Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810076C1187
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 13:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjCTMJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 08:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjCTMJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 08:09:08 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FDC2685A;
        Mon, 20 Mar 2023 05:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679314142; x=1710850142;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NrM7i/HzF4MWYWkmn2zen6eOiLv4oJT/kX2mcRUOiRU=;
  b=QJecRGfRqwAARIInj8GA1eNaSybxwkIeyzR6H1g+GKan2oSHp5oa+H27
   0FpMu4wS1tkrmBVRdM73cn/opARAtwqG+5fFIZDmtaospXChPWr8jQMJH
   qUFYfB4tlmDiF3hCedBnf8A4VnsuoMNJWy+yaorpR1fgLokKthWUli6KN
   sY+x2RkmABJQYpVh4PQdA7f+WVXnCQizrA1T2iTgFqAZgKMhxxruOUCiO
   zUM+SUYuJdQZQnXzn2ozmtQYEQDgAESwKAc8NczVEbJAbREadjVr7bRHZ
   y3UdT58HSWJ4u311iXDbFe83+ez5PBKC7qJs4M4LXZkn5ExoTl7bI0z1f
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="338669751"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="338669751"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 05:09:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="926938263"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="926938263"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 20 Mar 2023 05:09:01 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 05:09:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 05:09:01 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 05:09:01 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 05:09:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TyTsr9adilGkM5pIA/zfmci33Be3dUMf1Ev3VR+uS1qO298mfmJHmgnUSRnRZIAfq1dyr4CH564GqYJLufzfurpclfPmv+rCkKwWnVUQm01ZUoRte87z2PyaN3Qt+i2n2ffZ9qbUQV0mcihu6Pz+2rF+icGSzBccTKFt3vVs13SQF8ggjrY+zc8WQM+GsTjjfRXo5zCMGLIetS95nIhgXnNMA88CeK9iBXMeG5YJrRgnm5LjgzY5f7tm+0ZXhKiNqobbvT5OPxWUvxHbYMStuvi7SLaMZVmqQjigXGxzr6KkqatUN+Pq8Fgm67DygIdHjpdDay60Eh/7pUQsCXe7OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1qEr7ubkHSQRSufUCyD1Mr3ly9QBNxRGfzPCfaTovw=;
 b=K2mHSG5qG0AFmUmTy6BbopAxKOMW79rEktw/hJXoqYPuQQKn1rydW+ox3f3lCCUfm0peQxd+WzR2TolmRN8nQ0tNVgyCoAgXQiQKO3vY+8UxdaA/vN/58QvaUwL+mGsj1NfErSZmHStFz13txPOEkEba+cRV3qnXA1ixL0GlrA7+NRfUaoPsAdSj46aP0W5jdZVR4ESO63oD+5p65jyzb02A/Qe1PRl75m6+PWUKXSohX6EVhTOHEmWyT4KYwSUgAO9wYNAS531EiHGCEIFKRthfqt9TA9vB+9dSbF1X2A02/tl3bbt/cMi60gTq5gRO+JB4FsN+fWOvNDftNs4wDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BL1PR11MB5399.namprd11.prod.outlook.com (2603:10b6:208:318::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 12:08:59 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 12:08:59 +0000
Message-ID: <dca3f426-e3de-207b-51a0-ae272d2b1462@intel.com>
Date:   Mon, 20 Mar 2023 13:07:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Content-Language: en-US
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20230320102619.05b80a98@canb.auug.org.au>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230320102619.05b80a98@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB6PR0301CA0038.eurprd03.prod.outlook.com
 (2603:10a6:4:3e::48) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BL1PR11MB5399:EE_
X-MS-Office365-Filtering-Correlation-Id: 0daf83ca-02b5-4f74-5d3e-08db293be2b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: evKU05Y0aXXpfqq58dVuYUHHnC4a/N5dv4oeFO6OVb4SrApz8Ucp0xgwlYApnvLf9t5YW+YVqKmCnRX3NAUZF0QP5svGr2uVjO7InYr84i5KdWt5w+1rB2sFv6nxUMg46pIBqWHDlsVssVk2E8nc21uLuXvIKa99ziz91Z6dPia1UNR1+NT8/8sae/nPjeTsjvpkHEHADped0JYnrB2h0RYHFxE2JEQn00WWABE9sCYJBsZWSQRsOeBypOWE3soOx5zkv3HvCxUXgdLPK7zxslJS7KMLAB3pYZBZGrNSoOWz+IEFze/WLobrxyl/wwm66aEF6lFQtHe/CytadQv4PSAJ2/LAlzY0wQ5XrKfhGoTeOw4AeocZNDX6UdIDOg+pvuil1FyIoYBpZjocav8UcOLRQnQ3foTiGJmN0kO+rV9TbLHSjvnrHlFRY52s6bjmW2nwv0hIiUwNX/Ay7MrcvF39BiCXhMmyfZlf61xn0Ejsg530em4pTvn9IhGD5lAcEfvcSNzSPyl5IyVwyRtTesAZqClwzTsT8T01fQLcG8mjZY8/zd8AqDrmwGffRegKC3moOTcWgffRiNqauStA35EPqZaYX+NUAPJtgd6HH387LQUNqhb/qJeB9yJ2/APKm/6cQKcS26bqV1VMJL+7P/vNJnJvFVyNr64cQYh8SwOF3xZhzmYxEEE9SzuQG5rUrfG45f8VFJWsQmPCpOfM2ThY5Kxjcf3RXFm3Bl/GISo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(366004)(39860400002)(376002)(346002)(451199018)(8936002)(4744005)(5660300002)(41300700001)(31696002)(86362001)(38100700002)(82960400001)(36756003)(2906002)(4326008)(6486002)(478600001)(6666004)(2616005)(186003)(54906003)(26005)(6512007)(31686004)(6506007)(110136005)(316002)(8676002)(66556008)(66476007)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVlvWFNVZUJ4aTJweG12ejFJTUZ3MURVL1BDY0pUSitXMG5XczF2N1ZhQWxT?=
 =?utf-8?B?V2lEOHNnWmNtMytPMSt6VGM1aGlLbFBTRkM2Q25WUmVaMEpRM3FlZ3VBYmJr?=
 =?utf-8?B?UFJyNEZIY0ZLakIvV1B3UTJQS09Pa2lLZXBhbzBhYlJOQk0rU0hzakhJNGVP?=
 =?utf-8?B?QkdLaTNWUytkYlQzeUowVE5KU3MzWjVGbzQ3MDZ5b3ArNHlrZFF0aGNtMC9R?=
 =?utf-8?B?cDIycFVIOERLKy9tR2t3SGpsTmNBdTUySE45TUNlcG9oQUhNV1ljNVlDQnlY?=
 =?utf-8?B?SHRaUFNCZ2Z0T1dsbnBaZkgzandsVGRxWkJVRXhKU3dBdUdFSFJZRzM0eFcw?=
 =?utf-8?B?RVlUeVVmYzNybGtpbTlLb2poMXgzZG1ZS1dLYVlQbVJ6VVRUazNnOG4rR1Rp?=
 =?utf-8?B?VmFoVGR0M3J3OTlldzViZFZYN2l6SitPbFFuL0dhQ25FWng1RGtwY1ZQRXhk?=
 =?utf-8?B?bk45bFhqd1JHNEpWYTBjMHpNM2dMNXlkYzZZS016TCt1dUlrMzM2SHNQK3k3?=
 =?utf-8?B?WmVMeWp6MDBUcVVieHFTeExIRmdWQjN0VHgzRjVBMThOQktob05mNFVRb2JC?=
 =?utf-8?B?OWxrYXduUEx3Nkhnb3RnL091ZUMyQUo4TmJESXV5d2ZzaXRaWnBqNzBxOURi?=
 =?utf-8?B?c3BzSnpOU1dqYzhzaGcrR0hMQkI1TG1hWDUrQmhVcFgxaDR3ZWJtQ1o1RTVK?=
 =?utf-8?B?YkU5R1V0ZjFFK0grY0luOFFJajNsK0NMeStiQnBOVndUVHFNNlhSZStFV0Jy?=
 =?utf-8?B?eG9tdTJsSy9SMDQ2TStKaGFMZUFGaURvTUI2T01QeHVaU3pMMXAwU1BkYU9r?=
 =?utf-8?B?VHRLcWc1Nk8xTjVBekxoOFprSnZVRTZac2NUTGh6ZENPUTZtKzBsdjZKYmMw?=
 =?utf-8?B?YlJVbGFSbFZuTU5XdWhhQk9SdE9Faks2UDVtY0NYeVd1d2NhMkVwNWdEdEts?=
 =?utf-8?B?Z3I0QVMxZkx0bDNWK0huVkNPV3ZmbEQ2ZlVLY1B3aks2Q1pWeDNzSmlNZEhP?=
 =?utf-8?B?OUJFLzhnbFVmbklQeWVSY01SaG5xRXBlSE5sNEJqT003Z1NsWXkxS08xaXBD?=
 =?utf-8?B?d2hxa29XSmpqWTBVYlp1bGpSalRwYUM5WU9aZ0lnNkE2S3ZQN0hkcnh4QzJP?=
 =?utf-8?B?M25pY003aVFydkJxUXkwUHpuU2g1cmthN0ZYUm1OZ3pPUW54Uy92Sy9HV1p5?=
 =?utf-8?B?VWs0QllZcXMzbkVhZm1GbVpuZ1o1elFISjZFOXVySU1USmNKR1hETlQzMkNs?=
 =?utf-8?B?UW50WGxEc2xISGJPOGJ6N0xUY0c2WU4xMStrZ2NBREd2VUc5SmFsdHZMVTd4?=
 =?utf-8?B?UVdlM1J0aXVCNU0rTHpvM2dsc2hUVWQ3SzZjelc3Mi80MWVrVmZFbjhFQ2ZH?=
 =?utf-8?B?VEZiLzhjbWtYTFFqbzhCZWZIMm9nOTR0WGhYSEhzSWRzWmhDTUZhVHFhdllX?=
 =?utf-8?B?ZnhpY3RySUdVR05FZHFBY3Z6UnhRbmpqZk4xekEyMUo4SmxNQ2pVWnh3WUZ1?=
 =?utf-8?B?UGJ1ZGRScDdjaXVhUGp1OHBGTGlJbVZXRWcvYXI1MWJvS3FvRHdYZXp6Z21C?=
 =?utf-8?B?Y2pxemNqVkFSek9wYVBkTGpWZS9SM3doL3E4Q25MTEdTMUZtQVFiMXp3aWJi?=
 =?utf-8?B?bG5iZGJURHVpcEc0OGRHVnhFVGNUS2hrd3lPaGlzRUxJS0pvRzV3a0ZvTWNq?=
 =?utf-8?B?MzR2NDdhU2pnditYUVBlMzMzOGJ6eXBjRzh2VFJJcTFMVlRJb2I5R015VDFy?=
 =?utf-8?B?NTZaaTVSV3lNZ3hMSTMzekF5eTZ5b2Z5RURPWk5pa3Z4a1hyK0ZIQmZCTDJP?=
 =?utf-8?B?NUFXSVY1WVNldUVIblN5MlBkYmpySG1XdW5ZT1NrYStaMDd2azh1eFhlWFVK?=
 =?utf-8?B?K3pKNkZBU0h6Q1U4NVZuMjlVRkhXSk9aKzUvdmRKNmt4Y0Z3YlFybkgrYnFI?=
 =?utf-8?B?c2pycG1JT3ZreUNrRmNNamZsMmN2cElvMEVsVVVYdXdhaGZvYmk5dTd2RWNa?=
 =?utf-8?B?QUJTelpxbE13Y3pJWXFVblJkWkJEWTFlMmp2aGJ0R2JVanNRMnpIQXRkNW10?=
 =?utf-8?B?WW5ZQ0c1MEtPb1BqSitVamlOdEpOWWUwRXZCMzNvK0JJNlRoTWppdTJ1N0lk?=
 =?utf-8?B?OElQb0FlOW0yekxUMkhjRFgxZEcydW0rL1lvWU5NcEcvUzIxVlFTZjZXblBT?=
 =?utf-8?Q?s8XQLaGBK8K/0Dary71rWlg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0daf83ca-02b5-4f74-5d3e-08db293be2b0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 12:08:58.9512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3t2XJgEobYoVUHVeBZ3xXEOGrXYeJUUtSCb9mGieHmuQvJ5TjxcwuyHTmkMSn0yvjSHer/sBN2WCsO3GE+CxuSw1gAAdUNrfjitmwuJXd3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5399
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 20 Mar 2023 10:26:19 +1100

> Hi all,

Hi,

> 
> After merging the bpf-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> net/bpf/test_run.c: In function 'frame_was_changed':
> net/bpf/test_run.c:224:22: error: 'const struct xdp_page_head' has no member named 'frm'; did you mean 'frame'?
>   224 |         return head->frm.data != head->orig_ctx.data ||
>       |                      ^~~
>       |                      frame
> net/bpf/test_run.c:225:22: error: 'const struct xdp_page_head' has no member named 'frm'; did you mean 'frame'?
>   225 |                head->frm.flags != head->orig_ctx.flags;
>       |                      ^~~
>       |                      frame

The correct solution is to change `frm.` with `frame->`, but I hope the
BPF maintainers will merge bpf into bpf-next to pick up fixes and
changes like this :)

> 
> Caused by commit
> 
>   e5995bc7e2ba ("bpf, test_run: fix crashes due to XDP frame overwriting/corruption")
> 
> I have used the bpf-next tree from next-20230317 for today.
> 

Thanks,
Olek
