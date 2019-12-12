Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E088211C1A0
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 01:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfLLAto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 19:49:44 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45529 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbfLLAto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 19:49:44 -0500
Received: by mail-lj1-f193.google.com with SMTP id d20so217294ljc.12;
        Wed, 11 Dec 2019 16:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XaJpQ0s9fCLALk3Anux7ZDOeylMYTEb/MmGNUp3gxgg=;
        b=iz6cwI3NnEFQ/nc4wDmvIhGAH5/rtbn0DnFDpnr95ryInFlEJW04Aq1AR9H9Scd9uO
         PUPXMWdavBWWxDojMTGQX/IohIsy5cLTpeEz0xcQDUg19AFC4kqX/4UIEegzaLVPPCPn
         Q3JnP56j9h5pZYeS5CWcoH2WtsgNgkBs8aCMZn7etYXVolJGk13R3cefpFum4cfLguns
         W6Dk0QUOD271xu/SE5Fe6IZDdf4H3aorLq6bwTblY0rtSBgm5saoal6PbIYByhyDn6wL
         6l9oHdw/o+SGlgjE4MRO9CX60xWWQScW0wyQP6LrYv2q3BArBvdlK9C+5ZznqMadyjt7
         xbIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XaJpQ0s9fCLALk3Anux7ZDOeylMYTEb/MmGNUp3gxgg=;
        b=fd4zi7YiYtFLdbDvoTLsuBm5e1lxCrnhLTwnXfNNeOq9xuVlmEKcwjEUacpznW6jMZ
         zgkWf4L9WA1sH7y8lYie1N8m+adSuGblmxqW4LkRaEIONHgYVRq53PSdhWOmdXBirm1U
         0VIAevzsnuSjV7tbk4s1B93tGW05ncuM84i2pMieCMIIQF9O6UMSarwddp7EoYqmxJ4L
         1FnosFgLyQMV0PVkZJIU2JdkdNyROQbe996ETqCxg0lrEuXMidMVYdT/uHEQpyy7s7p2
         ngDaFbsWxPfThLxwcQpnRE9LlisxWR+sPtvPrOtqmlIIkDrs9cpIeKyzkC/SxG1FQwnQ
         8wjg==
X-Gm-Message-State: APjAAAUhe+DKD60cYLhtLwbtUQo2w7KYUX9wOKt4pJ0BqV7sLjkptXHH
        hX7nF/cK3kszyvj4QjKhvUpQTAZeN+4AK0TqL89lbA==
X-Google-Smtp-Source: APXvYqyLIGEhs2LPUn/rPfV5CbAKqix9WbX9310KuMXKuCCz9X5tztOh9VfvP19WUF1lMJJYP7L3ESAFVkarV9b0rHc=
X-Received: by 2002:a2e:5850:: with SMTP id x16mr4136273ljd.228.1576111782297;
 Wed, 11 Dec 2019 16:49:42 -0800 (PST)
MIME-Version: 1.0
References: <f78ad24795c2966efcc2ee19025fa3459f622185.1575903816.git.daniel@iogearbox.net>
 <20191209170644.tgsqlwaei3cf7sgi@kafai-mbp>
In-Reply-To: <20191209170644.tgsqlwaei3cf7sgi@kafai-mbp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 11 Dec 2019 16:49:30 -0800
Message-ID: <CAADnVQ+p4J2ApHO+SBQY2-yy65yYR8uGCiMOPtZerouJZC2P7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf, x86, arm64: enable jit by default when
 not built as always-on
To:     Martin Lau <kafai@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 9, 2019 at 9:07 AM Martin Lau <kafai@fb.com> wrote:
>
> On Mon, Dec 09, 2019 at 04:08:03PM +0100, Daniel Borkmann wrote:
> > After Spectre 2 fix via 290af86629b2 ("bpf: introduce BPF_JIT_ALWAYS_ON
> > config") most major distros use BPF_JIT_ALWAYS_ON configuration these days
> > which compiles out the BPF interpreter entirely and always enables the
> > JIT. Also given recent fix in e1608f3fa857 ("bpf: Avoid setting bpf insns
> > pages read-only when prog is jited"), we additionally avoid fragmenting
> > the direct map for the BPF insns pages sitting in the general data heap
> > since they are not used during execution. Latter is only needed when run
> > through the interpreter.
> >
> > Since both x86 and arm64 JITs have seen a lot of exposure over the years,
> > are generally most up to date and maintained, there is more downside in
> > !BPF_JIT_ALWAYS_ON configurations to have the interpreter enabled by default
> > rather than the JIT. Add a ARCH_WANT_DEFAULT_BPF_JIT config which archs can
> > use to set the bpf_jit_{enable,kallsyms} to 1. Back in the days the
> > bpf_jit_kallsyms knob was set to 0 by default since major distros still
> > had /proc/kallsyms addresses exposed to unprivileged user space which is
> > not the case anymore. Hence both knobs are set via BPF_JIT_DEFAULT_ON which
> > is set to 'y' in case of BPF_JIT_ALWAYS_ON or ARCH_WANT_DEFAULT_BPF_JIT.
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied. Thanks
