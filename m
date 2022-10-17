Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA90601CB9
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 00:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiJQW7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 18:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiJQW6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 18:58:49 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9024F814E8;
        Mon, 17 Oct 2022 15:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666047521; x=1697583521;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9atZX+cBH5XfrVLyN7GiyIUzafWg32K7fe6JJtbCX00=;
  b=i0e/AJ5rAVUVu9VMTYrj/VyUfEn2RNoL2oaRUJM29PU/mjKzmp3mGV9+
   9Do7HXe1pYHcC8CHkYRUUSxNP1tfcjPgULBc4rmkDv/J9Xhao8t9ILndy
   9jz2h3TdZBBet5Sx+2vhZbxTed2pq3q48XvlsBFCQNcDfGD8J71Ve+Jj9
   0YK/BpeGD+qI8nXuVvlp5S8867JXD1N1KzmSYQXeoJboQG5ySIhDpFK1+
   fs5vxMnE1WL0GO2Boah3nYb0pILfg6KcsSgyF5qrXjFrxQq0vYI4lY9gS
   zgqutzOurFnVYuVtJi9NqhnpFOSSkrYR1UR4i+Na5LJFNAYrwCFUQF4MN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="286330330"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="286330330"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 15:58:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="661658220"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="661658220"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 17 Oct 2022 15:58:40 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 15:58:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 15:58:39 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 17 Oct 2022 15:58:39 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 17 Oct 2022 15:58:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bHRVpi0C8Tm9qXu+pIkQ2PjzCX/a0DGLm0m3qNaP7D0Ixl1dQ+02t0vNHCPGSRTpbdg2p7517FZIPCLDkhe0u3Eg4CgCHmONr9LXPshFV9ixPZoIxLm0HvxGrEztCkup5LU9h44tmDUCTthiCRokcwt0b1MORQW4OGyQxDu6vJKkzPUxj2SP7CRNAkIEl/H8PjS876xWVxifJbNnN9LEuBchXv5jgAnwxYM1cAuSvrl/HcIDyj7tbjP+9kQ04IL1lY/QT+CUFQX2Kh9LugGlqstIgoeaGJwhvB1jFnTKjI78ETo4OLtXNs3CjwI/aDc9sEIAkAvGIVdPYe6gKCE1yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+nB3f1XJQG3aHyXLeen6pO15RGPn94/PbCO0nLRRhM=;
 b=guyEgtzF8fCP8hPnBWo8bnRbZ35o4vzO7nICvX3Mx9RU4nurVTciPyR2BhSnGKumj4g88syjROQ++i4CUCqqZaVON4+Fix32UTdfIrb5OgFwCmzven+5WbFBKo2aUf1WnQy/Ou7O27x0DN/rC7ylqSQ9qVxMJF26R+i1KPTZv+IxgPQ3Is1eYzCBHfuCaaxlKofgEboRmbTiAjQkz5679MzyOf6tMpj12kFOEnT3p3E29u9qxM2QNl9/Yy36k3BARXrAIfjfebE+7bxeiqMOwro+p2qc9aW9xvkuzQvmTfxEVlPwa1QyxgJGb+8oqbEl6KKxEW+hEGYhvtBU5w0XPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH7PR11MB6354.namprd11.prod.outlook.com (2603:10b6:510:1fe::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Mon, 17 Oct
 2022 22:58:37 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf%7]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 22:58:36 +0000
Message-ID: <ade90964-e8fe-c6d6-667d-133c36ad7c15@intel.com>
Date:   Mon, 17 Oct 2022 15:58:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.1
Subject: Re: [PATCH linux-next] iavf: Replace __FUNCTION__ with __func__
Content-Language: en-US
To:     Joe Perches <joe@perches.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <yexingchen116@gmail.com>, <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        ye xingchen <ye.xingchen@zte.com.cn>
References: <20221011111638.324346-1-ye.xingchen@zte.com.cn>
 <2e38c0f1-1b6c-1825-12c1-5ad135865c0c@intel.com>
 <a6d6e890c232775489daa9522c4f8dd9594b1656.camel@perches.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <a6d6e890c232775489daa9522c4f8dd9594b1656.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH7PR11MB6354:EE_
X-MS-Office365-Filtering-Correlation-Id: c09ab600-4021-46aa-62da-08dab0931f8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bI3iIHCidcE8zeLpvCGM5laEbXVQO2dtzAYKVeqUYBr4IizZb69HWrzvClpZq3++A9NPI0DQo3ufjwXY5I48tXXb168i1kATUtVu3cBGDRqW7c2oCra0lgB6xe35I9yv747GjeOvsbtYcBl95/U3n3hmfKasfzpGrnqstG7iZjRlwaD0qkyfS7JlTWj8a8hvHlzDPPCRY7p2tUPYc7/L/9ifL/KpvmaOHDReXRlZ1+Vc5t/h8yu5rRGndE8PDFs/V/0+lJ7y5Z4fsQ+p2FEPA99maESd8OdaY4/AnGlT/IWwrVEll7dlzLDp6CXPSiTm4+pHcRP6AHaEKxw/1iVwE51TuE2mjcGw/WnfVGXB9nVhooAxrfWLykUOUnUW/DU/m2Y+8ISyEVMctADOfepHMWvZ9L/VmKuoMz34MIUfLoexh/ABearAYtAsvd+hYlwPxSySH/eirDCVBHlF+y78mcNqelw7Xi1dA2fj0qrU5hmbvu17YRmwHZnpSqjSZ0Z9u7N7rmyzZMO0KojZE3cyUFVFfCckyw3T1AKcdzPlGFORC2E1DZB6rx5VXL86kRUkOFpas98UdwFiCp+u9Yl0n/pNXpW/nIytZwonUgN5dqc9mKnk/9j+mHjsaXx/6YuwC0oBr1MEab9GUiZ9+vZOVDhtIS/jhm/oRbSRnCVXgKcEXZx49lF27kLa/IQwkMC4QldBT9kP0UB01hnNT0jYLmyLOgpYesMQbz3TqjZCRxBE3Ii1SqtipvCAw3auXrytZaUJZg7ERngfmZr3J6lgDOQyRX3w6XWHozPZU2/5zUM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199015)(6636002)(6486002)(2616005)(186003)(83380400001)(31696002)(86362001)(5660300002)(82960400001)(38100700002)(7416002)(4001150100001)(2906002)(4326008)(41300700001)(8676002)(8936002)(6666004)(478600001)(53546011)(6512007)(6506007)(316002)(110136005)(66946007)(66476007)(66556008)(26005)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnVSWUVpVHRjQmVyQ0JGMkEwVTNiT0VyWUtrRWFmc1AyeVlpcFYza3pYU1Zz?=
 =?utf-8?B?NDFlcWtlNXQ4R01HbTRhdkZJZm05RWtlVUZOZjk5TUh0aDNEZXkzaDhFR0hM?=
 =?utf-8?B?Q1czL2xVZUtsdDUzSXVLTm5uTjQ5N1ZMcTYwN0E3SXNJd2xvQ1ZXRVpkMXlj?=
 =?utf-8?B?NFlhczBMbFRzcmIrUlhLdnJOMk9NRThkcVh3Y3dFeVhHU2NYZTBMZ01Xbmp0?=
 =?utf-8?B?djB1aHhwRFJINEkxdDJzL05tTlUzM1lpNkQ0WlIzK0pudnlneTRMMndzSlhG?=
 =?utf-8?B?RjBMdS9UUFVIalN4dXFhTlFCM3N0UmE1MEFKUzAyOThXeXQ5S1RQY3pYQjZH?=
 =?utf-8?B?NFN1UTV6RVhqbWI2c0tzUmNRUU1Hb0JPR0dUR0RMK3VLcForTGIrcyswZ0RC?=
 =?utf-8?B?TnloMVoyNGpvNE11WUNSRGlYTjVScXZoWmF5YnNnK010empWMEhUSmxMZE5w?=
 =?utf-8?B?TGU3MmtDRXNsYnhqUkVYZzh5dnVzV2VwSmpNVjcvTFQyZFVTN05OQjN3TTRq?=
 =?utf-8?B?NU42Z2pvdk1ML1RrTklHZmhzc3pGVkdGcWhVSVltc2VNY1FkMURWOWRjaXhp?=
 =?utf-8?B?dlliOWlFbWlkREVURW04RU13cUJOQlN1TTNwd1c4TmthNnB4Q2NRT1VFaWkx?=
 =?utf-8?B?WUpwMUlBQWR1RndPeS9OM3ZnRTBaekMyT29tK3QzRUp3OWZIbG8rR0lSNFR0?=
 =?utf-8?B?eGJJcHRjWTlmanBUbDVpSmJZbGU2VkNaSHZ3a3BpYmNic1djT1RxS0t6MmJY?=
 =?utf-8?B?d2ozUGNvbnhZZzBuNThxVDVBQkZWWE80SThuYmVJY0lmTjB2V0xBdGRrMEtq?=
 =?utf-8?B?cVM0ejdLeDlXSUgvY25FMlhqaWFzMk0waFRRU0pSbHVrSDgyWDFyZDhFemRC?=
 =?utf-8?B?UjJPQ2ZkcW1rdWRtZ3NuYWtyMUdLMkxWUU5XVXVyYUw3d0g1bG8wWTF0ZjEv?=
 =?utf-8?B?TDJzRyszVW8vYmNYMlVxR0JtdWhxeVM1MDZxVWI3ZVRWZ0dYOFQ3cisvSmtu?=
 =?utf-8?B?ZEthU0pOcy9Pd0FNVDI2bnhaa0lrQTdlSC93QkhzLzBXZVYzbVF3RVBGRllF?=
 =?utf-8?B?d09qRXE5VUY4QWRIVWJ0S3hNbmJOWDZYZHRpckRWanlnSjhQbjBGd2FKdmNs?=
 =?utf-8?B?bTZ1T3liVnQ0V0Q0T0VBZ3RZT2ordTczaHNqU3E1a2d1blVxR3hrS3hLNnl0?=
 =?utf-8?B?WHdMdERtcUk1eWVDN1pWekswZ0dnZEQ1U0hsbk8renNHaTd5U1Nna0t6aXJZ?=
 =?utf-8?B?UjBLRyt0Q0NhZ1Z4WkZCWmxNY01sd21kNldpM2VFVE0wT0UvTHVDMExsR1dh?=
 =?utf-8?B?OVZoZVFPeWhaR2NwRU1lcEJ6bGQ3M0F2NGU2aGhtTFhQZHMzZlJrQ3J3VFJE?=
 =?utf-8?B?RmNWWlNkaEtKcnQwR1V0VjdhTDZ0bW5wVkVCWitRMXlBSm1neW0za1ZrRG1C?=
 =?utf-8?B?b3NJTndyeE8vZFIrUlFueVA5dEM2VW5iZ04xQWtMZCtUWVdDWVJGazV3Slpz?=
 =?utf-8?B?K0tUbTdXQWJoalVydzNwS3BaMzZoQjJqbFJ0V2t0QzcvZTV1RHh1OEU1L3lO?=
 =?utf-8?B?STk2VFhMcE5KVWJicXVOK0R3NldjeUtpR2JWUzNnMjl4MWdKN1RIa0dBZDRZ?=
 =?utf-8?B?eG9lRUQ3Yys0WENPWUtRZUZaZkkxeTVybklCQWlIZzlSY0YrQ2dERi9QSnBS?=
 =?utf-8?B?Mlo5NWhWRm4vOGZINFROSDUrMHZHUHZTMG9aZ1VSb0YzeUJLK1U3WGNMbWdy?=
 =?utf-8?B?bDl1UVlQQmwrWEJaN0JpTGxTQ1oxWWhIc0ZHbmo4YzJwRm5USVJTZEUzMVRX?=
 =?utf-8?B?ZXhVZGgveVVCMVI1Y2x3cC82bDJ3N2liRTFZa2UwdU5OZ1VTdGpRVC9NR0kx?=
 =?utf-8?B?SFRpd2FyVmY2VGJHckRrK1Z2UnRqRzhqYUJpeThXcGlNTTBwWktPbHdpamxP?=
 =?utf-8?B?T2VFRTc4MnVHMnFMZmk1dXlSaTZUdkt6T29raS9vUnA4eUplWjFwSHp4YjQz?=
 =?utf-8?B?YkhXVExKTzB5ZURJQTFQa21iSHdlZVFEcjhCS2ttZVJqUGZNcWwwLzYva0VV?=
 =?utf-8?B?TFVPNFBOWk5rRUk3elFJa2hGTGtxdUt4UnJlQ0FVeHoxRjBpTS82NHdIK1JG?=
 =?utf-8?B?NFpnK1JYWWNqaUhJUXgraWNRVmdQNW1Kb0NBbUxNaDIvOEp2SlEzTE11NlNa?=
 =?utf-8?B?cnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c09ab600-4021-46aa-62da-08dab0931f8f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 22:58:36.3768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tzhVCJpjNPPdDBb4Tz8VLQBoep6bkiHoAc1lYsdU2S+lsiqM5TlyJEwF9YHQAEJt5IefRE7VzNfEORTGT7fEla9vmP76VmmKLkeyk9cc9qQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6354
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/14/2022 8:10 AM, Joe Perches wrote:
> On Tue, 2022-10-11 at 14:46 -0700, Jesse Brandeburg wrote:
>> On 10/11/2022 4:16 AM, yexingchen116@gmail.com wrote:
>>> __FUNCTION__ exists only for backwards compatibility reasons with old
>>> gcc versions. Replace it with __func__.
> []
>>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> []
>>> @@ -4820,7 +4820,7 @@ static void iavf_shutdown(struct pci_dev *pdev)
>>>   		iavf_close(netdev);
>>>   
>>>   	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
>>> -		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
>>> +		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __func__);
> 
> Trivia: I suggest
> 
> 		dev_warn(&adapter->pdev->dev, "%s: failed to acquire crit_lock\n", __func__);
> 
> As almost all printed uses of __func__ use a form like
> 
> 	<printk_variant>("%s: message\n", __func__);
> 
> not
> 
> 	<printk_variant>("message in %s\n", __func__);
> 

I agree with Joe. Please fix this message up to use "%s: ...", __func__.
While at it, you might mention this fixes commit 226d528512cf ("iavf:
fix locking of critical sections") which introduced the use of __FUNCTION__.

Thanks,
Jake
