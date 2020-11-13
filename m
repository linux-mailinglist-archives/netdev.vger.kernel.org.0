Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86D82B2128
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgKMQ5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:57:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725967AbgKMQ5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 11:57:32 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95742217A0;
        Fri, 13 Nov 2020 16:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605286652;
        bh=la7rtuRvQo/nFyioArw+GmaBHrmnYoByq6L20qjx5Vw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kHf7yJxG+JN4ZDc2SYUn1wSFTb+IXF3p7ZvwJ11WUUsu9VoX158214gLubXrSFDgw
         tx/TQGrbzuR2H0lg4iEJ0lnoun1eTceN0Lr+9VyefHnTvCHuHYEMb4UzadgXv6YZIq
         zNqhYp2NJjMyQu40EsbRiG8cNdyvbDwDetqrJk+0=
Date:   Fri, 13 Nov 2020 08:57:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        netdev@vger.kernel.org
Subject: Re: [net-next,v2,4/5] seg6: add support for the SRv6 End.DT4
 behavior
Message-ID: <20201113085730.5f3c850a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <202011131747.puABQV5A-lkp@intel.com>
References: <20201107153139.3552-5-andrea.mayer@uniroma2.it>
        <202011131747.puABQV5A-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good people of build bot, 

would you mind shedding some light on this one? It was also reported on
v1, and Andrea said it's impossible to repro. Strange that build bot
would make the same mistake twice, tho.

Thanks!

On Fri, 13 Nov 2020 17:23:09 +0800 kernel test robot wrote:
> Hi Andrea,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on ipvs/master]
> [also build test ERROR on linus/master sparc-next/master v5.10-rc3 next-20201112]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Andrea-Mayer/seg6-add-support-for-the-SRv6-End-DT4-behavior/20201109-093019
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
> config: x86_64-randconfig-a005-20201111 (attached as .config)
> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project 874b0a0b9db93f5d3350ffe6b5efda2d908415d0)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install x86_64 cross compiling tool for clang build
>         # apt-get install binutils-x86-64-linux-gnu
>         # https://github.com/0day-ci/linux/commit/761138e2f757ac64efe97b03311c976db242dc92
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Andrea-Mayer/seg6-add-support-for-the-SRv6-End-DT4-behavior/20201109-093019
>         git checkout 761138e2f757ac64efe97b03311c976db242dc92
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
> >> net/ipv6/seg6_local.c:793:4: error: field designator 'slwt_ops' does not refer to any field in type 'struct seg6_action_desc'  
>                    .slwt_ops       = {
>                     ^
> >> net/ipv6/seg6_local.c:826:10: error: invalid application of 'sizeof' to an incomplete type 'struct seg6_action_desc []'  
>            count = ARRAY_SIZE(seg6_action_table);
>                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/kernel.h:48:32: note: expanded from macro 'ARRAY_SIZE'
>    #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>                                   ^~~~~
>    2 errors generated.
> 
> vim +793 net/ipv6/seg6_local.c
> 
>    757	
>    758	static struct seg6_action_desc seg6_action_table[] = {
>    759		{
>    760			.action		= SEG6_LOCAL_ACTION_END,
>    761			.attrs		= 0,
>    762			.input		= input_action_end,
>    763		},
>    764		{
>    765			.action		= SEG6_LOCAL_ACTION_END_X,
>    766			.attrs		= (1 << SEG6_LOCAL_NH6),
>    767			.input		= input_action_end_x,
>    768		},
>    769		{
>    770			.action		= SEG6_LOCAL_ACTION_END_T,
>    771			.attrs		= (1 << SEG6_LOCAL_TABLE),
>    772			.input		= input_action_end_t,
>    773		},
>    774		{
>    775			.action		= SEG6_LOCAL_ACTION_END_DX2,
>    776			.attrs		= (1 << SEG6_LOCAL_OIF),
>    777			.input		= input_action_end_dx2,
>    778		},
>    779		{
>    780			.action		= SEG6_LOCAL_ACTION_END_DX6,
>    781			.attrs		= (1 << SEG6_LOCAL_NH6),
>    782			.input		= input_action_end_dx6,
>    783		},
>    784		{
>    785			.action		= SEG6_LOCAL_ACTION_END_DX4,
>    786			.attrs		= (1 << SEG6_LOCAL_NH4),
>    787			.input		= input_action_end_dx4,
>    788		},
>    789		{
>    790			.action		= SEG6_LOCAL_ACTION_END_DT4,
>    791			.attrs		= (1 << SEG6_LOCAL_TABLE),
>    792			.input		= input_action_end_dt4,
>  > 793			.slwt_ops	= {  
>    794						.build_state = seg6_end_dt4_build,
>    795					  },
>    796		},
>    797		{
>    798			.action		= SEG6_LOCAL_ACTION_END_DT6,
>    799			.attrs		= (1 << SEG6_LOCAL_TABLE),
>    800			.input		= input_action_end_dt6,
>    801		},
>    802		{
>    803			.action		= SEG6_LOCAL_ACTION_END_B6,
>    804			.attrs		= (1 << SEG6_LOCAL_SRH),
>    805			.input		= input_action_end_b6,
>    806		},
>    807		{
>    808			.action		= SEG6_LOCAL_ACTION_END_B6_ENCAP,
>    809			.attrs		= (1 << SEG6_LOCAL_SRH),
>    810			.input		= input_action_end_b6_encap,
>    811			.static_headroom	= sizeof(struct ipv6hdr),
>    812		},
>    813		{
>    814			.action		= SEG6_LOCAL_ACTION_END_BPF,
>    815			.attrs		= (1 << SEG6_LOCAL_BPF),
>    816			.input		= input_action_end_bpf,
>    817		},
>    818	
>    819	};
>    820	
>    821	static struct seg6_action_desc *__get_action_desc(int action)
>    822	{
>    823		struct seg6_action_desc *desc;
>    824		int i, count;
>    825	
>  > 826		count = ARRAY_SIZE(seg6_action_table);  
>    827		for (i = 0; i < count; i++) {
>    828			desc = &seg6_action_table[i];
>    829			if (desc->action == action)
>    830				return desc;
>    831		}
>    832	
>    833		return NULL;
>    834	}
>    835	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

