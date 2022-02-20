Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934C14BD218
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 22:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239594AbiBTVoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 16:44:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiBTVoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 16:44:19 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EE93F8B1;
        Sun, 20 Feb 2022 13:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645393437; x=1676929437;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0bzwVQmx+1o3RuwwZadHl4Hi0/9MsUVIVX1U/GUlgCU=;
  b=KV82jUd3x4DnMOQkVQtmI2OzCxxZS4w9XM2QZL8t8LnnLtFpyCLHrk6V
   APTP/1IWT7VTrzpeP6/x+3XBhIyeYE7e8SaKGohoMVtYtablYOMJog5rH
   NgzCBmObyUvzRuN6+lXhu4XglagsWWvemGxbc1DNzp22oRweMlUhPnbfS
   MIP/869s8/dvc+dwMap6hy9GLWrXGkZLhrrjpC4gFJzQ3YYOjIc7Ll579
   K5bi8nskjKgkpu5aQbWM6q7NV7bluHq6JU5AR05tXXrNKpYsqYT64zMap
   2Uz1PrDZLIu1jUvqSkjhT4ah+g1Gghu2hrJf4dEKlSNb74uqKhExBds2n
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="312146712"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="312146712"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 13:43:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="706028038"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 20 Feb 2022 13:43:54 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nLtzl-0000t5-Qt; Sun, 20 Feb 2022 21:43:53 +0000
Date:   Mon, 21 Feb 2022 05:43:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 10/15] bpf: Wire up freeing of referenced
 PTR_TO_BTF_ID in map
Message-ID: <202202210547.JnjWSpPA-lkp@intel.com>
References: <20220220134813.3411982-11-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220220134813.3411982-11-memxor@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kumar,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on next-20220217]
[cannot apply to bpf-next/master bpf/master linus/master v5.17-rc4 v5.17-rc3 v5.17-rc2 v5.17-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Kumar-Kartikeya-Dwivedi/Introduce-typed-pointer-support-in-BPF-maps/20220220-215105
base:    3c30cf91b5ecc7272b3d2942ae0505dd8320b81c
config: openrisc-randconfig-s032-20220220 (https://download.01.org/0day-ci/archive/20220221/202202210547.JnjWSpPA-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/09a47522ec608218eb6aabd5011316d78ad245e0
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Kumar-Kartikeya-Dwivedi/Introduce-typed-pointer-support-in-BPF-maps/20220220-215105
        git checkout 09a47522ec608218eb6aabd5011316d78ad245e0
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=openrisc SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   kernel/bpf/syscall.c: In function 'bpf_map_free_ptr_to_btf_id':
>> kernel/bpf/syscall.c:669:32: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     669 |                 off_desc->dtor((void *)old_ptr);
         |                                ^
   In file included from arch/openrisc/include/asm/atomic.h:131,
                    from include/linux/atomic.h:7,
                    from include/asm-generic/bitops/lock.h:5,
                    from arch/openrisc/include/asm/bitops.h:41,
                    from include/linux/bitops.h:33,
                    from include/linux/log2.h:12,
                    from include/asm-generic/div64.h:55,
                    from ./arch/openrisc/include/generated/asm/div64.h:1,
                    from include/linux/math.h:6,
                    from include/linux/math64.h:6,
                    from include/linux/time.h:6,
                    from include/linux/ktime.h:24,
                    from include/linux/timer.h:6,
                    from include/linux/workqueue.h:9,
                    from include/linux/bpf.h:9,
                    from kernel/bpf/syscall.c:4:
   In function '__xchg',
       inlined from 'bpf_map_free_ptr_to_btf_id' at kernel/bpf/syscall.c:668:13:
>> arch/openrisc/include/asm/cmpxchg.h:160:24: error: call to '__xchg_called_with_bad_pointer' declared with attribute error: Bad argument size for xchg
     160 |                 return __xchg_called_with_bad_pointer();
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +669 kernel/bpf/syscall.c

   640	
   641	/* Caller must ensure map_value_has_ptr_to_btf_id is true. Note that this
   642	 * function can be called on a map value while the map_value is visible to BPF
   643	 * programs, as it ensures the correct synchronization, and we already enforce
   644	 * the same using the verifier on the BPF program side, esp. for referenced
   645	 * pointers.
   646	 */
   647	void bpf_map_free_ptr_to_btf_id(struct bpf_map *map, void *map_value)
   648	{
   649		struct bpf_map_value_off *tab = map->ptr_off_tab;
   650		u64 *btf_id_ptr;
   651		int i;
   652	
   653		for (i = 0; i < tab->nr_off; i++) {
   654			struct bpf_map_value_off_desc *off_desc = &tab->off[i];
   655			u64 old_ptr;
   656	
   657			btf_id_ptr = map_value + off_desc->offset;
   658			if (!(off_desc->flags & BPF_MAP_VALUE_OFF_F_REF)) {
   659				/* On 32-bit platforms, WRITE_ONCE 64-bit store tearing
   660				 * into two 32-bit stores is fine for us, as we only
   661				 * permit pointer values to be stored at this address,
   662				 * which are word sized, so the other half of 64-bit
   663				 * value will always be zeroed.
   664				 */
   665				WRITE_ONCE(*btf_id_ptr, 0);
   666				continue;
   667			}
   668			old_ptr = xchg(btf_id_ptr, 0);
 > 669			off_desc->dtor((void *)old_ptr);
   670		}
   671	}
   672	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
