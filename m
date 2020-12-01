Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B6C2C94BA
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 02:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389237AbgLABei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 20:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731244AbgLABeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 20:34:37 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C93BC0613D3;
        Mon, 30 Nov 2020 17:34:16 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id j10so21355110lja.5;
        Mon, 30 Nov 2020 17:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Egg3a2e1qL7qHV5/zndxmywrtc1Vhd90TaMCylEAOPM=;
        b=c4jNl/vOrbvPoVQZ7Xg6bXnn0aT1+uUk7cwgfX3heil7AAuamwXxV2VDzoPV6alTuL
         G+5yE0/yZ1m8OCqA/j4p14R0FScZxIW+GLt6iWe6OtXC2h1tyxIJp3EWKhIHcutI8AhJ
         PGijmPmSyN2sToWxpolbs2PiqG85lS6G2CpXk5n4cXrB9w1Hlpj24mUgWk6+pWShI3PO
         JNd21m8jHLnRRIsQDJVQP6l6hYtLBBz5ViyoDfPNaeL8SyVJnBWjP0XTchKL/TzSp0be
         ut/WVYR49oQ5Uj9YRBRjtG/X+v9Gn9DoRzde3h3tCzWEpN8V3S4Ws7SaHLGAal2TiNaE
         kQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Egg3a2e1qL7qHV5/zndxmywrtc1Vhd90TaMCylEAOPM=;
        b=MAmV8PNzSmZlBtUeDUR5FsEQTwqQ4bBW8SjtOFhccnuXQJ5S2vOjQj2Fzjd31ynova
         q0UdWECiPR4NulsEAqCYTfSA9DZh09vEWZ/qIkCdPTM61Gugdbex3bf7OQxCc2xc2Jgc
         QsG1vuOgheE7dGz6FCtWt/klLUR4WcC6Osjbtx9BSzFlrxmeWB7BckD39HMwEz1RwXj3
         wah81KT1cFGnkb8ZKptZKTGMux6aK6gFCG7OMUyywiEQFjLrAILH4/HJzhVbmmtFg0PM
         hFaDu4VBXUpIeLLJFVnRaTxaeS21QhsAJSRTeUKF91LND6V8qW0T/cd4fmpbd+ynOM4w
         LQsA==
X-Gm-Message-State: AOAM533YPNrCOwQH6mYwcLTVBUoYFLzIRiIzmewtnIVCvmGUBEE8hnds
        QPe4JZLda0EigpL1cPK6mfVve+J/Qpz4eGjCCifHO5BD5io=
X-Google-Smtp-Source: ABdhPJxFyuboyheRu1v0trFV8xP1NmEzayfDb4MOT31NWlAFAwmoUCW+Bujmaa+I1oxzs45TOd7N2RiKbXCWA1waUNo=
X-Received: by 2002:a2e:9681:: with SMTP id q1mr194239lji.2.1606786454761;
 Mon, 30 Nov 2020 17:34:14 -0800 (PST)
MIME-Version: 1.0
References: <20201201000339.3310760-1-prankgup@fb.com> <20201201000339.3310760-2-prankgup@fb.com>
In-Reply-To: <20201201000339.3310760-2-prankgup@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 30 Nov 2020 17:34:03 -0800
Message-ID: <CAADnVQJK=s5aovsKoQT=qF1novjM4VMyZCGG_6BEenQQWPbTQw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Adds support for setting window clamp
To:     Prankur gupta <prankgup@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 4:07 PM Prankur gupta <prankgup@fb.com> wrote:
>
> Adds a new bpf_setsockopt for TCP sockets, TCP_BPF_WINDOW_CLAMP,
> which sets the maximum receiver window size. It will be useful for
> limiting receiver window based on RTT.
>
> Signed-off-by: Prankur gupta <prankgup@fb.com>
> ---
>  net/core/filter.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2ca5eecebacf..cb006962b677 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4910,6 +4910,14 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>                                 tp->notsent_lowat = val;
>                                 sk->sk_write_space(sk);
>                                 break;
> +                       case TCP_WINDOW_CLAMP:
> +                               if (val <= 0)
> +                                       ret = -EINVAL;

Why zero is not allowed?
Normal setsockopt() allows it.

> +                               else
> +                                       tp->window_clamp =
> +                                               max_t(int, val,
> +                                                     SOCK_MIN_RCVBUF / 2);
> +                               break;
>                         default:
>                                 ret = -EINVAL;
>                         }
> --
> 2.24.1
>
