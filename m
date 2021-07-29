Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D474E3DAE2D
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 23:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhG2VV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 17:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhG2VV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 17:21:58 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9974C061765
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 14:21:54 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id x192so12552019ybe.0
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 14:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iVEUoIeXmIQWOzUJGGX4tSb3gJiqrMaFOO2m6Pc5kvA=;
        b=AkIy2EM0oNkY12EMt/xwD5M2hIcWt3jNji03EE/cogOgyc4SsDUqKz5e5Xn6jh1yqh
         SGeiAFzQ00MhordY46Hk0rCbWbUP8Qz8tQV+dVBvD10aMEZ8h6EpKXMke6p8ARrRuT89
         2vA9cTQRrySJ9PRYFQxi/d/IzXN05XUBpk4+zeMwlBZE9XyzdcoNbBYWUaZ/r5OS56bX
         HaeDmPqID0LEmNFkCmJykq6ZubGWzKmJ9UNWvSx44K+gRDaKXIK+Uj+IuCqOcOzt0Jxp
         I9TpEwQTUvp4lOIjoDDmMMkGldqVB47FxaQQmoz/WdXalUXI7xFtOijBstbwy9Hup8lS
         nbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iVEUoIeXmIQWOzUJGGX4tSb3gJiqrMaFOO2m6Pc5kvA=;
        b=uSf5Hx6d0hMd6hiCipMQOLySXN/m4Fpmo2MXaLz5dzsaKvJsjQes4grTySKEtkjI3e
         t3EyjLQLP9gSNA7NbpYXRDOXenDpLZrLW0rCuBSvcUWbIYgdE30oiskPopWHaplOVimp
         2zsy5qtmYih+KVSPUmER9RCX7l1kuHMgou/mGreNO3eh1hcHwrbXuCzn8ZyYpL4RDnYN
         edsfx3XSitKwffwjzon+CqqYVk3dDZGGDgPe34JgD9ZRSIBSbn86Jsc/dpN4sZ8H+w8P
         y30Gm+LAmXRxItiNyyHeyQPYzJwcuvnm0Q+/awpYZMlvlUHdBk1uns6xqAm6Hq9+xBx0
         G6fA==
X-Gm-Message-State: AOAM533gkITDcS6yMUNGN/L/JIEVjBKp/DWGVh9hkL1/HezL6MY/FriN
        zFbbGPX6VEBHnk8sGpUXyKpV8RDdvhr/KkCflBwaKQ==
X-Google-Smtp-Source: ABdhPJwCMBfWJ1aZm/KOEvRIjOmo+J+kQglOzLy5W/OF9TNRuwn5MaCMCsB5ahVbKQn/WVdYdaVFT2UWFZfkdqN5R+k=
X-Received: by 2002:a25:ac18:: with SMTP id w24mr9861016ybi.289.1627593714088;
 Thu, 29 Jul 2021 14:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-8-johan.almbladh@anyfinetworks.com> <cbff35ec-07ce-9c7d-4c29-66f2f780daa4@fb.com>
In-Reply-To: <cbff35ec-07ce-9c7d-4c29-66f2f780daa4@fb.com>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Thu, 29 Jul 2021 23:21:43 +0200
Message-ID: <CAM1=_QQ6rUjANEKTPUadzMfP5zcxWimL8+YRjy=3eS0SZrwbpQ@mail.gmail.com>
Subject: Re: [PATCH 07/14] bpf/tests: Add more ALU64 BPF_MUL tests
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 1:32 AM Yonghong Song <yhs@fb.com> wrote:
> > @@ -3051,6 +3051,31 @@ static struct bpf_test tests[] = {
> >               { },
> >               { { 0, 2147483647 } },
> >       },
> > +     {
> > +             "ALU64_MUL_X: 64x64 multiply, low word",
> > +             .u.insns_int = {
> > +                     BPF_LD_IMM64(R0, 0x0fedcba987654321LL),
> > +                     BPF_LD_IMM64(R1, 0x123456789abcdef0LL),
> > +                     BPF_ALU64_REG(BPF_MUL, R0, R1),
> > +                     BPF_EXIT_INSN(),
> > +             },
> > +             INTERNAL,
> > +             { },
> > +             { { 0, 0xe5618cf0 } }
>
> Same here. Maybe capture the true 64-bit R0 value?

Same as the LSH/RSH/ARSH tests. Uses 32-bit shift to test high and low
words in two runs.
