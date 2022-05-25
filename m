Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E353C53435A
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 20:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343848AbiEYSv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 14:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbiEYSvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 14:51:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC7CB82D9;
        Wed, 25 May 2022 11:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653504669; x=1685040669;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VsaArmQbXIU984Fky0Ob1wA1EK8YPQICPQMN+ldpL3c=;
  b=VwUbM1S2B1yTgrlA2jSB9cO5b9PGhaQjakmh6Y5Gns558yNOgKTvQr4H
   Gci3JI5Ft41RRHl832e97M7TaCOXgLmVuJVZiUX4ne1vBar9EWIG8LEYs
   V0LMI4aho11sPh+W4nNI6tP1OiV/GTaggZ96QiEJ7j7yxwUsyxCMfRDg7
   KVFiUt6tkVwbzOUUgG9hzefKfSJGKDtd/y+g5WmxaZyXIryJTyNdvkNOz
   LiB3ixTyEIZXPs9VLFOcxsUBb4KwYOc3dS4wgYbfkxnis2jv7EPnNNEmt
   X5t69NhlE68TDUo5ycHElkWcXcIgpbOdvSwSU/g3Y5q0L1sifL+it9AhA
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="274015212"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="274015212"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 11:51:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="559819187"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 25 May 2022 11:51:05 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ntw64-0003F6-VI;
        Wed, 25 May 2022 18:51:04 +0000
Date:   Thu, 26 May 2022 02:50:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kpsingh@kernel.org
Cc:     kbuild-all@lists.01.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [PATCH 1/3] bpf: Add BPF_F_VERIFY_ELEM to require signature
 verification on map values
Message-ID: <202205260201.H6HGWRhl-lkp@intel.com>
References: <20220525132115.896698-2-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525132115.896698-2-roberto.sassu@huawei.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roberto,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]
[also build test ERROR on bpf/master horms-ipvs/master net/master net-next/master v5.18 next-20220525]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Roberto-Sassu/bpf-Add-support-for-maps-with-authenticated-values/20220525-212552
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20220526/202205260201.H6HGWRhl-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/196e68e5ddfa50f40efaf20c8df37f3420e38b72
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Roberto-Sassu/bpf-Add-support-for-maps-with-authenticated-values/20220525-212552
        git checkout 196e68e5ddfa50f40efaf20c8df37f3420e38b72
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   kernel/bpf/syscall.c: In function 'bpf_map_verify_value_sig':
>> kernel/bpf/syscall.c:1415:23: error: implicit declaration of function 'verify_pkcs7_signature' [-Werror=implicit-function-declaration]
    1415 |                 ret = verify_pkcs7_signature(mod, modlen, mod + modlen, sig_len,
         |                       ^~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/syscall.c: At top level:
   kernel/bpf/syscall.c:5271:13: warning: no previous prototype for 'unpriv_ebpf_notify' [-Wmissing-prototypes]
    5271 | void __weak unpriv_ebpf_notify(int new_state)
         |             ^~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/verify_pkcs7_signature +1415 kernel/bpf/syscall.c

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
  1386		_modlen = be32_to_cpu(*(u32 *)(mod));
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
> 1415			ret = verify_pkcs7_signature(mod, modlen, mod + modlen, sig_len,
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
