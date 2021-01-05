Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB4A2EB3E4
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 21:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbhAEUC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 15:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731178AbhAEUC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 15:02:58 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87434C061574;
        Tue,  5 Jan 2021 12:02:17 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id x20so1221301lfe.12;
        Tue, 05 Jan 2021 12:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DEpWYpLAj3TWxnfaAnWIv/bvFg1b8cW5KX0oeuUb66k=;
        b=T0Orix7j9KfUw3M0K1OzXzsVfO37VECtP7BSUzM4tnkjMBNcA9M0tCVh9YIXHtPS0w
         IQ3Khy2S0WsqlRPa4zj4JiobTqgo/1Vkr2ignN2CPOM3IdPYR4GShxvjGGbYdqR4oVTJ
         W+VeZvu1H7lVQaFUOAbQ11BpxiM5PDmcpLjUPavxd4FsGXtJfeKN1msFt026rH9+FQX/
         ZUXNRHgajzzC1Wik4rT1Ih15sTzDqCQMgN4ihAyfr6wSDq/+VBJkkLP3U2snGF1c9kdC
         TSZW6AgGiimrld+MHblKI07W537VjUD+jGk7AQUdkUUbpej1BIO23XaY1QgBDtzc0YkV
         ORNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DEpWYpLAj3TWxnfaAnWIv/bvFg1b8cW5KX0oeuUb66k=;
        b=SdUapxtYAje80PH+CkQpndOODm34Fgunaa9WaZtXC+nMCQ7JEDWTsKPmUugq1Gt5R+
         dfj9qAJzUUqlYnS6barkGlDSagtZ0/hSIk53v+odnMePu5UsE7J9l/uOpfhJQ+/mRirt
         0mPuK65ovpTH/lUs8jlEZdUJ4o2DhUoQS+mrstdHUZCkwWjmAJd1tKpmpzAvxEiz85X/
         S1X9zxqj1U5z6M2zixH/E8Ri/ghdOQ7kKuAf5clMMkRguw6JNK+E+Kn9BcGzq5NB2IbN
         7Vi+9w8HUIbf16Ip6zs/BJbItZe8ToN5BLxdSHwp7FTBRyVWUdxt8pllL7q12s5LVepc
         upOg==
X-Gm-Message-State: AOAM531WLqLz0qhTleuI0sc8vTp3xKZzbNeaHAzhKkdTtDTW6xlMxW3P
        uWdzFhbAsgH5nVzQ93N8b+tO3i3MNzCKXZgkAU8=
X-Google-Smtp-Source: ABdhPJyYlu+lEre8vkga5faJ/L3OHgkRcqU8tpLfK/pJ+YE6yLweDflEXSzJB0e92UOioQVn6Geq1LhM3ErF28tirPw=
X-Received: by 2002:a19:acd:: with SMTP id 196mr418460lfk.539.1609876936092;
 Tue, 05 Jan 2021 12:02:16 -0800 (PST)
MIME-Version: 1.0
References: <20210105153944.951019-1-jolsa@kernel.org> <CAADnVQJSry=o-GOPT0XL0=qGrikz=TuP=Wx7fHyiQVjLqMcOxA@mail.gmail.com>
 <20210105195030.GA936454@krava>
In-Reply-To: <20210105195030.GA936454@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 5 Jan 2021 12:02:04 -0800
Message-ID: <CAADnVQLf426mmqofhnA2eD7dAsG+DTaAM5GueS9PTqq0ooxf5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Warn when having multiple
 IDs for single type
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 11:50 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Jan 05, 2021 at 11:37:09AM -0800, Alexei Starovoitov wrote:
> > On Tue, Jan 5, 2021 at 7:39 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > The kernel image can contain multiple types (structs/unions)
> > > with the same name. This causes distinct type hierarchies in
> > > BTF data and makes resolve_btfids fail with error like:
> > >
> > >   BTFIDS  vmlinux
> > > FAILED unresolved symbol udp6_sock
> > >
> > > as reported by Qais Yousef [1].
> > >
> > > This change adds warning when multiple types of the same name
> > > are detected:
> > >
> > >   BTFIDS  vmlinux
> > > WARN: multiple IDs found for 'file' (526, 113351)
> > > WARN: multiple IDs found for 'sk_buff' (2744, 113958)
> > >
> > > We keep the lower ID for the given type instance and let the
> > > build continue.
> >
> > I think it would make sense to mention this decision in the warning.
> > 'WARN: multiple IDs' is ambiguous and confusing when action is not specified.
>
> ok, how about:
>
> WARN: multiple IDs found for 'file': 526, 113351 - using 526

yep. much better imo.
Please add a comment to .c file with the suggestion that such types should
be renamed to avoid ambiguity.
Adding 'please rename' to WARN is probably overkill.
