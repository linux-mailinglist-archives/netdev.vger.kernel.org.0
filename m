Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE6427D60D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 20:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgI2SqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 14:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728166AbgI2SqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 14:46:20 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E78C061755;
        Tue, 29 Sep 2020 11:46:19 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id w3so4880526ljo.5;
        Tue, 29 Sep 2020 11:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KRnynSBFXDyhlJB/lFn7BMINa1P/TMLHPg/QRGnV4cw=;
        b=gzQIkhazQHh8DwuLf0yqzzfAx0jQiwj6R1to2FRrmN8QzEAKi4Cucd9CNBX0HaqHSY
         8KM8INtefnbqWcs6Y9m5fIuo9EWxYfa9maHX7XJqXlZjKxK2zvpXQN1vMLtc3YJLsleK
         p2Q6y+9/HV4E+I3sXt/1D2ciIKHDNX2ey9Ma1FkRYpeWeDGA3NbgHUpWxvA9plyjW3k3
         sUhN+vPydqwdbA+2YKIUd+Yn5vGYiRyKmIl484VcObvBwdlkfD64X7r1W7+pL45G79YY
         GqjGCrN5FYdmrA/yh8/ibdSmr67Epzx0d5ZGp1h9gL8iXjpr2JGQ9CGfK/7kX9N8h9lG
         +bmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KRnynSBFXDyhlJB/lFn7BMINa1P/TMLHPg/QRGnV4cw=;
        b=KV9qSxW2DlDdyyU8wVrCAskhEiQOHNl9SKmByLsB11em9VONAMD0MoO9vyrZjGJIfE
         pF1mXLPS5fROaHOC6wgJqBYZeuHtP50YvW39oxVAlgRr34wcRLH4MKknMcOdEntYkEKR
         7yrPXr/CX8uOJDqkbyWKZ+TiBfbecaa3ViOYDge9bNSUllPxhEcACNBeAv8wZ0+r3ACe
         YtPKe6xSdQpM3vMCc9hnPFq/d2Z7pic54OkHniX6/B/94AkZkPOt3rObT7EGhXpwCh+/
         kLS0ENeeDGKYOlaohOqIF24EAjSs4C2TzxSXCltkFIEquNDd5SlGNrukGz9Z8aVu/W7u
         IBMw==
X-Gm-Message-State: AOAM533kfdD6+8a1KTuufUyfqk9ICCBxY9CW0ulXC1TuaaC/XXJ1l7FN
        2pyk3sPSw2dji8jznFLQhvHs0tyTYfzdRbEGLDI=
X-Google-Smtp-Source: ABdhPJx411aY0PIcYG7sdD1kilZGsC3pOpUoCh3yg01wbbKyUH4jBMDZk8OzwkEagnQHCRfgfACZKPcN/EVlipA4z+o=
X-Received: by 2002:a2e:9b15:: with SMTP id u21mr1705127lji.283.1601405178185;
 Tue, 29 Sep 2020 11:46:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200929123026.46751-1-toke@redhat.com>
In-Reply-To: <20200929123026.46751-1-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Sep 2020 11:46:05 -0700
Message-ID: <CAADnVQJt=Sj86-r9y_KvzCuLQU_r=kw4b+=fFx5-EYSA6SAeKQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests: Make sure all 'skel' variables are
 declared static
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 5:32 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> If programs in prog_tests using skeletons declare the 'skel' variable as
> global but not static, that will lead to linker errors on the final link =
of
> the prog_tests binary due to duplicate symbols. Fix a few instances of th=
is.
>
> Fixes: b18c1f0aa477 ("bpf: selftest: Adapt sock_fields test to use skel a=
nd global variables")
> Fixes: 9a856cae2217 ("bpf: selftest: Add test_btf_skc_cls_ingress")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Thanks for the fix. Applied.
I wonder why we don't see it with different gcc and clang versions.
What linker do you use?
And what kind of error do you see?
