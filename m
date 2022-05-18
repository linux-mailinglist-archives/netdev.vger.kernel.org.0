Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D44452C75E
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 01:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiERXOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 19:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiERXOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 19:14:03 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E817C1BF1B1;
        Wed, 18 May 2022 16:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652915640; x=1684451640;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+7xC5Q1BjsTKNBVhZVtbzNmmX8AWYp8Ft3lMIBj1NRY=;
  b=Ax5zVSZI2szv4bngM+GS+WFJ5jf5fYQA8rdZrlWXNxAKg+thdu17fA98
   ahkijLxD4SyRtvbeaDIxq+TanPSalquWkOqkmD3f5Q6MIoVXYsGWSNygN
   J8+tGh9BLOjTc0Z14sQvzOUjZ4qHs1z/b3N+O8kKny56mrInoUkpY/ZiY
   JzbzdC+2Ax5ZcXPr7m1Wyo/Z4PBY/zMZh7Up99vODIb5iRB7y49CjdfAx
   sLLZceRkhFvfkg9LPHCW4He5qw6yf0WTjXX4CWZ2l1lp/H0wT1nokBZXC
   JJ4W46j+p/GSJjodNWedccgMo59LlfaUTHx4ukz8s2cQawc+0BvwC+iZX
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="358339175"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="358339175"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 16:13:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="898481096"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 18 May 2022 16:13:54 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrSrZ-0002l7-Hr;
        Wed, 18 May 2022 23:13:53 +0000
Date:   Thu, 19 May 2022 07:13:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <greg@kroah.com>, Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     kbuild-all@lists.01.org, Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH bpf-next v5 09/17] HID: bpf: allocate data memory for
 device_event BPF programs
Message-ID: <202205190720.TIuHyCp6-lkp@intel.com>
References: <20220518205924.399291-10-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518205924.399291-10-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Benjamin,

I love your patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Benjamin-Tissoires/Introduce-eBPF-support-for-HID-devices/20220519-050506
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220519/202205190720.TIuHyCp6-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/ce32a9c683e801ac875c4e4eece32778040ed5cc
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Benjamin-Tissoires/Introduce-eBPF-support-for-HID-devices/20220519-050506
        git checkout ce32a9c683e801ac875c4e4eece32778040ed5cc
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   /usr/bin/ld: drivers/hid/hid-core.o: in function `hid_destroy_device':
   hid-core.c:(.text+0x10c0): undefined reference to `hid_bpf_destroy_device'
   /usr/bin/ld: drivers/hid/hid-core.o: in function `hid_allocate_device':
   hid-core.c:(.text+0x15c6): undefined reference to `hid_bpf_device_init'
   /usr/bin/ld: drivers/hid/hid-core.o: in function `hid_input_report':
   hid-core.c:(.text+0x22f7): undefined reference to `dispatch_hid_bpf_device_event'
   /usr/bin/ld: drivers/hid/hid-core.o: in function `hid_connect':
>> hid-core.c:(.text+0x25da): undefined reference to `hid_bpf_connect_device'
   /usr/bin/ld: drivers/hid/hid-core.o: in function `hid_disconnect':
>> hid-core.c:(.text+0xca1): undefined reference to `hid_bpf_disconnect_device'
   /usr/bin/ld: drivers/hid/hid-core.o: in function `hid_exit':
   hid-core.c:(.exit.text+0x7): undefined reference to `hid_bpf_ops'
   /usr/bin/ld: drivers/hid/hid-core.o: in function `hid_init':
   hid-core.c:(.init.text+0x35): undefined reference to `hid_bpf_ops'
   collect2: error: ld returned 1 exit status

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
