Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD4E27D314
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbgI2Psn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 11:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgI2Psm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 11:48:42 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A61FC061755;
        Tue, 29 Sep 2020 08:48:42 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id 77so6129326lfj.0;
        Tue, 29 Sep 2020 08:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C03GfNtAEwKiwdCU07tZSqak/2i7nim8viiXxocdJ8s=;
        b=Nf1tAi65bXqFvbQR7DC7chb2QRkBiFvi+mbBp/rVXUYcwqzp9+MsEIGVvS3NVt2Xp8
         FRODo4nI0CUJswMiLZdLW8uSOI5Z7mkOrz/k8sfxT+FwEZ6nTAIyN1M0gACOb0qipOvO
         W+1Hgx+0G5BMQDLTgwnNzx2P5NIuAL0oqLJib12Ms3XFuZ39ej8b63mWtw5hugkHvc/8
         zUUWLrryv78Xe7ppgZWEwpN67UUjQgq9q0u6V1Gis5PQdvObWGzvzAW4xpyL22iSoTyx
         yZpVQWz2yZdE442psFGNgJ6f4rIuRN3PW2GrFIluk31K+i1j+BHv4QROiB8WlPpc9MAK
         3ccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C03GfNtAEwKiwdCU07tZSqak/2i7nim8viiXxocdJ8s=;
        b=HTxE//uW0Dveifo6vvOTeOoIVpaTIKYh5xXPNYR9E33eNmbLa3kSUIPlZTaGyA480i
         D+E6Kw1dN6QW2LCkKuXWCOEGkig/APHO4E3Q9sohxidqTY+XyWluY3oI/a7Emc9MU3Ym
         2sul6CN+gG8DGHR2fhDNAs1oar4fI9P2vyAwwdfexTuaRedcDVe17RJsiV23WthOzJPH
         YwcH3ZVvsIN0UPr1ryTQMrAZBBorOSuCyw6putDyUAd859XCHLIuLqTxvGEtx6eHXKYe
         A/zS/I+h/hYEepogs/QgsZQAFnUkQ5wQbZRQGdMeXMfgLVliqC1eyftXWssr1QyX7Cjo
         GPbg==
X-Gm-Message-State: AOAM530nnyf1ox8Fpcb4M1ZPz2sHKuZ9Ivz31Y+JnzsRFHa0hVlXzsJ/
        6ejEfDNNX+eY2jKk8NNSxuF5+8TPyYJT60BOaoI=
X-Google-Smtp-Source: ABdhPJzknCWMQwp+7qyeON2fWeuJIJJaiL/XmYGkLKkBYBQfctT04GHRqvm1krAtMPimnWCbcsDBbMxS4gjjcIz6W8Y=
X-Received: by 2002:a19:9141:: with SMTP id y1mr1361477lfj.554.1601394520576;
 Tue, 29 Sep 2020 08:48:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200928090805.23343-1-lmb@cloudflare.com> <20200928090805.23343-3-lmb@cloudflare.com>
 <20200929055851.n7fa3os7iu7grni3@kafai-mbp>
In-Reply-To: <20200929055851.n7fa3os7iu7grni3@kafai-mbp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Sep 2020 08:48:27 -0700
Message-ID: <CAADnVQLwpWMea1rbFAwvR_k+GzOphaOW-kUGORf90PJ-Ezxm4w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/4] selftests: bpf: Add helper to compare
 socket cookies
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 10:59 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > +static void compare_cookies(struct bpf_map *src, struct bpf_map *dst)
> > +{
> > +     __u32 i, max_entries = bpf_map__max_entries(src);
> > +     int err, duration, src_fd, dst_fd;
> This should have a compiler warning.  "duration" is not initialized.

There was a warning. I noticed it while applying and fixed it up.
Lorenz, please upgrade your compiler. This is not the first time such
warning has been missed.
