Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF2E69E570
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbjBURCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234983AbjBURCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:02:15 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4F32E83B
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 09:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676998903; x=1708534903;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=wn7cYI9bLY03xibjsQpDXjdRLPwz/wsp72kPSJEWDN0=;
  b=Yj+sKde+MY0zO8psO7ZEkmKWfKaZ0qIFGK3eMXyizD8X9RyLlO3MWikk
   pTJsC9XaTNHz3k1hXV2BJykjbbD7otslf80/DW++rVEt8FDoJxF7Q3trV
   5BGEWPS8JwCY7Klw1kBTqozG7fQViWP+CiIlyeRKJ26eEgcLTOk3SzIhA
   WQeQjVBPhntHR0odyocIh96qY1PmqPuyVnEqsepjEZ9b9jWTkVVvU7uk0
   eL5QmQNnLRAWsPaBolSDQYM8zVgCXyqkmlseE/Qmxsf/LBQaK+LKvexml
   IM1+Kr7EM5tkcWs1VAPSW+FaVwTbJ5WwBGFuGB4W4BZqLQWi0aNPPlsJX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="418912284"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="xz'341?scan'341,208,341";a="418912284"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 08:59:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="845751598"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="xz'341?scan'341,208,341";a="845751598"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 21 Feb 2023 08:59:31 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 08:59:30 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 08:59:29 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 08:59:29 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 08:59:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkpoYg5FmziZzHg6S0hXzh0XFrQefx+Z2GpDM4O8HTMaDc5fcZ8qAffnG+palrzf4TqjiEjhBEuYoFj1XtfbCS1J8BRxgcCVkfenssasqmhcSn8gw1FPJF/o0HbNBA0R8MoYoaL5SOCoajbblxGpfKaOSMp4pEwYpY+JHpZpN6sTdy8k3L5VgNDJUpUHdMJEC5DAs1FnVkSavqCouDdTkGK9y6+n3cbypvZSAkObc8eXsjjGW21Rwbbg4GIAhzbEWsLvVn5/n7VPGsujTE9ZErZf4sX/cc7jsPuJVm8x280s71NMpG20EDCS0dFTDTuJAnWtJ/lMs/RLlHD6ut/nbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0BBeEkeslUYCR3BklqeH2BupEBbLvtfUBc2W56H8Lzg=;
 b=ZVwMgFhqmufPRSc14z24XmOyhc7RnjB13HQ+CvFo/DrKk9X6nZsXArE4AJSdGdtE4lTfV2VTIf48bwk8T/PXJyC6SI8YZJkoy4YbeLftNfh6G5T1kVXlHnzlbEeH6SUYNIR546XfOjGT6+MIHFgCrR1IemaRCENSt2x0sFqCPPl5Oo0laVlUa8qMTh3zjI3AYgDxb6NCQpQTu9/FpoBVDKZXWK6u6yJoD3nnhCgJ6cPArOpVO5JrWf6p3XO63XpRyUOMdjpD+1LMXnIIS+GlBrqr/P91dD9J3XzRm/XkhQU0TR96mLCcTCSJv1R2eE2g5TxrTaXLfV9w//ODr8asig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by DS0PR11MB7412.namprd11.prod.outlook.com (2603:10b6:8:152::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 16:59:14 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::66b:243c:7f3d:db9e]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::66b:243c:7f3d:db9e%4]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 16:59:14 +0000
Date:   Wed, 22 Feb 2023 00:56:26 +0800
From:   kernel test robot <yujie.liu@intel.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, <netdev@vger.kernel.org>
Subject: [linux-next:master] [net] 9b01c885be:
 WARNING:at_drivers/net/phy/phy.c:#phy_state_machine
Message-ID: <202302211644.c12d19de-yujie.liu@intel.com>
Content-Type: multipart/mixed; boundary="Nh+VQZ1K8DTPMh+2"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:3:18::26) To CY5PR11MB6392.namprd11.prod.outlook.com
 (2603:10b6:930:37::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|DS0PR11MB7412:EE_
X-MS-Office365-Filtering-Correlation-Id: 5769b44c-1818-4485-5127-08db142cf580
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ko8aYzu+U0AoSDl9FIu+YDDjIBUeuVIFNUW2nR/GzYeikbRLLOwAyG3n5G2TPRCNDgGxckjYvTeSZCWq/ZvOod5TbEVdO3hd6DyecBQ8DYMhoa7ayQCvafAFxSk+bnWBLy7jW7Hv+icqXf+t7A1Qtr+lw+/oO6bf8bJmSKZjDfAD1eD2E3KPVQhlBjXNoOCs4oKFl2T3cv606zTqmB8h31vA31AYwm7w3V/Kv06cORZ4ccNFx69vIhsR4pI5iR4hBogF83SO5EdfiGU4g6St2AMhUMFGY9phDR/5Jv0iRHt1kkZEIhDkDczl8nw1z6yga7JPMQr6Q8VCwhfrZvPUiZ44a7vaj16EdIJDPqIcvKjvjKCrUkzN0qBiuFCHhimFyKBW+IimtsE5uDxe+r+KQ+Za3S1Zcs3pKOLWSBvnBOm2vhDHqIf6yrge0IqOE1MeJ8Cv5Zf92/tQIIll924+5buN3ZAuEVA4aSIhsuhkYqUEf+QNCnFxjW9alePVPh+tgA7QEImwPf9wWF0AWCFY/Gk9w7/FjS6OYPltp9Y38qhHIIdHW0Wv4gNyDduGkCfbaFyZvxWXmsMyfjsbNu1AnCXyRcbFyD+VpGES4EumPoNPoNldfas8F0V7gIbSP+kszpuuIJuLnoxlM+M7/IG0oScDywGHmhIA9jYROCWq5vrKO4MSVPyD8iMR48dPBZKUJlXSowzNdabJA0yRjesqLgDLXo8pWQCuEJknb67yKIc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(39860400002)(376002)(396003)(136003)(451199018)(316002)(83380400001)(478600001)(45080400002)(54906003)(38100700002)(36756003)(82960400001)(2906002)(8676002)(66556008)(66946007)(86362001)(66476007)(6916009)(41300700001)(4326008)(8936002)(235185007)(5660300002)(44144004)(6506007)(6512007)(1076003)(6486002)(6666004)(966005)(2616005)(26005)(186003)(2700100001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jsUcNH/2u4PSEJ2gqCEd7OxHu7bwT0dNYNmA6mMgYdsglGJIKGqykuFWTj99?=
 =?us-ascii?Q?iDfdrLnVpzFz6HG3HO8r9q736Jop0pEG0g/nLGh9Vqj9B/l7Ykftjhkgl/tu?=
 =?us-ascii?Q?+CpOPb+hLQhuhyy2gVj7BAgGkgAfzse91kMGW0y29o6mWPqvu3Y0VUuJz58Y?=
 =?us-ascii?Q?ckaZ7cQIzy9BX0S2GqpEM9R5B7I6z2KBjT6ZPwxp2BvwUt3Wda5W6XbVQfWG?=
 =?us-ascii?Q?TPvp8CVplIJVahYy2fstC047JGXAcHueGQl9MWa3+uer3ceTiI8uuYymS2RZ?=
 =?us-ascii?Q?24SIdYxB2VTHGJpDn+eO9voPBzUQUuwoJBWDStvzf5BOcJz9LcDkcHnm0tu2?=
 =?us-ascii?Q?OfBSyUK8bRcK6sWw64ESMau3hx/36i/CEbuKOJJ7Y+PCxgFwGBBD3QKXQVg1?=
 =?us-ascii?Q?G4hg8HwGZmry7DjC4NBqRCSVOlE7sD/b5/y+okFtAHChH5OtbZbpYS5F2UjU?=
 =?us-ascii?Q?zR2mKzUQc3Ct7zFk9YvAjjGe74LhClSGg2hHeyto091yDBHXbpejijsjrDxn?=
 =?us-ascii?Q?MWsGBKq0av5Fp33IwnGpbOrkaEiCuJZWvq99W94O8zvl9afkN3+Fwzdw3JRV?=
 =?us-ascii?Q?A2j1v9s4KHoPiCNWoMtjehDvdgNjHVilvIS8A4LuU085HR1+hXwzFAh5EOnr?=
 =?us-ascii?Q?BEW36S93db1hCXENFl4WYRVX6FB8VnmkvQ2f12milFHKGfQYLIlzzvuGHDoI?=
 =?us-ascii?Q?KJwWzrtq/w/ZpJwRThhLPIs0BNn05t0OrpAoWcMrS5FR6WDWKwfkS6knBI+R?=
 =?us-ascii?Q?EpLaM2NUsg8FjFyDKcsvR/FIvxuBrbruR0D7uZS4Zx7ZgwqC5fZZFAI29FAd?=
 =?us-ascii?Q?5ZhFwYXbqk8jVgwMHjFYS8b6mb9Xo3eeqbbDD0jUSJBRiS6zwjSTHx3ON3kg?=
 =?us-ascii?Q?jPcNptnXdn0m6fcTHDVT/7pp08ABRefTkayBI6Koa9hnxDmsnwSrMKCfXXqY?=
 =?us-ascii?Q?FOAecIwLNjlxK3TkzKSk1RoimSOlkmZdyOzXL0kBgl/UiJmlJc2sC/3jURDz?=
 =?us-ascii?Q?JUP2KxSfpi3Xexwyf6yy7hpEawHPif72brQ4RCjAfasIe63IssgisvOV/4Cp?=
 =?us-ascii?Q?2rAWn5bG+71qzo5zd0gw5O92LmsB0VOOp1a/VfzPa3nHJaghvMUxrmhH3iNO?=
 =?us-ascii?Q?uqYxLnzOdpKX0cryAFZScUehiue2D5VF5yg9iBWkLn1TkTfKA6KkS3v581AT?=
 =?us-ascii?Q?f+YAq2eFr+fdrWuiNxdec9KhpESK25a5Q6bhNrMBPxHsuNAHvpGZJ1xaPXEM?=
 =?us-ascii?Q?BX3ep1oCVxlpkJjAWd+a6b4B8W6ffAjC1WM4QTSC49iNow7FO2ULvJcrEhlj?=
 =?us-ascii?Q?zH02rK/fqaAbX3G5j57gs50olXCrFHE8Kmeci0EBs4qrKiayRsAzXNwAbObi?=
 =?us-ascii?Q?k9J1b9vlcJY6sQzSO0VvhhvuujK9siFSIr7AHHwgv6yCsKtwCjDL0b64sVDw?=
 =?us-ascii?Q?c5MbL7jMXhxm/sFJDeN7rjoPrk+MdnwekyYCFfyr9SFbuYw3EaIGYQDfr+fy?=
 =?us-ascii?Q?TGIol4UZaAAD4SBknyrgzftZ+CierLpKuOtvFr3ypvwCgoj56poswex2wYZA?=
 =?us-ascii?Q?NmFXeQ6CDF5KTQO0ENMuO2PyV17ncIeXLMN870zVJVOo5CA1x0OpIY1pwN5G?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5769b44c-1818-4485-5127-08db142cf580
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 16:59:14.1744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FLGh6ucfvIhybtBciuWP17Bfe7uKZxK3knTMIuRg+SrC1qPAScyOQrhIXU12d3Ejp2EBdO3I1jDlwpQP0XIUmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7412
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

--Nh+VQZ1K8DTPMh+2
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

Greeting,

FYI, we noticed WARNING:at_drivers/net/phy/phy.c:#phy_state_machine due to commit (built with clang-14):

commit: 9b01c885be364526d8c05794f8358b3e563b7ff8 ("net: phy: c22: migrate to genphy_c45_write_eee_adv()")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master d2af0fa4bfa4ec29d03b449ccd43fee39501112d]

in testcase: trinity
version: 
with following parameters:

	runtime: 300s
	group: group-04

test-description: Trinity is a linux system call fuzz tester.
test-url: http://codemonkey.org.uk/projects/trinity/

on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):


+-----------------------------------------------------------------+------------+------------+
|                                                                 | 022c3f87f8 | 9b01c885be |
+-----------------------------------------------------------------+------------+------------+
| WARNING:at_drivers/net/phy/phy.c:#phy_state_machine             | 0          | 46         |
| EIP:phy_state_machine                                           | 0          | 46         |
| calltrace:do_softirq_own_stack                                  | 0          | 45         |
| WARNING:at_drivers/net/phy/phy.c:#phy_stop                      | 0          | 46         |
| EIP:phy_stop                                                    | 0          | 46         |
+-----------------------------------------------------------------+------------+------------+


[   24.211773][   T32] ------------[ cut here ]------------
[ 24.212462][ T32] WARNING: CPU: 1 PID: 32 at drivers/net/phy/phy.c:1168 phy_state_machine (??:?) 
[   24.213562][   T32] Modules linked in:
[   24.214050][   T32] CPU: 1 PID: 32 Comm: kworker/1:2 Tainted: G        W          6.2.0-rc7-01623-g9b01c885be36 #1 40addfa090b1209d5e5f69c68ec2db2dfac7322f
[   24.215673][   T12] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   24.219286][   T32] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-debian-1.16.0-5 04/01/2014
[   24.221639][   T32] Workqueue: events_power_efficient phy_state_machine
[ 24.222580][ T32] EIP: phy_state_machine (??:?) 
[ 24.223427][ T32] Code: 29 26 c4 01 eb 71 83 05 ac 29 26 c4 01 b8 88 31 10 c4 ba 01 00 00 00 31 c9 6a 01 e8 55 e6 6b ff 83 c4 04 83 05 34 29 26 c4 01 <0f> 0b b8 a0 31 10 c4 ba 01 00 00 00 31 c9 6a 01 e8 36 e6 6b ff 83
All code
========
   0:	29 26                	sub    %esp,(%rsi)
   2:	c4 01 eb 71          	(bad)  
   6:	83 05 ac 29 26 c4 01 	addl   $0x1,-0x3bd9d654(%rip)        # 0xffffffffc42629b9
   d:	b8 88 31 10 c4       	mov    $0xc4103188,%eax
  12:	ba 01 00 00 00       	mov    $0x1,%edx
  17:	31 c9                	xor    %ecx,%ecx
  19:	6a 01                	pushq  $0x1
  1b:	e8 55 e6 6b ff       	callq  0xffffffffff6be675
  20:	83 c4 04             	add    $0x4,%esp
  23:	83 05 34 29 26 c4 01 	addl   $0x1,-0x3bd9d6cc(%rip)        # 0xffffffffc426295e
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	b8 a0 31 10 c4       	mov    $0xc41031a0,%eax
  31:	ba 01 00 00 00       	mov    $0x1,%edx
  36:	31 c9                	xor    %ecx,%ecx
  38:	6a 01                	pushq  $0x1
  3a:	e8 36 e6 6b ff       	callq  0xffffffffff6be675
  3f:	83                   	.byte 0x83

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	b8 a0 31 10 c4       	mov    $0xc41031a0,%eax
   7:	ba 01 00 00 00       	mov    $0x1,%edx
   c:	31 c9                	xor    %ecx,%ecx
   e:	6a 01                	pushq  $0x1
  10:	e8 36 e6 6b ff       	callq  0xffffffffff6be64b
  15:	83                   	.byte 0x83
[   24.223568][    T1] dsa-loop fixed-0:1f lan2: configuring for phy/gmii link mode
[   24.225718][   T32] EAX: c4103194 EBX: edd2e41c ECX: 00000000 EDX: 00000000
[   24.231643][   T32] ESI: edd2e000 EDI: ffffffff EBP: c0cf1f10 ESP: c0cf1eec
[   24.231656][   T32] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010202
[   24.233216][   T32] CR0: 80050033 CR2: 00000000 CR3: 04551000 CR4: 000406d0
[   24.235302][   T32] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   24.235312][   T32] DR6: fffe0ff0 DR7: 00000400
[   24.236711][   T32] Call Trace:
[ 24.236729][ T32] process_one_work (workqueue.c:?) 
[ 24.238195][ T32] worker_thread (workqueue.c:?) 
[ 24.240453][ T32] ? rcu_lock_release (main.c:?) 
All code
========
   0:	29 26                	sub    %esp,(%rsi)
   2:	c4 01 eb 71          	(bad)  
   6:	83 05 ac 29 26 c4 01 	addl   $0x1,-0x3bd9d654(%rip)        # 0xffffffffc42629b9
   d:	b8 88 31 10 c4       	mov    $0xc4103188,%eax
  12:	ba 01 00 00 00       	mov    $0x1,%edx
  17:	31 c9                	xor    %ecx,%ecx
  19:	6a 01                	pushq  $0x1
  1b:	e8 55 e6 6b ff       	callq  0xffffffffff6be675
  20:	83 c4 04             	add    $0x4,%esp
  23:	83 05 34 29 26 c4 01 	addl   $0x1,-0x3bd9d6cc(%rip)        # 0xffffffffc426295e
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	b8 a0 31 10 c4       	mov    $0xc41031a0,%eax
  31:	ba 01 00 00 00       	mov    $0x1,%edx
  36:	31 c9                	xor    %ecx,%ecx
  38:	6a 01                	pushq  $0x1
  3a:	e8 36 e6 6b ff       	callq  0xffffffffff6be675
  3f:	83                   	.byte 0x83

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	b8 a0 31 10 c4       	mov    $0xc41031a0,%eax
   7:	ba 01 00 00 00       	mov    $0x1,%edx
   c:	31 c9                	xor    %ecx,%ecx
   e:	6a 01                	pushq  $0x1
  10:	e8 36 e6 6b ff       	callq  0xffffffffff6be64b
  15:	83                   	.byte 0x83
[ 24.242250][ T32] kthread (kthread.c:?) 
[ 24.243638][ T32] ? rcu_lock_release (main.c:?) 
[ 24.243654][ T32] ? kthread_unuse_mm (kthread.c:?) 
[ 24.243661][ T32] ret_from_fork (??:?) 
[   24.243683][   T32] irq event stamp: 255
[ 24.243686][ T32] hardirqs last enabled at (261): console_trylock_spinning (printk.c:?) 
[ 24.243696][ T32] hardirqs last disabled at (266): console_trylock_spinning (printk.c:?) 
[ 24.243702][ T32] softirqs last enabled at (216): __do_softirq (??:?) 
[ 24.243710][ T32] softirqs last disabled at (209): do_softirq_own_stack (??:?) 
[   24.243719][   T32] ---[ end trace 0000000000000000 ]---


If you fix the issue, kindly add following tag
| Reported-by: kernel test robot <yujie.liu@intel.com>
| Link: https://lore.kernel.org/oe-lkp/202302211644.c12d19de-yujie.liu@intel.com


To reproduce:

        # build kernel
	cd linux
	cp config-6.2.0-rc7-01623-g9b01c885be36 .config
	make HOSTCC=clang-14 CC=clang-14 ARCH=i386 olddefconfig prepare modules_prepare bzImage modules
	make HOSTCC=clang-14 CC=clang-14 ARCH=i386 INSTALL_MOD_PATH=<mod-install-dir> modules_install
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

--Nh+VQZ1K8DTPMh+2
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="config-6.2.0-rc7-01623-g9b01c885be36"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 6.2.0-rc7 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="clang version 14.0.6 (git://gitmirror/llvm_project f28c006a5895fc0e329fe15fead81e37457cb1d1)"
CONFIG_GCC_VERSION=0
CONFIG_CC_IS_CLANG=y
CONFIG_CLANG_VERSION=140006
CONFIG_AS_IS_LLVM=y
CONFIG_AS_VERSION=140006
CONFIG_LD_VERSION=0
CONFIG_LD_IS_LLD=y
CONFIG_LLD_VERSION=140006
CONFIG_RUST_IS_AVAILABLE=y
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT=y
CONFIG_TOOLS_SUPPORT_RELR=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_PAHOLE_VERSION=123
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
# CONFIG_WERROR is not set
CONFIG_UAPI_HEADER_TEST=y
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_WATCH_QUEUE is not set
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
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_IRQ_MSI_IOMMU=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_CLOCKSOURCE_WATCHDOG_MAX_SKEW_US=100
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y

#
# BPF subsystem
#
CONFIG_BPF_SYSCALL=y
# CONFIG_BPF_JIT is not set
# CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
CONFIG_USERMODE_DRIVER=y
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
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
CONFIG_PSI=y
CONFIG_PSI_DEFAULT_DISABLED=y
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
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_NOCB_CPU is not set
# CONFIG_TASKS_TRACE_RCU_READ_MB is not set
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
CONFIG_UCLAMP_TASK=y
CONFIG_UCLAMP_BUCKETS_COUNT=5
# end of Scheduler features

CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough"
CONFIG_GCC11_NO_ARRAY_BOUNDS=y
CONFIG_GCC12_NO_ARRAY_BOUNDS=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_CGROUP_FAVOR_DYNMODS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
# CONFIG_UCLAMP_TASK_GROUP is not set
CONFIG_CGROUP_PIDS=y
# CONFIG_CGROUP_RDMA is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_BPF is not set
CONFIG_CGROUP_MISC=y
CONFIG_CGROUP_DEBUG=y
CONFIG_SOCK_CGROUP_DATA=y
# CONFIG_NAMESPACES is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
CONFIG_BOOT_CONFIG=y
CONFIG_BOOT_CONFIG_EMBED=y
CONFIG_BOOT_CONFIG_EMBED_FILE=""
CONFIG_INITRAMFS_PRESERVE_MTIME=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_LD_ORPHAN_WARN_LEVEL="warn"
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_MULTIUSER=y
# CONFIG_SGETMASK_SYSCALL is not set
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
# CONFIG_POSIX_TIMERS is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
# CONFIG_ADVISE_SYSCALLS is not set
# CONFIG_MEMBARRIER is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_SELFTEST is not set
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
# CONFIG_KCMP is not set
# CONFIG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_BITS_MAX=16
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_X86_32_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=2

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
# CONFIG_X86_CPU_RESCTRL is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
# CONFIG_IOSF_MBI is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_M486SX is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
CONFIG_MK6=y
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_HYGON is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_CPU_SUP_ZHAOXIN is not set
CONFIG_CPU_SUP_VORTEX_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS_RANGE_BEGIN=2
CONFIG_NR_CPUS_RANGE_END=8
CONFIG_NR_CPUS_DEFAULT=8
CONFIG_NR_CPUS=8
# CONFIG_SCHED_CLUSTER is not set
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCELOG_LEGACY is not set
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_ANCIENT_MCE=y
# CONFIG_X86_MCE_INJECT is not set

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# end of Performance monitoring

# CONFIG_X86_LEGACY_VM86 is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX32=y
CONFIG_X86_IOPL_IOPERM=y
# CONFIG_TOSHIBA is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
# CONFIG_MTRR is not set
CONFIG_X86_UMIP=y
CONFIG_CC_HAS_IBT=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
# CONFIG_EFI is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_STRICT_SIGALTSTACK_SIZE=y
# end of Processor type and features

CONFIG_CC_HAS_ENTRY_PADDING=y
CONFIG_FUNCTION_PADDING_CFI=11
CONFIG_FUNCTION_PADDING_BYTES=16
# CONFIG_SPECULATION_MITIGATIONS is not set
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_DPM_WATCHDOG=y
CONFIG_DPM_WATCHDOG_TIMEOUT=120
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
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
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_DPTF is not set
# CONFIG_ACPI_CONFIGFS is not set
# CONFIG_ACPI_FFH is not set
# CONFIG_PMIC_OPREGION is not set
CONFIG_ACPI_VIOT=y
CONFIG_X86_PM_TIMER=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_CPUFREQ_DT=y
CONFIG_CPUFREQ_DT_PLATDEV=y
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_AMD_PSTATE is not set
# CONFIG_X86_AMD_PSTATE_UT is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=y
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
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
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
# CONFIG_GEOS is not set
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_COMPAT_32=y
# end of Binary Emulations

CONFIG_HAVE_ATOMIC_IOMAP=y
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
CONFIG_HOTPLUG_SMT=y
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_ARCH_32BIT_OFF_T=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_HAS_LTO_CLANG=y
CONFIG_LTO_NONE=y
# CONFIG_LTO_CLANG_FULL is not set
# CONFIG_LTO_CLANG_THIN is not set
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=8
CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
CONFIG_ISA_BUS_API=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
# CONFIG_RANDOMIZE_KSTACK_OFFSET is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_LOCK_EVENT_COUNTS=y
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_SPLIT_ARG64=y
CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH=y
CONFIG_DYNAMIC_SIGFRAME=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_FUNCTION_ALIGNMENT_4B=y
CONFIG_FUNCTION_ALIGNMENT_16B=y
CONFIG_FUNCTION_ALIGNMENT=16
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODULE_UNLOAD_TAINT_TRACKING is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/sbin/modprobe"
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
# CONFIG_BLOCK is not set
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

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#

#
# SLAB allocator options
#
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB_DEPRECATED is not set
CONFIG_SLUB_TINY=y
CONFIG_SLAB_MERGE_DEFAULT=y
# end of SLAB allocator options

# CONFIG_SHUFFLE_PAGE_ALLOCATOR is not set
# CONFIG_COMPAT_BRK is not set
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_EXCLUSIVE_SYSTEM_RAM=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_COMPACT_UNEVICTABLE_DEFAULT=1
# CONFIG_PAGE_REPORTING is not set
CONFIG_MIGRATION=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
# CONFIG_CMA is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_PAGE_IDLE_FLAG=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ARCH_HAS_ZONE_DMA_SET=y
# CONFIG_ZONE_DMA is not set
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_TEST is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_KMAP_LOCAL=y
CONFIG_SECRETMEM=y
CONFIG_USERFAULTFD=y

#
# Data Access Monitoring
#
# CONFIG_DAMON is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y
CONFIG_SKB_EXTENSIONS=y

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
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_INTERFACE is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=y
CONFIG_XFRM_ESP=y
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_XFRM_ESPINTCP=y
CONFIG_SMC=y
CONFIG_SMC_DIAG=y
# CONFIG_XDP_SOCKETS is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_IP_MROUTE is not set
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=y
CONFIG_NET_UDP_TUNNEL=y
CONFIG_NET_FOU=y
# CONFIG_NET_FOU_IP_TUNNELS is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_ESP_OFFLOAD=y
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_TABLE_PERTURB_ORDER=16
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
# CONFIG_INET_RAW_DIAG is not set
# CONFIG_INET_DIAG_DESTROY is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=y
CONFIG_INET6_ESP_OFFLOAD=y
CONFIG_INET6_ESPINTCP=y
CONFIG_INET6_IPCOMP=y
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_IPV6_VTI=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_FOU=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
# CONFIG_IPV6_MROUTE is not set
CONFIG_IPV6_SEG6_LWTUNNEL=y
CONFIG_IPV6_SEG6_HMAC=y
CONFIG_IPV6_SEG6_BPF=y
CONFIG_IPV6_RPL_LWTUNNEL=y
# CONFIG_IPV6_IOAM6_LWTUNNEL is not set
# CONFIG_NETLABEL is not set
# CONFIG_MPTCP is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_BPFILTER=y
CONFIG_BPFILTER_UMH=y
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set
# end of DCCP CCIDs Configuration

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# end of DCCP Kernel Hacking

CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=y
# CONFIG_RDS is not set
CONFIG_TIPC=y
# CONFIG_TIPC_MEDIA_IB is not set
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
# CONFIG_TIPC_DIAG is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
CONFIG_BRIDGE_MRP=y
CONFIG_BRIDGE_CFM=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_NONE=y
CONFIG_NET_DSA_TAG_AR9331=y
CONFIG_NET_DSA_TAG_BRCM_COMMON=y
CONFIG_NET_DSA_TAG_BRCM=y
CONFIG_NET_DSA_TAG_BRCM_LEGACY=y
CONFIG_NET_DSA_TAG_BRCM_PREPEND=y
CONFIG_NET_DSA_TAG_HELLCREEK=y
# CONFIG_NET_DSA_TAG_GSWIP is not set
CONFIG_NET_DSA_TAG_DSA_COMMON=y
CONFIG_NET_DSA_TAG_DSA=y
# CONFIG_NET_DSA_TAG_EDSA is not set
CONFIG_NET_DSA_TAG_MTK=y
CONFIG_NET_DSA_TAG_KSZ=y
CONFIG_NET_DSA_TAG_OCELOT=y
CONFIG_NET_DSA_TAG_OCELOT_8021Q=y
CONFIG_NET_DSA_TAG_QCA=y
CONFIG_NET_DSA_TAG_RTL4_A=y
# CONFIG_NET_DSA_TAG_RTL8_4 is not set
CONFIG_NET_DSA_TAG_RZN1_A5PSW=y
CONFIG_NET_DSA_TAG_LAN9303=y
CONFIG_NET_DSA_TAG_SJA1105=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_TAG_XRS700X=y
# CONFIG_VLAN_8021Q is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_6LOWPAN=y
CONFIG_6LOWPAN_DEBUGFS=y
# CONFIG_6LOWPAN_NHC is not set
CONFIG_IEEE802154=y
CONFIG_IEEE802154_NL802154_EXPERIMENTAL=y
# CONFIG_IEEE802154_SOCKET is not set
CONFIG_IEEE802154_6LOWPAN=y
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BATMAN_V=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_MCAST=y
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_BATMAN_ADV_TRACING is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
# CONFIG_VSOCKETS_DIAG is not set
CONFIG_VSOCKETS_LOOPBACK=y
CONFIG_VIRTIO_VSOCKETS=y
CONFIG_VIRTIO_VSOCKETS_COMMON=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_MPLS_ROUTING is not set
CONFIG_NET_NSH=y
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
# CONFIG_NET_L3_MASTER_DEV is not set
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
# CONFIG_PCPU_DEV_REFCNT is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_NET_DROP_MONITOR is not set
# end of Network testing
# end of Networking options

CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y
# CONFIG_CAN_J1939 is not set
# CONFIG_CAN_ISOTP is not set
CONFIG_BT=y
CONFIG_BT_BREDR=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y
CONFIG_BT_HS=y
# CONFIG_BT_LE is not set
CONFIG_BT_LEDS=y
CONFIG_BT_MSFTEXT=y
CONFIG_BT_AOSPEXT=y
CONFIG_BT_DEBUGFS=y
# CONFIG_BT_SELFTEST is not set
CONFIG_BT_FEATURE_DEBUG=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM4377 is not set
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=y
# CONFIG_BT_MTKSDIO is not set
CONFIG_BT_VIRTIO=y
# end of Bluetooth device drivers

CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_IPV6 is not set
# CONFIG_AF_RXRPC_INJECT_LOSS is not set
# CONFIG_AF_RXRPC_INJECT_RX_DELAY is not set
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
CONFIG_RXPERF=y
CONFIG_AF_KCM=y
CONFIG_STREAM_PARSER=y
CONFIG_MCTP=y
CONFIG_MCTP_FLOWS=y
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_FD=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_RDMA=y
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
# CONFIG_CAIF_USB is not set
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
# CONFIG_NFC_NCI is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_SIM=y
CONFIG_NFC_PN533=y
CONFIG_NFC_PN533_I2C=y
# end of Near Field Communication (NFC) devices

# CONFIG_PSAMPLE is not set
CONFIG_NET_IFE=y
CONFIG_LWTUNNEL=y
# CONFIG_LWTUNNEL_BPF is not set
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
CONFIG_PAGE_POOL_STATS=y
CONFIG_FAILOVER=y
# CONFIG_ETHTOOL_NETLINK is not set

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
# CONFIG_EISA_NAMES is not set
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
# CONFIG_PCI_FTPCI100 is not set
# CONFIG_PCI_HOST_GENERIC is not set

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
# CONFIG_PCIE_CADENCE_PLAT_HOST is not set
# CONFIG_PCI_J721E_HOST is not set
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
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_DEVTMPFS_SAFE is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_FW_LOADER_SYSFS=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_FW_LOADER_COMPRESS is not set
# CONFIG_FW_UPLOAD is not set
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=y
CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SLIMBUS=y
CONFIG_REGMAP_SPMI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
CONFIG_MHI_BUS=y
# CONFIG_MHI_BUS_DEBUG is not set
# CONFIG_MHI_BUS_PCI_GENERIC is not set
CONFIG_MHI_BUS_EP=y
# end of Bus devices

# CONFIG_CONNECTOR is not set

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
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
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set

#
# Partition parsers
#
CONFIG_MTD_AR7_PARTS=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_OF_PARTS=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# end of Partition parsers

#
# User Modules And Translation Layers
#
# CONFIG_MTD_OOPS is not set
CONFIG_MTD_PARTITIONED_MASTER=y

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_INTELEXT is not set
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y
# end of RAM/ROM/Flash chip drivers

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_PHYSMAP_OF=y
# CONFIG_MTD_PHYSMAP_VERSATILE is not set
# CONFIG_MTD_PHYSMAP_GEMINI is not set
# CONFIG_MTD_PHYSMAP_GPIO_ADDR is not set
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=y
CONFIG_MTD_PCMCIA_ANONYMOUS=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
# end of Mapping drivers for chip access

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set

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
CONFIG_MTD_NAND_CORE=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_RAW_NAND=y

#
# Raw/parallel NAND flash controllers
#
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_DENALI_DT is not set
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_CS553X is not set
# CONFIG_MTD_NAND_MXIC is not set
# CONFIG_MTD_NAND_GPIO is not set
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_NAND_CADENCE=y
CONFIG_MTD_NAND_ARASAN=y
CONFIG_MTD_NAND_INTEL_LGM=y

#
# Misc
#
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set

#
# ECC engine support
#
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SW_HAMMING is not set
# CONFIG_MTD_NAND_ECC_SW_BCH is not set
# CONFIG_MTD_NAND_ECC_MXIC is not set
# end of ECC engine support
# end of NAND

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# end of LPDDR & LPDDR2 PCM memory drivers

CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_HYPERBUS is not set
CONFIG_OF=y
# CONFIG_OF_UNITTEST is not set
CONFIG_OF_PROMTREE=y
CONFIG_OF_KOBJ=y
CONFIG_OF_DYNAMIC=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
# CONFIG_OF_OVERLAY is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_PC_PCMCIA is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# NVME Support
#
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_SMPRO_ERRMON=y
# CONFIG_SMPRO_MISC is not set
CONFIG_HI6421V600_IRQ=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_PCH_PHUB is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
CONFIG_XILINX_SDFEC=y
CONFIG_VCPU_STALL_DETECTOR=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_IDT_89HPESX=y
CONFIG_EEPROM_EE1004=y
# end of EEPROM support

# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=y
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_ECHO=y
# CONFIG_MISC_ALCOR_PCI is not set
# CONFIG_MISC_RTSX_PCI is not set
# CONFIG_HABANA_AI is not set
# CONFIG_UACCE is not set
CONFIG_PVPANIC=y
CONFIG_PVPANIC_MMIO=y
# CONFIG_PVPANIC_PCI is not set
# CONFIG_GP_PCI1XXXX is not set
# end of Misc devices

#
# SCSI device support
#
# end of SCSI device support

# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_NET=y
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set
# CONFIG_CAIF_DRIVERS is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_B53=y
# CONFIG_B53_MDIO_DRIVER is not set
# CONFIG_B53_MMAP_DRIVER is not set
# CONFIG_B53_SRAB_DRIVER is not set
CONFIG_B53_SERDES=y
# CONFIG_NET_DSA_BCM_SF2 is not set
CONFIG_NET_DSA_LOOP=y
# CONFIG_NET_DSA_LANTIQ_GSWIP is not set
CONFIG_NET_DSA_MT7530=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON=y
# CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C is not set
CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI=y
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MSCC_SEVILLE is not set
CONFIG_NET_DSA_AR9331=y
# CONFIG_NET_DSA_QCA8K is not set
CONFIG_NET_DSA_XRS700X=y
CONFIG_NET_DSA_XRS700X_I2C=y
CONFIG_NET_DSA_XRS700X_MDIO=y
CONFIG_NET_DSA_REALTEK=y
# CONFIG_NET_DSA_REALTEK_RTL8365MB is not set
# CONFIG_NET_DSA_REALTEK_RTL8366RB is not set
CONFIG_NET_DSA_SMSC_LAN9303=y
# CONFIG_NET_DSA_SMSC_LAN9303_I2C is not set
CONFIG_NET_DSA_SMSC_LAN9303_MDIO=y
CONFIG_NET_DSA_VITESSE_VSC73XX=y
CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM=y
# end of Distributed Switch Architecture drivers

CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_EL3 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_3C589 is not set
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
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CIRRUS=y
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_GEMINI_ETHERNET is not set
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
# CONFIG_EZCHIP_NPS_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_PCMCIA_FMVJ18X is not set
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
# CONFIG_LITEX_LITEETH is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
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
# CONFIG_LAN966X_SWITCH is not set
# CONFIG_VCAP is not set
CONFIG_NET_VENDOR_MICROSEMI=y
# CONFIG_MSCC_OCELOT_SWITCH is not set
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
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_PCMCIA_PCNET is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
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
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
# CONFIG_ROCKER is not set
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
# CONFIG_PCMCIA_SMC91C92 is not set
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
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLINK=y
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
CONFIG_LED_TRIGGER_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_SFP=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_ADIN_PHY is not set
CONFIG_ADIN1100_PHY=y
CONFIG_AQUANTIA_PHY=y
CONFIG_AX88796B_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_BCM54140_PHY=y
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM84881_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_BCM_NET_PHYLIB=y
CONFIG_CICADA_PHY=y
CONFIG_CORTINA_PHY=y
# CONFIG_DAVICOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
CONFIG_LXT_PHY=y
CONFIG_INTEL_XWAY_PHY=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MARVELL_PHY=y
# CONFIG_MARVELL_10G_PHY is not set
CONFIG_MARVELL_88X2222_PHY=y
CONFIG_MAXLINEAR_GPHY=y
CONFIG_MEDIATEK_GE_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_MICROCHIP_PHY is not set
CONFIG_MICROCHIP_T1_PHY=y
# CONFIG_MICROSEMI_PHY is not set
CONFIG_MOTORCOMM_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_NXP_C45_TJA11XX_PHY=y
# CONFIG_NXP_TJA11XX_PHY is not set
CONFIG_NCN26000_PHY=y
CONFIG_AT803X_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_RENESAS_PHY=y
CONFIG_ROCKCHIP_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_STE10XP is not set
CONFIG_TERANETICS_PHY=y
# CONFIG_DP83822_PHY is not set
CONFIG_DP83TC811_PHY=y
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
CONFIG_DP83869_PHY=y
CONFIG_DP83TD510_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_XILINX_GMII2RGMII=y
CONFIG_PSE_CONTROLLER=y
# CONFIG_PSE_REGULATOR is not set
# CONFIG_CAN_DEV is not set

#
# MCTP Device Drivers
#
# CONFIG_MCTP_SERIAL is not set
CONFIG_MCTP_TRANSPORT_I2C=y
# end of MCTP Device Drivers

CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_FWNODE_MDIO=y
CONFIG_OF_MDIO=y
CONFIG_ACPI_MDIO=y
CONFIG_MDIO_DEVRES=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_BCM_UNIMAC=y
CONFIG_MDIO_GPIO=y
CONFIG_MDIO_HISI_FEMAC=y
CONFIG_MDIO_I2C=y
CONFIG_MDIO_MSCC_MIIM=y
CONFIG_MDIO_IPQ4019=y
CONFIG_MDIO_IPQ8064=y

#
# MDIO Multiplexers
#
# CONFIG_MDIO_BUS_MUX_GPIO is not set
# CONFIG_MDIO_BUS_MUX_MULTIPLEXER is not set
# CONFIG_MDIO_BUS_MUX_MMIOREG is not set

#
# PCS device drivers
#
# end of PCS device drivers

CONFIG_PLIP=y
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=y
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y

#
# Host-side USB support is needed for USB Network Adapter support
#
# CONFIG_WLAN is not set
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y

#
# Wireless WAN
#
CONFIG_WWAN=y
CONFIG_WWAN_DEBUGFS=y
# CONFIG_WWAN_HWSIM is not set
# CONFIG_MHI_WWAN_CTRL is not set
CONFIG_MHI_WWAN_MBIM=y
CONFIG_RPMSG_WWAN_CTRL=y
# CONFIG_IOSM is not set
# CONFIG_MTK_T7XX is not set
# end of Wireless WAN

# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
CONFIG_NETDEVSIM=y
CONFIG_NET_FAILOVER=y
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y
CONFIG_INPUT_VIVALDIFMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
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
# CONFIG_KEYBOARD_IQS62X is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CAP11XX is not set
# CONFIG_KEYBOARD_BCM is not set
# CONFIG_KEYBOARD_CYPRESS_SF is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_PEGASUS is not set
CONFIG_TABLET_SERIAL_WACOM4=y
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=y
# CONFIG_RMI4_I2C is not set
CONFIG_RMI4_SMB=y
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=y
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
# CONFIG_RMI4_F34 is not set
CONFIG_RMI4_F3A=y
CONFIG_RMI4_F54=y
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_SERIO_APBPS2=y
CONFIG_SERIO_GPIO_PS2=y
CONFIG_USERIO=y
# CONFIG_GAMEPORT is not set
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
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DWLIB=y
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
CONFIG_SERIAL_8250_PERICOM=y
# CONFIG_SERIAL_OF_PLATFORM is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SIFIVE is not set
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_CONEXANT_DIGICOLOR is not set
# CONFIG_SERIAL_SPRD is not set
# CONFIG_SERIAL_LITEUART is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
# CONFIG_NOZOMI is not set
# CONFIG_NULL_TTY is not set
# CONFIG_RPMSG_TTY is not set
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_SSIF=y
# CONFIG_IPMI_IPMB is not set
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_SSIF_IPMI_BMC=y
CONFIG_IPMB_DEVICE_INTERFACE=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_CCTRNG is not set
CONFIG_HW_RANDOM_XIPHERA=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
CONFIG_SCR24X=y
# CONFIG_IPWIRELESS is not set
# end of PCMCIA character devices

# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_DEVMEM=y
CONFIG_NVRAM=y
CONFIG_DEVPORT=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C=y
CONFIG_TCG_TIS_I2C_CR50=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_CRB is not set
CONFIG_TCG_VTPM_PROXY=y
CONFIG_TCG_TIS_ST33ZP24=y
CONFIG_TCG_TIS_ST33ZP24_I2C=y
# CONFIG_TELCLOCK is not set
CONFIG_XILLYBUS_CLASS=y
CONFIG_XILLYBUS=y
CONFIG_XILLYBUS_OF=y
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
# CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_GPMUX is not set
CONFIG_I2C_MUX_LTC4306=y
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_MUX_PINCTRL=y
CONFIG_I2C_MUX_REG=y
CONFIG_I2C_DEMUX_PINCTRL=y
# CONFIG_I2C_MUX_MLXCPLD is not set
# end of Multiplexer I2C Chip support

# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
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
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_EMEV2=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_GPIO_FAULT_INJECTOR=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
CONFIG_I2C_PXA=y
CONFIG_I2C_PXA_PCI=y
# CONFIG_I2C_RK3X is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PCI1XXXX is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_FSI=y
# CONFIG_I2C_VIRTIO is not set
# end of I2C Hardware Bus support

# CONFIG_I2C_STUB is not set
CONFIG_I2C_SLAVE=y
CONFIG_I2C_SLAVE_EEPROM=y
CONFIG_I2C_SLAVE_TESTUNIT=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

CONFIG_I3C=y
# CONFIG_CDNS_I3C_MASTER is not set
CONFIG_DW_I3C_MASTER=y
# CONFIG_SVC_I3C_MASTER is not set
# CONFIG_MIPI_I3C_HCI is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
CONFIG_SPMI_HISI3670=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

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
CONFIG_GENERIC_PINCTRL_GROUPS=y
CONFIG_PINMUX=y
CONFIG_GENERIC_PINMUX_FUNCTIONS=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
CONFIG_DEBUG_PINCTRL=y
# CONFIG_PINCTRL_AMD is not set
# CONFIG_PINCTRL_AS3722 is not set
# CONFIG_PINCTRL_AXP209 is not set
CONFIG_PINCTRL_CY8C95X0=y
# CONFIG_PINCTRL_DA9062 is not set
# CONFIG_PINCTRL_EQUILIBRIUM is not set
CONFIG_PINCTRL_MCP23S08_I2C=y
CONFIG_PINCTRL_MCP23S08=y
# CONFIG_PINCTRL_MICROCHIP_SGPIO is not set
CONFIG_PINCTRL_OCELOT=y
CONFIG_PINCTRL_PALMAS=y
CONFIG_PINCTRL_RK805=y
CONFIG_PINCTRL_SINGLE=y
# CONFIG_PINCTRL_STMFX is not set
# CONFIG_PINCTRL_SX150X is not set
# CONFIG_PINCTRL_LOCHNAGAR is not set
CONFIG_PINCTRL_MADERA=y
CONFIG_PINCTRL_CS47L35=y
CONFIG_PINCTRL_CS47L85=y
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
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_CDEV=y
# CONFIG_GPIO_CDEV_V1 is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_74XX_MMIO is not set
CONFIG_GPIO_ALTERA=y
# CONFIG_GPIO_AMDPT is not set
CONFIG_GPIO_CADENCE=y
CONFIG_GPIO_DWAPB=y
# CONFIG_GPIO_EXAR is not set
CONFIG_GPIO_FTGPIO010=y
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_GRGPIO=y
CONFIG_GPIO_HLWD=y
CONFIG_GPIO_LOGICVC=y
CONFIG_GPIO_MB86S7X=y
# CONFIG_GPIO_SIFIVE is not set
# CONFIG_GPIO_SIOX is not set
CONFIG_GPIO_SYSCON=y
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_WCD934X is not set
CONFIG_GPIO_XILINX=y
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_IT87=y
# CONFIG_GPIO_SCH311X is not set
CONFIG_GPIO_WINBOND=y
CONFIG_GPIO_WS16C48=y
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
CONFIG_GPIO_ADNP=y
CONFIG_GPIO_GW_PLD=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCA9570=y
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_BD71815 is not set
CONFIG_GPIO_BD71828=y
CONFIG_GPIO_BD9571MWV=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_LP3943=y
# CONFIG_GPIO_LP873X is not set
# CONFIG_GPIO_MADERA is not set
CONFIG_GPIO_MAX77650=y
CONFIG_GPIO_PALMAS=y
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65218=y
CONFIG_GPIO_TPS65910=y
CONFIG_GPIO_TWL6040=y
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8350 is not set
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# CONFIG_GPIO_SODAVILLE is not set
# end of PCI GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
# CONFIG_GPIO_LATCH is not set
# CONFIG_GPIO_MOCKUP is not set
CONFIG_GPIO_VIRTIO=y
CONFIG_GPIO_SIM=y
# end of Virtual GPIO drivers

CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y
CONFIG_W1_MASTER_SGI=y
# end of 1-wire Bus Masters

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2405=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2406=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2805=y
# CONFIG_W1_SLAVE_DS2430 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2438 is not set
CONFIG_W1_SLAVE_DS250X=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_DS28E17=y
# end of 1-wire Slaves

CONFIG_POWER_RESET=y
CONFIG_POWER_RESET_AS3722=y
CONFIG_POWER_RESET_ATC260X=y
CONFIG_POWER_RESET_GPIO=y
# CONFIG_POWER_RESET_GPIO_RESTART is not set
# CONFIG_POWER_RESET_LTC2952 is not set
CONFIG_POWER_RESET_REGULATOR=y
CONFIG_POWER_RESET_RESTART=y
CONFIG_POWER_RESET_SYSCON=y
# CONFIG_POWER_RESET_SYSCON_POWEROFF is not set
CONFIG_REBOOT_MODE=y
CONFIG_SYSCON_REBOOT_MODE=y
CONFIG_NVMEM_REBOOT_MODE=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_POWER_SUPPLY_HWMON is not set
CONFIG_PDA_POWER=y
# CONFIG_IP5XXX_POWER is not set
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
CONFIG_CHARGER_ADP5061=y
# CONFIG_BATTERY_CW2015 is not set
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_OLPC=y
CONFIG_BATTERY_SAMSUNG_SDI=y
CONFIG_BATTERY_SBS=y
CONFIG_CHARGER_SBS=y
CONFIG_MANAGER_SBS=y
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_DA9030 is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_DA9150=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_BATTERY_MAX1721X is not set
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_LTC4162L is not set
CONFIG_CHARGER_MAX14577=y
# CONFIG_CHARGER_DETECTOR_MAX14656 is not set
CONFIG_CHARGER_MAX77650=y
CONFIG_CHARGER_MAX77693=y
CONFIG_CHARGER_MAX77976=y
CONFIG_CHARGER_MT6360=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24257 is not set
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_BQ2515X=y
# CONFIG_CHARGER_BQ25890 is not set
CONFIG_CHARGER_BQ25980=y
CONFIG_CHARGER_BQ256XX=y
CONFIG_CHARGER_RK817=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_CHARGER_TPS65217=y
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_BATTERY_RT5033 is not set
CONFIG_CHARGER_RT9455=y
# CONFIG_CHARGER_UCS1002 is not set
# CONFIG_CHARGER_BD99954 is not set
CONFIG_BATTERY_UG3105=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_SMPRO=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM1177=y
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_AHT10 is not set
CONFIG_SENSORS_AS370=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_CORSAIR_CPRO=y
CONFIG_SENSORS_CORSAIR_PSU=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DELL_SMM is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_GSC is not set
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_I5500 is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_POWR1220 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LOCHNAGAR=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC2947=y
CONFIG_SENSORS_LTC2947_I2C=y
CONFIG_SENSORS_LTC2990=y
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX127 is not set
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX31730=y
CONFIG_SENSORS_MAX31760=y
CONFIG_SENSORS_MAX6620=y
CONFIG_SENSORS_MAX6621=y
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MAX31790=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_MLXREG_FAN is not set
CONFIG_SENSORS_TC654=y
CONFIG_SENSORS_TPS23861=y
CONFIG_SENSORS_MENF21BMC_HWMON=y
CONFIG_SENSORS_MR75203=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NCT6683=y
CONFIG_SENSORS_NCT6775_CORE=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NCT6775_I2C=y
CONFIG_SENSORS_NCT7802=y
# CONFIG_SENSORS_NPCM7XX is not set
CONFIG_SENSORS_OCC_P8_I2C=y
CONFIG_SENSORS_OCC=y
# CONFIG_SENSORS_OXP is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_SENSORS_PECI_CPUTEMP=y
CONFIG_SENSORS_PECI_DIMMTEMP=y
CONFIG_SENSORS_PECI=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_BPA_RS600 is not set
CONFIG_SENSORS_DELTA_AHE50DC_FAN=y
# CONFIG_SENSORS_FSP_3Y is not set
CONFIG_SENSORS_IBM_CFFPS=y
CONFIG_SENSORS_DPS920AB=y
# CONFIG_SENSORS_INSPUR_IPSPS is not set
CONFIG_SENSORS_IR35221=y
# CONFIG_SENSORS_IR36021 is not set
CONFIG_SENSORS_IR38064=y
CONFIG_SENSORS_IR38064_REGULATOR=y
CONFIG_SENSORS_IRPS5401=y
CONFIG_SENSORS_ISL68137=y
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LT7182S=y
CONFIG_SENSORS_LTC2978=y
# CONFIG_SENSORS_LTC2978_REGULATOR is not set
# CONFIG_SENSORS_LTC3815 is not set
CONFIG_SENSORS_MAX15301=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX16601=y
# CONFIG_SENSORS_MAX20730 is not set
CONFIG_SENSORS_MAX20751=y
CONFIG_SENSORS_MAX31785=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_MP2888 is not set
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_MP5023 is not set
CONFIG_SENSORS_PIM4328=y
CONFIG_SENSORS_PLI1209BC=y
# CONFIG_SENSORS_PLI1209BC_REGULATOR is not set
CONFIG_SENSORS_PM6764TR=y
CONFIG_SENSORS_PXE1610=y
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
# CONFIG_SENSORS_TPS546D24 is not set
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_XDPE152=y
CONFIG_SENSORS_XDPE122=y
# CONFIG_SENSORS_XDPE122_REGULATOR is not set
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SBTSI=y
CONFIG_SENSORS_SBRMI=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHT4x is not set
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC2305 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_ADC128D818=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_INA238=y
CONFIG_SENSORS_INA3221=y
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_TMP464 is not set
CONFIG_SENSORS_TMP513=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_ASUS_EC is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_NETLINK=y
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_OF is not set
CONFIG_THERMAL_WRITABLE_TRIPS=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
# CONFIG_THERMAL_MMIO is not set
CONFIG_DA9062_THERMAL=y

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_PKG_TEMP_THERMAL=y
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# end of ACPI INT340X thermal drivers

# CONFIG_INTEL_PCH_THERMAL is not set
# CONFIG_INTEL_TCC_COOLING is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_INTEL_HFI_THERMAL=y
# end of Intel thermal drivers

# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_PCI=y
# CONFIG_BCMA_SFLASH is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_ACT8945A is not set
CONFIG_MFD_AS3711=y
CONFIG_MFD_SMPRO=y
CONFIG_MFD_AS3722=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_ATMEL_FLEXCOM=y
# CONFIG_MFD_ATMEL_HLCDC is not set
# CONFIG_MFD_BCM590XX is not set
CONFIG_MFD_BD9571MWV=y
CONFIG_MFD_AXP20X=y
CONFIG_MFD_AXP20X_I2C=y
CONFIG_MFD_MADERA=y
# CONFIG_MFD_MADERA_I2C is not set
# CONFIG_MFD_CS47L15 is not set
CONFIG_MFD_CS47L35=y
CONFIG_MFD_CS47L85=y
# CONFIG_MFD_CS47L90 is not set
CONFIG_MFD_CS47L92=y
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9062=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_DA9150=y
CONFIG_MFD_GATEWORKS_GSC=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_MFD_MP2629=y
# CONFIG_MFD_HI6421_PMIC is not set
CONFIG_MFD_HI6421_SPMI=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
# CONFIG_MFD_INTEL_LPSS_PCI is not set
CONFIG_MFD_IQS62X=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77620 is not set
CONFIG_MFD_MAX77650=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX77714=y
# CONFIG_MFD_MAX77843 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_MT6360=y
CONFIG_MFD_MT6370=y
# CONFIG_MFD_MT6397 is not set
CONFIG_MFD_MENF21BMC=y
# CONFIG_MFD_NTXEC is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_SY7636A is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT4831 is not set
CONFIG_MFD_RT5033=y
# CONFIG_MFD_RT5120 is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_RK808=y
CONFIG_MFD_RN5T618=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_TI_LMU=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65086 is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TI_LP873X=y
# CONFIG_MFD_TI_LP87565 is not set
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS65219=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TQMX86 is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_LOCHNAGAR=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_ROHM_BD718XX is not set
CONFIG_MFD_ROHM_BD71828=y
CONFIG_MFD_ROHM_BD957XMUF=y
# CONFIG_MFD_STPMIC1 is not set
CONFIG_MFD_STMFX=y
CONFIG_MFD_WCD934X=y
CONFIG_MFD_ATC260X=y
CONFIG_MFD_ATC260X_I2C=y
# CONFIG_MFD_QCOM_PM8008 is not set
CONFIG_MFD_RSMU_I2C=y
# end of Multifunction device drivers

CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PG86X is not set
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_AAT2870 is not set
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_AS3722=y
CONFIG_REGULATOR_ATC260X=y
CONFIG_REGULATOR_AXP20X=y
CONFIG_REGULATOR_BD71815=y
# CONFIG_REGULATOR_BD71828 is not set
CONFIG_REGULATOR_BD9571MWV=y
CONFIG_REGULATOR_BD957XMUF=y
# CONFIG_REGULATOR_DA9052 is not set
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9062=y
CONFIG_REGULATOR_DA9121=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_FAN53880 is not set
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_HI6421V600 is not set
CONFIG_REGULATOR_ISL9305=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LM363X=y
CONFIG_REGULATOR_LOCHNAGAR=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP873X=y
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_LTC3676=y
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX77650 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8893 is not set
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX20086=y
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MAX77802=y
CONFIG_REGULATOR_MAX77826=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_MCP16502 is not set
# CONFIG_REGULATOR_MP5416 is not set
# CONFIG_REGULATOR_MP8859 is not set
CONFIG_REGULATOR_MP886X=y
# CONFIG_REGULATOR_MPQ7920 is not set
CONFIG_REGULATOR_MT6311=y
CONFIG_REGULATOR_MT6315=y
# CONFIG_REGULATOR_MT6360 is not set
CONFIG_REGULATOR_MT6370=y
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PCA9450=y
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_PF8X00=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_PV88060 is not set
CONFIG_REGULATOR_PV88080=y
# CONFIG_REGULATOR_PV88090 is not set
CONFIG_REGULATOR_QCOM_SPMI=y
CONFIG_REGULATOR_QCOM_USB_VBUS=y
CONFIG_REGULATOR_RASPBERRYPI_TOUCHSCREEN_ATTINY=y
CONFIG_REGULATOR_RK808=y
# CONFIG_REGULATOR_RN5T618 is not set
CONFIG_REGULATOR_ROHM=y
# CONFIG_REGULATOR_RT4801 is not set
# CONFIG_REGULATOR_RT5033 is not set
CONFIG_REGULATOR_RT5190A=y
# CONFIG_REGULATOR_RT5759 is not set
CONFIG_REGULATOR_RT6160=y
# CONFIG_REGULATOR_RT6190 is not set
CONFIG_REGULATOR_RT6245=y
CONFIG_REGULATOR_RTQ2134=y
CONFIG_REGULATOR_RTMV20=y
CONFIG_REGULATOR_RTQ6752=y
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
# CONFIG_REGULATOR_S5M8767 is not set
CONFIG_REGULATOR_SLG51000=y
CONFIG_REGULATOR_SY8106A=y
CONFIG_REGULATOR_SY8824X=y
CONFIG_REGULATOR_SY8827N=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS6286X=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65132=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS65218=y
CONFIG_REGULATOR_TPS65219=y
# CONFIG_REGULATOR_TPS65910 is not set
CONFIG_REGULATOR_VCTRL=y
CONFIG_REGULATOR_WM831X=y
# CONFIG_REGULATOR_WM8350 is not set
# CONFIG_REGULATOR_QCOM_LABIBB is not set
CONFIG_RC_CORE=y
# CONFIG_BPF_LIRC_MODE2 is not set
CONFIG_LIRC=y
# CONFIG_RC_MAP is not set
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
CONFIG_CEC_CORE=y

#
# CEC support
#
CONFIG_MEDIA_CEC_RC=y
# CONFIG_MEDIA_CEC_SUPPORT is not set
# end of CEC support

CONFIG_MEDIA_SUPPORT=y
CONFIG_MEDIA_SUPPORT_FILTER=y
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Media device types
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
CONFIG_MEDIA_PLATFORM_SUPPORT=y
# CONFIG_MEDIA_TEST_SUPPORT is not set
# end of Media device types

CONFIG_VIDEO_DEV=y
CONFIG_MEDIA_CONTROLLER=y

#
# Video4Linux options
#
CONFIG_VIDEO_V4L2_I2C=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# CONFIG_V4L2_FLASH_LED_CLASS is not set
CONFIG_V4L2_FWNODE=y
CONFIG_V4L2_ASYNC=y
# end of Video4Linux options

#
# Media controller options
#
# end of Media controller options

#
# Media drivers
#

#
# Drivers filtered as selected at 'Filter media drivers'
#

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_MEDIA_PLATFORM_DRIVERS is not set
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_V4L2=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
# end of Media drivers

#
# Media ancillary drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_CS3308=y
CONFIG_VIDEO_CS5345=y
# CONFIG_VIDEO_CS53L32A is not set
CONFIG_VIDEO_MSP3400=y
# CONFIG_VIDEO_SONY_BTF_MPX is not set
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_TLV320AIC23B=y
CONFIG_VIDEO_TVAUDIO=y
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_WM8775=y
# end of Audio decoders, processors and mixers

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set
# end of RDS decoders

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_ADV748X is not set
CONFIG_VIDEO_ADV7604=y
CONFIG_VIDEO_ADV7604_CEC=y
# CONFIG_VIDEO_ADV7842 is not set
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_ISL7998X=y
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_MAX9286=y
CONFIG_VIDEO_ML86V7667=y
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_TC358743=y
CONFIG_VIDEO_TC358743_CEC=y
CONFIG_VIDEO_TC358746=y
CONFIG_VIDEO_TVP514X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=y
CONFIG_VIDEO_TW9910=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y
# end of Video decoders

#
# Video encoders
#
CONFIG_VIDEO_AD9389B=y
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=y
CONFIG_VIDEO_ADV7511=y
CONFIG_VIDEO_ADV7511_CEC=y
CONFIG_VIDEO_AK881X=y
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_THS8200=y
# end of Video encoders

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y
# end of Video improvement chips

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=y
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
CONFIG_VIDEO_THS7303=y
# end of Miscellaneous helper chips

CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC0011=y
# CONFIG_MEDIA_TUNER_FC0012 is not set
# CONFIG_MEDIA_TUNER_FC0013 is not set
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_IT913X=y
# CONFIG_MEDIA_TUNER_M88RS6000T is not set
CONFIG_MEDIA_TUNER_MAX2165=y
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MXL301RF is not set
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_QM1D1B0004=y
CONFIG_MEDIA_TUNER_QM1D1C0042=y
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_R820T=y
# CONFIG_MEDIA_TUNER_SI2157 is not set
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_TDA18218=y
# CONFIG_MEDIA_TUNER_TDA18250 is not set
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_XC5000=y
# end of Customize TV tuners
# end of Media ancillary drivers

#
# Graphics support
#
CONFIG_APERTURE_HELPERS=y
CONFIG_VIDEO_NOMODESET=y
# CONFIG_AGP is not set
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
CONFIG_DRM_DEBUG_MODESET_LOCK=y

#
# ARM devices
#
# end of ARM devices

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
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
# CONFIG_FB_GEODE is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_IBM_GXT4500=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_SIMPLE=y
CONFIG_FB_SSD1307=y
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MT6370=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_QCOM_WLED=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_88PM860X is not set
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=y
CONFIG_BACKLIGHT_ARCXCNN=y
CONFIG_BACKLIGHT_LED=y
# end of Backlight & LCD device support

CONFIG_HDMI=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

CONFIG_SOUND=y
# CONFIG_SND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
# CONFIG_HID_COUGAR is not set
CONFIG_HID_MACALLY=y
CONFIG_HID_CMEDIA=y
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_GEMBIRD=y
CONFIG_HID_GFRM=y
# CONFIG_HID_GLORIOUS is not set
CONFIG_HID_VIVALDI_COMMON=y
CONFIG_HID_VIVALDI=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_WALTOP=y
CONFIG_HID_VIEWSONIC=y
CONFIG_HID_VRC2=y
# CONFIG_HID_XIAOMI is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_ITE=y
CONFIG_HID_JABRA=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LED=y
CONFIG_HID_LENOVO=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MALTRON=y
# CONFIG_HID_MAYFLASH is not set
CONFIG_HID_REDRAGON=y
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_NINTENDO is not set
CONFIG_HID_NTI=y
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PLANTRONICS=y
# CONFIG_HID_PLAYSTATION is not set
# CONFIG_HID_PXRC is not set
# CONFIG_HID_RAZER is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SEMITEK=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEAM=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_TOPRE is not set
CONFIG_HID_THINGM=y
CONFIG_HID_UDRAW_PS3=y
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=y
# CONFIG_HID_ALPS is not set
# end of Special HID drivers

#
# I2C HID support
#
# CONFIG_I2C_HID_ACPI is not set
CONFIG_I2C_HID_OF=y
# CONFIG_I2C_HID_OF_ELAN is not set
# CONFIG_I2C_HID_OF_GOODIX is not set
# end of I2C HID support

CONFIG_I2C_HID_CORE=y
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
CONFIG_USB_PCI=y

#
# USB dual-mode controller drivers
#

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
# CONFIG_TYPEC is not set
# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=y
# CONFIG_PWRSEQ_EMMC is not set
CONFIG_PWRSEQ_SD8787=y
CONFIG_PWRSEQ_SIMPLE=y
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_USDHI6ROL0=y
CONFIG_MMC_CQHCI=y
CONFIG_MMC_HSQ=y
# CONFIG_MMC_TOSHIBA_PCI is not set
CONFIG_MMC_MTK=y
# CONFIG_MMC_LITEX is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_CLASS_FLASH=y
CONFIG_LEDS_CLASS_MULTICOLOR=y
CONFIG_LEDS_BRIGHTNESS_HW_CHANGED=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_AN30259A=y
CONFIG_LEDS_APU=y
# CONFIG_LEDS_AW2013 is not set
CONFIG_LEDS_BCM6328=y
# CONFIG_LEDS_BCM6358 is not set
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3532=y
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_LM3692X=y
# CONFIG_LEDS_NET48XX is not set
CONFIG_LEDS_WRAP=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP3952 is not set
CONFIG_LEDS_LP50XX=y
# CONFIG_LEDS_LP55XX_COMMON is not set
CONFIG_LEDS_LP8860=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA955X_GPIO=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_TLC591XX=y
# CONFIG_LEDS_MAX77650 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_MENF21BMC=y
CONFIG_LEDS_IS31FL319X=y
CONFIG_LEDS_IS31FL32XX=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set
CONFIG_LEDS_SYSCON=y
# CONFIG_LEDS_MLXCPLD is not set
CONFIG_LEDS_MLXREG=y
CONFIG_LEDS_USER=y
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set
CONFIG_LEDS_TPS6105X=y
CONFIG_LEDS_LGM=y

#
# Flash and Torch LED drivers
#
CONFIG_LEDS_AAT1290=y
CONFIG_LEDS_AS3645A=y
CONFIG_LEDS_KTD2692=y
# CONFIG_LEDS_LM3601X is not set
CONFIG_LEDS_MAX77693=y
CONFIG_LEDS_MT6360=y
# CONFIG_LEDS_RT4505 is not set
CONFIG_LEDS_RT8515=y
CONFIG_LEDS_SGM3140=y

#
# RGB LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_MTD is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_ACTIVITY=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_LEDS_TRIGGER_PANIC is not set
CONFIG_LEDS_TRIGGER_NETDEV=y
CONFIG_LEDS_TRIGGER_PATTERN=y
CONFIG_LEDS_TRIGGER_AUDIO=y
# CONFIG_LEDS_TRIGGER_TTY is not set

#
# Simple LED drivers
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
# CONFIG_INFINIBAND_ON_DEMAND_PAGING is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_OCRDMA is not set
CONFIG_INFINIBAND_IPOIB=y
# CONFIG_INFINIBAND_IPOIB_CM is not set
# CONFIG_INFINIBAND_IPOIB_DEBUG is not set
CONFIG_INFINIBAND_RTRS=y
CONFIG_INFINIBAND_RTRS_CLIENT=y
CONFIG_INFINIBAND_RTRS_SERVER=y
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_SYSTOHC_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_88PM80X=y
CONFIG_RTC_DRV_ABB5ZES3=y
# CONFIG_RTC_DRV_ABEOZ9 is not set
CONFIG_RTC_DRV_ABX80X=y
CONFIG_RTC_DRV_AS3722=y
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_HYM8563 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
# CONFIG_RTC_DRV_MAX77686 is not set
CONFIG_RTC_DRV_NCT3018Y=y
# CONFIG_RTC_DRV_RK808 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_ISL12026=y
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF85063=y
CONFIG_RTC_DRV_PCF85363=y
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BD70528=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_PALMAS=y
CONFIG_RTC_DRV_TPS65910=y
# CONFIG_RTC_DRV_RC5T619 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3028=y
# CONFIG_RTC_DRV_RV3032 is not set
# CONFIG_RTC_DRV_RV8803 is not set
CONFIG_RTC_DRV_S5M=y
CONFIG_RTC_DRV_SD3078=y

#
# SPI RTC drivers
#
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_DS3232_HWMON is not set
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_RV3029C2=y
# CONFIG_RTC_DRV_RV3029_HWMON is not set
CONFIG_RTC_DRV_RX6110=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1685_FAMILY=y
# CONFIG_RTC_DRV_DS1685 is not set
# CONFIG_RTC_DRV_DS1689 is not set
# CONFIG_RTC_DRV_DS17285 is not set
# CONFIG_RTC_DRV_DS17485 is not set
CONFIG_RTC_DRV_DS17885=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_DA9052 is not set
CONFIG_RTC_DRV_DA9055=y
# CONFIG_RTC_DRV_DA9063 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_WM8350=y
# CONFIG_RTC_DRV_PCF50633 is not set
CONFIG_RTC_DRV_ZYNQMP=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_CADENCE is not set
CONFIG_RTC_DRV_FTRTC010=y
CONFIG_RTC_DRV_MC13XXX=y
CONFIG_RTC_DRV_R7301=y

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_GOLDFISH is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y
CONFIG_ALTERA_MSGDMA=y
# CONFIG_DW_AXI_DMAC is not set
CONFIG_FSL_EDMA=y
# CONFIG_INTEL_IDMA64 is not set
# CONFIG_PCH_DMA is not set
# CONFIG_PLX_DMA is not set
CONFIG_XILINX_ZYNQMP_DPDMA=y
CONFIG_QCOM_HIDMA_MGMT=y
CONFIG_QCOM_HIDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
CONFIG_HSU_DMA=y
CONFIG_SF_PDMA=y
CONFIG_INTEL_LDMA=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
CONFIG_UDMABUF=y
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
CONFIG_DMABUF_HEAPS=y
# CONFIG_DMABUF_SYSFS_STATS is not set
CONFIG_DMABUF_HEAPS_SYSTEM=y
# end of DMABUF options

# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VFIO=y
CONFIG_VFIO_CONTAINER=y
CONFIG_VFIO_IOMMU_TYPE1=y
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
# CONFIG_VFIO_PCI is not set
CONFIG_VFIO_MDEV=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO_ANCHOR=y
CONFIG_VIRTIO=y
# CONFIG_VIRTIO_MENU is not set
# CONFIG_VDPA is not set
CONFIG_VHOST_IOTLB=y
CONFIG_VHOST=y
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=y
# CONFIG_VHOST_VSOCK is not set
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# end of Microsoft Hyper-V guest support

# CONFIG_GREYBUS is not set
CONFIG_COMEDI=y
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
# CONFIG_COMEDI_BOND is not set
# CONFIG_COMEDI_TEST is not set
CONFIG_COMEDI_PARPORT=y
CONFIG_COMEDI_SSV_DNP=y
CONFIG_COMEDI_ISA_DRIVERS=y
CONFIG_COMEDI_PCL711=y
CONFIG_COMEDI_PCL724=y
CONFIG_COMEDI_PCL726=y
# CONFIG_COMEDI_PCL730 is not set
CONFIG_COMEDI_PCL812=y
CONFIG_COMEDI_PCL816=y
CONFIG_COMEDI_PCL818=y
CONFIG_COMEDI_PCM3724=y
CONFIG_COMEDI_AMPLC_DIO200_ISA=y
# CONFIG_COMEDI_AMPLC_PC236_ISA is not set
CONFIG_COMEDI_AMPLC_PC263_ISA=y
CONFIG_COMEDI_RTI800=y
CONFIG_COMEDI_RTI802=y
# CONFIG_COMEDI_DAC02 is not set
CONFIG_COMEDI_DAS16M1=y
# CONFIG_COMEDI_DAS08_ISA is not set
CONFIG_COMEDI_DAS16=y
CONFIG_COMEDI_DAS800=y
CONFIG_COMEDI_DAS1800=y
CONFIG_COMEDI_DAS6402=y
CONFIG_COMEDI_DT2801=y
CONFIG_COMEDI_DT2811=y
CONFIG_COMEDI_DT2814=y
# CONFIG_COMEDI_DT2815 is not set
# CONFIG_COMEDI_DT2817 is not set
CONFIG_COMEDI_DT282X=y
CONFIG_COMEDI_DMM32AT=y
CONFIG_COMEDI_FL512=y
CONFIG_COMEDI_AIO_AIO12_8=y
CONFIG_COMEDI_AIO_IIRO_16=y
CONFIG_COMEDI_II_PCI20KC=y
CONFIG_COMEDI_C6XDIGIO=y
CONFIG_COMEDI_MPC624=y
# CONFIG_COMEDI_ADQ12B is not set
CONFIG_COMEDI_NI_AT_A2150=y
# CONFIG_COMEDI_NI_AT_AO is not set
CONFIG_COMEDI_NI_ATMIO=y
CONFIG_COMEDI_NI_ATMIO16D=y
CONFIG_COMEDI_NI_LABPC_ISA=y
CONFIG_COMEDI_PCMAD=y
CONFIG_COMEDI_PCMDA12=y
# CONFIG_COMEDI_PCMMIO is not set
CONFIG_COMEDI_PCMUIO=y
CONFIG_COMEDI_MULTIQ3=y
# CONFIG_COMEDI_S526 is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
CONFIG_COMEDI_PCMCIA_DRIVERS=y
CONFIG_COMEDI_CB_DAS16_CS=y
CONFIG_COMEDI_DAS08_CS=y
CONFIG_COMEDI_NI_DAQ_700_CS=y
CONFIG_COMEDI_NI_DAQ_DIO24_CS=y
CONFIG_COMEDI_NI_LABPC_CS=y
CONFIG_COMEDI_NI_MIO_CS=y
CONFIG_COMEDI_QUATECH_DAQP_CS=y
CONFIG_COMEDI_8254=y
CONFIG_COMEDI_8255=y
# CONFIG_COMEDI_8255_SA is not set
# CONFIG_COMEDI_KCOMEDILIB is not set
CONFIG_COMEDI_AMPLC_DIO200=y
CONFIG_COMEDI_DAS08=y
CONFIG_COMEDI_ISADMA=y
CONFIG_COMEDI_NI_LABPC=y
CONFIG_COMEDI_NI_LABPC_ISADMA=y
CONFIG_COMEDI_NI_TIO=y
CONFIG_COMEDI_NI_ROUTING=y
# CONFIG_COMEDI_TESTS is not set
# CONFIG_STAGING is not set
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
# CONFIG_MLXREG_HOTPLUG is not set
CONFIG_MLXREG_IO=y
# CONFIG_MLXREG_LC is not set
CONFIG_NVSW_SN2201=y
CONFIG_OLPC_EC=y
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_P2SB is not set
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_COMMON_CLK_WM831X is not set
CONFIG_COMMON_CLK_MAX77686=y
CONFIG_COMMON_CLK_MAX9485=y
CONFIG_COMMON_CLK_RK808=y
# CONFIG_COMMON_CLK_SI5341 is not set
CONFIG_COMMON_CLK_SI5351=y
CONFIG_COMMON_CLK_SI514=y
# CONFIG_COMMON_CLK_SI544 is not set
CONFIG_COMMON_CLK_SI570=y
CONFIG_COMMON_CLK_CDCE706=y
CONFIG_COMMON_CLK_CDCE925=y
CONFIG_COMMON_CLK_CS2000_CP=y
CONFIG_COMMON_CLK_S2MPS11=y
# CONFIG_CLK_TWL6040 is not set
CONFIG_COMMON_CLK_AXI_CLKGEN=y
CONFIG_COMMON_CLK_LOCHNAGAR=y
CONFIG_COMMON_CLK_PALMAS=y
CONFIG_COMMON_CLK_RS9_PCIE=y
CONFIG_COMMON_CLK_VC5=y
# CONFIG_COMMON_CLK_VC7 is not set
CONFIG_COMMON_CLK_BD718XX=y
CONFIG_COMMON_CLK_FIXED_MMIO=y
# CONFIG_CLK_LGM_CGU is not set
CONFIG_XILINX_VCU=y
CONFIG_COMMON_CLK_XLNX_CLKWZRD=y
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_TIMER_OF=y
CONFIG_TIMER_PROBE=y
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MICROCHIP_PIT64B=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
# CONFIG_PLATFORM_MHU is not set
# CONFIG_PCC is not set
# CONFIG_ALTERA_MBOX is not set
# CONFIG_MAILBOX_TEST is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_DMA_STRICT is not set
# CONFIG_IOMMU_DEFAULT_DMA_LAZY is not set
CONFIG_IOMMU_DEFAULT_PASSTHROUGH=y
CONFIG_OF_IOMMU=y
CONFIG_IOMMU_DMA=y
# CONFIG_IOMMUFD is not set
CONFIG_VIRTIO_IOMMU=y

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
CONFIG_RPMSG=y
CONFIG_RPMSG_CHAR=y
CONFIG_RPMSG_CTRL=y
CONFIG_RPMSG_NS=y
CONFIG_RPMSG_QCOM_GLINK=y
CONFIG_RPMSG_QCOM_GLINK_RPM=y
CONFIG_RPMSG_VIRTIO=y
# end of Rpmsg drivers

CONFIG_SOUNDWIRE=y

#
# SoundWire Devices
#

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
CONFIG_LITEX=y
CONFIG_LITEX_SOC_CONTROLLER=y
# end of Enable LiteX SoC Builder specific drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_FSA9480=y
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_INTEL_INT3496 is not set
# CONFIG_EXTCON_MAX14577 is not set
CONFIG_EXTCON_MAX3355=y
# CONFIG_EXTCON_MAX77693 is not set
# CONFIG_EXTCON_PALMAS is not set
CONFIG_EXTCON_PTN5150=y
CONFIG_EXTCON_RT8973A=y
CONFIG_EXTCON_SM5502=y
CONFIG_EXTCON_USB_GPIO=y
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_PWM is not set

#
# IRQ chip support
#
CONFIG_IRQCHIP=y
# CONFIG_AL_FIC is not set
CONFIG_MADERA_IRQ=y
CONFIG_XILINX_INTC=y
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_RESET_INTEL_GW is not set
CONFIG_RESET_SIMPLE=y
CONFIG_RESET_TI_SYSCON=y
# CONFIG_RESET_TI_TPS380X is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_GENERIC_PHY_MIPI_DPHY=y
# CONFIG_USB_LGM_PHY is not set
CONFIG_PHY_CAN_TRANSCEIVER=y

#
# PHY drivers for Broadcom platforms
#
# CONFIG_BCM_KONA_USB2_PHY is not set
# end of PHY drivers for Broadcom platforms

CONFIG_PHY_CADENCE_TORRENT=y
CONFIG_PHY_CADENCE_DPHY=y
CONFIG_PHY_CADENCE_DPHY_RX=y
CONFIG_PHY_CADENCE_SIERRA=y
CONFIG_PHY_CADENCE_SALVO=y
CONFIG_PHY_PXA_28NM_HSIC=y
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_LAN966X_SERDES is not set
# CONFIG_PHY_MAPPHONE_MDM6600 is not set
CONFIG_PHY_OCELOT_SERDES=y
# CONFIG_PHY_INTEL_LGM_COMBO is not set
CONFIG_PHY_INTEL_LGM_EMMC=y
# end of PHY Subsystem

# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

# CONFIG_RAS is not set
# CONFIG_USB4 is not set

#
# Android
#
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

# CONFIG_DAX is not set
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
# CONFIG_NVMEM_RMEM is not set
CONFIG_NVMEM_SPMI_SDAM=y
CONFIG_NVMEM_U_BOOT_ENV=y

#
# HW tracing support
#
CONFIG_STM=y
CONFIG_STM_PROTO_BASIC=y
CONFIG_STM_PROTO_SYS_T=y
# CONFIG_STM_DUMMY is not set
# CONFIG_STM_SOURCE_CONSOLE is not set
# CONFIG_STM_SOURCE_HEARTBEAT is not set
CONFIG_STM_SOURCE_FTRACE=y
# CONFIG_INTEL_TH is not set
# end of HW tracing support

# CONFIG_FPGA is not set
CONFIG_FSI=y
# CONFIG_FSI_NEW_DEV_NODE is not set
# CONFIG_FSI_MASTER_GPIO is not set
CONFIG_FSI_MASTER_HUB=y
CONFIG_FSI_MASTER_ASPEED=y
CONFIG_FSI_SCOM=y
CONFIG_FSI_SBEFIFO=y
# CONFIG_FSI_OCC is not set
CONFIG_MULTIPLEXER=y

#
# Multiplexer drivers
#
# CONFIG_MUX_ADG792A is not set
# CONFIG_MUX_GPIO is not set
CONFIG_MUX_MMIO=y
# end of Multiplexer drivers

CONFIG_PM_OPP=y
CONFIG_SIOX=y
CONFIG_SIOX_BUS_GPIO=y
CONFIG_SLIMBUS=y
CONFIG_SLIM_QCOM_CTRL=y
CONFIG_INTERCONNECT=y
CONFIG_COUNTER=y
# CONFIG_INTERRUPT_CNT is not set
CONFIG_FTM_QUADDEC=y
CONFIG_MICROCHIP_TCB_CAPTURE=y
# CONFIG_INTEL_QEP is not set
CONFIG_MOST=y
# CONFIG_MOST_CDEV is not set
CONFIG_PECI=y
CONFIG_PECI_CPU=y
# CONFIG_HTE is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_VALIDATE_FS_PARSER=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
# CONFIG_FS_ENCRYPTION is not set
CONFIG_FS_VERITY=y
# CONFIG_FS_VERITY_DEBUG is not set
CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_AUTOFS_FS=y
# CONFIG_FUSE_FS is not set
# CONFIG_OVERLAY_FS is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=y
# CONFIG_NETFS_STATS is not set
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_DEBUG=y
# end of Caches

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_PROC_CHILDREN is not set
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_MEMFD_CREATE=y
CONFIG_CONFIGFS_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
CONFIG_ORANGEFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
# CONFIG_JFFS2_RTIME is not set
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
CONFIG_JFFS2_CMODE_FAVOURLZO=y
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_UBIFS_FS_ZSTD is not set
CONFIG_UBIFS_ATIME_SUPPORT=y
CONFIG_UBIFS_FS_XATTR=y
CONFIG_UBIFS_FS_SECURITY=y
CONFIG_UBIFS_FS_AUTHENTICATION=y
CONFIG_CRAMFS=y
# CONFIG_CRAMFS_MTD is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
# CONFIG_PSTORE_DEFLATE_COMPRESS is not set
CONFIG_PSTORE_LZO_COMPRESS=y
CONFIG_PSTORE_LZ4_COMPRESS=y
CONFIG_PSTORE_LZ4HC_COMPRESS=y
# CONFIG_PSTORE_842_COMPRESS is not set
CONFIG_PSTORE_ZSTD_COMPRESS=y
CONFIG_PSTORE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS_DEFAULT is not set
# CONFIG_PSTORE_LZ4_COMPRESS_DEFAULT is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS_DEFAULT is not set
CONFIG_PSTORE_ZSTD_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="zstd"
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_PMSG is not set
CONFIG_PSTORE_RAM=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=m
# CONFIG_NFS_V4_1 is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_FSCACHE is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFSD is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
# CONFIG_SUNRPC_DEBUG is not set
CONFIG_SUNRPC_XPRT_RDMA=y
CONFIG_CEPH_FS=y
CONFIG_CEPH_FSCACHE=y
# CONFIG_CEPH_FS_POSIX_ACL is not set
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_SMB_DIRECT is not set
# CONFIG_CIFS_FSCACHE is not set
CONFIG_CIFS_ROOT=y
CONFIG_SMB_SERVER=y
# CONFIG_SMB_SERVER_SMBDIRECT is not set
# CONFIG_SMB_SERVER_CHECK_CAP_NET_ADMIN is not set
CONFIG_SMB_SERVER_KERBEROS5=y
CONFIG_SMBFS_COMMON=y
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
# CONFIG_AFS_FSCACHE is not set
# CONFIG_AFS_DEBUG_CURSOR is not set
CONFIG_9P_FS=y
# CONFIG_9P_FSCACHE is not set
# CONFIG_9P_FS_POSIX_ACL is not set
CONFIG_9P_FS_SECURITY=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEPRECATED_API is not set
# CONFIG_DLM_DEBUG is not set
CONFIG_UNICODE=y
# CONFIG_UNICODE_NORMALIZATION_SELFTEST is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEY_DH_OPERATIONS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
# CONFIG_SECURITY_INFINIBAND is not set
# CONFIG_SECURITY_PATH is not set
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
# CONFIG_HARDENED_USERCOPY is not set
CONFIG_STATIC_USERMODEHELPER=y
CONFIG_STATIC_USERMODEHELPER_PATH="/sbin/usermode-helper"
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
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
CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_ENABLER=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y
# CONFIG_INIT_STACK_NONE is not set
CONFIG_INIT_STACK_ALL_PATTERN=y
# CONFIG_INIT_STACK_ALL_ZERO is not set
CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y
CONFIG_INIT_ON_FREE_DEFAULT_ON=y
# end of Memory initialization

CONFIG_RANDSTRUCT_NONE=y
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
CONFIG_CRYPTO_ENGINE=y
# end of Crypto core or helper

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_DH_RFC7919_GROUPS=y
CONFIG_CRYPTO_ECC=y
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_ECDSA=y
# CONFIG_CRYPTO_ECRDSA is not set
CONFIG_CRYPTO_SM2=y
CONFIG_CRYPTO_CURVE25519=y
# end of Public-key cryptography

#
# Block ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_TI=y
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARIA is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SM4=y
CONFIG_CRYPTO_SM4_GENERIC=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# end of Block ciphers

#
# Length-preserving ciphers and modes
#
CONFIG_CRYPTO_ADIANTUM=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_HCTR2=y
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_OFB=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XCTR=y
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_NHPOLY1305=y
# end of Length-preserving ciphers and modes

#
# AEAD (authenticated encryption with associated data) ciphers
#
CONFIG_CRYPTO_AEGIS128=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=y
CONFIG_CRYPTO_ESSIV=y
# end of AEAD (authenticated encryption with associated data) ciphers

#
# Hashes, digests, and MACs
#
CONFIG_CRYPTO_BLAKE2B=y
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_POLYVAL=y
# CONFIG_CRYPTO_POLY1305 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
CONFIG_CRYPTO_SM3=y
CONFIG_CRYPTO_SM3_GENERIC=y
CONFIG_CRYPTO_STREEBOG=y
# CONFIG_CRYPTO_VMAC is not set
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_XCBC is not set
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
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_842=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y
CONFIG_CRYPTO_ZSTD=y
# end of Compression

#
# Random number generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_KDF800108_CTR=y
# end of Random number generation

#
# Userspace interface
#
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
# end of Userspace interface

CONFIG_CRYPTO_HASH_INFO=y

#
# Accelerated Cryptographic Algorithms for CPU (x86)
#
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TWOFISH_586=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
# end of Accelerated Cryptographic Algorithms for CPU (x86)

CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_CRYPTO_DEV_ATMEL_I2C=y
CONFIG_CRYPTO_DEV_ATMEL_ECC=y
CONFIG_CRYPTO_DEV_ATMEL_SHA204A=y
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXX is not set
# CONFIG_CRYPTO_DEV_QAT_C62X is not set
# CONFIG_CRYPTO_DEV_QAT_4XXX is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCCVF is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXXVF is not set
# CONFIG_CRYPTO_DEV_QAT_C62XVF is not set
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
CONFIG_CRYPTO_DEV_CCREE=y
CONFIG_CRYPTO_DEV_AMLOGIC_GXL=y
CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS8_PRIVATE_KEY_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
# CONFIG_SIGNED_PE_FILE_VERIFICATION is not set
# CONFIG_FIPS_SIGNATURE_SELFTEST is not set

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
CONFIG_SYSTEM_REVOCATION_LIST=y
CONFIG_SYSTEM_REVOCATION_KEYS=""
CONFIG_SYSTEM_BLACKLIST_AUTH_UPDATE=y
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
CONFIG_CORDIC=y
CONFIG_PRIME_NUMBERS=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_UTILS=y
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=y
CONFIG_CRYPTO_LIB_GF128MUL=y
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=y
CONFIG_CRYPTO_LIB_CHACHA=y
CONFIG_CRYPTO_LIB_CURVE25519_GENERIC=y
CONFIG_CRYPTO_LIB_CURVE25519=y
CONFIG_CRYPTO_LIB_DES=y
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=1
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=y
CONFIG_CRYPTO_LIB_POLY1305=y
CONFIG_CRYPTO_LIB_CHACHA20POLY1305=y
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
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC64=y
CONFIG_CRC4=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_842_COMPRESS=y
CONFIG_842_DECOMPRESS=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMMON=y
CONFIG_ZSTD_COMPRESS=y
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
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
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
CONFIG_SGL_ALLOC=y
# CONFIG_FORCE_NR_CPUS is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_DIMLIB=y
CONFIG_OID_REGISTRY=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_32=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_REF_TRACKER=y
# end of Library routines

CONFIG_POLYNOMIAL=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
CONFIG_STACKTRACE_BUILD_ID=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
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
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_DEBUG_INFO_DWARF5 is not set
CONFIG_DEBUG_INFO_REDUCED=y
CONFIG_DEBUG_INFO_COMPRESSED_NONE=y
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_PAHOLE_HAS_BTF_TAG=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=8192
CONFIG_STRIP_ASM_SYMS=y
CONFIG_HEADERS_INSTALL=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_FRAME_POINTER=y
CONFIG_VMLINUX_MAP=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
# CONFIG_MAGIC_SYSRQ_SERIAL is not set
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_CC_HAS_UBSAN_BOUNDS=y
CONFIG_CC_HAS_UBSAN_ARRAY_BOUNDS=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_ARRAY_BOUNDS=y
CONFIG_UBSAN_SHIFT=y
CONFIG_UBSAN_UNREACHABLE=y
# CONFIG_UBSAN_BOOL is not set
# CONFIG_UBSAN_ENUM is not set
# CONFIG_UBSAN_ALIGNMENT is not set
CONFIG_UBSAN_SANITIZE_ALL=y
# CONFIG_TEST_UBSAN is not set
CONFIG_HAVE_KCSAN_COMPILER=y
# end of Generic Kernel Debugging Instruments

#
# Networking Debugging
#
CONFIG_NET_DEV_REFCNT_TRACKER=y
CONFIG_NET_NS_REFCNT_TRACKER=y
# CONFIG_DEBUG_NET is not set
# end of Networking Debugging

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_PAGE_OWNER=y
# CONFIG_PAGE_POISONING is not set
CONFIG_DEBUG_PAGE_REF=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
CONFIG_PTDUMP_CORE=y
CONFIG_PTDUMP_DEBUGFS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SHRINKER_DEBUG=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
CONFIG_DEBUG_VM_IRQSOFF=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_MAPLE_TREE is not set
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VM_PGFLAGS=y
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_DEBUG_KMAP_LOCAL=y
CONFIG_ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP=y
CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_KASAN_SW_TAGS=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
CONFIG_HAVE_KMSAN_COMPILER=y
# end of Memory Debugging

# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_WQ_WATCHDOG=y
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RAW_LOCK_NESTING is not set
# CONFIG_LOCK_STAT is not set
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
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
# CONFIG_DEBUG_MAPLE_TREE is not set
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_LIST=y
CONFIG_TORTURE_TEST=m
CONFIG_RCU_SCALE_TEST=m
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_REF_SCALE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_EXP_CPU_STALL_TIMEOUT=0
CONFIG_RCU_TRACE=y
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

CONFIG_DEBUG_WQ_FORCE_RR_CPU=y
CONFIG_CPU_HOTPLUG_STATE_CONTROL=y
CONFIG_LATENCYTOP=y
# CONFIG_DEBUG_CGROUP_REF is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_RETHOOK=y
CONFIG_RETHOOK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_NO_PATCHABLE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_HAVE_BUILDTIME_MCOUNT_SORT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_BOOTTIME_TRACING=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
CONFIG_OSNOISE_TRACER=y
# CONFIG_TIMERLAT_TRACER is not set
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
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
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS=y
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_RV is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
CONFIG_IO_STRICT_DEVMEM=y

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
CONFIG_DEBUG_ENTRY=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_FRAME_POINTER=y
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_OF_RECONFIG_NOTIFIER_ERROR_INJECT is not set
CONFIG_NETDEV_NOTIFIER_ERROR_INJECT=y
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAULT_INJECTION_USERCOPY=y
CONFIG_FAIL_FUTEX=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_RUNTIME_TESTING_MENU is not set
CONFIG_ARCH_USE_MEMTEST=y
CONFIG_MEMTEST=y
# end of Kernel Testing and Coverage

#
# Rust hacking
#
# end of Rust hacking
# end of Kernel hacking

--Nh+VQZ1K8DTPMh+2
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
	export branch='linux-next/master'
	export commit='9b01c885be364526d8c05794f8358b3e563b7ff8'
	export kconfig='i386-randconfig-a006-20230213'
	export repeat_to=6
	export nr_vm=300
	export submit_id='63f348d00bc8036d3c6fbb70'
	export job_file='/lkp/jobs/scheduled/vm-meta-233/trinity-group-04-300s-debian-11.1-i386-20220923.cgz-9b01c885be364526d8c05794f8358b3e563b7ff8-20230220-27964-lla42e-3.yaml'
	export id='858f28802d276cc48fcfa496b90d71c0e991a0d8'
	export queuer_version='/zday/lkp'
	export model='qemu-system-x86_64 -enable-kvm -cpu SandyBridge'
	export nr_cpu=2
	export memory='16G'
	export need_kconfig=\{\"KVM_GUEST\"\=\>\"y\"\}
	export ssh_base_port=23032
	export kernel_cmdline_hw='vmalloc=256M initramfs_async=0 page_owner=on'
	export rootfs='debian-11.1-i386-20220923.cgz'
	export compiler='clang-14'
	export enqueue_time='2023-02-20 18:17:52 +0800'
	export _id='63f348d00bc8036d3c6fbb70'
	export _rt='/result/trinity/group-04-300s/vm-snb/debian-11.1-i386-20220923.cgz/i386-randconfig-a006-20230213/clang-14/9b01c885be364526d8c05794f8358b3e563b7ff8'
	export user='lkp'
	export LKP_SERVER='internal-lkp-server'
	export result_root='/result/trinity/group-04-300s/vm-snb/debian-11.1-i386-20220923.cgz/i386-randconfig-a006-20230213/clang-14/9b01c885be364526d8c05794f8358b3e563b7ff8/3'
	export scheduler_version='/lkp/lkp/.src-20230220-170517'
	export arch='i386'
	export max_uptime=1200
	export initrd='/osimage/debian/debian-11.1-i386-20220923.cgz'
	export bootloader_append='root=/dev/ram0
RESULT_ROOT=/result/trinity/group-04-300s/vm-snb/debian-11.1-i386-20220923.cgz/i386-randconfig-a006-20230213/clang-14/9b01c885be364526d8c05794f8358b3e563b7ff8/3
BOOT_IMAGE=/pkg/linux/i386-randconfig-a006-20230213/clang-14/9b01c885be364526d8c05794f8358b3e563b7ff8/vmlinuz-6.2.0-rc7-01623-g9b01c885be36
branch=linux-next/master
job=/lkp/jobs/scheduled/vm-meta-233/trinity-group-04-300s-debian-11.1-i386-20220923.cgz-9b01c885be364526d8c05794f8358b3e563b7ff8-20230220-27964-lla42e-3.yaml
user=lkp
ARCH=i386
kconfig=i386-randconfig-a006-20230213
commit=9b01c885be364526d8c05794f8358b3e563b7ff8
initcall_debug
mem=4G
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
	export modules_initrd='/pkg/linux/i386-randconfig-a006-20230213/clang-14/9b01c885be364526d8c05794f8358b3e563b7ff8/modules.cgz'
	export bm_initrd='/osimage/deps/debian-11.1-i386-20220923.cgz/run-ipconfig_20220923.cgz,/osimage/deps/debian-11.1-i386-20220923.cgz/lkp_20220923.cgz,/osimage/deps/debian-11.1-i386-20220923.cgz/rsync-rootfs_20220923.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-i386.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export schedule_notify_address=
	export stop_repeat_if_found='dmesg.WARNING:at_drivers/net/phy/phy.c:#phy_stop'
	export kbuild_queue_analysis=1
	export meta_host='vm-meta-233'
	export kernel='/pkg/linux/i386-randconfig-a006-20230213/clang-14/9b01c885be364526d8c05794f8358b3e563b7ff8/vmlinuz-6.2.0-rc7-01623-g9b01c885be36'
	export dequeue_time='2023-02-20 18:17:59 +0800'
	export job_initrd='/lkp/jobs/scheduled/vm-meta-233/trinity-group-04-300s-debian-11.1-i386-20220923.cgz-9b01c885be364526d8c05794f8358b3e563b7ff8-20230220-27964-lla42e-3.cgz'

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

	run_test group='group-04' $LKP_SRC/tests/wrapper trinity
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

--Nh+VQZ1K8DTPMh+2
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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
+wIAAAAABFla

--Nh+VQZ1K8DTPMh+2
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="trinity"

Seeding trinity by 3806611590 based on vm-snb/debian-11.1-i386-20220923.cgz/i386-randconfig-a006-20230213

--Nh+VQZ1K8DTPMh+2--
