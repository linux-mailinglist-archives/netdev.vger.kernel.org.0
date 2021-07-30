Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A633DBFB8
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 22:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhG3UXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 16:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbhG3UXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 16:23:19 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFEFC06175F
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 13:23:14 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id e5so12432081pld.6
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 13:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L6GZwee3zFFPBRG9bG2No8hxtp9CFwbkFuUJbccfQD8=;
        b=JOXZU0qKiHccvRmfAizmxvmud0U+2vK3GFGatspi4UhZRWN3JsNmy3MdrbFHbeAeJM
         lrYOTe1Ho70mPMzYNS5JwA55FuwyRj13ksmPSMFGqIoJAG7CiU2s29g04sacltNidi8T
         diHZAcffS23I++UNReWAA5HcM+Lw2yxQpJq1IYAcNSqzRadS936SgWQMcpaRzFoWb1Gd
         Wy4I1H9xPQ5ofw2grKWdDE8R/sEVbt8Knnp5w29aydvkox2IWf5HPg+cM+xi1k6Y7XDI
         f3/0udHVUmYlW2fHQqtQPgVoe7hqfWiDRLKBIo4Hl7KAYytUsRs+4MqhKifbRAvhCR1w
         g1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L6GZwee3zFFPBRG9bG2No8hxtp9CFwbkFuUJbccfQD8=;
        b=uaGKhtqbdnsHGJvU9FJbSeVUcr4Aa/r7TzBPO3f35D7Rx31stVIzx+q98/yTfF0yT0
         zkMgatbtUa1C8HJ02wbErJWtHsDuQ2beKymmCNe8E+9grfEYi9jRabYlSMpu+lGzh5Eu
         oqlsFuAF1sAkcuUSSg+aEa93yPJ5wJRqpOgqdzMFX75LxxS0iVYs/cltLyHn6ugkl1mc
         eEwWmvNhfxAHMe6PlGgdR2vDE1os6IjNdBe30kZSdPGd0e8sg9flw5wqXiBODIa8F3bt
         Grf+bKWOCLUnX2kSORp+sl3J2cKujJk1oBRT4TSSZZr+R+fijmafvo0gRoVyy038a1MN
         LWgA==
X-Gm-Message-State: AOAM532rn0DzZ8S/vIGg61Q2eYX5lLoPzbjlYtjSopC/8MstG5/fY9yS
        P+Z3iDZJ3cjkPGI49khue5crP8eyuf9PmPzEhijUxw==
X-Google-Smtp-Source: ABdhPJzqTNIRbw91KykDwe5YpS6CSO6GukDdkNVThVJ90gsI7hID/Uof2oiHLdFn5gxpJ1RoZDgN/n4fI8N7+AryPbw=
X-Received: by 2002:a17:902:e551:b029:12b:7e4c:b34 with SMTP id
 n17-20020a170902e551b029012b7e4c0b34mr3977994plf.43.1627676594074; Fri, 30
 Jul 2021 13:23:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210729162028.29512-1-quentin@isovalent.com> <CAEf4BzbrQOr8Z2oiywT-zPBEz9jbP9_6oJXOW28LdOaqAy8pLw@mail.gmail.com>
 <22d59def-51e7-2b98-61b6-b700e7de8ef6@isovalent.com> <CAEf4BzbjN+zjio3HPRkGLRgZpbLj9MUGLnXt1KDSsoOHB8_v3Q@mail.gmail.com>
In-Reply-To: <CAEf4BzbjN+zjio3HPRkGLRgZpbLj9MUGLnXt1KDSsoOHB8_v3Q@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Fri, 30 Jul 2021 21:23:02 +0100
Message-ID: <CACdoK4KCbseLYzY2aqVM5KC0oXOwzE-5b3-g07uoeyJN4+r70g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/8] libbpf: rename btf__get_from_id() and
 btf__load() APIs, support split BTF
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Jul 2021 at 18:24, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

[...]

> > > The right approach will be to define
> > > LIBBPF_MAJOR_VERSION/LIBBPF_MINOR_VERSION in some sort of
> > > auto-generated header, included from libbpf_common.h and installed as
> > > part of libbpf package.
> >
> > So generating this header is easy. Installing it with the other headers
> > is simple too. It becomes a bit trickier when we build outside of the
> > directory (it seems I need to pass -I$(OUTPUT) to build libbpf).
>
> Not sure why using the header is tricky. We auto-generate
> bpf_helper_defs.h, which is included from bpf_helpers.h, which is
> included in every single libbpf-using application. Works good with no
> extra magic.

bpf_helper_defs.h is the first thing I looked at, and I processed
libbpf_version.h just like it. But there is a difference:
bpf_helper_defs.h is _not_ included in libbpf itself, nor is it needed
in bpftool at the bootstrap stage (it is only included from the eBPF
skeletons for profiling or showing PIDs etc., which are compiled after
libbpf). The version header is needed in both cases.

>
> >
> > The step I'm most struggling with at the moment is bpftool, which
> > bootstraps a first version of itself before building libbpf, by looking
> > at the headers directly in libbpf's directory. It means that the
> > generated header with the version number has not yet been generated. Do
> > you think it is worth changing bpftool's build steps to implement this
> > deprecation helper?
>
> If it doesn't do that already, bpftool should do `make install` for
> libbpf, not just build. Install will put all the headers, generated or
> otherwise, into a designated destination folder, which should be
> passed as -I parameter. But that should be already happening due to
> bpf_helper_defs.h.

bpftool does not run "make install". It compiles libbpf passing
"OUTPUT=$(LIBBPF_OUTPUT)", sets LIBBPF_PATH to the same directory, and
then adds "-I$(LIBBPF_PATH)" for accessing bpf_helper_defs.h and compile
its eBPF programs. It is possible to include libbpf_version.h the same
way, but only after libbpf has been compiled, after the bootstrap.

I'll look into updating the Makefile to compile and install libbpf
before the bootstrap, when I have some time.
