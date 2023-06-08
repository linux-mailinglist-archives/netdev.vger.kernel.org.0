Return-Path: <netdev+bounces-9392-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91B26728BBF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 01:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E66591C20E1F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E26C534D95;
	Thu,  8 Jun 2023 23:29:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4A21953A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 23:29:11 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4605130DF
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686266950; x=1717802950;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qZFPv0lJQp2ESKAejEDwKUFSkeGE8SvZiKtCiNoeqJk=;
  b=QweDaTWCmVQ6azCtSzU6NkdhgKYzyQDMTCqJPXE53ZxcJGyIPw8vRJeC
   axzkU6tnYi6Dtt7IrIKs3k62abHg3OvRBoXtrI/ttTSbE14JmiIs53J1S
   pezSU9a39F5R8WCXSHj7Q2hz3GuSMml0S9kqrOAka4MrCjDbmSrx3gPg+
   nwPvBlT2AfbKUnykAkqNHEUPyR7BSA/0ED8lJe3iq7aSi63FvZwJYFDwY
   qrkH8JRfn2vV0uPixjoq6+qs9obEjsL6jAY0JUMGYfYPqAFyryN9F8a5m
   rRWNRdz5NZe33kxhSFPjxPutV6WKB8Pu0LlBARGRieDZbHyfh94bxpeki
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="347107920"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="347107920"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:29:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="704321810"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="704321810"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 08 Jun 2023 16:29:09 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 16:29:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 16:29:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 8 Jun 2023 16:29:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 8 Jun 2023 16:29:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fV7MwWDP5g8u2OSkB2ugO2ZSLW5YdLiINEKZrMm2f84nP8cxb62pS6O2WGQvbltSu0TdgVsTbuNrfSBYDBlbjLjb5GoZFEb9M1hxlLY1Yk1j4AbRotW7kBSU7nsVPTml/oc8Vl2oyCiALukhtq5KS5/4uUDnoNPzAhe5+Ht3wLNbcS82SptqQeuXsqUtEetEC4C8dm17duTImMrFK/cbZWhmLuREPkpedgvV1jlR2f9hOywt4gHhoAyd4sQ9qNl5M2NIceJKGQmwn7lL/JGueZWff/OGNuYV4gmsV4vaSbIAuqIR7l2bCEoucCy6Z3TR9HU62pi1CsgRCFdMW3E9VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fdn9+YQ+yXrRBjGJBrM7bH7ZWrCjk7Tey1Rwm3dpNqY=;
 b=aHwns35oK1FG9BLVVzMMLf1FQIEbJSWlFPPmWfVaWl9mBw0N5bux5k5VdJ2m5a76QW2JaYCDAbvuD7lDeifLgXcZNm3jqDB6+0jXrPonIscCI8pzdQUF1JUAd6uL1yKzfa0udjh4w2bNNF5cT6c/R4+k26y1b6G8kQs+KEUPIySuSblICx+ZcTGHRF/iqYecdIWgEutH6m49urvB0CGsC07winuPozMMA32lPOR3nkaerLEjF2YBfQlwjVvKOPtp/m3pxR0mailoLYTTvaLO8zvgGSQ1zWmzq69UsMZL0Qi4gdgHed5lkYhxBeBD7tN5xBND+BaO6fl8TXm+TQiPNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by IA0PR11MB7330.namprd11.prod.outlook.com (2603:10b6:208:436::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Thu, 8 Jun
 2023 23:29:05 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::b3c7:ebf8:7ddc:c5a4]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::b3c7:ebf8:7ddc:c5a4%6]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 23:29:02 +0000
Message-ID: <e64702f1-46a5-259d-6355-40676f9d0a68@intel.com>
Date: Thu, 8 Jun 2023 16:29:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next] nfc: store __be16 value in __be16 variable
Content-Language: en-US
To: Simon Horman <horms@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>
CC: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Luca Ceresoli
	<luca.ceresoli@bootlin.com>, Michael Walle <michael@walle.cc>,
	=?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
	<netdev@vger.kernel.org>
References: <20230608-nxp-nci-be16-v1-1-24a17345b27a@kernel.org>
From: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20230608-nxp-nci-be16-v1-1-24a17345b27a@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0031.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::44) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|IA0PR11MB7330:EE_
X-MS-Office365-Filtering-Correlation-Id: 57f051c0-ae61-4e41-676b-08db687824a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kMJmrRYWndjL4ASbmuRYGHPVWTVBtH//Bm9U16ECay4b3QV6pxC33b7BXJbuFwojTsZwT310Pw5/3oUPX25ZeqsXzEahgJiNB+nx2y3iMhOKK78+mTLlJ45KH9BhozuPe/qfIb/Nn4RjLG0TshY+nbmo5TaOiKIzcWyFsHwLi1ZiK/PeiuPm7jtx/CTQBCHJdGf96FVewtGs49glqXod26aLbnAv5HPzsQiNZT0RBzF8FW+igbQGNKPzZTeVd+w/1gmUyWj0glYsx0t30F68fC9yb9jYDYIT+mUqfFoTR9l4/J//U4T6eiZxkU03bWYCvQ7AMUXEaqRhNRuG7xP/IwWIJOEzR3dAmZeCgdm2inSup+zrTUxCqWmz1zwauuHlfJABfJedkGCeDTRKXOOGmQeFeJ8JQXin6uPidKT8trs05JLs6WZSTJWINRUrgndsHUG15XlQXYJQ/VX1+45c0r8czBS8LfRUfm/ecl6CdkIRiyzAkthirOKzIPyDqaaIzpEwfb2EONt6EeLD5fAbnWLK8/pYeMeHVpHY+tbwSiv8R1QxQI704euFtbzOWzRkA8wgP2Naft+VgfyKdYa7pOm36rv3LxfJ9fM3sxaxvLtri4pByYGPNU/DA9rnw6kDvXRs5ZaHA5XfLhE0XzLE0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199021)(4744005)(316002)(41300700001)(110136005)(54906003)(82960400001)(7416002)(5660300002)(31686004)(2906002)(66556008)(66476007)(8676002)(8936002)(66946007)(478600001)(4326008)(6486002)(36756003)(31696002)(86362001)(2616005)(186003)(38100700002)(53546011)(26005)(6512007)(6506007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UktlcXhjQWRQUitEQmZaQXJWUktXZnFmT0FkTktDUUpvTGtDK29XMm5Qbytk?=
 =?utf-8?B?RTYrOHA1a2dHdTE0VmExeC9mcnkyQmVWaDdOQVpnVU1pQkw3VklNM0hhOS9o?=
 =?utf-8?B?UkJEd01YakNkcXlCM01XWnRKZko5NDIxNE9Ic1VBaGMwdlNZWDlLS1VpMjJN?=
 =?utf-8?B?aElKalYvUjNGYUZoNk5FSlAwVzdOTGVSSmcva0JhemtCSy9Fb2hGR3lScHFZ?=
 =?utf-8?B?dWluZEFwZUZzWGpRQitKK3V2TUMwTGtxUnZtZkpXVHhBMWtIQkl3c1VLZkxo?=
 =?utf-8?B?ZXp0aCtiNGhqMG9md0k2RWVzd2tZK0ZsQk9KbzdqeHFDaWRTWW1kMlJDNSsx?=
 =?utf-8?B?ZkNQcjF4dDNBVnYyaE12VkZnRFZxUkZYRGRrU041eEs4TXM1eGZuYVBrMU54?=
 =?utf-8?B?cDNHcFliUm13aFFxWGlKbFVFZlFBM3NnR3FiZnBqd2NlTzcwUWkzeStHOXNn?=
 =?utf-8?B?Mk56QmdjNHl4d0FFaWVHUS94emtuZ2h2T0NuaDRpU2tqTEZVVDNvNlFPRHRr?=
 =?utf-8?B?dFYwRVpKZlZPelRrMkVLRkxOR2thWkt1L0JQVUtOZkNjS3hGMWkzYllvOXdj?=
 =?utf-8?B?NkI1WHFyZ2hnSFNwaXlhbFB4YWFveEl1bS9leHBWWFFIVGtzL1drSFVGUEcy?=
 =?utf-8?B?WWFwMXVreWpNWkVZTmxFL29weEJkanB2QlE0WnBzRWhialBGNEt6MnFFekRB?=
 =?utf-8?B?YjFZWmJSZUxqeCtZQ0pMMEQ3SEdMUlZ4cGJlaWdRYi92b3h0bVF6WmFRVnBj?=
 =?utf-8?B?QzFvb05NUUJzaHlvNlVvd3hQdlMvOUVRMkdoTGtUUC9RQWQrekZYaEh2L2ZE?=
 =?utf-8?B?NERNZlRLRHZEMHdUblBzYzAwSTcyQzlKV01Kb1Z0OHA3Y25YS284VTVIT1NB?=
 =?utf-8?B?QjBudS9RR0ptejVFSE1lOUJqbWtXa2RRbG1IeTgxazdLYnpyNXV1VmU3KytO?=
 =?utf-8?B?Mm55Y3AyL2xKTGtvMHFHS1BkckVVMEZaSTlkV3hiV21FbHVjN2lmRlVETmFi?=
 =?utf-8?B?WU5jTmJYQklaQXdORnREejhZQlZJRWVtMmRtZ3NUMXpKV2Rwa1Z3ZFVKZmZL?=
 =?utf-8?B?SXFibnFoampaazdvcjl0RjVPMGxMWVo0aXg2RjFnajUvRDFPY201bHdDZlZa?=
 =?utf-8?B?c2dmQ2JEWkFYNk5XWlV6SCtQeGo0K1ZNSy8yYktKZTEyOXlCZTlVM0RtSm9n?=
 =?utf-8?B?dHMyNmZLWUk2bTliTktwRUhIVlZHcjJrUWpFaWUzNDEzNDVEV0UvV1loV3Bt?=
 =?utf-8?B?ZVh5N1EyelRBUUhMWVd0MXNuRzBBT2tZOWs5K296cnRKSFA0NXVKY3dsZ2Z5?=
 =?utf-8?B?RlB6SFhFNXhLOUZVaTNOQWhwUW10TGMzeG1lZ1Z0RDhZZG9neTMydGVSZVJr?=
 =?utf-8?B?djZkWVhlMExiSTdheW9GVUtQSitBcDhNSGRQZFJ5NXNhaHdLeS9qcHF2ZTNw?=
 =?utf-8?B?NE9uQnFrT1V0aHBMUXBSTFZncm9EcmE1TUdFaTRyMVBPem1rSDIwVXBnblV0?=
 =?utf-8?B?NVlKR2FoOGRHdEx5YVJwUmQxUTMrbXUwalJsV2NoMXBnUXFIWEVZcjFSdkNB?=
 =?utf-8?B?eFA0b2dFQzBVWXJCMEVrNXQrR2FsR3EyQkxiNGh6SGs4RHY1a3A4YXMwc0Np?=
 =?utf-8?B?cEJ6NGRQQS9LSDlrZkdhcUtRbUxTaFJ3QnRoSzM0akwrTmdjVStwT1dxVDJa?=
 =?utf-8?B?Z1llcHhSSWVYcVlTbUpGV0QrQzNzeUhYT2ZIeSsxTVVVSkprL09XaHBBdXly?=
 =?utf-8?B?OTJ3RitWWHZxMENUSDBuNTd1dzNLK0hBdmFPT1czL0RLZVduZFNKNko4U2Fl?=
 =?utf-8?B?WFByS1pDQ0tDSTlFekxSdk9zdDV1d0dycG5KZ1BwbXk1TW53WmlDMmpkaURu?=
 =?utf-8?B?RGlUN29oWEhHdnhWT0J4eHIrMHRvS0hNWHNpY0RmNXhmeFVGVmZYT2Q2YTZU?=
 =?utf-8?B?Q094ek5EQ2s0eGVkZXMvZUVqNFdTK1A1V0ZJZUozR1o4SlFsVEhEUXloL3E4?=
 =?utf-8?B?UEhpUTMyemZ5NU9KL1ZvaGlsV3djR05VVTc0NnU5ZUx2SW5ublVKd3d4TjdY?=
 =?utf-8?B?T2NjdEpWVXByZVJ5MjJUU29EMk5WN2x0T0w1RGFyVTVjRTVQKytubXlGeGxB?=
 =?utf-8?B?T29HWDhicFBmUG1oc0F4WTFQK1FpbTJjL29qNWluOEJZZVdtSlcwS0VFdkRZ?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f051c0-ae61-4e41-676b-08db687824a0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 23:29:02.5606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e27yzLt7qqGt126BemoLK0+0lxhTHlj79i5g3iwXkj9M9/UvIxlkfMMk7hvYT4YxFLEySFX1J567EjnZkkj1lBCZyfz+M9F/o+AszTI3MHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7330
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/8/2023 4:21 AM, Simon Horman wrote:
> Use a __be16 variable to store the store the big endian value of header
> in nxp_nci_i2c_fw_read().
> 
> Flagged by sparse as:
> 
>   .../i2c.c:113:22: warning: cast to restricted __be16
> 
> No functional changes intended.
> Compile tested only.
> 
> Signed-off-by: Simon Horman <horms@kernel.org>

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>


> ---
>   drivers/nfc/nxp-nci/i2c.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
> index baddaf242d18..dca25a0c2f33 100644
> --- a/drivers/nfc/nxp-nci/i2c.c
> +++ b/drivers/nfc/nxp-nci/i2c.c
> @@ -97,8 +97,8 @@ static int nxp_nci_i2c_fw_read(struct nxp_nci_i2c_phy *phy,
>   			       struct sk_buff **skb)
>   {
>   	struct i2c_client *client = phy->i2c_dev;
> -	u16 header;
>   	size_t frame_len;
> +	__be16 header;
>   	int r;
>   
>   	r = i2c_master_recv(client, (u8 *) &header, NXP_NCI_FW_HDR_LEN);
> 
> 

