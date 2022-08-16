Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C155952A1
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiHPGiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiHPGh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:37:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1C9C3F6D;
        Mon, 15 Aug 2022 18:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660612605; x=1692148605;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LGPJbg4YSGE8kGvV/+MMwres2qQJGjWYu0L1b7FKRhE=;
  b=ELRkR2j1k99KuJmwKFAuMd3EZk19xB9XFwD1m3elDOIJ/99+sIdebamR
   BPlxiwKrSATGt8r0FVnjxTZg2R9AnPplI3rWDKZl93hNRipjow5kb5V3y
   jZoUzRg5s82gd6CunLWVcSV0iTKD/QIO6FXUx7iYPO4JGCD3q66DZ6I2n
   dsCBypP0P08a85N7ywODoZLQyacGutLWasCv1Juw7vCsoeTEmlssEY1cp
   t8d2L6lZzlp/dYoxYTxYNwKE6EcpGn090h7gPqU7pgfMDGt/kPyB8QZzC
   klr52tGFjSaa8NXxv5oSnV1j9tvcpwIY/mIXXzG9Ne3RrK+YdCwXZngay
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="293368083"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="293368083"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 18:16:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="639838790"
Received: from lkp-server02.sh.intel.com (HELO 3d2a4d02a2a9) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 15 Aug 2022 18:16:42 -0700
Received: from kbuild by 3d2a4d02a2a9 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oNlCD-0001KD-2Z;
        Tue, 16 Aug 2022 01:16:41 +0000
Date:   Tue, 16 Aug 2022 09:15:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Daniel Xu <dxu@dxuuu.xyz>, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com
Cc:     kbuild-all@lists.01.org, Daniel Xu <dxu@dxuuu.xyz>,
        pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/3] bpf: Add support for writing to nf_conn:mark
Message-ID: <202208160931.5FG8tZ8G-lkp@intel.com>
References: <f850bb7e20950736d9175c61d7e0691098e06182.1660592020.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f850bb7e20950736d9175c61d7e0691098e06182.1660592020.git.dxu@dxuuu.xyz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Daniel-Xu/Support-direct-writes-to-nf_conn-mark/20220816-060429
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: um-x86_64_defconfig (https://download.01.org/0day-ci/archive/20220816/202208160931.5FG8tZ8G-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/c7b21d163eb9c61514dd86baf4281deb4d4387bb
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Daniel-Xu/Support-direct-writes-to-nf_conn-mark/20220816-060429
        git checkout c7b21d163eb9c61514dd86baf4281deb4d4387bb
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/core/filter.c: In function 'tc_cls_act_btf_struct_access':
>> net/core/filter.c:8723:24: error: implicit declaration of function 'btf_struct_access' [-Werror=implicit-function-declaration]
    8723 |                 return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
         |                        ^~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/btf_struct_access +8723 net/core/filter.c

  8714	
  8715	static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
  8716						const struct btf *btf,
  8717						const struct btf_type *t, int off,
  8718						int size, enum bpf_access_type atype,
  8719						u32 *next_btf_id,
  8720						enum bpf_type_flag *flag)
  8721	{
  8722		if (atype == BPF_READ)
> 8723			return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
  8724						 flag);
  8725	
  8726		return nf_conntrack_btf_struct_access(log, btf, t, off, size, atype,
  8727						      next_btf_id, flag);
  8728	}
  8729	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
