Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E3065F398
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbjAESSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjAESR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:17:58 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2080.outbound.protection.outlook.com [40.107.8.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326D413DCF;
        Thu,  5 Jan 2023 10:17:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iK3Ig0TwIx4Eq3Ndz/woWrYRfy2fZLiODi8/F0F3afdTcy7C+hbPfbjX05flByIrQeMBGpoht+8gLDHnGocgl8PnyCPvh8Mf2wWQG7V+knUllY5goIr1kwdRtlBKhQu0d2rTYQMI8AKS56hmMaLyEc69PuD6rDka5rt84njxr5N2h/cY5jkFKuRLv6fdx3/kFgArlir981dbA9mhd8SNmdzn7uIy/6athdFOgzu08hu6UDCb2j+O9eTS7FEescfeyqEPMgNokngFYdYV/tKYGblBl8zfmAuYEs/yVWdFs2XOp3UxxIR/n2XJRXSlBqVZ8L33qC4YH/oz2uJJpNbdUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3dWiHzHgn5E3TOK2RRpIo9YK8qVjpOuA9DnEky/7Wco=;
 b=Uxl5QMbkgL6o8YEXOZpDwhx5KmF6s+hqEnY3iXr5ZJ+HgbcnE++X+doeAClnvCS2040zy3gbLnVHeIIYQ1oQ4d+DUQ6ZGYkF8BoXsqrAm8zWO2vMNMLO1ceCRsnw0XOsqzud0fc3zba9f38IRTE+JzOowUYCxTdPkO5QPsS5coCzQ8TvqceXzow/daYzfu2GOm3Zrqv10XLX3nJOiaXXgAU9t77OKQcjg29v4A1iDFJzzak5MxauF5LZBUuZXCelm+fcDqkFGduqg04iO9iLg37Ai3ldB+cs9gzbL8/K/igJoQXVufhzi03eIiLPHrdXC+Nv9HmOzdoOKrjIKHUzuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3dWiHzHgn5E3TOK2RRpIo9YK8qVjpOuA9DnEky/7Wco=;
 b=KeHUNuoe9kcFBK/bNoBwwGvYwV70qXjNaja7O84wWoeV66penM7cAEkTBaYjHxoLg/KTiyxdaRFvztYtC6JNrQr53Z1dt4yQNmJgzshoqWdM0B6OQIWknCSVcKih81IZRc/cSW0ti3ilmNJth2dR/HsCYD8HDoDqwzbkvZGdXGhJlGdKjqLgdeT9LHfVsGNRXafh9m3E/nsDExHQREb1DGasOBEs2/VMiVzCk/YNziDyrRI64icKeFrKNLO8V1oYoHqkMmq1w2piXisfxfZwLbQC/Rx6dpLfgNX72BiFZ2oPzByfNW25146weUTBvd3miGdmMVATV/WlB4ujY9RB7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PAXPR03MB7699.eurprd03.prod.outlook.com (2603:10a6:102:205::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 18:17:53 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 18:17:53 +0000
Message-ID: <3cab152b-ce5a-70c6-a8cf-8537faff5ab8@seco.com>
Date:   Thu, 5 Jan 2023 13:17:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
 <3919acb9-04bb-0ca0-07b9-45e96c4dad10@seco.com>
 <20230105175206.h3nmvccnzml2xa5d@skbuf>
 <20230105175542.ozqn67o3qmadnaph@skbuf>
 <39660d10-69b9-fa52-5a49-67d5f7e1acaf@seco.com>
 <20230105181152.ruzdv3iusvan4mek@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230105181152.ruzdv3iusvan4mek@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR12CA0023.namprd12.prod.outlook.com
 (2603:10b6:208:a8::36) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PAXPR03MB7699:EE_
X-MS-Office365-Filtering-Correlation-Id: 878c9733-6add-41d2-494e-08daef492924
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +VzlDGxsnBKM1H9qjLZMFLzRYUn660X3w3pfuDEnLeVrhqj3XhcIu9MDOcBv3xus2/30aUoSS8XQBQ3ZYilD1bQXYRrA/ENPem7UyyPlMRdwe7SVZzApkPP+QsIM753L5lqpdGNmfc3qi0Yos/grEc3H8BlC1La28bbGYaPdbVu+tagIP/hNdrS7Tpq+PRrSnybXlOXbYa1tXxxYPc2nSt7MoOLgbGE2/Uloc4i5JRxbbdreu2U+rPQDkZeY2agPtiIG3csc0fWqg3fI+apsYcMyp72RSLnRD6sNu7aY0ohGBxhnSDUOW0IinQ0rMqVS5zgl9YwYMILIO1xs9IyvD6oQtaJ+Ix0OLjDejYrVc29r41qK5ok5yTHx/xXRh0rilk2yBeN5aAQvv6AV8b6e5aXgvP4AL2mNqZWLZRrxdGeyMRjLOjEoLgJmt1bhI17Ljg47BbJIODOBPFgATKz8H1Rsz6QHgtmrA9OUPZuilQgHZdCFBNsvlvlLcP4mC7XU1sA+cYGpS8ZVjxxCG2vOIqkvT9FwdI2t30qFTHQkclr+Gf4wF3ecMq55GVBwosKzK6M1y+/sDYwITtkiEiQ5ALbzjsoDiZoHCy6Vlv8IRfhDgjo+WQETP7hvxFsdFcTJkmcwpWQJgvN1qptE7CnJm1+gJNvHYNc0m71sIUcINUhZblTyH+Qlt1KkOuqKc25yJPOpM5LacOLnAKM45gi/08ZR7pYbUgYeZB/x466qeA/Htlu+O7oiQJVzKYdMcjrrcfZE8+8r/bpgNbgsd6Emlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39850400004)(376002)(396003)(136003)(346002)(451199015)(86362001)(31696002)(6666004)(53546011)(6486002)(26005)(41300700001)(38100700002)(38350700002)(52116002)(6512007)(186003)(6506007)(478600001)(4744005)(7416002)(8936002)(5660300002)(66476007)(66556008)(8676002)(2906002)(66946007)(4326008)(2616005)(44832011)(31686004)(6916009)(316002)(54906003)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OU5tOFdnUU9YS3NmcXVXL0k3QTIzczR5QnpNVk9VNnZFNUxLakxTYmcwT3dj?=
 =?utf-8?B?dlgrOER1SWxTNmsxdHhHbVJ0RWJXS0FTOGYxZ2h2cGQ5ZnhIb1dhNkFPemJD?=
 =?utf-8?B?ZkMvblJGL3hGYzhOWlphTHVUc1ZCWWFDOWg1bkZPTmtGMUUyY3paYTIwQWlk?=
 =?utf-8?B?Wm9LMWg0S1lmdWVYUWM3T1hPanphL0cyT3pqdjlyalNBTGhkOEpod3cxZFky?=
 =?utf-8?B?bUZNaXRoSExBempZNHBYVVk0SnVvUmJMVmo4azVkS0N3NW1nUkdOTjlsempn?=
 =?utf-8?B?TnFmYTZoeGtEU2pRZldaYlcrWWlWMERxbnhjeHlLWlhpRHJUaFpMb3dyenhE?=
 =?utf-8?B?blFGdXJmNzNNenB4elFzL0NUdDFyeGdid0ZBMnVzdjFQQW9DNU8xQnBCSC8z?=
 =?utf-8?B?ZUNsSTFpU3c0MXhuY251TUV2OFVzaUo0SnA3WHRwMFRHOUVqODU4OWx4ZTR0?=
 =?utf-8?B?Z0U5WkVtODVWT2x4T0FUTWwwaWUyVDRvZmVXa08ra2VVYTZZVTRuMVlubU04?=
 =?utf-8?B?VHBLbnIxVUorL0hGTnNQTkNiWTdnTzVDVFJRcDM4R00yNUsvUU5QYlhJWHBN?=
 =?utf-8?B?VmNIY1JHWStwNXN5WUUwOWlnMTExaGNBdVNCVWYxU3gyZ2pWcG5QbVVRbHo1?=
 =?utf-8?B?bUN5SkNOczVhUDhZUUpEbVZJUEc0MWtRb1N6c21qVU1RVWpaUHlMWWVtYU1M?=
 =?utf-8?B?aWJRK2RwMklOYlh5dHJZY2wvaHZlZTh1L3hTb2pVZDFOQVVjbzdxbE5sMjNx?=
 =?utf-8?B?SWVuK3pLTVhuWTUwMkJUMVJlQWxlT3g0aVhSSUxSMDl1YXNpbTIzT1FJcXBR?=
 =?utf-8?B?NkdyWHpPanVLZ056UlI2ejBiL1hkbUpnNWN6aGJxK0lLTFNtTm9BeUJGWDdL?=
 =?utf-8?B?VzMycDhvUENoM1gvb0FJZFJSNGoxdnAwNEJtWUI0OTZSZ0F1d09YT0NlL2ZJ?=
 =?utf-8?B?ME9BYzRyM0YveE1MZDRISnVzY05MRmJGaDJLbzFhT3JZa0FYMm5URkE4VnFZ?=
 =?utf-8?B?a1pWam84OXgyaEJhN0VtT3k5WTRZZnJWS2xZZFdRUmJhZUVaOExkRERKY1dL?=
 =?utf-8?B?dG5EOEszQm5mVVErd0tONHkxb0QxYXNWeGZHTjBqVTBkcXJpK252VGxZVWdi?=
 =?utf-8?B?ZjFQLzd1eXB5TzVrY0FEblVDT2xLZmZNQW84QjAyNlRCVlMyVFIvUHpXWFpj?=
 =?utf-8?B?RWxzbVErUyswbEVhY1pZVnE2dmJUM2lRSzN2VERqd3pCelFnRHdEWnJpSjI0?=
 =?utf-8?B?QmFaM1dPVm1EU2oyQnd3WFJVT1lWbGd3Rk83cjJPQmtXNDZvZC93MXpSNkRl?=
 =?utf-8?B?OFlJc09LaUhtTis3UFJielM3dmdJMlIxVnl2emlNMEFSbU52UEZNcXovYmYv?=
 =?utf-8?B?VlM3eGlEUW1pUmxJbkd6ZmNrcFpmS3dQL2VFUHRrRWsvN2JCT3MyN2ZnSGt5?=
 =?utf-8?B?ajNXZkVZcHRmb1dJdko0elZmZWFRYVl3T3k5ZTg1TTlpc2JVV0NEL2lMUVdt?=
 =?utf-8?B?ZTEvTXVZcjczWGFNSDVER2lXaWZvbnZLTnFNRk9SVTI3Ni9qbjVhTXcycDB2?=
 =?utf-8?B?WWJiUkFwdVlDa2NPWkQ3Yms0Q2VGeXhlVEZsaWZLZ0dTajVTRm02Tms3eWpG?=
 =?utf-8?B?Y09zM1ZrWlh4Y0FjMk5uNEp3QWZyQU80TGV5NjVhMTlzTW1Ec2xpUy9zVDB6?=
 =?utf-8?B?ekRmcHBXK2paWTQ4cC9GOXFaVHphaHdJT1F2YUhXWTUreWRQUS9zOExyc0JZ?=
 =?utf-8?B?RWVHckpCUC9rMTdrcDg3aDRjbDNueTYvUE1JcUphYzB4K2dOUGIwUmpWZHZM?=
 =?utf-8?B?Ui9qM0dvYTgrNUM1N2tvWENBRVJPdm8zbW0wZnJUUnp6T2RndUJRckV4NmNG?=
 =?utf-8?B?MDZRUXpSZXdidTBZQzNGTWZqbmFaVVQ0Mis5L3YxNy9GeUpHeUVXNk1tc3V4?=
 =?utf-8?B?Nm5qVGtSNWNsajU5SnpTU3NJTWtrSnQ3dVpiY09VcmVWeEVUOHM5OEJIK01T?=
 =?utf-8?B?L21ERTFKWlA1eTd2MmFhd1U3bmpURjJ3SHFIa2NEWElDdGVNU1JIcEhBTkcz?=
 =?utf-8?B?MFNKQ0M0V0dRWldCaWFKWXFOc2IzYStDR2FQRDBsWE9wYnRiaXFBckFXdUVC?=
 =?utf-8?B?VU1sQzh3Um5yN0psZTBVQmw0R3hvaTdJemZINVZoR0t0WnpKc0g4UHpUUHdZ?=
 =?utf-8?B?K3c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 878c9733-6add-41d2-494e-08daef492924
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 18:17:52.9803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k4MypROgAVjOQZAR4BXUH4Z4lSINy+VAD2O4Os6hfsxFaz56dCjMvH14PKvmieiQiPYLgSaH6v8Q4JivcZSlAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7699
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/23 13:11, Vladimir Oltean wrote:
> I think I would prefer not exporting anything rate adaptation related to
> user space, at least until things clean up a little and we're confident
> that we don't need to radically change how it works.

Currently, we have a rate adaptation field for get_ksettings, which
indicates whether rate adaptation is occurring. To really support the
above case, we'd probably want a way for userspace to express a
preference for e.g. rate-adapted 10M over "native" 10M. I agree that we
should hold off on this until we're more confident in the
implementation.

--Sean
