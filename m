Return-Path: <netdev+bounces-1469-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E9796FDD87
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:16:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D30C281361
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E60512B74;
	Wed, 10 May 2023 12:16:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A72F12B63
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:16:28 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B087EF7;
	Wed, 10 May 2023 05:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683720983; x=1715256983;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=a9rx7MZ4u6Mf7caKRiVri47VPK4rzW/aLmdtbS9YcL4=;
  b=XlEh/bb/NYJU9cdtyqSfAGhL+mMndpdrGi7g2jKoErV5YaLCZ3mgM8px
   K/o4klK1JUzhRCy1EcK9rN6RoZESyuutdlDsYMtuhwwJzCKk0dLD1w3o8
   iBaplYLhon8V4O2H/Euijh3iZWjWbKuBQZnfs51biNplGfSrtT6iET3d/
   BkAKG1CY9so2IgiwBsf++ydYiK2cw4TCWIye7B/UJBrIL9vkE6NTZFWk4
   lo8fxL+SQqQvTb5qIUY5UArB6hoSaEXAVx2qER3l/vRp8lZYU/uoNFIaj
   4W4IkHLi47ZthWx/ejUvjVnnQDAUYQNmNR3lJNUcTyZ7Qmi9Gd9EAk/gL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="350231930"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="350231930"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 05:16:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="699276592"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="699276592"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 10 May 2023 05:16:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 05:16:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 05:16:17 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 05:16:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZfYb5FXM8Mw1GWnAxmfhxQ6I4JVNmk6akn5eRKO4MkL5R6y7VgPMd7oAf3IIw0VqWLUs/P4OixUAhO+0VbTEflDjJFGjoCH/fbp0wYHYTlAf9vvsm45bbq8KzyaHum0Iu4lKRPIOaekeFWwHgaVxVdH761Idd5RarzlvjAr9sYY0Hab3bSP535gaYcgIrl+b9gEbOakEkJjx1MREJ9MiSS2Ap09K8MGpzQgjEZgOTvxiM6zOgZGijlvtb/YikCnGfq8gYABV4+/ZWOF+0F158Hg3N5zTq14pjb1tA68vKiURRQcGKcuEbmenzR24FrKzYr6yvnnYVHoMMKtJi47Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5sfxgFDH7bt3iVHtm0qr/6CIPJH4h9nubaKFQ4DMz44=;
 b=GKxPHikaVbtuwK5FVBY7ehNNMWgluFXt+/x/ay6LoB/SiMwLzX/CFcxzUfkdBx6Tzngxj91U3YSjv9u3lf4DPLLCFxutasYPCbbasYAJqkowctw5FT8JCDpoMPDqU60P9Z+02r4HbgXovgNHph3eWu4W+jhTBzBq9d2fbSpV5/omj8iywYMwNKmYuQVYSyXIS2J9lLG0hbsOJYrSk10bJtUNXwlhecVVWgMjfmvXWuEmFpRiAurHWbxWxG0LSaTXco2jMjN3RJ6R8Wp89+co7EGH8fF8zdmIyZLw7bb3xNw/VLQw888veEKKKgdo1qxLUmZPRLI3t0GsCtlNWws5Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SA0PR11MB4607.namprd11.prod.outlook.com (2603:10b6:806:9b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.20; Wed, 10 May 2023 12:16:15 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::66f6:544e:665a:9bec]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::66f6:544e:665a:9bec%6]) with mapi id 15.20.6363.032; Wed, 10 May 2023
 12:16:15 +0000
Date: Wed, 10 May 2023 14:16:07 +0200
From: Michal Kubiak <michal.kubiak@intel.com>
To: Ding Hui <dinghui@sangfor.com.cn>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <intel-wired-lan@lists.osuosl.org>,
	<jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
	<keescook@chromium.org>, <grzegorzx.szczurek@intel.com>,
	<mateusz.palczewski@intel.com>, <mitch.a.williams@intel.com>,
	<gregory.v.rose@intel.com>, <jeffrey.t.kirsher@intel.com>,
	<simon.horman@corigine.com>, <madhu.chittim@intel.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>, <pengdonglin@sangfor.com.cn>,
	<huangcun@sangfor.com.cn>
Subject: Re: [PATCH net v5 0/2] iavf: Fix issues when setting channels
 concurrency with removing
Message-ID: <ZFuLB7QwaWMzfY6F@localhost.localdomain>
References: <20230509111148.4608-1-dinghui@sangfor.com.cn>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230509111148.4608-1-dinghui@sangfor.com.cn>
X-ClientProxiedBy: FR3P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::10) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SA0PR11MB4607:EE_
X-MS-Office365-Filtering-Correlation-Id: 611c806c-56d9-4d28-6c1e-08db515059f3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4/Qnpe2E1cNIg58bcuouVb9MPAejtZplXkoPizL+FuxuBZ3pNZ9cxc54aya9rhWglHNeqdqnNCCjOkv+SMMF7wwOz7lWvU8BJx3+0t6JBuHUkUjb71QdEnfYaFDbZLQbTAJSwGhLPRYjgovmvsQhe/i2WiSzuL1a99jLUJj8Zs440HA1Haotu12F96U2hvDrMVc0fQarqajmw4K1QX9Vtqjo4PE9G/pD+SLh7ueRrjqB6ah4wYWq22Xji2vUd6iJir64yilsXRdJ1VDN/ERTrKauuVZS8M20Xf0YoMirGveDeg7TpdlSCYnQTe8VBv+qhc08209n80S0lau4/BvOsMwVGEosAOANsPFA+fOspqXeLYrATqLgUTaRpr0xZ7DGlIbfJCr6zEhbAQw65DSroUKL5QFe5CsDnwIJsoqgJwAbA/qcDYcs+2fTbugBWRD5wbIIOrWOsdmCbUQ02Uqw8SNhfzfmx8qQ2sNXBW94jD2YQc74vwA8g+Ltsp5i2WYHH3la2flGS7K63gu2stgwkfjy6Es8pCMonmhOqb7sC/ktVG4FYNwrROp/T5xOPCaf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199021)(6486002)(6666004)(66476007)(66556008)(66946007)(4326008)(6916009)(82960400001)(2906002)(7416002)(44832011)(86362001)(41300700001)(38100700002)(316002)(8676002)(8936002)(5660300002)(478600001)(9686003)(6512007)(6506007)(186003)(26005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VBb3AocJhbX48XUMk2x2/oCrSzWAIf5k8lkTXpeewWyYm4IS0Os5GZVTHhFu?=
 =?us-ascii?Q?V0sg6Fss2Gv1MPc3ejyJkKNwkT5jSeTDkahm68npGfHccmH9Valtr6iu1BZD?=
 =?us-ascii?Q?Nwrh4XIHRQD/52UBsTFUfInS/8eOHcYPCJa4cekAeAI6sjCCpT0683/wCjwv?=
 =?us-ascii?Q?ubc0GrR0KDkprUcCk/l1PohjECnDTbSuQjM5ktqR1Id39zVLcR6C0K4g6jpd?=
 =?us-ascii?Q?j6gtD6m+65dOCq11WX5IXQwqll4UxHeEDicwEpWFCPRjC3St1GNkgXm3JH2S?=
 =?us-ascii?Q?RL+wF3FBnRnZIBUhZdMFEJWI2hpOSsF5QygIBhK0IjYGDJ7yxZgVNv6hTz8b?=
 =?us-ascii?Q?fqCSE3/movaVXBMjLBC1dr+wmC/KOKmtgtR2a8ydSCNigfAD+CJIfWU5UBEY?=
 =?us-ascii?Q?LltrDxO5T7if7RfoTBOoMfkA3/aZjJCG44MHnmyoku2WZqbo7ona16j0T7cW?=
 =?us-ascii?Q?zs90RIvpukDJVNKVNEhx0JJBwZt76V5KKf5QsZ4EWFdCve5CZa5ZGdzkma0Z?=
 =?us-ascii?Q?w1vZKCEtbdEWwf8gou/46fUeCXLH3oxO5eMzJ3a3rW8NANb9lcMVS44/VGCC?=
 =?us-ascii?Q?exxNTmC5Kf2npi7u1JEzdWQBpH59eBCVnpfAMmaf8WbtaKMPlowS4XgEwCjN?=
 =?us-ascii?Q?QVqN5Zq8HGW5cVRvSnAu9gVol8wU4QoUbMCArDSYDzOTjNaCBfTFVNb9/wRT?=
 =?us-ascii?Q?F61oE9MKUA2XIyYXrfaVdRlwoxnK0xMlVzYDPi2rcq46bC6NEexIl2m5iRTq?=
 =?us-ascii?Q?5IaPF3i4glNHQ/HmZigVFd2gpkCLW4p81BOzpiYGhaoLYgvOZ0wrzmUpLQsH?=
 =?us-ascii?Q?Fhdgo8rOONMmDxEUAO/MIee6Hm/lJRDzVhLZ5KVAl57YzLNdMaYwtZ5HE+xD?=
 =?us-ascii?Q?BX3kXxeiyPoyX7LeeU/dAnsXGdFJc6NbzwB8/njd17AiBtpfWbFjn5aP2oz0?=
 =?us-ascii?Q?mNKY0VG8wVN00FzDLK/syZv8jW0AgZa+nDVDB8wbzyZhQNTf1/TOKR5wOhgx?=
 =?us-ascii?Q?0J0MviETNvSs2pd6V712sRfzRCg/4TpkzgqEBhc8os3/RBlsdncB4YXDRlwO?=
 =?us-ascii?Q?IaGE0yGuCjHbUx4ESiIZyA/r4zrcOaakz8aa/j+eqBJHj/jAledAYetxMPxM?=
 =?us-ascii?Q?6yxugZEq+XOk2G7efVAQGnqhha0j/rSWgxH8d9FNT3UcsZQ+abu3En4LhKOl?=
 =?us-ascii?Q?E4tUK79+tB37yfqqR5GXYtEr4bEkB9y821SWgw54PawiVul0rm9ptDDCjsoJ?=
 =?us-ascii?Q?3ZTuDuG8swemQr7RGO1nrIPumKzu5FFKgSIr2ptf31gg6ROhxXeolil0rfh4?=
 =?us-ascii?Q?AwXsotFIn+KW0j/1E7OldNU7LFVyGIf5oDVQxiVKEFAjUXAJNVPZsfbTNJ1G?=
 =?us-ascii?Q?nIMjf5x+3KaYwz/HNj3KEFdPTjXNwmij/nRtD/n6fEQIiG/9nXnXpPc4ykZ7?=
 =?us-ascii?Q?9RqenMyQRM3Djiakn7Ngq3Fh/ioxKGe2knmrXGGoJAgqCgOoLGpVvsn9eRAt?=
 =?us-ascii?Q?I7xbaeO5uzLUBYMiD4i1/lImbuJoi6pc+zgL6yA8t46FNI9rvFN37l+Swj2L?=
 =?us-ascii?Q?9EpyydZeIOh4uVjuOcPBa3jZWdtjkL42ZblBibtO4D2AAl2Y+c3yhFHT9dez?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 611c806c-56d9-4d28-6c1e-08db515059f3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 12:16:15.3566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZFxkIfQTKz4LxOSbG3MQfrYgqsX/qYC1uGJoBgiemHxQzbb0GAsRVU3R/pvhErHMA3Dj1Clu+XScWj/cT3KFIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4607
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 07:11:46PM +0800, Ding Hui wrote:
> The patchset fix two issues which can be reproduced by the following script:
> 
> [root@host ~]# cat repro.sh
> #!/bin/bash
> 
> pf_dbsf="0000:41:00.0"
> vf0_dbsf="0000:41:02.0"
> g_pids=()
> 
> function do_set_numvf()
> {
>     echo 2 >/sys/bus/pci/devices/${pf_dbsf}/sriov_numvfs
>     sleep $((RANDOM%3+1))
>     echo 0 >/sys/bus/pci/devices/${pf_dbsf}/sriov_numvfs
>     sleep $((RANDOM%3+1))
> }
> 
> function do_set_channel()
> {
>     local nic=$(ls -1 --indicator-style=none /sys/bus/pci/devices/${vf0_dbsf}/net/)
>     [ -z "$nic" ] && { sleep $((RANDOM%3)) ; return 1; }
>     ifconfig $nic 192.168.18.5 netmask 255.255.255.0
>     ifconfig $nic up
>     ethtool -L $nic combined 1
>     ethtool -L $nic combined 4
>     sleep $((RANDOM%3))
> }
> 
> function on_exit()
> {
>     local pid
>     for pid in "${g_pids[@]}"; do
>         kill -0 "$pid" &>/dev/null && kill "$pid" &>/dev/null
>     done
>     g_pids=()
> }
> 
> trap "on_exit; exit" EXIT
> 
> while :; do do_set_numvf ; done &
> g_pids+=($!)
> while :; do do_set_channel ; done &
> g_pids+=($!)
> 
> wait
> 
> 
> Ding Hui (2):
>   iavf: Fix use-after-free in free_netdev
>   iavf: Fix out-of-bounds when setting channels on remove
> 
>  drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 4 +++-
>  drivers/net/ethernet/intel/iavf/iavf_main.c    | 6 +-----
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> -- 
> 2.17.1
> 

For the series:
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

Thanks,
Michal

