Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5585E41E61A
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 04:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351704AbhJACyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 22:54:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:44265 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230346AbhJACyO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 22:54:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="223445920"
X-IronPort-AV: E=Sophos;i="5.85,337,1624345200"; 
   d="gz'50?scan'50,208,50";a="223445920"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 19:52:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,337,1624345200"; 
   d="gz'50?scan'50,208,50";a="618746273"
Received: from lkp-server01.sh.intel.com (HELO 72c3bd3cf19c) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 30 Sep 2021 19:52:28 -0700
Received: from kbuild by 72c3bd3cf19c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mW8ey-0000iT-4p; Fri, 01 Oct 2021 02:52:28 +0000
Date:   Fri, 1 Oct 2021 10:51:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Wei Wang <weiwan@google.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: [net-next:master 415/423] net/core/sock.c:1417:14: error:
 'SO_RESERVE_MEM' undeclared
Message-ID: <202110011030.FOWD91L0-lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   b05173028cc52384be42dcf81abdb4133caccfa5
commit: 2bb2f5fb21b0486ff69b7b4a1fe03a760527d133 [415/423] net: add new socket option SO_RESERVE_MEM
config: sparc-defconfig (attached as .config)
compiler: sparc-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=2bb2f5fb21b0486ff69b7b4a1fe03a760527d133
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout 2bb2f5fb21b0486ff69b7b4a1fe03a760527d133
        # save the attached .config to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=sparc SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/core/sock.c: In function 'sock_setsockopt':
>> net/core/sock.c:1417:14: error: 'SO_RESERVE_MEM' undeclared (first use in this function)
    1417 |         case SO_RESERVE_MEM:
         |              ^~~~~~~~~~~~~~
   net/core/sock.c:1417:14: note: each undeclared identifier is reported only once for each function it appears in
   net/core/sock.c: In function 'sock_getsockopt':
   net/core/sock.c:1800:14: error: 'SO_RESERVE_MEM' undeclared (first use in this function)
    1800 |         case SO_RESERVE_MEM:
         |              ^~~~~~~~~~~~~~


vim +/SO_RESERVE_MEM +1417 net/core/sock.c

  1330	
  1331		case SO_MAX_PACING_RATE:
  1332			{
  1333			unsigned long ulval = (val == ~0U) ? ~0UL : (unsigned int)val;
  1334	
  1335			if (sizeof(ulval) != sizeof(val) &&
  1336			    optlen >= sizeof(ulval) &&
  1337			    copy_from_sockptr(&ulval, optval, sizeof(ulval))) {
  1338				ret = -EFAULT;
  1339				break;
  1340			}
  1341			if (ulval != ~0UL)
  1342				cmpxchg(&sk->sk_pacing_status,
  1343					SK_PACING_NONE,
  1344					SK_PACING_NEEDED);
  1345			sk->sk_max_pacing_rate = ulval;
  1346			sk->sk_pacing_rate = min(sk->sk_pacing_rate, ulval);
  1347			break;
  1348			}
  1349		case SO_INCOMING_CPU:
  1350			WRITE_ONCE(sk->sk_incoming_cpu, val);
  1351			break;
  1352	
  1353		case SO_CNX_ADVICE:
  1354			if (val == 1)
  1355				dst_negative_advice(sk);
  1356			break;
  1357	
  1358		case SO_ZEROCOPY:
  1359			if (sk->sk_family == PF_INET || sk->sk_family == PF_INET6) {
  1360				if (!((sk->sk_type == SOCK_STREAM &&
  1361				       sk->sk_protocol == IPPROTO_TCP) ||
  1362				      (sk->sk_type == SOCK_DGRAM &&
  1363				       sk->sk_protocol == IPPROTO_UDP)))
  1364					ret = -ENOTSUPP;
  1365			} else if (sk->sk_family != PF_RDS) {
  1366				ret = -ENOTSUPP;
  1367			}
  1368			if (!ret) {
  1369				if (val < 0 || val > 1)
  1370					ret = -EINVAL;
  1371				else
  1372					sock_valbool_flag(sk, SOCK_ZEROCOPY, valbool);
  1373			}
  1374			break;
  1375	
  1376		case SO_TXTIME:
  1377			if (optlen != sizeof(struct sock_txtime)) {
  1378				ret = -EINVAL;
  1379				break;
  1380			} else if (copy_from_sockptr(&sk_txtime, optval,
  1381				   sizeof(struct sock_txtime))) {
  1382				ret = -EFAULT;
  1383				break;
  1384			} else if (sk_txtime.flags & ~SOF_TXTIME_FLAGS_MASK) {
  1385				ret = -EINVAL;
  1386				break;
  1387			}
  1388			/* CLOCK_MONOTONIC is only used by sch_fq, and this packet
  1389			 * scheduler has enough safe guards.
  1390			 */
  1391			if (sk_txtime.clockid != CLOCK_MONOTONIC &&
  1392			    !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
  1393				ret = -EPERM;
  1394				break;
  1395			}
  1396			sock_valbool_flag(sk, SOCK_TXTIME, true);
  1397			sk->sk_clockid = sk_txtime.clockid;
  1398			sk->sk_txtime_deadline_mode =
  1399				!!(sk_txtime.flags & SOF_TXTIME_DEADLINE_MODE);
  1400			sk->sk_txtime_report_errors =
  1401				!!(sk_txtime.flags & SOF_TXTIME_REPORT_ERRORS);
  1402			break;
  1403	
  1404		case SO_BINDTOIFINDEX:
  1405			ret = sock_bindtoindex_locked(sk, val);
  1406			break;
  1407	
  1408		case SO_BUF_LOCK:
  1409			if (val & ~SOCK_BUF_LOCK_MASK) {
  1410				ret = -EINVAL;
  1411				break;
  1412			}
  1413			sk->sk_userlocks = val | (sk->sk_userlocks &
  1414						  ~SOCK_BUF_LOCK_MASK);
  1415			break;
  1416	
> 1417		case SO_RESERVE_MEM:
  1418		{
  1419			int delta;
  1420	
  1421			if (val < 0) {
  1422				ret = -EINVAL;
  1423				break;
  1424			}
  1425	
  1426			delta = val - sk->sk_reserved_mem;
  1427			if (delta < 0)
  1428				sock_release_reserved_memory(sk, -delta);
  1429			else
  1430				ret = sock_reserve_memory(sk, delta);
  1431			break;
  1432		}
  1433	
  1434		default:
  1435			ret = -ENOPROTOOPT;
  1436			break;
  1437		}
  1438		release_sock(sk);
  1439		return ret;
  1440	}
  1441	EXPORT_SYMBOL(sock_setsockopt);
  1442	
  1443	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--J2SCkAp4GZ/dPZZf
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
TqYRKOgSrUxenZ3k6aNISesy/A9UJbz4MdUAAA==

--J2SCkAp4GZ/dPZZf--
