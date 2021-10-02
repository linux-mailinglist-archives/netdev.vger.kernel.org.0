Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C3A41FE60
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 00:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhJBWNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 18:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbhJBWNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 18:13:46 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59260C061714
        for <netdev@vger.kernel.org>; Sat,  2 Oct 2021 15:12:00 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id l19so15382138vst.7
        for <netdev@vger.kernel.org>; Sat, 02 Oct 2021 15:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SsvscJ402dii9bAJeiyjIQz+HyfgmN4Yk1LeCVUSwDM=;
        b=Tei7YHAW2GP4SiEaqa1QWrHo1rwW2wXUVlg2yAJ55ELT7palkeOzTXhIrPVT6MCPgO
         bIktr+nDhCnMFWV9xeOA6exWHD/lYtYqxCnLlRR0kBvvQEylyhxirqk8TH/AQanPTj3c
         p0wHNEpVkPi7HhFIPxofKB1vm0382zxBLfmCb9P+BP56wMRAtyAPYry/0IQqdTMQ1F/t
         MdTd0hpxrenW5RzRJ0jelSjgo2UxolQiKCQvTK5+OPX/i+3zcYdJU0S05peljgSdy+K8
         82Kw0lbTt+l4XunmQKNWfXAMcwROg8iIs9IhlnrDxe/nt5dqXLOoNJlfjrAUMgo27DID
         jZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SsvscJ402dii9bAJeiyjIQz+HyfgmN4Yk1LeCVUSwDM=;
        b=dnP4oYBajWOWRX02EyLoQikovOwmyZS5FtFm065D03xYgOJFYJbhYFzJel60eDiXgI
         K9A+FMxJwML9d9WPth1khLXy6QRVBI9RxDkkPOdb/yleGV+HnHgmd34PbWT2Ny4gBzJ/
         DmCCTuHHURb87x76zwNSbd+YbFjLMN9VCtFXI0M6j4SQV68zsMdL7QLW6wxgF9hq4AD/
         InpGlqTy7txWhxGvc+wWI5FMACGoZ20v0qO8T9V/J0YfBcYpxidiPwoz7DpFQMZCO2eU
         ociinxnAoSvZEoc97NkL4Yb+hS8ByhFn9m1PYgsCCMeJmd+5aqfhV+4AME/FIAylpBLh
         uj2w==
X-Gm-Message-State: AOAM532g/2DaYWyOvsDDbW+vIxiWbdJFx40qJoGrZruLapI3v39NFfVZ
        0TwkExwL1bwmq7GT3Py5C64Gv3FULtduA0MqsCmtXg==
X-Google-Smtp-Source: ABdhPJxSiewjc5fxuicPfqjS/DGDqEJyacHtrPcYgxr6POZ3CGJWUri2UCSIznykYgJnFj7AT1mMjmkiGyW1qZoDkKU=
X-Received: by 2002:a05:6102:192:: with SMTP id r18mr9243859vsq.0.1633212719460;
 Sat, 02 Oct 2021 15:11:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211001110856.14730-1-quentin@isovalent.com> <20211001110856.14730-7-quentin@isovalent.com>
 <CAEf4BzYm_QTq+u5tUp71+wY+JAaiUApv35tSqFUEyc81yOeUzw@mail.gmail.com> <CACdoK4LL91u-JK1fZ3XvkrTXsKBVsN-y1Js4QSPkWyS51KPB8Q@mail.gmail.com>
In-Reply-To: <CACdoK4LL91u-JK1fZ3XvkrTXsKBVsN-y1Js4QSPkWyS51KPB8Q@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Sat, 2 Oct 2021 23:11:48 +0100
Message-ID: <CACdoK4K4-x4+ZWXyB697Kn8RK5AyoCST+V7Lhtk_Kaqm5uQ6wg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/9] bpf: iterators: install libbpf headers
 when building
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2 Oct 2021 at 21:27, Quentin Monnet <quentin@isovalent.com> wrote:
>
> On Sat, 2 Oct 2021 at 00:20, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Oct 1, 2021 at 4:09 AM Quentin Monnet <quentin@isovalent.com> wrote:
> > >
> > > API headers from libbpf should not be accessed directly from the
> > > library's source directory. Instead, they should be exported with "make
> > > install_headers". Let's make sure that bpf/preload/iterators/Makefile
> > > installs the headers properly when building.
>
> > >
> > > -$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
> > > +$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile)            \
> > > +          | $(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE)
> >
> > Would it make sense for libbpf's Makefile to create include and output
> > directories on its own? We wouldn't need to have these order-only
> > dependencies everywhere, right?
>
> Good point, I'll have a look at it.
> Quentin

So libbpf already creates the include (and parent $(DESTDIR))
directory, so I can get rid of the related dependencies. But I don't
see an easy solution for the output directory for the object files.
The issue is that libbpf's Makefile includes
tools/scripts/Makefile.include, which checks $(OUTPUT) and errors out
if the directory does not exist. This prevents us from creating the
directory as part of the regular targets. We could create it
unconditionally before running any target, but it's ugly; and I don't
see any simple workaround.

So I'll remove the deps on $(LIBBPF_INCLUDE) and keep the ones on
$(LIBBPF_OUTPUT).
