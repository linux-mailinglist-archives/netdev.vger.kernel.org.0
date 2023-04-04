Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3826D6D14
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 21:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbjDDTZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 15:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235645AbjDDTZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 15:25:31 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2101.outbound.protection.outlook.com [40.107.244.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C533A92
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 12:25:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtI4vuO0PzOu3DVlrpWxzPyYDVjFhvSuFI/G79iUGheHNVeRNcxpMuKreSYCpGXSDsbwq2toSisFRMYFmIFEzs+a+SF6ou4FgHe6k+Pf4fJW7gH57VVSW52OdQZoHEAv20Kh1pTNw6p+UXftIUbr1cAvFMNAIcbhjGchgowS/QsddpZeqVTv0JrVh86GgXL/MvjoCiC4ttAXHWxI9kMDUyv0akl5CX+6NjMODKsg3JDVbpnUlal5fUIdNEqIodMB34+D/KLkVOX21NvaP4PKozKmGbYKC2KhjZhFXjFYh1TkZByUdxpVH8007YDVogVHCKWPbubDAJXSgBW555CO0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+V6DokqZEFVzC7HTI0a9AiW8i34C1Oq7RV35zz31IYs=;
 b=cPBUlVqxlIW6NLfKkOsGpndsogDiCeHC/hz54eYFgQ1zO8IZhSJhCjlSsBFgOHnHdAF43T1eMNbowjDIyytaAfaitEq5PclqFfStxyczxwQwJSjXm+1QhZbNhPsVyybaQBr7hF2Cy4KScpW60dAjhRbC6NZUvf6FdJieHTYE17j9/QfCbk8sGAWNLzGEwFt/Di802TVxnfxETM1jmE+YttzWP/N6/MBS3UThbbJuzuVwi/ZllplEN/SfbZHgL2S0cMKFnDlD81n9hz3w+aMPugdMOgv9L3hG9KICNBL36jB9WL8jC4QZ/gDxs2UsQQV0Gq0MJHtJUtQs9BQ3rZge2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+V6DokqZEFVzC7HTI0a9AiW8i34C1Oq7RV35zz31IYs=;
 b=YQEuM/+FizqCnpkdGuqUwFfRb4o+TuDch2Xi4yuGxVlhlrXM2bfMdUIAFE0DB+Z9aVqs2KmErTmdm9YUCpq2DarQYEW0zstIS1GUqOO6ku6VncIBFsipHVigTXea7/3fIKYcDGwO5Y4f5OIitq9+4sC8/hNL4rbazR6J2QiU6B4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4921.namprd13.prod.outlook.com (2603:10b6:510:94::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 19:25:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 19:25:21 +0000
Date:   Tue, 4 Apr 2023 21:25:14 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net: thunderbolt: Fix typo in comment
Message-ID: <ZCx5mnYKdaI4LJ4x@corigine.com>
References: <20230404053636.51597-1-mika.westerberg@linux.intel.com>
 <20230404053636.51597-3-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404053636.51597-3-mika.westerberg@linux.intel.com>
X-ClientProxiedBy: AS4P190CA0041.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 564a78e3-26aa-45b4-d36a-08db354254a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VOiRf2sZQRkkgocxhyLRlvlOEVve4bSQ3N6K0PODLPSIfpk7OJ3a3gaH5L4tNS4U6tB0jkkbwuiAGDCrAZFEnoGnlIWSxPplIrLlhgwruQb7dNYImIXWouhfaDdZ6xNdUvYS2zgdEl9eR7ZRXeXC3yXt/52QrjhXPbW52lBwY+u/ePBvSQAkOBRvdqpQJ6s9oo5E56UyqOqVhBxEEGUfbFSNOuiJ2ajlaMmbac6bay8YriVBIbDGs7vma0+XjyMGiuwVe1FZjf7TrLCPxR6CVjssWbTf2JJ3cX207ObUwbe3AmfhEGKOi8Eh6ne3ewEoSa7W7KL8kyCq7mkCT4JTMAYqYuxVUY/fpZuWRlfClI4CWMedOqGHtRQWXvvfS71MskZURTtMxiTGb3Bw1mgv1ScNu/pf7teSHxGk/cMSACMZILdC+oOVEk7F0pfz32Jj3nsckdcF0ejh1aOqZjCmwcGV77C0RRX8DVXQSNxhjtxfmqCsSXM0xNGEbBjayx9eOQiUwkeru7rg/nKw17F/6RvFBaU7Mz0rrZHnPYV+I9i7oagaF60QtyJ+ZIPOBab7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(346002)(366004)(396003)(136003)(451199021)(4326008)(41300700001)(2906002)(316002)(54906003)(5660300002)(186003)(6916009)(8676002)(66556008)(44832011)(66946007)(66476007)(478600001)(8936002)(6486002)(6666004)(6512007)(6506007)(2616005)(83380400001)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E1+tSL0fIgd7I/19DxS/7F/mc0pWNdoGbYjS4xA6/NWz/VHGOkG8nuLVJufH?=
 =?us-ascii?Q?bQkKPxC2YA21ugEreU9e7uIWp0Mug8zrb49A4JTBsV6qh1LFoNEnui24tJq9?=
 =?us-ascii?Q?C/fEV34popLiY4GEPVLm/T9jSzn6lRQJ88hMoZWIm1zgwy1DqJv0zO+ovK5K?=
 =?us-ascii?Q?h4uRtsQT+ZunexevsY4Ls2kFmVUtogSulSDmKSpziOCzIOpZhZjnaLB62QtN?=
 =?us-ascii?Q?skFxZcyhriK6VWO/Xuf7a4CXMyCu0hE5D1sRvSpWfT9DWIEPWQclo0qoVNB9?=
 =?us-ascii?Q?u3Hk2RYFrohTYWD7x5WL6ZYmRxUWrXbp7TSZgYDRmbqdtHeKqIMRBcAcxsBP?=
 =?us-ascii?Q?PwC1ajZ3cJQtbQJ3jQiXscgQOPiXCy8bLkCafR2f+aC1vfiT2/K3GGIG3L6U?=
 =?us-ascii?Q?7S6jwNmmSwUt3NDSO7Mt0llGf7UOe5bTQnk5OCzsdrPxKQoPTERiHlGBusEk?=
 =?us-ascii?Q?2fmUr0RS5UttK+B6UpqFlvHX4WXVGO2Iq7EhDDwU9OVT0ZFpIkwxIm0RSv4q?=
 =?us-ascii?Q?AiIeToHMoJZN0LA/fXbNJWucdRK/rkoBJ4rBOAHa87BC61cKXx9GKjAa7Bu8?=
 =?us-ascii?Q?o/c8K/UdHb3J7nDmeUID3cUbGQr+erCWyQmULfvhUhjTpeOPurYV0yvd3xA1?=
 =?us-ascii?Q?riytd53MkEP48ff/9MwOwXn9h4MjwHPGUmQgDu3Y1KSEeZMKcVwon7PoocpX?=
 =?us-ascii?Q?/zqNuSSBa0v6RwhwvwZLTTmQDrTY31XH86MTrCgJ4GrknXC9zTslmKTYOrL0?=
 =?us-ascii?Q?wi/lRjBcSJaTBsODvuT9RzeLvdsYQlGtH0o/jCGlFuAKL8cOoj6RcMwE8Iqi?=
 =?us-ascii?Q?je6O8iDjAJsyhs+E4grgqLik9nU1/lg6v4pLOunW2ZssRALxv7pWwFB0SrfJ?=
 =?us-ascii?Q?qNV5VeFnPFif7ODIKr9oJl/r8ZeWpusUjPtO10qPIMMTvkbgBjxKVkXtVem3?=
 =?us-ascii?Q?+RdKgtFJFim2K5gn8NNy2OAxZjHt5voxPgi0INc2WxzEDVzRT0Js2oqcGSBv?=
 =?us-ascii?Q?IR57qsrpzmT/CePOcrDK9wjDBcRpu9+BbajKjfPz6UaRAwj3mXv4vQeh7aLf?=
 =?us-ascii?Q?8hvKZFl+yJRYmX8NbbEoTPzJXK7fqQOD6iqpDxy3On3QF5QFvN+3q3Gn4x1e?=
 =?us-ascii?Q?qkHzS7o3ADpt9wytszZxgJZHDfH4FjqiCrFcvId3C3O/YgRuvYhwg1sv+QMo?=
 =?us-ascii?Q?tpdahvDT5ZORW2Y0UqF45EUKo0Qh5YwVY7Akj70umMynoxA1NlwXHpxsGhcx?=
 =?us-ascii?Q?hnV0WAIhDEzSjM/HYZH+JTpixqpiLFLWMM390cvx+IWSJUCU6f2MwFvzs02B?=
 =?us-ascii?Q?+AeCNOKj1VTH0B5gpbDqbFmEU2gwxX5u4GGKArGj2gF943yhP7RctMOnDsnu?=
 =?us-ascii?Q?aT7hrfBPRxynn4MhqRT81i3iBhkGBH7RBLEXpvJ7pHA7GWRicl73hxu8omA4?=
 =?us-ascii?Q?iYUcR8gDNrsakXO68RQYytUHaNf547rYWK9ZCqwvbTwX1JTEKxSUvqTofU2L?=
 =?us-ascii?Q?nYz0gUbJ6thtLE8HLlCpz9JVuSv6+OKkFWQZPteLB/yOKm9uMdkJi+m8z1vR?=
 =?us-ascii?Q?OeDPFAd4tyY+BG5BTb0dzzrm8JWsxwBoZcpORQzUJmhM+45069CHBvLIuEmu?=
 =?us-ascii?Q?Xxmf1duwxut188GDahewS5B5/AKivhWxMVfOvMHl+MAxHf5ngiuiz8BPUAaZ?=
 =?us-ascii?Q?kF+NYQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 564a78e3-26aa-45b4-d36a-08db354254a8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 19:25:21.1317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oh3IAKyjWB+5WML6Dx+cdzmS92BzCbiW1U8R3T87m/Om7SF1KRH9n0EW6VZ845FAmP9iQ5LDfRsk3Fh47cmgWmJmKsOB15NpQqyCcxlYxB0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4921
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 08:36:36AM +0300, Mika Westerberg wrote:
> Should be UDP not UPD. No functional changes.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Looks good,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

codespell tells me you also may want to consider:

$ codespell drivers/net/thunderbolt/main.c
drivers/net/thunderbolt/main.c:151: blongs ==> belongs

> ---
>  drivers/net/thunderbolt/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
> index 6a43ced74881..0ce501e34f3f 100644
> --- a/drivers/net/thunderbolt/main.c
> +++ b/drivers/net/thunderbolt/main.c
> @@ -1030,7 +1030,7 @@ static bool tbnet_xmit_csum_and_map(struct tbnet *net, struct sk_buff *skb,
>  	/* Data points on the beginning of packet.
>  	 * Check is the checksum absolute place in the packet.
>  	 * ipcso will update IP checksum.
> -	 * tucso will update TCP/UPD checksum.
> +	 * tucso will update TCP/UDP checksum.
>  	 */
>  	if (protocol == htons(ETH_P_IP)) {
>  		__sum16 *ipcso = dest + ((void *)&(ip_hdr(skb)->check) - data);
> -- 
> 2.39.2
> 
