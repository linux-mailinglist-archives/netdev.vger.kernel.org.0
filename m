Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F9F6A55F3
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 10:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjB1Jhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 04:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjB1Jhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 04:37:33 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F922A6D6;
        Tue, 28 Feb 2023 01:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677577051; x=1709113051;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xjjLkwPdC4Qnu2rsgdsvGKcGVndM1jwKd4HVYu7Q/Rg=;
  b=bmHg8sPcaFuQc7//0yp1lD/dcV+0/TDMtoW2I4Bs0Xs0A8/rbLvm6Wqd
   3OJvZW/NWqn5P3gtG3CouOzI89Tw3C3xDNQyNqyyIsblydYiDbWCxtiFo
   eJmY6yK1RkHSeAAeXe+4vcQeAm3PsiElYLVmvjy/G4Zc7UrBpOYjLNcc/
   Nl5oaZxNzmSUTBSj9Pe+S4/W1VC/RuYt4Nx29ukJBJtCERDcbprpYAqxM
   lm89qwn7EdvSY7L6bbB3VI5BO9yxUVapGJdMFmcrcu3TwwXa5zXdlKAOq
   XXkxQd9voLAmsJq8yomDQ6SWlIopP5avkn+j163RFhjrtSEgK0Q701A+6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="336383336"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="336383336"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 01:37:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="667388941"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="667388941"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 28 Feb 2023 01:37:27 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pWwQI-0005Ha-2I;
        Tue, 28 Feb 2023 09:37:26 +0000
Date:   Tue, 28 Feb 2023 17:37:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Daniel Xu <dxu@dxuuu.xyz>, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, dsahern@kernel.org, pabeni@redhat.com
Cc:     oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 5/8] bpf: net: ipv6: Add bpf_ipv6_frag_rcv()
 kfunc
Message-ID: <202302281707.5vUL3boJ-lkp@intel.com>
References: <bce083a4293eefb048a700b5a6086e8d8c957700.1677526810.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bce083a4293eefb048a700b5a6086e8d8c957700.1677526810.git.dxu@dxuuu.xyz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Daniel-Xu/ip-frags-Return-actual-error-codes-from-ip_check_defrag/20230228-035449
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/bce083a4293eefb048a700b5a6086e8d8c957700.1677526810.git.dxu%40dxuuu.xyz
patch subject: [PATCH bpf-next v2 5/8] bpf: net: ipv6: Add bpf_ipv6_frag_rcv() kfunc
config: i386-debian-10.3 (https://download.01.org/0day-ci/archive/20230228/202302281707.5vUL3boJ-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/be4610312351d4a658435bd4649a3a830322396d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Daniel-Xu/ip-frags-Return-actual-error-codes-from-ip_check_defrag/20230228-035449
        git checkout be4610312351d4a658435bd4649a3a830322396d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302281707.5vUL3boJ-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: net/ipv6/af_inet6.o: in function `inet6_init':
>> net/ipv6/af_inet6.c:1177: undefined reference to `register_ipv6_reassembly_bpf'


vim +1177 net/ipv6/af_inet6.c

  1061	
  1062	static int __init inet6_init(void)
  1063	{
  1064		struct list_head *r;
  1065		int err = 0;
  1066	
  1067		sock_skb_cb_check_size(sizeof(struct inet6_skb_parm));
  1068	
  1069		/* Register the socket-side information for inet6_create.  */
  1070		for (r = &inetsw6[0]; r < &inetsw6[SOCK_MAX]; ++r)
  1071			INIT_LIST_HEAD(r);
  1072	
  1073		raw_hashinfo_init(&raw_v6_hashinfo);
  1074	
  1075		if (disable_ipv6_mod) {
  1076			pr_info("Loaded, but administratively disabled, reboot required to enable\n");
  1077			goto out;
  1078		}
  1079	
  1080		err = proto_register(&tcpv6_prot, 1);
  1081		if (err)
  1082			goto out;
  1083	
  1084		err = proto_register(&udpv6_prot, 1);
  1085		if (err)
  1086			goto out_unregister_tcp_proto;
  1087	
  1088		err = proto_register(&udplitev6_prot, 1);
  1089		if (err)
  1090			goto out_unregister_udp_proto;
  1091	
  1092		err = proto_register(&rawv6_prot, 1);
  1093		if (err)
  1094			goto out_unregister_udplite_proto;
  1095	
  1096		err = proto_register(&pingv6_prot, 1);
  1097		if (err)
  1098			goto out_unregister_raw_proto;
  1099	
  1100		/* We MUST register RAW sockets before we create the ICMP6,
  1101		 * IGMP6, or NDISC control sockets.
  1102		 */
  1103		err = rawv6_init();
  1104		if (err)
  1105			goto out_unregister_ping_proto;
  1106	
  1107		/* Register the family here so that the init calls below will
  1108		 * be able to create sockets. (?? is this dangerous ??)
  1109		 */
  1110		err = sock_register(&inet6_family_ops);
  1111		if (err)
  1112			goto out_sock_register_fail;
  1113	
  1114		/*
  1115		 *	ipngwg API draft makes clear that the correct semantics
  1116		 *	for TCP and UDP is to consider one TCP and UDP instance
  1117		 *	in a host available by both INET and INET6 APIs and
  1118		 *	able to communicate via both network protocols.
  1119		 */
  1120	
  1121		err = register_pernet_subsys(&inet6_net_ops);
  1122		if (err)
  1123			goto register_pernet_fail;
  1124		err = ip6_mr_init();
  1125		if (err)
  1126			goto ipmr_fail;
  1127		err = icmpv6_init();
  1128		if (err)
  1129			goto icmp_fail;
  1130		err = ndisc_init();
  1131		if (err)
  1132			goto ndisc_fail;
  1133		err = igmp6_init();
  1134		if (err)
  1135			goto igmp_fail;
  1136	
  1137		err = ipv6_netfilter_init();
  1138		if (err)
  1139			goto netfilter_fail;
  1140		/* Create /proc/foo6 entries. */
  1141	#ifdef CONFIG_PROC_FS
  1142		err = -ENOMEM;
  1143		if (raw6_proc_init())
  1144			goto proc_raw6_fail;
  1145		if (udplite6_proc_init())
  1146			goto proc_udplite6_fail;
  1147		if (ipv6_misc_proc_init())
  1148			goto proc_misc6_fail;
  1149		if (if6_proc_init())
  1150			goto proc_if6_fail;
  1151	#endif
  1152		err = ip6_route_init();
  1153		if (err)
  1154			goto ip6_route_fail;
  1155		err = ndisc_late_init();
  1156		if (err)
  1157			goto ndisc_late_fail;
  1158		err = ip6_flowlabel_init();
  1159		if (err)
  1160			goto ip6_flowlabel_fail;
  1161		err = ipv6_anycast_init();
  1162		if (err)
  1163			goto ipv6_anycast_fail;
  1164		err = addrconf_init();
  1165		if (err)
  1166			goto addrconf_fail;
  1167	
  1168		/* Init v6 extension headers. */
  1169		err = ipv6_exthdrs_init();
  1170		if (err)
  1171			goto ipv6_exthdrs_fail;
  1172	
  1173		err = ipv6_frag_init();
  1174		if (err)
  1175			goto ipv6_frag_fail;
  1176	
> 1177		err = register_ipv6_reassembly_bpf();
  1178		if (err)
  1179			goto ipv6_frag_fail;
  1180	
  1181		/* Init v6 transport protocols. */
  1182		err = udpv6_init();
  1183		if (err)
  1184			goto udpv6_fail;
  1185	
  1186		err = udplitev6_init();
  1187		if (err)
  1188			goto udplitev6_fail;
  1189	
  1190		err = udpv6_offload_init();
  1191		if (err)
  1192			goto udpv6_offload_fail;
  1193	
  1194		err = tcpv6_init();
  1195		if (err)
  1196			goto tcpv6_fail;
  1197	
  1198		err = ipv6_packet_init();
  1199		if (err)
  1200			goto ipv6_packet_fail;
  1201	
  1202		err = pingv6_init();
  1203		if (err)
  1204			goto pingv6_fail;
  1205	
  1206		err = calipso_init();
  1207		if (err)
  1208			goto calipso_fail;
  1209	
  1210		err = seg6_init();
  1211		if (err)
  1212			goto seg6_fail;
  1213	
  1214		err = rpl_init();
  1215		if (err)
  1216			goto rpl_fail;
  1217	
  1218		err = ioam6_init();
  1219		if (err)
  1220			goto ioam6_fail;
  1221	
  1222		err = igmp6_late_init();
  1223		if (err)
  1224			goto igmp6_late_err;
  1225	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
