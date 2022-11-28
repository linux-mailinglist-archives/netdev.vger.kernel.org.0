Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1373163B5C9
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbiK1XXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbiK1XXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:23:35 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40409286F7
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669677814; x=1701213814;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rKEFwfWNWH9ft+CByMSP5u+UYW01WYeG/4HQFi8LNgA=;
  b=il/mqVBUf68uWHE7oMYIAAzXQSy+10NrUbri6+w9FkRlZquSMO/+yWgE
   jwDIoGeNhLQtcZTXb08XpOisoT19z0MwHqp3LP+JfrQuk89N1Hoj9eHaG
   uQBxOr93uAH5nepEqkjJBgUy7Z5mHbxH440EoQUl7NYxzjJetUvpbC6Vm
   2ceB+HXyQ6lwze3m27lqrKoSBXcjhLfhKqjBbqIfFtgD+gwGSf2YL1n47
   aXgBZE4wVHdAYjmjwSZSadu9+MOJZKA0z+853bClls6nW8kmJzsrwkBgg
   7MfD/V96mIhMC1OMZtcM27ZkgSDcgHHWRiPoiWJkr9qXI9LhS3IgAVPey
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379232538"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379232538"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:23:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="645678516"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="645678516"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 28 Nov 2022 15:23:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:23:32 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:23:32 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:23:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lA2f5vjgJ7By7rWCyNtTaTXYz24BkAW6+RCBpYy9Yom0HMC6MEpT+yosWSsaJy/uJy+83/Fbt46/ey/J4fA6QNXpy+qw8ztdMVG5mUJBBIn8B9P2sGB4tp7V7ucmHJmwCnhZbfu2D89wu8V8XF4c2lY60h1YQUJHHfHdxdUfd1Ca1RTNLiZqABXU5gQ2YdK9fq9EA+xLiGrEPiawtTpxSIHn+dmHNfs4A9MgkP8Tm26hNew5mdg/AW06i6HBNUh31pGWLPh0pfDHlHs+pqRmz2Uu1dp+h9MYjJhIfvI+9lFXPjEXYbiNqiithSr2yZPWebMi47FY9JtEyUyJBhYSzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WftufR16FcD+VU5Z/wPD24GxVcGiAV07PiWMKbw6cpE=;
 b=Ca/FVIv2oQvIr83odzmu43YVq0b/mgLFAOB2ExoCcI+UICq1smVgZaOxTMYuNQICZqpR6G+D8vTd/31c2hxR7c9oIDsT3zQSl3/Rz9f6kjDiD+QW7u9PVySJIgT1LqMP4/+D1IXYrEv3uX3NeZN4BUlXv/y5/t+NDWCdcPz+OHf5CjRJqfL/ldQxddifZnijLq5XNzvej1fLT0Kv1KnyYZUSHkKye78Rg6NlvvJfg2JTHEKtemRORCJrZ53mhh0nMNXII5oj+nET05YKuTfGUZZ7nCoM4aR7qwZGmuTqyxW6mYQEODZ3yhbWef7QNNJXN8LZw6w4AgnLoY0WWeEsGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS0PR11MB6399.namprd11.prod.outlook.com (2603:10b6:8:c8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.22; Mon, 28 Nov 2022 23:23:30 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:23:30 +0000
Message-ID: <f0f7f0c1-e7c5-1083-2511-c94bde3814a0@intel.com>
Date:   Mon, 28 Nov 2022 15:23:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [net 03/15] net/mlx5: E-switch, Fix duplicate lag creation
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-4-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221124081040.171790-4-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0158.namprd05.prod.outlook.com
 (2603:10b6:a03:339::13) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS0PR11MB6399:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c845865-d924-4392-b08e-08dad1978f5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kAR6qlgp3IT/OkFXiTH3mK2CiYMJIE4ye0U42/nvcspZsPIzLtz6B3xftC4tPggqv4PssVkQ5Cb1FpYZhlMRmfASUXxrDpPQfh7fJg0zjgRgBwPB+AZ/re2wsYi6c+z8QsOwJpCYg+EZBg7rd0BVTVpVvv6c+xOz7lVlVSd42w1OPVEu1FFGSHr5vuu5+JhxUC91qmIFOY1c8dEO+UhlppiJxm8sL5brQ1OLEzu9FiB/CXIPoklBLoxiCt4gko5OI3Q3BRvzQMlWwVxQ6cAC+KEoKjZN/3eSL0g1M98Y9RkknZtNGF9O2rmLCniOg1qypZij/NTjDEADghByjKRTQAgCaAUpcLQiCNQYK2wQkEV69JoMkAXgnq7BFbq5uSD+utZQhspT6gVoKMipZJZt63FuPTyiqc1EvCYOaWOWpVls8JLm0VjtN53a+NCWh/bwsRKSVDt+1TBNCteTMX2nMo/7tLNhjO1vaJw4Ve9Wp0+e6SuQg/9ldFvYniAEE1GDT5nK8NeD2w7QL3fGMCdoewrymQ8U+Uejj108ybEbvgBwrFOVwASRZfbmOm+844pdHn451b3bIO9k3H8bbY7joznCbfGKNNGO/FGqcUeFk3GIhwmO3Z9/nvnSr12U9nzYQyhVPbozh/Mpvl/b3FdfWtTVnaOrJD1X2Fv6UpqrDT0U/3SBJhNTNHz9n7VsmTFoepg4q/huAI9RLw6vsIbrfcEeDhhy/mRyDtmAeTzo32o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199015)(8936002)(5660300002)(41300700001)(31696002)(8676002)(36756003)(4326008)(66556008)(86362001)(66946007)(7416002)(66476007)(83380400001)(6506007)(26005)(2616005)(186003)(53546011)(6666004)(6512007)(54906003)(316002)(478600001)(6486002)(82960400001)(38100700002)(110136005)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTNEWGJ4SjJoaGt6Qk9obnhhODloTis5a00vVUQyQjJReHlic1NLQlFhcmU5?=
 =?utf-8?B?K3lqYk1hMUxCQ2xnbGE0VnVpUTBNb3RQdVB5OThUY3l1ZlZab3oxQzBpY3hq?=
 =?utf-8?B?ckVETTZVMDlZR0hSNXNHSzlGcWhtMVZIT0YwWjF1cFhFS3BKVmFQYWVoaklh?=
 =?utf-8?B?L0M1Y0RRMzM0TE1SalNQZG5GOVd6SnhkWXk4azJjVGFUL1pDSkVjenBvZklH?=
 =?utf-8?B?VmtRWE9OS2pMRU1hSG12eXNqNXpTVVdNR3UxajRjK1VnUmxpZ0ozcDl1Yksz?=
 =?utf-8?B?Qk1XMS8xOHdKUElSRkJqbUtsNlYvUUVrdXRidkRNeHZNenlDbVZrSDlSdFg0?=
 =?utf-8?B?RndZbFVYMHh3UEkrZ2MrRUtlVW1EVm83eHd1QjBYZEhrSkI4dnk0SHlHcWVQ?=
 =?utf-8?B?UDR3VlQvaGNxRVlMdzBjNGJuM2FkdVZVWmlKRDBqc01HNmZKTzFBcGF2N2s0?=
 =?utf-8?B?ODZpVFFQQTJidGsydmd4bWpmMnRwdW8wUDJJb1JkaWRORXBEdFRJd0NGQW5T?=
 =?utf-8?B?OC9makJNRVQ5NGppTFhOd3llSk0vN0NKY0F0Zlc3QTRQZTc3ODhwWU1rdmFF?=
 =?utf-8?B?Y0laMElhSDVVU1p5Mmkxb1ZXcUhlL2NBRzVpSlE4RXFWanI2R2ZaZlZzNTN3?=
 =?utf-8?B?K0tFMFN3OVpWL0tZazZXRENoSmh1eXliREoyOUNBRHpGcFVIbFowMjMyeVpi?=
 =?utf-8?B?cUE5K3pnVGErL0dVYjVZK2pSOFdOWjhpa240ZmU2cFZ0ZlR3NnJUdDlMZlIw?=
 =?utf-8?B?bURIdWd4R0dGYncwRkRRNkRpSEVWT1hnWE0vcUZZY0NZdUxaNDdLYTF3NVdn?=
 =?utf-8?B?cVROQjAyb2hWeFZTOFlmbHZOUTdhL0NTVUZpa2tzbWVleUtIVDBZOFF5MlNp?=
 =?utf-8?B?R3pwSEdWRkJKUGZJd2pmY0p1REQzNXhQdFM2R2MydFZDUkVzWGZFMU83OUh2?=
 =?utf-8?B?VXRtYmh2M3NCdlNxSHlGanlFK081NXNMVVFicTF5YUV1ZElmdjNObHV3Ymsy?=
 =?utf-8?B?U0dxQ2UvWjdyZ2pmZ0ZSYmJSUi9qd29LbVZaTFB3NzJneXprWXM5ZzRTdllB?=
 =?utf-8?B?QVkxZnZ5TCt4TW1vblFTRFN4OU1LUHhVRWFCRWRsNVBpVmdmUWQ2RmVFRDdz?=
 =?utf-8?B?czE1ZEVTcHRYWkIvYzlrelEwNlVsc2JNVlBpOW0vT3FFb2l6OEdEL1RiM0s3?=
 =?utf-8?B?RGovYXBkSUtoTFN0WWFMcFQ2TFJNZ0xqSWVFeXJ4SG1QbkN0MXBXZVZDRDh0?=
 =?utf-8?B?QkUxU3lqNkZSTWlwOHZnRktaYnNJSUVlUk9ITVRrM0ZGMGVuRkZCc2dSNDF2?=
 =?utf-8?B?SnhMOTAvajFoV3MvdEFNeFlyaDdDZFFoSHhJYXJZc3U2ZnFwTFlObmxRb1Bw?=
 =?utf-8?B?K1NEZDZxZGhSUFNmTDZIRzhpcHJkRlBjaEw2SE8waDhXUmVTQVI4WlNwaUx5?=
 =?utf-8?B?N25Ya1RueXBaMHJlMkZ6UVgrUXd6Nk9ZUFJnVUVTS3Zwb3p5MzNmeXlpQ1ZZ?=
 =?utf-8?B?NUxFSUVmMXNOTVVZSWtFdkhocmw4RFF1Mm5wRXE0SlVTdzZZdkc4QlU5RGhR?=
 =?utf-8?B?dTBoZWljYVR4L2hubEZaOTRVbzhiSVdBWUpTMHNGMlpNQUMxek5pdGdRY1RG?=
 =?utf-8?B?cEdkU2tXaHo0VU91UUNLb29kVVhkTzhnVkh4QTFkd3VvVVJ6VFFGMWN5QTB4?=
 =?utf-8?B?SDEyeElaUlJqQThEU3dLYndtR2ZXb2JVNlQ4ZFI2WDlkOGN5YTRrWGVNSDZS?=
 =?utf-8?B?VEN4R09tekRxWWNLdTBFbDRHMnNvY1ZKYlBtTDBVaWZZSzNTTmV0TFBId2Ni?=
 =?utf-8?B?R3BSZU9CUjBYUFk0K1V3aTI2c3hWR3RDU0o3SjJSUytEVUNpVmdiYUVXd0Fn?=
 =?utf-8?B?a1ExMlorTndneTdKa1Zicy9UZlBJQXZwb3VsZk8zQStYOTgvL2g0MmFYT1Uv?=
 =?utf-8?B?MEkxWEJKeEVOclJsWVorUWtUNE53Zk9GM1AwOURnbVV6bzdOWnFNckIrZXJQ?=
 =?utf-8?B?TG8yMVY0K2FKTzFPK1lBQUlPeGxLeFI1d0ViT0d3VmFJRlh0QXJzQWhtbSto?=
 =?utf-8?B?QjFVMHBWM3NyRmFqZExCTmJ2Z2NWbHRJMWV3Tis3bXhYc3JCMEVIVTJaVENM?=
 =?utf-8?B?c09BSiswKytDQzl3R2JCaTN4am1lVGMvSUYyTEtpQldIQUc5bHFvSFB0Sjhs?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c845865-d924-4392-b08e-08dad1978f5e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:23:30.3380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KnU0pbgXWcpsrO4e50iueXLWuhP6F9IoUostM8/wyPmybli246JXNpWDELNuBVhHOZLb4NHPmC9bwaz3L/tbS6BR+7vz1tkAt99UIrgWqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6399
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



On 11/24/2022 12:10 AM, Saeed Mahameed wrote:
> From: Chris Mi <cmi@nvidia.com>
> 
> If creating bond first and then enabling sriov in switchdev mode,
> will hit the following syndrome:
> 
> mlx5_core 0000:08:00.0: mlx5_cmd_out_err:778:(pid 25543): CREATE_LAG(0x840) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x7d49cb), err(-22)
> 
> The reason is because the offending patch removes eswitch mode
> none. In vf lag, the checking of eswitch mode none is replaced
> by checking if sriov is enabled. But when driver enables sriov,
> it triggers the bond workqueue task first and then setting sriov
> number in pci_enable_sriov(). So the check fails.
> 
> Fix it by checking if sriov is enabled using eswitch internal
> counter that is set before triggering the bond workqueue task.
> 
> Fixes: f019679ea5f2 ("net/mlx5: E-switch, Remove dependency between sriov and eswitch mode")
> Signed-off-by: Chris Mi <cmi@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 8 ++++++++
>   drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 5 +++--
>   2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> index f68dc2d0dbe6..3029bc1c0dd0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> @@ -736,6 +736,14 @@ void mlx5_eswitch_offloads_destroy_single_fdb(struct mlx5_eswitch *master_esw,
>   					      struct mlx5_eswitch *slave_esw);
>   int mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw);
>   
> +static inline int mlx5_eswitch_num_vfs(struct mlx5_eswitch *esw)
> +{
> +	if (mlx5_esw_allowed(esw))
> +		return esw->esw_funcs.num_vfs;
> +
> +	return 0;
> +}
> +
>   #else  /* CONFIG_MLX5_ESWITCH */
>   /* eswitch API stubs */
>   static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index be1307a63e6d..4070dc1d17cb 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -701,8 +701,9 @@ static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
>   
>   #ifdef CONFIG_MLX5_ESWITCH
>   	dev = ldev->pf[MLX5_LAG_P1].dev;
> -	if ((mlx5_sriov_is_enabled(dev)) && !is_mdev_switchdev_mode(dev))
> -		return false;
> +	for (i = 0; i  < ldev->ports; i++)
> +		if (mlx5_eswitch_num_vfs(dev->priv.eswitch) && !is_mdev_switchdev_mode(dev))
> +			return false;
>   

Am I missing something? whats with the for loop iterator here? i isn't 
used or passed into these functions?

Do you need to check multiple times or do these functions have some side 
effect? But looking at their implementation neither of them appear to 
have side effects?

What am I missing?

Shouldn't this just be:
>> -	if ((mlx5_sriov_is_enabled(dev)) && !is_mdev_switchdev_mode(dev) >> +	if (mlx5_eswitch_num_vfs(dev->priv.eswitch) && 
!is_mdev_switchdev_mode(dev))
>>  		return false;
