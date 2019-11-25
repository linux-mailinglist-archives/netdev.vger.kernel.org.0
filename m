Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED411108925
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 08:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfKYH1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 02:27:30 -0500
Received: from www62.your-server.de ([213.133.104.62]:51818 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfKYH1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 02:27:30 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iZ8mH-0003rb-BA; Mon, 25 Nov 2019 08:27:21 +0100
Received: from [178.197.248.11] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iZ8mG-000Xpm-Uq; Mon, 25 Nov 2019 08:27:20 +0100
Subject: Re: [PATCH bpf-next] bpf: add bpf_jit_blinding_enabled for
 !CONFIG_BPF_JIT
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, ast@kernel.org, jakub@cloudflare.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        philip.li@intel.com, fengguang.wu@intel.com
References: <40baf8f3507cac4851a310578edfb98ce73b5605.1574541375.git.daniel@iogearbox.net>
 <201911250641.xKeDIKoX%lkp@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4447a335-6311-3470-7546-dff06672a200@iogearbox.net>
Date:   Mon, 25 Nov 2019 08:27:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <201911250641.xKeDIKoX%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25643/Sun Nov 24 10:57:45 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ +Philip, +Fengguang ]

On 11/24/19 11:54 PM, kbuild test robot wrote:
> Hi Daniel,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on bpf-next/master]
> [cannot apply to v5.4-rc8 next-20191122]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Daniel-Borkmann/bpf-add-bpf_jit_blinding_enabled-for-CONFIG_BPF_JIT/20191125-042008
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: i386-tinyconfig (attached as .config)
> compiler: gcc-7 (Debian 7.4.0-14) 7.4.0
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=i386
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>     In file included from include/net/sock.h:59:0,
>                      from include/linux/tcp.h:19,
>                      from include/linux/ipv6.h:87,
>                      from include/net/ipv6.h:12,
>                      from include/linux/sunrpc/clnt.h:28,
>                      from include/linux/nfs_fs.h:32,
>                      from init/do_mounts.c:23:
>>> include/linux/filter.h:1061:20: error: redefinition of 'bpf_jit_blinding_enabled'
>      static inline bool bpf_jit_blinding_enabled(struct bpf_prog *prog)
>                         ^~~~~~~~~~~~~~~~~~~~~~~~
>     include/linux/filter.h:1056:20: note: previous definition of 'bpf_jit_blinding_enabled' was here
>      static inline bool bpf_jit_blinding_enabled(struct bpf_prog *prog)
>                         ^~~~~~~~~~~~~~~~~~~~~~~~

Hmm, can't reproduce with above .config for `make ARCH=i386`. The .config doesn't have
CONFIG_BPF_JIT, and given there's only exactly *one* definition of bpf_jit_blinding_enabled()
for CONFIG_BPF_JIT and *one* for !CONFIG_BPF_JIT this build bot warning feels invalid to me
(unless I'm completely blind and missing something obvious, but the succeeded kernel build
seems to agree with me).

Thanks,
Daniel

> vim +/bpf_jit_blinding_enabled +1061 include/linux/filter.h
> 
>    1060	
>> 1061	static inline bool bpf_jit_blinding_enabled(struct bpf_prog *prog)
>    1062	{
>    1063		return false;
>    1064	}
>    1065	
> 
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology Center
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
> 

