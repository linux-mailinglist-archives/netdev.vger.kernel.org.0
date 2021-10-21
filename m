Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0066F435823
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 03:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhJUBYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 21:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhJUBYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 21:24:51 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90771C06161C;
        Wed, 20 Oct 2021 18:22:36 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id k26so4457607pfi.5;
        Wed, 20 Oct 2021 18:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GRLMpz20W+uWjSSx3JO2MLjsrcVU2TkHeUAxLEmJB58=;
        b=R3SUN5E4mDf3iv5WJwjMQdSDM5mATS7L6fZHzSHe+IBMasEJ/Skwfld6uw08RE2dcm
         Wn4Nl6EKnHup9cBEeoC0bugXURgBysYenN2rJIb4i+hN+i2wLLuATTGkWYVTfyO7ldhO
         RHWs4d+LMbrAwKh2zhrmjsOMmN+i66Y436NntymrMczeRQLQntR4L69eWFXD2vowRncc
         0WvweQzeqCMOqOY/lhpC0b8Y9Wx3KJMmjexUZJpolM1Cm5pkG0LTzQEKPGYwVxYfSnz2
         xJibmt2ut51V0ez9w9pfNXrII/JzI8TvL1HDc81hvi6etz7eIv/NsEnVTqXWL986MobG
         Y32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GRLMpz20W+uWjSSx3JO2MLjsrcVU2TkHeUAxLEmJB58=;
        b=be5LHpFcA2muojTWsIQj/85U3RteHOipLgdG4hk9j65y5d3/u3ABd01JXS/DpmMzdc
         SbD4tJbhXnlOJdD15J/o4u8CcmpK++jQPIT59kI0bZbgvF/zGlbLONfdAZHC63N3ZTKG
         A2BrcTK+myA8Xt9fquIJjbtltvyEfy8pxf08qu+U3XvsTVhBi5lSG9HrTyiih9u/gI2A
         oJ5UM2ipKp7QXOVH7z+V4E+vNqj5kMfVICwJGjTkOpCOcBk212BfeaRI8fVy8KgIJqDG
         2jrr5fr6CZjscRtff8g8uaEkMxEnbJMdpc2ZOTBY4WpFFUmFWMljQQXwciSRd8E5zu2N
         S/GA==
X-Gm-Message-State: AOAM531gUoVzYSJ4+4EN4XLZe73NNOPVnOyioVlettGbFSJ+itT6+KNO
        YpSV0plesqWfjOIRxB0O779CMDdedBdKUS3ebBI=
X-Google-Smtp-Source: ABdhPJytfbK6iVZ4JeBA2xLyuOJ57QviX7QpjPKNosl6WEl0zzOnxGXZ9AlPU1P8coSQxpPKhaH86KdqqpGYMK1x7Oo=
X-Received: by 2002:a65:4008:: with SMTP id f8mr2062629pgp.310.1634779356017;
 Wed, 20 Oct 2021 18:22:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211014142554.53120-1-lmb@cloudflare.com>
In-Reply-To: <20211014142554.53120-1-lmb@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 20 Oct 2021 18:22:24 -0700
Message-ID: <CAADnVQJRUz81YeBqM-Kk4OM7FXAw07TNA_mOY1ZGAZ5MHpsE2A@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Fix up bpf_jit_limit some more
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 7:26 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Fix some inconsistencies of bpf_jit_limit on non-x86 platforms.
> I've dropped exposing bpf_jit_current since we couldn't agree on
> file modes, correct names, etc.

Applied to bpf tree. Seems more appropriate there.
