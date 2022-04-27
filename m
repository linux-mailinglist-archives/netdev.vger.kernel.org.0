Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC98A510E40
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 03:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345671AbiD0Br3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 21:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236081AbiD0Br2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 21:47:28 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA784A3C0
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 18:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651023859; x=1682559859;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=54WT4Iuec/sTvXejFoy/OrZ4WMe4xTvx7Y6LH7ztoVk=;
  b=BhVYWCTRgxEV24/UqVjcn+jZ7wkl5fWrwf3LopHP17Om2XXkCfngBg+b
   phApjH9Cq4RlTt8AveP51t+x6yAhxzbo1FroDdYtV4AVXqrQNTBlNA8mj
   tJFT+QdfftTzjGIxke/SQSxWoFDTQiCe37RO1bGVVcstmxNMEhf6j2V3J
   V4fwtGzb7tZQwMwuUzMa+cue/bBGtpdgLBgM3KYxZwMKpWMY0AOpbvp3h
   RxNjGiF0GJLa+MZajlKQPFgB+IyS08O4JRqJvXzAQReHaXaUuDsaV9NrE
   niHGkmpuxUOi4kqMXxr0adwFb6ehWHE2bf8l+0NXQOJkRj0YjHNZkh6LX
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="247709916"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="247709916"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 18:44:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="679611587"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 26 Apr 2022 18:44:17 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njWj2-0004Bk-Pr;
        Wed, 27 Apr 2022 01:44:16 +0000
Date:   Wed, 27 Apr 2022 09:43:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Erin MacNeil <lnx.erin@gmail.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Erin MacNeil <lnx.erin@gmail.com>
Subject: Re: [PATCH net-next] net: Add SO_RCVMARK socket option to provide
 SO_MARK with recvmsg().
Message-ID: <202204270907.nUUrw3dS-lkp@intel.com>
References: <20220426173805.2652-1-lnx.erin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426173805.2652-1-lnx.erin@gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Erin,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Erin-MacNeil/net-Add-SO_RCVMARK-socket-option-to-provide-SO_MARK-with-recvmsg/20220427-014257
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 561215482cc69d1c758944d4463b3d5d96d37bd1
config: alpha-defconfig (https://download.01.org/0day-ci/archive/20220427/202204270907.nUUrw3dS-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ba0c57c49e3f18b23fe626dd2e603cf4ed91ebf7
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Erin-MacNeil/net-Add-SO_RCVMARK-socket-option-to-provide-SO_MARK-with-recvmsg/20220427-014257
        git checkout ba0c57c49e3f18b23fe626dd2e603cf4ed91ebf7
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/core/sock.c: In function 'sock_setsockopt':
>> net/core/sock.c:1314:14: error: 'SO_RCVMARK' undeclared (first use in this function); did you mean 'SOCK_RCVMARK'?
    1314 |         case SO_RCVMARK:
         |              ^~~~~~~~~~
         |              SOCK_RCVMARK
   net/core/sock.c:1314:14: note: each undeclared identifier is reported only once for each function it appears in
   net/core/sock.c: In function 'sock_getsockopt':
   net/core/sock.c:1743:14: error: 'SO_RCVMARK' undeclared (first use in this function); did you mean 'SOCK_RCVMARK'?
    1743 |         case SO_RCVMARK:
         |              ^~~~~~~~~~
         |              SOCK_RCVMARK


vim +1314 net/core/sock.c

  1031	
  1032	/*
  1033	 *	This is meant for all protocols to use and covers goings on
  1034	 *	at the socket level. Everything here is generic.
  1035	 */
  1036	
  1037	int sock_setsockopt(struct socket *sock, int level, int optname,
  1038			    sockptr_t optval, unsigned int optlen)
  1039	{
  1040		struct so_timestamping timestamping;
  1041		struct sock_txtime sk_txtime;
  1042		struct sock *sk = sock->sk;
  1043		int val;
  1044		int valbool;
  1045		struct linger ling;
  1046		int ret = 0;
  1047	
  1048		/*
  1049		 *	Options without arguments
  1050		 */
  1051	
  1052		if (optname == SO_BINDTODEVICE)
  1053			return sock_setbindtodevice(sk, optval, optlen);
  1054	
  1055		if (optlen < sizeof(int))
  1056			return -EINVAL;
  1057	
  1058		if (copy_from_sockptr(&val, optval, sizeof(val)))
  1059			return -EFAULT;
  1060	
  1061		valbool = val ? 1 : 0;
  1062	
  1063		lock_sock(sk);
  1064	
  1065		switch (optname) {
  1066		case SO_DEBUG:
  1067			if (val && !capable(CAP_NET_ADMIN))
  1068				ret = -EACCES;
  1069			else
  1070				sock_valbool_flag(sk, SOCK_DBG, valbool);
  1071			break;
  1072		case SO_REUSEADDR:
  1073			sk->sk_reuse = (valbool ? SK_CAN_REUSE : SK_NO_REUSE);
  1074			break;
  1075		case SO_REUSEPORT:
  1076			sk->sk_reuseport = valbool;
  1077			break;
  1078		case SO_TYPE:
  1079		case SO_PROTOCOL:
  1080		case SO_DOMAIN:
  1081		case SO_ERROR:
  1082			ret = -ENOPROTOOPT;
  1083			break;
  1084		case SO_DONTROUTE:
  1085			sock_valbool_flag(sk, SOCK_LOCALROUTE, valbool);
  1086			sk_dst_reset(sk);
  1087			break;
  1088		case SO_BROADCAST:
  1089			sock_valbool_flag(sk, SOCK_BROADCAST, valbool);
  1090			break;
  1091		case SO_SNDBUF:
  1092			/* Don't error on this BSD doesn't and if you think
  1093			 * about it this is right. Otherwise apps have to
  1094			 * play 'guess the biggest size' games. RCVBUF/SNDBUF
  1095			 * are treated in BSD as hints
  1096			 */
  1097			val = min_t(u32, val, sysctl_wmem_max);
  1098	set_sndbuf:
  1099			/* Ensure val * 2 fits into an int, to prevent max_t()
  1100			 * from treating it as a negative value.
  1101			 */
  1102			val = min_t(int, val, INT_MAX / 2);
  1103			sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
  1104			WRITE_ONCE(sk->sk_sndbuf,
  1105				   max_t(int, val * 2, SOCK_MIN_SNDBUF));
  1106			/* Wake up sending tasks if we upped the value. */
  1107			sk->sk_write_space(sk);
  1108			break;
  1109	
  1110		case SO_SNDBUFFORCE:
  1111			if (!capable(CAP_NET_ADMIN)) {
  1112				ret = -EPERM;
  1113				break;
  1114			}
  1115	
  1116			/* No negative values (to prevent underflow, as val will be
  1117			 * multiplied by 2).
  1118			 */
  1119			if (val < 0)
  1120				val = 0;
  1121			goto set_sndbuf;
  1122	
  1123		case SO_RCVBUF:
  1124			/* Don't error on this BSD doesn't and if you think
  1125			 * about it this is right. Otherwise apps have to
  1126			 * play 'guess the biggest size' games. RCVBUF/SNDBUF
  1127			 * are treated in BSD as hints
  1128			 */
  1129			__sock_set_rcvbuf(sk, min_t(u32, val, sysctl_rmem_max));
  1130			break;
  1131	
  1132		case SO_RCVBUFFORCE:
  1133			if (!capable(CAP_NET_ADMIN)) {
  1134				ret = -EPERM;
  1135				break;
  1136			}
  1137	
  1138			/* No negative values (to prevent underflow, as val will be
  1139			 * multiplied by 2).
  1140			 */
  1141			__sock_set_rcvbuf(sk, max(val, 0));
  1142			break;
  1143	
  1144		case SO_KEEPALIVE:
  1145			if (sk->sk_prot->keepalive)
  1146				sk->sk_prot->keepalive(sk, valbool);
  1147			sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
  1148			break;
  1149	
  1150		case SO_OOBINLINE:
  1151			sock_valbool_flag(sk, SOCK_URGINLINE, valbool);
  1152			break;
  1153	
  1154		case SO_NO_CHECK:
  1155			sk->sk_no_check_tx = valbool;
  1156			break;
  1157	
  1158		case SO_PRIORITY:
  1159			if ((val >= 0 && val <= 6) ||
  1160			    ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) ||
  1161			    ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
  1162				sk->sk_priority = val;
  1163			else
  1164				ret = -EPERM;
  1165			break;
  1166	
  1167		case SO_LINGER:
  1168			if (optlen < sizeof(ling)) {
  1169				ret = -EINVAL;	/* 1003.1g */
  1170				break;
  1171			}
  1172			if (copy_from_sockptr(&ling, optval, sizeof(ling))) {
  1173				ret = -EFAULT;
  1174				break;
  1175			}
  1176			if (!ling.l_onoff)
  1177				sock_reset_flag(sk, SOCK_LINGER);
  1178			else {
  1179	#if (BITS_PER_LONG == 32)
  1180				if ((unsigned int)ling.l_linger >= MAX_SCHEDULE_TIMEOUT/HZ)
  1181					sk->sk_lingertime = MAX_SCHEDULE_TIMEOUT;
  1182				else
  1183	#endif
  1184					sk->sk_lingertime = (unsigned int)ling.l_linger * HZ;
  1185				sock_set_flag(sk, SOCK_LINGER);
  1186			}
  1187			break;
  1188	
  1189		case SO_BSDCOMPAT:
  1190			break;
  1191	
  1192		case SO_PASSCRED:
  1193			if (valbool)
  1194				set_bit(SOCK_PASSCRED, &sock->flags);
  1195			else
  1196				clear_bit(SOCK_PASSCRED, &sock->flags);
  1197			break;
  1198	
  1199		case SO_TIMESTAMP_OLD:
  1200		case SO_TIMESTAMP_NEW:
  1201		case SO_TIMESTAMPNS_OLD:
  1202		case SO_TIMESTAMPNS_NEW:
  1203			sock_set_timestamp(sk, optname, valbool);
  1204			break;
  1205	
  1206		case SO_TIMESTAMPING_NEW:
  1207		case SO_TIMESTAMPING_OLD:
  1208			if (optlen == sizeof(timestamping)) {
  1209				if (copy_from_sockptr(&timestamping, optval,
  1210						      sizeof(timestamping))) {
  1211					ret = -EFAULT;
  1212					break;
  1213				}
  1214			} else {
  1215				memset(&timestamping, 0, sizeof(timestamping));
  1216				timestamping.flags = val;
  1217			}
  1218			ret = sock_set_timestamping(sk, optname, timestamping);
  1219			break;
  1220	
  1221		case SO_RCVLOWAT:
  1222			if (val < 0)
  1223				val = INT_MAX;
  1224			if (sock->ops->set_rcvlowat)
  1225				ret = sock->ops->set_rcvlowat(sk, val);
  1226			else
  1227				WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
  1228			break;
  1229	
  1230		case SO_RCVTIMEO_OLD:
  1231		case SO_RCVTIMEO_NEW:
  1232			ret = sock_set_timeout(&sk->sk_rcvtimeo, optval,
  1233					       optlen, optname == SO_RCVTIMEO_OLD);
  1234			break;
  1235	
  1236		case SO_SNDTIMEO_OLD:
  1237		case SO_SNDTIMEO_NEW:
  1238			ret = sock_set_timeout(&sk->sk_sndtimeo, optval,
  1239					       optlen, optname == SO_SNDTIMEO_OLD);
  1240			break;
  1241	
  1242		case SO_ATTACH_FILTER: {
  1243			struct sock_fprog fprog;
  1244	
  1245			ret = copy_bpf_fprog_from_user(&fprog, optval, optlen);
  1246			if (!ret)
  1247				ret = sk_attach_filter(&fprog, sk);
  1248			break;
  1249		}
  1250		case SO_ATTACH_BPF:
  1251			ret = -EINVAL;
  1252			if (optlen == sizeof(u32)) {
  1253				u32 ufd;
  1254	
  1255				ret = -EFAULT;
  1256				if (copy_from_sockptr(&ufd, optval, sizeof(ufd)))
  1257					break;
  1258	
  1259				ret = sk_attach_bpf(ufd, sk);
  1260			}
  1261			break;
  1262	
  1263		case SO_ATTACH_REUSEPORT_CBPF: {
  1264			struct sock_fprog fprog;
  1265	
  1266			ret = copy_bpf_fprog_from_user(&fprog, optval, optlen);
  1267			if (!ret)
  1268				ret = sk_reuseport_attach_filter(&fprog, sk);
  1269			break;
  1270		}
  1271		case SO_ATTACH_REUSEPORT_EBPF:
  1272			ret = -EINVAL;
  1273			if (optlen == sizeof(u32)) {
  1274				u32 ufd;
  1275	
  1276				ret = -EFAULT;
  1277				if (copy_from_sockptr(&ufd, optval, sizeof(ufd)))
  1278					break;
  1279	
  1280				ret = sk_reuseport_attach_bpf(ufd, sk);
  1281			}
  1282			break;
  1283	
  1284		case SO_DETACH_REUSEPORT_BPF:
  1285			ret = reuseport_detach_prog(sk);
  1286			break;
  1287	
  1288		case SO_DETACH_FILTER:
  1289			ret = sk_detach_filter(sk);
  1290			break;
  1291	
  1292		case SO_LOCK_FILTER:
  1293			if (sock_flag(sk, SOCK_FILTER_LOCKED) && !valbool)
  1294				ret = -EPERM;
  1295			else
  1296				sock_valbool_flag(sk, SOCK_FILTER_LOCKED, valbool);
  1297			break;
  1298	
  1299		case SO_PASSSEC:
  1300			if (valbool)
  1301				set_bit(SOCK_PASSSEC, &sock->flags);
  1302			else
  1303				clear_bit(SOCK_PASSSEC, &sock->flags);
  1304			break;
  1305		case SO_MARK:
  1306			if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
  1307			    !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
  1308				ret = -EPERM;
  1309				break;
  1310			}
  1311	
  1312			__sock_set_mark(sk, val);
  1313			break;
> 1314		case SO_RCVMARK:
  1315			sock_valbool_flag(sk, SOCK_RCVMARK, valbool);
  1316			break;
  1317	
  1318		case SO_RXQ_OVFL:
  1319			sock_valbool_flag(sk, SOCK_RXQ_OVFL, valbool);
  1320			break;
  1321	
  1322		case SO_WIFI_STATUS:
  1323			sock_valbool_flag(sk, SOCK_WIFI_STATUS, valbool);
  1324			break;
  1325	
  1326		case SO_PEEK_OFF:
  1327			if (sock->ops->set_peek_off)
  1328				ret = sock->ops->set_peek_off(sk, val);
  1329			else
  1330				ret = -EOPNOTSUPP;
  1331			break;
  1332	
  1333		case SO_NOFCS:
  1334			sock_valbool_flag(sk, SOCK_NOFCS, valbool);
  1335			break;
  1336	
  1337		case SO_SELECT_ERR_QUEUE:
  1338			sock_valbool_flag(sk, SOCK_SELECT_ERR_QUEUE, valbool);
  1339			break;
  1340	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
