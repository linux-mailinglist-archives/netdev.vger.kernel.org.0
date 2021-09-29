Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F4D41CDEC
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346889AbhI2VSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbhI2VSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 17:18:54 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD9DC06161C;
        Wed, 29 Sep 2021 14:17:13 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id g2so3060201pfc.6;
        Wed, 29 Sep 2021 14:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ULTC7uFCOb8co9nVQnkd69sN3DLPbqoM7kYoB4W6cDo=;
        b=lm3kthFnazHXttVvxmdnJ2lpddbf2XDDyEtVHiu5kq5+E/TNrxO3zShoJxK27vGl5M
         hLkZkRTMLcuesvn+vFn4Ge75LG4H7FLCIN7FbUOH8nZU+A/OTkRnJ0PI+ci6nlJLkbFe
         1bBqwdJex2HHw3sywCY1BZuTJT+y6lXovyxKl9FywmFBwmQ25E/FgXRnZfHhc+Rw6yu4
         xNJTkuF81lzc2+IdHEn+mmmAstIfe4vSEgy1YJcV8EakedVVyWgvQJVx2YThuDmFwz65
         FPShZHE0KdPj/BpB4vvhSqMznDCAy+TqnEGtK3aS7y7GiqH875fT8GQhmGE0mo0/7flf
         n5vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ULTC7uFCOb8co9nVQnkd69sN3DLPbqoM7kYoB4W6cDo=;
        b=5jcfcSHpZQOdq2P4mWrs8SMfyix7IoLQ662uO2X50BkEZdUTShsH88iY9m4WrUJevP
         Vox0JQib3+djz/eHlEVjA5AcZFB014Uah/2loZ2/EVSU7SlwLET/fgt4IOcEDHFdJ9b5
         KHpgCBaKXMu2n3+dVii22er6snvrtipgo/tUbbYvnyz+Gh5aoYW9pJ4fYgQaRD8mwVXQ
         mmgov9wBKoazoBfGy7hJsIukVYsLnuMi7Pyypuq69LEOM3Iwezqi2x65AzXb7/jGLMf5
         4U/K0gB63/rO3MJ/NRJZ3zSIUt1UBCidbXxWIR7caf2E4P989IP937VPEsp6pAzyyEBn
         I09Q==
X-Gm-Message-State: AOAM533BG0fEkXm232iGFxeySgyZwgHaqoDLuO8TWlXki6TQ1oIo/zCs
        JSnHJvl3Px5I6Y76twmO6v/fY+zOTsxsJKg1Jxc=
X-Google-Smtp-Source: ABdhPJxK7Y+GYLhrsVzMbbLmfBk8/ATnKnMWoKns7LcaEVHzKqcybRRET83y8SkXgeSPrXDx6tUoyQPsY5quo84VXc4=
X-Received: by 2002:a63:374c:: with SMTP id g12mr1778357pgn.35.1632950232758;
 Wed, 29 Sep 2021 14:17:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210928093100.27124-1-lmb@cloudflare.com>
In-Reply-To: <20210928093100.27124-1-lmb@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Sep 2021 14:17:01 -0700
Message-ID: <CAADnVQ+UJ5bhRNdnHM62_XFzMp3q1-Njh80ZNvs=4=PH1jAmpw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: do not invoke the XDP dispatcher for
 PROG_RUN with single repeat
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 2:31 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> We have a unit test that invokes an XDP program with 1m different
> inputs, aka 1m BPF_PROG_RUN syscalls. We run this test concurrently
> with slight variations in how we generated the input.
>
> Since commit f23c4b3924d2 ("bpf: Start using the BPF dispatcher in BPF_TEST_RUN")
> the unit test has slowed down significantly. Digging deeper reveals that
> the concurrent tests are serialised in the kernel on the XDP dispatcher.
> This is a global resource that is protected by a mutex, on which we contend.
>
> Fix this by not calling into the XDP dispatcher if we only want to perform
> a single run of the BPF program.
>
> See: https://lore.kernel.org/bpf/CACAyw9_y4QumOW35qpgTbLsJ532uGq-kVW-VESJzGyiZkypnvw@mail.gmail.com/
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>

Applied. Thanks
