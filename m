Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78525285813
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 07:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgJGFNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 01:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgJGFNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 01:13:39 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6967C061755;
        Tue,  6 Oct 2020 22:13:39 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 7so624271pgm.11;
        Tue, 06 Oct 2020 22:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HcUrC2h912Ise4NnCqH2Ml1ksM1fqY/57tAY9LEMA9c=;
        b=ZB4SE7EXlvfHWy3qozaXROQKgeDBeCMp10YiwJOlvrqSsf8vKFxZ4hVtG7OmI4Z0Rb
         jVyMSbYEgdjErd6IL2HpId4FUXtQzlTglCWg2HoiWLrrqnLe+z49Mj/wvdkPHght5s+9
         cFIL5iFak7h4kp2X2VqC3pUiXoXlxarezWtFjyS7yXHTqQSA1iezQqD3qee+wTVuPqpp
         tuxKPqktml7n/xP/GNx0LA/7nU0XwHshPlPaboh062aMe1x5xPveSnhWHS2hlDwhvG86
         FsHAdh0f477/AleFSFrvpJPfeSx0aH2blODuinHp3iwyFpZH1yW2niFkgtgOHxTfkUBe
         jwqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HcUrC2h912Ise4NnCqH2Ml1ksM1fqY/57tAY9LEMA9c=;
        b=DcjO3mhrxMn5Ty21dlmTGn0N4xGTfQThQbDlpvhmzTEABBc3SPcBqvYUBLEy8zcNBJ
         Go/mANQDuMUIi9C149vYyEyaHQGzjtKYc9STj8vdfrwlFbT5/r7U4DpXMRiwi9alGME9
         FZI87mcO83srN3RzJUnililN2u5elRwNAm+eV+sxR3DTSIV6ibnSYdhaSRdeOWLsxKoM
         11WZ6RIhNmrUS126WaS9RlkCy45CWxIvC5/xpagwWDbB0ywtm+8FMQFQj+sfFLwx3F5J
         xK93pQ5jdPLkRAQrR0ZotO/sSyLyGJ8If+U/VyGR4szR0XC7iBTqxafei0YOwQMUhd9s
         N2Rg==
X-Gm-Message-State: AOAM532/Aj757N9dGdiHMIEOK+ajBD056brZPcWuzyk1e+clvfP50qKt
        +DePHH/t9vLTqT10mcFI0Fs=
X-Google-Smtp-Source: ABdhPJzIxaIGz2QbQUkCOwturiObL6vXGcQqDA2u5A53i7+zYKxc4E+PrdieQNhwoWhXqU2kVIRA2g==
X-Received: by 2002:a65:64c1:: with SMTP id t1mr1450985pgv.55.1602047619179;
        Tue, 06 Oct 2020 22:13:39 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:9c77])
        by smtp.gmail.com with ESMTPSA id c201sm1100685pfb.216.2020.10.06.22.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 22:13:38 -0700 (PDT)
Date:   Tue, 6 Oct 2020 22:13:35 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Propagate scalar ranges through
 register assignments.
Message-ID: <20201007051335.z6lwkinpsyxmpfam@ast-mbp>
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
 <20201006200955.12350-2-alexei.starovoitov@gmail.com>
 <CAEf4BzbRLLJ=r3LJfQbkkXtXgNqQL3Sr01ibhOaxNN-QDqiXdw@mail.gmail.com>
 <20201007021842.2lwngvsvj2hbuzh5@ast-mbp>
 <CAEf4Bza=7GzvXJinkwO1XcASg7ahHranmNRmXEzU-KzOg9wVCw@mail.gmail.com>
 <20201007041517.6wperlh6dqrk7xjc@ast-mbp>
 <CAEf4BzY1kKrB-GRmMCvEVy64KhpT=jao7voQuvXkKw4woMe8cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY1kKrB-GRmMCvEVy64KhpT=jao7voQuvXkKw4woMe8cA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 09:42:18PM -0700, Andrii Nakryiko wrote:
> > I see it differently.
> > I don't like moving if (reg->id) into find_equal_scalars(). Otherwise it would
> > have to be named something like try_find_equal_scalars(). And even with such
> > "try_" prefix it's still not clean. It's my general dislike of defensive
> > programming. I prefer all functions to be imperative: "do" vs "try_do".
> > There are exception from the rule, of course. Like kfree() that accepts NULL.
> > That's fine.
> > In this case I think if (type == SCALAR && id != 0) should be done by the caller.
> 
> There is no need to do (type == SCALAR) check, see pseudo-code above.
> In all cases where find_equal_scalars() is called we know already that
> register is SCALAR.
> 
> As for `if (reg->id)` being moved inside find_equal_scalars(). I
> didn't mean it as a defensive measure. It just allows to keep
> higher-level logic in check_cond_jmp_op() a bit more linear.
> 
> Also, regarding "try_find_equal_scalars". It's not try/attempt to do
> this, it's do it, similarly to __update_reg_bounds() you explained
> below. It's just known_reg->id == 0 is a guarantee that there are no
> other equal registers, so we can skip the work. But of course one can
> look at this differently. I just prefer less nested ifs, if it's
> possible to avoid them.
> 
> But all this is not that important. I suggested, you declined, let's move on.
> 
> > Note that's different from __update_reg_bounds().
> > There the bounds may or may not change, but the action is performed.
> > What you're proposing it to make find_equal_scalars() accept any kind
> > of register and do the action only if argument is actual scalar
> > and its "id != 0". That's exactly the defensive programming
> > that I feel make programmers sloppier.
> 
> :) I see a little bit of an irony between this anti-defensive
> programming manifesto and "safety net in case id assignment goes
> wrong" above.
> 
> > Note that's not the same as mark_reg_unknown() doing
> > if (WARN_ON(regno >= MAX_BPF_REG)) check. I hope the difference is clear.

Looks like the difference between defensive programming and safety net checks
was not clear. The safety net in mark_reg_unknown() will be triggered when
things really go wrong. I don't think I've ever seen in production code. I only
saw it during the development when my code was badly broken. That check is to
prevent security issues in case a bug sneaks in. The defensive programming lets
a function accept incorrect arguments. That's normal behavior of such function.
Because of such design choice the programers will routinely pass invalid args.
That's kfree() checking for NULL and the only exception I can remember in the
kernel code base. Arguably NULL is not an invalid value in this case. When
people talk about defensive programming the NULL check is brought up as an
example, but I think it's important to understand it at deeper level.
Letting function accept any register only to
> prefer less nested ifs, if it's possible to avoid them
is the same thing. It's making code sloppier for esthetics of less nested if-s.
There are plenty of projects and people that don't mind such coding style and
find it easier to program. That's a disagreement in coding philosophy. It's ok
to disagree, but it's important to understand those coding differences.
