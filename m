Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38361157AF
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 20:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfLFTSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 14:18:51 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44119 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfLFTSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 14:18:49 -0500
Received: by mail-pf1-f193.google.com with SMTP id d199so3804720pfd.11;
        Fri, 06 Dec 2019 11:18:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:to:cc:cc:cc:subject
         :references:in-reply-to;
        bh=gv9fsA6Ao/pebDnTI1hmSbmmPR6XS0w88Vxh8VJ2D7U=;
        b=RpTaUzRZvghYPxU0ZAERA+PqOQ5ObyBJk5E4gvl76rNbfS4L7RyCU/9y/5G7NxsXxh
         w0YNElLtCdza4X+tgG0RbVJMHAQHlZERO1P0mDvVWrgJF9Yy2uI+ULqmvmiXqYNgqraV
         i1E/VbUeyydz5WEUNrapWI/NxrqxyvgA/lc6GsqOhdh/VakTN2v4BnuxYXzNOI2vMFN+
         /BFyu7OTZIxFMffR3f5x09QGtIEuES1n2QjlSvL9QpW9KyV6mwGFlLBMOargsNTIskkE
         JoX8eYU1Xb9txqRdsXuWkpAwGXUFyIPmhIF6bL/Fbu61GIvIDYVUadJnIIl6v+twzkVO
         ziiA==
X-Gm-Message-State: APjAAAXVZqxZPfn671wg30zsC3OnWQk0g/9PyYJagqykgMB63+V5wPAR
        1OIlzzRotTdkW7WWo4Bmqqk=
X-Google-Smtp-Source: APXvYqyvoLWWIxFLFCrxMQlx3rIouun1f9/M6m8GVOeFSgwMyLKkc5DixpR+L8+xuyX/dZYgb0ZBHg==
X-Received: by 2002:a63:4b52:: with SMTP id k18mr5207178pgl.371.1575659928396;
        Fri, 06 Dec 2019 11:18:48 -0800 (PST)
Received: from localhost (MIPS-TECHNO.ear1.SanJose1.Level3.net. [4.15.122.74])
        by smtp.gmail.com with ESMTPSA id z26sm15634408pgu.80.2019.12.06.11.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 11:18:47 -0800 (PST)
Message-ID: <5deaa997.1c69fb81.4d5ed.a377@mx.google.com>
Date:   Fri, 06 Dec 2019 11:18:47 -0800
From:   Paul Burton <paulburton@kernel.org>
To:     Alexander Lobakin <alobakin@dlink.ru>
CC:     Paul Burton <paulburton@kernel.org>
CC:     Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org
CC:     linux-mips@vger.kernel.org
Subject: Re: [PATCH mips-fixes] MIPS: BPF: eBPF JIT: check for MIPS ISA compliance  in Kconfig
References:  <20191206080741.12306-1-alobakin@dlink.ru>
In-Reply-To:  <20191206080741.12306-1-alobakin@dlink.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Alexander Lobakin wrote:
> It is completely wrong to check for compile-time MIPS ISA revision in
> the body of bpf_int_jit_compile() as it may lead to get MIPS JIT fully
> omitted by the CC while the rest system will think that the JIT is
> actually present and works [1].
> We can check if the selected CPU really supports MIPS eBPF JIT at
> configure time and avoid such situations when kernel can be built
> without both JIT and interpreter, but with CONFIG_BPF_SYSCALL=y.
> 
> [1] https://lore.kernel.org/linux-mips/09d713a59665d745e21d021deeaebe0a@dlink.ru/

Applied to mips-fixes.

> commit 3721376d7d02
> https://git.kernel.org/mips/c/3721376d7d02
> 
> Fixes: 716850ab104d ("MIPS: eBPF: Initial eBPF support for MIPS32 architecture.")
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
> Signed-off-by: Paul Burton <paulburton@kernel.org>

Thanks,
    Paul

[ This message was auto-generated; if you believe anything is incorrect
  then please email paulburton@kernel.org to report it. ]
