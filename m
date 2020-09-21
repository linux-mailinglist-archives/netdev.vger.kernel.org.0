Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57632273141
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgIURwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgIURwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 13:52:53 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84CAC061755;
        Mon, 21 Sep 2020 10:52:53 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id 67so10916816ybt.6;
        Mon, 21 Sep 2020 10:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SKjNQMGb1+nm0CnnDw2aoYSyVGHtiTfWCigjGqfb/+E=;
        b=d9FHneM2P4UxVk88dAx28UxwPAGxarNtMwaqkCGZua9STsqKgPYHCSfzKYMFYUxmfv
         wTllfUf5RLgTYGEzyRgNrmP1dblvy/67akSZjOv5RDzjTxc1HLzNHpE+tGCB/8OCOj9e
         nuEoK8QUMPe+pVI1Id7/TMO+/O048VcoRmQAaL6tH7F9NLejjTLstXtXFjoVBLuFzUXX
         lhJETWlGd9SLle6CqOjQKaB+pFQ8J2kczK206ZeOYKrijJVDAefJT8ghNqLi4hliCzNA
         HjhkUvdS+/qqjbaSla3PUyf7ZeT4IigH6moX0lcNey1B+dJWDo9auAh5y+fz5Gx4vl15
         affQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SKjNQMGb1+nm0CnnDw2aoYSyVGHtiTfWCigjGqfb/+E=;
        b=tAsn0IajoaRfetQUKbDEDuxZqp7NVTErTmarb52Kq9dc3pisCz3aUMpvBL0vgmSXO/
         vLW6rjOjkIOPKRjqlFmPrLFqnPketWb/OTuOVUwebelmBW9wKqCNoRmc44UVnQgzteej
         0eMNB6A1Xd/utijBmMs5/dA6XYkhsS9vLlcY8DrFH2PcSWAiJsEQ8Gt19k6uRVN+XXSy
         J6tUrWcUO56LsFw1FHkH7Fb4viiyskSIAPZSBi5A/1wey27QYwSYJk5gVtkvSvgCqRbV
         H4+3nHlNG52Oiy2uBCoGr8TY8Pyx43TciaqXhOlp93IcTkpxXxfkBsms55XSpFFnsgrc
         On7g==
X-Gm-Message-State: AOAM530H8hv9Im4DWpfto++ebO3N2JNmsu2HIrMNvP1r9wmvxlmz+nIK
        n0XhXzWKp7f8C+w1m8MvlxADELsb/mx8VSeMGOc=
X-Google-Smtp-Source: ABdhPJwG/v5AEvqbf4XjP/SdkJJVKa8hUfCwk70rh1VomyNc7J66rcB333cB+SBTkM5sT7fkWrWYwpitua9D9LujH6Q=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr1458382ybp.510.1600710772768;
 Mon, 21 Sep 2020 10:52:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200916223512.2885524-1-haoluo@google.com> <20200916223512.2885524-3-haoluo@google.com>
In-Reply-To: <20200916223512.2885524-3-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 10:52:41 -0700
Message-ID: <CAEf4BzbTWGQ4QAOz29Jzj14RwprhsuDSbudU+rrUTaOg9ZP9Zg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/6] bpf/libbpf: BTF support for typed ksyms
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 3:38 PM Hao Luo <haoluo@google.com> wrote:
>
> If a ksym is defined with a type, libbpf will try to find the ksym's btf
> information from kernel btf. If a valid btf entry for the ksym is found,
> libbpf can pass in the found btf id to the verifier, which validates the
> ksym's type and value.
>
> Typeless ksyms (i.e. those defined as 'void') will not have such btf_id,
> but it has the symbol's address (read from kallsyms) and its value is
> treated as a raw pointer.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---

This looks nice and clean, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c | 112 ++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 99 insertions(+), 13 deletions(-)
>

[...]
