Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563405F0C37
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 15:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbiI3NMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 09:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiI3NMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 09:12:19 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33A9176AE6;
        Fri, 30 Sep 2022 06:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664543532; x=1696079532;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=eIkXqdBjutLyjCuzU6ABXCJX2bimPCD7ieStbsT8qmc=;
  b=hCM1vpyYmAwxr9Lt1fif8dujUYho7DkwiYr36SFacQUV37vozohVxN20
   +JURCM1vkpSLI8MXx4IHkBsIZ12V9k9rgC4x7BDqmyU9mFemqYpjIblta
   QpmMv+dk83bEf9oji+kNgVd0uYfGf6PbbIQOyBteQ4vB+KokH+MVdYNVK
   Om6wfWaD/3BxuUnnMzJfEL+hMlnC29F2+z15xBgkikCxC6Q1G9OkRQBoz
   vo1hR2g2OZ1KTWE7KdIEH/FvuJjNGHCQBuN803woIHv9u4XJ6dt/2HxXW
   7bpKWb2rwhv2dMdJXr7C9ICDYX906/Iqi/tJdmo3zJ6z3VcVdUZVDNVV5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="388464830"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="xz'?yaml'?scan'208";a="388464830"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 06:12:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="622765250"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="xz'?yaml'?scan'208";a="622765250"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 30 Sep 2022 06:12:08 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 06:12:08 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 06:12:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 30 Sep 2022 06:12:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 30 Sep 2022 06:12:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZJIcIo2rQhy6zzsvJ+qLRfAolFTRSKd8Xuwo0VZiXoxnaPhSP1K4DWEG5vCo518l3K+EFuqxOE4XYlzurbKSNsv7SznjIAU0iGTsD6yIcxM+0gKdgbOMWhFiKASx2pJc/iwiQ3qdfUJV4JUPLklLUij9gR/qcvGFyczISMYsEGJuCHwCWYejXaVsGTrOqBjx47Q7IPkh0qiJq77+Klc/7L/EJ4dqhWQDt4Sup4TUjT13JX4UNuYEdcbmduYcirNEtA1F7VA6kqV2Z9sevoLGS+agZFeJBfBWiSEKDFsfSpTk3ZZ9iMDYWuKSaxY05E4etjYvzvvjVPc7ilVdRpS1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LMG6Y5WCAPZKiEmFO6nq9etK7mnUcL5yfXdbXbd0Eb0=;
 b=ogZvP8SVO0JpzdWf339ZOZsfbwqI+HGvsF/8mPl7bDWoy4NYJr8T7uSlfky0OhWNoO1MKbOK0xU19NfCHnobaJbryAoqqtQtLmTSbkbOH0dzIpHePAqV/vovx0qC7AU5swaJNkFXUju3XdqujLySgF1//8coeZQSvzgj0P6B394kdiZMug/b46z0Y5lvxrmHQ79yOO2nKWhr6bFZn1RSz0uIJeOXzqhNCwAp64UJRO176q0a4nGog1zv1r3u0Ia8I4j7HvRF8oFqSJVV3tzGjyq/tsGJG5GNBt4H5mtYwMbTGj6QlQWxkG4tNAIqGP/SoVdC+AZgWhmlOdXZcciXOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by SA2PR11MB4908.namprd11.prod.outlook.com (2603:10b6:806:112::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 13:11:59 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e1c4:1741:2788:37d0]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e1c4:1741:2788:37d0%3]) with mapi id 15.20.5676.020; Fri, 30 Sep 2022
 13:11:59 +0000
Date:   Fri, 30 Sep 2022 21:11:48 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
CC:     <lkp@lists.01.org>, <lkp@intel.com>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <aroulin@nvidia.com>,
        <sbrivio@redhat.com>, <roopa@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        <linux-kernel@vger.kernel.org>,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: [net]  f6390526ee:
 WARNING:at_net/core/dev.c:#unregister_netdevice_many
Message-ID: <202209302138.2da57ac7-oliver.sang@intel.com>
Content-Type: multipart/mixed; boundary="DuewNRPVZxpFkKvl"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ef43d44ebdebe90783325cb68edb70a7c80c038.1663445339.git.sevinj.aghayeva@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: SG2PR06CA0249.apcprd06.prod.outlook.com
 (2603:1096:4:ac::33) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|SA2PR11MB4908:EE_
X-MS-Office365-Filtering-Correlation-Id: 653698fe-e8f3-40a2-9f90-08daa2e55b4b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKCDLIasPfU7pDB5K8F9wdkPW+KCtbi9Sx5NrLtrVuATMTAtHAd7DR8VXx5aFHfOFdttZnl0J1EmjWBXwAawlJBPUD8YyOFmh1t5oPfDAwcItnjT9GG56q19xsNUNzDV31/RIpcNRYdUmJYPBxiKUqO5YbjKIpu+TjcP2aUsuvdZ1+X2aIZq0ov3mVXwQPMllU07T6HTmiu7ywkVLotx9QSeJu8WcgW5hhjLmyCj3H/QjeyDbt2jFXAmx+9gop1osTP7EETlwziQInpHnbjsmrer1uhh9K/KwWXTuT0F/78OtFg1mBWjOH8I5y4ne9tynOsSR0b6pohtvyxN03ndXshYyrmdO9FIEMbyVv65vi+Iw+sAHBKsSRzbN8jNMyAWKCDZ+jqoL7I/hHsRHrGcqsiCyc/bFctU4GV3+BERIuSe7CTv+972CvptBk15Xu4VKf+c8tw5wzEKzrfG/yZ75PnYPX2Mv8gmb8BckS4k9zyYOeJa287SDTfb8AXadN8ZcBRqIvknv2JRXy5VvsVPmZbmeex/DgqXGUwBK5BBPnqWwoCrA8oAQWH+bQa/XdOIkqxm29GtRPZNqmRwhwHdcyJcs1HYb7cCI9fVFQOGKOZ5MqTg3wZlKk5ZnNsoDoBQxpfW8gA0AO1wcPjc80www6WBo/kQQWL+PBkKjz/IH07yDlVKxYxuEoJOSlkoB/8FDMdSdmQqNrTjUFLySOENITP1Kr6g16gtpXZN4bnrQo/0CjXjXSi/tLVcpPU6SzdU+82QUNNNwnDmXu8rTpUg3SfXfEAWxUN61XvRYhqsVfLNw73HGs5OPipTEJBwQsKiMaLsmun3EFwj2ZzyEUEsTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(346002)(366004)(396003)(451199015)(41300700001)(36756003)(30864003)(38100700002)(8936002)(7416002)(5660300002)(26005)(235185007)(2616005)(966005)(478600001)(6486002)(45080400002)(186003)(6666004)(1076003)(6512007)(33964004)(6506007)(86362001)(66556008)(66946007)(8676002)(66476007)(4326008)(21490400003)(6916009)(316002)(83380400001)(44144004)(54906003)(82960400001)(2906002)(2700100001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dOHyeFMZ1BtJfifdlYc3pfp/8cRSi08kWUeqbo4hYt79H3wA7TuwZeYxDsAW?=
 =?us-ascii?Q?ScxqtB3bCq3PxYltXZBI2HNs+gPWlvdFCtFAJqIAzy4Nw2YBEQA3wP79HmWy?=
 =?us-ascii?Q?V2KFDLNZ3qgRQbCU+wZaT3cvf+40coeREb080+pSbAbMEfQFgPwBLxpCK9ZF?=
 =?us-ascii?Q?FEBTZFNlE+EKNYGcM9HiK2WM3+XhuOKnt5p//Nq35uqmDy4AIANgbYi5EYUC?=
 =?us-ascii?Q?k6Mixapmn4rFBypR7gxorSV5OWzyQpGGDTkWtisiKktfSKnjUm0Sj2a5G1SK?=
 =?us-ascii?Q?tD1ibmEwZYxKuccTT4CYagtdEotXOuFIRg2N4FXvgCIX3OGGtCQLqqJmWUUT?=
 =?us-ascii?Q?NTIfYBEQR+JXPbzkJoZP2LO3obCUXeP0a6fO8tD60773Ly6J6VwekbU6/SxT?=
 =?us-ascii?Q?OaauEciqTdu53guFdjQ2DHAEVBAycrNEaIlduqT0sLi46ZIy79TTgGljD2Y6?=
 =?us-ascii?Q?ZkWULZoCt5Wv0GkLhI9ANmvwlmuLFKdPpMUHEW2kRQvLtM0w5xmkLA7zNKZJ?=
 =?us-ascii?Q?j2Z68KgHrbX9FgCppu1hMy+Eike8VFZhxIQ0aN45VDV/TCik4T94VrxdEXsK?=
 =?us-ascii?Q?1LrQAhM6zsiensrXHgs8BM32WLN7kv02fa/TFbNnwTQvxe9YZBXdmR83+4fZ?=
 =?us-ascii?Q?qRALwTD6zRABHNRCt1QttDbz7O893I4bj/Cok0VPnrj08CLybIDgjL9p4tHQ?=
 =?us-ascii?Q?jymTZt4Ug+WHIS94hYAVLQ1xxCePtHEI2uZqt8VvFZ9cYRB8LbMJYIWFTjU5?=
 =?us-ascii?Q?g8+dcNxHFn5DNqOLLWTy7uxM0y+0fNudUFdfw8pTw+7vGsTrt7QW9JIfjLBp?=
 =?us-ascii?Q?ilQbbtSku9f2GB2IeZWH4yofTzNX/Y6TY5DemqdZafVa1IE1T5iI6GGO+jQX?=
 =?us-ascii?Q?bSbJMaYAfSJG6EQ49LNNYNVlaDNwM+eOM2ZqTS4wGvdTvcvlKC8MK+64fg9W?=
 =?us-ascii?Q?MnlcjiciCdp3mjDYA8f5o9IBuQSmqpI5D5qEfMvfTG5wf6bKAUN97Qna97jU?=
 =?us-ascii?Q?Na9w8zpQBK2Kybl5dFgTjXo3k7OuNboBlY8swRZVTglsi1NDnoGEy3kuMKyY?=
 =?us-ascii?Q?/FpAJW+vWC2lpHa7U4fdOR/k+R6ewCbeTwP7unR3h0jkWgh+roN7TofKecJS?=
 =?us-ascii?Q?matzmNnSsfW+mVYAzamELW9cD/oxcvg7WS0b8U5p/v8ZzVZA/gWYXXypnKUa?=
 =?us-ascii?Q?JajP2vUtBlrLGFaxXnVh9qEYrsNvpEkBMxm8jr7DXsVIC2KonpGQpXPSZ0il?=
 =?us-ascii?Q?fd+Vp/ZMmV0nHNJGUw5lmhmiRMahcPBvCvVn4rAVz9EPax9Lbc+Rig36KxIn?=
 =?us-ascii?Q?Y7sCS8gW0uGwa2RR20z3nPcUBJczHEp/I9IT7irdyN2digc98EEp4OMXc3at?=
 =?us-ascii?Q?cgPbD1IJRPu3c2g4ty8GJdS5S37ySI2ToPHKgpztBarevjTQlAM8eYLQX9Da?=
 =?us-ascii?Q?74HbRnBms0BS9e0uUDRQX5hcLKD2tDIIoeMoyVYUfcLy7q21n4fvKZ0DkaoD?=
 =?us-ascii?Q?zUaPdHMvOL8A9HgK59mGS0gv9s26OazTC70zuTbRIXV+k6JSvDQRcNqarR3w?=
 =?us-ascii?Q?OLQfyfCsR7NCs+QbcqUJoaQviKyQtbjecKMn9pL8EODsprA1wasPfZSfgA5T?=
 =?us-ascii?Q?XA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 653698fe-e8f3-40a2-9f90-08daa2e55b4b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 13:11:59.6594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7yNxxITryy/lkFRdGE8hEcxLltk4QzZeK4iEzlEdQ6KiAEnP9WD5D3S8xkg7e1xi0SQ4KYqLczrtL7z4sAoGuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4908
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLACK autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--DuewNRPVZxpFkKvl
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline


Greeting,

FYI, we noticed the following commit (built with gcc-11):

commit: f6390526ee0b0408d9ed03bd8607abd2a702cb36 ("[PATCH RFC net-next 4/5] net: bridge: handle link-type-specific changes in the bridge module")
url: https://github.com/intel-lab-lkp/linux/commits/Sevinj-Aghayeva/net-vlan-fix-bridge-binding-behavior-and-add-selftests/20220918-041944
base: https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git 44a8535fb87c5503ce01121278ac3058eef701ec
patch link: https://lore.kernel.org/netdev/8ef43d44ebdebe90783325cb68edb70a7c80c038.1663445339.git.sevinj.aghayeva@gmail.com

in testcase: hwsim
version: hwsim-x86_64-717e5d7-1_20220525
with following parameters:

	test: group-02



on test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz (Ivy Bridge) with 16G memory

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):



If you fix the issue, kindly add following tag
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Link: https://lore.kernel.org/r/202209302138.2da57ac7-oliver.sang@intel.com


[  114.492414][ T4435] ------------[ cut here ]------------
[ 114.492544][ T4435] WARNING: CPU: 0 PID: 4435 at net/core/dev.c:10882 unregister_netdevice_many (net/core/dev.c:10882 (discriminator 1)) 
[  114.492717][ T4435] Modules linked in: 8021q garp mrp bridge stp llc cmac ccm mac80211_hwsim mac80211 cfg80211 rfkill libarc4 netconsole btrfs blake2b_generic xor raid6_pq zstd_compress libcrc32c intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp i915 sd_mod t10_pi coretemp crc64_rocksoft_generic crc64_rocksoft crc64 sg drm_buddy kvm_intel intel_gtt kvm irqbypass crct10dif_pclmul crc32_pclmul drm_display_helper crc32c_intel ghash_clmulni_intel ipmi_devintf ttm rapl ipmi_msghandler firewire_ohci drm_kms_helper ahci intel_cstate libahci firewire_core intel_uncore syscopyarea crc_itu_t sysfillrect sysimgblt libata mxm_wmi fb_sys_fops wmi video drm fuse ip_tables
[  114.493770][ T4435] CPU: 0 PID: 4435 Comm: hostapd Not tainted 6.0.0-rc4-00989-gf6390526ee0b #1
[  114.493948][ T4435] Hardware name:  /DZ77BH-55K, BIOS BHZ7710H.86A.0097.2012.1228.1346 12/28/2012
[ 114.494119][ T4435] RIP: 0010:unregister_netdevice_many (net/core/dev.c:10882 (discriminator 1)) 
[ 114.494234][ T4435] Code: 73 fb ff ff ba ce 1a 00 00 48 c7 c6 60 cd e2 83 48 c7 c7 a0 cd e2 83 c6 05 41 21 3f 02 01 e8 c4 52 6f 00 0f 0b e9 4d fb ff ff <0f> 0b e9 39 fb ff ff 4c 89 0c 24 e8 e3 37 b5 fe 4c 8b 0c 24 e9 40
All code
========
   0:	73 fb                	jae    0xfffffffffffffffd
   2:	ff                   	(bad)  
   3:	ff                   	(bad)  
   4:	ba ce 1a 00 00       	mov    $0x1ace,%edx
   9:	48 c7 c6 60 cd e2 83 	mov    $0xffffffff83e2cd60,%rsi
  10:	48 c7 c7 a0 cd e2 83 	mov    $0xffffffff83e2cda0,%rdi
  17:	c6 05 41 21 3f 02 01 	movb   $0x1,0x23f2141(%rip)        # 0x23f215f
  1e:	e8 c4 52 6f 00       	callq  0x6f52e7
  23:	0f 0b                	ud2    
  25:	e9 4d fb ff ff       	jmpq   0xfffffffffffffb77
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 39 fb ff ff       	jmpq   0xfffffffffffffb6a
  31:	4c 89 0c 24          	mov    %r9,(%rsp)
  35:	e8 e3 37 b5 fe       	callq  0xfffffffffeb5381d
  3a:	4c 8b 0c 24          	mov    (%rsp),%r9
  3e:	e9                   	.byte 0xe9
  3f:	40                   	rex

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 39 fb ff ff       	jmpq   0xfffffffffffffb40
   7:	4c 89 0c 24          	mov    %r9,(%rsp)
   b:	e8 e3 37 b5 fe       	callq  0xfffffffffeb537f3
  10:	4c 8b 0c 24          	mov    (%rsp),%r9
  14:	e9                   	.byte 0xe9
  15:	40                   	rex
[  114.494583][ T4435] RSP: 0018:ffffc900011df168 EFLAGS: 00010202
[  114.494718][ T4435] RAX: ffff8881603d6301 RBX: ffff8881603d6b00 RCX: ffffffff812f88d3
[  114.494871][ T4435] RDX: 1ffff11020451414 RSI: 0000000000000008 RDI: ffffffff84fb2aa0
[  114.495004][ T4435] RBP: ffffffffa07829c0 R08: 0000000000000000 R09: ffffffff84fb2aa7
[  114.495137][ T4435] R10: fffffbfff09f6554 R11: 0000000000000001 R12: ffff8881603d6b10
[  114.495273][ T4435] R13: dffffc0000000000 R14: ffff8881603d6b00 R15: ffff88810228a000
[  114.495406][ T4435] FS:  00007f67dc94a740(0000) GS:ffff88837d800000(0000) knlGS:0000000000000000
[  114.495599][ T4435] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  114.495733][ T4435] CR2: 00007f81b15f56f4 CR3: 00000001b56f4003 CR4: 00000000001706f0
[  114.495869][ T4435] Call Trace:
[  114.495931][ T4435]  <TASK>
[ 114.495989][ T4435] ? flush_backlog (net/core/dev.c:10803) 
[ 114.496077][ T4435] ? kfree (mm/slub.c:1780 mm/slub.c:3534 mm/slub.c:4562) 
[ 114.496153][ T4435] ? rcu_nocb_try_bypass (kernel/rcu/tree.c:2769) 
[ 114.496247][ T4435] ? vlan_vid_del (net/8021q/vlan_core.c:368 net/8021q/vlan_core.c:387) 
[ 114.496334][ T4435] vlan_device_event (net/8021q/vlan.c:528) 8021q
[ 114.496439][ T4435] ? br_del_if (net/bridge/br_if.c:743) bridge
[ 114.496572][ T4435] ? unregister_vlan_dev (net/8021q/vlan.c:362) 8021q
[ 114.496701][ T4435] ? br_switchdev_event (net/bridge/br.c:29) bridge
[ 114.496820][ T4435] ? netconsole_netdev_event (drivers/net/netconsole.c:735) netconsole
[ 114.496937][ T4435] raw_notifier_call_chain (kernel/notifier.c:92 kernel/notifier.c:455) 
[ 114.497035][ T4435] unregister_netdevice_many (net/core/dev.c:10861) 
[ 114.497136][ T4435] ? __kernfs_remove+0x5b7/0x840 
[ 114.497235][ T4435] ? flush_backlog (net/core/dev.c:10803) 
[ 114.497321][ T4435] ? kernfs_dir_pos (fs/kernfs/dir.c:1342) 
[ 114.497408][ T4435] ? __cond_resched (kernel/sched/core.c:8316) 
[ 114.497492][ T4435] unregister_netdevice_queue (net/core/dev.c:10792) 
[ 114.497611][ T4435] ? unregister_netdevice_many (net/core/dev.c:10781) 
[ 114.497747][ T4435] ? up_write (arch/x86/include/asm/atomic64_64.h:172 include/linux/atomic/atomic-long.h:95 include/linux/atomic/atomic-instrumented.h:1348 kernel/locking/rwsem.c:1356 kernel/locking/rwsem.c:1605) 
[ 114.497826][ T4435] _cfg80211_unregister_wdev (include/linux/netdevice.h:3030 net/wireless/core.c:1157) cfg80211
[ 114.497985][ T4435] ? mutex_unlock (arch/x86/include/asm/atomic64_64.h:190 include/linux/atomic/atomic-long.h:449 include/linux/atomic/atomic-instrumented.h:1790 kernel/locking/mutex.c:181 kernel/locking/mutex.c:540) 
[ 114.498070][ T4435] ieee80211_if_remove (net/mac80211/iface.c:2279) mac80211
[ 114.498223][ T4435] ieee80211_del_iface (net/mac80211/cfg.c:204) mac80211
[ 114.498367][ T4435] cfg80211_remove_virtual_intf (net/wireless/rdev-ops.h:62 net/wireless/util.c:2491) cfg80211
[ 114.498543][ T4435] genl_family_rcv_msg_doit (net/netlink/genetlink.c:731) 
[ 114.498670][ T4435] ? genl_family_rcv_msg_attrs_parse+0x240/0x240 
[ 114.498798][ T4435] ? security_capable (security/security.c:807 (discriminator 13)) 
[ 114.498888][ T4435] genl_rcv_msg (net/netlink/genetlink.c:778 net/netlink/genetlink.c:795) 
[ 114.498970][ T4435] ? genl_get_cmd (net/netlink/genetlink.c:784) 
[ 114.499054][ T4435] ? netlink_recvmsg (net/netlink/af_netlink.c:2000) 
[ 114.499142][ T4435] ? nl80211_stop_ap (net/wireless/nl80211.c:4295) cfg80211
[ 114.499290][ T4435] ? kasan_set_free_info (mm/kasan/generic.c:372) 
[ 114.499381][ T4435] ? __kasan_slab_free (mm/kasan/common.c:369 mm/kasan/common.c:329 mm/kasan/common.c:375) 
[ 114.499473][ T4435] ? kmem_cache_free (mm/slub.c:1780 mm/slub.c:3534 mm/slub.c:3551) 
[ 114.499589][ T4435] ? netlink_recvmsg (net/netlink/af_netlink.c:2000) 
[ 114.499700][ T4435] ? ____sys_recvmsg (net/socket.c:2701) 
[ 114.499789][ T4435] ? ___sys_recvmsg (net/socket.c:2744) 
[ 114.499876][ T4435] ? __sys_recvmsg (include/linux/file.h:31 net/socket.c:2775) 
[ 114.499961][ T4435] netlink_rcv_skb (net/netlink/af_netlink.c:2540) 
[ 114.500046][ T4435] ? genl_get_cmd (net/netlink/genetlink.c:784) 
[ 114.500132][ T4435] ? netlink_ack (net/netlink/af_netlink.c:2517) 
[ 114.500216][ T4435] ? netlink_recvmsg (net/netlink/af_netlink.c:514) 
[ 114.500306][ T4435] ? _copy_from_iter (lib/iov_iter.c:628 (discriminator 11)) 
[ 114.500400][ T4435] genl_rcv (net/netlink/genetlink.c:807) 
[ 114.500474][ T4435] netlink_unicast (net/netlink/af_netlink.c:1320 net/netlink/af_netlink.c:1345) 
[ 114.500607][ T4435] ? netlink_attachskb (net/netlink/af_netlink.c:1330) 
[ 114.500720][ T4435] ? check_heap_object (arch/x86/include/asm/bitops.h:207 arch/x86/include/asm/bitops.h:239 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/page-flags.h:487 mm/usercopy.c:193) 
[ 114.500812][ T4435] netlink_sendmsg (net/netlink/af_netlink.c:1921) 
[ 114.500898][ T4435] ? netlink_unicast (net/netlink/af_netlink.c:1841) 
[ 114.500987][ T4435] ? __import_iovec (lib/iov_iter.c:1771) 
[ 114.501073][ T4435] ? netlink_unicast (net/netlink/af_netlink.c:1841) 
[ 114.501161][ T4435] sock_sendmsg (net/socket.c:714 net/socket.c:734) 
[ 114.501242][ T4435] ____sys_sendmsg (net/socket.c:2482) 
[ 114.501330][ T4435] ? kernel_sendmsg (net/socket.c:2429) 
[ 114.501414][ T4435] ? __copy_msghdr (net/socket.c:2409) 
[ 114.501500][ T4435] ___sys_sendmsg (net/socket.c:2538) 
[ 114.501612][ T4435] ? __ia32_sys_recvmmsg (net/socket.c:2525) 
[ 114.501728][ T4435] ? __fsnotify_update_child_dentry_flags (fs/notify/fsnotify.c:180) 
[ 114.501846][ T4435] ? __generic_file_write_iter (mm/filemap.c:3866) 
[ 114.501948][ T4435] ? _copy_from_user (arch/x86/include/asm/uaccess_64.h:46 arch/x86/include/asm/uaccess_64.h:52 lib/usercopy.c:16) 
[ 114.502035][ T4435] ? netlink_setsockopt (net/netlink/af_netlink.c:1630) 
[ 114.502130][ T4435] ? __fget_light (arch/x86/include/asm/atomic.h:29 include/linux/atomic/atomic-instrumented.h:28 fs/file.c:1005) 
[ 114.502213][ T4435] __sys_sendmsg (include/linux/file.h:31 net/socket.c:2567) 
[ 114.502297][ T4435] ? __sys_sendmsg_sock (net/socket.c:2553) 
[ 114.502386][ T4435] ? __sys_setsockopt (net/socket.c:2254) 
[ 114.502477][ T4435] ? __x64_sys_setsockopt (net/socket.c:2260) 
[ 114.502598][ T4435] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
[ 114.502703][ T4435] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120) 
[  114.502809][ T4435] RIP: 0033:0x7f67dca8d2c3
[ 114.502890][ T4435] Code: 64 89 02 48 c7 c0 ff ff ff ff eb b7 66 2e 0f 1f 84 00 00 00 00 00 90 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 89 54 24 1c 48
All code
========
   0:	64 89 02             	mov    %eax,%fs:(%rdx)
   3:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
   a:	eb b7                	jmp    0xffffffffffffffc3
   c:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  13:	00 00 00 
  16:	90                   	nop
  17:	64 8b 04 25 18 00 00 	mov    %fs:0x18,%eax
  1e:	00 
  1f:	85 c0                	test   %eax,%eax
  21:	75 14                	jne    0x37
  23:	b8 2e 00 00 00       	mov    $0x2e,%eax
  28:	0f 05                	syscall 
  2a:*	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax		<-- trapping instruction
  30:	77 55                	ja     0x87
  32:	c3                   	retq   
  33:	0f 1f 40 00          	nopl   0x0(%rax)
  37:	48 83 ec 28          	sub    $0x28,%rsp
  3b:	89 54 24 1c          	mov    %edx,0x1c(%rsp)
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
   6:	77 55                	ja     0x5d
   8:	c3                   	retq   
   9:	0f 1f 40 00          	nopl   0x0(%rax)
   d:	48 83 ec 28          	sub    $0x28,%rsp
  11:	89 54 24 1c          	mov    %edx,0x1c(%rsp)
  15:	48                   	rex.W


To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        sudo bin/lkp install job.yaml           # job file is attached in this email
        bin/lkp split-job --compatible job.yaml # generate the yaml file for lkp run
        sudo bin/lkp run generated-yaml-file

        # if come across any failure that blocks the test,
        # please remove ~/.lkp and /lkp dir to run from a clean state.



-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



--DuewNRPVZxpFkKvl
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="config-6.0.0-rc4-00989-gf6390526ee0b"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 6.0.0-rc4 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-11 (Debian 11.3.0-5) 11.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=110300
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=23890
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23890
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
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
CONFIG_SYSVIPC_COMPAT=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_WATCH_QUEUE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

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
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
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
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y
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
# CONFIG_CONTEXT_TRACKING_USER_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_CLOCKSOURCE_WATCHDOG_MAX_SKEW_US=100
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
# CONFIG_BPF_SYSCALL is not set
CONFIG_BPF_JIT=y
CONFIG_BPF_JIT_DEFAULT_ON=y
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
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
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
# CONFIG_FORCE_TASKS_RUDE_RCU is not set
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
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
# CONFIG_PRINTK_INDEX is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough=5"
CONFIG_GCC12_NO_ARRAY_BOUNDS=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
# CONFIG_CGROUP_FAVOR_DYNMODS is not set
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_MISC is not set
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
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
# CONFIG_BOOT_CONFIG is not set
CONFIG_INITRAMFS_PRESERVE_MTIME=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_GUEST_PERF_EVENTS=y

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
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_NR_GPIO=1024
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_AUDIT_ARCH=y
CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_HAVE_INTEL_TXT=y
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
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_BOOT_VESA_SUPPORT=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_CLUSTER=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# CONFIG_PERF_EVENTS_AMD_UNCORE is not set
# CONFIG_PERF_EVENTS_AMD_BRS is not set
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_LATE_LOADING=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_X86_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT is not set
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_X86_UMIP=y
CONFIG_CC_HAS_IBT=y
# CONFIG_X86_KERNEL_IBT is not set
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
# CONFIG_X86_INTEL_TSX_MODE_OFF is not set
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
CONFIG_X86_INTEL_TSX_MODE_AUTO=y
# CONFIG_X86_SGX is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
# CONFIG_KEXEC_SIG is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_XONLY=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
# CONFIG_STRICT_SIGALTSTACK_SIZE is not set
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_CC_HAS_SLS=y
CONFIG_CC_HAS_RETURN_THUNK=y
CONFIG_SPECULATION_MITIGATIONS=y
CONFIG_PAGE_TABLE_ISOLATION=y
CONFIG_RETPOLINE=y
CONFIG_RETHUNK=y
CONFIG_CPU_UNRET_ENTRY=y
CONFIG_CPU_IBPB_ENTRY=y
CONFIG_CPU_IBRS_ENTRY=y
# CONFIG_SLS is not set
CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_USERSPACE_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
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
# CONFIG_ACPI_FPDT is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_TAD=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_PLATFORM_PROFILE=m
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_ACPI_DPTF is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_ACPI_CONFIGFS is not set
# CONFIG_ACPI_PFRUT is not set
CONFIG_ACPI_PCC=y
CONFIG_PMIC_OPREGION=y
CONFIG_ACPI_PRMT=y
CONFIG_X86_PM_TIMER=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_AMD_PSTATE is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
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

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_MMCONF_FAM10H=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32_ABI is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
# end of Binary Emulations

CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_PFNCACHE=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_DIRTY_RING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_HAVE_KVM_PM_NOTIFIER=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_XEN is not set
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
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_KRETPROBE_ON_RETHOOK=y
CONFIG_USER_RETURN_NOTIFIER=y
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
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
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET=y
# CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
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

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODULE_UNLOAD_TAINT_TRACKING is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/sbin/modprobe"
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLOCK_LEGACY_AUTOLOAD=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG_COMMON=y
CONFIG_BLK_ICQ=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
CONFIG_BLK_DEV_ZONED=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_MQ=y
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
# CONFIG_BLK_CGROUP_IOPRIO is not set
CONFIG_BLK_DEBUG_FS=y
CONFIG_BLK_DEBUG_FS_ZONED=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_MQ_RDMA=y
CONFIG_BLK_PM=y
CONFIG_BLOCK_HOLDER_DEPRECATED=y
CONFIG_BLK_MQ_STACKING=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
# CONFIG_BFQ_CGROUP_DEBUG is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
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
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_ZPOOL=y
CONFIG_SWAP=y
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_DEFAULT_ON is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD=y
# CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD is not set
# CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC is not set
CONFIG_ZSWAP_ZPOOL_DEFAULT="zbud"
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
CONFIG_ZSMALLOC_STAT=y

#
# SLAB allocator options
#
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
# CONFIG_SLAB_FREELIST_HARDENED is not set
# CONFIG_SLUB_STATS is not set
CONFIG_SLUB_CPU_PARTIAL=y
# end of SLAB allocator options

CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_NUMA_KEEP_MEMINFO=y
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
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_DEVICE_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_THP_SWAP=y
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
# CONFIG_CMA_SYSFS is not set
CONFIG_CMA_AREAS=19
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_PAGE_IDLE_FLAG=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ZONE_DMA=y
CONFIG_ZONE_DMA32=y
CONFIG_ZONE_DEVICE=y
CONFIG_HMM_MIRROR=y
CONFIG_GET_FREE_REGION=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_TEST is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_SECRETMEM=y
# CONFIG_ANON_VMA_NAME is not set
# CONFIG_USERFAULTFD is not set

#
# Data Access Monitoring
#
# CONFIG_DAMON is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_AF_UNIX_OOB=y
CONFIG_UNIX_DIAG=m
CONFIG_TLS=m
CONFIG_TLS_DEVICE=y
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_USER_COMPAT is not set
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=m
CONFIG_XFRM_ESP=m
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_SMC is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_INET_RAW_DIAG=m
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_NV=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
CONFIG_TCP_CONG_BBR=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_ESP_OFFLOAD=m
# CONFIG_INET6_ESPINTCP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
# CONFIG_IPV6_SEG6_HMAC is not set
# CONFIG_IPV6_RPL_LWTUNNEL is not set
# CONFIG_IPV6_IOAM6_LWTUNNEL is not set
CONFIG_NETLABEL=y
# CONFIG_MPTCP is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_EGRESS=y
CONFIG_NETFILTER_SKIP_EGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
# CONFIG_NETFILTER_NETLINK_HOOK is not set
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_SYSLOG=m
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_NUMGEN=m
CONFIG_NFT_CT=m
CONFIG_NFT_CONNLIMIT=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
# CONFIG_NFT_TUNNEL is not set
CONFIG_NFT_OBJREF=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_QUOTA=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NFT_FIB=m
CONFIG_NFT_FIB_INET=m
# CONFIG_NFT_XFRM is not set
CONFIG_NFT_SOCKET=m
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NFT_SYNPROXY is not set
CONFIG_NF_DUP_NETDEV=m
CONFIG_NFT_DUP_NETDEV=m
CONFIG_NFT_FWD_NETDEV=m
CONFIG_NFT_FIB_NETDEV=m
# CONFIG_NFT_REJECT_NETDEV is not set
# CONFIG_NF_FLOW_TABLE is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XTABLES_COMPAT=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_OVF=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m
# CONFIG_IP_VS_TWOS is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NFT_DUP_IPV4=m
CONFIG_NFT_FIB_IPV4=m
CONFIG_NF_TABLES_ARP=y
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NFT_DUP_IPV6=m
CONFIG_NFT_FIB_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_TABLES_BRIDGE=m
# CONFIG_NFT_BRIDGE_META is not set
CONFIG_NFT_BRIDGE_REJECT=m
# CONFIG_NF_CONNTRACK_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
# CONFIG_TIPC_MEDIA_IB is not set
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
# CONFIG_6LOWPAN_NHC is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
# CONFIG_NET_SCH_ETF is not set
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=m
# CONFIG_NET_SCH_FQ_PIE is not set
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m
# CONFIG_NET_SCH_ETS is not set
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
# CONFIG_DEFAULT_CODEL is not set
CONFIG_DEFAULT_FQ_CODEL=y
# CONFIG_DEFAULT_SFQ is not set
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="fq_codel"

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_EMATCH_IPSET=m
# CONFIG_NET_EMATCH_IPT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
# CONFIG_NET_ACT_MPLS is not set
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
# CONFIG_NET_ACT_CONNMARK is not set
# CONFIG_NET_ACT_CTINFO is not set
CONFIG_NET_ACT_SKBMOD=m
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=m
# CONFIG_NET_ACT_GATE is not set
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=y
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
CONFIG_PCPU_DEV_REFCNT=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
# CONFIG_CAN_J1939 is not set
# CONFIG_CAN_ISOTP is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
# CONFIG_MCTP is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_FD=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
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
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCIE_DPC=y
# CONFIG_PCIE_PTM is not set
# CONFIG_PCIE_EDR is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=m
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
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
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_DEVTMPFS_SAFE is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_FW_LOADER_SYSFS=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
# CONFIG_FW_UPLOAD is not set
# end of Firmware loader

CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_MHI_BUS is not set
# CONFIG_MHI_BUS_EP is not set
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT is not set
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
CONFIG_SYSFB=y
# CONFIG_SYSFB_SIMPLEFB is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_DXE_MEM_ATTRIBUTES=y
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
# CONFIG_APPLE_PROPERTIES is not set
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y
# CONFIG_EFI_DISABLE_RUNTIME is not set
# CONFIG_EFI_COCO_SECRET is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

# CONFIG_GNSS is not set
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=m
CONFIG_ZRAM_DEF_COMP_LZORLE=y
# CONFIG_ZRAM_DEF_COMP_LZO is not set
CONFIG_ZRAM_DEF_COMP="lzo-rle"
CONFIG_ZRAM_WRITEBACK=y
# CONFIG_ZRAM_MEMORY_TRACKING is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_UBLK is not set

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
# CONFIG_NVME_VERBOSE_ERRORS is not set
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
# CONFIG_NVME_RDMA is not set
# CONFIG_NVME_FC is not set
# CONFIG_NVME_TCP is not set
# CONFIG_NVME_AUTH is not set
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
# CONFIG_NVME_TARGET_RDMA is not set
CONFIG_NVME_TARGET_FC=m
# CONFIG_NVME_TARGET_TCP is not set
# CONFIG_NVME_TARGET_AUTH is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_GSC is not set
# CONFIG_INTEL_MEI_HDCP is not set
# CONFIG_INTEL_MEI_PXP is not set
CONFIG_VMWARE_VMCI=m
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_BCM_VK is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=m
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# CONFIG_UACCE is not set
CONFIG_PVPANIC=y
# CONFIG_PVPANIC_MMIO is not set
# CONFIG_PVPANIC_PCI is not set
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI_COMMON=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_BLK_DEV_BSG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPI3MR is not set
# CONFIG_SCSI_SMARTPQI is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_EFCT is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_MD_CLUSTER=m
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
CONFIG_DM_WRITECACHE=m
# CONFIG_DM_EBS is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_MULTIPATH_HST is not set
# CONFIG_DM_MULTIPATH_IOA is not set
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
CONFIG_DM_INTEGRITY=m
# CONFIG_DM_ZONED is not set
CONFIG_DM_AUDIT=y
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=m
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_GENEVE is not set
# CONFIG_BAREUDP is not set
# CONFIG_GTP is not set
# CONFIG_AMT is not set
CONFIG_MACSEC=m
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_NET_VRF is not set
# CONFIG_VSOCKMON is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
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
# CONFIG_ENA_ETHERNET is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ASIX=y
# CONFIG_SPI_AX88796C is not set
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
CONFIG_CAVIUM_PTP=y
# CONFIG_LIQUIDIO is not set
# CONFIG_LIQUIDIO_VF is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
CONFIG_NET_VENDOR_DAVICOM=y
# CONFIG_DM9051 is not set
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
# CONFIG_FUN_ETH is not set
CONFIG_NET_VENDOR_GOOGLE=y
# CONFIG_GVE is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBE_DCB is not set
# CONFIG_IXGBE_IPSEC is not set
# CONFIG_IXGBEVF is not set
CONFIG_I40E=y
# CONFIG_I40E_DCB is not set
# CONFIG_I40EVF is not set
# CONFIG_ICE is not set
# CONFIG_FM10K is not set
CONFIG_IGC=y
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
# CONFIG_PRESTERA is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MICROSOFT=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
CONFIG_NET_VENDOR_NETRONOME=y
# CONFIG_NFP is not set
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
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=y
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
# CONFIG_SFC_SIENA is not set
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
# CONFIG_MSE102X is not set
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
CONFIG_PHYLINK=y
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set
CONFIG_FIXED_PHY=y
# CONFIG_SFP is not set

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_ADIN_PHY is not set
# CONFIG_ADIN1100_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
CONFIG_AX88796B_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM54140_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM84881_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_CORTINA_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_INTEL_XWAY_PHY is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_MARVELL_10G_PHY is not set
# CONFIG_MARVELL_88X2222_PHY is not set
# CONFIG_MAXLINEAR_GPHY is not set
# CONFIG_MEDIATEK_GE_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
# CONFIG_MOTORCOMM_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_NXP_C45_TJA11XX_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_TERANETICS_PHY is not set
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
# CONFIG_DP83TD510_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_CAN_DEV=m
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_NETLINK=y
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_CAN327 is not set
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_CTUCANFD_PCI is not set
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_F81601 is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_PLX_PCI=m
# CONFIG_CAN_SJA1000_ISA is not set
# CONFIG_CAN_SJA1000_PLATFORM is not set
CONFIG_CAN_SOFTING=m

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_CAN_MCP251XFD is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB is not set
# CONFIG_CAN_ETAS_ES58X is not set
# CONFIG_CAN_GS_USB is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_MCBA_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_FWNODE_MDIO=y
CONFIG_ACPI_MDIO=y
CONFIG_MDIO_DEVRES=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_MDIO_MVUSB is not set
# CONFIG_MDIO_THUNDER is not set

#
# MDIO Multiplexers
#

#
# PCS device drivers
#
# end of PCS device drivers

# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
# CONFIG_USB_NET_CDCETHER is not set
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_CDC_NCM is not set
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
# CONFIG_ATH11K is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWLMEI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
# CONFIG_WLAN_VENDOR_MEDIATEK is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
CONFIG_WLAN_VENDOR_PURELIFI=y
# CONFIG_PLFXLC is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_RTL8XXXU is not set
# CONFIG_RTW88 is not set
# CONFIG_RTW89 is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_SILABS=y
# CONFIG_WFX is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set
# CONFIG_WAN is not set

#
# Wireless WAN
#
# CONFIG_WWAN is not set
# end of Wireless WAN

# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_NETDEVSIM is not set
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set
CONFIG_INPUT_VIVALDIFMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
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
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
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
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_DECODER is not set
# CONFIG_INPUT_GPIO_VIBRA is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
# CONFIG_INPUT_PWM_VIBRA is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_DA7280_HAPTICS is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_IQS269A is not set
# CONFIG_INPUT_IQS626A is not set
# CONFIG_INPUT_IQS7222 is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SPI=m
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
# CONFIG_RMI4_F3A is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=64
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
CONFIG_SERIAL_8250_PERICOM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
CONFIG_HVC_DRIVER=y
# CONFIG_SERIAL_DEV_BUS is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
CONFIG_NVRAM=y
CONFIG_DEVPORT=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
# CONFIG_TCG_TIS_I2C is not set
# CONFIG_TCG_TIS_I2C_CR50 is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# CONFIG_XILLYUSB is not set
CONFIG_RANDOM_TRUST_CPU=y
CONFIG_RANDOM_TRUST_BOOTLOADER=y
# end of Character devices

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_MUX_MLXCPLD=m
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

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
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_AMDPSP is not set
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_CP2615 is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
# CONFIG_I2C_VIRTIO is not set
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_MICROCHIP_CORE is not set
# CONFIG_SPI_LANTIQ_SSC is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set
# CONFIG_SPI_AMD is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
CONFIG_SPI_DYNAMIC=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_PTP_1588_CLOCK_OPTIONAL=y
# CONFIG_DP83640_PHY is not set
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# end of PTP clock support

CONFIG_PINCTRL=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set

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
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_AMDPT is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCA9570 is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
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
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
# end of USB GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
# CONFIG_GPIO_MOCKUP is not set
# CONFIG_GPIO_VIRTIO is not set
# CONFIG_GPIO_SIM is not set
# end of Virtual GPIO drivers

# CONFIG_W1 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_PDA_POWER is not set
# CONFIG_IP5XXX_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SAMSUNG_SDI is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_LTC4162L is not set
# CONFIG_CHARGER_MAX77976 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
# CONFIG_CHARGER_BQ256XX is not set
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_BATTERY_RT5033 is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_CHARGER_BD99954 is not set
# CONFIG_BATTERY_UG3105 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AHT10 is not set
# CONFIG_SENSORS_AQUACOMPUTER_D5NEXT is not set
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_CORSAIR_PSU is not set
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_DELL_SMM is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX6620 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_MLXREG_FAN is not set
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_TPS23861 is not set
# CONFIG_SENSORS_MR75203 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775_CORE=m
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT6775_I2C is not set
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
# CONFIG_SENSORS_NZXT_SMART2 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_BPA_RS600 is not set
# CONFIG_SENSORS_DELTA_AHE50DC_FAN is not set
# CONFIG_SENSORS_FSP_3Y is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_DPS920AB is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR36021 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
# CONFIG_SENSORS_LT7182S is not set
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_MAX15301 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_MP2888 is not set
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_MP5023 is not set
# CONFIG_SENSORS_PIM4328 is not set
# CONFIG_SENSORS_PLI1209BC is not set
# CONFIG_SENSORS_PM6764TR is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE152 is not set
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SBTSI is not set
# CONFIG_SENSORS_SBRMI is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHT4x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SY7636A is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA238 is not set
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP464 is not set
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
# CONFIG_SENSORS_ASUS_WMI is not set
# CONFIG_SENSORS_ASUS_WMI_EC is not set
# CONFIG_SENSORS_ASUS_EC is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# CONFIG_INTEL_TCC_COOLING is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_INTEL_HFI_THERMAL is not set
# end of Intel thermal drivers

CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y
# CONFIG_WATCHDOG_HRTIMER_PRETIMEOUT is not set

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_MLX_WDT is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

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
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT4831 is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SIMPLE_MFD_I2C is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_ATC260X_I2C is not set
# CONFIG_MFD_INTEL_M10_BMC is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=m
CONFIG_LIRC=y
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_IR_IMON_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_IR_SANYO_DECODER=m
# CONFIG_IR_SHARP_DECODER is not set
CONFIG_IR_SONY_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
CONFIG_RC_DEVICES=y
CONFIG_IR_ENE=m
CONFIG_IR_FINTEK=m
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_IMON_RAW is not set
CONFIG_IR_ITE_CIR=m
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_NUVOTON=m
# CONFIG_IR_REDRAT3 is not set
CONFIG_IR_SERIAL=m
CONFIG_IR_SERIAL_TRANSMITTER=y
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_TOY is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_IR_WINBOND_CIR=m
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_RC_LOOPBACK is not set
# CONFIG_RC_XBOX_DVD is not set

#
# CEC support
#
# CONFIG_MEDIA_CEC_SUPPORT is not set
# end of CEC support

CONFIG_MEDIA_SUPPORT=m
CONFIG_MEDIA_SUPPORT_FILTER=y
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Media device types
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_PLATFORM_SUPPORT is not set
# CONFIG_MEDIA_TEST_SUPPORT is not set
# end of Media device types

#
# Media drivers
#

#
# Drivers filtered as selected at 'Filter media drivers'
#

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# end of Media drivers

CONFIG_MEDIA_HIDE_ANCILLARY_SUBDRV=y

#
# Media ancillary drivers
#
# end of Media ancillary drivers

#
# Graphics support
#
CONFIG_APERTURE_HELPERS=y
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
# CONFIG_DRM_DEBUG_SELFTEST is not set
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_DISPLAY_HELPER=m
CONFIG_DRM_DISPLAY_DP_HELPER=y
CONFIG_DRM_DISPLAY_HDCP_HELPER=y
CONFIG_DRM_DISPLAY_HDMI_HELPER=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_BUDDY=m
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
# CONFIG_DRM_I915_GVT_KVMGT is not set
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# CONFIG_DRM_VGEM is not set
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=m
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_QXL=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# CONFIG_DRM_PANEL_WIDECHIPS_WS2401 is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
CONFIG_DRM_BOCHS=m
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_GM12U320 is not set
# CONFIG_DRM_PANEL_MIPI_DBI is not set
# CONFIG_DRM_SIMPLEDRM is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9163 is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_GUD is not set
# CONFIG_DRM_SSD130X is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_NOMODESET=y
CONFIG_DRM_PRIVACY_SCREEN=y

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
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
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
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION is not set
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=m
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
CONFIG_HID_CMEDIA=m
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_FT260 is not set
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_VIVALDI is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
# CONFIG_HID_XIAOMI is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
# CONFIG_HID_LETSKETCH is not set
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_MEGAWORLD_FF is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NINTENDO is not set
CONFIG_HID_NTI=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=m
# CONFIG_HID_RAZER is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SEMITEK is not set
# CONFIG_HID_SIGMAMICRO is not set
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# CONFIG_HID_MCP2221 is not set
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set
# end of USB HID support

#
# I2C HID support
#
# CONFIG_I2C_HID_ACPI is not set
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=m
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
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
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=y
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PCI_RENESAS is not set
# CONFIG_USB_XHCI_PLATFORM is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_CDNS_SUPPORT is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_UPD78F0730 is not set
# CONFIG_USB_SERIAL_XR is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_APPLE_MFI_FASTCHARGE is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_UCSI_STM32G0 is not set
# CONFIG_TYPEC_TPS6598X is not set
# CONFIG_TYPEC_RT1719 is not set
# CONFIG_TYPEC_STUSB160X is not set
# CONFIG_TYPEC_WUSB3801 is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_FSA4480 is not set
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
# CONFIG_LEDS_LP50XX is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_IS31FL319X is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set

#
# Flash and Torch LED drivers
#

#
# RGB LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=m
# CONFIG_LEDS_TRIGGER_TTY is not set

#
# Simple LED drivers
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
CONFIG_INFINIBAND_VIRT_DMA=y
# CONFIG_INFINIBAND_EFA is not set
# CONFIG_INFINIBAND_ERDMA is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_OCRDMA is not set
# CONFIG_INFINIBAND_USNIC is not set
# CONFIG_INFINIBAND_RDMAVT is not set
CONFIG_RDMA_RXE=m
CONFIG_RDMA_SIW=m
CONFIG_INFINIBAND_IPOIB=m
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_INFINIBAND_ISERT is not set
# CONFIG_INFINIBAND_RTRS_CLIENT is not set
# CONFIG_INFINIBAND_RTRS_SERVER is not set
# CONFIG_INFINIBAND_OPA_VNIC is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_GHES=y
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
# CONFIG_EDAC_I10NM is not set
CONFIG_EDAC_PND2=m
# CONFIG_EDAC_IGEN6 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV3032 is not set
# CONFIG_RTC_DRV_RV8803 is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
# CONFIG_RTC_DRV_RV3029_HWMON is not set
# CONFIG_RTC_DRV_RX6110 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_GOLDFISH is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=m
# CONFIG_INTEL_IDXD is not set
# CONFIG_INTEL_IDXD_COMPAT is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_AMD_PTDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set
# CONFIG_INTEL_LDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
# CONFIG_DMABUF_HEAPS is not set
# CONFIG_DMABUF_SYSFS_STATS is not set
# end of DMABUF options

CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VFIO=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI_CORE=m
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=m
CONFIG_IRQ_BYPASS_MANAGER=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO_ANCHOR=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_PCI_LIB=y
CONFIG_VIRTIO_PCI_LIB_LEGACY=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MEM is not set
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
# CONFIG_VDPA is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# end of Microsoft Hyper-V guest support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
# CONFIG_STAGING is not set
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
# CONFIG_MLXREG_IO is not set
# CONFIG_MLXREG_LC is not set
# CONFIG_NVSW_SN2201 is not set
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE3_WMI is not set
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_HUAWEI_WMI is not set
# CONFIG_UV_SYSFS is not set
CONFIG_MXM_WMI=m
# CONFIG_PEAQ_WMI is not set
# CONFIG_NVIDIA_WMI_EC_BACKLIGHT is not set
# CONFIG_XIAOMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
# CONFIG_YOGABOOK_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACER_WMI=m
# CONFIG_AMD_PMC is not set
# CONFIG_AMD_HSMP is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
# CONFIG_ASUS_TF103C_DOCK is not set
# CONFIG_MERAKI_MX100 is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
# CONFIG_X86_PLATFORM_DRIVERS_DELL is not set
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
# CONFIG_WIRELESS_HOTKEY is not set
CONFIG_HP_WMI=m
# CONFIG_IBM_RTL is not set
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_SENSORS_HDAPS=m
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_THINKPAD_LMI is not set
# CONFIG_INTEL_ATOMISP2_PM is not set
# CONFIG_INTEL_SAR_INT1092 is not set
CONFIG_INTEL_PMC_CORE=m

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_WMI=y
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m

#
# Intel Uncore Frequency Control
#
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set
# end of Intel Uncore Frequency Control

CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_OAKTRAIL=m
# CONFIG_INTEL_ISHTP_ECLITE is not set
# CONFIG_INTEL_PUNIT_IPC is not set
CONFIG_INTEL_RST=m
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_INTEL_TURBO_MAX_3=y
# CONFIG_INTEL_VSEC is not set
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_PCENGINES_APU2 is not set
# CONFIG_BARCO_P50_GPIO is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
CONFIG_COMPAL_LAPTOP=m
# CONFIG_LG_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_SYSTEM76_ACPI is not set
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_SERIAL_MULTI_INSTANTIATE is not set
CONFIG_MLX_PLATFORM=m
CONFIG_INTEL_IPS=m
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
# CONFIG_SIEMENS_SIMATIC_IPC is not set
# CONFIG_WINMATE_FM07_KEYS is not set
CONFIG_P2SB=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_LMK04832 is not set
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
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
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOASID=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_DMA_STRICT is not set
CONFIG_IOMMU_DEFAULT_DMA_LAZY=y
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
CONFIG_IOMMU_SVA=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_SVM=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON=y
CONFIG_IRQ_REMAP=y
# CONFIG_VIRTIO_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
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

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_NTB_MSI is not set
# CONFIG_NTB_AMD is not set
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_EPF is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
# CONFIG_PWM_CLK is not set
# CONFIG_PWM_DWC is not set
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_USB_LGM_PHY is not set
# CONFIG_PHY_CAN_TRANSCEIVER is not set

#
# PHY drivers for Broadcom platforms
#
# CONFIG_BCM_KONA_USB2_PHY is not set
# end of PHY drivers for Broadcom platforms

# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
# CONFIG_NVMEM_RMEM is not set

#
# HW tracing support
#
CONFIG_STM=m
# CONFIG_STM_PROTO_BASIC is not set
# CONFIG_STM_PROTO_SYS_T is not set
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_ACPI=m
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_TEE is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# CONFIG_MOST is not set
# CONFIG_PECI is not set
# CONFIG_HTE is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_REPAIR=y
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_FS_SECURITY=y
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
CONFIG_F2FS_IOSTAT=y
# CONFIG_F2FS_UNFAIR_RWSEM is not set
# CONFIG_ZONEFS_FS is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_ALGS=y
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_VIRTIO_FS is not set
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=y
CONFIG_NETFS_STATS=y
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_ERROR_INJECTION is not set
# CONFIG_CACHEFILES_ONDEMAND is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_EXFAT_FS is not set
# CONFIG_NTFS_FS is not set
# CONFIG_NTFS3_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_TMPFS_INODE64 is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
# CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON is not set
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_PMSG is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_PSTORE_BLK is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EROFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFS_V4_2_READ_PLUS is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
# CONFIG_NFSD_V4_2_INTER_SSC is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_NFS_V4_2_SSC_HELPER=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_SMB_DIRECT is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_SMB_SERVER is not set
CONFIG_SMBFS_COMMON=m
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEPRECATED_API is not set
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_TRUSTED_KEYS_TPM=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_USER_DECRYPTED_DATA is not set
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_KEY_NOTIFICATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_INFINIBAND is not set
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_INTEL_TXT=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_SECURITY_LANDLOCK is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
# CONFIG_IMA is not set
# CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT is not set
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
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
# CONFIG_ZERO_CALL_USED_REGS is not set
# end of Memory initialization

CONFIG_RANDSTRUCT_NONE=y
# CONFIG_RANDSTRUCT_FULL is not set
# CONFIG_RANDSTRUCT_PERFORMANCE is not set
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
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
CONFIG_CRYPTO_KPP=m
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=y

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
# CONFIG_CRYPTO_DH_RFC7919_GROUPS is not set
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECDSA is not set
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_SM2 is not set
# CONFIG_CRYPTO_CURVE25519 is not set
# CONFIG_CRYPTO_CURVE25519_X86 is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=m
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
# CONFIG_CRYPTO_HCTR2 is not set
CONFIG_CRYPTO_ESSIV=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_XXHASH=m
CONFIG_CRYPTO_BLAKE2B=m
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_CRC64_ROCKSOFT=m
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_POLYVAL_CLMUL_NI is not set
CONFIG_CRYPTO_POLY1305=m
CONFIG_CRYPTO_POLY1305_X86_64=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3_GENERIC is not set
# CONFIG_CRYPTO_SM3_AVX_X86_64 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CHACHA20_X86_64=m
CONFIG_CRYPTO_SEED=m
# CONFIG_CRYPTO_ARIA is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4_GENERIC is not set
# CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
# CONFIG_CRYPTO_DEV_QAT_4XXX is not set
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
CONFIG_CRYPTO_DEV_NITROX=m
CONFIG_CRYPTO_DEV_NITROX_CNN55XX=m
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y
# CONFIG_FIPS_SIGNATURE_SELFTEST is not set

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_MODULE_SIG_KEY_TYPE_RSA=y
# CONFIG_MODULE_SIG_KEY_TYPE_ECDSA is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# CONFIG_SYSTEM_REVOCATION_LIST is not set
# CONFIG_SYSTEM_BLACKLIST_AUTH_UPDATE is not set
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_RAID6_PQ_BENCHMARK=y
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_CORDIC=m
# CONFIG_PRIME_NUMBERS is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=m
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=m
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305=m
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=m
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA1=y
CONFIG_CRYPTO_LIB_SHA256=y
# end of Crypto library routines

CONFIG_LIB_MEMNEQ=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC64_ROCKSOFT=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC64=m
# CONFIG_CRC4 is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
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
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_INTERVAL_TREE=y
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
# CONFIG_DMA_PERNUMA_CMA is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_DIMLIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_STACKDEPOT_ALWAYS_INIT=y
CONFIG_SBITMAP=y
# end of Library routines

CONFIG_ASN1_ENCODER=y

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
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_NONE is not set
# CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
CONFIG_DEBUG_INFO_DWARF4=y
# CONFIG_DEBUG_INFO_DWARF5 is not set
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=8192
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_OBJTOOL=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
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
# CONFIG_PAGE_TABLE_CHECK is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SHRINKER_DEBUG is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
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
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
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
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=m
# CONFIG_RCU_SCALE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_REF_SCALE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_EXP_CPU_STALL_TIMEOUT=0
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_RETHOOK=y
CONFIG_RETHOOK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_HAVE_BUILDTIME_MCOUNT_SORT=y
CONFIG_BUILDTIME_MCOUNT_SORT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_DYNAMIC_FTRACE_WITH_ARGS=y
# CONFIG_FPROBE is not set
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_OSNOISE_TRACER is not set
# CONFIG_TIMERLAT_TRACER is not set
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_MCOUNT_USE_CC=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_FTRACE_SORT_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
# CONFIG_RV is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT=y
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT_MULTI=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
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
# CONFIG_FAULT_INJECTION_USERCOPY is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAIL_FUNCTION is not set
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAIL_SUNRPC is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_LKDTM is not set
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_DIV64 is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_TEST_REF_TRACKER is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_STRING_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_STRSCPY is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_PRINTF is not set
# CONFIG_TEST_SCANF is not set
# CONFIG_TEST_BITMAP is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_SIPHASH is not set
# CONFIG_TEST_IDA is not set
# CONFIG_TEST_LKM is not set
# CONFIG_TEST_BITOPS is not set
# CONFIG_TEST_VMALLOC is not set
# CONFIG_TEST_USER_COPY is not set
CONFIG_TEST_BPF=m
# CONFIG_TEST_BLACKHOLE_DEV is not set
# CONFIG_FIND_BIT_BENCHMARK is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_SYSCTL is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_TEST_STATIC_KEYS is not set
# CONFIG_TEST_KMOD is not set
# CONFIG_TEST_MEMCAT_P is not set
# CONFIG_TEST_LIVEPATCH is not set
# CONFIG_TEST_MEMINIT is not set
# CONFIG_TEST_HMM is not set
# CONFIG_TEST_FREE_PAGES is not set
# CONFIG_TEST_FPU is not set
# CONFIG_TEST_CLOCKSOURCE_WATCHDOG is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--DuewNRPVZxpFkKvl
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="job-script"

#!/bin/sh

export_top_env()
{
	export suite='hwsim'
	export testcase='hwsim'
	export category='functional'
	export need_memory='1G'
	export job_origin='hwsim-part1.yaml'
	export queue_cmdline_keys='branch
commit
kbuild_queue_analysis
bm_initrd_keep'
	export queue='validate'
	export testbox='lkp-ivb-d01'
	export tbox_group='lkp-ivb-d01'
	export submit_id='633440fd535fded1aab38ff0'
	export job_file='/lkp/jobs/scheduled/lkp-ivb-d01/hwsim-group-02-debian-11.1-x86_64-20220510.cgz-f6390526ee0b0408d9ed03bd8607abd2a702cb36-20220928-184746-19klnkg-5.yaml'
	export id='bb9b648edd9c49df48e49a83e8b7a18b82a2964f'
	export queuer_version='/zday/lkp'
	export model='Ivy Bridge'
	export nr_node=1
	export nr_cpu=8
	export memory='16G'
	export nr_ssd_partitions=1
	export nr_hdd_partitions=4
	export ssd_partitions='/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL42040066800RGN-part2'
	export hdd_partitions='/dev/disk/by-id/ata-WDC_WD10EACS-22D6B0_WD-WCAU45298688-part*'
	export rootfs_partition='/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL42040066800RGN-part1'
	export brand='Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz'
	export need_kconfig=\{\"WLAN\"\=\>\"y\"\}'
'\{\"PACKET\"\=\>\"y\"\}'
'\{\"CFG80211\"\=\>\"m\"\}'
'\{\"CFG80211_WEXT\"\=\>\"y\"\}'
'\{\"MAC80211\"\=\>\"m\"\}'
'\{\"MAC80211_HWSIM\"\=\>\"m\"\}'
'\{\"MAC80211_LEDS\"\=\>\"y\"\}'
'\{\"MAC80211_MESH\"\=\>\"y\"\}'
'\{\"MAC80211_DEBUGFS\"\=\>\"y\"\}'
'\{\"VETH\"\=\>\"m\"\}'
'\{\"BRIDGE\"\=\>\"m\"\}'
'\{\"MACSEC\"\=\>\"m\"\}
	export commit='f6390526ee0b0408d9ed03bd8607abd2a702cb36'
	export netconsole_port=6672
	export ucode='0x21'
	export need_kconfig_hw='{"PTP_1588_CLOCK"=>"y"}
{"IGB"=>"y"}
{"E1000E"=>"y"}
SATA_AHCI
DRM_I915'
	export bisect_dmesg=true
	export kconfig='x86_64-rhel-8.3-func'
	export enqueue_time='2022-09-28 20:41:33 +0800'
	export _id='6334411b535fded1aab38ff4'
	export _rt='/result/hwsim/group-02/lkp-ivb-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/f6390526ee0b0408d9ed03bd8607abd2a702cb36'
	export user='lkp'
	export compiler='gcc-11'
	export LKP_SERVER='internal-lkp-server'
	export head_commit='8ad71f125e82d1ebf137b03c06eb2b0ec66600bd'
	export base_commit='521a547ced6477c54b4b0cc206000406c221b4d6'
	export branch='linux-review/Sevinj-Aghayeva/net-vlan-fix-bridge-binding-behavior-and-add-selftests/20220918-041944'
	export rootfs='debian-11.1-x86_64-20220510.cgz'
	export result_root='/result/hwsim/group-02/lkp-ivb-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/f6390526ee0b0408d9ed03bd8607abd2a702cb36/1'
	export scheduler_version='/lkp/lkp/.src-20220928-170131'
	export arch='x86_64'
	export max_uptime=2100
	export initrd='/osimage/debian/debian-11.1-x86_64-20220510.cgz'
	export bootloader_append='root=/dev/ram0
RESULT_ROOT=/result/hwsim/group-02/lkp-ivb-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/f6390526ee0b0408d9ed03bd8607abd2a702cb36/1
BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-func/gcc-11/f6390526ee0b0408d9ed03bd8607abd2a702cb36/vmlinuz-6.0.0-rc4-00989-gf6390526ee0b
branch=linux-review/Sevinj-Aghayeva/net-vlan-fix-bridge-binding-behavior-and-add-selftests/20220918-041944
job=/lkp/jobs/scheduled/lkp-ivb-d01/hwsim-group-02-debian-11.1-x86_64-20220510.cgz-f6390526ee0b0408d9ed03bd8607abd2a702cb36-20220928-184746-19klnkg-5.yaml
user=lkp
ARCH=x86_64
kconfig=x86_64-rhel-8.3-func
commit=f6390526ee0b0408d9ed03bd8607abd2a702cb36
max_uptime=2100
LKP_SERVER=internal-lkp-server
nokaslr
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
	export modules_initrd='/pkg/linux/x86_64-rhel-8.3-func/gcc-11/f6390526ee0b0408d9ed03bd8607abd2a702cb36/modules.cgz'
	export bm_initrd='/osimage/deps/debian-11.1-x86_64-20220510.cgz/run-ipconfig_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/lkp_20220513.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/rsync-rootfs_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/hwsim_20220523.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/hwsim-x86_64-717e5d7-1_20220525.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/hw_20220526.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20220804.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='6.0.0-rc6-wt-ath-10044-g8ad71f125e82'
	export repeat_to=6
	export schedule_notify_address=
	export stop_repeat_if_found='dmesg.WARNING:at_net/core/dev.c:#unregister_netdevice_many'
	export kbuild_queue_analysis=1
	export bm_initrd_keep=true
	export kernel='/pkg/linux/x86_64-rhel-8.3-func/gcc-11/f6390526ee0b0408d9ed03bd8607abd2a702cb36/vmlinuz-6.0.0-rc4-00989-gf6390526ee0b'
	export dequeue_time='2022-09-28 20:44:11 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-ivb-d01/hwsim-group-02-debian-11.1-x86_64-20220510.cgz-f6390526ee0b0408d9ed03bd8607abd2a702cb36-20220928-184746-19klnkg-5.cgz'

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

	run_test test='group-02' $LKP_SRC/tests/wrapper hwsim
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	env test='group-02' $LKP_SRC/stats/wrapper hwsim
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time hwsim.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--DuewNRPVZxpFkKvl
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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
nlI92wABgc0C8e8gTSG7+7HEZ/sCAAAAAARZWg==

--DuewNRPVZxpFkKvl
Content-Type: text/plain; charset="utf-8"
Content-Disposition: attachment; filename="hwsim"
Content-Transfer-Encoding: 8bit

2022-09-28 12:45:07 export USER=root
2022-09-28 12:45:07 ./build.sh
Building TNC testing tools
Building wlantest
Building hs20-osu-client
osu_client.c: In function ‘cmd_osu_select’:
osu_client.c:2090:44: warning: ‘%s’ directive output may be truncated writing up to 985 bytes into a region of size 4 [-Wformat-truncation=]
 2090 |    snprintf(txt->lang, sizeof(txt->lang), "%s", buf + 14);
      |    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~
osu_client.c:2090:4: note: ‘snprintf’ output between 1 and 986 bytes into a destination of size 4
 2090 |    snprintf(txt->lang, sizeof(txt->lang), "%s", buf + 14);
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
osu_client.c:2103:44: warning: ‘%s’ directive output may be truncated writing up to 994 bytes into a region of size 4 [-Wformat-truncation=]
 2103 |    snprintf(txt->lang, sizeof(txt->lang), "%s", buf + 5);
      |    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
osu_client.c:2103:4: note: ‘snprintf’ output between 1 and 995 bytes into a destination of size 4
 2103 |    snprintf(txt->lang, sizeof(txt->lang), "%s", buf + 5);
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
osu_client.c:2077:10: warning: ‘%s’ directive output may be truncated writing up to 990 bytes into a region of size 256 [-Wformat-truncation=]
 2077 |         "%s", buf + 9);
      |          ^~
In file included from ../../src/utils/common.h:12,
                 from osu_client.c:16:
../../src/utils/os.h:552:21: note: ‘snprintf’ output between 1 and 991 bytes into a destination of size 256
  552 | #define os_snprintf snprintf
osu_client.c:2076:4: note: in expansion of macro ‘os_snprintf’
 2076 |    os_snprintf(last->osu_nai2, sizeof(last->osu_nai2),
      |    ^~~~~~~~~~~
osu_client.c:2071:10: warning: ‘%s’ directive output may be truncated writing up to 991 bytes into a region of size 256 [-Wformat-truncation=]
 2071 |         "%s", buf + 8);
      |          ^~
In file included from ../../src/utils/common.h:12,
                 from osu_client.c:16:
../../src/utils/os.h:552:21: note: ‘snprintf’ output between 1 and 992 bytes into a destination of size 256
  552 | #define os_snprintf snprintf
osu_client.c:2070:4: note: in expansion of macro ‘os_snprintf’
 2070 |    os_snprintf(last->osu_nai, sizeof(last->osu_nai),
      |    ^~~~~~~~~~~
osu_client.c:2065:7: warning: ‘%s’ directive output may be truncated writing up to 989 bytes into a region of size 33 [-Wformat-truncation=]
 2064 |    snprintf(last->osu_ssid2, sizeof(last->osu_ssid2),
      |    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 2065 |      "%s", buf + 10);
      |      ~^~~~~~~~~~~~~~
osu_client.c:2064:4: note: ‘snprintf’ output between 1 and 990 bytes into a destination of size 33
 2064 |    snprintf(last->osu_ssid2, sizeof(last->osu_ssid2),
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 2065 |      "%s", buf + 10);
      |      ~~~~~~~~~~~~~~~
osu_client.c:2059:7: warning: ‘%s’ directive output may be truncated writing up to 990 bytes into a region of size 33 [-Wformat-truncation=]
 2058 |    snprintf(last->osu_ssid, sizeof(last->osu_ssid),
      |    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 2059 |      "%s", buf + 9);
      |      ~^~~~~~~~~~~~~
osu_client.c:2058:4: note: ‘snprintf’ output between 1 and 991 bytes into a destination of size 33
 2058 |    snprintf(last->osu_ssid, sizeof(last->osu_ssid),
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 2059 |      "%s", buf + 9);
      |      ~~~~~~~~~~~~~~
osu_client.c:2048:44: warning: ‘%s’ directive output may be truncated writing up to 995 bytes into a region of size 256 [-Wformat-truncation=]
 2048 |    snprintf(last->url, sizeof(last->url), "%s", buf + 4);
      |    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
osu_client.c:2048:4: note: ‘snprintf’ output between 1 and 996 bytes into a destination of size 256
 2048 |    snprintf(last->url, sizeof(last->url), "%s", buf + 4);
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
osu_client.c:2040:48: warning: ‘%s’ directive output may be truncated writing up to 986 bytes into a region of size 20 [-Wformat-truncation=]
 2040 |    snprintf(last->bssid, sizeof(last->bssid), "%s",
      |    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
 2041 |      buf + 13);
      |      ~~~~~~~~~                                  
osu_client.c:2040:4: note: ‘snprintf’ output between 1 and 987 bytes into a destination of size 20
 2040 |    snprintf(last->bssid, sizeof(last->bssid), "%s",
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 2041 |      buf + 13);
      |      ~~~~~~~~~
Building hostapd
Building wpa_supplicant
2022-09-28 12:45:49 ./start.sh
2022-09-28 12:45:49 ./run-tests.py ap_anqp_sharing
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_anqp_sharing 1/1
Test: ANQP sharing within ESS and explicit unshare
Starting AP wlan3
Starting AP wlan4
Normal network selection with shared ANQP results
Explicit ANQP request to unshare ANQP results
PASS ap_anqp_sharing 0.450142 2022-09-28 12:45:51.753140
passed all 1 test case(s)
2022-09-28 12:45:51 ./run-tests.py ap_bss_add_remove
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_bss_add_remove 1/1
Test: Dynamic BSS add/remove operations with hostapd
Set up three BSSes one by one
Starting BSS phy=phy3 ifname=wlan3
Connect STA wlan1 to AP
Connect STA wlan2 to AP
Connect STA wlan0 to AP
Starting BSS phy=phy3 ifname=wlan3-2
Connect STA wlan2 to AP
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Starting BSS phy=phy3 ifname=wlan3-3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Connect STA wlan2 to AP
Remove the last BSS and re-add it
Removing BSS wlan3-3
Connect STA wlan2 to AP
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Starting BSS phy=phy3 ifname=wlan3-3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Connect STA wlan2 to AP
Remove the middle BSS and re-add it
Removing BSS wlan3-2
Connect STA wlan1 to AP
Connect STA wlan0 to AP
Connect STA wlan2 to AP
Starting BSS phy=phy3 ifname=wlan3-2
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Connect STA wlan2 to AP
Remove the first BSS and re-add it and other BSSs
Removing BSS wlan3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Connect STA wlan2 to AP
Starting BSS phy=phy3 ifname=wlan3
Starting BSS phy=phy3 ifname=wlan3-2
Starting BSS phy=phy3 ifname=wlan3-3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Connect STA wlan2 to AP
Remove two BSSes and re-add them
Removing BSS wlan3-2
Connect STA wlan1 to AP
Connect STA wlan0 to AP
Connect STA wlan2 to AP
Removing BSS wlan3-3
Connect STA wlan1 to AP
Connect STA wlan2 to AP
Connect STA wlan0 to AP
Starting BSS phy=phy3 ifname=wlan3-2
Connect STA wlan2 to AP
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Starting BSS phy=phy3 ifname=wlan3-3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Connect STA wlan2 to AP
Remove three BSSes in and re-add them
Removing BSS wlan3-3
Connect STA wlan2 to AP
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Removing BSS wlan3-2
Connect STA wlan1 to AP
Connect STA wlan2 to AP
Connect STA wlan0 to AP
Removing BSS wlan3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Connect STA wlan2 to AP
Starting BSS phy=phy3 ifname=wlan3
Connect STA wlan1 to AP
Connect STA wlan2 to AP
Connect STA wlan0 to AP
Starting BSS phy=phy3 ifname=wlan3-2
Connect STA wlan2 to AP
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Starting BSS phy=phy3 ifname=wlan3-3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Connect STA wlan2 to AP
Test error handling if a duplicate ifname is tried
Starting BSS phy=phy3 ifname=wlan3-3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Connect STA wlan2 to AP
PASS ap_bss_add_remove 8.639252 2022-09-28 12:46:00.787836
passed all 1 test case(s)
2022-09-28 12:46:00 ./run-tests.py ap_cipher_replay_protection_ap_gcmp
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_cipher_replay_protection_ap_gcmp 1/1
Test: GCMP replay protection on AP
Starting AP wlan3
Connect STA wlan0 to AP
PASS ap_cipher_replay_protection_ap_gcmp 1.643299 2022-09-28 12:46:02.827664
passed all 1 test case(s)
2022-09-28 12:46:02 ./run-tests.py ap_duplicate_bssid
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_duplicate_bssid 1/1
Test: Duplicate BSSID
Starting AP wlan3
Starting BSS phy=phy3 ifname=wlan3-2
Starting BSS phy=phy3 ifname=wlan3-3
Connect STA wlan0 to AP
PASS ap_duplicate_bssid 0.349767 2022-09-28 12:46:03.575131
passed all 1 test case(s)
2022-09-28 12:46:03 ./run-tests.py ap_ft_ap_oom4
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_ft_ap_oom4 1/1
Test: WPA2-PSK-FT and AP OOM 4
Starting AP wlan3
Connect STA wlan0 to AP
Starting AP wlan4
PASS ap_ft_ap_oom4 1.075682 2022-09-28 12:46:05.048605
passed all 1 test case(s)
2022-09-28 12:46:05 ./run-tests.py ap_ft_mismatching_rrb_key_push
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_ft_mismatching_rrb_key_push 1/1
Test: WPA2-PSK-FT AP over DS with mismatching RRB key (push)
Starting AP wlan3
Starting AP wlan4
Connect to first AP
Connect STA wlan0 to AP
Roam to the second AP
PASS ap_ft_mismatching_rrb_key_push 1.632348 2022-09-28 12:46:07.078353
passed all 1 test case(s)
2022-09-28 12:46:07 ./run-tests.py ap_ft_pmf
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_ft_pmf 1/1
Test: WPA2-PSK-FT AP with PMF
Starting AP wlan3
Starting AP wlan4
Connect to first AP
Connect STA wlan0 to AP
Roam to the second AP
Roam back to the first AP
PASS ap_ft_pmf 0.90131 2022-09-28 12:46:08.369215
passed all 1 test case(s)
2022-09-28 12:46:08 ./run-tests.py ap_ft_sae_ptk_rekey_ap_ext_key_id
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_ft_sae_ptk_rekey_ap_ext_key_id 1/1
Test: WPA2-PSK-FT-SAE AP and PTK rekey triggered by AP (Ext Key ID)
Starting AP wlan3
Starting AP wlan4
Connect to first AP
Connect STA wlan0 to AP
Roam to the second AP
PASS ap_ft_sae_ptk_rekey_ap_ext_key_id 2.794489 2022-09-28 12:46:11.552029
passed all 1 test case(s)
2022-09-28 12:46:11 ./run-tests.py ap_hs20_multiple_home_cred
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_hs20_multiple_home_cred 1/1
Test: Hotspot 2.0 and select with multiple matching home credentials
Starting AP wlan3
Starting AP wlan4
PASS ap_hs20_multiple_home_cred 0.471161 2022-09-28 12:46:12.413523
passed all 1 test case(s)
2022-09-28 12:46:12 ./run-tests.py ap_hs20_proxyarp_enable_dgaf
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_hs20_proxyarp_enable_dgaf 1/1
Test: Hotspot 2.0 and ProxyARP with DGAF enabled
Starting AP wlan3
Connect STA wlan1 to AP
After connect: ['192.168.1.123 dev ap-br0 lladdr 02:00:00:00:00:00 PERMANENT', 'aaaa:bbbb:cccc::2 dev ap-br0 lladdr 02:00:00:00:00:00 PERMANENT']
After disconnect: []
PASS ap_hs20_proxyarp_enable_dgaf 1.447711 2022-09-28 12:46:14.251805
passed all 1 test case(s)
2022-09-28 12:46:14 ./run-tests.py ap_pmf_assoc_comeback
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_pmf_assoc_comeback 1/1
Test: WPA2-PSK AP with PMF association comeback
Starting AP wlan3
Connect STA wlan0 to AP
PASS ap_pmf_assoc_comeback 1.521845 2022-09-28 12:46:16.163920
passed all 1 test case(s)
2022-09-28 12:46:16 ./run-tests.py ap_pmf_inject_auth
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_pmf_inject_auth 1/1
Test: WPA2-PSK AP with PMF and Authentication frame injection
Starting AP wlan3
Connect STA wlan0 to AP
PASS ap_pmf_inject_auth 5.777436 2022-09-28 12:46:22.333440
passed all 1 test case(s)
2022-09-28 12:46:22 ./run-tests.py ap_vlan_wpa2_radius_mixed
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_vlan_wpa2_radius_mixed 1/1
Test: AP VLAN with WPA2-Enterprise and tagged+untagged VLANs
Starting AP wlan3
Connect STA wlan0 to AP
Test connectivity in untagged VLAN 2
Test connectivity in tagged VLAN 1
dev1->dev2 unicast data delivery failed
Traceback (most recent call last):
  File "/lkp/benchmarks/hwsim/tests/hwsim/./run-tests.py", line 534, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_ap_vlan.py", line 730, in test_ap_vlan_wpa2_radius_mixed
    hwsim_utils.run_connectivity_test(dev[0], hapd, 0, ifname1=ifname,
  File "/lkp/benchmarks/hwsim/tests/hwsim/hwsim_utils.py", line 113, in run_connectivity_test
    raise Exception("dev1->dev2 unicast data delivery failed")
Exception: dev1->dev2 unicast data delivery failed
Failed to remove hostapd interface
FAIL ap_vlan_wpa2_radius_mixed 25.498377 2022-09-28 12:46:48.223286
passed 0 test case(s)
skipped 0 test case(s)
failed tests: ap_vlan_wpa2_radius_mixed
Timeout on waiting response
Failed to connect to hostapd interface
Timeout on waiting response
Terminating early due to device reset failure
2022-09-28 12:46:48 ./run-tests.py ap_vlan_wpa2_radius_required
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:46:58 ./run-tests.py ap_wpa2_eap_aka_config
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:47:09 ./run-tests.py ap_wpa2_eap_fast_gtc_identity_change
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:47:19 ./run-tests.py ap_wpa2_eap_gpsk
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:47:29 ./run-tests.py ap_wpa2_eap_pwd_salt_sha512
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:47:40 ./run-tests.py ap_wpa2_eap_tls_ocsp_unknown_sign
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:47:50 ./run-tests.py ap_wpa2_eap_ttls_eap_vendor
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:48:01 ./run-tests.py ap_wpa2_ext_add_to_bridge
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:48:11 ./run-tests.py ap_wps_frag_ack_oom
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:48:21 ./run-tests.py ap_wps_reg_config_ext_processing
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:48:32 ./run-tests.py cert_check_dnsname
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:48:42 ./run-tests.py cert_check_dnsname_wildcard
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:48:52 ./run-tests.py concurrent_grpform_while_connecting3
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:49:03 ./run-tests.py dbus_p2p_autogo_legacy
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:49:13 ./run-tests.py discovery_and_interface_disabled
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:49:24 ./run-tests.py dpp_auto_connect_legacy_psk_sae_3
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:49:34 ./run-tests.py dpp_config_connector_error_expired_5
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:49:44 ./run-tests.py dpp_listen_continue
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:49:55 ./run-tests.py dpp_network_intro_version_missing_req
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:50:05 ./run-tests.py dpp_proto_auth_resp_invalid_i_bootstrap_key
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:50:16 ./run-tests.py dpp_proto_auth_resp_invalid_r_bootstrap_key
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:50:26 ./run-tests.py dpp_proto_conf_req_invalid_e_nonce
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:50:36 ./run-tests.py dpp_proto_conf_req_no_wrapped_data
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:50:47 ./run-tests.py dpp_qr_code_auth_broadcast
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:50:57 ./run-tests.py eap_proto_leap
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:51:08 ./run-tests.py eap_proto_pwd_invalid_element_peer
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:51:18 ./run-tests.py eap_teap_eap_mschapv2_id0
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:51:28 ./run-tests.py eap_teap_eap_mschapv2_user_and_machine
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:51:39 ./run-tests.py eap_teap_tls_cs_sha384
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:51:49 ./run-tests.py ext_password_interworking
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:51:59 ./run-tests.py fils_and_ft_over_air
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:52:10 ./run-tests.py fils_sk_erp_roam_diff_akm
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:52:20 ./run-tests.py fst_ap_config_llt_zero
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:52:31 ./run-tests.py fst_ap_remove_session_established
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:52:41 ./run-tests.py fst_disconnect_non_fst_sta
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:52:51 ./run-tests.py fst_session_respond_fail
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:53:02 ./run-tests.py fst_sta_initiate_session_bad_peer_addr
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:53:12 ./run-tests.py fst_sta_start_session_no_set_params
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:53:23 ./run-tests.py gas_anqp_get_no_scan
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:53:33 ./run-tests.py gas_comeback_resp_additional_delay
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:53:43 ./run-tests.py grpform_not_ready2
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:53:54 ./run-tests.py he80_csa
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:54:04 ./run-tests.py he80b
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:54:15 ./run-tests.py ieee8021x_proto
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:54:25 ./run-tests.py macsec_psk_br2_same_prio
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:54:35 ./run-tests.py mbo_without_pmf
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:54:46 ./run-tests.py mesh_link_probe
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:54:56 ./run-tests.py multi_ap_wps_split
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:55:07 ./run-tests.py nfc_wps_handover_errors
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:55:17 ./run-tests.py olbc
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:55:27 ./run-tests.py owe_limited_group_set_pmf
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:55:38 ./run-tests.py owe_transition_mode_mismatch2
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:55:48 ./run-tests.py p2ps_stale_group_removal2
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:55:58 ./run-tests.py proxyarp_errors
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:56:09 ./run-tests.py rrm_beacon_req_table
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:56:19 ./run-tests.py rrm_neighbor_rep_req_not_supported
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:56:30 ./run-tests.py rrm_rep_parse_proto
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:56:40 ./run-tests.py sae_proto_hostapd_ffc
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:56:50 ./run-tests.py sae_pwe_group_14
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:57:01 ./run-tests.py scan
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:57:11 ./run-tests.py scan_multi_bssid
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:57:22 ./run-tests.py sigma_dut_ap_sae
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:57:32 ./run-tests.py sigma_dut_dpp_tcp_configurator_init_mutual
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:57:42 ./run-tests.py sigma_dut_preconfigured_profile
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:57:53 ./run-tests.py sigma_dut_psk_pmf_bip_gmac_256_mismatch
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:58:03 ./run-tests.py sigma_dut_sae_h2e_ap_h2e
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:58:14 ./run-tests.py sigma_dut_sae_pw_id_pwe_loop
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:58:24 ./run-tests.py sta_dynamic_random_mac_addr_keep_oui
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:58:34 ./run-tests.py tnc_peap_soh
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:58:45 ./run-tests.py wnm_bss_transition_mgmt
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:58:55 ./run-tests.py wpa2_ocv_ap_override_fils_assoc
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:59:06 ./run-tests.py wps_ext_m3_missing_e_hash1
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:59:16 ./run-tests.py wps_ext_proto_ack_m3_r_nonce_mismatch
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:59:26 ./run-tests.py wps_ext_proto_m2_no_public_key
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:59:37 ./run-tests.py wps_ext_proto_m4_invalid_pad_string
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
Failed to remove hostapd interface
Timeout on waiting response
2022-09-28 12:59:47 ./stop.sh
Waiting for ctrl_iface /var/run/hostapd-global to disappear
Control interface file /var/run/hostapd-global exists - remove it

--DuewNRPVZxpFkKvl
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="job.yaml"

---

#! jobs/hwsim-part1.yaml
suite: hwsim
testcase: hwsim
category: functional
need_memory: 1G
hwsim:
  test: group-02
job_origin: hwsim-part1.yaml

#! queue options
queue_cmdline_keys:
- branch
- commit
queue: bisect
testbox: lkp-ivb-d01
tbox_group: lkp-ivb-d01
submit_id: 63342b88535fdecbeb0ec4f4
job_file: "/lkp/jobs/scheduled/lkp-ivb-d01/hwsim-group-02-debian-11.1-x86_64-20220510.cgz-f6390526ee0b0408d9ed03bd8607abd2a702cb36-20220928-183275-nbikwr-0.yaml"
id: 3e4b0176e7cab21bc15e0fb1a7e261c37b54308d
queuer_version: "/zday/lkp"

#! hosts/lkp-ivb-d01
model: Ivy Bridge
nr_node: 1
nr_cpu: 8
memory: 16G
nr_ssd_partitions: 1
nr_hdd_partitions: 4
ssd_partitions: "/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL42040066800RGN-part2"
hdd_partitions: "/dev/disk/by-id/ata-WDC_WD10EACS-22D6B0_WD-WCAU45298688-part*"
rootfs_partition: "/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL42040066800RGN-part1"
brand: Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz

#! include/category/functional
kmsg:
heartbeat:
meminfo:

#! include/hwsim
need_kconfig:
- WLAN: y
- PACKET: y
- CFG80211: m
- CFG80211_WEXT: y
- MAC80211: m
- MAC80211_HWSIM: m
- MAC80211_LEDS: y
- MAC80211_MESH: y
- MAC80211_DEBUGFS: y
- VETH: m
- BRIDGE: m
- MACSEC: m

#! include/queue/cyclic
commit: f6390526ee0b0408d9ed03bd8607abd2a702cb36

#! include/testbox/lkp-ivb-d01
netconsole_port: 6672
ucode: '0x21'
need_kconfig_hw:
- PTP_1588_CLOCK: y
- IGB: y
- E1000E: y
- SATA_AHCI
- DRM_I915
bisect_dmesg: true
kconfig: x86_64-rhel-8.3-func
enqueue_time: 2022-09-28 19:10:00.987331188 +08:00
_id: 63342b88535fdecbeb0ec4f4
_rt: "/result/hwsim/group-02/lkp-ivb-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/f6390526ee0b0408d9ed03bd8607abd2a702cb36"

#! schedule options
user: lkp
compiler: gcc-11
LKP_SERVER: internal-lkp-server
head_commit: 8ad71f125e82d1ebf137b03c06eb2b0ec66600bd
base_commit: 521a547ced6477c54b4b0cc206000406c221b4d6
branch: linux-devel/devel-hourly-20220921-191402
rootfs: debian-11.1-x86_64-20220510.cgz
result_root: "/result/hwsim/group-02/lkp-ivb-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/f6390526ee0b0408d9ed03bd8607abd2a702cb36/0"
scheduler_version: "/lkp/lkp/.src-20220928-170131"
arch: x86_64
max_uptime: 2100
initrd: "/osimage/debian/debian-11.1-x86_64-20220510.cgz"
bootloader_append:
- root=/dev/ram0
- RESULT_ROOT=/result/hwsim/group-02/lkp-ivb-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/f6390526ee0b0408d9ed03bd8607abd2a702cb36/0
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-func/gcc-11/f6390526ee0b0408d9ed03bd8607abd2a702cb36/vmlinuz-6.0.0-rc4-00989-gf6390526ee0b
- branch=linux-devel/devel-hourly-20220921-191402
- job=/lkp/jobs/scheduled/lkp-ivb-d01/hwsim-group-02-debian-11.1-x86_64-20220510.cgz-f6390526ee0b0408d9ed03bd8607abd2a702cb36-20220928-183275-nbikwr-0.yaml
- user=lkp
- ARCH=x86_64
- kconfig=x86_64-rhel-8.3-func
- commit=f6390526ee0b0408d9ed03bd8607abd2a702cb36
- max_uptime=2100
- LKP_SERVER=internal-lkp-server
- nokaslr
- selinux=0
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- drbd.minor_count=8
- systemd.log_level=err
- ignore_loglevel
- console=tty0
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- vga=normal
- rw
modules_initrd: "/pkg/linux/x86_64-rhel-8.3-func/gcc-11/f6390526ee0b0408d9ed03bd8607abd2a702cb36/modules.cgz"
bm_initrd: "/osimage/deps/debian-11.1-x86_64-20220510.cgz/run-ipconfig_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/lkp_20220513.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/rsync-rootfs_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/hwsim_20220523.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/hwsim-x86_64-717e5d7-1_20220525.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/hw_20220526.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20220804.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn

#! /cephfs/db/releases/20220921152839/lkp-src/include/site/inn
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer:
watchdog:

#! runtime status
last_kernel: 6.0.0-rc7-wt-ath-07387-gd1ae6e59ae4b
schedule_notify_address:

#! user overrides
kernel: "/pkg/linux/x86_64-rhel-8.3-func/gcc-11/f6390526ee0b0408d9ed03bd8607abd2a702cb36/vmlinuz-6.0.0-rc4-00989-gf6390526ee0b"
dequeue_time: 2022-09-28 19:50:21.359969050 +08:00

#! /cephfs/db/releases/20220928145816/lkp-src/include/site/inn
job_state: soft_timeout
loadavg: 2.00 2.00 1.75 1/177 13997
start_time: '1664365878'
end_time: '1664368037'
version: "/lkp/lkp/.src-20220928-170222:bb654a6c7:c8f74508d"

--DuewNRPVZxpFkKvl
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="reproduce"

export USER=root
./build.sh
./start.sh
./run-tests.py ap_anqp_sharing
./run-tests.py ap_bss_add_remove
./run-tests.py ap_cipher_replay_protection_ap_gcmp
./run-tests.py ap_duplicate_bssid
./run-tests.py ap_ft_ap_oom4
./run-tests.py ap_ft_mismatching_rrb_key_push
./run-tests.py ap_ft_pmf
./run-tests.py ap_ft_sae_ptk_rekey_ap_ext_key_id
./run-tests.py ap_hs20_multiple_home_cred
./run-tests.py ap_hs20_proxyarp_enable_dgaf
./run-tests.py ap_pmf_assoc_comeback
./run-tests.py ap_pmf_inject_auth
./run-tests.py ap_vlan_wpa2_radius_mixed
./run-tests.py ap_vlan_wpa2_radius_required
./run-tests.py ap_wpa2_eap_aka_config
./run-tests.py ap_wpa2_eap_fast_gtc_identity_change
./run-tests.py ap_wpa2_eap_gpsk
./run-tests.py ap_wpa2_eap_pwd_salt_sha512
./run-tests.py ap_wpa2_eap_tls_ocsp_unknown_sign
./run-tests.py ap_wpa2_eap_ttls_eap_vendor
./run-tests.py ap_wpa2_ext_add_to_bridge
./run-tests.py ap_wps_frag_ack_oom
./run-tests.py ap_wps_reg_config_ext_processing
./run-tests.py cert_check_dnsname
./run-tests.py cert_check_dnsname_wildcard
./run-tests.py concurrent_grpform_while_connecting3
./run-tests.py dbus_p2p_autogo_legacy
./run-tests.py discovery_and_interface_disabled
./run-tests.py dpp_auto_connect_legacy_psk_sae_3
./run-tests.py dpp_config_connector_error_expired_5
./run-tests.py dpp_listen_continue
./run-tests.py dpp_network_intro_version_missing_req
./run-tests.py dpp_proto_auth_resp_invalid_i_bootstrap_key
./run-tests.py dpp_proto_auth_resp_invalid_r_bootstrap_key
./run-tests.py dpp_proto_conf_req_invalid_e_nonce
./run-tests.py dpp_proto_conf_req_no_wrapped_data
./run-tests.py dpp_qr_code_auth_broadcast
./run-tests.py eap_proto_leap
./run-tests.py eap_proto_pwd_invalid_element_peer
./run-tests.py eap_teap_eap_mschapv2_id0
./run-tests.py eap_teap_eap_mschapv2_user_and_machine
./run-tests.py eap_teap_tls_cs_sha384
./run-tests.py ext_password_interworking
./run-tests.py fils_and_ft_over_air
./run-tests.py fils_sk_erp_roam_diff_akm
./run-tests.py fst_ap_config_llt_zero
./run-tests.py fst_ap_remove_session_established
./run-tests.py fst_disconnect_non_fst_sta
./run-tests.py fst_session_respond_fail
./run-tests.py fst_sta_initiate_session_bad_peer_addr
./run-tests.py fst_sta_start_session_no_set_params
./run-tests.py gas_anqp_get_no_scan
./run-tests.py gas_comeback_resp_additional_delay
./run-tests.py grpform_not_ready2
./run-tests.py he80_csa
./run-tests.py he80b
./run-tests.py ieee8021x_proto
./run-tests.py macsec_psk_br2_same_prio
./run-tests.py mbo_without_pmf
./run-tests.py mesh_link_probe
./run-tests.py multi_ap_wps_split
./run-tests.py nfc_wps_handover_errors
./run-tests.py olbc
./run-tests.py owe_limited_group_set_pmf
./run-tests.py owe_transition_mode_mismatch2
./run-tests.py p2ps_stale_group_removal2
./run-tests.py proxyarp_errors
./run-tests.py rrm_beacon_req_table
./run-tests.py rrm_neighbor_rep_req_not_supported
./run-tests.py rrm_rep_parse_proto
./run-tests.py sae_proto_hostapd_ffc
./run-tests.py sae_pwe_group_14
./run-tests.py scan
./run-tests.py scan_multi_bssid
./run-tests.py sigma_dut_ap_sae
./run-tests.py sigma_dut_dpp_tcp_configurator_init_mutual
./run-tests.py sigma_dut_preconfigured_profile
./run-tests.py sigma_dut_psk_pmf_bip_gmac_256_mismatch
./run-tests.py sigma_dut_sae_h2e_ap_h2e
./run-tests.py sigma_dut_sae_pw_id_pwe_loop
./run-tests.py sta_dynamic_random_mac_addr_keep_oui
./run-tests.py tnc_peap_soh
./run-tests.py wnm_bss_transition_mgmt
./run-tests.py wpa2_ocv_ap_override_fils_assoc
./run-tests.py wps_ext_m3_missing_e_hash1
./run-tests.py wps_ext_proto_ack_m3_r_nonce_mismatch
./run-tests.py wps_ext_proto_m2_no_public_key
./run-tests.py wps_ext_proto_m4_invalid_pad_string
./stop.sh

--DuewNRPVZxpFkKvl--
