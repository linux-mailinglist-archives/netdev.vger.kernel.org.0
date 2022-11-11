Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCFF626343
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 21:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbiKKU5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 15:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiKKU5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 15:57:31 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2046.outbound.protection.outlook.com [40.107.249.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3491054F
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 12:57:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guxjx6RcilH9RbtzyW1D7bVkSrpXpIdSGqxUn79X/pytn9HS59Voc4vDMAomvgCna30qKKdRoSex5bpHr59MdUHrv3FzD53I/Nvn6AxgoKP5naKix+Is/Zs6MlA7Z4i+bUmFJszZ/vunCPW+NInTlFTuMVqjv202rgnbxeLQP+Sg5K4eprJSW/uZvZIdHde6BERjNocsB3g3pqBpH8R9IkgtXOV+wYhHN19oKkMjol7k76tJ5ScAM5sPh/TUcaD9JhlxDgJSeXqeUWX8b6Bm5EA5TprDEXM3uLmxLyI9gWJHqhHb6ClznG0K4Uqj+UFmEH8+qz15cIbobGaadFW1pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VPCfneLYAQCD9fkMoeJo9wuOo4KaZDUycawtJYFWHnE=;
 b=AbFGfMBJoVlMWuOY0iN8d5wPZK/HFFycvvozUz7/CSe3sm+4ogyLAAUNWNvnppIdJqbVGMzItJy2VUhjy/VN2sBnAit/gYLytFjvqUiBMXhprBsbVQPpmJy7HvUXtO3/7pbjZrgXN5wyFZdwWp5LhSCfTaNR8INtUmUlAGliZbenBx7PfDKVWjqWpKnM496DINi13OSVUQN9O2oD2ka6L0yBJF0H1nxqSCyJce632J8U4tmUztaUneYf8dsRmYWZk6guBUBlRmt71eaOS5ZZNrcXO2Y1RDdwXKHmqaJj6SbSpDjAUVqcjOZhiw+2i8Xv3/Q+lUVRi8MU0NhJjFlzlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPCfneLYAQCD9fkMoeJo9wuOo4KaZDUycawtJYFWHnE=;
 b=kMi6GrpM/Gg4IqhjdeodPXNdvQ0ZBozjzjxpaJalD5AZpsfGjPnufWQCobMgWQ8QdKBzUYRo9nebFmiTc3ECqStDTKqm6wTclTfL6fkQjJkmurTOYP0CbAtDgenwXwlp5de6LJNFmmZTulq+/KvT6P2cOqd2+xzRkoIKeWNnSiDdOw+zIzXuZ/lSXQT7j4A4JeHH6aiapg6LN/2Tc07AaN1PjV4CfjzmxQWOKvJdjB40Y2nHieCrFkzL/SzoMQkhOMp+i+by0PpUpMNrzGL9spis3sPUw2HSRRFCMZ+4tBM+3gkdXQz+42RNkatVEYnFrQXpJVydLzZpSmXVMK+YYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB8PR03MB6140.eurprd03.prod.outlook.com (2603:10a6:10:135::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 20:57:26 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 20:57:26 +0000
Message-ID: <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com>
Date:   Fri, 11 Nov 2022 15:57:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: status of rate adaptation
Content-Language: en-US
To:     Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0053.namprd16.prod.outlook.com
 (2603:10b6:208:234::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|DB8PR03MB6140:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a20cb38-3906-4e87-aeee-08dac42756a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PRtoCZ5X949UP2QFGHe0mZGAk53DTO7oS5u+rdAIzFQHP2s5RF9fz5JzX9IoHMfcpp1wnSd8JKQb9VdMAlk634OcQ6iWjSior9zcejouRGw9mEjM/+YpFzlAxQ3v04waq8MLZs3asZ/xXZT3zBj2xsESXTQTw1ZdLsfC8nbwEkJjYftVREtjeLqCJU4R7KRhl+w61p3n6NjhFaaaAjO+MKmSrOxf9vd04zgs9tu2ZEzb7C8ZvLo0PO+kxBhUq4gmU++zMh6LcdEg3OCyBunv4QCr9xUUSk0uOC4MeW0w/A9SV193ojWAYb6pvmDsSG+tStBmz8FNPnytP8fG0vIVVLkBb8md8gCa4GpNCAy0L8D/81AUWTWPgH3nIq8Ot7pPdTZDFV93AnwjbmIrt1XtoF1Pjay4btqb5kCxG6k2tP/ZXfPNFaNp9pq+VwklkmsNT1AXeDJjzqoav2zI0doTtBmUJ0MkuR8DrgEJYq1Q8BDpMvOeUYQ0RK2srYP6zOyO1JRH1n8LeBzzTHrULqeotVhtxBTXCzXB49OojK+vQoIpgJoR1F/GNbIyNQnYkyy4DSfFCjKqUo4ZDH04J+Ail4YpxO3NrxDD9wKHM124L8v0y/eGPbcJ3xqudgUjdSMJu0CjtSUfsxdX0kfuGsooWK+/gz1bg9OR/YCtz+fOc8eOIpjxL4RnQCaELmyWkT8sXJKjRtOc6vKgwcWdpg8+PQiKpkgX1HW/bYbyRaQQvqXxt1YJfRj0X3e79tuxUeJ2VWu3mrq/Sd2vjRSyEE1SSyl+HP0gUMgk4TfHy5+UAcF4aYsgtkqd3XYzdo6k12Ax
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(136003)(39850400004)(346002)(451199015)(2906002)(31686004)(66946007)(41300700001)(83380400001)(38100700002)(8676002)(66556008)(66476007)(38350700002)(8936002)(316002)(31696002)(86362001)(4744005)(44832011)(5660300002)(36756003)(26005)(6506007)(2616005)(110136005)(52116002)(6512007)(6666004)(53546011)(3480700007)(186003)(6486002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDZ5Ym1lV3VXZFJvMUdsdEd6OUhOaitSNUhEN3lUS21udWJRWmVMZmJjc3NM?=
 =?utf-8?B?WE9JRmdPZGpFN1FGN0hkWkJQN1RpZ24rTHRrUlBqM0dTOFF6MkdXcGVyM0M3?=
 =?utf-8?B?em9abG5EQnZSMUFCRVpzc1JwcWRYVVBETjArUVJ5TjI1UzduZW1Edk5OOXpB?=
 =?utf-8?B?NER3OXdhcjRiRStTT1pQMkY3eFdYeWxTUFpjTndOaTE3b284eEhUbTFYU3pV?=
 =?utf-8?B?aVV4anFMS0RwMUdMZ0p1WWx0QkxBZzhabjVuV2drSk05S3RrWGRKSThKMlo2?=
 =?utf-8?B?NU5SenhGWDNYMU42dExlSzg3MU1NWVMyb2ZTWk50ZFo0eksrV21tOVo3Ykh5?=
 =?utf-8?B?Ly8rbnV0WTJXKy9QU01Sd1FuUnJTclBWQlFDNmtzMVg5NUVVQWwrbWMvZU5M?=
 =?utf-8?B?Wnl4Ti9oUzZLNDdiQnUwbE0ySm0xd25Cd090MlRiRWJaRXc5d3RFUjdaUE1M?=
 =?utf-8?B?OUNNdldEZzJDMW9GRklzajJyN1N2NUljMlBBWStkWjBXY25FUDNsZVlIQ1JG?=
 =?utf-8?B?bzZpZVNLdTAraEtUU0c2ek9VN29GZ1hVMTd5R1B6VndnR1hTUTQzdHo0ZzJK?=
 =?utf-8?B?N1hOSnIrVnIyNmxIeTZYYU1RaU1zYXFjZ01hdWovUEJSZWxWbGJlQXRDUlZY?=
 =?utf-8?B?Y0g4N1NuU0Iwek9IZlJ3MENTM0IyZFVNWjFTVlJKY0UzMWxWTS90aFZ0YzUw?=
 =?utf-8?B?Z0JaRjhrQ2J3MXk4NmtUM2U3bjM0S1RiWXJTMVNDUDBDUlh5eFZDTTZWQlBS?=
 =?utf-8?B?b3FhelpZRUkxaFcwaExKSDJzSWVQY01UdTJaRzB5bkN3eitWOHVwTVlTT0d5?=
 =?utf-8?B?bGpZQjNqdTJCWTdoSk9qVC94L3FucUR2WmRGK0VDK1ltcEw1ckJhTVdyYU5J?=
 =?utf-8?B?NFg0VXBUU0tDUmxpcUlTMEUvZFd6WUFLUlA5cEk1c3NCNWVJelcvVEVTcmkx?=
 =?utf-8?B?b0VKVlBWNDZjMFNETXdqUFlqdDMrQzM4YUJRVnYxeUJsZzBVbHpBQm1OOEtG?=
 =?utf-8?B?T0R4dndWWVZJcEFSYmN4THhyME1BcUdma01mYytzTG9QK0R0QXNSb09OUFJI?=
 =?utf-8?B?ZzM5Nmt3Y0h6STJseUZDZnEvM01keHNMQnNsTDdCUE1vbHdIQmQxQ1UwMHN2?=
 =?utf-8?B?T3dFQ29zd0N2RFNoRTkyTFVXSGxqS25QVVU5N2ZKcDJqdmpEOUlEc3J1Z3di?=
 =?utf-8?B?VFgrTkxnWVFWRGJxTmRxWGlJZXRzSWtXR3FxeVNyT3JJajdPYk9RNzFhTGFa?=
 =?utf-8?B?WXo2bHlOVHdML0JBd1I5K2FyR0txbDVqc1BiR2JoRi9LWGIxYWFRK1R1OXZv?=
 =?utf-8?B?bXkyMkRhdmkyU2luQXYvUGUrbUpJMTdCK09RVjNBaTdMSUFaYTMwQkFFT0s4?=
 =?utf-8?B?ZXNLTHpUMmVrZUY3V0VtUFoxNWRURkpkWnRlOXRwVkVHZ2Z0UEVuR0pqYnpa?=
 =?utf-8?B?V24zS3Vwam1LdUg1ZGRiYVBKMmVZbjJHZmhSTGdmYlJHWEdkWE1vVkNZYkN1?=
 =?utf-8?B?NGo0bDJuUVlpZUp6S2ZIcm5LTVRXb2w2RlVqWUYvcTloWHRacGFpamZDajA0?=
 =?utf-8?B?eGU0SDZxZmFxT1JxOFU2akd2U3hiQURMK04xNDV5emVCNHpkblRtSUxNeFVH?=
 =?utf-8?B?NWVKVnhESzdzbmtJNXlGWEdiUWxqZkh2VlYvNWI0UU4zQnN2U0o3dFRMODhN?=
 =?utf-8?B?dlpzN21RQ05GRXRWZXVuWXNiQnBDOFJKTWtFTmJWZDJ3WUNqaW4vWll6OGEy?=
 =?utf-8?B?cTZYS0l2MWtBbGZ5S3lXWks5NkVxZkluaEtlemNZbU03RTJEVFVISzBOR1F4?=
 =?utf-8?B?cmV5QWRJcFU3YzQ3Rk9zb2hubWpPZXlkNEtsckFWdzdxQXZqZnNtRGM3K2Uy?=
 =?utf-8?B?d3hSSnBPU21Gdk5FT1RNcVpyNEJaOUNWaTR4ZXJnN1Y5bWNWN1FJbHZQVFFV?=
 =?utf-8?B?TUNPbFNsM0NkRFRzWUxBTTFOV0ZZNEpoNVFwZ0NxcCs0K29rVlNNWERvT2hr?=
 =?utf-8?B?ZnVDQ2s0NGRjMFk1ekFGWGJ1dXZCeUlPQ0M0Y3JsZUhMSUd6UkxVV2VKNERu?=
 =?utf-8?B?ODBVOXMzMGV6NHlPcTlnSnNJOVl0N2t5SkYrRm1Tcnd4NTh5clVoS1RJWnJU?=
 =?utf-8?B?WCtYalZwKzI3NjBjazNDK1FYQUdRdzdWZnUyKzZucWFSeGoybnlVYkpCbDBN?=
 =?utf-8?B?c0E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a20cb38-3906-4e87-aeee-08dac42756a2
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 20:57:26.4648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u9XtyL2boaoT8bjtLHtoVCyIBBuUIEpuU7anC4mkteeDGWbM7cHL2/TnO9BTf+GBwpKvXGCgTgyO7X5EpG5Qyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6140
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tim,

On 11/11/22 15:44, Tim Harvey wrote:
> Greetings,
> 
> I've noticed some recent commits that appear to add rate adaptation support:
> 3c42563b3041 net: phy: aquantia: Add support for rate matching
> 7de26bf144f6 net: phy: aquantia: Add some additional phy interfaces
> b7e9294885b6 net: phylink: Adjust advertisement based on rate matching
> ae0e4bb2a0e0 net: phylink: Adjust link settings based on rate matching
> 0c3e10cb4423 net: phy: Add support for rate matching
> 
> I have a board with an AQR113C PHY over XFI that functions properly at
> 10Gbe links but still not at 1Gbe,2.5Gbe,5.0Gbe,100M with v6.1-rc4
> 
> Should I expect this to work now at those lower rates

Yes.

> and if so what kind of debug information or testing can I provide?

Please send

- Your test procedure (how do you select 1G?)
- Device tree node for the interface
- Output of ethtool (on both ends if possible).
- Kernel logs with debug enabled for drivers/phylink.c

That should be enough to get us started.

--Sean
