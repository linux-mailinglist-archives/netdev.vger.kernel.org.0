Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506EF535D19
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 11:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348572AbiE0JRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 05:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238328AbiE0JR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 05:17:29 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090B26A06E;
        Fri, 27 May 2022 02:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653643048; x=1685179048;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bE2tT2netU6tjQqP+1ZH1rQ7LDSr6uV96k8vICiBJ3g=;
  b=DFAdMRbr4SxJKnAVknWNJs8uLNftm25lOviXmHZeddyJpKAfVb3N5DR6
   ULaUoCXuK3MViDjcaH7B7jS9UgL3hMMryCdNxbCP+x5Z1/NJufifYKCvH
   fgLXQSvIc6E9YCmszsNLv8QMj8IPZJVH1rz7fom/4Y+8piy8qf4jtw0PA
   k4Z0ttPjnhhLveXu3eTe5v5YEM3it5Phe/6Z90BCHvEoKYzxd77bq3xbW
   P5CjXP7FBLkQupzC/zFU5ltZEJ36tRiaTOofWLNc8BVnmWQsLFuMY3/UI
   O6GU85yOyOin+HWfpWmrVxge7i9RUz7APOVHg88Fc8Yf49Itm4I9jM4r7
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="254924181"
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="254924181"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 02:17:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="902480516"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 27 May 2022 02:17:23 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nuW5y-0004cA-QH;
        Fri, 27 May 2022 09:17:22 +0000
Date:   Fri, 27 May 2022 17:17:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: Re: [PATCH v4 bpf-next 06/14] bpf: Whitelist some fields in nf_conn
 for BPF_WRITE
Message-ID: <202205271714.Uznf3vlP-lkp@intel.com>
References: <2954ab26de09afeecf3a56ba93624f9629072102.1653600578.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2954ab26de09afeecf3a56ba93624f9629072102.1653600578.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Bianconi/net-netfilter-add-kfunc-helper-to-update-ct-timeout/20220527-053913
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220527/202205271714.Uznf3vlP-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/c346565af9b023d9231ca8fca2e1b8c66a782f84
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Lorenzo-Bianconi/net-netfilter-add-kfunc-helper-to-update-ct-timeout/20220527-053913
        git checkout c346565af9b023d9231ca8fca2e1b8c66a782f84
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "btf_type_by_id" [net/netfilter/nf_conntrack.ko] undefined!
>> ERROR: modpost: "nf_conn_btf_struct_access_mtx" [net/netfilter/nf_conntrack.ko] undefined!
>> ERROR: modpost: "bpf_log" [net/netfilter/nf_conntrack.ko] undefined!
>> ERROR: modpost: "nf_conn_btf_struct_access" [net/netfilter/nf_conntrack.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
