Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653D03648FD
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 19:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbhDSR0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 13:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhDSR0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 13:26:18 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFE8C06174A;
        Mon, 19 Apr 2021 10:25:47 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 65-20020a9d03470000b02902808b4aec6dso28546593otv.6;
        Mon, 19 Apr 2021 10:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3HIbRDGM28FCUvqMIhymTERSRguapYMbEYU1+dJ/ZIc=;
        b=fcw7b3c29DAiAuGdNpjLnViMXqN9PcBoUWTNDOv6U9yivfrmkv5SmHKMwNWPy6gIoJ
         pugpcOMLlAeEZzk+kLr8zRXfzNTY6ykqEO6dKmNMJQZHfN8REYYI0u5EfQzo1+8SOym9
         auBSKaH6NROvRflPV/LHt323tBc5uQTqL/FojAF3GDte5va4Th5OxkrdYmTP2FyZoKbo
         ZC/NkzARjzo6bxzMBc1uiohwyIWWCXYfF0lOy925RWfu0KWRjtaGNiS9XBxbwe7obauU
         MQDabAueC2T3oM1p2C2diGIO7LHMsFsL5wY0HsMsRnmFBHqLHoh9H5H68nBnbo99yPJV
         TmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3HIbRDGM28FCUvqMIhymTERSRguapYMbEYU1+dJ/ZIc=;
        b=lMV8z7fNJlYn9B4+M+JsboWJRyagfSl6RTSxEs/Db6yjIukREL9PqizeE70yYvK/7e
         L47lfWluJ/1r/H1ipK6U5Ve4yW/jfUuuwAI4UdKvqglJ0kFlLOMO2gmcRe/dBESAz8nJ
         C8yNmfS2FOIfdau+2A8m9pOq6NAxZDve2ch+JOithVY6EHhC3VIZIGUX4BJxL+rhyjPG
         dmHnD6wufCJdxXZUNKb/739TB2BC1gPTEIqRJn1xWKuV09AYDtjvbXw06igOryk9Tzd/
         tDwZnb6uYF4jA9MyNDDcAYTZClhrFdFqSioxDkV8Vl497+TFBEjjWjjoiPaVVYFlON+n
         AP2Q==
X-Gm-Message-State: AOAM531eYqFOl3UfiL/mhmdj9RluLcEajkTieSAE1k1lC13MtOfGwCCi
        bWF25d38zpPIa0+ZWTK6jeTK915pSYG2v7Z4yFY=
X-Google-Smtp-Source: ABdhPJyl4zUa7RWvSiIV1QPL9ksPdGp/q99v9hfGaP7WlLMJCuZk8a9XUEteNr93Eux7KoCVmjyMuxm9dNgUCHyCXsM=
X-Received: by 2002:a9d:61c1:: with SMTP id h1mr1298796otk.173.1618853146965;
 Mon, 19 Apr 2021 10:25:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210415174619.51229-1-pctammela@mojatatu.com> <20210416213553.wclvjwbkxpvs6rfr@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210416213553.wclvjwbkxpvs6rfr@kafai-mbp.dhcp.thefacebook.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Mon, 19 Apr 2021 10:25:36 -0700
Message-ID: <CABCgpaXOWWPeZysFTnrqvYFn_mbKZjdvgX=SEn4-BvktwO9tsA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/3] add batched ops for percpu array
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Pedro Tammela <pctammela@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry I missed  this.
I don't recall why I didn't add the array percpu variant, but LGTM.

Acked-by: Brian Vazquez <brianvv@google.com>

On Fri, Apr 16, 2021 at 3:09 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Apr 15, 2021 at 02:46:16PM -0300, Pedro Tammela wrote:
> > This patchset introduces batched operations for the per-cpu variant of
> > the array map.
> >
> > It also removes the percpu macros from 'bpf_util.h'. This change was
> > suggested by Andrii in a earlier iteration of this patchset.
> >
> > The tests were updated to reflect all the new changes.
> Acked-by: Martin KaFai Lau <kafai@fb.com>
