Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D1E105D8A
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 01:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKVALr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 19:11:47 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:40476 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfKVALq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 19:11:46 -0500
Received: by mail-qv1-f65.google.com with SMTP id i3so2198644qvv.7;
        Thu, 21 Nov 2019 16:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rvf6GdcZqxgDiIyBJHEmvdw8Sb4QOPMzejK6SiW3zro=;
        b=Ww8mlpopRe/tyjTPSAizu4hUP4ovvMsqCVr74foZV05BdV/yA/9j2QCMm8PJPjztel
         btkaaL3S9vq4mRTKl1c7mC8p6O2I1k8gAvp5NrvwrpoxckZYsC96PNuNpPajo7qmc5h1
         HOBh9uO0wcH6wDAtX0Yj1bVUmliv99P3lL0agbDfBMef+LbFKfCyOGh3EKIFsWecchXv
         KNA8AWYZ7UV4DJMex5SqYdmQ4DNIm0yd0KV6binOPA7niRZQjLbMroQfTzjBJj8pbwUW
         2oHAoLAo8/iy226ncwMNQOSr0WBG7j1nLuwa5vsMqo+tMLtwkeufu0XGKs/1v9GK1OuI
         MrBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rvf6GdcZqxgDiIyBJHEmvdw8Sb4QOPMzejK6SiW3zro=;
        b=RxkuLlhkM9yWZdT0MVFvNYU+YGgUd5OkvnNBvr2GXTzmy/RUSWK29RyWkYWKUsArTb
         RWEgYrupfMiYTfT0SyFmgdaTg4p6x0y17jGU1PWUZrzLVjco+74smxCgKptWQxSe4HP5
         j49koDhrvKLJZTaJTIx1AvPlpjbrrYMrw/v+tDpCiT9b36OxEu87lNfcMI6LBhzE5UJo
         T/P6i4HpNa8ecvusO9nukmnOkiaYd7vtvEdEz899Uayq7ZTlXJBly3CC6nYH2/Q6gCjt
         VDIk84/kQlbUEjVduwOd77MCQaXUCrYkKQqSaEXL9E6Z4c/y9mb5tVZt/rN7hO1ipr4y
         xCbQ==
X-Gm-Message-State: APjAAAW9hqUZD7IFGqdszijsEX1m1HZgHd0nS/sMIoEVQURFdZlXwUJX
        kdeiZaSYe6l9R6KEIMpLa+mc0HJEZW1PcY5b5iA=
X-Google-Smtp-Source: APXvYqyTzLR/9Jq5hYtYtAxpNj7pYHvWtIbmL18kn+Qq+zc2HKCbAi2lIcKHPX0/0YmgRiVK6IkXUHSeDtRvIV+ZmHY=
X-Received: by 2002:a05:6214:90f:: with SMTP id dj15mr11147691qvb.224.1574381505270;
 Thu, 21 Nov 2019 16:11:45 -0800 (PST)
MIME-Version: 1.0
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
 <20191011002808.28206-12-ivan.khoronzhuk@linaro.org> <20191121214225.GA3145429@mini-arch.hsd1.ca.comcast.net>
In-Reply-To: <20191121214225.GA3145429@mini-arch.hsd1.ca.comcast.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 Nov 2019 16:11:34 -0800
Message-ID: <CAEf4BzZWPwzC8ZBWcBOfQQmxBkDRjogxw2xHZ+dMWOrrMmU0sg@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 11/15] libbpf: don't use cxx to test_libpf target
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com, ilias.apalodimas@linaro.org,
        sergei.shtylyov@cogentembedded.com,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 1:42 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 10/11, Ivan Khoronzhuk wrote:
> > No need to use C++ for test_libbpf target when libbpf is on C and it
> > can be tested with C, after this change the CXXFLAGS in makefiles can
> > be avoided, at least in bpf samples, when sysroot is used, passing
> > same C/LDFLAGS as for lib.
> >
> > Add "return 0" in test_libbpf to avoid warn, but also remove spaces at
> > start of the lines to keep same style and avoid warns while apply.
> Hey, just spotted this patch, not sure how it slipped through.
> The c++ test was there to make sure libbpf can be included and
> linked against c++ code (i.e. libbpf headers don't have some c++
> keywords/etc).
>
> Any particular reason you were not happy with it? Can we revert it
> back to c++ and fix your use-case instead? Alternatively, we can just
> remove this test if we don't really care about c++.
>

No one seemed to know why we have C++ pieces in pure C library and its
Makefile, so we decide to "fix" this. :)
But I do understand your concern. Would it be possible to instead do
this as a proper selftests test? Do you mind taking a look at that?
Thanks!

(please trim irrelevant parts)
[...]
