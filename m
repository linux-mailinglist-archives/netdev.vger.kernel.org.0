Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972216761CA
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 00:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjATX6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 18:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjATX6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 18:58:32 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F538B339
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 15:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674259111; x=1705795111;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aliLkxoododNbai4zALLncNnjCc1eTQDT63704DzBp4=;
  b=htzaM5P2bX0Vz545YYqdt8zLDbEoGxXUkdh9aXfAYslQE1LecdjqiATe
   8Q2QuMhXa41qsh5yW67+07OkIFRRCRs6O/0vvlZh9JgYX+9Gpsth6tcD5
   nF8UoPUrXBjhnHZArVk1zdo7cNzZzcmj8I+cwYDyesVXb6sHdNbqjRBZO
   LyureeydKedh6EwLWmUzQMo/Q9CgaPv0mFTZuF8gT7MsqEHbMM792QiVt
   NEgzLcLn3Xr0BwDl158AmE19RONElqFgv3+b5w63dX5VLjaEk/JtuxMoa
   pv1aagioFLkagByNdFjub/mX5XA22+fUdIkqaR5ELW14eeSWI3QGTRDaT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="327818841"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="327818841"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 15:58:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="803246591"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="803246591"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jan 2023 15:58:30 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 15:58:30 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 15:58:30 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 20 Jan 2023 15:58:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/dzbvIH/EVKxsfFMHuWULfLC8q5A1Gcjj41alZf6d+oB4v1UT6Co57dquaXppnrhuPBqTQw/+S9TF7CpzGnlHiAcijBZjzOjQczqqkcJHU86qVb8aizm+GqZ27lm7cTWtzIo5LddCQ9E2lUNuD/V5dTcWH3nzfWN0aOKxLet5Ge6i9x1624LnWUJmTpioN3q94y5HDpnjMY1uawz0t2lUcyhRxfAfqC20IEm1XT2JGfnxGKa0u2agO0JGM+xLO8dDV6OMmLwJZGazTnDW2KH85n8ZJxrav/ns0AXe6lUT3JolywE6TOIzzh3S1O1gvBcivYf4p4dVeYXU40JuWhXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRtqvaeFwT462iuuK4GG+bmiHLKd1lsXJ4KPesbbm5U=;
 b=D4qTkJwAYgIkB6iFX0BSxpt73lYjr1YE582loyZeKk37dthxaCiO84dfbp2JmxJA3p7/4HiQ/D/anjElsxYaWvLHVk7uVlSq2sulNg/v7PJ0Y4rrwXjRRFBg1zjQ2v4ZKLOVSu9jO+CdgHPXtr39uVC1IslEq1YEHpsqLgK+FEvIz5qbQ4SYvhpF2BM9kJndXpyeK3NDnil07yasu7/hEAv4WmTrXDDP07aZ3r9fnQcAzziTOhKBxKTqaDJh451YuRjUh9OkpLvQqfcc2lWp9WwKEdUu/KfHwpUWc98+LqQs9vgCwJuU2jN20vu0JmkOIq4AYwiGJ+UXtpX6QP0hFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH7PR11MB7122.namprd11.prod.outlook.com (2603:10b6:510:20d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 23:58:28 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 23:58:28 +0000
Message-ID: <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
Date:   Fri, 20 Jan 2023 15:58:25 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Content-Language: en-US
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-4-saeed@kernel.org>
 <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
 <20230119194631.1b9fef95@kernel.org> <87tu0luadz.fsf@nvidia.com>
 <20230119200343.2eb82899@kernel.org> <87pmb9u90j.fsf@nvidia.com>
 <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com> <87r0vpcch0.fsf@nvidia.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <87r0vpcch0.fsf@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:a03:331::18) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH7PR11MB7122:EE_
X-MS-Office365-Filtering-Correlation-Id: 6746e6f8-2172-4620-2a39-08dafb4239b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09vsD9OKwIyTC897FQPonX5Zn5814yYBEIe6TVLxYmW8HNgxRws/uLgFTppk19BDe9lYZg9IKldk0xtFGJNdmJDyRNEqtIS/MHhsE55bPF3nbDn+9Y0rjSaYJ4ahAlbG+nAO+RlWSx+ZJ8ZynRHHJjrHe390hWTzfolzNVxpzKdCWodumhgwX1QACyhTV/Ok3ihcJoixusTCh6T3eUlJdCwSOjOGbDMI1WxFsNQMtD/MHBRe6fQ9lfSdwjlxHT8KMqXMazRBqxipGYqaNy8l2K1M92umeS2xfnaYVW9YewHd9EAJURcbZH7gmcsOC3LiD3kn9g6xNqumF6fsS/jt66VHOs0F43ea67YMFLLwI0P559cDa5FVZ98bcGShEDZxinWlqIUk4HZmdEa10xiSE8NHY7bx2vkhtorBNbT81nZZ9uF/bN1CKoGdYVHTzTYs7a/7YOdxl3g0v4K2TTipy6JpCoZkyLHNSODHzkBPrBywxMmFtkYnG6xDafdnFshOb7JFFX1qXLs2e4PTIaRFlQNTOL1jOvRNqwB7DmGvW12d2A9QrJAKjX0apy0apiOLD8YSty9lAbJ4HqHQVog/ZERZYap37jyvmLBGKON+iTCrw5fd8/eRaxZhKf3QMySmnuTpIKFPO7kKGBWb1w7w95aP6nRk48QPNOAgKsMK4HYI5rsH8BDVMQqNo6kMeihBn2HJMaFo2l9QpyQWJYq36/Vx7iGLWSk1UZBF6bM+Gc0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(396003)(346002)(376002)(366004)(451199015)(5660300002)(8676002)(6916009)(66476007)(4326008)(316002)(53546011)(82960400001)(66556008)(6666004)(2616005)(36756003)(6506007)(41300700001)(54906003)(8936002)(38100700002)(86362001)(2906002)(478600001)(83380400001)(26005)(6512007)(186003)(31686004)(6486002)(7416002)(31696002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnIwcU1VQzRwanAwYTI3U1hGYW9lUDRqTVZWUlZlVmowa0lIck4zSnZFdklB?=
 =?utf-8?B?UXV0T3E3L2Z6K2tKWW5mdkxjdTdYZ2ZtUndNc0lKMG5FOFpQV09RWnNUY0Mx?=
 =?utf-8?B?YXZwc1JheVlRNU03bWI5QUIvVjhXWThqQnVVaDFxWE1GWURXekJxYklQME8z?=
 =?utf-8?B?QU9TdlQwTlp6YWFVV1JraHQzbkt1VGpQdjJVeHF2azB6OXhpaHh0dmFyQnZ5?=
 =?utf-8?B?VFFDY0srNy9VME5iWnN0S1prRUt6WmFia1hJMFk0c1pIUzhkN1E2Z0VYWUJJ?=
 =?utf-8?B?clkxWlNPVExVSUVXcVcrejhUNEM0am5ucTgzRjhDZGp1TW9HV0hPTk1qWGc2?=
 =?utf-8?B?UUNZVHI2b0MyNmxrOUxBaHVlVnptOEd0cjE1dTVqZTRnYWZtWEVrNUorbVFJ?=
 =?utf-8?B?MTNVMlJoYy83VDQxTzhnVlZzWlBvWDhaRXBsczJFOVVmODdQVUt1czFHajUv?=
 =?utf-8?B?M3lvUlJVcXRnQVJFZHBCL1Q3cWxDQlRjQ1JzSUsrdSs4Q2Vrb0FmbXVGTSsr?=
 =?utf-8?B?R1A4ejk2TnI5SExCTk1zMG9YVDh0SkRxOEJpK2M2V09YdEFFVk12Y09FbEtq?=
 =?utf-8?B?RlJPajJLcWlwdG1rYmh5K0V4Z2dHMzlFQTVMWUtHZFhWcTZCR0hCb2FlMk5X?=
 =?utf-8?B?dnlZdTRldFZyelNwR3A2Y3FYL2ZWSUZndm03STRENzIvUDlIZFA1K25vTjdn?=
 =?utf-8?B?WGxjUDkyTmh5ZDQ4VXlybDhDSmxUU3hzc2lxempEdXNtWnZxcnNkUjhWN3dn?=
 =?utf-8?B?dUxLdXNXZEZKZk5mcEhwbXU1czR6MncyNmtiRU1CblJuc3BoT1lPZFpPckE0?=
 =?utf-8?B?eTUwM2FWSHBSMUQvdFFiUkl3R2lkVFpmZm9Sd2lFNE9DbWt1bm9HS1JiSDda?=
 =?utf-8?B?OXhyckxUMVhFNXlqYU50YjJVVzlNWGJRRmxObzhoMUxzWVlrR2x0SEhOYjBl?=
 =?utf-8?B?bkdXK1NQWmRIKzdQODk2bHhuTy92Wjc1Ky9BZ0pWVmRGWjcrL05IeE4zSmds?=
 =?utf-8?B?ZGZTUlg5dU01R25rbE5xSGhyT3JmZkVvSE1Jbm0zeDhRSjk0c2lRdlVxSUwx?=
 =?utf-8?B?ZnI4TlhjMTJTdFhybGtORk1wdDBaOUlHdnBKeXJldm1rNUEwVGtZWi9QOHhv?=
 =?utf-8?B?RXUzOXlMcldwR0ZsZlFuWmp4TGU3YmsyZjF5cmZWaUZxbGV6QkJlbE5OSUVE?=
 =?utf-8?B?cWVWR3A2emEvL0JvL0hQbGM5ZHVwdTFvRGQwMUFURGVUeGNzUnUzM0NnR2RG?=
 =?utf-8?B?VzJvWUZhUFlUaHhtaXFSQ2ZDa1FhT3lFYjV4aUZJSHROckxWUUtxWjdUZkJs?=
 =?utf-8?B?KzBRa0xtV29kdXZLU0pSQ25jNG5MTXJXSFVzMGh0aGtpZWhLWFkzOHl2MjhJ?=
 =?utf-8?B?LzIvM1ZuZllnbFo3TFc0QnFXOUVGMERnR0xpaEpHY0Y1UFlrWVJlWm51cDR2?=
 =?utf-8?B?bGE3aWtiN0d4SjF2ZVBxbGVVdVBCdHlMeW5BR1cvOVZEajhBcmZMOVhEdlMv?=
 =?utf-8?B?RUNldmhxeUtpK1A2dU1IaWF3b29KRzA2VWJnRC9RYWtaQjZvTUVVdFRuZTZD?=
 =?utf-8?B?TExWSy9SKzdDbEdvcE1HdENuUFhnTnFyOUl6UWh4K0pHakRndEh2ME5ZaGl4?=
 =?utf-8?B?QlNxWlArRU9BU2ZBeHowWGtBTU5tdy9kZEVDTHBUanljSHJNQk1NeTRmQWF5?=
 =?utf-8?B?WVQwM3hYS1JFZ1laOGIvTXdYMzVCTDhCcDZTN1NCUmgycW9ma0Rndk42TTdF?=
 =?utf-8?B?Uml5M1NaREFNd1o2Uy8rT2hYMUt2dGN5bkVIQktwKzZoN2p2bVlsSGJ2L3Rq?=
 =?utf-8?B?YW1zaS9rck8vNmVreXI5S3dvc2NwdUVoek1yOXBxSlNQdStZNGRiUnlkc283?=
 =?utf-8?B?ZGVnd1JRSEJ5cDdPYnFEVmpyK2o5MDZvNHZaS3pXY1E1QWk3ejFwNG8vV0J5?=
 =?utf-8?B?RVpxU3VqekFIOWdmMnhvYitkRlJuMUtxZHQ1TnRtV2FpM0h6Mkt4bzJ2R2xQ?=
 =?utf-8?B?VG5RMVp1TmxLMlZ5TlRhMlU5NVAyakU5a2lFb0JPVXFtLzIxalRZZEpUd0s2?=
 =?utf-8?B?aFczNHNpclFmUkhUaU95MS9ZUDl5emxwYjBpeTVueTFzeUF6SzdiU0J6OTRr?=
 =?utf-8?B?VDFDMFVTZmNRc0F1QmI2T0JWSE4vdDFwR0JFdWpnQmdudHduZ0p4WE5MNDFv?=
 =?utf-8?B?U2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6746e6f8-2172-4620-2a39-08dafb4239b8
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 23:58:28.2692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5JM2c55t7c23rgL4bxPTPNnMWj4ky+O1wliv5IoKzxyFVmaTsx8viZv/VYZfi2eEKcMN8/Z3f8IzyAV1lDtZFM9HqE9h+q5awnE2L5bPlXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7122
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



On 1/20/2023 10:00 AM, Rahul Rameshbabu wrote:
> I assumed the phase control word is more than just a simple one-shot
> (atomic) time offset done in the hardware (at least internally what the
> hardware does when implementing this control word).
> 
>   adjtime modifies HW counter with a value to move the 1 PPS abruptly to new location.
>   adjphase modifies the frequency to quickly nudge the 1 PPS to new location and also includes a HW filter to smooth out the adjustments and fine tune frequency.
> 
>   Continuous small offset adjustments using adjtime, likley see sudden shifts of the 1 PPS.  The 1 PPS probably disappears and re-appears.
>   Continuous small offset adjustments using adjphase, should see continuous 1 PPS.
> 

Sure. I guess what I don't understand is why or when one would want to
use adjphase instead of just performing frequency adjustment via the
.adjfine operation...

Especially since "gradual adjustment over time" means it will still be
slow to converge (just like adjusting frequency is today).

We should definitely improve the doc to explain the diff between them
and make sure that its more clear to driver implementations.

It also makes it harder to justify mapping small .adjtime to .adjphase,
as it seems like .adjphase isn't required to adjust the offset
immediately. Perhaps the adjustment size is small enough that isn't a
big problem?

Thanks,
Jake
