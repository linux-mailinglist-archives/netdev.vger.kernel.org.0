Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D4F553BBA
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 22:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354144AbiFUUkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 16:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352338AbiFUUkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 16:40:32 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECDA20BEA;
        Tue, 21 Jun 2022 13:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655844031; x=1687380031;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oRToPcyoR5anodSGmLeoEQrxshMAAj35tyI4OUz/vAE=;
  b=jB9X86LodnwqgFGi4KqMv84Nr0MoU3Ih5vs9bS8Wma/usvJDO9HDNLqE
   JoCkkxcTJziIJkXcSIG5qxFW8EVRUVI0INpXo+b6guTlmAInNZ6UlFSda
   X7P0deUyV6UG9piR5KJ1EU9O2osOpC1tsQLQ0nrLk0IStLbYdiqPNVvEB
   u29o9hv7xz8dtKfNnT4MtX5oTSQnwkRQY8AmjWeKWO3qcpvzLb3e0A2WF
   16T4EHogzsxWP7HkhLdY9HAmL9oF5p5+bjQlxY/0djAYuLidufl1XfQUE
   eAwB4aI34/jL3rz1lFP41INhDwBa94nFwNYGnyEwD5EAcbd0kCEmr5WEC
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="305679841"
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="305679841"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 13:40:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="914309447"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 21 Jun 2022 13:40:29 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 21 Jun 2022 13:40:28 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 21 Jun 2022 13:40:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 21 Jun 2022 13:40:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 21 Jun 2022 13:40:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSN0pF2J+AWfZ4h5RMgSV38lYtZLa4dQ3GERkUkpAuRfqYVtJ6+1pOPLsfb8/B0shcANxravYQQGOAuF77IdSqJuWdFy0WdOHpFed6Og0ZGHlSnRjtgdf6NqbRXzWlJlTHL6VrEA9SAhnZON010QSvNZBZH0N2LlceNJbj9Pjc+68+hSlZPPHiQFL5eeyvXkpTczKsD2hMvgpcjZ4hw+sJmZgVk8s2SqWAjFwLObYkk52iab1M7+Jcnd99dij8nglusYyBwS9/qWW8TS8Osgy7xJ6OJcEEZuIit69/y1T0oc1RnEgbrkYHc0t+LOQ/rpTv1uqkqhMBM3F0hJ9NtrMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JajPnLcZPZ/u3slVdtdyWIO/JVJUc4WcSYtv5BB0aV4=;
 b=LvoPlyYdnDkx+ydjLxZZQ6gYiPh/7lWpbVY5sOb0Ava8Cc+kPHkTK40xUAPARI1qTQrNpGeOK5DR8I1507psN7h4PhAT3VHKP4btHIif5kpR0P7wc85ir3Y0L/j38VBCqyj1CHJNFgM0Nm+f1cgQZ5gMgelKrN8Rzk6yfN3ojcb0KdtlV99az7aXT4d5zxqGLXEirepl2f0F9xGwQYI35yGrJ3I/AM/ea3jaMA9URB9jnmZY5XbsoOu6ZxAvjJ1h1DWTk2JFXDgJNQ7xfCIcQUnofWVUcC8yTyJTrQCSa/86wP+FKKhnOkShCImYi9rsLb5Teu0dtvE4nko+ANGVfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DM6PR11MB3531.namprd11.prod.outlook.com (2603:10b6:5:61::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 20:40:27 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::70f8:baee:885f:92ef]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::70f8:baee:885f:92ef%2]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 20:40:26 +0000
Message-ID: <bc8d3d9d-fa62-7e90-9809-449b7338800d@intel.com>
Date:   Tue, 21 Jun 2022 13:40:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [Intel-wired-lan] [PATCH][next] iavf: Replace one-element array
 in struct virtchnl_iwarp_qvlist_info and iavf_qvlist_info
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>
References: <20210525230429.GA175658@embeddedor>
 <ee2c8631-6e3f-c113-cc8e-29834bcc348e@embeddedor.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <ee2c8631-6e3f-c113-cc8e-29834bcc348e@embeddedor.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW3PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:303:2b::33) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2fb7eb6-7367-468d-6843-08da53c645d5
X-MS-TrafficTypeDiagnostic: DM6PR11MB3531:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB3531430A97FC3623186E6B07C6B39@DM6PR11MB3531.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4GUbxFm5x+VvO2gf/3qmTth6XKPkG5igm2ZkEKJfmsW0/ynnR95BiZY3SWUfWrwJMD+rEZwzDdS0iUEVuF+jVK++gmQPLnvwa+Ik2i77x6mbuVnRcrXIAPzWRGY/UBpFDRJaGDm9Cu5Uzr6WWRDuQUMfE/uXLqwHFPJfuUNxtrlxGroDsfsZMPBT1D8bZgX9e1wVG+9XAmWo0XWWePgONbMa0f2URIyNpC8jz/Uvd8vLrs3D9m03FBAL+3KmnVarHysXQhk6zF18xbcEXHjE9IMR9qSHy2iIEvJkgsZx/jhcInQQrGSf1JOAjX/5LH4sfcWXJuZRHY2OF8PHPodIhQl6AjPStGfBi0wa9DGHrWzBpBen+Fn40gtuRijYZEa8u4HBdoqABqmaTKQNyUqxGbipkFRz0qreQ/pAMauitrQHkQyzRqsM2KN7G6ekyz364bUco1bY+30aPkg3l7uZ7Tfl0s0NIBUI4FVOfZyF9+AOH0bRx6CFqXWdVDFFexHFMlsB5QDOlOk/6cCI1UpaeN5WPWP/Nee+PJAPO0G8zfQK07LQW2PD194ylOXhjDoiDVjwfOOs83yBpjnSCX/CWe4tjQvZH19XaFWhBJNJDrjF/CSb+nPe4ftz793tDd2sbJ1b/WEj1X56WFf+sTKD2nAYvBHJu29zYcWuo+VG74YkNdTjPtGQZfBN36YVVUUACpTsPlaVNESt758MxEK1XX6mil7AT/GCHpxLn+NrAICmGwM79lTOKtdpUG1sMf9hu4XxOGs5YXj7im4xEr9Jd74yOZmtO2LyTHQiWTXZ4Mn3tdrhXEGZcg49auYRVGOyT9hjcBkuB8v8OQh3NAv9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(346002)(366004)(39860400002)(136003)(6512007)(26005)(2906002)(53546011)(31696002)(66476007)(31686004)(6506007)(86362001)(41300700001)(66556008)(66946007)(6666004)(110136005)(4326008)(38100700002)(8676002)(478600001)(82960400001)(6486002)(186003)(36756003)(83380400001)(5660300002)(316002)(8936002)(966005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3kzbnk0anprU2oxWDM5RkJ4YlFHSHllWWhiTUJBZ3g1eTRRK2EwVmZiWENj?=
 =?utf-8?B?WHVsZ0RWK2pCaHNSSmprRGdVemZ6dkY3Z0k0dVI1a3pqUURyK0h2L2JWOHMw?=
 =?utf-8?B?bEg2OUprREhheTJsS2xTcFd1Q2NkSE90TERhT2xuM0RvSjRFSFpMSU5DQ0dB?=
 =?utf-8?B?UDNKVS9XVWh4UjZpK0xOWHR0aTVBZ3ZHTnlHWGpGa3VMa3lHaWNtc3pXcHZY?=
 =?utf-8?B?Wjlsc3N0azVlS0NjYUxhdnJxRVhLZEs4NDFMR0lVU1NKNzg5YmpIL2Q0MEJq?=
 =?utf-8?B?N0JjS29tdjVWeUszVTBob2krWWRRYnBnTWNqODJCZkJFTDhzNm1ROWRHYmhq?=
 =?utf-8?B?NFNJWDVpd0tYeTdmSmhhVG9DTVNPNGt0Y2JiRXFRTlZzeEVTbzRyTUJWMFZs?=
 =?utf-8?B?NDFBTE9jVEExRm4vckxCS1llbDJDOE1tK0FpOHdnQ0k2ckZqMVhHTzVaNWUy?=
 =?utf-8?B?Q2tnZ0wyZ2pGYmRNRkcxRUpFM0UvRUMrM25KWWhsZ2dqb3RkSmtUY3NCcXpL?=
 =?utf-8?B?S2FPb0VzbEpFZWp5NXlxejMzeWxDMVlyOFZuOWlmRmx2eUsrY1JzZTRRQ2pr?=
 =?utf-8?B?c2tXeGlXVHE3TGtCVW1yTlJ2aElNeGdkMmo2VHJ0NG15VDdZSEQ1K3UwcDE5?=
 =?utf-8?B?bDNSdmE1STBzQzV0amhzUHB1ejgvRExtenorOFBlTEIzd2RZbU9uUnNXaXRv?=
 =?utf-8?B?YmJMYmNxZ3l2dXVDcE9HaVhGM1M2K2ZpZ01wSTNiL0NhaG1Pemo5RGEzcUh0?=
 =?utf-8?B?N3ZURWhSdEUrWnduejJESzJJZy84cklHbWF1UUxKb0llWjVCMU56UVhBdnhF?=
 =?utf-8?B?T1F3bGNFdFBEQlVleXV2OEF1VkNRdEF3V0kyMlhmOFpGZ2RHbUVEOFdIVFI4?=
 =?utf-8?B?d3FGOTUwNElGNWpNamhZSHpUZkhEeFlYUVNDMFBKS1FnOW1yQ3JQUitiSUh6?=
 =?utf-8?B?YXlBRTBrZUovKzQvOXR4dWpqb1gyUHo2d1ozb0ZDeGtIVTNtOHc3RHd3K3JO?=
 =?utf-8?B?aTdBU2RWWUI3VVZJSWF2a0ZtQVAzbGcxWjBGSnkyVzJ4UWNub0Y0N0tSeU4w?=
 =?utf-8?B?NXowVlVqVVRaMXZTRStCZ0NIYkROSnFOb1pwaDBBQjFIUFd6U0hzeVh2Vk1F?=
 =?utf-8?B?anB1KytEZHQ1bXVHNHdTYm54TkhqNXVVS0U4b2ExTjFveU9NSWxWNFVFUThB?=
 =?utf-8?B?azFVRkN4SHBGazdTN2dCVlRsRkdCZmFQbjdPUUNDekNqWmhXaXhBYkVVZW11?=
 =?utf-8?B?bUJpVlF3Y2Z6allwZkR0T0thNjYrbjdZUk9pNkh3MVRmR2tjTkhVSDZXNVV3?=
 =?utf-8?B?RWQzQlV4b1ZHQU9vZzRCS3dsaDdxY3JsenplSDc2bzVObDlzNW90a2g1SXVF?=
 =?utf-8?B?R3MxcEUyNmFjd2ttVGhGeThhWnduaEJZV2tuVWZ1S1JpRzNDK0dMUmxtYlAx?=
 =?utf-8?B?K2RRNjJ4RG9EdjgwK3BDa09qVmxweUZiNGlrZlROK2tRNHkrYXk0S2dwY0xB?=
 =?utf-8?B?ZFIzU05CQ1REZzhJb0twOVU3TTNuSWNSNTR3SmJIQXdhQjBDNVFuUFRiTGpl?=
 =?utf-8?B?aXFGdm5XODJ6VG0rM3RFbTJUQzFsNU14WmRuWERyZWZrang4Vk1hVnRaWWdu?=
 =?utf-8?B?TXVaUjliWEFKR0Y1TWwrdUl0NE9sbUN6ejl5eHRWWTlMOXIxNHMzaDhMZXBT?=
 =?utf-8?B?bmppcGVXS1d4R2FtRWl6U3h3ditXM1ZzMVdIV0cxMWFOVUJLWnNVWGFORUxj?=
 =?utf-8?B?WmRGODRDN2RTYjREYU1pVCsrZGNZUzRQb0xENlZBYmNMdmRFaE5QWGxhS2ZK?=
 =?utf-8?B?b3VxYmVCR0ZXeUt1eXBrdHJNcU1MMjg1K2pwTlU5MU9tU0RDOE5uNUZrT2Z1?=
 =?utf-8?B?R3kxN3F3T1RzckZaT2tNTVAxZU5wYldneHp4NGUveUw4ZjlwSGhReWo5c3Rh?=
 =?utf-8?B?czdzUVE4WGM0ZW5LY0cxbjByZVVhRks2SHlTK25HamxiMjQ3N1d2b1pGSXla?=
 =?utf-8?B?WS85c2U0UzE3eVpOQndJTCtjVnpoYUc4SmIzaFY0anZ2K2hvOSszVXpJckY0?=
 =?utf-8?B?WEtPVDlTZVJOMW9WVXlWb0E4dEFHVmdwdzAvc1ozN090QUZpZzRzckxwdHpH?=
 =?utf-8?B?R3MycDdpcnVkazR6UzExWW4wUVI3dGxtOTBESnR3cnVwTUNLcGlLQTBhTmcw?=
 =?utf-8?B?NXNwYi8wMmdMNXlZbkYxTEIxQU9mazMrUUpHSjAxbVJZdFlVV1ZyTGhEaHNF?=
 =?utf-8?B?V3pzS3o4L0hwSjdCVC9pcWsrVGpMYXF2UHFjbnVaQnpiYUxmSGlqaWdoMXA2?=
 =?utf-8?B?VEVhbXZnRUo5NnZyczQvU2lRam04MG1DZWxEa1lkZk9qeHlaSVo5aHZ0VGpN?=
 =?utf-8?Q?QsBD2zzcgTvo6OuI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c2fb7eb6-7367-468d-6843-08da53c645d5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 20:40:26.8308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k0dRxAyhCvIMiYh8byb4YfVflfe0IodEf/YuUZ5NBs6LWBni/Bd/i7DHy1cWv++1U64xwjv3/XQ0kZwkaLDx3c6Vu/zBAQp8xbgt++EEZe4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3531
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/17/2022 9:00 AM, Gustavo A. R. Silva wrote:
> Hi all,
> 
> Friendly ping (after more than a year after I sent this patch :O):
> 
> Who can review and/or take this patch, please?

Hi Gustavo,

IIRC this could cause some issues with the expectations of the virtchnl 
structures [1] for compatibility. There was a direction that we were 
going to head to resolve this. Unfortunately, the person who, I believe, 
was going to make this change is out for a couple of weeks. I will ask 
around and see if I can get any updates on this work. Otherwise, I'll 
ask him when he returns.

Thanks,
Tony

[1] 
https://lore.kernel.org/intel-wired-lan/f2fe13346f1d44ee9047254a95914d00@intel.com/

> Thanks
> -- 
> Gustavo
> 
> On 5/26/21 01:04, Gustavo A. R. Silva wrote:
>> There is a regular need in the kernel to provide a way to declare 
>> having a
>> dynamically sized set of trailing elements in a structure. Kernel code
>> should always use “flexible array members”[1] for these cases. The older
>> style of one-element or zero-length arrays should no longer be used[2].
>>
>> Refactor the code according to the use of a flexible-array member in 
>> struct
>> virtchnl_iwarp_qvlist_info and iavf_qvlist_info instead of one-element 
>> array,
>> and use the flex_array_size() helper.
>>
>> [1] https://en.wikipedia.org/wiki/Flexible_array_member
>> [2] 
>> https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays 
>>
>>
>> Link: https://github.com/KSPP/linux/issues/79
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>
