Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C542935B60F
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 18:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbhDKQYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 12:24:06 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:30507 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236406AbhDKQYF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 12:24:05 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4FJHHM2Bm5zB09Zv;
        Sun, 11 Apr 2021 18:23:43 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id M7H_TZ3xfLZz; Sun, 11 Apr 2021 18:23:43 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4FJHHM11MkzB09Zt;
        Sun, 11 Apr 2021 18:23:43 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A74A38B770;
        Sun, 11 Apr 2021 18:23:46 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id z7Gre_ROyeC9; Sun, 11 Apr 2021 18:23:46 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 3131E8B75B;
        Sun, 11 Apr 2021 18:23:46 +0200 (CEST)
Subject: Re: sysctl: setting key "net.core.bpf_jit_enable": Invalid argument
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>
Cc:     it+linux-bpf@molgen.mpg.de, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <412d88b2-fa9a-149e-6f6e-3cfbce9edef0@molgen.mpg.de>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <d880c38c-e410-0b69-0897-9cbf4b759045@csgroup.eu>
Date:   Sun, 11 Apr 2021 18:23:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <412d88b2-fa9a-149e-6f6e-3cfbce9edef0@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 11/04/2021 à 13:09, Paul Menzel a écrit :
> Dear Linux folks,
> 
> 
> Related to * [CVE-2021-29154] Linux kernel incorrect computation of branch displacements in BPF JIT 
> compiler can be abused to execute arbitrary code in Kernel mode* [1], on the POWER8 system IBM 
> S822LC with self-built Linux 5.12.0-rc5+, I am unable to disable `bpf_jit_enable`.
> 
>     $ /sbin/sysctl net.core.bpf_jit_enable
>     net.core.bpf_jit_enable = 1
>     $ sudo /sbin/sysctl -w net.core.bpf_jit_enable=0
>     sysctl: setting key "net.core.bpf_jit_enable": Invalid argument
> 
> It works on an x86 with Debian sid/unstable and Linux 5.10.26-1.

Maybe you have selected CONFIG_BPF_JIT_ALWAYS_ON in your self-built kernel ?

config BPF_JIT_ALWAYS_ON
	bool "Permanently enable BPF JIT and remove BPF interpreter"
	depends on BPF_SYSCALL && HAVE_EBPF_JIT && BPF_JIT
	help
	  Enables BPF JIT and removes BPF interpreter to avoid
	  speculative execution of BPF instructions by the interpreter


Christophe
