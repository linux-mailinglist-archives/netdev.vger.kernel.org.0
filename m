Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7B15F485B
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 19:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiJDR0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 13:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJDR0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 13:26:48 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2040.outbound.protection.outlook.com [40.107.21.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDB922B2B;
        Tue,  4 Oct 2022 10:26:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ly1dSco3EAqNvvNp3nxQW1Z1Xfjzv4GiWq5BCg1TcoFz5+adfsdtOJyls4MoWGQNe+WYCa0Ajr+krfno7Qmq2SiW0uPVuYf10hW5Kw6Yb0suZ3kVPTST60cR+I6a0akngPQgQcDAzyC/I7OM9HEMCEw4O3lyIiPrWFZFAyzcYXMIoVF86YAX2KmR5mXeuIm49nfc4AjYNWIa0xQk8qAV5hHzyaLvEMfCU6ef/aNb7qrQTC7wQuPJ+Yxh+/yTk7t+6LrISXCUyfToxzTxfYeEtyFlRHV8SaNsbr4SXOvT5CZUj+zBUhs+0Z5i8ip78DKX2ey3DlpByUENB9G3NyvEaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJSNABsyz6HetKHJs6v3G+u29BVyi/7ZyKsv6qRrqU0=;
 b=OjUFhseKrQwJOAA77DQMVAvy+HT1V9+iA5TRrf4DNI980hCq8K8AdTC+rO6tGOM9wrQLwLm4t9wAu0khHZL5llrKlylOLE9F8ED4iTvj2VAX/x5HqJQWboSsZsukS34EDe/ks4D7fs+/wFznx2/9ANQQiNL7M60toPXbqdc4cGB8ibEg33SnAPtTv4wMWs3X+zhaCixRqmDroch6rm4Qv3Nv9gbi75m9KcZZzDfaXfAx5zIEgKP+KdXci5rPb2DdlNZeuSsFAFNngQUs7i81TqbmRjru0ANoKCmnxk4i8DPmXkywgLStlf67ivdhqTuAMQOGssKqbWxjhibrWlMglw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJSNABsyz6HetKHJs6v3G+u29BVyi/7ZyKsv6qRrqU0=;
 b=wCnWhQ9UASP4ICdZYm6ZUjBxhma3r5GbNtD11AS8jAI7uJYai18Guhn8QYPK+nC/9s1m11yYl7HIXB4lOm23aZ8URw5AWqn5QgJx5jQL4iuH6A2jSFrKtGrtV1QaD+HoNo04OLShXBKKTg964fssUrL2vp+X4riTickohU0Sqa4mGIICOMlyhy3uYA6aRqpKs59h/758JTan6m77d1UwJqnl0q8UR1TJ9tCGZwZEHNGQzuWkYOE6HYMYCtUZMHOz3QlZkpglFQB1JEbc3EYRtuPDSPYZDACE/BhhJkeM84PVU80qnuhOYGVW88cDDf2PqHEnGrfS1YvaL/tfU8Hazg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB8273.eurprd03.prod.outlook.com (2603:10a6:102:23c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Tue, 4 Oct
 2022 17:26:43 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 17:26:43 +0000
Subject: Re: [PATCH net-next v6 0/9] [RFT] net: dpaa: Convert to phylink
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
References: <20220930200933.4111249-1-sean.anderson@seco.com>
 <0b47fd86-f775-e6ad-4e5f-e40479f2d301@seco.com>
 <20221004095245.1e9918bf@kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <bf6b58ed-a42f-9848-993f-e074779e8264@seco.com>
Date:   Tue, 4 Oct 2022 13:26:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20221004095245.1e9918bf@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:806:20::27) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAXPR03MB8273:EE_
X-MS-Office365-Filtering-Correlation-Id: 3104820d-3653-41e3-abd5-08daa62d9b43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gn5zobhnfM8s07aQxD8/t2cxPW9fzbDaAX3AsgXMiloeyNmwK5cGguL6ga6VcVEHu4CtYXgkXtelXsPjVoIlWGAqxeOrb5q5/I32gOg0TVyrwwWa3QRudZSdPngmtC73WOK0KuC+jTYIuRubaEEz0q3Dtw8OX6UIvitnGwynIsNDEjPCjIhUarWzWvKZvj+3yMLaycmE6/f/UarpEi42ntOHkTwddPCFvolJUAwqtwLc+Pa386j6GHGuF7i8NqOXcbude3wYNPYrfS6re+6Qik6Ku89BjimG1OFNFiDNJw8KJMfL5i39/kLXZ9kN9hN7mqLGT1K0QDacXm+L2egVXXtI1TwF0jYPwJgyJVDFq785JwpSTReag/5of9426yYHAuIsu0ZYbca9WgKX62IOfXqKF8jH8OtOIWbswSHscsYlsmTRGkFYCex6FGHqXxJVb+6VPUSPaJ7B5oGJLnj+aJnKD5HIjDHourbrU/VF/uiYsUEbpQ6hF1eyRw2ssDHM4tiqvVYWnBYtm87Mk3tff0BS8LdfHD0KxwMYMv1bWWOp3fEUc9bb1m16yQRwmsDdvvyIPu18gQq85ez9PcQJHb9FLKxM9zSorAKpBjbVdt5Ja1AoruTVZ5nKLyvKSFnArw2WCGYwT+kJPSbbj0YFZ+e9WBNqgU+sSHNoJO36cKJC4+AVveQW/xHkxVD2BIaaO5yF5EYK0+PzTYLIkRI1MS4BByf1wBrjff+RBs0b65qJL65OadwXVKAbZdRECvQDxr0r4TU4bZ+HVXzS0lNwyGmKXtdULkn7DN2iyP4q9iYjNnT/MEGjCXoTftUVNdiGMCweMBeYNJLf1iH5gHoqww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39850400004)(376002)(451199015)(2616005)(86362001)(31696002)(38350700002)(83380400001)(7416002)(38100700002)(41300700001)(186003)(5660300002)(44832011)(66946007)(6916009)(4326008)(2906002)(6506007)(6666004)(8936002)(26005)(52116002)(53546011)(66556008)(6512007)(66476007)(54906003)(316002)(8676002)(478600001)(6486002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlN3N2tkQVk2bkowVHFhRnQxblZLTzVaYTlCbGxRMFozWkkwNmo5OUtHekFl?=
 =?utf-8?B?TDQyR1NPYWdaZjdRWkFTWk1rNEpSTktOTkRvdU9ncHNNdHNZbjZkczhqSGs3?=
 =?utf-8?B?NWM0WDBLUTB0QmJLS0ZUYTlyVlhVb0wrOXhhZWZwZE5NQThvOHA0RTZsMG05?=
 =?utf-8?B?SXJaUjlWRlF3TUdydFJvZzFBZmQyZEZISEVtem53R0xDWUNRZWFFa2JYWVAx?=
 =?utf-8?B?TGprQy9CeXQ2bit4NWRQMHBCdmZIa2szdGZyWWc2Tm5ucUROVXRhRDNvSEhB?=
 =?utf-8?B?Q0NIV2R4T0RrRWdleU52bmpYZjF0aXM4YWJiT0h1bUdQaFZBdWo4dmlZWlZv?=
 =?utf-8?B?QlR1OUQxUjFqNVdnLzJSZVRCa3B2NllhS010NzcrME5CTFA4NnJzaHZKUWp2?=
 =?utf-8?B?QnBKZnVSMTU3TWI4dXhqa2hNUWx5dkVndkE3aDUzNTA2NFI0bldudHZRNGlm?=
 =?utf-8?B?YzlSbjhFdkFoR00yVVJ5eDEyamd5bzluSlRoSkZ3b3RHcXdUL29FM0pyMjZH?=
 =?utf-8?B?S2Nzdm1sb2pGYjRtTXFtYnJLdDd0U1Flc0ZWYmwvR1l1K0Q4Zi9Yd1doa1lh?=
 =?utf-8?B?dWpWNXRkQWpxR2RLeHpNQ3pITlVHQ0RpUlZmam82YlZSUTNCc0UwclRUdzRt?=
 =?utf-8?B?MnlIcUgySytuVTZXdnN2L2ozcytPSER6V1pYOVpTV28wQ3NqUFlLM2tya3dD?=
 =?utf-8?B?dGhYZktIbThYSGNtSG95dlExZ1dGZHhQNEUzRkthaTgwQnR2bzRFTndJSHJE?=
 =?utf-8?B?UlJTN3dqQmRrZ1JJK0hJdG9ZSkFsdVhDWGNEKzlLWE80YS9sd3ZqdG9lc2Yz?=
 =?utf-8?B?bHdVejJ6a3gvVWVDTmIvZE03OGVGaGc1SzhkSXpSSVFQbHNPMTZPQ0J4bWdw?=
 =?utf-8?B?MytxY3dKdWZtMjVqSlFQb3QxTllvOGVGUWxadlI1c0Q4Y2tLa3RVYm1JRGFR?=
 =?utf-8?B?T2hUNEd4Zk9sTDRsek9FZlJ0b01YMndXbzZQU3ZVQTVXQ2lucTFSb3BOSlR5?=
 =?utf-8?B?dHRXVHJTSDVZVE0reFFKYTFoeEJpUWp2WmRsRmFkN0NhcjJUa01GbHQ0endS?=
 =?utf-8?B?MVFlckFDbCtrUXZKL3VFREpYS2hqVzhKV1NDTlhzV3ZJdTg2RGFGWnd2dStC?=
 =?utf-8?B?NmNRT2NoRmRTZXk2a1VZazlXbFBYS1lCTVl5ZG5ZbERvclpmcEhEcGh1Z0xw?=
 =?utf-8?B?ekk4RTJULytLVVBmNzZSV0U1M1dibHh5SlIwM0RhYzE0NnRaaDhnbHVoaXB0?=
 =?utf-8?B?SFdmRjVZd2U0dk9oaThoMituYWZ0RW16clRMSTZ0SHpOOEsxaFhNNVk0VVdL?=
 =?utf-8?B?a05KNFZ6QVJyNkh6bCticW94OWl3am9NM3RFY1lONEZ3Y0lOQTlBdjRHTDZV?=
 =?utf-8?B?RS9vcm9VUWZFeWl4MzN1Z1Jud0p2TW9HbXV0UlZ6QkxGY3E5SU1oZHkxcndD?=
 =?utf-8?B?dlc3NkVaQUZKR3F2YkIzODg4b0p3eHZYRHhlSU1RS2xONnRIZmlnUUJxK0xx?=
 =?utf-8?B?bDBHRTk4dWhNdVBRcnl0aEZ5VDl6OENZTWsrek1iQWlMajhzL0NpdkkxQ1Nz?=
 =?utf-8?B?MHlFcTdLeXJXSjFwdm1iUnY5elRacUswdHVTcWJpckZkcFBRdWlPOFl2bnlK?=
 =?utf-8?B?b0lzMy94N3NkeDdrajVPVHlrNWtIb2hDZ2xvblI0cDNKT2NSQ2tKbFo1RXFj?=
 =?utf-8?B?STNDM3RrYi9pMzlqK0xSRE1TRHZhNm5WZHdsK1ovNW92MjBFeWJKTE1kNzV0?=
 =?utf-8?B?ZklRVVpVemtSdERJYXdPcmJMcVVBNUJudG9BR0VXTG9pUGRZQ2JVSmx0RjM5?=
 =?utf-8?B?ejBIWVNTKzZVckVudE84Sjh3SG5SVWxnZ0FPMDBZenFORWFXelVHekg1eHJS?=
 =?utf-8?B?d3ZzWUk4WjlOUjIvemZHVExUTXBURXdaSENSNWpUb3VJL3FDeFNQUTUxSWxj?=
 =?utf-8?B?Vm5WT0xoZ255aUJHcXdXbGdabmRnaXE4bC9vMmc1RHFiTDA0bGZ5VzZLRmdO?=
 =?utf-8?B?TUVic1RwZ1R4Wkl3SVdpczBqM25kL0JGUGdwZ3RrWVJoZXhZWG5QZEJia3FV?=
 =?utf-8?B?bkUwUkp6a2hVbDBWNVp2QnM5VkVnTnJaNWhMMHdhbzdnbzFqcVZUT1hFbG96?=
 =?utf-8?B?R3JERjM2SGJCVEJBak1XRmt0SEFCajJhbm5Ib05wR0w4MWVqQmRTTXZQNUpp?=
 =?utf-8?B?S3c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3104820d-3653-41e3-abd5-08daa62d9b43
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 17:26:43.6707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rAe1rSMw2LZqdq5D+/3jOLlKawv49VQCWQDQTsLQ2aocye4TXPvbRcS5MXLRNV2/5CE9WHNd0pWTc6mW1vbnww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB8273
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/22 12:52 PM, Jakub Kicinski wrote:
> On Tue, 4 Oct 2022 11:28:19 -0400 Sean Anderson wrote:
>> I noticed that this series was marked "RFC" in patchwork.
> 
> Because the cover letter has RTF in the subject, presumably.
> 
>> I consider this series ready to apply. I am requesting *testing*, in
>> particular on 10gec/dtsec boards (P-series). Since no one seems to
>> have tried that over the past 4 months that I've been working on this
>> series, perhaps the best way for it to get tested is to apply it...
> 
> You know the situation the best as the author, you should make 
> a clear call on the nature of the posting. It's either RFC/RFT 
> or a ready-to-go-in posting.

Well, I consider the memac stuff to be well tested, but I don't
have 10gec/dtsec hardware. I was hoping that someone with the hardware
might look at this series if I stuck RFT in the subject. I suspect
there are still some bugs in those drivers.

> Maybe in smaller subsystems you can post an RFC/RTF and then it 
> gets applied after some time without a repost but we don't do that.
> The normal processing time for a patch is 1-3 days while we like
> to give people a week to test. So the patches would have to rot in 
> the review queue for extra half a week. At our patch rate this is
> unsustainable.
> 

Well, I have gotten reviews for the device tree stuff, but the core
changes (what I consider to be the actual content of the series) is
missing Reviewed-bys. I don't anticipate making any major changes to
the series unless I get some feedback one way or another. If having
RFT in the subject is preventing that review, I will remove it.

--Sean
