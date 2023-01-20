Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE53B6747CE
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 01:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjATAFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 19:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjATAEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 19:04:41 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DA2A2940
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 16:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674173058; x=1705709058;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9fMqAB0uu2lE6hVit9rjD/OW5+Gy3iQ30HHILG1g2Es=;
  b=nMP8ukNqGgbkk6sxAXUPlR47yfWioHqUbY8t2eopNy1mCSSLFtBHxeki
   bPk23qeUbcNb4nT4+zQdsNiM+GmeZZOjX6x6t4W/JFu0l8JrC75BkW2JZ
   HrETvJf73NMrsNY2qBganBVJ2F8nwPmYZfKJiBpHr+NcYtzDSI5fyz1TI
   UUTh7XVHuIdLQCY8T+qYn3XIVC63k6DRt0B0m8K5EDPIfB4FadTpfxM1m
   /BVh5sunUcaNst1BYS9HV2dbHfNCfmfwvzp2w3O05TfopHBMfo/h1AomT
   ZrQo01LbbV3L0Y4MaIFiYHm9NulHPchrTEcriu4Np/DLYNL/FVsZTl+tb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="352723310"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="352723310"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 16:04:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="834211581"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="834211581"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 19 Jan 2023 16:03:38 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 16:03:38 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 16:03:38 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 16:03:38 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 16:03:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9r03hGqKov8gTYwlie+ethPQYOgDZyvaUlNucqubENzvJxZGYiz5oDOsbvgnwoPtz+Vd+Kpk2ijCpxo7+PxF5D48jwu4QYgVBZ0e/TLrFXa5xxUAzrxG7BHdf29fUD+GglaOhS5hFQcEER0vQCZIoBwyb0vr96f/uxNo8ep5i2C5oU2qtVW3NEqPdDJT9wE7BRyJNJOO3JHaz6j73YIVJ+Kt5KtQVILZ36YtH4COsb9opb6tLuSHp5fohqMy9x3M77L2ukEx2AL5yMTWScogCS/aA5FtZir1I74m2fqy4nVVU/wduNPOSkvA0qRAWtue8KI9QOJlcOFsMMnSqDq7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=64T5utMljqz0wiwDxBU/nWWQ/GFDoMfIAx+srhT1yO8=;
 b=OcMe96PKZbzFnmtMAJdqDB8ZJBrRjUn7T0hz9eVRjI7W5S/hkqHcV+OGviLFCQuX+JF3FiQhptuQlxTPDuGXj23eT6d7ZrLCAgn1dOhWuGwqg+LZrBx6QL+su98sIB/vhjoeHSjxvVVmIzA729HkHljupAOW95nUijQBWXy6VtdP6VUnhL8MxVdz1Dkul5TrH8nQ1pbeNI7ABeXeCkasaCenXOFkHQjjmAi0wsovJAFXQs8+9Fg9LruCeUjCIiqftltrNIdq+of8/K4wHzRJsyG3W8lv7XW7X7k/xqKj769s0byYmlLvIRFU5uZLL5E+xnR3OIwtur9sQnzkbJNMoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA1PR11MB5922.namprd11.prod.outlook.com (2603:10b6:806:239::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Fri, 20 Jan
 2023 00:03:35 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 00:03:35 +0000
Message-ID: <75c6f2e8-bc1a-608a-0616-e182822a7591@intel.com>
Date:   Thu, 19 Jan 2023 16:03:33 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 5/7] sfc: obtain device mac address based on
 firmware handle for ef100
Content-Language: en-US
To:     <alejandro.lucero-palau@amd.com>, <netdev@vger.kernel.org>,
        <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm@gmail.com>,
        <ecree.xilinx@gmail.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-6-alejandro.lucero-palau@amd.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230119113140.20208-6-alejandro.lucero-palau@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0131.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::16) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA1PR11MB5922:EE_
X-MS-Office365-Filtering-Correlation-Id: 05d2886a-e1d6-42f2-d6bb-08dafa79c64f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +WuacfxYge6PlV8+ADVMbN0DyxjtehNlE68i6Pf0GGUDCu8p/2O0r6HYOoclAyG85Y3L/hJjW9SFr751wKy3IPfcZOOB+msZFnBBMnbc2/Q6UtGoYj2RWT+uveo/8qMcrjVYfnMDJnBKE3q2FDXhUfq+TR8V9RYPBQYrNeecMmtjOTODL7FQrnIX+pLlzaUzVyAuw5fzHV8zdgKd7omtHrA3t4sMOLFzYVd1v6vHan2Pla57EEqPFxaxnskzrKae6wlxO9tzBBx2tFN92JqFGdHPHJ91RiOOwTSzONGk0DMT/uyg8JGw66MsRLq+zVgn9qRbF2/SCqmCkhUjb2VddmRWaOpTyZ0HQFwGzfrLJlcHVurq8zeWPnpn1Ihm9LIcE6fEUDohuOx1lR2PLHy9cA2SFPUTSDpRNybHNWcJithIJqMsIVMgHwt7QCA69Obb1BXrZI4DTiiOMoD0kBkhzGejS7WUMnM2lhpbKLY50Z2vcAh9jW6KkAaDU3VL2W79oXMtocBWa8IXm6mSr1kKo3LW0vn9tFZB82/3lJ7Emd+SnY7psq800sp8S68+ddnfEOUee4tvN0yYJM93wOfE1sIrs+J7FFndVx1xIlZkh6JaLJCE1oBe7GkXsqPcDfTvpOp2lvwHlt0Az/uwwiaaao6qh+MFu2tYa75GB1agiaXXw5hl903LgC7gTwkwUbAhkuytxCF1HyiYUzMaESkypWLyjwQ8DBuBI56OePuLFsY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199015)(5660300002)(316002)(53546011)(36756003)(2906002)(4744005)(2616005)(38100700002)(6486002)(31696002)(86362001)(26005)(6506007)(186003)(478600001)(82960400001)(6512007)(8676002)(4326008)(41300700001)(31686004)(66556008)(66946007)(66476007)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3hOWC9scDRHRHN4NDFIUDB2Y0NMUlJiK0hVZzlXSWwvWktRM2JaSE9PUXFQ?=
 =?utf-8?B?SlB6WkVRVGRidUVQY2pKajRUZnhaT2hsM0w1cW40OHEvQ0xTV2tZb1FrbVZG?=
 =?utf-8?B?K2Y0N0JMZkVkcWtJYXpxWktEbVREa1Nnb1dXUGw2YWhEQTdBelNHSDJhRzVO?=
 =?utf-8?B?MVJNdkN0dUc5MmtTcU42ZXNvVjJreDF5ck1Nc0NCR1BHcVFJdG5ybThpb283?=
 =?utf-8?B?REl1MnZBSGwxZkh3TG5WTWJUSllVdHFtbTdnRUFTYUkwR0FDUlltdTRHTXEw?=
 =?utf-8?B?YVV6UTZsYlJROEpaNithWndTbng4YVZHdE1QNTIraVVHNlpkT3kyS2lqYjVH?=
 =?utf-8?B?Z0VvbkVjcTZBZlBNVTdpbWIrQS9Nc01FclBSenA4ZVBaaXQvZGRMZDVLYUJi?=
 =?utf-8?B?RXgxOUpTR25VZDNLbVhUYXZFWGhtRkNCcUE5eHFUMytaT09Vek8vTkh0bmU1?=
 =?utf-8?B?QUYrVXJzNjdES1dZS1FaVXgxVUEzaHNRVDJMbUtSSG5IVkY1VFZiN2F1Umlw?=
 =?utf-8?B?Mk80cVc1OG9XZTZjckNNb3B2N1pNQTNKcnErVXRGc0VFNTNUS1lPZjhOdXJm?=
 =?utf-8?B?SjF6bmF5ekpnK09tbE5mK2taK1VoK1lxSmk4TUt2aHhmbVJiRHRVTC9ZVXFI?=
 =?utf-8?B?cG1XS2hKRXliVWR3ZnpyTjlIdG0zelZyamZ5T3NzcG0wTkF1STJDUS9ieDJz?=
 =?utf-8?B?RmlabnJ1SkM1Wm1lUWs0WmtXZDg1c3c1MGg0WlBuUU1PWFNHcVNKZ3ZYT0xW?=
 =?utf-8?B?dW5sT3puYkpTUGxzS3JrVVYwY2J6YzR1L0Y4V21WRTdWM2VWU1oyOEUxT0Y4?=
 =?utf-8?B?NzFNYVE1NHhhNUEvU29JYlMzamJCSjRWL3pIUzBGOGpjRGxPbTNEMDJZUEVU?=
 =?utf-8?B?YzFOWlRUOTNzMDNPVUxTTEdDS3dEbjlqMHI2aHJXQjliWXZISWRNckphK1Nx?=
 =?utf-8?B?L2tQaDk5OUVoZDZKQkkwTWgwb3hoL0lWK3F4VitkbUNKbzJCZ3E1dHpLRzFl?=
 =?utf-8?B?MzNJNFhWTUN6QmtMVWJ3ZmpmanlFYWkydVNMa3RhdXNhU1RNNnBMRFhtNXhy?=
 =?utf-8?B?WER0aEpMUVNla2ZIeDBwN1F3UFBSUXlYRXlFUjNjcmNXcVF3ZituNFdDd1BJ?=
 =?utf-8?B?V0xZRXZIOWFWbGFGY2t5NlI2TXljVnM1QzJhTy9pajVpYkJGT016bFo5M0Jm?=
 =?utf-8?B?d285WWRjWkY5bFZUYnFwUTRRUmNVYndhNzNxczIzM1d3OEIyZURuTXpiVk9O?=
 =?utf-8?B?UkxneHRJeWpVc1o4MVl1YWJtV2ZFa29LNldIc0cvZHB1anM2NlRZUWExTWpS?=
 =?utf-8?B?ZUZMclBjVWwxcDh5bDNCLzlYcVowRk1kVHluK3o3TFJiUWxoZDI4RjBTUGlR?=
 =?utf-8?B?OVRqb0hCQ2RRY1MwYlFleFJHTzRPWWF2Wm5scDgycFA3YVlDWDVsZXZkcEh4?=
 =?utf-8?B?dzVtVjlOTWVIL290MlpCRHowTHZlMkFoQmhkOS9qTk10MzFacjZCOXkyck5J?=
 =?utf-8?B?cTlvMXhCMTZITmFGeFRoK0pPbkNGUkczTkdWNjFkaXdPMEUyQzZKdjUrVnQ4?=
 =?utf-8?B?enJpT3NOd3FocXpRdDdFSmFUaDZObGk0TFhtaWxlQzgwVElsRld6YVRUNExG?=
 =?utf-8?B?ak9EWjdsV2dHalBXMmpTelZiL0htWTFNcEI0T1BsSTB5WW8xZURFbHN4ckQ2?=
 =?utf-8?B?bHprdC90N2RBM3kxQnBDd25Oa0xtWW5oWVdZN2FXVEhka25YSDR4d0hxWDFQ?=
 =?utf-8?B?S1R6aVFib3hqbXJ4aHErM05BVEtaOE8yc1hSU25rRDJ2cjJpWFN6WEdBNEVm?=
 =?utf-8?B?UDYra29oUUZkQWhpa1YvckR2MzJ5djZTS29nLy85ODIyTW1iMDVIY3JBVlVk?=
 =?utf-8?B?ZEZFTXZSZXVNMVJva3R0cGIwRVRTYytUeEtPYU4yOThmS2psbWM3TC9ZaS9Y?=
 =?utf-8?B?SnNuTWV0dnp2REFoS1k3WE5sYTZTcVdZODFkMTVZVFk5TFZhcGNoUUd4QUw3?=
 =?utf-8?B?WmdlVjZseWNDSklBRVVHMDQrUEYvdDI5ZEJycVNGa25UK04rbDlFdWlCNlYx?=
 =?utf-8?B?UWdYekJib244RlBuUlczRlJyTktDdkhWSG91QnRhdTY4dDUydGZkNm11ZHkv?=
 =?utf-8?B?elJrdHNBUjkrLy9KYU9kNlVxSHJOTnlCRTc2cTlQcGM3WTFWS3h0Y3IwdnJJ?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05d2886a-e1d6-42f2-d6bb-08dafa79c64f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 00:03:35.3172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NWkEtO6Y+9Bza30Zq0LG6Elwipwp+GMLlXJ06MAptOtRuY+9BvbPVClu2veUkl46aPEjyS4b0WjFaJp8EWPxh1EH4vmT6YgtTnW3WQ7ap+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5922
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/2023 3:31 AM, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Getting device mac address is currently based on a specific MCDI command
> only available for the PF. This patch changes the MCDI command to a
> generic one for PFs and VFs based on a client handle. This allows both
> PFs and VFs to ask for their mac address during initialization using the
> CLIENT_HANDLE_SELF.
> 
> Moreover, the patch allows other client handles which will be used by
> the PF to ask for mac addresses linked to VFs. This is necessary for
> suporting the port_function_hw_addr_get devlink function in further
> patches.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
