Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1575699AAD
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjBPQ5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjBPQ5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:57:52 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B23E9004;
        Thu, 16 Feb 2023 08:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676566670; x=1708102670;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zvCiSu7Oqjug3YouXdcgIpXUkfB1PXRNI7V5f3D+fKg=;
  b=dKrUi/ombml46eULzEXLbqLzmYCQiKtwH4LmMcNRnoa6pPqoJWZgfhZi
   gxK7tmYzRnkgkybEwaSvePgEVA4QnBNtajiK2n85wt5zY0BpNl6dXjNjN
   YpjUC2NULQekTwe6Z9f3L9Jb9+/3e+NDoHFJa46B62Esh66t5E5El9hNO
   37K/kanMc7UXbC0qEoBpW2BzZoNUHF9sngtmONMHtOZgTqJe3h7+67CNy
   2zFnwkXoTa1a5/j80a53l2CHyDJNbYsPxa1Yb2BC3M0j5R0qMKUmgrPZg
   FhmLVlwpoXqLMeGIxTiAX8Rk7rw/e1FTkC3YZaUiNiOs4SHzleqMSABL8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="311399255"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="311399255"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 08:57:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="733961040"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="733961040"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 16 Feb 2023 08:57:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 08:57:38 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 08:57:38 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 08:57:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EdQVD3ORxlJdc3AViag1kCdWCkWjTdcCVqKMDrmD0lUV2pvaqYw7jWY4kXDDwyoBxnuz/O+SN08KoMlCsUiLc4zgO3wmIQEFLB/NSgz/T2Q4rebdV5ibxWHZONRdk9NQ/T5zfCzxqAkXstsOlMhxLPYBKWRyL9bCC6OLsuSHGh648DBVTfHB7UKMXfZPAroh1wUMR2QZy8qMmmeRfw0guEbj3FqeyQeyak9sskSoJXg9gQnYuoetuvAGR/TfR8cun7Qf5fpt/jdxIV5/8HUAMUPql3+mpf15cVUVzAeH1f3wWj2/OLrbeAbqJyzW2SSNOzcL0oGvmYOI9Xb3l0fdsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Owe5xtnUu55jLb7R9cdvVzp0mF5bO836AtgS4dvEcj8=;
 b=X0AG0745uup/Xpairw6xL8AH6Fz9DEJoNOxA2aY4j1+XhroSS0m0THawoEowF8L2NNFhaqahWwfA1OxSPlbJja9fqlzDxavUsXym1VYo+rGiSTe3biCuApln1mZV0tzvj+3Po3lSxp7YcKlowRdQqErFwgSp9kOnhSmp8IYA9HznOm/xhOfYeePqfPXxZW10bJHKs69jn2ATPed5ziuuSwacFb3nhaRpi0XfT8LGfAPWbpzFm45Cx8AjQ/8Pe8gnkNwJFvpdolXqVtFID8rpKkeofMxCyJJ1El3c2N7YyD8EORFsp8m82EdEjNhD2B7ZwW2hRfWpD68H0e5rPZRfCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB7302.namprd11.prod.outlook.com (2603:10b6:8:109::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 16:57:36 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 16:57:34 +0000
Message-ID: <fb29db5d-645b-86c7-c31c-738df55687ab@intel.com>
Date:   Thu, 16 Feb 2023 17:56:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH -next] can: ctucanfd: Use devm_platform_ioremap_resource()
Content-Language: en-US
To:     Yang Li <yang.lee@linux.alibaba.com>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pisa@cmp.felk.cvut.cz>, <ondrej.ille@gmail.com>,
        <wg@grandegger.com>, <mkl@pengutronix.de>, <pabeni@redhat.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230216090610.130860-1-yang.lee@linux.alibaba.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230216090610.130860-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0154.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::7) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: ad923a93-89ae-4dbe-9e87-08db103ee63e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fB5jzGw/e4G/lW7KxnWGzXDUzddtfSyJJUN2NZU/7NGBTsBTLuWpsNDpDxCv8v1GyQFrKeI/YqMMYd/FLyuWrLijRJOUqtR2JBDa2E+YLR+EbZnBb503YqmJ8862gZYa0IDmUheKDy9m+qwhITETFa3LMllJG2NLYsNuj8LQSZWUNPAL1Qz5Yasg3G5I1r4PtmnGXBlQ40isLCB/gXWVERFEpah05gI0WY33pg+TZ+rAfcusGnEjdHWstAzd15H2OXxCoy3fFvl5Pj8gIi1D0WGRyBojNp7ny4UVdIEHhMBRwCv0cKwbBN6/wdwn5bsNCGMDnrms6nHTz6BY7eSMZD6m83r+d+8TjEV2vTOUyTj8X/TGzYWF2zGU8zgsu0dVcvEf+kcjRhYFwJnxa4aRyz1Ygm9abxRQLlNXPtJd8j3b65U0ELfmCjmRmkNdDZ7GXFvN4F4A/9fOdvpEnnB2/KGnMLsqBaJYZMTINcdZ7uSAuTrVEnDSEZlr9gm7SEbT5a8Exmj7pMb5KEx/JTgICZ5N1M5FzEQjlt1uYZ4OhQC5f7PtErgxjpmlkvHkJtBj06cfJo84UGpbB8/SLqd9rf3jjDWpZ1M3Nfo9ZLaD4n6Y1Ev7NqGoT5/xgp6aQjyQhv5guyMWKNrlAg7yzLY6wSluBcGVO9y47EgdLczbv3yZP2Av6OS2MlUtmvcGHUQf93U1mdYUJYco/70R7LlQiECA9dKPDPQyjDxAybk9QFQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199018)(2906002)(36756003)(2616005)(38100700002)(82960400001)(7416002)(83380400001)(316002)(66476007)(8676002)(66946007)(8936002)(6916009)(66556008)(4326008)(5660300002)(41300700001)(6512007)(6666004)(6506007)(186003)(26005)(6486002)(478600001)(31696002)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWNFNVNtOWZnaFU1cEJFa0xMNkMwRFJCQkxMOS9QK3YrbWhDZEE0MUgvQUZl?=
 =?utf-8?B?eUVzV3BvUWRSdElRM2Q2RWlUL1hYQkZrQkMvZkcwK0c3Qks3SG9KMFVIWXNk?=
 =?utf-8?B?a3NUZnh4ampINUx6L0crUmFLclVYVHRzTm11a0ozT052WDJNdnFEU3dpRWhy?=
 =?utf-8?B?SVZ4RTZraXpVMURvZEE5SWRLeDZIQ292b3RFbnJnSStFRTVhVVc2bm5rWTZL?=
 =?utf-8?B?VDY5QVJza1N4bjhZdVhaeVZ3SlZvS2pxNjZjSUpUTktnendJa2Z3WVZHdTBN?=
 =?utf-8?B?S2VsZkdma1FLUHdyUnlYR3lNRnVTblBDek9wOWlWS0diYWpHTlpvMExOTkhE?=
 =?utf-8?B?T3dxWkhmNjJWSHcyWGp0b2FtNk5QOCtkMmY2UEV0ZjVjYlluejlBTFdSR0VY?=
 =?utf-8?B?UmZxdGJpck9WTExOTDlWa3AvT2lJakRnbGUybGI1ekNzRmRlMlVkMGErWHda?=
 =?utf-8?B?WE1LK01FSi9FaSttWjBaejJMOEZPcXBtM0plbTlwZHpiL2Z0QzVXK2dJcVBX?=
 =?utf-8?B?YUdMclZpa1VJcHhJUTFoNUFNU1B5V1o4VEVEbGd2bUdCZXh1VFJ2TzErUXdS?=
 =?utf-8?B?UmFTZkhwZnFMNzVQVGM4Mi9XRzFsUDdoUHhNTnVVVWtkYjZOZWpSWEpScXcw?=
 =?utf-8?B?aVRaV0NQZ1FtZUlOZEFLbnJVTEVabk9ZNERBTkEvSGlqNTNzQThweW9kOXhy?=
 =?utf-8?B?enhFZmlSRzh5TkRGL0dFZzhKNVJtY3YwUzFUL1RISTdQNmJDQ3UySzJ4RHY2?=
 =?utf-8?B?c1BreE5rWEE0QXlTUjk3SmsxSGNBTnAraHVYMVkvbmNSakpLRXNGS0thNzJo?=
 =?utf-8?B?SFY1SHk5UUppTXlhT0RNcXRoZ1ZpWXMxamNtQUVsTjRRTXRHeTdNMHphUndF?=
 =?utf-8?B?cTFSamRlZXNXbUpQMUZWSjZwT0x0V2dUWTV4YkFpZnFET3NJM3VlUHdad25p?=
 =?utf-8?B?ZnlNcWhDQ294c1pMWStrbUtETmhXSldJQm1nV0s5czNWZzJtVTdBQ1hJdVls?=
 =?utf-8?B?REd0c09qdks2UXYzYkkyMVNQdG53eFFPNDBXYzNMcExoWGNVdnhPeTJiMHln?=
 =?utf-8?B?WmRQWEJ6OHpZdXh3MXdDNXkxZ2d0cHZyUTlxZGVMb1BrNGxOYTZ3MmJUUW5M?=
 =?utf-8?B?Wm9NVXZ6TWxLT1paN1p6WUhmU2x5M0lqREpDUlJTeWM5N2lUTWxtd1hzV2dh?=
 =?utf-8?B?T2xDYmo4L2JtbGQ2WUdMSGpodkFjWFVqbFIrY0JoOW1rWEZFaFFzLzBJK0Jx?=
 =?utf-8?B?dmtmalBQWHdlT1B3TnBFUU9HUlFWVFRuSnYwOXRWOGlyL055Uys4b3dVMnNK?=
 =?utf-8?B?VzJ0NUxOOU9zMEJVb0Fzc1NpWGZWcjNEYU1Yb3JNYjY1Nzg4clU1ZXZVeHMz?=
 =?utf-8?B?MUhBU25BWkpUdHpOVTlaNzYyYU1LR1JYMElXS2FSV3RZM0xJdWZOQzlvb2Rm?=
 =?utf-8?B?QlhNNnNvTzIwaXpVUG9Yb1hoRk9uWXUxNTQ2ZVFublBlOFpzNC80bmk0NWdT?=
 =?utf-8?B?bTlpQmFhb2w4R1NsMkRVeEZzRkZ3eitVeTVQdy9VY0pCb2VLRjNLUjFHK0Jk?=
 =?utf-8?B?d21YMWMrWGQzR2lsZVVtdWFlOHZQSDRiemQ3S3NmTDZVbUFSUkUvR08yNS9B?=
 =?utf-8?B?UjNVUmZuSHg4VjhWRU1KSm9kWXA2Vjg3SFJ6bEZqVFRTOUpiWTY4MGN4U21Z?=
 =?utf-8?B?YVlWZFFPWFBQc1hjeGxlMUNMdzl4R204SkhRT21leTFXaDliREVGOHYwd2VZ?=
 =?utf-8?B?eC9XNXphSVpsRzkzRzNSY0dQcDBjWkdsYWtHTzRLT3ViV3RIWTA3QXRCVDZZ?=
 =?utf-8?B?c25BQjBiNExKamtkRUI4eXdrY3Y4UTd4eGdjWk1NMkFEUS9MNXBhT1E2WW9t?=
 =?utf-8?B?VFg3SVNGSGdRSlZKeENEU0pLakdxWXZ1MzU5VW92Ly9GZlRSS1JJYVh6bDFV?=
 =?utf-8?B?eS96ci85Z2p5a3orekRoYVhIRUpRMFUvY2Nmd0xlTzNDNUFNNGJ4VnI0QXdL?=
 =?utf-8?B?OWZjcE5BZ2FIVEdXU0NBR2JjZ1JjZHZhL0hWWUtQT29ETDFHZE5JcEdtRVJV?=
 =?utf-8?B?bGdGdkJYZmNzN3laQ3VJeHJuUHI0Y1p1VWhxZzRESnlEb0VJdlA1Nnl4dk44?=
 =?utf-8?B?aTR3VUtPcVlPNWVrYnkvZHRFVk91cFRBeU10dTFzZFFXL2Z1NHRyVzNpZ1Fl?=
 =?utf-8?Q?75E+nTq0Bnx2bolov9E5sm0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ad923a93-89ae-4dbe-9e87-08db103ee63e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 16:57:34.2593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vO1ZxIbKGGzxVrY7g0fhuwIgq3nHyU7HspRDy2Rlg3L3I/FmNhGcyb9TvOKXM7SRs7eFfK7vK6ccqVa3utdMYyQ2zyQ+5ain/NATVgzA7Sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7302
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>
Date: Thu, 16 Feb 2023 17:06:10 +0800

> Convert platform_get_resource(), devm_ioremap_resource() to a single
> call to Use devm_platform_ioremap_resource(), as this is exactly
> what this function does.
> 
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

> ---
>  drivers/net/can/ctucanfd/ctucanfd_platform.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/can/ctucanfd/ctucanfd_platform.c b/drivers/net/can/ctucanfd/ctucanfd_platform.c
> index f83684f006ea..a17561d97192 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd_platform.c
> +++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c
> @@ -47,7 +47,6 @@ static void ctucan_platform_set_drvdata(struct device *dev,
>   */
>  static int ctucan_platform_probe(struct platform_device *pdev)
>  {
> -	struct resource *res; /* IO mem resources */
>  	struct device	*dev = &pdev->dev;
>  	void __iomem *addr;
>  	int ret;
> @@ -55,8 +54,7 @@ static int ctucan_platform_probe(struct platform_device *pdev)
>  	int irq;
>  
>  	/* Get the virtual base address for the device */
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	addr = devm_ioremap_resource(dev, res);
> +	addr = devm_platform_ioremap_resource(pdev, 0);
>  	if (IS_ERR(addr)) {
>  		ret = PTR_ERR(addr);
>  		goto err;
Thanks,
Olek
