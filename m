Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E16F1B5416
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgDWFSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726691AbgDWFSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 01:18:09 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336DCC03C1AB;
        Wed, 22 Apr 2020 22:18:09 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mq3so1952089pjb.1;
        Wed, 22 Apr 2020 22:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=X/bdaJ5V5H1KJbsw0eGlJwkvK434Nt04DtUI1ZecYLM=;
        b=lLzF5KkbfSTw9RNjqMYjexHclyBEVb2kpqk3pAlhJfOhkGFuL8B9H0LP+BdPU1z75z
         2d10ysdqeCrSYXQKDVBciRh2uJyOchU8KwXL7eJkBaYqtnYeosCUnIXRPflLWCuTcJM5
         rbsUTg6binJc1RpZtwfe04db8Cpsw9Yqdw5f1zB36AqxPeai14pwF+GHBO9dJcXODF0z
         t+2jvOpVF0swL2AUFoET/5H/EvlrkSFyseYJPhehGf2PTUq0PkdlYyLmjlfausxf865x
         UmuRMK90lsp7cuhIsBDZdcOMMSL4JUDjbeFoONMI0mcHlZ0RxvTDw1KBLQ8+sLCWrfdn
         9JjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=X/bdaJ5V5H1KJbsw0eGlJwkvK434Nt04DtUI1ZecYLM=;
        b=W/CPWGinDKkRj8u6ZTGjaMzBYctu9EXAkB+Jtumt5TAYqEmKXq4Z9az54Q7kp85Uey
         vyWJl1tytDK8j2S8xuBtzdXa3uMyWzvO99js/VKZV9I67z78Ue3pgL0qfudKcCQSZbFl
         8DUtl8SiTvYDqOJekRd6okbIw5mW+M+lnRrQZiDwU5mYCxsRg5Cw/HHC21FCEbAUMilL
         6b+YT4ZQy2vKjBl2Cq4cQJcRuZZpRsVW2IAQqi0KklpAqSFJ6uKTgn4SBTl9eBKN8eSe
         IGGVW71p7qAIlL7wYfSQhoy45wbeZehlHqyG1OSmo5GkFi6J5IBRZ1cLW6iQpA2gAUvp
         wd6Q==
X-Gm-Message-State: AGi0PuY+YEVdsKugEOAHikf+n2HMgQJGl+y113NH6PofcXcFiy5Wcj6P
        SHBhmw7UTJOmDBWo+04jDWY=
X-Google-Smtp-Source: APiQypJLLbaBcyZazQopL3aDYB6VLEH3ua/ifLN3oi85y/63+awgT+NPWSeukqaJAAkn1CF8R2cXOw==
X-Received: by 2002:a17:90a:de8d:: with SMTP id n13mr2283164pjv.173.1587619088742;
        Wed, 22 Apr 2020 22:18:08 -0700 (PDT)
Received: from udknight.localhost ([183.250.89.86])
        by smtp.gmail.com with ESMTPSA id k10sm1300719pfa.163.2020.04.22.22.18.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 22:18:07 -0700 (PDT)
Received: from udknight.localhost (localhost [127.0.0.1])
        by udknight.localhost (8.14.9/8.14.4) with ESMTP id 03N4rwl5003504;
        Thu, 23 Apr 2020 12:53:58 +0800
Received: (from root@localhost)
        by udknight.localhost (8.14.9/8.14.9/Submit) id 03N4rvmP003503;
        Thu, 23 Apr 2020 12:53:57 +0800
Date:   Thu, 23 Apr 2020 12:53:56 +0800
From:   Wang YanQing <udknight@gmail.com>
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf@vger.kernel.org, Brian Gerst <brgerst@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf v2 1/2] bpf, x86_32: Fix incorrect encoding in
 BPF_LDX zero-extension
Message-ID: <20200423045356.GB1153@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
        Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org,
        Brian Gerst <brgerst@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200422173630.8351-1-luke.r.nels@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422173630.8351-1-luke.r.nels@gmail.com>
User-Agent: Mutt/1.7.1 (2016-10-04)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 10:36:29AM -0700, Luke Nelson wrote:
> The current JIT uses the following sequence to zero-extend into the
> upper 32 bits of the destination register for BPF_LDX BPF_{B,H,W},
> when the destination register is not on the stack:
> 
>   EMIT3(0xC7, add_1reg(0xC0, dst_hi), 0);
> 
> The problem is that C7 /0 encodes a MOV instruction that requires a 4-byte
> immediate; the current code emits only 1 byte of the immediate. This
> means that the first 3 bytes of the next instruction will be treated as
> the rest of the immediate, breaking the stream of instructions.
> 
> This patch fixes the problem by instead emitting "xor dst_hi,dst_hi"
> to clear the upper 32 bits. This fixes the problem and is more efficient
> than using MOV to load a zero immediate.
> 
> This bug may not be currently triggerable as BPF_REG_AX is the only
> register not stored on the stack and the verifier uses it in a limited
> way, and the verifier implements a zero-extension optimization. But the
> JIT should avoid emitting incorrect encodings regardless.
> 
> Fixes: 03f5781be2c7b ("bpf, x86_32: add eBPF JIT compiler for ia32")
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Acked-by: Wang YanQing <udknight@gmail.com>
