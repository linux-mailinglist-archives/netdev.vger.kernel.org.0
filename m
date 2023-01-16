Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9C266BE9A
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjAPNE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjAPNDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:03:08 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90C81715;
        Mon, 16 Jan 2023 05:02:02 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id m6so42604691lfj.11;
        Mon, 16 Jan 2023 05:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YrxM2ma2ZBYDAq8s9CbIufpSBlUgpo5/Z8BF4LzI+dI=;
        b=YWOsj91Cdx+vve1qMtvqCAsHCzRWC+owVcTseZ+Cu5FIfKE/pGRHdqHAZR4VaS7B82
         l/Tk2ISKj6d8rC0Ju0DTj4fdwWVBqtuJpgACObjR62/u5p4Pvgcpqh7gul2GAw764wwb
         v6GLxMTRnMq/dL6z1dxNj2gEmfua9c9wFh3LzGIPsK7Nj0Xr9WiSbPaYz12rXfe6XZ5l
         IOKIyUhZ5df6L0zQ+zSoJnVQj5wKyRullKwViFHan5SX8Oy88CPxr2BNc5anvbLvwrBd
         B35ODD33KBUddqN7He+CdzCPM9TArlTXCllil31Kym9zp/RlhksCbqu0IaaQo9AUKoaG
         6wiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YrxM2ma2ZBYDAq8s9CbIufpSBlUgpo5/Z8BF4LzI+dI=;
        b=IdTXwdhJMIgKW4xVue8JPB8mCEIUCbxxFy7vg7bYtXSfQfkFxAcbufeUdsjrcMK7yP
         htd/Rlw2S4Kg2Qv94e3R/+STMa9vs6dHiOFjtATgg0yr8zoWzB/Mcyuhz5wkGLjFrLO8
         4UKA94sIP+ARZx69xYBb/v+HMUvSZGvkorCpx6yx0f6G8COyMZMUog+LwnbiVVDuNtGg
         zId2qw+HIeHLZwkiNIJmeQ/RUKV7SXFE82cxCDMAWSqkAmXvNuNXw9UwH/0HN+bPdPZt
         AiWJ3nxHHxNyFU7f3C0kxOxM5Xt7pgOx++j/OtDGOWXWsaemZN1UGl+deLAfkd5bSXB2
         jNZA==
X-Gm-Message-State: AFqh2koXCIZHWJnYouJvqP4lLeKr5o9PpZRAKxA6RRzSJMysLQNGJsB/
        X/WOl36K0pNYM+TpMe7NP4bTQ6//K/S0Gey8fQ==
X-Google-Smtp-Source: AMrXdXtBAwhXyozmm5Hfdl21UHbZnX6dXXmqkwTW5SCS5ChQGa+p0lTocTSFrJXf5Ls836hlgXE99KSinyhO4lPH7Qk=
X-Received: by 2002:a05:6512:2812:b0:4c5:3861:ee94 with SMTP id
 cf18-20020a056512281200b004c53861ee94mr3844592lfb.260.1673874120972; Mon, 16
 Jan 2023 05:02:00 -0800 (PST)
MIME-Version: 1.0
References: <20230115071613.125791-1-danieltimlee@gmail.com> <CAADnVQ+zP5bkjkSa97k+dK7=NabkdoLWQtZ1qRwRTUQgGdqhVA@mail.gmail.com>
In-Reply-To: <CAADnVQ+zP5bkjkSa97k+dK7=NabkdoLWQtZ1qRwRTUQgGdqhVA@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Mon, 16 Jan 2023 22:01:43 +0900
Message-ID: <CAEKGpzgzxabXqUKXz4A-dYx6B05vbDkGELadRDBnbCF_hLxMAQ@mail.gmail.com>
Subject: Re: [bpf-next 00/10] samples/bpf: modernize BPF functionality test programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 6:38 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Jan 14, 2023 at 11:16 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Currently, there are many programs under samples/bpf to test the
> > various functionality of BPF that have been developed for a long time.
> > However, the kernel (BPF) has changed a lot compared to the 2016 when
> > some of these test programs were first introduced.
> >
> > Therefore, some of these programs use the deprecated function of BPF,
> > and some programs no longer work normally due to changes in the API.
> >
> > To list some of the kernel changes that this patch set is focusing on,
> > - legacy BPF map declaration syntax support had been dropped [1]
> > - bpf_trace_printk() always append newline at the end [2]
> > - deprecated styled BPF section header (bpf_load style) [3]
> > - urandom_read tracepoint is removed (used for testing overhead) [4]
> > - ping sends packet with SOCK_DGRAM instead of SOCK_RAW [5]*
> > - use "vmlinux.h" instead of including individual headers
> >
> > In addition to this, this patchset tries to modernize the existing
> > testing scripts a bit. And for network-related testing programs,
> > a separate header file was created and applied. (To use the
> > Endianness conversion function from xdp_sample and bunch of constants)
>
> Nice set of cleanups. Applied.
> As a follow up could you convert some of them to proper selftests/bpf ?
> Unfortunately samples/bpf will keep bit rotting despite your herculean efforts.

I really appreciate for your compliment!
I'll try to convert the existing sample to selftest in the next patch.

-- 
Best,
Daniel T. Lee
