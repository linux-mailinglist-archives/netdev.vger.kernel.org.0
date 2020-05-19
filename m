Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9114B1D96D4
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 14:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgESM6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 08:58:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:24423 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbgESM6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 08:58:19 -0400
IronPort-SDR: S3M6wa+vcuJsWCv2ffKE8HVCPEfRKkqRbpRxyjSr0/jFGdA46K3Bh1PvJ933Akm17nZf3dicc2
 zg97JY+RNtRg==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 05:56:16 -0700
IronPort-SDR: Z4D5EsxoJ4eiI8VLEtMAzE37GNMmXKSFTdBOtOdu1NdDMRzaw7j3gTBNmEzeX+6IUOaYkKcqrj
 a49jGil4MWAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="gz'50?scan'50,208,50";a="411623909"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 19 May 2020 05:56:13 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jb1n2-000Apo-ON; Tue, 19 May 2020 20:56:12 +0800
Date:   Tue, 19 May 2020 20:55:57 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, dsahern@gmail.com,
        davem@davemloft.net
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH net-next 3/6] vxlan: ecmp support for mac fdb entries
Message-ID: <202005192024.bhmnPcpX%lkp@intel.com>
References: <1589854474-26854-4-git-send-email-roopa@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <1589854474-26854-4-git-send-email-roopa@cumulusnetworks.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Roopa,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on net/master kselftest/next sparc-next/master linus/master v5.7-rc6 next-20200518]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Roopa-Prabhu/Support-for-fdb-ECMP-nexthop-groups/20200519-185605
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5cdfe8306631b2224e3f81fc5a1e2721c7a1948b
config: sh-polaris_defconfig (attached as .config)
compiler: sh4-linux-gcc (GCC) 9.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=sh 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>, old ones prefixed by <<):

In file included from net/ipv4/ip_tunnel_core.c:38:
include/net/vxlan.h: In function 'vxlan_fdb_nh_path_select':
>> include/net/vxlan.h:496:8: error: implicit declaration of function 'nexthop_path_fdb_result' [-Werror=implicit-function-declaration]
496 |  nhc = nexthop_path_fdb_result(nh, hash);
|        ^~~~~~~~~~~~~~~~~~~~~~~
>> include/net/vxlan.h:496:6: warning: assignment to 'struct fib_nh_common *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
496 |  nhc = nexthop_path_fdb_result(nh, hash);
|      ^
cc1: some warnings being treated as errors

vim +/nexthop_path_fdb_result +496 include/net/vxlan.h

   489	
   490	static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
   491						    int hash,
   492						    struct vxlan_rdst *rdst)
   493	{
   494		struct fib_nh_common *nhc;
   495	
 > 496		nhc = nexthop_path_fdb_result(nh, hash);
   497		if (unlikely(!nhc))
   498			return false;
   499	
   500		switch (nhc->nhc_gw_family) {
   501		case AF_INET:
   502			rdst->remote_ip.sin.sin_addr.s_addr = nhc->nhc_gw.ipv4;
   503			rdst->remote_ip.sa.sa_family = AF_INET;
   504			break;
   505		case AF_INET6:
   506			rdst->remote_ip.sin6.sin6_addr = nhc->nhc_gw.ipv6;
   507			rdst->remote_ip.sa.sa_family = AF_INET6;
   508			break;
   509		}
   510	
   511		return true;
   512	}
   513	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--6TrnltStXW4iwmi0
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
A/Od0Zz/Pxij9Fw6pwAA

--6TrnltStXW4iwmi0--
