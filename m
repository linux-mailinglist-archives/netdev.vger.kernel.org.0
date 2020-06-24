Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27387206930
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 02:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388159AbgFXAzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 20:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387757AbgFXAy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 20:54:59 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EB5C061755;
        Tue, 23 Jun 2020 17:54:59 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id d21so352928lfb.6;
        Tue, 23 Jun 2020 17:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SELmzgReg+iVHTahgJ6371+YxkQAf2+VAlTqmhfhQZo=;
        b=cjm1L/wqIptfZr5x8pU2JkKdOAtu7JqBjyEKy4fB44k9+UJuDN2Eq1lL7CkW8p5L85
         5vGpTmpgCkeeswMlvxMrNmFE57s/nxkGn948SblHhhnDX5O0TGMyuPpRWcEl/p0u5pNr
         usUcghxjxuQeNK87WSgwTIz55tpj8qYEwqxK8CqDN8SiwHQ9nMdP5m/C3CPyzTwm8wty
         dw3FZFwdtf85AbQTzTKfIFfMnxeXGo/Wr+fudv5aIK60EaWz7/+l6uXdX5OmHHR/GU5d
         9jzRaO2hatTE/vVE3Wbqh0kbuhO8/JY5jg1r7pN3xO/RazbA5GcpcbqPApqTVyBu/FIn
         z/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SELmzgReg+iVHTahgJ6371+YxkQAf2+VAlTqmhfhQZo=;
        b=F0xu9pmJ45BuPE42a/Z2djk/wNvsQNGmBnNm0BrDh1WZ34MNW+CfTci4hNF4wlYaxf
         S50r18EhlCzDEyoKHeiXY8PCq8ytstBrl6rzNN8hIRo+mnjiSsTLYjExFQNOjfFn4CQg
         jpYOXIFLorH2JOvgUmNrEJN3QISYn4zNbSP38oYqwJoTzvAfWXx4Ea40NblP3ag5IamD
         LfOXNzp2XUm/PdB3eyiiN82bKjErCCUq/JlxPEBSVu1G318+JvjaWlCNpPlGu6mc5piJ
         AlNLb9kMJ8hG4xJ9nackWbJZ5/KomVOR1gR/BOJtFTydKCkpUXDYvlVTFHbslTFa6gpI
         wvUw==
X-Gm-Message-State: AOAM5314LjFYDamuxR12+97bPsEvLlZPA9zLQGB2aIs+YcMBM8QpYfe4
        jSekVG9My8/bUnfenyw8bWFOV9dp4qsNc4Q02FevWg==
X-Google-Smtp-Source: ABdhPJzCSvOsbrXcmQd/TYWAgOjemkPC4Im/Bu/7EQrDLmukBVCfqTq30O8ThuYksFmuP216BQ761tc/uSzHOR5Cjmk=
X-Received: by 2002:a19:4143:: with SMTP id o64mr13922941lfa.157.1592960097892;
 Tue, 23 Jun 2020 17:54:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQ+BqPeVqbgojN+nhYTE0nDcGF2-TfaeqyfPLOF-+DLn5Q@mail.gmail.com>
 <20200620212616.93894-1-zenczykowski@gmail.com> <CALAqxLVeg=EE06Eh5yMBoXtb2KTHLKKnBLXwGu-yGV4aGgoVMA@mail.gmail.com>
In-Reply-To: <CALAqxLVeg=EE06Eh5yMBoXtb2KTHLKKnBLXwGu-yGV4aGgoVMA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 23 Jun 2020 17:54:46 -0700
Message-ID: <CAADnVQJOpsQhT0oY5GZikf00MT1=pR3vpCZkn+Z4hp2_duUFSQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2] restore behaviour of CAP_SYS_ADMIN allowing the
 loading of networking bpf programs
To:     John Stultz <john.stultz@linaro.org>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 12:44 PM John Stultz <john.stultz@linaro.org> wrote=
:
>
> On Sat, Jun 20, 2020 at 2:26 PM Maciej =C5=BBenczykowski
> <zenczykowski@gmail.com> wrote:
> >
> > From: Maciej =C5=BBenczykowski <maze@google.com>
> >
> > This is a fix for a regression introduced in 5.8-rc1 by:
> >   commit 2c78ee898d8f10ae6fb2fa23a3fbaec96b1b7366
> >   'bpf: Implement CAP_BPF'
> >
> > Before the above commit it was possible to load network bpf programs
> > with just the CAP_SYS_ADMIN privilege.
> >
> > The Android bpfloader happens to run in such a configuration (it has
> > SYS_ADMIN but not NET_ADMIN) and creates maps and loads bpf programs
> > for later use by Android's netd (which has NET_ADMIN but not SYS_ADMIN)=
.
> >
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Reported-by: John Stultz <john.stultz@linaro.org>
> > Fixes: 2c78ee898d8f ("bpf: Implement CAP_BPF")
> > Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
>
> Thanks so much for helping narrow this regression down and submitting thi=
s fix!
> It's much appreciated!
>
> Tested-by: John Stultz <john.stultz@linaro.org>

Applied to bpf tree. Thanks
