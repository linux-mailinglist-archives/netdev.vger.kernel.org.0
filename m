Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E796A9AC6
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 16:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbjCCPgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 10:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjCCPgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 10:36:39 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230C822A29;
        Fri,  3 Mar 2023 07:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677857796; x=1709393796;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kGSg64CAW/lA8jVE6nSibuYMjB8hQLnRs+yPmmEM9U0=;
  b=NtH6FHF5QS9J3HhG2pOAU0LPND65KlPszRWX2DpHCezsinLd9WqIJVMK
   TvB3GYH4ehDmhyKOdqj7oaFuMCW8S/t4uuhVlfP0gHZud2GkEQ/hK5zVC
   4kxejCzjmW+/zArnc3cJD7EtV+iuCdGpzZ9I22L4p9ir86I46Y9S5OUbX
   5pHr6DnCb3wAYyGSW5FnjlucdJKVdxUoRZ3BmCeAKj8Vt6P2fN1rSkXvu
   ZtWT/sr0inHa9PaXa97iO+hQXtzIhifizNPN1eEJJ3WhNfgT3ksCeX5xi
   36WES+G2x57sR0lzDvZsqyX+ZKm+gskCDZ0SuZY6PTHARbvnj2giFpmI5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="421341449"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="421341449"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 07:36:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="764463371"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="764463371"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Mar 2023 07:36:34 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 07:36:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 07:36:33 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 3 Mar 2023 07:36:33 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 3 Mar 2023 07:36:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvf7aTql0xNfhs4oFmFoyU51C1BDZmkZxlEyewZQ8dHSn+7FdWiPPLZjUIedaRboCdMovXqSPH6OWBltfNf7rsBWAEqMCXtjbEYwJ95EP26lknlIzYYrG86LG5kAZZaJGstpg83Cft59X29PB9LbRzUgyRBk5z3iv850Spxw2DN23Sn94VEc1OJWpbPokHk3TY9P2fEyEbVQlos6NGICkke+t2w0jJkrf8anOmMgvbiQ7w4mDwuziUvgAE6yWBogc8nMoau8Fnj4RruM4qhE4Q6b/5Ha/EOjJxE5F49sjoEqYbUK5jMgu6sx3n5+XvB/Bhr1S23vCpbUackxNk/zlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFJIFtVpBt8m7s1XcFZnSc5KkhkgDXRvQrrkJ2YU6YY=;
 b=QtgWphLhGm1DuIZ+rOig0E7NAVl6i6ySt2/TYvz4QX8JLGcvdPiJVEhPPW/pu8mmLXi7HRNHhNVxrURj1l3pTcrapcfHBCu7dJkO4RQVjCuQ8auG3nZuVmBLpk/OC+JvMuGnIGobP7w3NtiXVAiFsFA9o65a2kdSuMkplwh96RKJVvgMHAX8MU/S1Kfeb9ZuGdoXcmckldqrHoVku9qG2ZcE6YLQmRNqADaZdoKNNsRDiy1Vt6EwmdX0AzJqzkH6jmKGcXunmOquhAIqV6lGDIFmfe20RZvMWBAO+6YV2w3RUNWTFHXa0ZzHfs3b2JOXThLask2GFjZK4K8jhbhV0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW4PR11MB5872.namprd11.prod.outlook.com (2603:10b6:303:169::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Fri, 3 Mar
 2023 15:36:30 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.022; Fri, 3 Mar 2023
 15:36:29 +0000
Message-ID: <f29ae960-dea1-6754-3957-412e3c4d095c@intel.com>
Date:   Fri, 3 Mar 2023 16:35:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] qede: remove linux/version.h
Content-Language: en-US
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
CC:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <kernel@collabora.com>,
        <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230303125844.2050449-1-usama.anjum@collabora.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230303125844.2050449-1-usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::27) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW4PR11MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: f327cac8-e49b-4e50-1d79-08db1bfd0eef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KtG2w4OfHlkd9IFXxTUTVSlGg0URn2dq7ByMYHpXzw7kyT+/RGfaqXJy2uB9Wel6yde21qDisZZv82FX3xC7NUa1kJZU+LvXRrJJC+v5ltNH2/lPH4kpDWQzULTavE0Z9O1wwgOxGOxxtaOEXYfXPK2Yo+JaiOCZmezdHbJze450cMWeW9NTM/Llykoy4Hyqwh2monLkV3YTWT31T/p/QypSGLgGczr/FpacwvK4LRQYj0ZRLBSGwcJyJK+Tt3nRT+eLAUC43KipFu7CwVHShdjoLI5s4LKDu7VSMahmNqSbi5lDWSuw9jDR7j9gYlk9TprKKH9FLGofXTNNFfc/+XnGr9XsWswmwSe4G8bNBqaPd0PGEfoxMHKWK2zcuQ7bcPKZ9v6MfyubJpqzJ2X5jHYruq2TzHjSH0tfu9FlwbTYQM/1LEiR4MrrC2sNe5AMTxhDiEH2g9V43p/kgWHL+5JL6KRivchvhZV+0C7g8zy0mOr70IrrerdJAT7uW+/jQZSXi3PQWjmKqtfKeVzeate8WluQDxoANj4wfygffi9+QGl+lrtQGpy8N8bfkO7qU1vL6cMl+09urbJ/ZuDbNG2fXkaBijusHQIF+XqB5rksw6YGhyDd/O/T+6j1DS+Xn6f5QB/vHfDYaS+pThXxOBqC+bnR4PCoNwG+BXWk+LLwIZBgNEa7/ZzkpRVleXasaoG72596mXcpT3u5fnnHiP0KvSlT1OjyETFZu9aMZk8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(366004)(346002)(39860400002)(136003)(451199018)(8676002)(6916009)(66946007)(66556008)(66476007)(31686004)(2616005)(83380400001)(26005)(316002)(6512007)(41300700001)(186003)(4326008)(6506007)(54906003)(8936002)(7416002)(82960400001)(38100700002)(5660300002)(6666004)(86362001)(36756003)(31696002)(2906002)(478600001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFlTZnVDMDJNTGhkcmtqZEk0eVVuaEQ3UW90ZC9YbnR6ajdGcURFelJVK01X?=
 =?utf-8?B?V0tURDFIUFc0T1graHlORG1FVDlvaGZVSzVnM24vUnhlc2crNm02M2FlN1h1?=
 =?utf-8?B?ZFlIV2oxcDdyL3hobWlBcEFoQXNCdjlOS29ab2tialcxRnJ4aFFvV0pvMkVJ?=
 =?utf-8?B?ekg0aHBlQm5PbytZMXFGMlpQRWtyaHY0N2pDMTRlV1hua05BeEcyQzN4S3RB?=
 =?utf-8?B?Y1EwcVdrV21hbFZvbEQ1ckNvTHRWaCtNV0MwbGtEOHNjenJKbTFXaXRjSU0w?=
 =?utf-8?B?bU1DK1JlbVJJWE96Ly9EWERCS1k1Z2xkbUlUY2tJNFp4cVRQcWMzV1ZqRDZU?=
 =?utf-8?B?S0ZWVUcvYllNdUQyaVQ5bGhHYVkyeGFqRFVWN1J5L05XSkFlZ1dSQVV3OGdD?=
 =?utf-8?B?cWFRYlBJcGVSUUlxKzJwc1Y4YkxXdkN2UjdYYVlxQVhOTGhLOGZNYjAwWXF3?=
 =?utf-8?B?a1BIMlZxcDVBaWZUcVFybXlmSHpYUGlCUTUrYWtHbWV5a3VEWm5IckJPN1dP?=
 =?utf-8?B?Mk9nM01GVG9BZkYyNkhoTEhxclFJWEx2ZklKclppUGMwa3pHMStwbDRNaFZ2?=
 =?utf-8?B?Vm5YajdjNVhCUzlTYmdZM2FENGc5QTI3NkpPZEN1MHh2a05UbXhjTFBnSG5t?=
 =?utf-8?B?Vnllaitpa29qcDBLZUlKM1hHMEVIaWNZVVhrWDY5dDZxb3c0aVZjc29VZUV3?=
 =?utf-8?B?VmdjdlZnNmd6a0JYUzhaZlpMMlc5OFV4NUtJRmFWTHg0dk9YMGNuek96ZHFF?=
 =?utf-8?B?b0hTalBqam1wSUJqbW4zR2J0OWpKV0NVT2NVQk1ndGtlMjJ3ZnptSi96Zk9F?=
 =?utf-8?B?Z0NiVXJhV21sZ2w4Sno2MGdUV2RKbU5MMEsrb0VaaW5CcENiZStseWNBSi9T?=
 =?utf-8?B?aXdZbVUrYVhjYnJTbVFobjZMY2t0bklyb3FRRkdUT1VmTjZxenNrbVBRaU9W?=
 =?utf-8?B?TXp4Vi81eGdmMHBGejNvUFY1R2xKS29pMXFFVkttbVczam5PekRLSXozUDRx?=
 =?utf-8?B?UjZqVnRIYXpzeTRsVkZwRzBqTzVWSUtDTS9lakZQVTlUeUtjL3JCY1FLdjFl?=
 =?utf-8?B?dkVtam1SbEhUTzlDZFZOQlZwSWR5RnVBSFAwbEduQkZGdjF3dmhObi80NzBl?=
 =?utf-8?B?QW5jaE50dHA0aHlQKzBUQ0RIbDBzb0Y4ZmR2bUMzcTFod29PTXlCZlRqdW5U?=
 =?utf-8?B?TmtVblNsVGp2NTVCNE1tdW94Ykx0a1JoZGpldEZzQmpkdVpFbkRGTGhDakVY?=
 =?utf-8?B?Vkp4VTJyVUtpVVNOMDFjT2wwL3BQL0dMSy9ZREJNSkhEdGJjRWlVSytaeWJE?=
 =?utf-8?B?ZG5JcVRXYktZajN5dWxObmh3Vzh1dXJFcjlQN0hnL0VJY1pwWFRPNEtBK3Z1?=
 =?utf-8?B?eXZPMjJNMnJxZzI5Y01Wb0NGendaNm9xa1JJcTRFTERRcTVoRTM0NE9pMEFY?=
 =?utf-8?B?YzhDU0FuUzJOd0FicFBkT0tsWTMzZVFsNWxaMm10cWpDMzZFVU5LemtGczBM?=
 =?utf-8?B?a2ttTjk4TzAyK0NyVVhpdG9zOExWZlNweEtoczI2OW5LMmVvdXhrTnplVmxo?=
 =?utf-8?B?bkpGM3AwOVRpMExKRnpReTl5YitpVEtzMlpEM2ZvVjZ4YkI4RHdlSFZteEdp?=
 =?utf-8?B?V2RSYkhNUGlTSDJReWhDV2lwUEJMRkxJK0I0Slc1dGp3Q1ltbEpsa3A3YnNC?=
 =?utf-8?B?TktYZVBJN1Qwc21DQXJuemVFSCs5dXVGY2NZa0ExbDFzZTg4eTAwb2JoVXJB?=
 =?utf-8?B?d3gxUEY5VFIxZy9XVkh6eUZUMFc0MlhiNXdYdDUyRDFwYnYzYzllMDlZSTR2?=
 =?utf-8?B?STJxeXAvMjRjc054YXlXeDgvUU01TUZLcVVuemxYblB6TXVqT3NLdXo5dVVW?=
 =?utf-8?B?Zy8wVGlQNDF0MG1ray94VldtcVVXNnNycW9EeERnaHJPbG1GZ2kwS1NOUVBl?=
 =?utf-8?B?Q3hjbGpqWG1QR0ZlenNGV1Q5dmtZaXVrTmNFVitUc3BJUXB6VDVTNHFUOENT?=
 =?utf-8?B?RUNUdEh2RGhUc3ZqUHVaWEF1S24zUVJYTC9BZE13NksxZkkrQjJQeW9yRFl0?=
 =?utf-8?B?aDdTQlB5NldCRGhPa0FINXpIM011QW1MbkFJZ2RCdVZCVVpVVENia2ZuK3NW?=
 =?utf-8?B?ZnZxY3ZPUXhPWFlTUHJzOVgrNUZlaW0xcit0ZUFTMkhyQ0NjZG5IMzNpUTJ0?=
 =?utf-8?Q?tAsipfyDFN3CTRpen5wypqk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f327cac8-e49b-4e50-1d79-08db1bfd0eef
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 15:36:29.7096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sh1REVlRfxmJ+2cOzTL9EBqNJUTuElVyFfOtzvhLxHKK9E0Tv2Ql57igLnwjoAUh+iy0WvUTEN1Bz3cTUcr6x7fchsz7BkJXWjE7Ey6i69c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5872
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Date: Fri,  3 Mar 2023 17:58:44 +0500

> make versioncheck reports the following:
> ./drivers/net/ethernet/qlogic/qede/qede.h: 10 linux/version.h not needed.
> ./drivers/net/ethernet/qlogic/qede/qede_ethtool.c: 7 linux/version.h not needed.
> 
> So remove linux/version.h from both of these files.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>  drivers/net/ethernet/qlogic/qede/qede.h         | 1 -
>  drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
> index f90dcfe9ee68..6ff1bd48d2aa 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede.h
> +++ b/drivers/net/ethernet/qlogic/qede/qede.h
> @@ -7,7 +7,6 @@
>  #ifndef _QEDE_H_
>  #define _QEDE_H_
>  #include <linux/compiler.h>

I think compiler.h is also unused, maybe this one too, while at it?

> -#include <linux/version.h>
>  #include <linux/workqueue.h>
>  #include <linux/netdevice.h>
>  #include <linux/interrupt.h>
> diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> index 8034d812d5a0..374a86b875a3 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> @@ -4,7 +4,6 @@
>   * Copyright (c) 2019-2020 Marvell International Ltd.
>   */
>  
> -#include <linux/version.h>
>  #include <linux/types.h>
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>

Thanks,
Olek
