Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919D51D3AA9
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 20:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbgENS6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728526AbgENS6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 14:58:15 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B56C061A0E
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 11:58:14 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id z22so3603410lfd.0
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 11:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RNZtOuZNCvXep73RZPyIzpAKoJOWSrLB4f/cVGJYlV4=;
        b=eBV96bd4k2zM+n+JyucLNP1MbLQqrKwMF5XNAcqJ2+4oKLsrDI25pVUkh5GqO+h92o
         NxGbZJC2jSf+drQKF30Zgpmjrf9P335BMpN8RHLu0bm/cvcyPa3hE9zwNLWLuNhxKp6f
         h3i6pJu7RNmRyb2ljEONon/Hni9mlshAkWUDo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RNZtOuZNCvXep73RZPyIzpAKoJOWSrLB4f/cVGJYlV4=;
        b=tC50CchWuz8qqgCjgOL3AYIjqTS6qW6J6aYy5dEB7b05+0aZeXiyTbLL6hKSJTpGGY
         gUVSJkHsyvj6yebBbWC+RR14qkfTGf1OChcpFu2QQkd4GraEI2IRrtR4HSt95NB75HRM
         j99FgnTHnmyVlQJsWuX04TFDO128G+sGUZQWhKQyyLVgZFGLzME2YttGKlzi0hdLcp6X
         FukgKH/69mS4GpeclpzNG7ct6FJPz5kiYX6K/Yp3ckcERFxIRoEuLob6+rrJ4SlZ4jff
         Eh1HMwbrfVvpDuirKI4mculXah9G4hXETfDM1/EN3t37clmYxw0o4Bq1E0OH0XBXwwyE
         nKqQ==
X-Gm-Message-State: AOAM531Btls+qnlgw9hOUeDZgN0uSOz3U9IpYdOskGmkwm73wyt2jSlB
        cPIZdzijzJs6Pf91hxpxuKdvGiFZvOs=
X-Google-Smtp-Source: ABdhPJxIi2O4EPXg+UfCUEefTqa1HkpAH8JZmxxIjAKLBsIx1yKGkn6pZW4pfPjgB7qSrQ5rnnoF/A==
X-Received: by 2002:a19:7004:: with SMTP id h4mr4030233lfc.148.1589482691987;
        Thu, 14 May 2020 11:58:11 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id r13sm1932568ljh.66.2020.05.14.11.58.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 11:58:11 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id j3so4700663ljg.8
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 11:58:10 -0700 (PDT)
X-Received: by 2002:a2e:87d9:: with SMTP id v25mr3625999ljj.241.1589482690395;
 Thu, 14 May 2020 11:58:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200514161607.9212-1-daniel@iogearbox.net> <20200514161607.9212-2-daniel@iogearbox.net>
In-Reply-To: <20200514161607.9212-2-daniel@iogearbox.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 14 May 2020 11:57:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wghQ5dr-56J7CrGR10_bAJsWNZvtHcrYnhVh-RvbPjW3Q@mail.gmail.com>
Message-ID: <CAHk-=wghQ5dr-56J7CrGR10_bAJsWNZvtHcrYnhVh-RvbPjW3Q@mail.gmail.com>
Subject: Re: [PATCH bpf 1/3] bpf: restrict bpf_probe_read{,str}() only to
 archs where they work
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        brendan.d.gregg@gmail.com, Christoph Hellwig <hch@lst.de>,
        john.fastabend@gmail.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 9:18 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> However, their use should be restricted to archs with non-overlapping
> address ranges where they are working in their current form. Therefore,
> move this behind a CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE and
> have x86, arm64, arm select it (other archs supporting it can follow-up
> on it as well).

Ack, looks sane to me.

               Linus
