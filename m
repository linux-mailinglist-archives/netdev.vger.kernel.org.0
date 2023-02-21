Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5548E69E502
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 17:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbjBUQpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 11:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbjBUQov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 11:44:51 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8A32CFDC
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 08:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676997879; x=1708533879;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=jcTjLABCiJbXRpbfzmFri6hXsUyuO10o/+Ps+x8oBZo=;
  b=Hg2qApaLDI9IgPh68oPz02gt+n1/DZt685MSpCGsalVLGI6wIY99KE0L
   LPixl6x64+tSh7JFaW08WBao3Q/6XLHNnSk+czfUYGJUIvrM4qeAy2dN5
   0r2yXqM3UBB11qEjj8TxovjcEEpU94xF89J47sOQqMafknWWaP7PrI7dy
   /uGMCKA6Lo7imW1s1WtxNvlBBePrWGT7LGSLsIx/1AZVRZ4VOKQqP4iL2
   PplRj399HC4/vnp4d1A1TFT0+Q3Ajye+0MCS+F3Q3vs7IKyIHZdbcM9/x
   Ntoa1wJYfJz5+FqsDcilTMwUuXGipeID/uhDVfke4EgmZqIySoGlZakfB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="334879698"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="xz'341?scan'341,208,341";a="334879698"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 08:44:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="704096562"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="xz'341?scan'341,208,341";a="704096562"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 21 Feb 2023 08:44:25 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 08:44:24 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 08:44:24 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 08:44:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m3w4RBw2B9t+cwx/4r1dmUf2xac8LbKFwjPjgg9uBb/qrs0gPA0f46sPUq9xg/nPn+iROmSpoo0PRsLAN2sX6EQ6vqQl4yJoyfj9GYI4sSelr6mWDhRE43eDpdih7zu3PtN7avryiAP/+zlNFnNj/kiC6o9OX/hZ/5EpqfDwSPODR0L06jXC089QPgWYFVF2ZVlaGQ7vfslnxcIJSKG/t9riWMYnAydXqLkUHpVkJlA+0KwfH4t1LdgU8g0DvQshLeouiWOXzAKsUhS6fBIkGQkR1MYTfG0JTfbd3zcE4KYsLobF008AvHEwEvWZTc0r9/TstoJrR2RRDMT/i2hW7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gxctYt5Vfn5haPj2AqOLF+ApfiaU/RH0RmtKkosVzxM=;
 b=ZnA5eRIKjDACaPX5s3WvK2vLYP+5J1nWNXhO7LOKE3mweHNA5cQY5p8l04Xdhaxr+grY9QZCVhVIMWKKMbDVHOtaXWipJyeH08gl8kWECeFK+YoLZP3tXuX1wjYuRPyPZsaf9Tq77/3hha4CdxJxXUb1erEVW1qnTqVgPNFrt23W2KI8T/nkzUj06jF4aA1W35AoGCkHHiu70ZEESsFSkhzOM8jv2wIdpnD90dRHVjpmBVkahdvPgfr/DPaJ7Ny8M5tAFeJeMZROQJoJeXGHi7fVNkuc+PIQLT/wnYQKFSycXSw2iZV9tKGC+YXxZTXHEduEf6Bvndlf7M/6N++OWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 16:44:19 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::66b:243c:7f3d:db9e]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::66b:243c:7f3d:db9e%4]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 16:44:19 +0000
Date:   Wed, 22 Feb 2023 00:41:31 +0800
From:   kernel test robot <yujie.liu@intel.com>
To:     Kassey Li <quic_yingangl@quicinc.com>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, Kassey Li <quic_yingangl@quicinc.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH] net: disable irq in napi_poll
Message-ID: <202302211734.1d9915a-yujie.liu@intel.com>
Content-Type: multipart/mixed; boundary="EQB/CcOsoyEfnLnZ"
Content-Disposition: inline
In-Reply-To: <20230215072046.4000-1-quic_yingangl@quicinc.com>
X-ClientProxiedBy: SGAP274CA0022.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::34)
 To CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|SN7PR11MB7566:EE_
X-MS-Office365-Filtering-Correlation-Id: 865fc1dc-6b6e-4097-3999-08db142ae020
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lo4/DoufWaJXddfA7CtINsTY7TXt5HvZ7AF0+Ue1RZmCiA7yq7kJM/rVNavYHEmwSEW1UkizzG3pA/LUwTRFuAEldhwu15RqrifopkCP9vZxARorL9TppqXjyYzYDnnbq0IRBUuTAUevQCEvPNmIBJLftUF+Qg39xObUmlDvg32JYGQ+HVg9nTHDxli+QdOWUPKag55gGVbsnZvm/dydqr0XtD1to2f0Dd8DWC+j5kguzT/+95ldC+vjXp6tstg0wEl5cYFOFJPYHInokZRlp2e6DSaFrTAFiRDH0FMJr8dtVVgdYmNsIjLJGF43E2V32cz8ENIj56DEChwST1Id0oEkc/F1wo0jHOliJXylKExXCsZi3xTddMP2P8hcB+oiP80mzEGYqNaCVMiAriqA/c7Ro62+EVfraZpeG5OKKQYRRRJDBZfGqAExy3u2fWD+8Y4vHGXm7QMOf/o+tBpGf2GT5QrPBXAu9nHukAqiuqntDHJ+XbsyRWKv4x1v4STBKZQsBH2g10VDkAtLHrycA7rgiXF5HqSFz6ln7iK57aWAm3cPet977cLqgXZmiCUq4yy3vXCDkKYcJqNkW2EBXArf6A5vF7yLf/q9NvHsfiRcd+ftjC8UOXtqCl2b+Nc4JwjHV6mUQdlY9hbM2J7YSynQTrGBRxQAP0NdKzHGwH6S32MAxhW3QOfL2XDSjxw71XSwG1HDPo7p+IAPFtA9T1MsQ+KjCCJcsXzgfZ6nJjY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199018)(41300700001)(83380400001)(186003)(6512007)(26005)(316002)(86362001)(6506007)(44144004)(6486002)(6666004)(966005)(478600001)(1076003)(45080400002)(36756003)(2616005)(6916009)(66556008)(66946007)(4326008)(8676002)(66476007)(82960400001)(2906002)(38100700002)(5660300002)(8936002)(235185007)(2700100001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uo0IGoNYaMcEfAjhEW3uSF1JNNfGY5C1N8BK9F8Z+8AiIoMI7v7OmmlCwZaj?=
 =?us-ascii?Q?htmsZYAU64grTdspL9fxbk0ONoiA4dqt2XRQoWzh/j3Fh7Xga3aFkwzBwvRA?=
 =?us-ascii?Q?OwZtUv0oJfD7tBKod+FNi9wohBF+aiq1N4JVdIvYl1lRTnMx6q/iqy57bk0J?=
 =?us-ascii?Q?a6bJeXeLQ5Z5NzRyy1oA+NaqAewkz0sYj8LYhzxAqS4zAP3q+2XQxnf3gxzV?=
 =?us-ascii?Q?3iaORf6eItPy7LXPcYaC+FQQrsfclr201ai35Aa5zesc1E3OBHdPgW991bQo?=
 =?us-ascii?Q?N5lLNsTjubCS6t9DtiduSWkVHn9Pc4AbLRC9VvCZ/HzMiXg5zzGEXYuSmoUV?=
 =?us-ascii?Q?bJNl5qw3YuyVhsq6sdvgV8D+uGVcMsGs0GvAIr7YYtBkWcDSt6wukVFz9yM5?=
 =?us-ascii?Q?iyRe29FRv/JfXKjnV3yTn0QajRim/yLjMkNS6TTR+gIfi/tKC2gcHy4FzRm3?=
 =?us-ascii?Q?zToY8v3wbgDXKG/E7gSeZVl6XlXttYjjVfHPuoCV/3sVZ4mkAnB6bxsXBdlM?=
 =?us-ascii?Q?2MzFoYzI5us6JQNoTinDh7KOK+pbjoupC1pPqHBS7/Id+53FIEc+V+Eqqdbp?=
 =?us-ascii?Q?jXe17GlVUbjowg8Z1lDyL8Kh8ftwMA3jZyQWMHTZrgoFSA78VkOplnkNIOc8?=
 =?us-ascii?Q?IPsl1Avj/UVFvemG2BmJKAqyPlzgFtH0+wyGTXzXcKKZqwobnfttingt6cOH?=
 =?us-ascii?Q?dCVYBLKVysyYv04H6KsE+S2e9gZ45fWjXD+LEnYXtk8MTcpYpmGV3rQZ9v56?=
 =?us-ascii?Q?lgCf+ugLTrZU5HNSFhspNz+VJOvjzEdSv5W3Y3WKb9ASZlHNhskkY+kRl96E?=
 =?us-ascii?Q?gRIEDzQyF0nMjxvWL+aZiQHypLdSjr1gP0+XRACnrjtLfLpQyCjNP8lPfOXv?=
 =?us-ascii?Q?3gG2ew5YdX3AjgokuUzKyYxFtWoA3P0LOZjTJhuX6w4089mObhh3CFSrz+KM?=
 =?us-ascii?Q?YMw6UqIPGd+zp2TSviUTbnheIclqN1KjgQe08NNHHZKb1nMpflgc4b8O4ebv?=
 =?us-ascii?Q?3OgkItADPR3RAotBGHCJaSs7ukkkLu2MLf4iEuKn89lCHvaYdIgzK1kWHkvf?=
 =?us-ascii?Q?Owl2bAKXX1KpvlFC/0is/is9le6Pt4OEhGDdn1ZmjggEhM4+AB+2/pOMvOvP?=
 =?us-ascii?Q?g5VtWrEOOPbmLZPmzzSb4pABC0OX7I2QK7qVXbatroUbH27RxfkZvOQ2qUyX?=
 =?us-ascii?Q?plJiC9eUakwfL7O+WG4mw/fZt5wf+EByA8cQvpjm606+0Mlhx5NbW6uYAjgB?=
 =?us-ascii?Q?wY23TuW0RzusNoLaVMxHbimast048F7oabJPdRF2NsukdvEEYndAZlcR5Al4?=
 =?us-ascii?Q?DlTSO6B8aAKszkoagWUOLd+/tdNJD3IzR7lpS5BF3WLXoE2e5IuEj588KCkK?=
 =?us-ascii?Q?hK7jvs/87eE548V8yVXVKlb3UMr5YLSIfpm19wjtW29YKka1/ouo6i8qVqVR?=
 =?us-ascii?Q?DVvUDT+hGusFiuDmarcCJlTShQvv6zJsm2vwaXzzxFTCTEwTMwL37I9xsnpl?=
 =?us-ascii?Q?Qz/g1G7bXz3wtenDh6VJ4FlehGFLZ06B/XIFs9q5qcXVk8Zqh+2pPKziBikZ?=
 =?us-ascii?Q?RSQNO22Y9aiMwdwDHhFeB+delYGGiSHN3gzkDwQv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 865fc1dc-6b6e-4097-3999-08db142ae020
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 16:44:19.3521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sY9i582p38zPauZghs3zZ78lRTRypK0p4bEwqa3DICsWRNXTPLU+AJAMVo5HeZ8sQcJvipk6wLSwbhmo/TYIuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7566
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--EQB/CcOsoyEfnLnZ
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

Greeting,

FYI, we noticed WARNING:at_kernel/softirq.c:#__local_bh_enable_ip due to commit (built with gcc-11):

commit: ed417c671fa6b56ce9f6db582d21c3a608838929 ("[PATCH] net: disable irq in napi_poll")
url: https://github.com/intel-lab-lkp/linux/commits/Kassey-Li/net-disable-irq-in-napi_poll/20230215-152235
base: https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git 1ed32ad4a3cb7c6a8764510565e15ab46b5fdd19
patch link: https://lore.kernel.org/all/20230215072046.4000-1-quic_yingangl@quicinc.com/
patch subject: [PATCH] net: disable irq in napi_poll

in testcase: trinity
version: trinity-static-x86_64-x86_64-1c734c75-1_2020-01-06
with following parameters:

	runtime: 300s

test-description: Trinity is a linux system call fuzz tester.
test-url: http://codemonkey.org.uk/projects/trinity/

on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):


[   22.476967][    C0] ------------[ cut here ]------------
[ 22.477861][ C0] WARNING: CPU: 0 PID: 56 at kernel/softirq.c:376 __local_bh_enable_ip (kernel/softirq.c:376) 
[   22.479087][    C0] Modules linked in:
[   22.479648][    C0] CPU: 0 PID: 56 Comm: kworker/0:2 Tainted: G                T  6.2.0-rc7-01664-ged417c671fa6 #41
[   22.481139][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-debian-1.16.0-5 04/01/2014
[   22.482568][    C0] Workqueue: ipv6_addrconf addrconf_dad_work
[ 22.483472][ C0] RIP: 0010:__local_bh_enable_ip (kernel/softirq.c:376) 
[ 22.486242][ C0] Code: c7 c7 ec 5c 58 84 e8 f7 9e 3f 00 83 3d e0 75 3f 03 00 74 18 65 8b 05 0b 92 05 7f 85 c0 75 0d 65 8b 05 4c 90 e9 7e 85 c0 75 02 <0f> 0b 9c 58 fa 0f ba e0 09 73 05 e8 6d 98 1b 00 65 8b 05 0d af 06
All code
========
   0:	c7 c7 ec 5c 58 84    	mov    $0x84585cec,%edi
   6:	e8 f7 9e 3f 00       	callq  0x3f9f02
   b:	83 3d e0 75 3f 03 00 	cmpl   $0x0,0x33f75e0(%rip)        # 0x33f75f2
  12:	74 18                	je     0x2c
  14:	65 8b 05 0b 92 05 7f 	mov    %gs:0x7f05920b(%rip),%eax        # 0x7f059226
  1b:	85 c0                	test   %eax,%eax
  1d:	75 0d                	jne    0x2c
  1f:	65 8b 05 4c 90 e9 7e 	mov    %gs:0x7ee9904c(%rip),%eax        # 0x7ee99072
  26:	85 c0                	test   %eax,%eax
  28:	75 02                	jne    0x2c
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	9c                   	pushfq 
  2d:	58                   	pop    %rax
  2e:	fa                   	cli    
  2f:	0f ba e0 09          	bt     $0x9,%eax
  33:	73 05                	jae    0x3a
  35:	e8 6d 98 1b 00       	callq  0x1b98a7
  3a:	65                   	gs
  3b:	8b                   	.byte 0x8b
  3c:	05                   	.byte 0x5
  3d:	0d                   	.byte 0xd
  3e:	af                   	scas   %es:(%rdi),%eax
  3f:	06                   	(bad)  

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	9c                   	pushfq 
   3:	58                   	pop    %rax
   4:	fa                   	cli    
   5:	0f ba e0 09          	bt     $0x9,%eax
   9:	73 05                	jae    0x10
   b:	e8 6d 98 1b 00       	callq  0x1b987d
  10:	65                   	gs
  11:	8b                   	.byte 0x8b
  12:	05                   	.byte 0x5
  13:	0d                   	.byte 0xd
  14:	af                   	scas   %es:(%rdi),%eax
  15:	06                   	(bad)  
[   22.489103][    C0] RSP: 0018:ffff8883aee096d0 EFLAGS: 00010046
[   22.490095][    C0] RAX: 0000000000000000 RBX: 0000000000000200 RCX: 1ffffffff08b0b9d
[   22.491351][    C0] RDX: dffffc0000000000 RSI: 0000000000000200 RDI: ffffffff825bdeb5
[   22.492537][    C0] RBP: ffff8883aee096e0 R08: 0000000000000000 R09: 0000000000000000
[   22.493640][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff825bdeb5
[   22.494729][    C0] R13: ffff88811c6d5b40 R14: 0000000000000000 R15: 0000000000000002
[   22.495828][    C0] FS:  0000000000000000(0000) GS:ffff8883aee00000(0000) knlGS:0000000000000000
[   22.497038][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.497951][    C0] CR2: 00007f2d57caffb0 CR3: 000000011cbe4000 CR4: 00000000000406f0
[   22.499055][    C0] Call Trace:
[   22.499517][    C0]  <IRQ>
[ 22.499936][ C0] ip6_pol_route (net/ipv6/route.c:2259) 
[ 22.500722][ C0] ? ip6_pol_route_lookup (net/ipv6/route.c:2203) 
[ 22.501612][ C0] ? fib6_table_lookup (net/ipv6/route.c:2458) 
[ 22.502425][ C0] ip6_pol_route_input (net/ipv6/route.c:2276) 
[ 22.503215][ C0] ? ip6_pol_route (net/ipv6/route.c:2274) 
[ 22.504008][ C0] fib6_rule_lookup (net/ipv6/ip6_fib.c:320) 
[ 22.504800][ C0] ip6_route_input_lookup (net/ipv6/route.c:2288) 
[ 22.505648][ C0] ip6_route_input (net/ipv6/route.c:2583) 
[ 22.506387][ C0] ? ip6_validate_gw (net/ipv6/route.c:2558) 
[ 22.507176][ C0] ip6_rcv_finish_core+0x1b5/0x1c5 
[ 22.508115][ C0] ip6_list_rcv_finish+0x364/0x46f 
[ 22.508987][ C0] ? rcu_lock_acquire (arch/x86/include/asm/preempt.h:80 include/linux/rcupdate.h:94 include/linux/rcupdate.h:762 kernel/notifier.c:224) 
[ 22.509817][ C0] ipv6_list_rcv (net/ipv6/ip6_input.c:325) 
[ 22.510495][ C0] ? ipv6_rcv (net/ipv6/ip6_input.c:325) 
[ 22.511069][ C0] ? do_xdp_generic (net/core/dev.c:5273) 
[ 22.511785][ C0] __netif_receive_skb_list_ptype (net/core/dev.c:5528) 
[ 22.512621][ C0] __netif_receive_skb_list_core (net/core/dev.c:5538) 
[ 22.513510][ C0] ? __netif_receive_skb_core+0xcdf/0xcdf 
[ 22.514483][ C0] ? dma_direct_map_page (kernel/dma/direct.h:101) 
[ 22.515243][ C0] ? dma_to_phys+0xad/0xad 
[ 22.516004][ C0] netif_receive_skb_list_internal (net/core/dev.c:5630 net/core/dev.c:5719) 
[ 22.516916][ C0] ? process_backlog (net/core/dev.c:5691) 
[ 22.517629][ C0] ? e1000_alloc_rx_buffers (drivers/net/ethernet/intel/e1000/e1000_main.c:4628) 
[ 22.518433][ C0] gro_normal_list (include/linux/list.h:37 include/net/gro.h:434) 
[ 22.519104][ C0] napi_complete_done (include/linux/list.h:292 net/core/dev.c:6061) 
[ 22.519830][ C0] ? gro_normal_list (net/core/dev.c:6026) 
[ 22.520517][ C0] e1000_clean (drivers/net/ethernet/intel/e1000/e1000_main.c:3811) 
[ 22.521135][ C0] ? hlock_class (arch/x86/include/asm/bitops.h:228 arch/x86/include/asm/bitops.h:240 include/asm-generic/bitops/instrumented-non-atomic.h:142 kernel/locking/lockdep.c:227) 
[ 22.521792][ C0] ? mark_lock (kernel/locking/lockdep.c:4612 (discriminator 3)) 
[ 22.522408][ C0] ? e1000_clean_tx_irq (drivers/net/ethernet/intel/e1000/e1000_main.c:3796) 
[ 22.523134][ C0] ? mark_held_locks (kernel/locking/lockdep.c:4236) 
[ 22.523849][ C0] __napi_poll+0xa4/0x2b8 
[ 22.524628][ C0] net_rx_action (net/core/dev.c:6557 (discriminator 3) net/core/dev.c:6666 (discriminator 3)) 
[ 22.525304][ C0] ? __napi_poll+0x2b8/0x2b8 
[ 22.526094][ C0] ? rcu_read_lock_sched_held (kernel/rcu/update.c:125) 
[ 22.526896][ C0] ? lock_is_held (include/linux/sched.h:1566) 
[   22.527129][   T72] /dev/root: Can't open blockdev
[ 22.527469][ C0] __do_softirq (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:207 include/trace/events/irq.h:142 kernel/softirq.c:572) 
[ 22.528738][ C0] ? rcu_read_unlock_bh (include/linux/rcupdate.h:330 include/linux/rcupdate.h:832) 
[ 22.529484][ C0] do_softirq (kernel/softirq.c:472) 
[   22.530076][    C0]  </IRQ>
[   22.530513][    C0]  <TASK>
[ 22.530954][ C0] __local_bh_enable_ip (arch/x86/include/asm/preempt.h:85 kernel/softirq.c:399) 
[ 22.531677][ C0] rcu_read_unlock_bh (include/linux/lockdep.h:191 include/linux/lockdep.h:198 include/linux/lockdep.h:204) 
[ 22.532368][ C0] ip6_finish_output2 (net/ipv6/ip6_output.c:135) 
[ 22.532953][ C0] ? ip6_mtu (net/ipv6/route.c:3206) 
[ 22.533439][ C0] ip6_output (net/ipv6/ip6_output.c:195 net/ipv6/ip6_output.c:206 include/linux/netfilter.h:403 net/ipv6/ip6_output.c:227) 
[ 22.533923][ C0] ndisc_send_skb (net/ipv6/ndisc.c:511 (discriminator 142)) 
[ 22.534453][ C0] ? ndisc_ifinfo_sysctl_change (net/ipv6/ndisc.c:472) 
[ 22.535116][ C0] ? ndisc_fill_addr_option (net/ipv6/ndisc.c:173) 
[ 22.535733][ C0] ndisc_send_rs (net/ipv6/ndisc.c:719) 
[ 22.536258][ C0] addrconf_dad_completed (net/ipv6/addrconf.c:4255) 
[ 22.536840][ C0] ? lock_is_held (include/linux/lockdep.h:284) 
[ 22.537335][ C0] ? addrconf_verify_work (net/ipv6/addrconf.c:4203) 
[ 22.537900][ C0] ? addrconf_dad_work (net/ipv6/addrconf.c:4154) 
[ 22.538466][ C0] addrconf_dad_work (net/ipv6/addrconf.c:4164) 
[ 22.539001][ C0] ? addrconf_dad_work (net/ipv6/addrconf.c:4164) 
[ 22.539570][ C0] ? addrconf_ifdown+0xae1/0xae1 
[ 22.540302][ C0] ? rcu_read_lock_sched_held (kernel/rcu/update.c:125) 
[ 22.541088][ C0] ? lock_is_held (include/linux/sched.h:1566) 
[ 22.541681][ C0] process_one_work (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:207 include/trace/events/workqueue.h:108 kernel/workqueue.c:2294) 
[ 22.542251][ C0] ? max_active_store (kernel/workqueue.c:2184) 
[ 22.542814][ C0] worker_thread (include/linux/list.h:292 kernel/workqueue.c:2437) 
[ 22.543313][ C0] ? trace_hardirqs_on (kernel/trace/trace_preemptirq.c:51 (discriminator 22)) 
[ 22.543895][ C0] kthread (kernel/kthread.c:376) 
[ 22.544343][ C0] ? rescuer_thread (kernel/workqueue.c:2379) 
[ 22.544867][ C0] ? kthread_complete_and_exit (kernel/kthread.c:331) 
[ 22.545480][ C0] ret_from_fork (arch/x86/entry/entry_64.S:314) 
[   22.546008][    C0]  </TASK>
[   22.546347][    C0] irq event stamp: 265
[ 22.546787][ C0] hardirqs last enabled at (264): net_rx_action (arch/x86/include/asm/irqflags.h:45 arch/x86/include/asm/irqflags.h:80 net/core/dev.c:6651) 
[ 22.547781][ C0] hardirqs last disabled at (265): net_rx_action (net/core/dev.c:6551 (discriminator 3) net/core/dev.c:6666 (discriminator 3)) 
[ 22.548750][ C0] softirqs last enabled at (260): rcu_read_unlock_bh (include/linux/rcupdate.h:330 include/linux/rcupdate.h:832) 
[ 22.549741][ C0] softirqs last disabled at (261): do_softirq (kernel/softirq.c:472) 
[   22.550664][    C0] ---[ end trace 0000000000000000 ]---


If you fix the issue, kindly add following tag
| Reported-by: kernel test robot <yujie.liu@intel.com>
| Link: https://lore.kernel.org/oe-lkp/202302211734.1d9915a-yujie.liu@intel.com


To reproduce:

        # build kernel
	cd linux
	cp config-6.2.0-rc7-01664-ged417c671fa6 .config
	make HOSTCC=gcc-11 CC=gcc-11 ARCH=x86_64 olddefconfig prepare modules_prepare bzImage modules
	make HOSTCC=gcc-11 CC=gcc-11 ARCH=x86_64 INSTALL_MOD_PATH=<mod-install-dir> modules_install
	cd <mod-install-dir>
	find lib/ | cpio -o -H newc --quiet | gzip > modules.cgz


        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp qemu -k <bzImage> -m modules.cgz job-script # job-script is attached in this email

        # if come across any failure that blocks the test,
        # please remove ~/.lkp and /lkp dir to run from a clean state.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

--EQB/CcOsoyEfnLnZ
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="config-6.2.0-rc7-01664-ged417c671fa6"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 6.2.0-rc7 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-11 (Debian 11.3.0-8) 11.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=110300
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=23990
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23990
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_PAHOLE_VERSION=123
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
# CONFIG_WERROR is not set
# CONFIG_UAPI_HEADER_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_WATCH_QUEUE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_IRQ_MSI_IOMMU=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_DEBUGFS=y
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_IDLE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING_USER=y
CONFIG_CONTEXT_TRACKING_USER_FORCE=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_CLOCKSOURCE_WATCHDOG_MAX_SKEW_US=100
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
CONFIG_BPF_SYSCALL=y
# CONFIG_BPF_JIT is not set
CONFIG_BPF_UNPRIV_DEFAULT_OFF=y
# CONFIG_BPF_PRELOAD is not set
# end of BPF subsystem

CONFIG_PREEMPT_VOLUNTARY_BUILD=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_PREEMPT_DYNAMIC is not set
# CONFIG_SCHED_CORE is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_FORCE_TASKS_RCU=y
CONFIG_TASKS_RCU=y
CONFIG_FORCE_TASKS_RUDE_RCU=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_FORCE_TASKS_TRACE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_DEFAULT_ALL is not set
# CONFIG_TASKS_TRACE_RCU_READ_MB is not set
CONFIG_RCU_LAZY=y
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_PRINTK_INDEX=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough=5"
CONFIG_GCC11_NO_ARRAY_BOUNDS=y
CONFIG_GCC12_NO_ARRAY_BOUNDS=y
CONFIG_CC_NO_ARRAY_BOUNDS=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_FAVOR_DYNMODS is not set
# CONFIG_MEMCG is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUP_PIDS is not set
# CONFIG_CGROUP_RDMA is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_BPF is not set
# CONFIG_CGROUP_MISC is not set
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_NAMESPACES is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
# CONFIG_BOOT_CONFIG is not set
# CONFIG_INITRAMFS_PRESERVE_MTIME is not set
# CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_LD_ORPHAN_WARN=y
CONFIG_LD_ORPHAN_WARN_LEVEL="warn"
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_FHANDLE=y
# CONFIG_POSIX_TIMERS is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_IO_URING is not set
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_SELFTEST is not set
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
CONFIG_DEBUG_RSEQ=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PC104=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_CSUM=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_AUDIT_ARCH=y
CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DYNAMIC_PHYSICAL_MASK=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
# CONFIG_X86_CPU_RESCTRL is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
# CONFIG_IOSF_MBI is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_XEN=y
# CONFIG_XEN_PV is not set
CONFIG_XEN_PVHVM=y
CONFIG_XEN_PVHVM_SMP=y
CONFIG_XEN_PVHVM_GUEST=y
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
CONFIG_ACRN_GUEST=y
CONFIG_INTEL_TDX_GUEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_HYGON is not set
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_CPU_SUP_ZHAOXIN is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_CLUSTER=y
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCELOG_LEGACY is not set
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# end of Performance monitoring

CONFIG_X86_VSYSCALL_EMULATION=y
# CONFIG_X86_IOPL_IOPERM is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_LATE_LOADING is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_X86_MEM_ENCRYPT=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
# CONFIG_X86_PMEM_LEGACY is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
CONFIG_X86_UMIP=y
CONFIG_CC_HAS_IBT=y
# CONFIG_X86_KERNEL_IBT is not set
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_X86_SGX=y
# CONFIG_EFI is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_KEXEC=y
# CONFIG_KEXEC_FILE is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
CONFIG_LEGACY_VSYSCALL_XONLY=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
# CONFIG_MODIFY_LDT_SYSCALL is not set
CONFIG_STRICT_SIGALTSTACK_SIZE=y
CONFIG_HAVE_LIVEPATCH=y
# end of Processor type and features

CONFIG_CC_HAS_SLS=y
CONFIG_CC_HAS_RETURN_THUNK=y
CONFIG_CC_HAS_ENTRY_PADDING=y
CONFIG_FUNCTION_PADDING_CFI=59
CONFIG_FUNCTION_PADDING_BYTES=64
CONFIG_SPECULATION_MITIGATIONS=y
CONFIG_PAGE_TABLE_ISOLATION=y
# CONFIG_RETPOLINE is not set
CONFIG_CPU_IBRS_ENTRY=y
CONFIG_SLS=y
CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_USERSPACE_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
# CONFIG_ACPI_FPDT is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_TAD is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_NFIT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_DPTF is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_ACPI_CONFIGFS is not set
# CONFIG_ACPI_PFRUT is not set
# CONFIG_ACPI_FFH is not set
# CONFIG_PMIC_OPREGION is not set
CONFIG_X86_PM_TIMER=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

# CONFIG_INTEL_IDLE is not set
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_ISA_BUS=y
CONFIG_ISA_DMA_API=y
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
CONFIG_X86_X32_ABI=y
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
# end of Binary Emulations

CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_KRETPROBE_ON_RETHOOK=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_ARCH_CORRECT_STACKTRACE_ON_KRETPROBE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_ARCH_WANTS_NO_INSTR=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_RUST=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_MMU_GATHER_MERGE_VMAS=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
# CONFIG_SECCOMP is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
# CONFIG_STACKPROTECTOR is not set
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_ARCH_SUPPORTS_CFI_CLANG=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING_USER=y
CONFIG_HAVE_CONTEXT_TRACKING_USER_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_HUGE_VMALLOC=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
CONFIG_HAVE_OBJTOOL=y
CONFIG_HAVE_JUMP_LABEL_HACK=y
CONFIG_HAVE_NOINSTR_HACK=y
CONFIG_HAVE_NOINSTR_VALIDATION=y
CONFIG_HAVE_UACCESS_VALIDATION=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_ISA_BUS_API=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
# CONFIG_VMAP_STACK is not set
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET=y
# CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_LOCK_EVENT_COUNTS=y
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_ARCH_HAS_CC_PLATFORM=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_SUPPORTS_PAGE_TABLE_CHECK=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y
CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH=y
CONFIG_DYNAMIC_SIGFRAME=y
CONFIG_HAVE_ARCH_NODE_DEV_GROUP=y
CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
CONFIG_FUNCTION_ALIGNMENT_4B=y
CONFIG_FUNCTION_ALIGNMENT_16B=y
CONFIG_FUNCTION_ALIGNMENT_64B=y
CONFIG_FUNCTION_ALIGNMENT=64
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODULE_UNLOAD_TAINT_TRACKING is not set
CONFIG_MODVERSIONS=y
CONFIG_ASM_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS=y
CONFIG_MODPROBE_PATH="/sbin/modprobe"
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLOCK_LEGACY_AUTOLOAD=y
CONFIG_BLK_ICQ=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=y
CONFIG_BLK_DEV_ZONED=y
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_MQ=y
# CONFIG_BLK_DEBUG_FS is not set
# CONFIG_BLK_SED_OPAL is not set
CONFIG_BLK_INLINE_ENCRYPTION=y
# CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
CONFIG_AIX_PARTITION=y
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_CMDLINE_PARTITION=y
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_PM=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=m
CONFIG_IOSCHED_BFQ=m
# end of IO Schedulers

CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
# end of Executable file formats

#
# Memory Management options
#
# CONFIG_SWAP is not set

#
# SLAB allocator options
#
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB_DEPRECATED is not set
# CONFIG_SLUB_TINY is not set
# CONFIG_SLAB_MERGE_DEFAULT is not set
CONFIG_SLAB_FREELIST_RANDOM=y
# CONFIG_SLAB_FREELIST_HARDENED is not set
# CONFIG_SLUB_STATS is not set
CONFIG_SLUB_CPU_PARTIAL=y
# end of SLAB allocator options

CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
CONFIG_COMPAT_BRK=y
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_EXCLUSIVE_SYSTEM_RAM=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_MEMORY_HOTPLUG=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
# CONFIG_COMPACTION is not set
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_WANTS_THP_SWAP=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
CONFIG_CMA_DEBUGFS=y
# CONFIG_CMA_SYSFS is not set
CONFIG_CMA_AREAS=7
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ARCH_HAS_ZONE_DMA_SET=y
# CONFIG_ZONE_DMA is not set
CONFIG_ZONE_DMA32=y
# CONFIG_ZONE_DEVICE is not set
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_TEST is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
# CONFIG_SECRETMEM is not set
CONFIG_ANON_VMA_NAME=y
# CONFIG_USERFAULTFD is not set
CONFIG_LRU_GEN=y
CONFIG_LRU_GEN_ENABLED=y
CONFIG_LRU_GEN_STATS=y

#
# Data Access Monitoring
#
# CONFIG_DAMON is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_AF_UNIX_OOB=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_TLS is not set
# CONFIG_XFRM_USER is not set
# CONFIG_NET_KEY is not set
# CONFIG_XDP_SOCKETS is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
CONFIG_INET_TABLE_PERTURB_ORDER=16
CONFIG_INET_TUNNEL=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_INET_RAW_DIAG is not set
# CONFIG_INET_DIAG_DESTROY is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_IPV6_VTI is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
# CONFIG_IPV6_SEG6_HMAC is not set
# CONFIG_IPV6_RPL_LWTUNNEL is not set
# CONFIG_IPV6_IOAM6_LWTUNNEL is not set
# CONFIG_NETLABEL is not set
# CONFIG_MPTCP is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_6LOWPAN is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_MPLS is not set
# CONFIG_NET_NSH is not set
# CONFIG_HSR is not set
# CONFIG_NET_SWITCHDEV is not set
# CONFIG_NET_L3_MASTER_DEV is not set
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
CONFIG_PCPU_DEV_REFCNT=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
# CONFIG_MCTP is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_FD=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
# CONFIG_PSAMPLE is not set
# CONFIG_NET_IFE is not set
# CONFIG_LWTUNNEL is not set
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_PAGE_POOL=y
# CONFIG_PAGE_POOL_STATS is not set
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
# CONFIG_PCIE_PTM is not set
# CONFIG_PCI_MSI is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_PCI_LOCKLESS_CONFIG=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y
# CONFIG_PCIE_BUS_TUNE_OFF is not set
CONFIG_PCIE_BUS_DEFAULT=y
# CONFIG_PCIE_BUS_SAFE is not set
# CONFIG_PCIE_BUS_PERFORMANCE is not set
# CONFIG_PCIE_BUS_PEER2PEER is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_HOTPLUG_PCI is not set

#
# PCI controller drivers
#

#
# DesignWare PCI Core Support
#
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_CXL_BUS is not set
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_DEVTMPFS_SAFE=y
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_FW_LOADER_SYSFS=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
CONFIG_FW_LOADER_COMPRESS=y
# CONFIG_FW_LOADER_COMPRESS_XZ is not set
# CONFIG_FW_LOADER_COMPRESS_ZSTD is not set
CONFIG_FW_CACHE=y
CONFIG_FW_UPLOAD=y
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=y
CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_SYS_HYPERVISOR=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SLIMBUS=m
CONFIG_REGMAP_SPMI=m
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_REGMAP_SCCB=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
CONFIG_MHI_BUS=m
# CONFIG_MHI_BUS_DEBUG is not set
# CONFIG_MHI_BUS_PCI_GENERIC is not set
# CONFIG_MHI_BUS_EP is not set
# end of Bus devices

# CONFIG_CONNECTOR is not set

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

CONFIG_EDD=m
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
# CONFIG_SYSFB_SIMPLEFB is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_GNSS=y
CONFIG_GNSS_SERIAL=y
CONFIG_GNSS_MTK_SERIAL=y
# CONFIG_GNSS_SIRF_SERIAL is not set
# CONFIG_GNSS_UBX_SERIAL is not set
CONFIG_GNSS_USB=m
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set

#
# Partition parsers
#
CONFIG_MTD_AR7_PARTS=y
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# end of Partition parsers

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=y

#
# Note that in some cases UBI block is preferred. See MTD_UBI_BLOCK.
#
# CONFIG_FTL is not set
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=m
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_CFI_INTELEXT=m
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=y
# end of RAM/ROM/Flash chip drivers

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
# end of Mapping drivers for chip access

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# end of Self-contained MTD device drivers

#
# NAND
#
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=m
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y
# CONFIG_MTD_RAW_NAND is not set

#
# ECC engine support
#
# CONFIG_MTD_NAND_ECC_SW_HAMMING is not set
# CONFIG_MTD_NAND_ECC_SW_BCH is not set
# CONFIG_MTD_NAND_ECC_MXIC is not set
# end of ECC engine support
# end of NAND

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# end of LPDDR & LPDDR2 PCM memory drivers

CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_MTD_HYPERBUS is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_UBLK is not set

#
# NVME Support
#
CONFIG_NVME_COMMON=m
CONFIG_NVME_CORE=m
# CONFIG_BLK_DEV_NVME is not set
CONFIG_NVME_MULTIPATH=y
CONFIG_NVME_VERBOSE_ERRORS=y
CONFIG_NVME_HWMON=y
CONFIG_NVME_FABRICS=m
CONFIG_NVME_FC=m
# CONFIG_NVME_TCP is not set
CONFIG_NVME_AUTH=y
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
CONFIG_NVME_TARGET_FC=m
CONFIG_NVME_TARGET_FCLOOP=m
# CONFIG_NVME_TARGET_TCP is not set
CONFIG_NVME_TARGET_AUTH=y
# end of NVME Support

#
# Misc devices
#
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SMPRO_ERRMON=m
CONFIG_SMPRO_MISC=m
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=m
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_IDT_89HPESX is not set
CONFIG_EEPROM_EE1004=y
# end of EEPROM support

# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

# CONFIG_SENSORS_LIS3_I2C is not set
CONFIG_ALTERA_STAPL=m
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set
# CONFIG_GENWQE is not set
CONFIG_ECHO=m
# CONFIG_MISC_ALCOR_PCI is not set
# CONFIG_MISC_RTSX_PCI is not set
CONFIG_MISC_RTSX_USB=m
# CONFIG_HABANA_AI is not set
CONFIG_UACCE=m
# CONFIG_PVPANIC is not set
# CONFIG_GP_PCI1XXXX is not set
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI_COMMON=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=m
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
# end of SCSI Transports

# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# end of SCSI device support

CONFIG_ATA=y
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
# CONFIG_ATA_FORCE is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_AHCI_DWC=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_ISCSI_TARGET is not set
CONFIG_SBP_TARGET=m
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=m
# CONFIG_FIREWIRE_NET is not set
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_GENEVE is not set
# CONFIG_BAREUDP is not set
# CONFIG_GTP is not set
# CONFIG_MACSEC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_TUN is not set
# CONFIG_TUN_VNET_CROSS_LE is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_MHI_NET is not set
# CONFIG_ARCNET is not set
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ASIX=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_CX_ECAT is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
# CONFIG_LIQUIDIO is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
CONFIG_NET_VENDOR_DAVICOM=y
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_ENGLEDER=y
# CONFIG_TSNEP is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_FUNGIBLE=y
CONFIG_NET_VENDOR_GOOGLE=y
CONFIG_NET_VENDOR_HUAWEI=y
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_I40E is not set
CONFIG_ICE_GNSS=y
# CONFIG_IGC is not set
CONFIG_NET_VENDOR_WANGXUN=y
# CONFIG_NGBE is not set
# CONFIG_TXGBE is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_LITEX=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_OCTEON_EP is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_LAN743X is not set
# CONFIG_VCAP is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MICROSOFT=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VERTEXCOM=y
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_EMACLITE is not set
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_PHYLIB is not set
# CONFIG_PSE_CONTROLLER is not set
# CONFIG_MDIO_DEVICE is not set

#
# PCS device drivers
#
# end of PCS device drivers

# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# Host-side USB support is needed for USB Network Adapter support
#
CONFIG_USB_NET_DRIVERS=m
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
# CONFIG_USB_LAN78XX is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_WLAN_VENDOR_ATMEL=y
CONFIG_WLAN_VENDOR_BROADCOM=y
CONFIG_WLAN_VENDOR_CISCO=y
CONFIG_WLAN_VENDOR_INTEL=y
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
CONFIG_WLAN_VENDOR_MARVELL=y
CONFIG_WLAN_VENDOR_MEDIATEK=y
CONFIG_WLAN_VENDOR_MICROCHIP=y
CONFIG_WLAN_VENDOR_PURELIFI=y
CONFIG_WLAN_VENDOR_RALINK=y
CONFIG_WLAN_VENDOR_REALTEK=y
CONFIG_WLAN_VENDOR_RSI=y
CONFIG_WLAN_VENDOR_SILABS=y
CONFIG_WLAN_VENDOR_ST=y
CONFIG_WLAN_VENDOR_TI=y
CONFIG_WLAN_VENDOR_ZYDAS=y
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_WAN is not set

#
# Wireless WAN
#
# CONFIG_WWAN is not set
# end of Wireless WAN

CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_NETDEVSIM is not set
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=m
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set
CONFIG_INPUT_VIVALDIFMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_PINEPHONE is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_MTK_PMIC is not set
# CONFIG_KEYBOARD_CYPRESS_SF is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
# CONFIG_MOUSE_PS2_VMMOUSE is not set
CONFIG_MOUSE_PS2_SMBUS=y
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_ELAN_I2C is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
# CONFIG_RMI4_CORE is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
# CONFIG_SERIO_GPIO_PS2 is not set
CONFIG_USERIO=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_LEGACY_TIOCSTI=y
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DWLIB=y
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
CONFIG_SERIAL_8250_PERICOM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
# CONFIG_NOZOMI is not set
# CONFIG_NULL_TTY is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_RPMSG_TTY is not set
CONFIG_SERIAL_DEV_BUS=y
CONFIG_SERIAL_DEV_CTRL_TTYPORT=y
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=m
# CONFIG_IPMI_SSIF is not set
CONFIG_IPMI_IPMB=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_SSIF_IPMI_BMC=m
CONFIG_IPMB_DEVICE_INTERFACE=m
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_BA431=m
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_XIPHERA=m
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_DEVMEM is not set
CONFIG_NVRAM=m
CONFIG_DEVPORT=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C=y
CONFIG_TCG_TIS_I2C_CR50=m
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_XEN is not set
# CONFIG_TCG_CRB is not set
# CONFIG_TCG_VTPM_PROXY is not set
# CONFIG_TCG_TIS_ST33ZP24_I2C is not set
CONFIG_TELCLOCK=m
CONFIG_XILLYBUS_CLASS=m
# CONFIG_XILLYBUS is not set
CONFIG_XILLYUSB=m
# end of Character devices

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_MUX_REG=m
CONFIG_I2C_MUX_MLXCPLD=m
# end of Multiplexer I2C Chip support

# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y
# end of I2C Algorithms

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_AMD_MP2 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_AMDPSP is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EMEV2=y
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_DLN2 is not set
CONFIG_I2C_CP2615=m
# CONFIG_I2C_PCI1XXXX is not set
CONFIG_I2C_ROBOTFUZZ_OSIF=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
CONFIG_I2C_VIRTIO=m
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
CONFIG_I2C_SLAVE=y
CONFIG_I2C_SLAVE_EEPROM=m
# CONFIG_I2C_SLAVE_TESTUNIT is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
CONFIG_SPMI_HISI3670=y
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=m
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK_OPTIONAL=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
# CONFIG_PINCTRL_CY8C95X0 is not set
CONFIG_PINCTRL_MCP23S08_I2C=m
CONFIG_PINCTRL_MCP23S08=m
CONFIG_PINCTRL_SX150X=y
CONFIG_PINCTRL_MADERA=y
CONFIG_PINCTRL_CS47L15=y
CONFIG_PINCTRL_CS47L35=y
CONFIG_PINCTRL_CS47L85=y
CONFIG_PINCTRL_CS47L90=y
CONFIG_PINCTRL_CS47L92=y

#
# Intel pinctrl drivers
#
# CONFIG_PINCTRL_BAYTRAIL is not set
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
# CONFIG_PINCTRL_ALDERLAKE is not set
# CONFIG_PINCTRL_BROXTON is not set
# CONFIG_PINCTRL_CANNONLAKE is not set
# CONFIG_PINCTRL_CEDARFORK is not set
# CONFIG_PINCTRL_DENVERTON is not set
# CONFIG_PINCTRL_ELKHARTLAKE is not set
# CONFIG_PINCTRL_EMMITSBURG is not set
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
# CONFIG_PINCTRL_LAKEFIELD is not set
# CONFIG_PINCTRL_LEWISBURG is not set
# CONFIG_PINCTRL_METEORLAKE is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
# CONFIG_PINCTRL_TIGERLAKE is not set
# end of Intel pinctrl drivers

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
# CONFIG_GPIO_CDEV is not set
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_MAX730X=y
CONFIG_GPIO_IDIO_16=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_AMDPT is not set
CONFIG_GPIO_DWAPB=m
# CONFIG_GPIO_EXAR is not set
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_MB86S7X=y
# CONFIG_GPIO_SIOX is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
CONFIG_GPIO_I8255=y
CONFIG_GPIO_104_DIO_48E=y
CONFIG_GPIO_104_IDIO_16=y
# CONFIG_GPIO_104_IDI_48 is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_GPIO_MM=y
# CONFIG_GPIO_IT87 is not set
CONFIG_GPIO_SCH311X=m
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCA9570=y
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
CONFIG_GPIO_ADP5520=m
CONFIG_GPIO_DA9052=m
# CONFIG_GPIO_DA9055 is not set
CONFIG_GPIO_DLN2=m
CONFIG_GPIO_LP3943=m
CONFIG_GPIO_LP873X=m
CONFIG_GPIO_MADERA=m
CONFIG_GPIO_TPS65086=y
CONFIG_GPIO_TPS6586X=y
CONFIG_GPIO_TPS65910=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TQMX86=y
CONFIG_GPIO_TWL4030=m
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8994=m
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# USB GPIO expanders
#
# end of USB GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
CONFIG_GPIO_LATCH=m
# CONFIG_GPIO_MOCKUP is not set
# CONFIG_GPIO_VIRTIO is not set
# CONFIG_GPIO_SIM is not set
# end of Virtual GPIO drivers

CONFIG_W1=m

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set
# CONFIG_W1_MASTER_SGI is not set
# end of 1-wire Bus Masters

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2405=m
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2406=m
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2805=m
CONFIG_W1_SLAVE_DS2430=m
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2438=m
CONFIG_W1_SLAVE_DS250X=m
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_DS28E17=m
# end of 1-wire Slaves

CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_ATC260X is not set
CONFIG_POWER_RESET_MT6323=y
CONFIG_POWER_RESET_RESTART=y
# CONFIG_POWER_RESET_TPS65086 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=m
CONFIG_IP5XXX_POWER=m
CONFIG_MAX8925_POWER=m
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=m
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SAMSUNG_SDI=y
CONFIG_BATTERY_SBS=m
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
CONFIG_BATTERY_BQ27XXX=m
CONFIG_BATTERY_BQ27XXX_I2C=m
CONFIG_BATTERY_BQ27XXX_HDQ=m
CONFIG_BATTERY_BQ27XXX_DT_UPDATES_NVM=y
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_CHARGER_DA9150=m
# CONFIG_BATTERY_DA9150 is not set
# CONFIG_CHARGER_AXP20X is not set
CONFIG_BATTERY_AXP20X=m
# CONFIG_AXP20X_POWER is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
# CONFIG_BATTERY_MAX1721X is not set
# CONFIG_BATTERY_TWL4030_MADC is not set
CONFIG_CHARGER_PCF50633=m
CONFIG_BATTERY_RX51=m
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=m
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_LT3651=m
CONFIG_CHARGER_LTC4162L=m
CONFIG_CHARGER_MAX14577=m
CONFIG_CHARGER_MAX77976=y
# CONFIG_CHARGER_MP2629 is not set
CONFIG_CHARGER_MT6360=y
# CONFIG_CHARGER_MT6370 is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=m
# CONFIG_CHARGER_BQ24257 is not set
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_BQ2515X=m
CONFIG_CHARGER_BQ25890=m
CONFIG_CHARGER_BQ25980=y
# CONFIG_CHARGER_BQ256XX is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
CONFIG_BATTERY_GAUGE_LTC2941=y
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_BATTERY_RT5033 is not set
# CONFIG_CHARGER_RT9455 is not set
CONFIG_CHARGER_BD99954=y
CONFIG_BATTERY_UG3105=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_SMPRO is not set
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM1177=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_AHT10 is not set
# CONFIG_SENSORS_AQUACOMPUTER_D5NEXT is not set
CONFIG_SENSORS_AS370=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_AXI_FAN_CONTROL=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_CORSAIR_PSU is not set
CONFIG_SENSORS_DRIVETEMP=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_DELL_SMM is not set
CONFIG_SENSORS_DA9052_ADC=m
CONFIG_SENSORS_DA9055=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_FTSTEUTATES=m
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_HIH6130=m
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IIO_HWMON=m
# CONFIG_SENSORS_I5500 is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_POWR1220=m
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LTC2945=m
CONFIG_SENSORS_LTC2947=m
CONFIG_SENSORS_LTC2947_I2C=m
# CONFIG_SENSORS_LTC2990 is not set
CONFIG_SENSORS_LTC2992=m
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX127 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX31730=m
CONFIG_SENSORS_MAX31760=m
CONFIG_SENSORS_MAX6620=m
CONFIG_SENSORS_MAX6621=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_MAX31790=m
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_MLXREG_FAN is not set
CONFIG_SENSORS_TC654=m
CONFIG_SENSORS_TPS23861=m
CONFIG_SENSORS_MENF21BMC_HWMON=m
# CONFIG_SENSORS_MR75203 is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_NCT6683=m
CONFIG_SENSORS_NCT6775_CORE=m
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NCT6775_I2C=m
# CONFIG_SENSORS_NCT7802 is not set
CONFIG_SENSORS_NCT7904=m
CONFIG_SENSORS_NPCM7XX=m
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
# CONFIG_SENSORS_NZXT_SMART2 is not set
CONFIG_SENSORS_OCC_P8_I2C=m
CONFIG_SENSORS_OCC=m
# CONFIG_SENSORS_OXP is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_SENSORS_PECI_CPUTEMP=m
CONFIG_SENSORS_PECI_DIMMTEMP=m
CONFIG_SENSORS_PECI=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1266 is not set
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_BEL_PFE=m
CONFIG_SENSORS_BPA_RS600=m
# CONFIG_SENSORS_DELTA_AHE50DC_FAN is not set
# CONFIG_SENSORS_FSP_3Y is not set
CONFIG_SENSORS_IBM_CFFPS=m
# CONFIG_SENSORS_DPS920AB is not set
CONFIG_SENSORS_INSPUR_IPSPS=m
CONFIG_SENSORS_IR35221=m
# CONFIG_SENSORS_IR36021 is not set
CONFIG_SENSORS_IR38064=m
# CONFIG_SENSORS_IR38064_REGULATOR is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LM25066_REGULATOR=y
CONFIG_SENSORS_LT7182S=m
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_LTC3815 is not set
CONFIG_SENSORS_MAX15301=m
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX16601=m
CONFIG_SENSORS_MAX20730=m
CONFIG_SENSORS_MAX20751=m
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_MP2888=m
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_MP5023 is not set
CONFIG_SENSORS_PIM4328=m
CONFIG_SENSORS_PLI1209BC=m
# CONFIG_SENSORS_PLI1209BC_REGULATOR is not set
CONFIG_SENSORS_PM6764TR=m
CONFIG_SENSORS_PXE1610=m
CONFIG_SENSORS_Q54SJ108A2=m
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TPS40422 is not set
CONFIG_SENSORS_TPS53679=m
# CONFIG_SENSORS_TPS546D24 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_XDPE152=m
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SBTSI is not set
# CONFIG_SENSORS_SBRMI is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SHT3x=m
CONFIG_SENSORS_SHT4x=m
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC2305=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_ADC128D818=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA238 is not set
CONFIG_SENSORS_INA3221=m
CONFIG_SENSORS_TC74=m
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP103=m
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP464 is not set
CONFIG_SENSORS_TMP513=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM831X=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_ASUS_EC is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_WRITABLE_TRIPS=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
# CONFIG_THERMAL_GOV_BANG_BANG is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_DEVFREQ_THERMAL=y
CONFIG_THERMAL_EMULATION=y

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# end of ACPI INT340X thermal drivers

# CONFIG_INTEL_PCH_THERMAL is not set
CONFIG_INTEL_TCC_COOLING=m
# CONFIG_INTEL_MENLOW is not set
# CONFIG_INTEL_HFI_THERMAL is not set
# end of Intel thermal drivers

CONFIG_GENERIC_ADC_THERMAL=m
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y
# CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED is not set
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y
CONFIG_WATCHDOG_HRTIMER_PRETIMEOUT=y

#
# Watchdog Pretimeout Governors
#
CONFIG_WATCHDOG_PRETIMEOUT_GOV=y
CONFIG_WATCHDOG_PRETIMEOUT_GOV_SEL=m
CONFIG_WATCHDOG_PRETIMEOUT_GOV_NOOP=y
CONFIG_WATCHDOG_PRETIMEOUT_GOV_PANIC=y
# CONFIG_WATCHDOG_PRETIMEOUT_DEFAULT_GOV_NOOP is not set
CONFIG_WATCHDOG_PRETIMEOUT_DEFAULT_GOV_PANIC=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_SOFT_WATCHDOG_PRETIMEOUT=y
# CONFIG_DA9052_WATCHDOG is not set
# CONFIG_DA9055_WATCHDOG is not set
# CONFIG_MENF21BMC_WATCHDOG is not set
# CONFIG_WDAT_WDT is not set
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_XILINX_WATCHDOG is not set
CONFIG_ZIIRAVE_WATCHDOG=y
CONFIG_RAVE_SP_WATCHDOG=y
CONFIG_MLX_WDT=m
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=y
# CONFIG_MAX63XX_WATCHDOG is not set
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=y
CONFIG_ADVANTECH_EC_WDT=m
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_EBC_C384_WDT=y
CONFIG_EXAR_WDT=y
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=m
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=m
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_TQMX86_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set
# CONFIG_XEN_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
CONFIG_MFD_SMPRO=m
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
# CONFIG_MFD_BD9571MWV is not set
CONFIG_MFD_AXP20X=m
CONFIG_MFD_AXP20X_I2C=m
CONFIG_MFD_MADERA=y
CONFIG_MFD_MADERA_I2C=m
CONFIG_MFD_CS47L15=y
CONFIG_MFD_CS47L35=y
CONFIG_MFD_CS47L85=y
CONFIG_MFD_CS47L90=y
CONFIG_MFD_CS47L92=y
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_DA9150=m
CONFIG_MFD_DLN2=m
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_MFD_MP2629=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
# CONFIG_MFD_INTEL_LPSS_PCI is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=m
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX77843=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_MT6360=y
CONFIG_MFD_MT6370=m
CONFIG_MFD_MT6397=y
CONFIG_MFD_MENF21BMC=m
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_SY7636A is not set
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_RT4831=y
# CONFIG_MFD_RT5033 is not set
CONFIG_MFD_RT5120=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SI476X_CORE=m
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SKY81452 is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_TI_LMU=m
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65086=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TI_LP873X=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TWL4030_AUDIO is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TQMX86=y
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=m
CONFIG_MFD_WCD934X=m
CONFIG_MFD_ATC260X=y
CONFIG_MFD_ATC260X_I2C=y
CONFIG_RAVE_SP_CORE=y
# end of Multifunction device drivers

CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_88PG86X=y
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_ATC260X=y
# CONFIG_REGULATOR_AXP20X is not set
CONFIG_REGULATOR_BCM590XX=m
CONFIG_REGULATOR_DA903X=m
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=m
CONFIG_REGULATOR_DA9210=m
# CONFIG_REGULATOR_DA9211 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=m
# CONFIG_REGULATOR_ISL9305 is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LM363X=m
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LTC3589=m
CONFIG_REGULATOR_LTC3676=y
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8893=m
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX20086 is not set
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MAX77826=m
# CONFIG_REGULATOR_MP8859 is not set
CONFIG_REGULATOR_MT6311=m
CONFIG_REGULATOR_MT6315=m
CONFIG_REGULATOR_MT6323=y
# CONFIG_REGULATOR_MT6331 is not set
CONFIG_REGULATOR_MT6332=m
# CONFIG_REGULATOR_MT6357 is not set
CONFIG_REGULATOR_MT6358=m
CONFIG_REGULATOR_MT6359=y
CONFIG_REGULATOR_MT6360=y
# CONFIG_REGULATOR_MT6370 is not set
# CONFIG_REGULATOR_MT6397 is not set
CONFIG_REGULATOR_PCA9450=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PV88060=m
CONFIG_REGULATOR_PV88080=y
CONFIG_REGULATOR_PV88090=m
CONFIG_REGULATOR_QCOM_SPMI=m
CONFIG_REGULATOR_QCOM_USB_VBUS=y
CONFIG_REGULATOR_RT4801=y
CONFIG_REGULATOR_RT4831=m
CONFIG_REGULATOR_RT5120=y
CONFIG_REGULATOR_RT5190A=m
CONFIG_REGULATOR_RT5759=m
CONFIG_REGULATOR_RT6160=y
CONFIG_REGULATOR_RT6190=y
# CONFIG_REGULATOR_RT6245 is not set
CONFIG_REGULATOR_RTQ2134=m
# CONFIG_REGULATOR_RTMV20 is not set
CONFIG_REGULATOR_RTQ6752=m
# CONFIG_REGULATOR_SLG51000 is not set
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65086=m
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65132=m
CONFIG_REGULATOR_TPS6586X=y
# CONFIG_REGULATOR_TPS65910 is not set
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TWL4030=m
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=m
CONFIG_REGULATOR_QCOM_LABIBB=m
# CONFIG_RC_CORE is not set
CONFIG_CEC_CORE=y

#
# CEC support
#
CONFIG_MEDIA_CEC_SUPPORT=y
CONFIG_CEC_CH7322=y
# CONFIG_CEC_SECO is not set
# CONFIG_USB_PULSE8_CEC is not set
# CONFIG_USB_RAINSHADOW_CEC is not set
# end of CEC support

CONFIG_MEDIA_SUPPORT=y
CONFIG_MEDIA_SUPPORT_FILTER=y
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Media device types
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_PLATFORM_SUPPORT is not set
# CONFIG_MEDIA_TEST_SUPPORT is not set
# end of Media device types

CONFIG_VIDEO_DEV=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_DVB_CORE=y

#
# Video4Linux options
#
CONFIG_VIDEO_V4L2_I2C=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=m
CONFIG_V4L2_FLASH_LED_CLASS=m
CONFIG_V4L2_FWNODE=y
CONFIG_V4L2_ASYNC=y
# end of Video4Linux options

#
# Media controller options
#
CONFIG_MEDIA_CONTROLLER_DVB=y
# end of Media controller options

#
# Digital TV options
#
CONFIG_DVB_MMAP=y
CONFIG_DVB_NET=y
CONFIG_DVB_MAX_ADAPTERS=16
# CONFIG_DVB_DYNAMIC_MINORS is not set
CONFIG_DVB_DEMUX_SECTION_LOSS_LOG=y
# CONFIG_DVB_ULE_DEBUG is not set
# end of Digital TV options

#
# Media drivers
#

#
# Drivers filtered as selected at 'Filter media drivers'
#

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_GSPCA=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_DTCS033 is not set
# CONFIG_USB_GSPCA_ETOMS is not set
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
# CONFIG_USB_GSPCA_KINECT is not set
# CONFIG_USB_GSPCA_KONICA is not set
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
# CONFIG_USB_GSPCA_OV534 is not set
# CONFIG_USB_GSPCA_OV534_9 is not set
CONFIG_USB_GSPCA_PAC207=m
# CONFIG_USB_GSPCA_PAC7302 is not set
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
# CONFIG_USB_GSPCA_SN9C2028 is not set
# CONFIG_USB_GSPCA_SN9C20X is not set
CONFIG_USB_GSPCA_SONIXB=m
# CONFIG_USB_GSPCA_SONIXJ is not set
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
# CONFIG_USB_GSPCA_SPCA506 is not set
# CONFIG_USB_GSPCA_SPCA508 is not set
# CONFIG_USB_GSPCA_SPCA561 is not set
# CONFIG_USB_GSPCA_SQ905 is not set
CONFIG_USB_GSPCA_SQ905C=m
# CONFIG_USB_GSPCA_SQ930X is not set
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_STK1135=m
# CONFIG_USB_GSPCA_STV0680 is not set
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
# CONFIG_USB_GSPCA_TOPRO is not set
CONFIG_USB_GSPCA_TOUPTEK=m
CONFIG_USB_GSPCA_TV8532=m
# CONFIG_USB_GSPCA_VC032X is not set
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
# CONFIG_USB_GL860 is not set
CONFIG_USB_M5602=m
# CONFIG_USB_STV06XX is not set
# CONFIG_USB_PWC is not set
CONFIG_USB_S2255=m
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y

#
# Analog TV USB devices
#
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
CONFIG_VIDEO_PVRUSB2_DEBUGIFC=y
CONFIG_VIDEO_STK1160_COMMON=m
CONFIG_VIDEO_STK1160=m

#
# Analog/digital TV USB devices
#
# CONFIG_VIDEO_AU0828 is not set
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_DVB=m

#
# Digital TV USB devices
#
# CONFIG_DVB_AS102 is not set
# CONFIG_DVB_B2C2_FLEXCOP_USB is not set
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_AF9015=m
# CONFIG_DVB_USB_AF9035 is not set
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_AU6610=m
# CONFIG_DVB_USB_AZ6007 is not set
# CONFIG_DVB_USB_CE6230 is not set
CONFIG_DVB_USB_DVBSKY=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_MXL111SF=m
# CONFIG_DVB_USB_RTL28XXU is not set
CONFIG_DVB_USB_ZD1301=m
CONFIG_SMS_USB_DRV=m
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_V4L2=m
# CONFIG_VIDEO_EM28XX_DVB is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_RADIO_ADAPTERS is not set

#
# FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_SMS_SIANO_MDTV=m
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_V4L2=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_VIDEOBUF2_DMA_SG=m
# end of Media drivers

#
# Media ancillary drivers
#
CONFIG_MEDIA_ATTACH=y

#
# Camera sensor devices
#
CONFIG_VIDEO_APTINA_PLL=m
CONFIG_VIDEO_CCS_PLL=m
# CONFIG_VIDEO_AR0521 is not set
# CONFIG_VIDEO_HI556 is not set
# CONFIG_VIDEO_HI846 is not set
CONFIG_VIDEO_HI847=m
CONFIG_VIDEO_IMX208=m
CONFIG_VIDEO_IMX214=y
CONFIG_VIDEO_IMX219=m
CONFIG_VIDEO_IMX258=m
CONFIG_VIDEO_IMX274=m
CONFIG_VIDEO_IMX290=m
# CONFIG_VIDEO_IMX319 is not set
CONFIG_VIDEO_IMX355=y
CONFIG_VIDEO_MAX9271_LIB=y
CONFIG_VIDEO_MT9M001=m
CONFIG_VIDEO_MT9M032=m
CONFIG_VIDEO_MT9M111=y
# CONFIG_VIDEO_MT9P031 is not set
CONFIG_VIDEO_MT9T001=y
CONFIG_VIDEO_MT9T112=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_MT9V032=y
CONFIG_VIDEO_MT9V111=y
CONFIG_VIDEO_NOON010PC30=y
CONFIG_VIDEO_OG01A1B=m
CONFIG_VIDEO_OV02A10=y
CONFIG_VIDEO_OV08D10=y
CONFIG_VIDEO_OV08X40=y
CONFIG_VIDEO_OV13858=m
CONFIG_VIDEO_OV13B10=m
CONFIG_VIDEO_OV2640=y
CONFIG_VIDEO_OV2659=y
CONFIG_VIDEO_OV2680=y
# CONFIG_VIDEO_OV2685 is not set
CONFIG_VIDEO_OV2740=m
# CONFIG_VIDEO_OV4689 is not set
# CONFIG_VIDEO_OV5647 is not set
CONFIG_VIDEO_OV5648=m
CONFIG_VIDEO_OV5670=y
# CONFIG_VIDEO_OV5675 is not set
CONFIG_VIDEO_OV5693=y
CONFIG_VIDEO_OV5695=m
CONFIG_VIDEO_OV6650=y
# CONFIG_VIDEO_OV7251 is not set
CONFIG_VIDEO_OV7640=m
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_OV772X=y
# CONFIG_VIDEO_OV7740 is not set
CONFIG_VIDEO_OV8856=y
CONFIG_VIDEO_OV8865=m
CONFIG_VIDEO_OV9640=y
CONFIG_VIDEO_OV9650=m
CONFIG_VIDEO_OV9734=y
CONFIG_VIDEO_RDACM20=m
CONFIG_VIDEO_RDACM21=y
CONFIG_VIDEO_RJ54N1=y
# CONFIG_VIDEO_S5K5BAF is not set
CONFIG_VIDEO_S5K6A3=m
# CONFIG_VIDEO_S5K6AA is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_VS6624 is not set
CONFIG_VIDEO_CCS=m
CONFIG_VIDEO_ET8EK8=y
CONFIG_VIDEO_M5MOLS=m
# end of Camera sensor devices

#
# Lens drivers
#
# CONFIG_VIDEO_AD5820 is not set
CONFIG_VIDEO_AK7375=m
CONFIG_VIDEO_DW9714=y
CONFIG_VIDEO_DW9768=y
CONFIG_VIDEO_DW9807_VCM=y
# end of Lens drivers

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_LM3560 is not set
CONFIG_VIDEO_LM3646=y
# end of Flash devices

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_CS3308=y
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_MSP3400=m
# CONFIG_VIDEO_SONY_BTF_MPX is not set
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
# CONFIG_VIDEO_TLV320AIC23B is not set
CONFIG_VIDEO_TVAUDIO=y
CONFIG_VIDEO_UDA1342=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_WM8775=m
# end of Audio decoders, processors and mixers

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y
# end of RDS decoders

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=m
CONFIG_VIDEO_ADV7183=m
# CONFIG_VIDEO_ADV7604 is not set
# CONFIG_VIDEO_ADV7842 is not set
CONFIG_VIDEO_BT819=m
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_ML86V7667=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TC358743=m
CONFIG_VIDEO_TC358743_CEC=y
# CONFIG_VIDEO_TC358746 is not set
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=m
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=m
CONFIG_VIDEO_TW9906=m
CONFIG_VIDEO_TW9910=y
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m
# end of Video decoders

#
# Video encoders
#
CONFIG_VIDEO_AD9389B=m
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y
# CONFIG_VIDEO_ADV7343 is not set
CONFIG_VIDEO_ADV7393=y
CONFIG_VIDEO_ADV7511=m
CONFIG_VIDEO_ADV7511_CEC=y
CONFIG_VIDEO_AK881X=m
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
CONFIG_VIDEO_THS8200=m
# end of Video encoders

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
# CONFIG_VIDEO_UPD64083 is not set
# end of Video improvement chips

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set
# end of Audio/Video compression chips

#
# SDR tuner chips
#
# end of SDR tuner chips

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_I2C is not set
CONFIG_VIDEO_M52790=y
# CONFIG_VIDEO_ST_MIPID02 is not set
# CONFIG_VIDEO_THS7303 is not set
# end of Miscellaneous helper chips

CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=y
# CONFIG_MEDIA_TUNER_FC0013 is not set
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_M88RS6000T=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_MT2266 is not set
CONFIG_MEDIA_TUNER_MXL301RF=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
# CONFIG_MEDIA_TUNER_QM1D1B0004 is not set
CONFIG_MEDIA_TUNER_QM1D1C0042=y
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_R820T=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_TDA18250=m
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_XC5000=y
# end of Customize TV tuners

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_M88DS3103=y
CONFIG_DVB_MXL5XX=y
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=m
# CONFIG_DVB_STV0910 is not set
# CONFIG_DVB_STV6110x is not set
CONFIG_DVB_STV6111=m

#
# Multistandard (cable + terrestrial) frontends
#
# CONFIG_DVB_DRXK is not set
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=y
CONFIG_DVB_SI2165=y
CONFIG_DVB_TDA18271C2DD=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=y
CONFIG_DVB_CX24120=m
CONFIG_DVB_CX24123=m
# CONFIG_DVB_DS3000 is not set
CONFIG_DVB_MB86A16=m
# CONFIG_DVB_MT312 is not set
CONFIG_DVB_S5H1420=y
# CONFIG_DVB_SI21XX is not set
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0288=y
# CONFIG_DVB_STV0299 is not set
CONFIG_DVB_STV0900=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_TDA10071=m
CONFIG_DVB_TDA10086=y
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_TDA8261=y
# CONFIG_DVB_TDA826X is not set
CONFIG_DVB_TS2020=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TUNER_ITD1000=y
# CONFIG_DVB_VES1X93 is not set
CONFIG_DVB_ZL10036=y
# CONFIG_DVB_ZL10039 is not set

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_AF9013=m
CONFIG_DVB_CX22700=y
CONFIG_DVB_CX22702=y
CONFIG_DVB_CXD2820R=y
CONFIG_DVB_CXD2841ER=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=y
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_DIB9000=y
CONFIG_DVB_DRXD=m
CONFIG_DVB_EC100=m
CONFIG_DVB_L64781=m
CONFIG_DVB_MT352=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_S5H1432=y
CONFIG_DVB_SI2168=m
CONFIG_DVB_SP887X=y
CONFIG_DVB_STV0367=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_ZD1301_DEMOD=m
CONFIG_DVB_ZL10353=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_STV0297=y
CONFIG_DVB_TDA10021=y
CONFIG_DVB_TDA10023=m
# CONFIG_DVB_VES1820 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LGDT3306A=m
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_MXL692=m
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51132=y
CONFIG_DVB_OR51211=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=y
CONFIG_DVB_S921=y

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
# CONFIG_DVB_MN88443X is not set
CONFIG_DVB_TC90522=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=y
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_A8293 is not set
CONFIG_DVB_AF9033=m
# CONFIG_DVB_ASCOT2E is not set
CONFIG_DVB_ATBM8830=y
CONFIG_DVB_HELENE=m
# CONFIG_DVB_HORUS3A is not set
CONFIG_DVB_ISL6405=y
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_IX2505V=m
# CONFIG_DVB_LGS8GL5 is not set
# CONFIG_DVB_LGS8GXX is not set
CONFIG_DVB_LNBH25=y
CONFIG_DVB_LNBH29=m
# CONFIG_DVB_LNBP21 is not set
CONFIG_DVB_LNBP22=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_DRX39XYJ=m

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=y
CONFIG_DVB_SP2=m
# end of Customise DVB Frontends
# end of Media ancillary drivers

#
# Graphics support
#
CONFIG_APERTURE_HELPERS=y
CONFIG_VIDEO_NOMODESET=y
# CONFIG_AGP is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_USE_DYNAMIC_DEBUG=y
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
CONFIG_DRM_DEBUG_MODESET_LOCK=y
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_DISPLAY_HELPER=m
CONFIG_DRM_DISPLAY_DP_HELPER=y
# CONFIG_DRM_DP_AUX_CHARDEV is not set
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_GEM_SHMEM_HELPER=m
CONFIG_DRM_SCHED=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=m
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_VGEM=m
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_QXL is not set
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
CONFIG_DRM_ANALOGIX_ANX78XX=m
CONFIG_DRM_ANALOGIX_DP=m
# end of Display Interface Bridges

CONFIG_DRM_ETNAVIV=m
CONFIG_DRM_ETNAVIV_THERMAL=y
# CONFIG_DRM_BOCHS is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_GM12U320=m
CONFIG_DRM_SIMPLEDRM=m
CONFIG_DRM_XEN=y
CONFIG_DRM_XEN_FRONTEND=m
# CONFIG_DRM_VBOXVIDEO is not set
CONFIG_DRM_GUD=m
CONFIG_DRM_SSD130X=m
CONFIG_DRM_SSD130X_I2C=m
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=m

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=m
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_SMSCUFX=m
# CONFIG_FB_UDL is not set
CONFIG_FB_IBM_GXT4500=m
CONFIG_FB_VIRTUAL=m
# CONFIG_XEN_FBDEV_FRONTEND is not set
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
CONFIG_FB_SIMPLE=m
# CONFIG_FB_SSD1307 is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_KTD253=m
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_DA903X=m
CONFIG_BACKLIGHT_DA9052=m
CONFIG_BACKLIGHT_MAX8925=m
# CONFIG_BACKLIGHT_MT6370 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_QCOM_WLED=m
CONFIG_BACKLIGHT_RT4831=m
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_WM831X=m
# CONFIG_BACKLIGHT_ADP5520 is not set
CONFIG_BACKLIGHT_ADP8860=m
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_PCF50633=m
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_PANDORA=m
CONFIG_BACKLIGHT_GPIO=m
CONFIG_BACKLIGHT_LV5207LP=m
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
CONFIG_BACKLIGHT_RAVE_SP=m
# end of Backlight & LCD device support

CONFIG_VIDEOMODE_HELPERS=y
CONFIG_HDMI=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
# end of Graphics support

# CONFIG_DRM_ACCEL is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACCUTOUCH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_ASUS is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
# CONFIG_HID_CMEDIA is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_GEMBIRD is not set
# CONFIG_HID_GFRM is not set
# CONFIG_HID_GLORIOUS is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_VIVALDI is not set
# CONFIG_HID_GT683R is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_VIEWSONIC is not set
# CONFIG_HID_VRC2 is not set
# CONFIG_HID_XIAOMI is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_ITE is not set
# CONFIG_HID_JABRA is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LED is not set
# CONFIG_HID_LENOVO is not set
# CONFIG_HID_LETSKETCH is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_MEGAWORLD_FF is not set
# CONFIG_HID_REDRAGON is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NINTENDO is not set
# CONFIG_HID_NTI is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PENMOUNT is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PLANTRONICS is not set
# CONFIG_HID_PLAYSTATION is not set
# CONFIG_HID_PXRC is not set
# CONFIG_HID_RAZER is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SEMITEK is not set
# CONFIG_HID_SIGMAMICRO is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEAM is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_TOPRE is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set
# CONFIG_HID_ALPS is not set
# CONFIG_HID_MCP2221 is not set
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
# end of USB HID Boot Protocol drivers
# end of USB HID support

#
# I2C HID support
#
# CONFIG_I2C_HID_ACPI is not set
# end of I2C HID support

#
# Intel ISH HID support
#
# CONFIG_INTEL_ISH_HID is not set
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
# CONFIG_AMD_SFH_HID is not set
# end of AMD SFH HID Support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
CONFIG_USB_ULPI_BUS=y
CONFIG_USB_CONN_GPIO=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
CONFIG_USB_PCI=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
# CONFIG_USB_OTG_DISABLE_EXTERNAL_HUB is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=m
CONFIG_USB_AUTOSUSPEND_DELAY=2
# CONFIG_USB_MON is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_XHCI_HCD=m
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=m
CONFIG_USB_XHCI_PCI_RENESAS=m
CONFIG_USB_XHCI_PLATFORM=m
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=m
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_HCD_BCMA=m
# CONFIG_USB_HCD_TEST_MODE is not set
CONFIG_USB_XEN_HCD=m

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=m
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
# CONFIG_USBIP_CORE is not set

#
# USB dual-mode controller drivers
#
# CONFIG_USB_CDNS_SUPPORT is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=m
# CONFIG_USB_DWC2_HOST is not set

#
# Gadget/Dual-role mode requires USB Gadget support to be enabled
#
CONFIG_USB_DWC2_PERIPHERAL=y
# CONFIG_USB_DWC2_DUAL_ROLE is not set
# CONFIG_USB_DWC2_PCI is not set
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
CONFIG_USB_DWC2_DEBUG_PERIODIC=y
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_UDC=y
CONFIG_USB_CHIPIDEA_PCI=m
CONFIG_USB_CHIPIDEA_MSM=m
CONFIG_USB_CHIPIDEA_GENERIC=m
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_CYPRESS_CY7C63=m
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=m
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_APPLE_MFI_FASTCHARGE is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_HSIC_USB4604=m
# CONFIG_USB_LINK_LAYER_TEST is not set
CONFIG_USB_CHAOSKEY=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=m
CONFIG_TAHVO_USB=y
CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
CONFIG_USB_ISP1301=y
# end of USB Physical Layer drivers

CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_VERBOSE=y
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_GR_UDC=m
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_PXA27X=y
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
CONFIG_USB_M66592=y
CONFIG_USB_BDC_UDC=y
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# end of USB Peripheral Controller

CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_F_SS_LB=y
CONFIG_USB_F_MASS_STORAGE=m
CONFIG_USB_F_FS=y
CONFIG_USB_F_UVC=m
CONFIG_USB_F_HID=y
CONFIG_USB_F_PRINTER=y
CONFIG_USB_F_TCM=m
CONFIG_USB_CONFIGFS=m
# CONFIG_USB_CONFIGFS_SERIAL is not set
# CONFIG_USB_CONFIGFS_ACM is not set
# CONFIG_USB_CONFIGFS_OBEX is not set
# CONFIG_USB_CONFIGFS_NCM is not set
# CONFIG_USB_CONFIGFS_ECM is not set
# CONFIG_USB_CONFIGFS_ECM_SUBSET is not set
# CONFIG_USB_CONFIGFS_RNDIS is not set
# CONFIG_USB_CONFIGFS_EEM is not set
CONFIG_USB_CONFIGFS_MASS_STORAGE=y
CONFIG_USB_CONFIGFS_F_LB_SS=y
CONFIG_USB_CONFIGFS_F_FS=y
# CONFIG_USB_CONFIGFS_F_HID is not set
CONFIG_USB_CONFIGFS_F_UVC=y
# CONFIG_USB_CONFIGFS_F_PRINTER is not set
CONFIG_USB_CONFIGFS_F_TCM=y

#
# USB Gadget precomposed configurations
#
CONFIG_USB_ZERO=y
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
CONFIG_USB_FUNCTIONFS=y
# CONFIG_USB_FUNCTIONFS_ETH is not set
# CONFIG_USB_FUNCTIONFS_RNDIS is not set
CONFIG_USB_FUNCTIONFS_GENERIC=y
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
CONFIG_USB_G_PRINTER=y
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
CONFIG_USB_G_HID=y
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
CONFIG_USB_RAW_GADGET=y
# end of USB Gadget precomposed configurations

CONFIG_TYPEC=y
CONFIG_TYPEC_TCPM=m
CONFIG_TYPEC_TCPCI=m
CONFIG_TYPEC_RT1711H=m
# CONFIG_TYPEC_MT6360 is not set
CONFIG_TYPEC_TCPCI_MT6370=m
CONFIG_TYPEC_TCPCI_MAXIM=m
CONFIG_TYPEC_FUSB302=m
# CONFIG_TYPEC_UCSI is not set
# CONFIG_TYPEC_TPS6598X is not set
CONFIG_TYPEC_ANX7411=m
CONFIG_TYPEC_RT1719=m
CONFIG_TYPEC_HD3SS3220=m
CONFIG_TYPEC_STUSB160X=m
CONFIG_TYPEC_WUSB3801=m

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_FSA4480 is not set
CONFIG_TYPEC_MUX_PI3USB30532=m
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
CONFIG_TYPEC_DP_ALTMODE=m
CONFIG_TYPEC_NVIDIA_ALTMODE=m
# end of USB Type-C Alternate Mode drivers

CONFIG_USB_ROLE_SWITCH=y
# CONFIG_USB_ROLES_INTEL_XHCI is not set
CONFIG_MMC=y
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set
CONFIG_MMC_CRYPTO=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MMC_USDHI6ROL0 is not set
# CONFIG_MMC_REALTEK_USB is not set
CONFIG_MMC_CQHCI=y
CONFIG_MMC_HSQ=m
# CONFIG_MMC_TOSHIBA_PCI is not set
CONFIG_MMC_MTK=y
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m
CONFIG_LEDS_CLASS_FLASH=m
CONFIG_LEDS_CLASS_MULTICOLOR=m
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
CONFIG_LEDS_APU=m
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3532=m
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_MT6323=m
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
# CONFIG_LEDS_LP50XX is not set
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA955X_GPIO is not set
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_WM831X_STATUS=m
# CONFIG_LEDS_DA903X is not set
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_TLC591XX=m
CONFIG_LEDS_LM355x=m
CONFIG_LEDS_MENF21BMC=m
# CONFIG_LEDS_IS31FL319X is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
CONFIG_LEDS_MLXREG=m
CONFIG_LEDS_USER=m
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set
CONFIG_LEDS_TPS6105X=m

#
# Flash and Torch LED drivers
#
CONFIG_LEDS_AS3645A=m
CONFIG_LEDS_LM3601X=m
CONFIG_LEDS_RT8515=m
CONFIG_LEDS_SGM3140=m

#
# RGB LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_DISK is not set
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_ACTIVITY=m
CONFIG_LEDS_TRIGGER_GPIO=m
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
CONFIG_LEDS_TRIGGER_PATTERN=y
CONFIG_LEDS_TRIGGER_AUDIO=y
# CONFIG_LEDS_TRIGGER_TTY is not set

#
# Simple LED drivers
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_IE31200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
# CONFIG_EDAC_SBRIDGE is not set
# CONFIG_EDAC_SKX is not set
# CONFIG_EDAC_I10NM is not set
# CONFIG_EDAC_PND2 is not set
# CONFIG_EDAC_IGEN6 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=m
# CONFIG_INTEL_IDXD_COMPAT is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_PLX_DMA is not set
# CONFIG_AMD_PTDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
CONFIG_QCOM_HIDMA=m
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set
CONFIG_INTEL_LDMA=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
# CONFIG_UDMABUF is not set
CONFIG_DMABUF_MOVE_NOTIFY=y
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
CONFIG_DMABUF_HEAPS=y
CONFIG_DMABUF_SYSFS_STATS=y
# CONFIG_DMABUF_HEAPS_SYSTEM is not set
# CONFIG_DMABUF_HEAPS_CMA is not set
# end of DMABUF options

# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VFIO=m
CONFIG_VFIO_CONTAINER=y
CONFIG_VFIO_IOMMU_TYPE1=m
# CONFIG_VFIO_NOIOMMU is not set
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
# CONFIG_VFIO_PCI is not set
CONFIG_VFIO_MDEV=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO_ANCHOR=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MENU=y
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MEM is not set
# CONFIG_VIRTIO_INPUT is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
# CONFIG_VDPA is not set
CONFIG_VHOST_MENU=y
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# end of Microsoft Hyper-V guest support

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XEN_BACKEND is not set
# CONFIG_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
CONFIG_XEN_GRANT_DEV_ALLOC=y
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
# CONFIG_XEN_PVCALLS_FRONTEND is not set
# CONFIG_XEN_PRIVCMD is not set
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
CONFIG_XEN_FRONT_PGDIR_SHBUF=m
CONFIG_XEN_GRANT_DMA_OPS=y
CONFIG_XEN_VIRTIO=y
CONFIG_XEN_VIRTIO_FORCE_GRANT=y
# end of Xen driver support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
CONFIG_STAGING=y
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_RTS5208 is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# end of Accelerometers

#
# Analog to digital converters
#
# end of Analog to digital converters

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=m
# CONFIG_ADT7316_I2C is not set
# end of Analog digital bi-direction converters

#
# Direct Digital Synthesis
#
# end of Direct Digital Synthesis

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=m
# end of Network Analyzer, Impedance Converters

#
# Active energy metering IC
#
# CONFIG_ADE7854 is not set
# end of Active energy metering IC

#
# Resolver to digital converters
#
# end of Resolver to digital converters
# end of IIO staging drivers

# CONFIG_FB_SM750 is not set
# CONFIG_STAGING_MEDIA is not set
# CONFIG_LTE_GDM724X is not set
# CONFIG_KS7010 is not set
# CONFIG_FIELDBUS_DEV is not set
# CONFIG_QLGE is not set
# CONFIG_VME_BUS is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_ACPI is not set
CONFIG_CHROMEOS_LAPTOP=m
# CONFIG_CHROMEOS_PSTORE is not set
# CONFIG_CHROMEOS_TBMC is not set
# CONFIG_CROS_EC is not set
# CONFIG_CROS_KBD_LED_BACKLIGHT is not set
# CONFIG_CROS_HPS_I2C is not set
# CONFIG_CHROMEOS_PRIVACY_SCREEN is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
CONFIG_MLXREG_IO=m
# CONFIG_MLXREG_LC is not set
# CONFIG_NVSW_SN2201 is not set
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
# CONFIG_SURFACE_AGGREGATOR is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_P2SB is not set
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_COMMON_CLK_WM831X is not set
CONFIG_COMMON_CLK_MAX9485=m
# CONFIG_COMMON_CLK_SI5341 is not set
CONFIG_COMMON_CLK_SI5351=y
CONFIG_COMMON_CLK_SI544=y
# CONFIG_COMMON_CLK_CDCE706 is not set
CONFIG_COMMON_CLK_CS2000_CP=y
# CONFIG_XILINX_VCU is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
# CONFIG_PCC is not set
CONFIG_ALTERA_MBOX=m
CONFIG_IOMMU_IOVA=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

CONFIG_IOMMU_DEBUGFS=y
# CONFIG_IOMMU_DEFAULT_DMA_STRICT is not set
# CONFIG_IOMMU_DEFAULT_DMA_LAZY is not set
CONFIG_IOMMU_DEFAULT_PASSTHROUGH=y
CONFIG_IOMMU_DMA=y
# CONFIG_AMD_IOMMU is not set
CONFIG_IOMMUFD=m
# CONFIG_VIRTIO_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
CONFIG_RPMSG=m
# CONFIG_RPMSG_CHAR is not set
# CONFIG_RPMSG_CTRL is not set
CONFIG_RPMSG_NS=m
CONFIG_RPMSG_QCOM_GLINK=m
CONFIG_RPMSG_QCOM_GLINK_RPM=m
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# fujitsu SoC drivers
#
# end of fujitsu SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

CONFIG_SOC_TI=y

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=m
CONFIG_DEVFREQ_GOV_USERSPACE=y
CONFIG_DEVFREQ_GOV_PASSIVE=m

#
# DEVFREQ Drivers
#
CONFIG_PM_DEVFREQ_EVENT=y
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=m
# CONFIG_EXTCON_FSA9480 is not set
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_INTEL_INT3496 is not set
# CONFIG_EXTCON_MAX14577 is not set
CONFIG_EXTCON_MAX3355=y
CONFIG_EXTCON_MAX77843=y
CONFIG_EXTCON_PTN5150=y
CONFIG_EXTCON_RT8973A=m
# CONFIG_EXTCON_SM5502 is not set
# CONFIG_EXTCON_USB_GPIO is not set
CONFIG_EXTCON_USBC_TUSB320=m
CONFIG_MEMORY=y
CONFIG_FPGA_DFL_EMIF=m
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=m
CONFIG_IIO_BUFFER_DMA=m
CONFIG_IIO_BUFFER_DMAENGINE=m
CONFIG_IIO_BUFFER_HW_CONSUMER=m
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_CONFIGFS=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
CONFIG_IIO_SW_DEVICE=m
CONFIG_IIO_SW_TRIGGER=m
# CONFIG_IIO_TRIGGERED_EVENT is not set

#
# Accelerometers
#
# CONFIG_ADXL313_I2C is not set
CONFIG_ADXL345=m
CONFIG_ADXL345_I2C=m
CONFIG_ADXL355=m
CONFIG_ADXL355_I2C=m
# CONFIG_ADXL367_I2C is not set
# CONFIG_ADXL372_I2C is not set
CONFIG_BMA180=m
CONFIG_BMA400=m
CONFIG_BMA400_I2C=m
CONFIG_BMC150_ACCEL=m
CONFIG_BMC150_ACCEL_I2C=m
# CONFIG_DA280 is not set
CONFIG_DA311=m
CONFIG_DMARD06=m
# CONFIG_DMARD09 is not set
CONFIG_DMARD10=m
CONFIG_FXLS8962AF=m
CONFIG_FXLS8962AF_I2C=m
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
CONFIG_IIO_KX022A=m
CONFIG_IIO_KX022A_I2C=m
# CONFIG_KXSD9 is not set
# CONFIG_KXCJK1013 is not set
# CONFIG_MC3230 is not set
CONFIG_MMA7455=m
CONFIG_MMA7455_I2C=m
# CONFIG_MMA7660 is not set
CONFIG_MMA8452=m
CONFIG_MMA9551_CORE=m
CONFIG_MMA9551=m
CONFIG_MMA9553=m
CONFIG_MSA311=m
CONFIG_MXC4005=m
# CONFIG_MXC6255 is not set
CONFIG_STK8312=m
# CONFIG_STK8BA50 is not set
# end of Accelerometers

#
# Analog to digital converters
#
CONFIG_AD7091R5=m
CONFIG_AD7291=m
CONFIG_AD7606=m
CONFIG_AD7606_IFACE_PARALLEL=m
CONFIG_AD799X=m
CONFIG_AXP20X_ADC=m
# CONFIG_AXP288_ADC is not set
CONFIG_CC10001_ADC=m
CONFIG_DA9150_GPADC=m
CONFIG_DLN2_ADC=m
CONFIG_ENVELOPE_DETECTOR=m
# CONFIG_HX711 is not set
# CONFIG_INA2XX_ADC is not set
CONFIG_LTC2471=m
# CONFIG_LTC2485 is not set
# CONFIG_LTC2497 is not set
CONFIG_MAX1363=m
CONFIG_MAX9611=m
CONFIG_MCP3422=m
CONFIG_MEDIATEK_MT6360_ADC=m
# CONFIG_MEDIATEK_MT6370_ADC is not set
CONFIG_MP2629_ADC=m
# CONFIG_NAU7802 is not set
CONFIG_QCOM_VADC_COMMON=m
CONFIG_QCOM_SPMI_IADC=m
# CONFIG_QCOM_SPMI_VADC is not set
CONFIG_QCOM_SPMI_ADC5=m
CONFIG_RICHTEK_RTQ6056=m
CONFIG_SD_ADC_MODULATOR=m
# CONFIG_TI_ADC081C is not set
CONFIG_TI_ADS1015=m
# CONFIG_TI_AM335X_ADC is not set
CONFIG_TWL4030_MADC=m
# CONFIG_TWL6030_GPADC is not set
CONFIG_VF610_ADC=m
# CONFIG_XILINX_XADC is not set
# end of Analog to digital converters

#
# Analog to digital and digital to analog converters
#
# CONFIG_STX104 is not set
# end of Analog to digital and digital to analog converters

#
# Analog Front Ends
#
CONFIG_IIO_RESCALE=m
# end of Analog Front Ends

#
# Amplifiers
#
CONFIG_HMC425=m
# end of Amplifiers

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7746 is not set
# end of Capacitance to digital converters

#
# Chemical Sensors
#
CONFIG_ATLAS_PH_SENSOR=m
CONFIG_ATLAS_EZO_SENSOR=m
CONFIG_BME680=m
CONFIG_BME680_I2C=m
# CONFIG_CCS811 is not set
CONFIG_IAQCORE=m
CONFIG_PMS7003=m
CONFIG_SCD30_CORE=m
CONFIG_SCD30_I2C=m
CONFIG_SCD30_SERIAL=m
# CONFIG_SCD4X is not set
# CONFIG_SENSIRION_SGP30 is not set
# CONFIG_SENSIRION_SGP40 is not set
CONFIG_SPS30=m
CONFIG_SPS30_I2C=m
CONFIG_SPS30_SERIAL=m
CONFIG_SENSEAIR_SUNRISE_CO2=m
# CONFIG_VZ89X is not set
# end of Chemical Sensors

#
# Hid Sensor IIO Common
#
# end of Hid Sensor IIO Common

CONFIG_IIO_MS_SENSORS_I2C=m

#
# IIO SCMI Sensors
#
# end of IIO SCMI Sensors

#
# SSP Sensor Common
#
# end of SSP Sensor Common

CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
# CONFIG_AD5380 is not set
CONFIG_AD5446=m
CONFIG_AD5592R_BASE=m
CONFIG_AD5593R=m
CONFIG_AD5686=m
CONFIG_AD5696_I2C=m
# CONFIG_CIO_DAC is not set
# CONFIG_DPOT_DAC is not set
CONFIG_DS4424=m
CONFIG_M62332=m
CONFIG_MAX517=m
CONFIG_MAX5821=m
CONFIG_MCP4725=m
CONFIG_TI_DAC5571=m
CONFIG_VF610_DAC=m
# end of Digital to analog converters

#
# IIO dummy driver
#
# CONFIG_IIO_SIMPLE_DUMMY is not set
# end of IIO dummy driver

#
# Filters
#
# end of Filters

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# end of Clock Generator/Distribution

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
CONFIG_BMG160=m
CONFIG_BMG160_I2C=m
CONFIG_FXAS21002C=m
CONFIG_FXAS21002C_I2C=m
# CONFIG_MPU3050_I2C is not set
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_ITG3200=m
# end of Digital gyroscope sensors

#
# Health Sensors
#

#
# Heart Rate Monitors
#
CONFIG_AFE4404=m
CONFIG_MAX30100=m
CONFIG_MAX30102=m
# end of Heart Rate Monitors
# end of Health Sensors

#
# Humidity sensors
#
# CONFIG_AM2315 is not set
CONFIG_DHT11=m
CONFIG_HDC100X=m
CONFIG_HDC2010=m
CONFIG_HTS221=m
CONFIG_HTS221_I2C=m
CONFIG_HTU21=m
# CONFIG_SI7005 is not set
# CONFIG_SI7020 is not set
# end of Humidity sensors

#
# Inertial measurement units
#
CONFIG_BMI160=m
CONFIG_BMI160_I2C=m
CONFIG_BOSCH_BNO055=m
CONFIG_BOSCH_BNO055_SERIAL=m
CONFIG_BOSCH_BNO055_I2C=m
CONFIG_FXOS8700=m
CONFIG_FXOS8700_I2C=m
# CONFIG_KMX61 is not set
# CONFIG_INV_ICM42600_I2C is not set
CONFIG_INV_MPU6050_IIO=m
CONFIG_INV_MPU6050_I2C=m
CONFIG_IIO_ST_LSM6DSX=m
CONFIG_IIO_ST_LSM6DSX_I2C=m
CONFIG_IIO_ST_LSM9DS0=m
CONFIG_IIO_ST_LSM9DS0_I2C=m
# end of Inertial measurement units

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
# CONFIG_ADJD_S311 is not set
# CONFIG_ADUX1020 is not set
CONFIG_AL3010=m
CONFIG_AL3320A=m
CONFIG_APDS9300=m
CONFIG_APDS9960=m
# CONFIG_AS73211 is not set
# CONFIG_BH1750 is not set
CONFIG_BH1780=m
CONFIG_CM32181=m
# CONFIG_CM3232 is not set
CONFIG_CM3323=m
# CONFIG_CM3605 is not set
# CONFIG_CM36651 is not set
CONFIG_GP2AP002=m
CONFIG_GP2AP020A00F=m
# CONFIG_SENSORS_ISL29018 is not set
CONFIG_SENSORS_ISL29028=m
CONFIG_ISL29125=m
# CONFIG_JSA1212 is not set
CONFIG_RPR0521=m
CONFIG_SENSORS_LM3533=m
# CONFIG_LTR501 is not set
CONFIG_LTRF216A=m
# CONFIG_LV0104CS is not set
CONFIG_MAX44000=m
CONFIG_MAX44009=m
CONFIG_NOA1305=m
CONFIG_OPT3001=m
CONFIG_PA12203001=m
CONFIG_SI1133=m
# CONFIG_SI1145 is not set
CONFIG_STK3310=m
CONFIG_ST_UVIS25=m
CONFIG_ST_UVIS25_I2C=m
CONFIG_TCS3414=m
CONFIG_TCS3472=m
CONFIG_SENSORS_TSL2563=m
# CONFIG_TSL2583 is not set
CONFIG_TSL2591=m
CONFIG_TSL2772=m
CONFIG_TSL4531=m
# CONFIG_US5182D is not set
CONFIG_VCNL4000=m
CONFIG_VCNL4035=m
CONFIG_VEML6030=m
CONFIG_VEML6070=m
# CONFIG_VL6180 is not set
# CONFIG_ZOPT2201 is not set
# end of Light sensors

#
# Magnetometer sensors
#
# CONFIG_AK8974 is not set
CONFIG_AK8975=m
CONFIG_AK09911=m
CONFIG_BMC150_MAGN=m
CONFIG_BMC150_MAGN_I2C=m
CONFIG_MAG3110=m
# CONFIG_MMC35240 is not set
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m
CONFIG_SENSORS_HMC5843=m
CONFIG_SENSORS_HMC5843_I2C=m
# CONFIG_SENSORS_RM3100_I2C is not set
CONFIG_YAMAHA_YAS530=m
# end of Magnetometer sensors

#
# Multiplexers
#
# CONFIG_IIO_MUX is not set
# end of Multiplexers

#
# Inclinometer sensors
#
# end of Inclinometer sensors

#
# Triggers - standalone
#
# CONFIG_IIO_HRTIMER_TRIGGER is not set
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_TIGHTLOOP_TRIGGER=m
# CONFIG_IIO_SYSFS_TRIGGER is not set
# end of Triggers - standalone

#
# Linear and angular position sensors
#
# end of Linear and angular position sensors

#
# Digital potentiometers
#
# CONFIG_AD5110 is not set
CONFIG_AD5272=m
CONFIG_DS1803=m
CONFIG_MAX5432=m
# CONFIG_MCP4018 is not set
CONFIG_MCP4531=m
CONFIG_TPL0102=m
# end of Digital potentiometers

#
# Digital potentiostats
#
# CONFIG_LMP91000 is not set
# end of Digital potentiostats

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
CONFIG_BMP280=m
CONFIG_BMP280_I2C=m
# CONFIG_DLHL60D is not set
CONFIG_DPS310=m
# CONFIG_HP03 is not set
# CONFIG_ICP10100 is not set
# CONFIG_MPL115_I2C is not set
CONFIG_MPL3115=m
CONFIG_MS5611=m
CONFIG_MS5611_I2C=m
# CONFIG_MS5637 is not set
# CONFIG_IIO_ST_PRESS is not set
# CONFIG_T5403 is not set
CONFIG_HP206C=m
CONFIG_ZPA2326=m
CONFIG_ZPA2326_I2C=m
# end of Pressure sensors

#
# Lightning sensors
#
# end of Lightning sensors

#
# Proximity and distance sensors
#
# CONFIG_ISL29501 is not set
# CONFIG_LIDAR_LITE_V2 is not set
CONFIG_MB1232=m
CONFIG_PING=m
CONFIG_RFD77402=m
CONFIG_SRF04=m
CONFIG_SX_COMMON=m
CONFIG_SX9310=m
CONFIG_SX9324=m
CONFIG_SX9360=m
# CONFIG_SX9500 is not set
# CONFIG_SRF08 is not set
CONFIG_VCNL3020=m
CONFIG_VL53L0X_I2C=m
# end of Proximity and distance sensors

#
# Resolver to digital converters
#
# end of Resolver to digital converters

#
# Temperature sensors
#
# CONFIG_MLX90614 is not set
CONFIG_MLX90632=m
CONFIG_TMP006=m
CONFIG_TMP007=m
# CONFIG_TMP117 is not set
CONFIG_TSYS01=m
CONFIG_TSYS02D=m
CONFIG_MAX30208=m
# end of Temperature sensors

# CONFIG_NTB is not set
# CONFIG_PWM is not set

#
# IRQ chip support
#
CONFIG_MADERA_IRQ=y
# end of IRQ chip support

CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_RESET_SIMPLE=y
CONFIG_RESET_TI_SYSCON=m
CONFIG_RESET_TI_TPS380X=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_USB_LGM_PHY=y
CONFIG_PHY_CAN_TRANSCEIVER=y

#
# PHY drivers for Broadcom platforms
#
CONFIG_BCM_KONA_USB2_PHY=m
# end of PHY drivers for Broadcom platforms

CONFIG_PHY_PXA_28NM_HSIC=y
CONFIG_PHY_PXA_28NM_USB2=y
CONFIG_PHY_CPCAP_USB=m
# CONFIG_PHY_QCOM_USB_HS is not set
# CONFIG_PHY_QCOM_USB_HSIC is not set
# CONFIG_PHY_SAMSUNG_USB2 is not set
CONFIG_PHY_TUSB1210=y
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_USB4 is not set

#
# Android
#
CONFIG_ANDROID_BINDER_IPC=y
# CONFIG_ANDROID_BINDERFS is not set
CONFIG_ANDROID_BINDER_DEVICES="binder,hwbinder,vndbinder"
# CONFIG_ANDROID_BINDER_IPC_SELFTEST is not set
# end of Android

# CONFIG_LIBNVDIMM is not set
CONFIG_DAX=m
CONFIG_NVMEM=y
# CONFIG_NVMEM_SYSFS is not set
CONFIG_NVMEM_RAVE_SP_EEPROM=y
# CONFIG_NVMEM_RMEM is not set
# CONFIG_NVMEM_SPMI_SDAM is not set

#
# HW tracing support
#
CONFIG_STM=y
# CONFIG_STM_PROTO_BASIC is not set
CONFIG_STM_PROTO_SYS_T=y
CONFIG_STM_DUMMY=y
CONFIG_STM_SOURCE_CONSOLE=m
# CONFIG_STM_SOURCE_HEARTBEAT is not set
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=y
# CONFIG_INTEL_TH_PCI is not set
# CONFIG_INTEL_TH_ACPI is not set
# CONFIG_INTEL_TH_GTH is not set
CONFIG_INTEL_TH_STH=y
# CONFIG_INTEL_TH_MSU is not set
CONFIG_INTEL_TH_PTI=y
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

CONFIG_FPGA=y
CONFIG_ALTERA_PR_IP_CORE=y
# CONFIG_FPGA_MGR_ALTERA_CVP is not set
CONFIG_FPGA_BRIDGE=y
# CONFIG_ALTERA_FREEZE_BRIDGE is not set
CONFIG_XILINX_PR_DECOUPLER=y
CONFIG_FPGA_REGION=m
CONFIG_FPGA_DFL=m
CONFIG_FPGA_DFL_FME=m
CONFIG_FPGA_DFL_FME_MGR=m
# CONFIG_FPGA_DFL_FME_BRIDGE is not set
CONFIG_FPGA_DFL_FME_REGION=m
CONFIG_FPGA_DFL_AFU=m
CONFIG_FPGA_DFL_NIOS_INTEL_PAC_N3000=m
# CONFIG_FPGA_DFL_PCI is not set
CONFIG_MULTIPLEXER=y

#
# Multiplexer drivers
#
# CONFIG_MUX_ADG792A is not set
CONFIG_MUX_GPIO=m
# end of Multiplexer drivers

CONFIG_PM_OPP=y
CONFIG_SIOX=y
CONFIG_SIOX_BUS_GPIO=y
CONFIG_SLIMBUS=m
CONFIG_SLIM_QCOM_CTRL=m
CONFIG_INTERCONNECT=y
CONFIG_COUNTER=y
CONFIG_104_QUAD_8=m
CONFIG_INTERRUPT_CNT=m
# CONFIG_INTEL_QEP is not set
# CONFIG_MOST is not set
CONFIG_PECI=y
CONFIG_PECI_CPU=y
CONFIG_HTE=y
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_VALIDATE_FS_PARSER=y
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_REPAIR=y
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_F2FS_FS=m
# CONFIG_F2FS_STAT_FS is not set
# CONFIG_F2FS_FS_XATTR is not set
CONFIG_F2FS_CHECK_FS=y
# CONFIG_F2FS_FAULT_INJECTION is not set
CONFIG_F2FS_FS_COMPRESSION=y
# CONFIG_F2FS_FS_LZO is not set
CONFIG_F2FS_FS_LZ4=y
CONFIG_F2FS_FS_LZ4HC=y
# CONFIG_F2FS_FS_ZSTD is not set
# CONFIG_F2FS_IOSTAT is not set
CONFIG_ZONEFS_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
# CONFIG_FS_ENCRYPTION is not set
CONFIG_FS_VERITY=y
CONFIG_FS_VERITY_DEBUG=y
# CONFIG_FS_VERITY_BUILTIN_SIGNATURES is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=m
CONFIG_VIRTIO_FS=y
# CONFIG_OVERLAY_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_FAT_DEFAULT_UTF8=y
# CONFIG_EXFAT_FS is not set
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set
CONFIG_NTFS3_FS=m
# CONFIG_NTFS3_64BIT_CLUSTER is not set
CONFIG_NTFS3_LZX_XPRESS=y
CONFIG_NTFS3_FS_POSIX_ACL=y
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
# CONFIG_PROC_CHILDREN is not set
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_TMPFS_INODE64=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
# CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON is not set
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
# end of Pseudo filesystems

# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=m
# CONFIG_NFS_V4_1 is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFSD is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_SMB_SERVER is not set
CONFIG_SMBFS_COMMON=m
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set
CONFIG_UNICODE=y
# CONFIG_UNICODE_NORMALIZATION_SELFTEST is not set
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_REQUEST_CACHE=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=m
CONFIG_TRUSTED_KEYS_TPM=y
CONFIG_ENCRYPTED_KEYS=m
CONFIG_USER_DECRYPTED_DATA=y
CONFIG_KEY_DH_OPERATIONS=y
# CONFIG_KEY_NOTIFICATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_NETWORK is not set
# CONFIG_SECURITY_PATH is not set
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
# CONFIG_HARDENED_USERCOPY is not set
CONFIG_FORTIFY_SOURCE=y
CONFIG_STATIC_USERMODEHELPER=y
CONFIG_STATIC_USERMODEHELPER_PATH="/sbin/usermode-helper"
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_SECURITY_LANDLOCK is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
CONFIG_INIT_ON_FREE_DEFAULT_ON=y
CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
CONFIG_ZERO_CALL_USED_REGS=y
# end of Memory initialization

# CONFIG_RANDSTRUCT_NONE is not set
CONFIG_RANDSTRUCT_FULL=y
# CONFIG_RANDSTRUCT_PERFORMANCE is not set
CONFIG_RANDSTRUCT=y
CONFIG_GCC_PLUGIN_RANDSTRUCT=y
# end of Kernel hardening options
# end of Security options

CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=y
# end of Crypto core or helper

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_DH_RFC7919_GROUPS=y
CONFIG_CRYPTO_ECC=y
CONFIG_CRYPTO_ECDH=m
CONFIG_CRYPTO_ECDSA=m
CONFIG_CRYPTO_ECRDSA=y
CONFIG_CRYPTO_SM2=y
# CONFIG_CRYPTO_CURVE25519 is not set
# end of Public-key cryptography

#
# Block ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_TI=m
CONFIG_CRYPTO_ARIA=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SM4=m
CONFIG_CRYPTO_SM4_GENERIC=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
# end of Block ciphers

#
# Length-preserving ciphers and modes
#
# CONFIG_CRYPTO_ADIANTUM is not set
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CFB is not set
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_HCTR2 is not set
CONFIG_CRYPTO_KEYWRAP=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_OFB=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
CONFIG_CRYPTO_NHPOLY1305=y
# end of Length-preserving ciphers and modes

#
# AEAD (authenticated encryption with associated data) ciphers
#
CONFIG_CRYPTO_AEGIS128=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m
# CONFIG_CRYPTO_ECHAINIV is not set
CONFIG_CRYPTO_ESSIV=y
# end of AEAD (authenticated encryption with associated data) ciphers

#
# Hashes, digests, and MACs
#
CONFIG_CRYPTO_BLAKE2B=m
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_POLYVAL=y
# CONFIG_CRYPTO_POLY1305 is not set
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_SHA3 is not set
CONFIG_CRYPTO_SM3=y
CONFIG_CRYPTO_SM3_GENERIC=y
CONFIG_CRYPTO_STREEBOG=y
CONFIG_CRYPTO_VMAC=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_XXHASH=y
# end of Hashes, digests, and MACs

#
# CRCs (cyclic redundancy checks)
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRC64_ROCKSOFT=y
# end of CRCs (cyclic redundancy checks)

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_842=y
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set
CONFIG_CRYPTO_ZSTD=y
# end of Compression

#
# Random number generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_KDF800108_CTR=y
# end of Random number generation

#
# Userspace interface
#
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_USER_API_RNG is not set
# CONFIG_CRYPTO_USER_API_AEAD is not set
# end of Userspace interface

CONFIG_CRYPTO_HASH_INFO=y

#
# Accelerated Cryptographic Algorithms for CPU (x86)
#
CONFIG_CRYPTO_CURVE25519_X86=m
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES3_EDE_X86_64=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64=m
# CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m
CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CHACHA20_X86_64=y
CONFIG_CRYPTO_AEGIS128_AESNI_SSE2=y
CONFIG_CRYPTO_NHPOLY1305_SSE2=y
CONFIG_CRYPTO_NHPOLY1305_AVX2=m
CONFIG_CRYPTO_BLAKE2S_X86=y
CONFIG_CRYPTO_POLYVAL_CLMUL_NI=y
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SM3_AVX_X86_64=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
# end of Accelerated Cryptographic Algorithms for CPU (x86)

# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set

#
# Certificates for signature checking
#
# CONFIG_SYSTEM_BLACKLIST_KEYRING is not set
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_LINEAR_RANGES=y
CONFIG_PACKING=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_CORDIC=m
CONFIG_PRIME_NUMBERS=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_UTILS=y
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_GF128MUL=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S=y
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=y
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=y
CONFIG_CRYPTO_LIB_CHACHA=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519=m
CONFIG_CRYPTO_LIB_CURVE25519_GENERIC=m
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=y
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=y
CONFIG_CRYPTO_LIB_POLY1305=m
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA1=y
CONFIG_CRYPTO_LIB_SHA256=y
# end of Crypto library routines

CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC64_ROCKSOFT=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC64=y
CONFIG_CRC4=m
CONFIG_CRC7=y
CONFIG_LIBCRC32C=m
CONFIG_CRC8=y
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_842_COMPRESS=y
CONFIG_842_DECOMPRESS=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMMON=y
CONFIG_ZSTD_COMPRESS=y
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
# CONFIG_XZ_DEC_MICROLZMA is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_INTERVAL_TREE=y
CONFIG_INTERVAL_TREE_SPAN_ITER=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=y
CONFIG_SWIOTLB=y
CONFIG_DMA_CMA=y
CONFIG_DMA_PERNUMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_PERCENTAGE=0
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
CONFIG_SGL_ALLOC=y
CONFIG_CPUMASK_OFFSTACK=y
# CONFIG_FORCE_NR_CPUS is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_STACKDEPOT_ALWAYS_INIT=y
CONFIG_SBITMAP=y
# end of Library routines

CONFIG_ASN1_ENCODER=m

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
# CONFIG_STACKTRACE_BUILD_ID is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DYNAMIC_DEBUG_CORE=y
# CONFIG_SYMBOLIC_ERRNAME is not set
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_MISC is not set

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_AS_HAS_NON_CONST_LEB128=y
# CONFIG_DEBUG_INFO_NONE is not set
# CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
CONFIG_DEBUG_INFO_DWARF4=y
# CONFIG_DEBUG_INFO_DWARF5 is not set
CONFIG_DEBUG_INFO_REDUCED=y
CONFIG_DEBUG_INFO_COMPRESSED_NONE=y
# CONFIG_DEBUG_INFO_COMPRESSED_ZLIB is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_GDB_SCRIPTS=y
CONFIG_FRAME_WARN=8192
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_HEADERS_INSTALL=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B=y
CONFIG_FRAME_POINTER=y
CONFIG_OBJTOOL=y
# CONFIG_STACK_VALIDATION is not set
CONFIG_VMLINUX_MAP=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
# CONFIG_MAGIC_SYSRQ_SERIAL is not set
CONFIG_DEBUG_FS=y
# CONFIG_DEBUG_FS_ALLOW_ALL is not set
CONFIG_DEBUG_FS_DISALLOW_MOUNT=y
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_CC_HAS_UBSAN_BOUNDS=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_ONLY_BOUNDS=y
CONFIG_UBSAN_SHIFT=y
# CONFIG_UBSAN_DIV_ZERO is not set
# CONFIG_UBSAN_BOOL is not set
# CONFIG_UBSAN_ENUM is not set
# CONFIG_UBSAN_ALIGNMENT is not set
CONFIG_UBSAN_SANITIZE_ALL=y
# CONFIG_TEST_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
CONFIG_HAVE_KCSAN_COMPILER=y
# end of Generic Kernel Debugging Instruments

#
# Networking Debugging
#
# CONFIG_NET_DEV_REFCNT_TRACKER is not set
# CONFIG_NET_NS_REFCNT_TRACKER is not set
# CONFIG_DEBUG_NET is not set
# end of Networking Debugging

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_PAGE_OWNER=y
CONFIG_PAGE_TABLE_CHECK=y
# CONFIG_PAGE_TABLE_CHECK_ENFORCED is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
CONFIG_DEBUG_WX=y
CONFIG_GENERIC_PTDUMP=y
CONFIG_PTDUMP_CORE=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SHRINKER_DEBUG=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
CONFIG_DEBUG_VM_IRQSOFF=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_MAPLE_TREE=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VM_PGFLAGS=y
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
CONFIG_KASAN=y
CONFIG_KASAN_GENERIC=y
# CONFIG_KASAN_OUTLINE is not set
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
# CONFIG_KASAN_MODULE_TEST is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
CONFIG_HAVE_ARCH_KMSAN=y
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_WQ_WATCHDOG=y
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

CONFIG_DEBUG_TIMEKEEPING=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RAW_LOCK_NESTING is not set
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_LOCKDEP_BITS=15
CONFIG_LOCKDEP_CHAINS_BITS=16
CONFIG_LOCKDEP_STACK_TRACE_BITS=19
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
CONFIG_CSD_LOCK_WAIT_DEBUG=y
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_TRACE_IRQFLAGS_NMI=y
CONFIG_DEBUG_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
CONFIG_DEBUG_MAPLE_TREE=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_LIST is not set
CONFIG_TORTURE_TEST=m
CONFIG_RCU_SCALE_TEST=m
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_REF_SCALE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_EXP_CPU_STALL_TIMEOUT=0
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_EQS_DEBUG=y
# end of RCU Debugging

CONFIG_DEBUG_WQ_FORCE_RR_CPU=y
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
# CONFIG_DEBUG_CGROUP_REF is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_RETHOOK=y
CONFIG_RETHOOK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_NO_PATCHABLE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_OBJTOOL_NOP_MCOUNT=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_HAVE_BUILDTIME_MCOUNT_SORT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_HWLAT_TRACER=y
CONFIG_OSNOISE_TRACER=y
CONFIG_TIMERLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENTS=y
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_BPF_KPROBE_OVERRIDE=y
# CONFIG_SYNTH_EVENTS is not set
# CONFIG_HIST_TRIGGERS is not set
CONFIG_TRACE_EVENT_INJECT=y
CONFIG_TRACEPOINT_BENCHMARK=y
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS=y
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_RV is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_SAMPLES=y
CONFIG_SAMPLE_AUXDISPLAY=y
# CONFIG_SAMPLE_TRACE_EVENTS is not set
# CONFIG_SAMPLE_TRACE_CUSTOM_EVENTS is not set
CONFIG_SAMPLE_TRACE_PRINTK=m
CONFIG_SAMPLE_TRACE_ARRAY=m
CONFIG_SAMPLE_KOBJECT=m
# CONFIG_SAMPLE_KPROBES is not set
# CONFIG_SAMPLE_HW_BREAKPOINT is not set
CONFIG_SAMPLE_KFIFO=m
CONFIG_SAMPLE_RPMSG_CLIENT=m
CONFIG_SAMPLE_CONFIGFS=m
CONFIG_SAMPLE_FANOTIFY_ERROR=y
CONFIG_SAMPLE_HIDRAW=y
CONFIG_SAMPLE_LANDLOCK=y
CONFIG_SAMPLE_PIDFD=y
# CONFIG_SAMPLE_TIMER is not set
# CONFIG_SAMPLE_UHID is not set
CONFIG_SAMPLE_VFIO_MDEV_MTTY=m
# CONFIG_SAMPLE_VFIO_MDEV_MDPY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY_FB is not set
CONFIG_SAMPLE_VFIO_MDEV_MBOCHS=m
CONFIG_SAMPLE_ANDROID_BINDERFS=y
CONFIG_SAMPLE_VFS=y
# CONFIG_SAMPLE_WATCHDOG is not set
CONFIG_SAMPLE_WATCH_QUEUE=y
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT=y
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT_MULTI=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y

#
# x86 Debugging
#
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
# CONFIG_UNWINDER_ORC is not set
CONFIG_UNWINDER_FRAME_POINTER=y
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAULT_INJECTION_USERCOPY=y
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAIL_FUNCTION is not set
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
# CONFIG_RUNTIME_TESTING_MENU is not set
CONFIG_ARCH_USE_MEMTEST=y
CONFIG_MEMTEST=y
# end of Kernel Testing and Coverage

#
# Rust hacking
#
# end of Rust hacking
# end of Kernel hacking

--EQB/CcOsoyEfnLnZ
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="job-script"

#!/bin/sh

export_top_env()
{
	export suite='trinity'
	export testcase='trinity'
	export category='functional'
	export need_memory='300MB'
	export runtime=300
	export job_origin='trinity.yaml'
	export queue_cmdline_keys='branch
commit
kbuild_queue_analysis'
	export queue='validate'
	export testbox='vm-snb'
	export tbox_group='vm-snb'
	export branch='linux-review/Kassey-Li/net-disable-irq-in-napi_poll/20230215-152235'
	export commit='ed417c671fa6b56ce9f6db582d21c3a608838929'
	export kconfig='x86_64-randconfig-a012-20230213'
	export repeat_to=6
	export nr_vm=300
	export submit_id='63f3329a2a9522997d09d196'
	export job_file='/lkp/jobs/scheduled/vm-meta-132/trinity-300s-yocto-x86_64-minimal-20190520.cgz-ed417c671fa6b56ce9f6db582d21c3a608838929-20230220-39293-yn2acr-3.yaml'
	export id='b563f077eefe5c93e0057e458eff2595d488daf6'
	export queuer_version='/zday/lkp'
	export model='qemu-system-x86_64 -enable-kvm -cpu SandyBridge'
	export nr_cpu=2
	export memory='16G'
	export need_kconfig=\{\"KVM_GUEST\"\=\>\"y\"\}
	export ssh_base_port=23032
	export kernel_cmdline_hw='vmalloc=256M initramfs_async=0 page_owner=on'
	export rootfs='yocto-x86_64-minimal-20190520.cgz'
	export compiler='gcc-11'
	export enqueue_time='2023-02-20 16:43:06 +0800'
	export _id='63f332b12a9522997d09d197'
	export _rt='/result/trinity/300s/vm-snb/yocto-x86_64-minimal-20190520.cgz/x86_64-randconfig-a012-20230213/gcc-11/ed417c671fa6b56ce9f6db582d21c3a608838929'
	export user='lkp'
	export LKP_SERVER='internal-lkp-server'
	export result_root='/result/trinity/300s/vm-snb/yocto-x86_64-minimal-20190520.cgz/x86_64-randconfig-a012-20230213/gcc-11/ed417c671fa6b56ce9f6db582d21c3a608838929/3'
	export scheduler_version='/lkp/lkp/src'
	export arch='x86_64'
	export max_uptime=1200
	export initrd='/osimage/yocto/yocto-x86_64-minimal-20190520.cgz'
	export bootloader_append='root=/dev/ram0
RESULT_ROOT=/result/trinity/300s/vm-snb/yocto-x86_64-minimal-20190520.cgz/x86_64-randconfig-a012-20230213/gcc-11/ed417c671fa6b56ce9f6db582d21c3a608838929/3
BOOT_IMAGE=/pkg/linux/x86_64-randconfig-a012-20230213/gcc-11/ed417c671fa6b56ce9f6db582d21c3a608838929/vmlinuz-6.2.0-rc7-01664-ged417c671fa6
branch=linux-review/Kassey-Li/net-disable-irq-in-napi_poll/20230215-152235
job=/lkp/jobs/scheduled/vm-meta-132/trinity-300s-yocto-x86_64-minimal-20190520.cgz-ed417c671fa6b56ce9f6db582d21c3a608838929-20230220-39293-yn2acr-3.yaml
user=lkp
ARCH=x86_64
kconfig=x86_64-randconfig-a012-20230213
commit=ed417c671fa6b56ce9f6db582d21c3a608838929
initcall_debug
nmi_watchdog=0
vmalloc=256M initramfs_async=0 page_owner=on
max_uptime=1200
LKP_SERVER=internal-lkp-server
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-randconfig-a012-20230213/gcc-11/ed417c671fa6b56ce9f6db582d21c3a608838929/modules.cgz'
	export bm_initrd='/osimage/pkg/debian-x86_64-20180403.cgz/trinity-static-x86_64-x86_64-1c734c75-1_2020-01-06.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export schedule_notify_address=
	export stop_repeat_if_found='dmesg.WARNING:at_kernel/softirq.c:#__local_bh_enable_ip'
	export kbuild_queue_analysis=1
	export meta_host='vm-meta-132'
	export kernel='/pkg/linux/x86_64-randconfig-a012-20230213/gcc-11/ed417c671fa6b56ce9f6db582d21c3a608838929/vmlinuz-6.2.0-rc7-01664-ged417c671fa6'
	export dequeue_time='2023-02-20 16:43:36 +0800'
	export job_initrd='/lkp/jobs/scheduled/vm-meta-132/trinity-300s-yocto-x86_64-minimal-20190520.cgz-ed417c671fa6b56ce9f6db582d21c3a608838929-20230220-39293-yn2acr-3.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test $LKP_SRC/tests/wrapper trinity
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time trinity.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--EQB/CcOsoyEfnLnZ
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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

--EQB/CcOsoyEfnLnZ
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="trinity"

Seeding trinity by 335537 based on vm-snb/yocto-x86_64-minimal-20190520.cgz/x86_64-randconfig-a012-20230213
2023-02-20 08:44:58 trinity -q -q -l off -s 335537 -x get_robust_list -x remap_file_pages -N 999999999 -X
Trinity 2019.06  Dave Jones <davej@codemonkey.org.uk>
shm:0x7f58e2a28000-0x7f58ef624d00 (4 pages)
[main] Marking syscall get_robust_list (64bit:274 32bit:312) as to be disabled.
[main] Marking syscall remap_file_pages (64bit:216 32bit:257) as to be disabled.
[main] Using user passed random seed: 335537.
[main] Kernel was tainted on startup. Will ignore flags that are already set.
Marking all syscalls as enabled.
[main] Disabling syscalls marked as disabled by command line options
[main] Marked 64-bit syscall remap_file_pages (216) as deactivated.
[main] Marked 64-bit syscall get_robust_list (274) as deactivated.
[main] Marked 32-bit syscall remap_file_pages (257) as deactivated.
[main] Marked 32-bit syscall get_robust_list (312) as deactivated.
[main] 32-bit syscalls: 426 enabled, 3 disabled.  64-bit syscalls: 345 enabled, 91 disabled.
--dropprivs is still in development, and really shouldn't be used unless you're helping development. Expect crashes.
Going to run as user nobody (uid:65534 gid:65534)
ctrl-c now unless you really know what you are doing.
Continuing in 10 seconds.
Continuing in 9 seconds.
Continuing in 8 seconds.
Continuing in 7 seconds.
Continuing in 6 seconds.
Continuing in 5 seconds.
Continuing in 4 seconds.
Continuing in 3 seconds.
Continuing in 2 seconds.
Continuing in 1 seconds.
[main] Using pid_max = 32768
[main] futex: 0 owner:0 global:1
[main] futex: 0 owner:0 global:1
[main] futex: 0 owner:0 global:1
[main] futex: 0 owner:0 global:1
[main] futex: 0 owner:0 global:1
[main] futex: 0 owner:0 global:1
[main] futex: 0 owner:0 global:1
[main] futex: 0 owner:0 global:1
[main] futex: 0 owner:0 global:1
[main] futex: 0 owner:0 global:1
[main] Reserved/initialized 10 futexes.
[main] Added 14 filenames from /dev
[main] Added 16097 filenames from /proc
[main] Added 10382 filenames from /sys
[main] Enabled 14/14 fd providers. initialized:14.
[main] Error opening tracing_on : No such file or directory
[main] 10309 iterations. [F:6998 S:3305 HI:1750]
Segmentation fault

--EQB/CcOsoyEfnLnZ--
