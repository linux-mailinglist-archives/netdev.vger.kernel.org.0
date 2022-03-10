Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEC84D546F
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiCJWQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbiCJWQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:16:28 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E546197B45;
        Thu, 10 Mar 2022 14:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646950525; x=1678486525;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YpW4YUv7uiavmQMWZME6TFy743TYotFi42/exPhVCPA=;
  b=hc8k5APnbucPOm80mUXRYgNKpV+vt2f/pqLPl6lTF/K5phC3HFO6skkT
   +pUWQ+23b9CZ4HEpiVQUYtUZptfW9yac/yCwOsrJ4+7ZzYNpFRXGwb0v6
   kIJhK5sMW1/ZsVGDd7g3z1rXDk5IqM5QsWROBIfqavmh+SkS8LFvgCmtX
   uHUmCWll6ntNRR8VTE27llzvCPV5sIKDeb2nqnUNk8oufPiYpNylgcDuk
   ritEU5LHrK/xcLhnzGEzVToeV3KI3sHyfqROG774clpTKL1tk3eBU1KNc
   36hVQqIsKgebcwgt6BEGn/BpG8HMCH1MHW8cDY6MXBUzrUP6cW0PqvrAw
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="255343495"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="255343495"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 14:15:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="596845517"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 10 Mar 2022 14:15:24 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 14:15:23 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 14:15:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 10 Mar 2022 14:15:23 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 10 Mar 2022 14:15:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIrB+NUKUBVQuZvtTneyJT1JZcUiDgo1pYjGYV6L7d4R7E/BrR5MxaUPkRWNaeskss/qwIgAU2/XksX/CNggQJdkHEeTCgSHtNstS5auVJh7feEZlqAfbSjTSyiAgwUidO47lw6Owb5/wZEjN9uutOaCOHtj0tGbKHGCVYBau4cYTQNuEhEIfXTVkdv+tYV71lLpaTOI0u7Qa1Vqz4lgDPf4D84MFTqWly0v1QPT2Hjznpcna3pE29vXa/QuBCJlwYibtv1QcFtlrbshQ8aYGAFtkw60kDmkshmbZ6AKEeeiB9Lw6ZYQmf5m4pLP7Ry+7hnwzjuVK30FLcvU3yApPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4r8iZGy5qR2O/uRJ+mWPq2EeWT1BwydZfRRSuovFFEs=;
 b=Vr45Xl3gyjYekE2RShh6b9lF7/dTyT3XctS/E/jkdMm5G9fiGCJIjeI87rHcl+I4gAIqyiCZ64pWfGthWK4V1kgZtK4AIpBJMnEIbh2Bg0phPAo1SvVSU4QOJVqrNcAG2mIDzoaqqhP89Sfv69Ee+rXhH5aOD9S97HbCNAFu305a5HLPJJEnWetzAk+PsPuP1RZJ+aNoWwxnbs5FCeqyafV6MtihbWm6dI+W8+vfDVkeGxoOH4nCdqZPsZk1ivR8Yu6r53bSLDER1fgam6IkepDgGRezZAzvTDd8Nybvgh4fHRi1x3GuYugy9NPTNXnU+ivjgYk/xMSJUTdRv0VMYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DM6PR11MB4170.namprd11.prod.outlook.com (2603:10b6:5:19a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Thu, 10 Mar
 2022 22:15:21 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81%6]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 22:15:20 +0000
Message-ID: <501deae6-07a4-1a43-dd52-fc40a409547f@intel.com>
Date:   Thu, 10 Mar 2022 14:15:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net] ice: Fix race condition during interface enslave
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Ivan Vecera <ivecera@redhat.com>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>
CC:     <netdev@vger.kernel.org>, Petr Oros <poros@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220310171641.3863659-1-ivecera@redhat.com>
 <20220310135901.39b1abdf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220310135901.39b1abdf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::22) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6734f51-19f6-4fa8-8508-08da02e37728
X-MS-TrafficTypeDiagnostic: DM6PR11MB4170:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB4170FF52161FE05AE43057C8C60B9@DM6PR11MB4170.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LHZwcnQB2mHntW5ufHnYnftzEtTdO34GmM4DoFR2sGNXSy2YAJwl+hW47y8t2YclxXRDRXL/YHYqJ+aiprLdc7tiODHosQ2dJ06Kc3uQMg/1Y9y4hOwDRcSCTx3shMkVbp4iDtNrUHTH5St6C4pajVM3pt7vomnHCaTu+av+0KfjBB9ubREt3/3isXWBBFK09/DZ7+hMF9CSISKc7CxRzZlp1B2IUDzr36iiLvy/rkUp3or49oAcKJ7z35eCttYzfxJLIeE7QqUmamsBWnuqMKZ1AzKSWZlLtaOZe3Oa4Z72uKFzRrw0vgKyjEciAgjcORlW5rWMy6HXSoY5my2y04UO5r5h3ZxhGr/GTgmGXXxI/9CwNNFXL+2pv6G2fA/uMHNl1fQOeCg/P4EXR5tiPDXL2fn9XSFzVlCFDVI7cejWMXmaIfaErUfq+dyASYv7KV2o9EQewEzdG3/vngqBeGGCegz+Imkp6ENYvc4LTjza2icjuSKP2+7Xokj1+9kjvE6Eudtw0uF+jukzb+2J5Vt7XEVAxZuOiZoVANr2IWvMxPxDMKcPZs+Mg7hFcdhLbPq7yWmahrwLwSn3KvRjOiHMR4JNcLwrJMjdOGBLiKhBmRZcUHSTWeHFh/FOaVjcF99QMsY4RCEg6PwN+u+IQy2E4tcYfzTiF0s/pUm46UY57qzwd8QTrqO+LVhSvUjOZYAxBmwJP/4gSRen7PKd9NFZ2Q9CQmt0n3TFoDdi+Zg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(8936002)(83380400001)(2906002)(36756003)(316002)(53546011)(6666004)(6506007)(6636002)(6486002)(110136005)(54906003)(508600001)(2616005)(66946007)(66556008)(6512007)(66476007)(8676002)(4326008)(38100700002)(31686004)(82960400001)(31696002)(86362001)(186003)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFRjWnR1NG1LS0kyMTZQS2NhL3VBRUh6NUR6TytOV1FSZjFwZVhodTZuK2NB?=
 =?utf-8?B?M2hxMHBjYmxXcUtua1pGakJOUXIyVHJQMkJXYnBrUFE1OGFqTXpkbGN4aS9F?=
 =?utf-8?B?cHNFS0RPcHJKZDZPdklQSXZ0bHE1TlBpWnBwNlpUWWF3ay9BWWR0VC9KWXNQ?=
 =?utf-8?B?R21mWmZPcUdhclNYMzhsY3ZpajdweVVuYlFMR2hVTTRiS1loUzduQmsxdWEw?=
 =?utf-8?B?Yk40SnJJL204RE1sWDZ2eWJ0ZVVFVXM1MlZ1cEUxQmEwY0pZRFpMdTUxQjNm?=
 =?utf-8?B?enZmVElTd0E4dmpOTkd2Rk8zOEV6cytOZzlzblBLSVJEREVYQkxlTDJYdkZW?=
 =?utf-8?B?UTFNcmdFQmNjNEw3RHVHRzVtMnZEMFhEWlRFUEVhNWVWZnhsenprY2MzYVBp?=
 =?utf-8?B?dFZyWVJGVVJ6UTh1bVVKUVA5VDgyY2tVZUFFb0lodUpiSzVvWjBQNm5DT3pZ?=
 =?utf-8?B?TEd5bmw2MmRqZ2trVEk0ZHczY3NZcTM4bHQ1b3l0QnVwSVF0NlRsd0R5N0k2?=
 =?utf-8?B?YVRidHdHelJnQkVFSitlNVROV1h6TmVra05JZVMwdzZlWWhWaDVMNG5uM2Ew?=
 =?utf-8?B?WG10emJabEU0K2hiaDFkcmY1QkdxUU5ReG02TDJxOHdZd2FzbmNmM1NLeVNJ?=
 =?utf-8?B?Ym5TcE5GUlJBSHdhSUtaQXNUZll5SGZLVllKTDZTZDBnNUVwL3RxMU1pVStk?=
 =?utf-8?B?SmlTbUYzSFFtaXU4RHJjS254blczQXFPRUdueFdIeStrNkM5SktrUC9nV01x?=
 =?utf-8?B?VmxWUURZTk0zNXd0MC85N2hpWmE0NERERGdwbk54N1djZVBGZ0FRRXpTMHZN?=
 =?utf-8?B?Y3JFZTlYQVdEM1ZxWkl3NDQvU0F6eHVZeDFXL1hHZ2dkVk9QV0dIL1pIUGVu?=
 =?utf-8?B?TDZJNHlCWm1mNEJjUWlMb3pLdk0yY3dtNU5YME03Ylo1ek9pVGJIUWEwUk9R?=
 =?utf-8?B?NTk2cGpMcGdaU1RLOWtIUVhPUmJrY2V1VjdNR0FTK28vTHVDOVRUaThiWXE5?=
 =?utf-8?B?dnAxVHFLVEgwbU0yZDBCaXQ2cy9TdGJvNU1GSnRPRXhPRTBmcGpiczk0SUkz?=
 =?utf-8?B?YWp2TjRGR3lxVzVIQ05OSDh3YXRIRlpTL0FtOHZFNkFrZm5mM2g0Wmg0R3lo?=
 =?utf-8?B?WVVjRVYzK04wQys2QmF5dnFhd0NjbTZsSU03V2oyd1hYZ2dYSnFDK3A0dk4r?=
 =?utf-8?B?ZUZPSEszeVc5UVQ3RkpwOHJmUTl3Tm1PTFAwV20vN3EwT29rK0JmR3owU3Zl?=
 =?utf-8?B?VUcwc0MxUHY5cTJHYWt4YWt1dGxtU0xzdVJGWDN3aHBQR0V4bjBqZ1paK0R3?=
 =?utf-8?B?WUhlZUxTSTRnNTIvTTNzS3BubG9rZ0I0RnFpSktvQ0V3ellJdXR4R2JXMzlU?=
 =?utf-8?B?YUpVZ2ZRWHdVVTFWM0dOVWw1L2htazZHSmFvZy9NbXZGV242VUFUTkpTOFk4?=
 =?utf-8?B?MzBNQi9ESlBWVW90Qy95UHpNS09OVkk5RDhaaUpYYnIyRmlYVlRmdWs2dVRM?=
 =?utf-8?B?dHFIUDF5K293LzRENEMwUnRWa3EyakNuQ0tTNVhUYmY5T1FWVFVERW9iRGJh?=
 =?utf-8?B?RU8wclpseGd5dVF4bTBGMDlnWGlnZDc2ZFR6K1V4Q2JtOC9HeVo3a2wvd3ZP?=
 =?utf-8?B?N3FIbXY0UGh4YlNjTlRQVVJRb2wzOHY0dWxOVDR2QTgyLzN3VE9ZelJKN3Z0?=
 =?utf-8?B?YWljNE8vWS9zdzFGV3lQNUs1VFhGTUdZd3kycWNBeGNOTzA2Y04yTFFteEtq?=
 =?utf-8?B?d3kzazNkN1BCTHh2MHR1SFVWNnlzUGVvMTlVSk9tQVYyVVF5aXdCT3VRdEo0?=
 =?utf-8?B?WFRiRnhNbGljbnlFdGk5Z21kM2srUmh2QnI1NWprd0lqakR1eGt5dG15dDNO?=
 =?utf-8?B?QTRBd2pEVlFBc1RQRFNWTExsWVZFY1A0U2tvekg1a20yc2hCVzFVZFRJb09X?=
 =?utf-8?B?dEVoTmJ1NzRrbWM5ZDhabWNVenpIS0RIQ0RSNjg0czRuYitvdkxuZHJjd0N6?=
 =?utf-8?B?RWtQTHpuckJBPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d6734f51-19f6-4fa8-8508-08da02e37728
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 22:15:20.8197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wvqadLV/9k8KJ+eXAm+weV/A2kv9UhLPhKduOYu5a2+MHGWdDhhg3EvBgY1Sixi98hgcmzZHqAGt6Tm1eNDmFMMHwRx73/0QRjJ99/kjx3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4170
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/10/2022 1:59 PM, Jakub Kicinski wrote:
> On Thu, 10 Mar 2022 18:16:41 +0100 Ivan Vecera wrote:
>> Commit 5dbbbd01cbba83 ("ice: Avoid RTNL lock when re-creating
>> auxiliary device") changes a process of re-creation of aux device
>> so ice_plug_aux_dev() is called from ice_service_task() context.
>> This unfortunately opens a race window that can result in dead-lock
>> when interface has left LAG and immediately enters LAG again.
>>
>> Reproducer:
>> ```
>> #!/bin/sh
>>
>> ip link add lag0 type bond mode 1 miimon 100
>> ip link set lag0
>>
>> for n in {1..10}; do
>>          echo Cycle: $n
>>          ip link set ens7f0 master lag0
>>          sleep 1
>>          ip link set ens7f0 nomaster
>> done
> What's the priority on this one? The loop max of 10 seems a little
> worrying.
>
> Tony, Jesse, is it important enough to push into 5.17 or do you prefer
> to take it via the normal path and do full QA? The blamed patch come
> in to 5.17-rc it seems.

Hi Jakub,

Yea, it'd be preferred to make it into 5.17. Feel free to take it directly.

Thanks,

Tony

