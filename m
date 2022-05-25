Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43D35341BA
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 18:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245492AbiEYQwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 12:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238797AbiEYQwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 12:52:08 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBF933349;
        Wed, 25 May 2022 09:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653497527; x=1685033527;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=m352ENUFZqE2xOC6YCGx5rdnXcIf8B+FsHq1FS7a9n4=;
  b=AlR8AeCx7MJd2tej0iO8awLGjA2hz2+nU2TmER/ibgpmzzJn3bdo1x+V
   7hxfyXoemCZuMOXD/kiFtxdPmH4m3GInUu+dI+Iacv34OJwtjRiOEBEbt
   XWgpEuGhNqPtThVAZI95vtfU+/NLCb9hQCri3szbfhNTmDzAJo2wIVD9x
   KeMVM32MU7BG2Umspxk3wo1zcCZM8HJETA4ZFowYeskRqrygh1uiCRzC9
   6xAdjwE1cuEIlnC6zomXmQGI88NDMMHAdyr+0+be5lFSeMxamPysR+pJ1
   rsPempsjRRTJq/K7apaLkhmQ8d0nyH+LE1n5m4jTPgPhoulFyZnVEOJGi
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="255929672"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="255929672"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 09:52:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="559767274"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 25 May 2022 09:52:01 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ntuEr-00039o-1Z;
        Wed, 25 May 2022 16:52:01 +0000
Date:   Thu, 26 May 2022 00:51:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kpsingh@kernel.org
Cc:     kbuild-all@lists.01.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [PATCH 1/3] bpf: Add BPF_F_VERIFY_ELEM to require signature
 verification on map values
Message-ID: <202205260057.t4Lmg5Gb-lkp@intel.com>
References: <20220525132115.896698-2-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525132115.896698-2-roberto.sassu@huawei.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20220526/202205260057.t4Lmg5Gb-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/196e68e5ddfa50f40efaf20c8df37f3420e38b72
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Roberto-Sassu/bpf-Add-support-for-maps-with-authenticated-values/20220525-212552
        git checkout 196e68e5ddfa50f40efaf20c8df37f3420e38b72
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: kernel/bpf/syscall.o: in function `bpf_map_verify_value_sig':
>> syscall.c:(.text+0x4ff): undefined reference to `mod_check_sig'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
