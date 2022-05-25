Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3734B5346D8
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 00:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241120AbiEYWxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 18:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiEYWxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 18:53:24 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C56F3B55D;
        Wed, 25 May 2022 15:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653519203; x=1685055203;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E0mLQr3arF2hw1fLqA325E6sG4xs0WL8xdqdjaiaNI8=;
  b=linCQBwrsSxpEZNTP+RVTdYGt7bOE/gO+TR0FGL4qdvA4tejDX2xCMcE
   tVI7TSjUY5cU7fNKeokiBVMRJQ+KZ2HMHEVSGeMrasqoKQ6FaMH0mY6ic
   yfjWvtcSpr5fb7ucOO3a5Gh2rjJwGAzxJTev0HWOMUkAsg8HLpMOq2k2+
   Rxjpnr9fcRNmr11JeOIbdDZUdC9RFUOXlZdhkso5hYl8Ujd9TsiYjYRoM
   XXmCwlcSSgTWOflq/HSxeEfeL+ifNc4/RurW+VNN8/DGl1lgdgwFf6YeD
   fUUs0Xe5eNUNlgoMNGdfTwN5xxVtJtGim6EIDtf6JCixYjqkA/33xVHpp
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="261568232"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="261568232"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 15:53:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="578542089"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 25 May 2022 15:53:20 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ntzsV-0003Nc-Jl;
        Wed, 25 May 2022 22:53:19 +0000
Date:   Thu, 26 May 2022 06:53:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kpsingh@kernel.org
Cc:     kbuild-all@lists.01.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [PATCH 1/3] bpf: Add BPF_F_VERIFY_ELEM to require signature
 verification on map values
Message-ID: <202205260606.VXzztn2R-lkp@intel.com>
References: <20220525132115.896698-2-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525132115.896698-2-roberto.sassu@huawei.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roberto,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]
[also build test WARNING on bpf/master horms-ipvs/master net/master net-next/master v5.18 next-20220525]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Roberto-Sassu/bpf-Add-support-for-maps-with-authenticated-values/20220525-212552
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220526/202205260606.VXzztn2R-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-14-g5a0004b5-dirty
        # https://github.com/intel-lab-lkp/linux/commit/196e68e5ddfa50f40efaf20c8df37f3420e38b72
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Roberto-Sassu/bpf-Add-support-for-maps-with-authenticated-values/20220525-212552
        git checkout 196e68e5ddfa50f40efaf20c8df37f3420e38b72
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   kernel/bpf/syscall.c:590:25: sparse: sparse: Using plain integer as NULL pointer
>> kernel/bpf/syscall.c:1386:19: sparse: sparse: cast to restricted __be32
   kernel/bpf/syscall.c: note: in included file (through include/linux/bpf.h):
   include/linux/bpfptr.h:52:47: sparse: sparse: cast to non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast from non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast to non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast from non-scalar
   include/linux/bpfptr.h:81:43: sparse: sparse: cast to non-scalar
   include/linux/bpfptr.h:81:43: sparse: sparse: cast from non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast to non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast from non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast to non-scalar
   include/linux/bpfptr.h:52:47: sparse: sparse: cast from non-scalar

vim +1386 kernel/bpf/syscall.c

  1369	
  1370	int bpf_map_verify_value_sig(const void *mod, size_t modlen, bool verify)
  1371	{
  1372		const size_t marker_len = strlen(MODULE_SIG_STRING);
  1373		struct module_signature ms;
  1374		size_t sig_len;
  1375		u32 _modlen;
  1376		int ret;
  1377	
  1378		/*
  1379		 * Format of mod:
  1380		 *
  1381		 * verified data+sig size (be32), verified data, sig, unverified data
  1382		 */
  1383		if (modlen <= sizeof(u32))
  1384			return -ENOENT;
  1385	
> 1386		_modlen = be32_to_cpu(*(u32 *)(mod));
  1387	
  1388		if (_modlen > modlen - sizeof(u32))
  1389			return -EINVAL;
  1390	
  1391		modlen = _modlen;
  1392		mod += sizeof(u32);
  1393	
  1394		if (modlen <= marker_len)
  1395			return -ENOENT;
  1396	
  1397		if (memcmp(mod + modlen - marker_len, MODULE_SIG_STRING, marker_len))
  1398			return -ENOENT;
  1399	
  1400		modlen -= marker_len;
  1401	
  1402		if (modlen <= sizeof(ms))
  1403			return -EBADMSG;
  1404	
  1405		memcpy(&ms, mod + (modlen - sizeof(ms)), sizeof(ms));
  1406	
  1407		ret = mod_check_sig(&ms, modlen, "bpf_map_value");
  1408		if (ret)
  1409			return ret;
  1410	
  1411		sig_len = be32_to_cpu(ms.sig_len);
  1412		modlen -= sig_len + sizeof(ms);
  1413	
  1414		if (verify) {
  1415			ret = verify_pkcs7_signature(mod, modlen, mod + modlen, sig_len,
  1416						     VERIFY_USE_SECONDARY_KEYRING,
  1417						     VERIFYING_UNSPECIFIED_SIGNATURE,
  1418						     NULL, NULL);
  1419			if (ret < 0)
  1420				return ret;
  1421		}
  1422	
  1423		return modlen;
  1424	}
  1425	EXPORT_SYMBOL_GPL(bpf_map_verify_value_sig);
  1426	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
