Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E9C5987FF
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344436AbiHRPxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344375AbiHRPvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:51:37 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130044.outbound.protection.outlook.com [40.107.13.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6605C275C;
        Thu, 18 Aug 2022 08:51:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/2a6uYO4IVS9y2JRA9gcuxf6VtNa394ggdctikXA8QvXfGvDHKI04mnUP2HsIaSrq0yWNu57Lux2GoXkFoDdPu+2DlSRQ/05+dZFyRbjrEcZa1y4LeGrFP4yG9px3FBLle8F/5yD9iMgJn3/jrNVtbqMrrxa0Q+/Dfn2cyXeEp0REkaGI2QJlnTMbjgEYy2oG6ISkBL+OVK+8rsV8O5W36pjS21jKS32k9OOA7uX2Kn5N0rUuo9QyWDX9NAGemyCbf6Tzxke5ktzkb5+zL92ukZt0aL2vb3qMklDmtMQw/zob6fc+MOeAJ4Wp7XIdG2E2Fqnc7ZZQsAq9dL0jSKvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9dxmtlCGI9jI6hgceqlAtg+ukkgsUAi4FwPJqQvhHv0=;
 b=TB+Fmg5A3Mx9e1kig6uQP/im3Sk7R2ea3bhF97yirlgD8utEX6J8pngtTRADr4MKvK3TOv37Tkuv7EOU4YwYQUt5a73SI3K5Pcv5pCjDFHF4Sxf8t/7Ay/yCXUH8GvdZLlQkFiGLy7pdwSVBv7TDiomevAwJl8F4UGbOO76aeOG67G5vo86Nt+zEyUg9P8+YfXafOaCjOT/7pZta7QdUQ84PB3MBVnziarJ1K3juJYqvr/AEkXJdv/3luDeQ7TUxl9RTEdlhbj1CyX6vNjMBmxfmBljXqRD0DzXkTzHQnZ2LvIryzr4EQzSUx2lm5DKthARjharUo7+PDkHRgB/njg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9dxmtlCGI9jI6hgceqlAtg+ukkgsUAi4FwPJqQvhHv0=;
 b=JzZL7iOgDcEAxFBoEoeVlCV5WHaWYTGvriiWY0SlUvs5paZVlAqYgL3Hq7hix8559IJH152605ery8EkO/Z4arVfBpHFxxyyUYeKQuVxzMgcaH9iY9pvrPHZaV928TSYTtsBT+votysTFaO0jVba6buDROYZYLVkO4CG2lYPTdRwGHDlDE5j//iiX3IW5pVAQ/fV2j8LQFUtKgW3vPpQ/uoZxo0PSkG4J+dAYt3NzjKVRFkEpB8XlXGq89IQsyj6cWq9HdG6z2QuZRjSyvznjC3c1PabEU6pG/t0aKONIE/xYpdqQNKAccCgbW5twzK8D/ShOHQPzCdDvGCKMihcOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AM6PR03MB4567.eurprd03.prod.outlook.com (2603:10a6:20b:b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 15:51:31 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::fd39:2209:b2dd:5f0a]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::fd39:2209:b2dd:5f0a%6]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 15:51:31 +0000
Subject: Re: [PATCH v3 00/11] net: phy: Add support for rate adaptation
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Bhadram Varka <vbhadram@nvidia.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-doc@vger.kernel.org
References: <20220725153730.2604096-1-sean.anderson@seco.com>
 <f6707ee4-b735-52ad-4f02-be2f58eb3f9b@seco.com> <Yv5dt1Scht2Tmdfg@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <14d72a66-b202-f7b6-e690-e119368bf1b6@seco.com>
Date:   Thu, 18 Aug 2022 11:51:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <Yv5dt1Scht2Tmdfg@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAP220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::16) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9de67979-2bc8-490b-e07b-08da813184d9
X-MS-TrafficTypeDiagnostic: AM6PR03MB4567:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0KPlq1sbk6Z/bpKseraJ9TD0nOBjxBUmxMjShZX1zNAW7CnuE9Mnd6B/k4Eg5iute1h413oRJnbcoe8EMLwBDkiWux5r6wMJIeRxraux1mYGvSuhm0FOjjXg62Nq74ahCsYJHK9llXFI7vr3+j/YpVmsKM/uddiid2dZrmjB1dglb7USp5agkTmlq06Bjolk94uzs6fFHyF6c9VQaFJwRSxH4dc705NMuvH/OzQSiyTxJrkgZiwtx55pRNcec31c0jr5bNFES6jQiyWpf5dohCJNCuZtzziE3Mmf/L2x7GBSpvATPlK5p9G2lnA5SwonTV5sVZS9n/AOLoTmHwLqmPgZfFGVk4rMhxVZ7O0QauwfmjdopTe6vuhTqLh+O9DJyOQaKZQlUVkoeSU0ot1rX/ofn0UYgQm2LpkmwIdsv7vpQSh8+Nnp4HK7s9qfjSiC4MJ96eCZ19mUKX7Ng14kV71+s+5WeSmXzR08rdBOLgY/H0rIMx4m0o1sfGkDtwClBfiEMblFKYSbokTwwORInVlJr5rw19NVTwp+JEDuvvW/0kyYzmPN9JB/bs4zR8UKqNXXUbFJkrw1yubdo6HMO3j3FXy3qzmwWusSaFAVe6Pmc5lLAyRSHS6OcKQ28lYN2y31znEOYIqRB3Du9qwznGGVaNDBr5M1oP1GbSjf7UXBGeMoXZ8TI8pePxb3zdxEhwHkQ6PJjqQJMi5hPudNnqIGc9XInWRFYc5ytrwVoBH2U5XttVG/SsWAKh+2AzeSkRIjlZITvF6uLBKX5V4WWf3a+PPMRjlxgKebiku58p9bXfVPNPdXav85bFqzyGwGUwgk3PD3gLQi66Q2LYti0OzK16bZH5L8ut0GINyRvL8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(396003)(376002)(346002)(136003)(966005)(6486002)(478600001)(6666004)(2906002)(54906003)(6916009)(31686004)(31696002)(36756003)(41300700001)(316002)(86362001)(2616005)(186003)(38350700002)(38100700002)(52116002)(53546011)(26005)(6506007)(6512007)(8936002)(5660300002)(4326008)(66476007)(66946007)(8676002)(44832011)(7416002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0FZaHVibHJQWVlTbmg3VlRTbUdtU0FIaWNzUm80aG5aMmJCSkE3Y3JXbks3?=
 =?utf-8?B?WWFFclRkb3IzVmxOdGZoaTlyM0ExODdCdlE2K214M05xNkVuZjUwaUs2STEr?=
 =?utf-8?B?SXhjdGxqNHQ2WE5WY3R1RUZySTErcjBxemRGWGlmeFYvVUNJVFY5SE1uQUZB?=
 =?utf-8?B?UkpxMjc3WVJKbkJ3UDJsUk9ZcEdvZEREMmI4OFQrSnN4S2l0RldMWHBQODJY?=
 =?utf-8?B?YmlWdG52eU1Bbmw4d0NvaWxUcXBGdU1JV0lEcGlMMG5HOGpIa3Rqa2lLRStY?=
 =?utf-8?B?WVROekVTUDdVbFVyNGk5TzR2Z0EzSDI5Rk9OR29QOXZhYWt6SExUT1NIRFpv?=
 =?utf-8?B?a0FIbVVnSC9STUdzYUM0VlFxQkduNmNiVVhQZW45aFNueDNiaW44M2NITVh1?=
 =?utf-8?B?a0VPbnRLT1J0RlN3T3UzVFNtTVJQQzI4Y0c3WlRxbUViOVRCNlRGYXQ2SFJx?=
 =?utf-8?B?ZTNBZVZCZ2lFSFNQc2xBUWtLTFhERnZXOG1vZUt5clkwRXZrMm96UnU5MHB5?=
 =?utf-8?B?QlpyZ1l1QzhuS0pISFVCUHZLWnlhUWlxN01NS0RJd2daUEZOV2E1ZTZRd2pV?=
 =?utf-8?B?UHYrSDgyT3ROMm9nOEtPaEVCOVZIUXgxK3ZxSGxzdy9xcHBpQnBwQVhUZ3FX?=
 =?utf-8?B?NVBiaXhENzhveVRsbTFwUzJMWHB6TmVMajBxQmpLNEV4ZDVTVys4NmE4QXV1?=
 =?utf-8?B?YUEzWGNpMWx6dVRoVkZIMDZEOHdPSWE4elN3UkFTQjF6UWxVaENJcE5ncUFm?=
 =?utf-8?B?TFhMQ1BqTUFGRzJjN1VaaW9JVmRwQisvajRMR20wbC93VEhsc1pYdERrT1cw?=
 =?utf-8?B?NHFmbDJXT0VqTTlLbWtETDhZOFFMSE5Ga25iUWdHSEp2NUdadUpYYnhzYVVT?=
 =?utf-8?B?V0VkM05EeHVOd1luamU4Z0hFS2VFM1Q2cVo3cDE4WW1ycGk4R1lDUlR4Yk1F?=
 =?utf-8?B?TWQwYjQ5eTdiSFo4eU5TZ04xbld5ZnhCcGxhYWlCQUdBaVZ5UGFGODYzZDlG?=
 =?utf-8?B?QmFzWkxpSDFBQnF0c3M2ancvQkRRVU5abHovazFsV25ObEp3Tm1jUmJDdDlo?=
 =?utf-8?B?NVFndWluNnoxSkdzbWJ0S0krNnUzbXU1Qnh2SDNSeHphVDVrOWFzVkxKTUh5?=
 =?utf-8?B?bnNzNWwzTDR0cHc2bi9DeXpYUlFUVmFWN3loWmFZQ3N1Z1NyeFdWMEU0NE8x?=
 =?utf-8?B?bitjaXFrdFpXNlk1UjdsQkJ2blFPMUdOZGR5YmRqTmF5Z09DMnpTN1JPWmhS?=
 =?utf-8?B?RmdRVFNZbk9DcThmM1NsVVVURW42d0xZSnBVaEt6YVFtVTFINEUzSTJhMmJU?=
 =?utf-8?B?bGxhNHNObVNBNmR6clk5VlN1UFZyYWZVQ0o3STQrN3FkdmgrUHlNcU9mbVhM?=
 =?utf-8?B?a2VqOHpZTjFJZGlTNEk0b0lWeXRodnFoN0xoRUNpZWE4M0Nrd0JwUk9wSmFu?=
 =?utf-8?B?MkJqdHYwSUNkQlRNVHJNWGNlOVRNWjc4MDJnY1I2b1pkcFNQNTh6eG9nZnFB?=
 =?utf-8?B?L3pNY0lkR0lKQmxsV3Q0N1UxL1Z0NU4zM2JVRFJ3ODg0dlZOaFZ2SlJYem1x?=
 =?utf-8?B?ZCtCdk5JMzgvYlhnR2dFUENYMXdSUUhOcm8wM2RRSzZSejY5NEYxRy8yd0J6?=
 =?utf-8?B?bTBJOVRINFRzNXFxbEJPWDA2b1Vpb2JhWDlEcy8wcU5sL1cwMGZFbmIyYks4?=
 =?utf-8?B?VEhpQVAyenpKS3dURTA5SHlwT3hYZ3Y5ZHZDelRuS2hua3B5U1lTZ2crM3ox?=
 =?utf-8?B?eGg2YmFENDlmVDcwOUJTTUd5K2dvNmlxZ1Y1TDAySGphL0k3WldqY2VMNDFu?=
 =?utf-8?B?dXhsOTUzY2w5enJmZk9lSHNqTlVOZ3VJcWd3TGQzdTdBNXpzeWdaaTg2bENq?=
 =?utf-8?B?SmJqVmliQ0pzQ1dVQ1FFaG1VK2xKOEFKb1lDa1FtUEg3SjgxcWhjYUs5V1ow?=
 =?utf-8?B?ZTczanlndTZyS0pXWWxtN2pTWGMvaUx6czVqeE9uMnJWdU1JQWpJMWFlS085?=
 =?utf-8?B?Z0g1Qk9sL05ZVXoxdTJVd0FzSDRBY3JMWWtLdDQ4K3ZQUHUwZGppaytGSkZB?=
 =?utf-8?B?c2prY2ZqdDYrT2cxNXlZT2NiUWlnbUIwTUxMVHVXV0NqYnRYaE5DNldwS2hy?=
 =?utf-8?B?c0NUUVdoWE1iVEYwU1lxcDdaYk4wNGh5YStzYzVBMm5sZVNNeXZTWGJibkRr?=
 =?utf-8?B?QWc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de67979-2bc8-490b-e07b-08da813184d9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:51:30.9848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eG2CLz0KUI/OgfUqFJb6x3gfq7dWXDsMHC1schA+VagsyYWpbMc4Etq8vPEY68F3IeHlEZeqychrS4E6A7ErfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4567
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/22 11:41 AM, Andrew Lunn wrote:
> On Thu, Aug 18, 2022 at 11:21:10AM -0400, Sean Anderson wrote:
>> 
>> 
>> On 7/25/22 11:37 AM, Sean Anderson wrote:
>> > This adds support for phy rate adaptation: when a phy adapts between
>> > differing phy interface and link speeds. It was originally submitted as
>> > part of [1], which is considered "v1" of this series.
>  
>> ping?
>> 
>> Are there any comments on this series other than about the tags for patch 6?
> 
> Anything that old is going to need a rebase. So you may as well repost
> rather than ping.

OK

I have some other series [1,2] which have also received little-to-no feedback. Should
I resend those as well? I didn't ping about these earlier because there was a merge
window open, and e.g. gregkh has told me not to ping at that time (since series will
be reviewed afterwards). Should I be pinging sooner on netdev?

--Sean

[1] https://lore.kernel.org/linux-phy/20220804220602.477589-1-sean.anderson@seco.com/
[2] https://lore.kernel.org/netdev/20220725151039.2581576-1-sean.anderson@seco.com/
