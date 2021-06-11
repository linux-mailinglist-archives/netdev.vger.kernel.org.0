Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726B03A43EE
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 16:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhFKOVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 10:21:20 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:51050 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbhFKOVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 10:21:14 -0400
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jun 2021 10:21:14 EDT
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4G1jR31TRzz1qt3l;
        Fri, 11 Jun 2021 16:10:07 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4G1jR26D3Sz1r0ws;
        Fri, 11 Jun 2021 16:10:06 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id blSMxjRTcGUs; Fri, 11 Jun 2021 16:10:04 +0200 (CEST)
X-Auth-Info: dkbXKa2FuB4b08eUrov5kSul9UpeLtIdhCkDN2zB3p004oJgCtYlXEmO7oD1pnrg
Received: from igel.home (ppp-46-244-189-84.dynamic.mnet-online.de [46.244.189.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 11 Jun 2021 16:10:04 +0200 (CEST)
Received: by igel.home (Postfix, from userid 1000)
        id 01ABD2C365F; Fri, 11 Jun 2021 16:10:03 +0200 (CEST)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?utf-8?B?IEJqw7ZybiBUw7ZwZWw=?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 7/9] riscv: bpf: Avoid breaking W^X
References: <20210330022144.150edc6e@xhacker>
        <20210330022521.2a904a8c@xhacker>
X-Yow:  Look!!  Karl Malden!
Date:   Fri, 11 Jun 2021 16:10:03 +0200
In-Reply-To: <20210330022521.2a904a8c@xhacker> (Jisheng Zhang's message of
        "Tue, 30 Mar 2021 02:25:21 +0800")
Message-ID: <87o8ccqypw.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mär 30 2021, Jisheng Zhang wrote:

> From: Jisheng Zhang <jszhang@kernel.org>
>
> We allocate Non-executable pages, then call bpf_jit_binary_lock_ro()
> to enable executable permission after mapping them read-only. This is
> to prepare for STRICT_MODULE_RWX in following patch.

That breaks booting with
<https://github.com/openSUSE/kernel-source/blob/master/config/riscv64/default>.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
