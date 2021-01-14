Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399682F59BE
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbhANEDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbhANEDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 23:03:13 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BBFC061575;
        Wed, 13 Jan 2021 20:02:33 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id o19so6136256lfo.1;
        Wed, 13 Jan 2021 20:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9zbOPoIi8TSOltOZ0lasCpcW26irh6vW30Vtu7ZvdrI=;
        b=G9sHLPMOqgptKAZS7dyKhCRBvPXAF/JLHLzc5XarOLYayClSxWpLZP/mp068zjZle2
         aJcguZB3t6UBWMYVPEYMNyp1HuNMOcXIDpUSuTUWmVo4L6RZiayW+HEMgtMkuQloc+wE
         el14WFuLdU8mz6IJwsjhjIGkQ5DhPnEdUdQf0Jde00BtZQkjscj1PFJPUG8tSAvJ9T6N
         nuiivM3yqX/7Md0SPfFxmk/A/n9ZKMvYw1kMCvdvM5yJsBBWMieL22QlpHT1SX7LJ0HL
         XcKEXc4diPe5SIc3wn46C8a0NUUGlEBsKABT8FyrsQhPGDhaIa+BOxyKuP6DA6rdI5Tu
         j4dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9zbOPoIi8TSOltOZ0lasCpcW26irh6vW30Vtu7ZvdrI=;
        b=LhcVK+QsFFM5pbvvZ8XajRrdWSUwCgGgIW4cnMdWdKNm/ivVJvDuC/TfVBYcx/5FVg
         Fxa+H8SP2BNpakaRvCxcUOo1FdsBmTL0WHi7UQgMxDmyhVEw0PRIFlWbe2TeSeIQ6r+t
         NNCy2FYiuENIp/f6ZHIQ5Jg1ThgHXhORqUmzhxAq+cNHQ2/QdxBPFrJq/FfbS9lMawmz
         0oYWJgpffyMm5903SYk0OTE0ZTXyJmRWO9oc6hX5l7GAL2gWNpij80IbmYBzS+wie32J
         5I212uKjSK7bIdXdFqNkVgGHqmTVC1+W2lFGiDj/yu/eimCYfq3fFYMA1kh5Scf6K4wD
         xtmA==
X-Gm-Message-State: AOAM533r6mo2XiR62WwIxrHo89gpZyA1kHzpVJLyq3aKZMt1UjVxyCT7
        Lhjf9aB1Z2GNn8q8kDR/lO3+7rulIIDGnPcFMQw=
X-Google-Smtp-Source: ABdhPJzyqXQ9gidEN7na/gmJki+J0SdAv0wEhwst9rBKLK8u89tJETmG4Y1lxAZjEgtbBVxwY1gtFE8zlMwJs71GVKc=
X-Received: by 2002:ac2:43c1:: with SMTP id u1mr2488353lfl.38.1610596951899;
 Wed, 13 Jan 2021 20:02:31 -0800 (PST)
MIME-Version: 1.0
References: <20210113053810.13518-1-gilad.reti@gmail.com> <CACYkzJ5o7QBR1stFTqxGJv2gbS0qsVKZW6BJ3iBUagy5_S+N0w@mail.gmail.com>
In-Reply-To: <CACYkzJ5o7QBR1stFTqxGJv2gbS0qsVKZW6BJ3iBUagy5_S+N0w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 13 Jan 2021 20:02:20 -0800
Message-ID: <CAADnVQKF=bEzc6UjaSCAyE6dUXsYRXcQe4qBBBczyr75HyVL8A@mail.gmail.com>
Subject: Re: [PATCH bpf v2 1/2] bpf: support PTR_TO_MEM{,_OR_NULL} register spilling
To:     KP Singh <kpsingh@kernel.org>
Cc:     Gilad Reti <gilad.reti@gmail.com>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 2:29 PM KP Singh <kpsingh@kernel.org> wrote:
>
> On Wed, Jan 13, 2021 at 6:38 AM Gilad Reti <gilad.reti@gmail.com> wrote:
> >
> > Add support for pointer to mem register spilling, to allow the verifier
> > to track pointers to valid memory addresses. Such pointers are returned
> > for example by a successful call of the bpf_ringbuf_reserve helper.
> >
> > The patch was partially contributed by CyberArk Software, Inc.
> >
> > Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
> > Suggested-by: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Gilad Reti <gilad.reti@gmail.com>
>
> Acked-by: KP Singh <kpsingh@kernel.org>

It's a border line feature vs fix.
Since the patch is trivial and it addresses a real problem I've
applied to the bpf tree.
Thanks!
