Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C76E1C1E17
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 21:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgEATxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 15:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgEATxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 15:53:51 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C75BC061A0C;
        Fri,  1 May 2020 12:53:51 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id l11so4692858lfc.5;
        Fri, 01 May 2020 12:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eLkHCYTX65FanCUz3FGo9DHm9M6l7fkrFEW0FMC5F38=;
        b=lrWTXLI3amZbQ6VrK6hi4UcxorzKUPWacsUmgIyCL7+dSJHnqKcalh/nRBjw77Rw5C
         pb6uB83edUMxnrnL4aNbxCyx68qGBmoXSCP3WsQ9q1TqsuPC53V1rb3QjVGpPL7K7TtB
         3/e4RFZ5VzGFgIgT5iQzByeARX8x18y/z7Is/NCp1TKVBtQrXCutrnqwhskxAnzS/90h
         DlnJ0VrRVfGT70JKVCT7W4D9N4rco40vzdAdNoXaPuo+FbgCgxo4l/S/B5fPf4vexMvZ
         i5r20aK0edLDW2EM54hF4tjhdY3Fv4KIQfjYKlCMfjS+AQ+XObKhp0Z/4uRB05iuiqGL
         fvzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eLkHCYTX65FanCUz3FGo9DHm9M6l7fkrFEW0FMC5F38=;
        b=qYqZPtZPKvQQaWgZCdoxI8qUuR4t1BbJ2ft236NCxxEBo13cgf3eTN13cA2mn0TpMS
         R2MUmnebjfFFfOvOq5j4GK6JnbbXvYUaH1aj32zFMEMB80lCWmuQuopR2umRHu9qLj9w
         vkb4xdPYaT7sk9sTa49z3nT70ScUZ5cKBntakU86VVOn8HFEgB/KtbBri6x+GUeBUtu6
         71wxaZY/5XScX7VIuS9SLIFFTIeQ3bMJn1Lpp/8LsMZxl3cgrx91P5sM/iIFY+8DlaYi
         mCBZXGQdUVX7pyJv9n2BUwbpPwNPtwT1z+gLSGlvgnNMJZ7b/tmVJ1bEGVCyWXhsrqJA
         KNCA==
X-Gm-Message-State: AGi0PuYyEJ00L80AJquvUUmrd1pgmWr91wxGuphWGELTrPiGCQ73D9p+
        nTYVTznhzUruty40DMmL7Y9v5N/47w9iYk8gFbw=
X-Google-Smtp-Source: APiQypKarPZIn17Dqxjm7lbKIn7nz/O1si92DdMxBzYGW9+hPUO3PAiY46HAt4//L5RpaBW4qUHBU3RcT0cevptzXFs=
X-Received: by 2002:ac2:5235:: with SMTP id i21mr3469858lfl.73.1588362829634;
 Fri, 01 May 2020 12:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200430233152.199403-1-sdf@google.com> <5eac6b6252755_2dd52ac42ee805b8c9@john-XPS-13-9370.notmuch>
In-Reply-To: <5eac6b6252755_2dd52ac42ee805b8c9@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 1 May 2020 12:53:37 -0700
Message-ID: <CAADnVQK0Jtr3+nvOgWxmtBD2SQE2YhYbNJPMWw-7n219vy_4+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] bpf: bpf_{g,s}etsockopt for struct bpf_sock_addr
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 1, 2020 at 11:33 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Stanislav Fomichev wrote:
> > Currently, bpf_getsockopt and bpf_setsockopt helpers operate on the
> > 'struct bpf_sock_ops' context in BPF_PROG_TYPE_SOCK_OPS program.
> > Let's generalize them and make them available for 'struct bpf_sock_addr'.
> > That way, in the future, we can allow those helpers in more places.
> >
> > As an example, let's expose those 'struct bpf_sock_addr' based helpers to
> > BPF_CGROUP_INET{4,6}_CONNECT hooks. That way we can override CC before the
> > connection is made.
> >
> > v3:
> > * Expose custom helpers for bpf_sock_addr context instead of doing
> >   generic bpf_sock argument (as suggested by Daniel). Even with
> >   try_socket_lock that doesn't sleep we have a problem where context sk
> >   is already locked and socket lock is non-nestable.
> >
> > v2:
> > * s/BPF_PROG_TYPE_CGROUP_SOCKOPT/BPF_PROG_TYPE_SOCK_OPS/
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
>
> To bad we had to fall back to ctx here.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Applied. Thanks
