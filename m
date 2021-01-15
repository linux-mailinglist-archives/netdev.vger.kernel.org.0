Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2279D2F7152
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 05:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732829AbhAOEAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 23:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732822AbhAOEAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 23:00:46 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF6BC061575;
        Thu, 14 Jan 2021 20:00:05 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id x20so11224033lfe.12;
        Thu, 14 Jan 2021 20:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E0XjuZJ3EZHxNpAUlNb0DkG+6+sra0VhluL9Rzgb1ZY=;
        b=PEXblVoHmtOn61RuXyD2H55L88JCeMRIXM/+xO7F74KbuZQYahM0FjvSDYzxTNBlzo
         y/xxY4iRKWDgbjgHaGm8W8XunJOFJ+Wu8MhCGZ/74ZP4YT0VNFB6Zel66QmcguLTZUg9
         XZX48JzZ7P28QPkI9ViYAmH7c7xslRSE9CbRISWm8vpmumK9dxGnHzfoYUG0Z34S4O9T
         ERUij8LRj07w3dnj2bMeHSDVGdAbZ60Ci6IypRWfqvYJjxDATdeuE9SGqD9rgpmHbtJd
         ngcrDeLfzHaFddzsS5NyxW867apVR7A4ZErEfy8j5tgSg/FHg4alnsBwuuPkSNC8SzCg
         gjfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E0XjuZJ3EZHxNpAUlNb0DkG+6+sra0VhluL9Rzgb1ZY=;
        b=iby/BsR+qp8ZpxX50XsBg7YfjQLtqRdg4qUHeJaT6BCXXeYrnBMHAszxQo7on6dLKg
         cBAH6Pk8KABZXFkKc4G1stINcsDg7z1Lm4cBMXg9SAakuxle3+nJa4YvJgChqgfOGFts
         hMjBVggeT3r7cqwZByqSqWt1FxKoE9rrJip03/h5kIocFN7dV4LvkWF5xCdq1VDY5qDW
         RM83RoseOryGgAcDApTRfHHThXmKkOvJwCPqT7saTnFGOsKfEXxiBboqNgsvJhXOTl3Z
         5NSzFBz2XBtCKG8k4Ng41gwzV5Jh/6CScD+XbpXkn/NryQfpdDlhCgnX6jLPv1GAs1eI
         UOtQ==
X-Gm-Message-State: AOAM533NjRvuvIIQM35TkeIBQBUTdjEJIf1+tiM1V/md/x7cf6f1LXrY
        2eFm1UEwKKoCpzZGkhlLpZVO+UkOv0a//xb9dDmX1ZZj
X-Google-Smtp-Source: ABdhPJzpEyZZ/lgeKI1oEBzNzLdeZoc1adKDMWn4l8m4Xu795BVXTRBXlxi9ZBELoJjIF0INjLqgz4M1TpQgXNA5KH4=
X-Received: by 2002:a05:6512:34c5:: with SMTP id w5mr4826307lfr.214.1610683204044;
 Thu, 14 Jan 2021 20:00:04 -0800 (PST)
MIME-Version: 1.0
References: <1627e0f688c7de7fe291b09c524c7fbb55cfe367.1610669653.git.sdf@google.com>
 <CAEf4BzZOt-VZPwHZ4uGxG_mZYb7NX3wJv1UiAnnt3+dOSkkqtA@mail.gmail.com> <CAKH8qBuvbRa0qSbYBqJ0cz5vcQ-8XQA8k6B4FS-TNE1QUEnH8Q@mail.gmail.com>
In-Reply-To: <CAKH8qBuvbRa0qSbYBqJ0cz5vcQ-8XQA8k6B4FS-TNE1QUEnH8Q@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 Jan 2021 19:59:52 -0800
Message-ID: <CAADnVQJwOteRbJuZXhbkexBYp2Sr2R9KxgTF4xEw16KmCuH1sQ@mail.gmail.com>
Subject: Re: [RPC PATCH bpf-next] bpf: implement new BPF_CGROUP_INET_SOCK_POST_CONNECT
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 7:51 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > >         lock_sock(sock->sk);
> > >         err = __inet_stream_connect(sock, uaddr, addr_len, flags, 0);
> >
> > Similarly here, attaching fexit to __inet_stream_connect would execute
> > your BPF program at exactly the same time (and then you can check for
> > err value).
> >
> > Or the point here is to have a more "stable" BPF program type?
> Good suggestion, I can try to play with it, I think it should give me
> all the info I need (I only need sock).
> But yeah, I'd rather prefer a stable interface against stable
> __sk_buff, but maybe fexit will also work.

Maybe we can add an extension to fentry/fexit that are cgroup scoped?
I think this will solve many such cases.
