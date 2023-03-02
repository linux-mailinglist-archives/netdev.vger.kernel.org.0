Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBF96A7A0E
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 04:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjCBDaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 22:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBDaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 22:30:02 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B9F1630D;
        Wed,  1 Mar 2023 19:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677727801; x=1709263801;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NwJ07CM/Mu9/J7cKY3zH1nzADgAXPFICFXfxAgaZASM=;
  b=XEr157G0SOO8hCrzT4NtvMBeJMoLiomKwBBIYIHXfbXm3FuBzxem8hEV
   7cfhZeoR0iIibnMY1l0x3dMGcD/T7ehLEl/v6abXxBWKurxkSM4IVtRAu
   PANQKlCf2NnavO/ivLRTvw2B35rpg4wvfualBFDaOEzfmdTVexlSn2SzE
   LJX8nlcvIWyChajl1dcEmFE63a9DghK3UyNcC4hcA7bT0QR34uU4Gw5uY
   pCVvE4Gb3Z0X29XsyzzMpkde62k3o1gQje4zNDO+S/vddGBzFUHum6epg
   alOU2WlDTFddinFFOO6VR1xH9a0Oim/pMBmFNEd05wqNtDx/Q90DSAcVl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="332085176"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="332085176"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 19:30:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="743674639"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="743674639"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 01 Mar 2023 19:29:58 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pXZdm-00009M-0B;
        Thu, 02 Mar 2023 03:29:58 +0000
Date:   Thu, 2 Mar 2023 11:29:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, martin.lau@kernel.org,
        andrii@kernel.org, ast@kernel.org, memxor@gmail.com,
        daniel@iogearbox.net, netdev@vger.kernel.org, toke@kernel.org,
        Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and
 bpf_dynptr_slice_rdwr
Message-ID: <202303021152.sPWiwGYn-lkp@intel.com>
References: <20230301154953.641654-10-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301154953.641654-10-joannelkoong@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joanne,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/bpf-Support-sk_buff-and-xdp_buff-as-valid-kfunc-arg-types/20230301-235341
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/20230301154953.641654-10-joannelkoong%40gmail.com
patch subject: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
config: microblaze-randconfig-s043-20230302 (https://download.01.org/0day-ci/archive/20230302/202303021152.sPWiwGYn-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/ab021cad431168baaba04ed320003be30f4deb34
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/bpf-Support-sk_buff-and-xdp_buff-as-valid-kfunc-arg-types/20230301-235341
        git checkout ab021cad431168baaba04ed320003be30f4deb34
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=microblaze olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=microblaze SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303021152.sPWiwGYn-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> kernel/bpf/helpers.c:2231:24: sparse: sparse: Using plain integer as NULL pointer
   kernel/bpf/helpers.c:2235:24: sparse: sparse: Using plain integer as NULL pointer
   kernel/bpf/helpers.c:2256:24: sparse: sparse: Using plain integer as NULL pointer
   kernel/bpf/helpers.c:2305:24: sparse: sparse: Using plain integer as NULL pointer
   kernel/bpf/helpers.c:2342:18: sparse: sparse: context imbalance in 'bpf_rcu_read_lock' - wrong count at exit
   kernel/bpf/helpers.c:2347:18: sparse: sparse: context imbalance in 'bpf_rcu_read_unlock' - unexpected unlock

vim +2231 kernel/bpf/helpers.c

  2195	
  2196	/**
  2197	 * bpf_dynptr_slice - Obtain a read-only pointer to the dynptr data.
  2198	 *
  2199	 * For non-skb and non-xdp type dynptrs, there is no difference between
  2200	 * bpf_dynptr_slice and bpf_dynptr_data.
  2201	 *
  2202	 * If the intention is to write to the data slice, please use
  2203	 * bpf_dynptr_slice_rdwr.
  2204	 *
  2205	 * The user must check that the returned pointer is not null before using it.
  2206	 *
  2207	 * Please note that in the case of skb and xdp dynptrs, bpf_dynptr_slice
  2208	 * does not change the underlying packet data pointers, so a call to
  2209	 * bpf_dynptr_slice will not invalidate any ctx->data/data_end pointers in
  2210	 * the bpf program.
  2211	 *
  2212	 * @ptr: The dynptr whose data slice to retrieve
  2213	 * @offset: Offset into the dynptr
  2214	 * @buffer: User-provided buffer to copy contents into
  2215	 * @buffer__szk: Size (in bytes) of the buffer. This is the length of the
  2216	 * requested slice. This must be a constant.
  2217	 *
  2218	 * @returns: NULL if the call failed (eg invalid dynptr), pointer to a read-only
  2219	 * data slice (can be either direct pointer to the data or a pointer to the user
  2220	 * provided buffer, with its contents containing the data, if unable to obtain
  2221	 * direct pointer)
  2222	 */
  2223	__bpf_kfunc void *bpf_dynptr_slice(const struct bpf_dynptr_kern *ptr, u32 offset,
  2224					   void *buffer, u32 buffer__szk)
  2225	{
  2226		enum bpf_dynptr_type type;
  2227		u32 len = buffer__szk;
  2228		int err;
  2229	
  2230		if (!ptr->data)
> 2231			return 0;
  2232	
  2233		err = bpf_dynptr_check_off_len(ptr, offset, len);
  2234		if (err)
  2235			return 0;
  2236	
  2237		type = bpf_dynptr_get_type(ptr);
  2238	
  2239		switch (type) {
  2240		case BPF_DYNPTR_TYPE_LOCAL:
  2241		case BPF_DYNPTR_TYPE_RINGBUF:
  2242			return ptr->data + ptr->offset + offset;
  2243		case BPF_DYNPTR_TYPE_SKB:
  2244			return skb_header_pointer(ptr->data, ptr->offset + offset, len, buffer);
  2245		case BPF_DYNPTR_TYPE_XDP:
  2246		{
  2247			void *xdp_ptr = bpf_xdp_pointer(ptr->data, ptr->offset + offset, len);
  2248			if (xdp_ptr)
  2249				return xdp_ptr;
  2250	
  2251			bpf_xdp_copy_buf(ptr->data, ptr->offset + offset, buffer, len, false);
  2252			return buffer;
  2253		}
  2254		default:
  2255			WARN_ONCE(true, "unknown dynptr type %d\n", type);
  2256			return 0;
  2257		}
  2258	}
  2259	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
