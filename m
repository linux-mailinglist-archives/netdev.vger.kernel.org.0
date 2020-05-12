Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62721D01AB
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 00:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730993AbgELWNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 18:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727899AbgELWNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 18:13:31 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102C9C061A0C;
        Tue, 12 May 2020 15:13:30 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id c24so6127133qtw.7;
        Tue, 12 May 2020 15:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JRKy9vIaabxo0Cw4b3DS0PxAxZUK8zgDHFpXCN4phmg=;
        b=Y5C/pEK6Bjd9nUmekcGqVkzuRifkvHGwcKinuvn9avWhrZHj40iuE02OMGmH8CiCIX
         dHQmMAH3ZM/Q1n+YUjUFWCDsMRtXvlqTLgghr6S/mu82TMfp9++OtqusnMDW7mSTq4F3
         zKxxp3nR2FVy+1r//Tj+slZ85BZ36uwTuuHjxOxjoEWiV7ocXgm+lUkdda+xCFzH3H6j
         KOOCdZK8nN1eiKSCNxEjKeE5vjJQJIYswkJMucxL44djdmCRPvGyCUnmh/+uW8rHWSAY
         u3UvBK3Y2GVvlrizkoIQqD/PCkBpMHe9LVtnjIlunvJlRbtzfYwtQLcN2wOchmBDDSFK
         Plmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JRKy9vIaabxo0Cw4b3DS0PxAxZUK8zgDHFpXCN4phmg=;
        b=OVWvNXm3GPCsE/PXTPnwMKX0vPFCgGr+ZUzKM/o0xbJaZd9W4IbX0uG21hr/yKx24A
         pYnnzfCTa/nZbN2iF8P05IocY9Cp3IM/8jfIbktZphmGPWeHqeV9tuq9dn0KhLjpkn1w
         m0xHj0qnyqEdp0w9RnhySQsct7V8tK8dp03JXdWxjSrUvCLqfhJvAI/ey9xpDS+3hBgl
         QSmRd+0Ecw0zLyd9xuKbCZ0K3j9zMdC5UiepZywzQj98+JFEtwl/ruLuR3k4RF4ZMeJM
         0fqTC21+qdBahVLlAKcjGSW0MiaNWdsXqhUgFlWkh3v64Hn8XsgN1/uO0qQpKcVt5V/9
         ND+g==
X-Gm-Message-State: AOAM530AM0IplZadR/74Swig0W6/XwuyvHgp5jZ/GxjPmYiH3yr4VQYm
        6kP3SCaKyQaa88lVUWGGqPF2eAujdb9oAUhOTa6tjw==
X-Google-Smtp-Source: ABdhPJwceZIc9vp8C1oyMdKZ0aN6+YNQpVAZR4wfYVqaS/DJ3skafnhqIYXjs7gDHjt/y1Kw8//L0xFyIRKwNqEhy7A=
X-Received: by 2002:ac8:6d0a:: with SMTP id o10mr5518064qtt.141.1589321609152;
 Tue, 12 May 2020 15:13:29 -0700 (PDT)
MIME-Version: 1.0
References: <20191016060051.2024182-1-andriin@fb.com> <20191016060051.2024182-6-andriin@fb.com>
 <xunymu6chpt2.fsf@redhat.com>
In-Reply-To: <xunymu6chpt2.fsf@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 May 2020 15:13:18 -0700
Message-ID: <CAEf4BzbE3UYw_rKAGNW9HQ5AVeebt=PDuRnEiijrwaKxNsdiYg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 5/7] selftests/bpf: replace test_progs and
 test_maps w/ general rule
To:     Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 1:16 PM Yauheni Kaliuta
<yauheni.kaliuta@redhat.com> wrote:
>
> Hi, Andrii!
>
> The patch blanks TEST_GEN_FILES which was used by install target
> (lib.mk) to install test progs. How is it supposed to work?
>

I actually never used install for selftests, just make and then run
individual test binaries, which explains why this doesn't work :)


> That fixes it for me btw:
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 8f25966b500b..1f878dcd2bf6 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -265,6 +265,7 @@ TRUNNER_BPF_OBJS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.o, $$(TRUNNER_BPF_SRCS)
>  TRUNNER_BPF_SKELS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.skel.h,      \
>                                  $$(filter-out $(SKEL_BLACKLIST),       \
>                                                $$(TRUNNER_BPF_SRCS)))
> +TEST_GEN_FILES += $$(TRUNNER_BPF_OBJS)

Yeah, this makes sense, these files will be copied over along the
compiled test_xxx binaries. Do you mind submitting a patch?

[...]
