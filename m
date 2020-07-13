Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B85A21E322
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgGMWly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:41:54 -0400
Received: from mga17.intel.com ([192.55.52.151]:40574 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgGMWly (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 18:41:54 -0400
IronPort-SDR: 3iKhfYgONhlHboQePjXvZYY4m4n59rcjzgKR9JnBVPbzLtqf2tK0U783MuRbIKfH0tzWDcdRB1
 CCz3Lk3HqrVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="128844134"
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="gz'50?scan'50,208,50";a="128844134"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 15:36:51 -0700
IronPort-SDR: 9sVZ8i4qW0QD7mGE+mZ+7zoDuk8DRaWddmpDG8xzrstRsR12RD9bjAHgC+2FUS4vR0PuiDhHlh
 vDy8OYJrkw7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="gz'50?scan'50,208,50";a="324368206"
Received: from lkp-server02.sh.intel.com (HELO fb03a464a2e3) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jul 2020 15:36:49 -0700
Received: from kbuild by fb03a464a2e3 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jv744-00010i-Vi; Mon, 13 Jul 2020 22:36:48 +0000
Date:   Tue, 14 Jul 2020 06:36:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dmitry Yakunin <zeil@yandex-team.ru>, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, sdf@google.com
Subject: Re: [PATCH bpf-next 4/4] bpf: try to use existing cgroup storage in
 bpf_prog_test_run_skb
Message-ID: <202007140649.5N7vFmaT%lkp@intel.com>
References: <20200713182520.97606-5-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <20200713182520.97606-5-zeil@yandex-team.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dmitry,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Dmitry-Yakunin/bpf-cgroup-skb-improvements-for-bpf_prog_test_run/20200714-022728
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: m68k-sun3_defconfig (attached as .config)
compiler: m68k-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=m68k 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   net/bpf/test_run.c: In function 'bpf_prog_find_active_storage':
>> net/bpf/test_run.c:47:9: error: implicit declaration of function 'task_dfl_cgroup' [-Werror=implicit-function-declaration]
      47 |  cgrp = task_dfl_cgroup(current);
         |         ^~~~~~~~~~~~~~~
>> net/bpf/test_run.c:47:7: warning: assignment to 'struct cgroup *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
      47 |  cgrp = task_dfl_cgroup(current);
         |       ^
>> net/bpf/test_run.c:50:13: error: dereferencing pointer to incomplete type 'struct cgroup'
      50 |         cgrp->bpf.effective[BPF_CGROUP_INET_INGRESS]);
         |             ^~
   net/bpf/test_run.c: In function 'bpf_test_run':
   net/bpf/test_run.c:67:8: error: implicit declaration of function 'bpf_cgroup_storages_alloc'; did you mean 'bpf_cgroup_storage_alloc'? [-Werror=implicit-function-declaration]
      67 |  ret = bpf_cgroup_storages_alloc(dummy_storage, prog);
         |        ^~~~~~~~~~~~~~~~~~~~~~~~~
         |        bpf_cgroup_storage_alloc
   net/bpf/test_run.c:115:2: error: implicit declaration of function 'bpf_cgroup_storages_free'; did you mean 'bpf_cgroup_storage_free'? [-Werror=implicit-function-declaration]
     115 |  bpf_cgroup_storages_free(dummy_storage);
         |  ^~~~~~~~~~~~~~~~~~~~~~~~
         |  bpf_cgroup_storage_free
   cc1: some warnings being treated as errors

vim +/task_dfl_cgroup +47 net/bpf/test_run.c

    38	
    39	static struct bpf_cgroup_storage **bpf_prog_find_active_storage(struct bpf_prog *prog)
    40	{
    41		struct bpf_prog_array_item *item;
    42		struct cgroup *cgrp;
    43	
    44		if (prog->type != BPF_PROG_TYPE_CGROUP_SKB)
    45			return NULL;
    46	
  > 47		cgrp = task_dfl_cgroup(current);
    48	
    49		item = bpf_prog_find_active(prog,
  > 50					    cgrp->bpf.effective[BPF_CGROUP_INET_INGRESS]);
    51		if (!item)
    52			item = bpf_prog_find_active(prog,
    53						    cgrp->bpf.effective[BPF_CGROUP_INET_EGRESS]);
    54	
    55		return item ? item->cgroup_storage : NULL;
    56	}
    57	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--gBBFr7Ir9EOA20Yy
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--gBBFr7Ir9EOA20Yy--
