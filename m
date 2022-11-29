Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B899E63C442
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 16:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236111AbiK2P5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 10:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbiK2P5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 10:57:06 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2063.outbound.protection.outlook.com [40.107.20.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA5F31DCC;
        Tue, 29 Nov 2022 07:57:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lGmK8y+uyw8226zyrMGHJWYXsn6a2QZky0TSIKV73wqPFTY3uvDyEyKaKCI3dHxkuVXYSX6vIpZjcyehfX+Mp30liO4IrG9YjOxr3XBtL4u7PEkiMZpe5yYF5JVMEFfQFw706p3EaEUFWa1GBwvTT1FpAQUjAZh3usjkuY0IFELecK27lW5Av1DB8QC/J0xVVIqHHkCS2NA9vrPsd48+gMUO7uGb0yr08fC3A7CW67gpNgh/KMWWIxgPiItPVtNgjn9ewZcTZZ55X/OIMowNyx5w/XwCxFxYxPU4xWhds75lmx6lMXaV83MWAzvELmr/THpV0ml2/EGIdSIIaeswKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O898Wb9LawqVHc3YA5uePpwOTlEvyyvVdK7xUXf59L4=;
 b=V2br4K6ELI9Oknh+Cmc/hhteERKADDH2Zft+cxwagZfTbGadtxpBHZyWPDG/hRKTLoXXKCWWWuJfiw+mCrsDVNOYN8jgbSyXOafjM1W8QNwrPun/gsipr/zgCVNevJ9EJv0vvG+cBoQ95vUYXHZSyryF9E1Z65nBzZ7Fozbk+7ZrCL54/yLJZlxs4qA1/1GeO3C/fjnIu6yI39uu0R6ib/hTGjE6G8LC+gKNsc+j5LOBxkdJsHEMEhrJH3jGHBAIUDLJkJ/59SBjnggk+lI+5ylP+MvU3LYuTcwfGrRaRN/cctPlomdto7q/Kiy/QuNUGF8rNDGo344QstQ//du0ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O898Wb9LawqVHc3YA5uePpwOTlEvyyvVdK7xUXf59L4=;
 b=Y5sgimm4jbjnm7wBulj7ItKGS4N8hgVpRJqPxrAhGcMtTFkniw4T4ZKVk63bUu0yg+dEMhUzWuJkSh4E2fkwO0TxhaAY43XdLZeJYp8vxjUPu6DvQ90HcU72NyM9LbwXpFJZHffA3Y0Itd/a074MGQLcDvTBRiRrnu1Z8HSncqWt/q4l2DRQVsmVNqqcSVuK1S5p4LB8z3vDk8SKcugSkK6YNhLrps5ZI+FgbEJyRLHP6EKU1/8MbPYtwdUkqLpqStzjojwTTWdH7YukUPqCB37Au1He98HrWdBE4KqGIPgbAxA3dj2uY3gfLkel1rTmGyBJv0W/QLOXRI0O6XWAZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS8PR03MB7287.eurprd03.prod.outlook.com (2603:10a6:20b:2e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Tue, 29 Nov
 2022 15:57:02 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 15:57:02 +0000
Message-ID: <9d4db6a2-5d3f-1e2a-b60a-9a051a61b7da@seco.com>
Date:   Tue, 29 Nov 2022 10:56:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net v2 2/2] phy: aquantia: Determine rate adaptation
 support from registers
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20221128195409.100873-1-sean.anderson@seco.com>
 <20221128195409.100873-2-sean.anderson@seco.com>
 <Y4VCz2i+kkK0z+XY@shell.armlinux.org.uk>
 <b25b1d9b-35dd-a645-a5f4-05eb0dbc6039@seco.com>
 <Y4VVhwQqk2iwBzao@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <Y4VVhwQqk2iwBzao@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0065.prod.exchangelabs.com (2603:10b6:208:23f::34)
 To DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS8PR03MB7287:EE_
X-MS-Office365-Filtering-Correlation-Id: f5605de8-baa7-4d03-bcae-08dad22259cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NQYUoA50oHnydr1uYZ9Q/aDFS1HlURc8edmoJXKCeiZGrw1kyjRKFwdzLul4jr2JmKS994dhOF8nUYV/LlUXbjVmhSWcTvU46HQPEEj32fKnzcY8A23aGU4NNIFVoBX+7NTz5EO1scMKRbKrynVr9A93PcIjU4j7tZJaJ9ulytdhVMQv69pj27MnvsosLijMUYuRZx95+xKvjDQ5O0SFy0utNAejbHzY4iLE4Vtf1lXk5PNzkuJ5cnX4ToWoo8pyS8Yk/Cu+QevWlVXJtctr6KC7kqbe6O+hUrra0582r8b+wwckIhOXNTH1E8pkAyGK7QcwXwOztr+szWKMHzqoXooGQsb/3XHthufnaR1tZcrN9GHTHJrpYvAHyoVH/X0VtdgV9ePBvlcxW5Uc+orIalzdCe6DtVjqBfXmuJbqfb/kMxojQh4881Fs49Ws85ZMSVAQlGSddBpz7YGIsN/PLXdKFGLH77DKW8Ahxupjmax0/1S4IYcCYehWDWcP+JKB3/DhEJ/P+7VScdDnwM/nxXI1A6iUm1AMxqfs0/IDnKg/bmEQl9b23aiw0w2aHhz58xVG116ljiz0mTOjDz+yoo4+vuAEI+bWF8OrnLDup02tAB3mIyGqaEIpnMunY4L2Cvk9f5zglLhJ1mOUw63Baucse2TCJ7dc+AJrBttBsz8SVW0MXzJ+IBUpjdvOda2M6Fjz9UuOh8U0AEyjsql6MtY1l/F8GKl/9Hmi56jm0R0V/dXwa2jIAjITb2IFLFKQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(376002)(346002)(366004)(136003)(396003)(451199015)(31686004)(36756003)(86362001)(31696002)(478600001)(6666004)(6486002)(7416002)(2906002)(186003)(6512007)(38350700002)(83380400001)(44832011)(66946007)(38100700002)(41300700001)(4326008)(53546011)(8676002)(66476007)(2616005)(6506007)(52116002)(6916009)(8936002)(26005)(316002)(66556008)(5660300002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDZvd3Zqb0xzSUJnTkFlWUlEYjlVY2U5T0FKK3g4ZElJbWRLMEVpSXNyM2Zj?=
 =?utf-8?B?WEV0YlBBbWNXOGp2V1ZtU1ZRSG96eEpaV2JhMThzeS9OYnU4UlR4TzJ6cEhN?=
 =?utf-8?B?SnZ0OWxJeENmWW5MUVFBM0lVV3c0eHJQVEtjZm83VUN2RXhqalplUDl4dGVm?=
 =?utf-8?B?Y1lEV0V2SUdSaDgzSFdSZlR6Z0RsNklzb3RIdFhRZGRXcXNNVXV5emZyRVJH?=
 =?utf-8?B?alN4Q0hPMWNqRFFQS1V0dHNmZzJyVGprWHpNVEZ6aG9ueis5ZU5OQkVkZkg0?=
 =?utf-8?B?UmJSeGFlWEJWN05hdjFpN2RDYmNnZmlnd3EvMWRiVEtVQ0hnTFNlNWJNLzdQ?=
 =?utf-8?B?MnFrelk3Zkh6NHNPWFlBbzA1M0VsTmNMSStOclgwSk10NXlZMWRvNDJtekRN?=
 =?utf-8?B?d05TcEJVTk5oNHh0azRqeHloNUxZWnZZQmtpYVRPRHNWTDRoLzg0Z3Y3N0lW?=
 =?utf-8?B?YXp5L2NMSDJUbVdiQVFLMVRHcUxjTlhkVFd4UGFOZGpwbURkeSs1cFVyVi9i?=
 =?utf-8?B?UHVGaVBXT0JTdkJBdnBPZjE2R2ZGYVFDY2pzSUlvMmlORVg4ckpoMDVRbEhE?=
 =?utf-8?B?QlNzOXlrQVdvaitPaHV1b2ZsKzVjYjVHUFowUERYU0RVVUxBeURlcURwVWFa?=
 =?utf-8?B?a1l5YktYRjlJajcwUXpyQXNGY0J5SU12TjIrdkFjUmEwN1NJTVRYL2d2Z3dN?=
 =?utf-8?B?RjNSNnJrRk5yeFF0V1QyR1NsY09VK0tMMlN0dXNkLzJDenpnZWhFK0QxTnVn?=
 =?utf-8?B?L0VYUkRxUmhKZ0tJTFFBSUFUVEJmWGlQbHhDWVVVV1JZbThXSTV6bzFYMXYx?=
 =?utf-8?B?MUhGNldqQlZLeEVURXdtUlNySTBNSFNUdDlDYWlCRUZrS21yZ1BMV0hobUxD?=
 =?utf-8?B?VTZWenZxTEVVV3RLY2daUUpORm8zS2dVb3U0R0EzSXZpQWI2Ni9kUnJERmNC?=
 =?utf-8?B?TjhUV1VIL01UOFExUkZqNWZ6dWtRUGhxNmprZ1R3RzdMRjJvRzN4M3dnRVMy?=
 =?utf-8?B?Q1UyZ2duYW03OEhPTUtvQ0sxUHJhVEdJZnlFemJmaDZoVVR1SzhBQzl1RFFj?=
 =?utf-8?B?SnE0WGd2ZDVKc1JGQlZJVDlYRXRqcUphOHBMd1dralJ5UzVZYS96Y3grUVVT?=
 =?utf-8?B?S2N4N3pVWGhlRlpFZElFdDB6M1NTMG5JaHpYOU9PTDUyaXB3L3Vvc24zeXor?=
 =?utf-8?B?OGtRNzNHTmZNRzgyN3JQMWh2YlpGb3FwaWsyT3U3djJyeDc0MVVkTUxDTUxZ?=
 =?utf-8?B?ZUtNMGw5UVBGNHEySmhpN1BFVit6Zjl1NkVMZ2tkTS96VVhCRWViR2xqSSsx?=
 =?utf-8?B?akhSaTVQNHljOGF2S3hHZ0p3MGx3RWM0Nm1YN3lkdUFGUWtBNkwycEJjSEtp?=
 =?utf-8?B?Ukx4U0pITlFtcmNIWlJSSVVlRXpZbHpvaUY3MWhDc3RYQU5YSFNsM1BkTVRV?=
 =?utf-8?B?UkNxL2ZMODVGWFZCRHBOMlJmemZtYWViUmRJTlV5c2lvREsxNUdueHlLUEZ4?=
 =?utf-8?B?aW00b09SMGJPaytrZ1lCSnE5WURvRzJSOVZxZTVvbHVJWGt6aURrcUhRWDZP?=
 =?utf-8?B?VVFGZTdDSHIvY2I2MG55eGw0b0VxMittdUo4NXJOLzQ4b0VuZW1qUmNxcnJC?=
 =?utf-8?B?ZTNMNXNxSlZ6WjNTMzNFd1Q0ZTJ6RnE2RDJSZTJtdkx1UjRudnl0eEZ4RkJK?=
 =?utf-8?B?eER4NThrUTgweUpwSUVKaEN5U0k5aVkyY1E4QU94b0J2eU5DenAyRGoxQTZy?=
 =?utf-8?B?ZmoyTWh1c1haWk9zKzR6UXZrWUw0dGNFdVhGUFpaY1pzcTZmelZ1NVJ5U05j?=
 =?utf-8?B?QWZPZVVUdUlDZUl3WGVXYVg5R2NXRWQzQVVoVVlvTEwxaXJtNE1hUXVwSjlt?=
 =?utf-8?B?SE1JOHpPc2ZWSng1SDFKK1FpZERTc1UrL2NDa2pxeDhvbmt1ekRpU2VQTnpP?=
 =?utf-8?B?T2pKb3kva3IwbzVPK1JYcEVqazBkcG9mTlRKbzg0Sk9lRzE0bXBaQmpGaklT?=
 =?utf-8?B?a1FRcXZPLzhIcXdvaGp2STYyajQxRlV5djRTL1ROTHM3ZVdHUjNPTGNuLzE5?=
 =?utf-8?B?ekFNMHZ1RVhxMVFXTmJxUmVBczlMemtCdHQyMkxlUkNuNzhQbVlWRk1RWW5R?=
 =?utf-8?B?aWxGWTE1SXpyTG8rN2pUZ3dJcnR0a1R0K244TElOdnVyck9ZT0FFTm9XdUFr?=
 =?utf-8?B?c0E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5605de8-baa7-4d03-bcae-08dad22259cb
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 15:57:01.9840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z11bLtaDkwSY0MZg2vfTDkjQR93JA07TBApNxvm3MF1Dv1Z5ElBYTzoTitPDokFJx6FDeY/t6AM7WArl+u9nMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7287
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/22 19:42, Russell King (Oracle) wrote:
> On Mon, Nov 28, 2022 at 07:21:56PM -0500, Sean Anderson wrote:
>> On 11/28/22 18:22, Russell King (Oracle) wrote:
>> > This doesn't make any sense. priv->supported_speeds is the set of speeds
>> > read from the PMAPMD. The only bits that are valid for this are the
>> > MDIO_PMA_SPEED_* definitions, but teh above switch makes use of the
>> > MDIO_PCS_SPEED_* definitions. To see why this is wrong, look at these
>> > two definitions:
>> > 
>> > #define MDIO_PMA_SPEED_10               0x0040  /* 10M capable */
>> > #define MDIO_PCS_SPEED_2_5G             0x0040  /* 2.5G capable */
>> > 
>> > Note that they are the same value, yet above, you're testing for bit 6
>> > being clear effectively for both 10M and 2.5G speeds. I suspect this
>> > is *not* what you want.
>> > 
>> > MDIO_PMA_SPEED_* are only valid for the PMAPMD MMD (MMD 1).
>> > MDIO_PCS_SPEED_* are only valid for the PCS MMD (MMD 3).
>> 
>> Ugh. I almost noticed this from the register naming...
>> 
>> Part of the problem is that all the defines are right next to each other
>> with no indication of what you just described.
> 
> That's because they all refer to the speed register which is at the same
> address, but for some reason the 802.3 committees decided to make the
> register bits mean different things depending on the MMD. That's why the
> definition states the MMD name in it.

Well, then it's really a different register per MMD (and therefore the
definitions should be better separated). Grouping them together implies
that they share bits, when they do not (except for the 10G bit).

> This is true of all definitions in mdio.h - the naming convention is of
> the format "MDIO_mmd_register_bit" where the bit is specific to a MMD,
> or "MDIO_register_bit" where it is non-specific (e.g. the status
> register 1 link status bit.)
> 
>> Anyway, what I want are the PCS/PMA speeds from the 2018 revision, which
>> this phy seems to follow.
> 
> I think we should add further entries for the PMA/PMD speed register.
> For example, 2.5G is bit 13 and 5G is bit 14. (vs bits 6 and 7 for the
> PCS MMD version of the speed register.)
> 

Yes. I will do this for v3.

--Sean
