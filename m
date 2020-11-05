Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5DC2A8B10
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 00:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732610AbgKEX64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 18:58:56 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:55360 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732035AbgKEX64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 18:58:56 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0A5NvmjE020885;
        Fri, 6 Nov 2020 00:57:53 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 2FE7C120925;
        Fri,  6 Nov 2020 00:57:43 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1604620663; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X5qgOQWn1atN2JvqIQ+51gxDrdrwTkdn0yB5QuLIC/w=;
        b=xdYr/CFUq12TGdTEdXXz/HbXja9/1cZXfLJlyNKk6kQvFPuKK0r/ITeOomI/veoXDeWk81
        Scjdb7DO65iIBFCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1604620663; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X5qgOQWn1atN2JvqIQ+51gxDrdrwTkdn0yB5QuLIC/w=;
        b=PLtPPoTraKcS4SzwyfMDzltcxzoR7ptP+D0z6zMPDOeLX7NOg4NqXMjF/Iau2ZXksbvmBr
        EpND+0rNvFAw2vf3bV8U46HziMTitnTAbS0nfhOem52BJ7xPw0mgo6rRol/Cshcqezm5Kx
        jmVypdL2YfEtE55k1uUu5U+oIj+ZWuWk4LUfQNsVtvrmHSLHDtVGKSzprVvx0irrmU55Xc
        sD4TF+WvEMZ1gCIJ5Gkt5V+KVbTVqmG9TSmc2NVr85IvwNZqjdaHbLJaYPDXzQ222f1Ejv
        Hoxd+XmeW6+MXHRCIBrW1IMUAdRiIwxs8HkiA0b1qFn50QyHKNoy7eR+6fE0Pw==
Date:   Fri, 6 Nov 2020 00:57:42 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kbuild-all@lists.01.org, netdev@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next,v1,4/5] seg6: add support for the SRv6 End.DT4
 behavior
Message-Id: <20201106005742.31985db8c30c89e0b0868170@uniroma2.it>
In-Reply-To: <202011040355.ljXTObZi-lkp@intel.com>
References: <20201103125242.11468-5-andrea.mayer@uniroma2.it>
        <202011040355.ljXTObZi-lkp@intel.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Wed, 4 Nov 2020 04:00:10 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi Andrea,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on ipvs/master]
> [also build test WARNING on linus/master v5.10-rc2 next-20201103]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Andrea-Mayer/seg6-add-support-for-the-SRv6-End-DT4-behavior/20201103-205553
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
> config: arc-allyesconfig (attached as .config)
> compiler: arceb-elf-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/266de8d69af869840a965c080862d6b5ea4a93cd
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Andrea-Mayer/seg6-add-support-for-the-SRv6-End-DT4-behavior/20201103-205553
>         git checkout 266de8d69af869840a965c080862d6b5ea4a93cd
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=arc 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    net/ipv6/seg6_local.c:793:4: error: 'struct seg6_action_desc' has no member named 'slwt_ops'
>      793 |   .slwt_ops = {
>          |    ^~~~~~~~

I spent some time figuring out what happened with this patch. It seems that the
patchset was not applied by the kernel test robot in the correct order. In
particular, patch 3 is missing from this build attempt.

I applied one patch after another in the correct order and, each time, I was
able to compile the kernel (C=1 W=1) successfully with the .config file provided
by the robot.

Thanks,
Andrea
