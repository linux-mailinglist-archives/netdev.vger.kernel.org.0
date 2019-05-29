Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5A22D2DE
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfE2AgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:36:11 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42575 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfE2AgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 20:36:11 -0400
Received: by mail-lf1-f68.google.com with SMTP id y13so481068lfh.9;
        Tue, 28 May 2019 17:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zHVQHvdN95XyuKz1DO4twHpntO9M0ikbWPHhVAV0QGQ=;
        b=Qui6Ks6aW+6ZekicI4zDpqszWFZDHA6u6TqPM9RB+vTwqaKtOBXuY64Y4YKNqVLtrp
         luE1POQACVl97jtWqj8JzIZ2UK+/Rx4Wzkw73AUb/ZDhdNfyILvnAePHIiQ2cx7UDTGJ
         JfKT70GOdYREzMPEaXadj1HDAFPB4HgGwPj47Fl2VIPVqhiy+tAZqOeY+eh1evdp+D0o
         HxPX+6HULbDMUpMMZfAmtJigq4tecdLnH1gnzVp7SAl8k/1aqjt9IOi8HWlSzC5RrWaA
         duGuEy9hKsMfkgLgsIurIowMl7gV/WT0YCO7gZP1/73a8nfqRuDKOMYnqPylhTvtwlD4
         S2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zHVQHvdN95XyuKz1DO4twHpntO9M0ikbWPHhVAV0QGQ=;
        b=Mr9qOo+h/suIsmVEWLB21dAocSLibvWYkB7Nn+p9jiTK5CXSh6U2tNRz8tQR9U7XCM
         leo7I6ZmLW8pCPbQMebC9ACRv8me5n5aVGKGrUQGv1SXzPXqJ4++D8XuBnhO4Ze0c+Ff
         yBLQLzjEjuWUhiOHsUtfByVfw2ifDOn7uX5P6In8X3kTMAt9ZoO05+6b0/Com5WwsDnI
         6INLW6Wblo8/z3qi2y/4EusHdbOIGsF2dAuxy80x47e71CSUl0L1wzblJfK5IfpNx1Qg
         NLPPHVWZZn7UdJhHK0GEnXpNmL7baX7UIFvYHwd2uaK7SosCHcFrwpjFymdguNmSmJQG
         z+Cg==
X-Gm-Message-State: APjAAAVqlv2CwzQHXd7Wz1tAp4lTI/RmGCXOjGACTU6OS6IIla0niUVb
        1hVvJ4+airpVhsRWbVqUUpzfhVvrvvqRhu1Xpuo=
X-Google-Smtp-Source: APXvYqwBTOb9HI+K62nLJfrXYu/UDrj5nnKreJd06NaV8a9ZaK1Uk3xeMI5oOTTE9adnTGSjZeFKWP5DnE4Bhg6MFoM=
X-Received: by 2002:a19:ca0e:: with SMTP id a14mr9926757lfg.19.1559090169462;
 Tue, 28 May 2019 17:36:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190524103648.15669-1-quentin.monnet@netronome.com> <20190524103648.15669-3-quentin.monnet@netronome.com>
In-Reply-To: <20190524103648.15669-3-quentin.monnet@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 28 May 2019 17:35:57 -0700
Message-ID: <CAADnVQJ_V1obLb1ZhkKWzuPhrxGBjJOuSbof6VrA6vxT+W463A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add bpf_object__load_xattr() API
 function to pass log_level
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 3:36 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> libbpf was recently made aware of the log_level attribute for programs,
> used to specify the level of information expected to be dumped by the
> verifier. Function bpf_prog_load_xattr() got support for this log_level
> parameter.
>
> But some applications using libbpf rely on another function to load
> programs, bpf_object__load(), which does accept any parameter for log
> level. Create an API function based on bpf_object__load(), but accepting
> an "attr" object as a parameter. Then add a log_level field to that
> object, so that applications calling the new bpf_object__load_xattr()
> can pick the desired log level.
>
> v3:
> - Rewrite commit log.
>
> v2:
> - We are in a new cycle, bump libbpf extraversion number.
>
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
>  tools/lib/bpf/Makefile   |  2 +-
>  tools/lib/bpf/libbpf.c   | 20 +++++++++++++++++---
>  tools/lib/bpf/libbpf.h   |  6 ++++++
>  tools/lib/bpf/libbpf.map |  5 +++++
>  4 files changed, 29 insertions(+), 4 deletions(-)

This commit broke ./test_progs -s
prog_tests/bpf_verif_scale.c no longer passes log_level.
Could you please take a look?
