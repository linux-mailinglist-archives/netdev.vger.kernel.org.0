Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5814449DA25
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 06:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiA0F1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 00:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbiA0F1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 00:27:20 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46166C061759;
        Wed, 26 Jan 2022 21:27:20 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id t14so2592743ljh.8;
        Wed, 26 Jan 2022 21:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+KZw77VTbGx/ikpYyZi7X6MiCrJcShG0V+WSry482T8=;
        b=dzSFOALU/Ev8NqSL+YoaI4j2UbcbpKbKfbKKBC9cZSiuuoFLENU8JOjpdOl3gkvP1s
         4YAZCm6Tr4G+mWjnNFrwwx7M+4bd3E0rDmzycT2encIQw4zbvlxWB/t6gKU1y+Ehvmqf
         OhImPbmDt6SjIiK+ZFZdAOe/Gvp3zDu+wVf2vBeE5ZS94lU5YGz/YVsbZWPF7GXjTejd
         dFoOv/rOz6iZZWdquw+26zpXPFV9sS1fuq1OOj41ngNVcDgKMnc9v2dNYHTzXRAhGdp5
         9ZcbtXDH3v1mtB12V9sb4dFJzFCuNLtZc57FGu4NuCf+i69vWrpeV4HACt/zTgck7lFx
         0FvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+KZw77VTbGx/ikpYyZi7X6MiCrJcShG0V+WSry482T8=;
        b=3F7nYpw08ZcjMgbO2iV1ci/c8glzaGam5OfCGGQNFEvMbV5KcrntyEQ5hvUGNqLWlD
         Wzzj2QeS6iY6xn3DRVtxHkdDQNRXQLpjXh0jrULIgcPlHtOvOCHQfGkmqXTyJi2p0avn
         qkeHTy/m0IA7hXWnx9O2q9nQlyppoDVKXRxJPV0++2O74eSEoaRPQ9BaHo3uBqOVtRAE
         EYlaorK4cx20113yredlhyRuX9stjZJX2esJcRGNlrZ9klec0v3gaw3JWbB9OSetJgW8
         hayTIxFIC6GG672uWSMaDuCVUL2n2qUQ+X0rI2eBzTHnGa9U/2KtVyURKsF7AAiSQRqS
         5pnA==
X-Gm-Message-State: AOAM5330NpYbhb7ajFbVB9uXkXvNp5JBm4stSz+IZXkPWQY8BMQh2W8p
        K23yQKUCejOT7Ug6xfUrLKY6HI8uUIgYwWVCPi3k0kjuIpc=
X-Google-Smtp-Source: ABdhPJy2eFOKlfpEnZ8mDxP6SzukivBLS6Sa7oh1Z52Hi5Pnx4tZXEGYVb/y7R+qgf2Dl1kJ84XCveyX4OKFokZZBx8=
X-Received: by 2002:a2e:9c06:: with SMTP id s6mr1718467lji.450.1643261238541;
 Wed, 26 Jan 2022 21:27:18 -0800 (PST)
MIME-Version: 1.0
References: <20220125081717.1260849-1-liuhangbin@gmail.com> <20220125081717.1260849-8-liuhangbin@gmail.com>
In-Reply-To: <20220125081717.1260849-8-liuhangbin@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Wed, 26 Jan 2022 21:26:42 -0800
Message-ID: <CALDO+SbNpOjYOdDWT9M5-_ZY9HpMDiFgTkQospu38YY_GZuEBg@mail.gmail.com>
Subject: Re: [PATCH bpf 7/7] selftests/bpf/test_xdp_redirect: use temp netns
 for testing
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 12:18 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Use temp netns instead of hard code name for testing in case the
> netns already exists.
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
LGTM
Acked-by: William Tu <u9012063@gmail.com>
