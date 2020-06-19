Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCE5200001
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 04:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgFSCFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 22:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgFSCE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 22:04:59 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F93C06174E;
        Thu, 18 Jun 2020 19:04:58 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id n23so9647405ljh.7;
        Thu, 18 Jun 2020 19:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R3VKRlz6KhsBegBX4kZbzzxJb4mSrV2DKeZcEmCvB5A=;
        b=pcp+r6tcnC4UiZHq2w3ecFsiqjQ5ZAl9c72euE9GDiimDstUoP0z5NtI9j714pIXcD
         nY84AWFDehOFaLxDCFQdSz9BL3l3+eU/+aCCSY+BDpS05gg/hpjkY6IU5eDuXyUqOCAy
         UpRuRSHAsfrmf3e89yqBwyMP2rsWpAuT8YXqGiqFkBec7wj5jfeCbQoGwOZIPaSnDsB3
         YgjhhbAIyOb/XFQ2tVgPt+7KTKplRAS1jtvIcKnXjdFQfutW2eC7rrn/+92CrZI1Xuky
         bn6bln2G3uFT7rP/YPHDpiGfOiAc86x+oW1WWUFE0VdXdDMiz2HtrpCy4aNzDFi1bgdk
         VudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R3VKRlz6KhsBegBX4kZbzzxJb4mSrV2DKeZcEmCvB5A=;
        b=moUfglcmHC+/Bm36QGFVZuwYAz/ryppYv4hc+7SGVDNaOe970iPsK+D/ulN9RVVqmB
         ixHu20PQa/OYgRRpMELo4yIAl4kpkn5ZPBODhKuSPuUrjcch9j0LJqd9KwXjsyTj38e8
         AsLJI79swaRk+4lAvLEwFnETEIdaPQ+PexgLSvIza3n40oQ+TiWeke7vsLSPlTezh/UF
         xk9mZP33mQGI+pM0+Y1dmXnjiKGjrWjnpruBCY1LGVMwsatnqbNr/OSCeGN6GUE8ZBhf
         5l9j+3uYKXGRTlsA+auoI7pAvh5DAfzf+etmBXG1N7zPwHbyR4uWQJ+IdP1My9/9BvkV
         5cqg==
X-Gm-Message-State: AOAM533sW3sXwAHrVX9Q9Z4aySTm2NNF4uKvgnA2w/C8r16cK9mK7MEw
        gr6WhdfnNQMQgP2dNUjs1M5dZ0OYKo0fKpD5S6g=
X-Google-Smtp-Source: ABdhPJxBNRcKl6EbhjEr4KNQrGUoVgyLcm4OlhaMlCgQGrJLNqIRgY0a+Nzk5scH6yY6ndLUCvw9SLq7aCFNejJHc7k=
X-Received: by 2002:a05:651c:1193:: with SMTP id w19mr620933ljo.121.1592532296809;
 Thu, 18 Jun 2020 19:04:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200616173556.2204073-1-jolsa@kernel.org> <5eeaa556c7a0e_38b82b28075185c46a@john-XPS-13-9370.notmuch>
 <20200618114806.GA2369163@krava> <5eebe552dddc1_6d292ad5e7a285b83f@john-XPS-13-9370.notmuch>
 <CAEf4Bzb+U+A9i0VfGUHLVt28WCob7pb-0iVQA8d1fcR8A27ZpA@mail.gmail.com> <5eec061598dcf_403f2afa5de805bcde@john-XPS-13-9370.notmuch>
In-Reply-To: <5eec061598dcf_403f2afa5de805bcde@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Jun 2020 19:04:45 -0700
Message-ID: <CAADnVQLGNUcDWmrgUBmdcgLMfUNf=-3yroA8a+b7s+Ki5Tb4Jg@mail.gmail.com>
Subject: Re: [PATCH] bpf: Allow small structs to be type of function argument
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Andrii Nakryiko <andriin@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        Masanori Misono <m.misono760@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 5:26 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
>  foo(int a, __int128 b)
>
> would put a in r0 and b in r2 and r3 leaving a hole in r1. But that
> was some old reference manual and  might no longer be the case
> in reality. Perhaps just spreading hearsay, but the point is we
> should say something about what the BPF backend convention
> is and write it down. We've started to bump into these things
> lately.

calling convention for int128 in bpf is _undefined_.
calling convention for struct by value in bpf is also _undefined_.

In many cases the compiler has to have the backend code
so other parts of the compiler can function.
I didn't bother explicitly disabling every undefined case.
Please don't read too much into llvm generated code.
