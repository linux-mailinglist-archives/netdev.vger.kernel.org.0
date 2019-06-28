Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2325A57D
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfF1Tyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:54:43 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36053 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfF1Tyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:54:43 -0400
Received: by mail-qt1-f193.google.com with SMTP id p15so7715083qtl.3;
        Fri, 28 Jun 2019 12:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qy8aMOGiDBOvv28OGN/tZqbRVccwkG+kNDj2nWReKTg=;
        b=tqPYiEeeWx+U7r6aDfqWxIvb1Vt7NSCIAWp6AIIFlDWe+tgM8p6enIDAL27QwDupar
         qkKRyW49q9m7eBrVClOREG2comgKqi60+85pHzQ8HzrTk7zXx6cTVzGESyyy9EkMTBn9
         GVGlC178oDUUa1qBfAOylLDauE18AuB30FIlDToNvmiCJP83m3lbHn8A69aOSd/tuRpj
         wuNtD+d3UDdkH/UEvN3SiGRn2b0Ld1+Rj2iCZUWzmfKDCs5m2W1+UF7hJ9Qsg/uWJlwI
         RTN9Vf5bBc8jMg49DrUMfqYrZQKBYTDBHd7NmMz/hi05C8kJxWowumBuSP8cAjdwBwYm
         IZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qy8aMOGiDBOvv28OGN/tZqbRVccwkG+kNDj2nWReKTg=;
        b=P6wUWYuszs2Ymld1Ujvhq09nZOTIxyjOK1XoDKK8gVul0ZBl1x+HLyGr6BYBrVnKam
         7gSnGiybUXVogR24NhzPNvN1tmSlR6jgWeMvB/fbCDFRIDhFqTEpvsy7Uf5/kib/X4B/
         y87Ow1vw3zafpprtvVa8r0Ubu6o0vGilyPgrFI3yiv2rIsSMc3ZZHfcJ4rC5E2363oXS
         /K7eaiZLJGrW3Btm7EJEfSSHhP/lm3vLovNKrWm/4KgDPzjq2S5+aPEbgeUR+7Cvt4Mr
         9AlThtdrorjyfDYP3vTiQUGcjlHbJxiX3/AiB7o8KwsP3sb2ogiIm1YtEInJHJRBd29c
         VhPA==
X-Gm-Message-State: APjAAAXajLETGBlfrMnj958M6Gu5XVvqP5RSSykfidelg+F1Al+EeHvm
        C3S6elWQqt0HTSJmH5Yn68/CnkwXKipIBP190Xo=
X-Google-Smtp-Source: APXvYqwt7AhVTJdE47VQiQolzNDoK57iBib/um8nZJEt9V3IGywi+FRFSadjqk3bAf1+fQBzL2iNDo8V7Cjy3pV1WB8=
X-Received: by 2002:ac8:152:: with SMTP id f18mr9378180qtg.84.1561751682283;
 Fri, 28 Jun 2019 12:54:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190628055303.1249758-1-andriin@fb.com> <20190628055303.1249758-7-andriin@fb.com>
In-Reply-To: <20190628055303.1249758-7-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 28 Jun 2019 12:54:31 -0700
Message-ID: <CAPhsuW4+T6JuRv4UjmvBBTPNQdjZX01VswVFMYaqGKNyBqpG2g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 6/9] libbpf: add raw tracepoint attach API
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 10:53 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add a wrapper utilizing bpf_link "infrastructure" to allow attaching BPF
> programs to raw tracepoints.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
