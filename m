Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141D86C8F4B
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 17:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbjCYQGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 12:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYQGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 12:06:02 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2107.outbound.protection.outlook.com [40.107.243.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27321F976;
        Sat, 25 Mar 2023 09:06:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmPMurnMl5+1Ze+tbOLbgSvPiUK8mOODn1fNT0gtQCKxi7HD+hK72A7HFwVEHr0Z5mqQjQuh75DnbBiYLTM3reRch5HBQOSvbK6Dcwr3om1aTYjLSmMTY4mh1R+Efl0TFXifbC94CytVTCllSBZSs3ycZetGhETgIvCbVcpXvheaXAOBG/o1XiO4eZBpEyYuzXuz1wOjcmktkTIzPUZnHH7fRKqJ5LA4ljl8bbiD95UbucZhr4ljO4L9u9aZzTJ0ztEEvaod/dVc9J8JJUUIzsu8PkCTlKZIsT//JZ7f5aTimraY0wMz3yDCwGBkLdVzB+UCZfvskgHy1oCgUsJAfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHXs6V5BOg2hz5VFm6j0ahftt7saNf2gQRMibBii2xA=;
 b=kJqp3sAeReWk/2GiODbXbO9P5aAsWNg0+Tq7ZNBsXM/5VgDuyOejThbTwzswAcFB+bE9oePBm1JjG2Ehq4YBSphGxwaQaBxwY9X4fUaaA18tQPsvAkEZUkj9SSk/FulGOdtN1IMAhLItvTsCEazUsgZ7tTq55ZM0LN8PcuhJ7tMzzg4e+v54W/g/1QUrzUag4mftGnoaDAF1Gmt6HHmY/auFSpus2qEF/2u97fb/hw2KDaUc5fKwuWySwERbmGyubdfuShdnkkFz1Il586Vurp6bMlfRbIDAnwvXqZDg3miSP+bREWPDf6WcoBWbZYWjy95ZjRRO6e1Ibsa451kjAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHXs6V5BOg2hz5VFm6j0ahftt7saNf2gQRMibBii2xA=;
 b=JlRX7vv7mOm5Kojf+f+OZH4z1Z5UsgF/AmARkPYTqb8jqD5fYWEEwjpv41hVe09ZguQ+tjCHlrmI6XlG3/HsbEJmBy60zfXh4oom6JERKuj/2yhNPNVJwd1B5zoscx+mbeiqvbbNFY2t8ZuMHQold33ptWSOQzO6+7SPSLvexIY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4621.namprd13.prod.outlook.com (2603:10b6:5:3b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sat, 25 Mar
 2023 16:05:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 16:05:59 +0000
Date:   Sat, 25 Mar 2023 17:05:52 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] mac80211: minstrel_ht: remove unused n_supported variable
Message-ID: <ZB8b4CWiSENo49Kz@corigine.com>
References: <20230325132610.1334820-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325132610.1334820-1-trix@redhat.com>
X-ClientProxiedBy: AS4P195CA0001.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4621:EE_
X-MS-Office365-Filtering-Correlation-Id: 54924172-8f76-4596-14ae-08db2d4ad296
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aN0oKYccGwKLXTih7qkQ3XuDv7NJZo6ol6/n1noUvd6ZZBx/zV5lMOfBUnnT6CSNQHc7rYK6x70qex7yshYZA9fFLl2C1kkukQH7KqhQ9gjkHCUqHEvrnPTr2Wt5am+E/KosLKP2cR8VxR3/O4lx6FLs9NWheJZ6Yl+hKbsNrNzgUmabzdBQKu1l5uwnPaeqdlvz60eJxvAElcHo1fH1pmEMDNc+QcYtWL7Ecve0BXg8Mp5NnySxcbh90PwKaFBo/OmBhBsqfIKhxm7tjLWIJ8zi1RKAA/wOypDdQniRmPiDzbRzeryVjo/UIOa0Gvut1D06Mw6YJvZOslKPsxnPd52tgi1eqdF1P2kPr28f+Zmui5Xllffd3AFTM+XkNMC6Njn8JSQ+QQf/rT8JdqbAUzEtewIJdKyknomexn/SiU1lUg9C5/lUryxtTrH8ufo7DMaGRpM1b5vROkOne6AD3s2DWogaz0/IIKKGZLvJ36voaxqUUoyObj5TSxJafEGtyu2nQqjs8AvVUcleUp5ZC7oAzHHhSt3oSulvd2oiFK2LCEzZn1Oh9//eA5sA4Cfb/uKZ54zKL6uJFpLS/y+SH4I84DPh5mScSs6FwcFyZwc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(396003)(136003)(39830400003)(451199021)(38100700002)(4744005)(44832011)(2906002)(6486002)(5660300002)(41300700001)(7416002)(66556008)(66476007)(8936002)(66946007)(6916009)(4326008)(8676002)(478600001)(316002)(86362001)(6666004)(36756003)(6506007)(6512007)(2616005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q3rvu4I9dMkYE34o1q1w6fSVougpZl6Knn5N9IcItVkuuEXACdoB4RMyn0em?=
 =?us-ascii?Q?xrsXc5ooTzL6n27D5NqF7j/ssrMRIh3RMRz9Y6G0cekv5rQ0tC93z9Xdqyy+?=
 =?us-ascii?Q?T7eAWU998BeNci3ypfEacIGtTy8D99Xi32A0Mz+SY8X1ikAHhDBeS07lBp13?=
 =?us-ascii?Q?8ymQhWITNaM5RiVtbQRgjUNRWNm6bZ2LxM/Qbo3xXVHMBtKJ2oAitpyy7MiG?=
 =?us-ascii?Q?efhvGOkchxZ7otOacmYuTdLgQvZRssDsLLbqRDjmHzNxfjPuSd0GLHYp7WM9?=
 =?us-ascii?Q?ReWQjgXdNXhHfSfZxj8OxhSqF4n+UXv8paANYX2XGMkbXy1X7/sNX0myj8G9?=
 =?us-ascii?Q?conoHFvTbOhrYdsPTWEpdYP3hsyzXZQRu/SJ3spXmKC75bUv9mZCFHhT8o1r?=
 =?us-ascii?Q?qCrdykAcJRcfadPPjuMfqYzatkJGzFj+ZWQob4NJrWJHUnqEyJUfkociF9FT?=
 =?us-ascii?Q?nLDBeX9U0xfQCiPVmUowrY4zrB0MnfMZ/PXukjM04BgiVdJgxPULPL8pzw0U?=
 =?us-ascii?Q?Q/p0/Ak+FQFOMBHl9H7XGqn7vpps4oSpmc5NKIFTOVuBYw1LiG63gfe13JrR?=
 =?us-ascii?Q?JjEw+E5bjfl9vNAdID5IkgkNkWLEhv0EdYyQzrXMShBYux5OT5Ak4c6Oa/Ip?=
 =?us-ascii?Q?JMuw+GpBmS2hbDPFAubaIXihiEpCsypGMpLs4lbsDZjFHN6BFOINJXkKU9XP?=
 =?us-ascii?Q?+Y4f9cw5EV6XHLe18jMlzYH1tDygClXSdhBUdfqyrPZVVA8JNnu6MeypjD57?=
 =?us-ascii?Q?R4enn3GIvP9rRS51SJIbP1e2Y8oVlYqBPBIR638P5dI0VP3U0JR9wMY06LJJ?=
 =?us-ascii?Q?jzRMhXlwbS1T2tKqSZ5Au0JCFXTLB06YUaN/fovrjf6FHqIiUxHVie35GUqS?=
 =?us-ascii?Q?N0JOO+oBw1odvoIzIzhixVQVR1u3FGf66HCohdDR4I5Xj9fBJ8/6a13vZRSY?=
 =?us-ascii?Q?ojv1oCrq00/IVIFaLbOhIQCOibfyo3zJYcjmZGbjeErrjWPDeWRMlRF2BXO+?=
 =?us-ascii?Q?6Wkp8EovBk6865UaUvYbX5cXiO6k4DXqAD7SOsrSJ5L1YJgTEtm2AOXJm3Hm?=
 =?us-ascii?Q?PUR5E3tU31qeMtqs5Jrv9kWxhIcAHJnWkCIvewbDe2Z5JUTYRTXF1AjpUong?=
 =?us-ascii?Q?ZXLsNVCaGE3B2OU7/uHG2qLqu9HdcoihvIT0U4e09cz+RNEzJqx28nUX+XRo?=
 =?us-ascii?Q?VCUVnBdOycrjh9t0cibsMqSGHe9CuZQthw/UjEtH1xozRtcgJ9lUP0REQ9aQ?=
 =?us-ascii?Q?cowyz8BG2QgErKLi6cglIcg81roVMLdofQxLAvcygXiRQWbcRnfD5FUXthE3?=
 =?us-ascii?Q?M5LQursUIBWVfR0JdA0ndKXxTcNEuVKyYICN8dphx+NCak9H0gEuYkuCVoJ2?=
 =?us-ascii?Q?CWmXqPrTJr8xDfWmds+C4BzrW9AfFzMYVbHVOP/G9LPx6+RhXkqPixG/4quS?=
 =?us-ascii?Q?9Wtwqd+MCFs84xfy/dXenr3W/iFgMbIQwxpx6fGv7YYQJZqwGyKDAZehM00d?=
 =?us-ascii?Q?1Lv43hNNvaABR+UDahxbzjkkZH/5lwmkwpFcZOWG3bZZNv5gu84bCavRVIDs?=
 =?us-ascii?Q?mT4oFQsD1dwCRtl0IOcsnVxBef26R3jq4n79PMl+U3tfnX6GfakKp8BSxJZ5?=
 =?us-ascii?Q?BTDw8oyj9WBkTkMyTAB02NFDxXhu6ZFMEzQ1vDRx3PqS9Bp5vrzIig5P5O+M?=
 =?us-ascii?Q?TWDn8A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54924172-8f76-4596-14ae-08db2d4ad296
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 16:05:58.8656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Hw6XyKazaZzyXo8uCUC6Y/MJmGa1mi6+N+Efxa3fu8kNF3VKtLZw9P9vOa6XxoWCy9iPUmP5I4GFCKge05GfEPQ4iMJ1nDGzzFF7f7SE64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4621
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 09:26:10AM -0400, Tom Rix wrote:
> clang with W=1 reports
> net/mac80211/rc80211_minstrel_ht.c:1711:6: error: variable
>   'n_supported' set but not used [-Werror,-Wunused-but-set-variable]
>         int n_supported = 0;
>             ^
> This variable is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

