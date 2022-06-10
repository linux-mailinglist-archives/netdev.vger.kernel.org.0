Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6080854675C
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 15:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348074AbiFJN1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 09:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237423AbiFJN1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 09:27:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB1E206113;
        Fri, 10 Jun 2022 06:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654867662; x=1686403662;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=eTW19iyv8bmGlE74qdXZDVFsCItRJ8cEpvPZFZ3XmRo=;
  b=HVLl6o+jVNSa3OLtunwQvY85fPJ/Np6OqEL7J5tduz+2iv7SGrBlLt/I
   mpSUF6KcB3KArBqX6ghJG1jwTRr3HW7OQBmarr3pw92WFty8hEcs/g+rv
   gkA9IHpeHId7LNs1+arhqbS+kj0FDvXfW1VaUa3nG8KGzhmyBqKH5E0wM
   Azw1T5h0BIDDFqV/mNyBJRwllrLi4PyO2qnwkLWaTOndl60ufBhYQJbnm
   Ebk3s/SrZWV+enDBkPJEsHlwT3CgiDqev/OP4YoRb1cVM4hUGTtwTrVAJ
   sULBBi9g0wYwKdUhK0EpLnnSVGBPpvzVzumUC0dWgur6m8PBOV1i71LfL
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="277662252"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="277662252"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 06:27:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="724969786"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 10 Jun 2022 06:27:40 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nzefr-000HyT-Sf;
        Fri, 10 Jun 2022 13:27:39 +0000
Date:   Fri, 10 Jun 2022 21:26:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?J=F6rn-Thorben?= Hinz 
        <jthinz@mailbox.tu-berlin.de>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        =?iso-8859-1?Q?J=F6rn-Thorben?= Hinz 
        <jthinz@mailbox.tu-berlin.de>
Subject: Re: [PATCH bpf-next v2 2/2] bpf: Require only one of cong_avoid()
 and cong_control() from a TCP CC
Message-ID: <202206102106.exquHIbr-lkp@intel.com>
References: <20220609204702.2351369-3-jthinz@mailbox.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220609204702.2351369-3-jthinz@mailbox.tu-berlin.de>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi "Jörn-Thorben,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/J-rn-Thorben-Hinz/bpf-Allow-a-TCP-CC-to-write-sk_pacing_rate-and-sk_pacing_status/20220610-054718
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: i386-randconfig-a003 (https://download.01.org/0day-ci/archive/20220610/202206102106.exquHIbr-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/ac2a3c95ce28ad79c2ef7e6c52c4fd25af9f3c6d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review J-rn-Thorben-Hinz/bpf-Allow-a-TCP-CC-to-write-sk_pacing_rate-and-sk_pacing_status/20220610-054718
        git checkout ac2a3c95ce28ad79c2ef7e6c52c4fd25af9f3c6d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/ipv4/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/ipv4/bpf_tcp_ca.c: In function 'bpf_tcp_ca_init_member':
>> net/ipv4/bpf_tcp_ca.c:225:13: warning: unused variable 'prog_fd' [-Wunused-variable]
     225 |         int prog_fd;
         |             ^~~~~~~


vim +/prog_fd +225 net/ipv4/bpf_tcp_ca.c

0baf26b0fcd74b Martin KaFai Lau   2020-01-08  218  
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  219  static int bpf_tcp_ca_init_member(const struct btf_type *t,
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  220  				  const struct btf_member *member,
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  221  				  void *kdata, const void *udata)
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  222  {
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  223  	const struct tcp_congestion_ops *utcp_ca;
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  224  	struct tcp_congestion_ops *tcp_ca;
0baf26b0fcd74b Martin KaFai Lau   2020-01-08 @225  	int prog_fd;
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  226  	u32 moff;
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  227  
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  228  	utcp_ca = (const struct tcp_congestion_ops *)udata;
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  229  	tcp_ca = (struct tcp_congestion_ops *)kdata;
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  230  
8293eb995f349a Alexei Starovoitov 2021-12-01  231  	moff = __btf_member_bit_offset(t, member) / 8;
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  232  	switch (moff) {
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  233  	case offsetof(struct tcp_congestion_ops, flags):
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  234  		if (utcp_ca->flags & ~TCP_CONG_MASK)
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  235  			return -EINVAL;
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  236  		tcp_ca->flags = utcp_ca->flags;
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  237  		return 1;
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  238  	case offsetof(struct tcp_congestion_ops, name):
8e7ae2518f5265 Martin KaFai Lau   2020-03-13  239  		if (bpf_obj_name_cpy(tcp_ca->name, utcp_ca->name,
8e7ae2518f5265 Martin KaFai Lau   2020-03-13  240  				     sizeof(tcp_ca->name)) <= 0)
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  241  			return -EINVAL;
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  242  		if (tcp_ca_find(utcp_ca->name))
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  243  			return -EEXIST;
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  244  		return 1;
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  245  	}
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  246  
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  247  	return 0;
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  248  }
0baf26b0fcd74b Martin KaFai Lau   2020-01-08  249  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
