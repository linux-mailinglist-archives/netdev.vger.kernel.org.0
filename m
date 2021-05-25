Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA2F38F6E7
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 02:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhEYAQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 20:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhEYAQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 20:16:43 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B58C061574;
        Mon, 24 May 2021 17:15:13 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id g38so40452865ybi.12;
        Mon, 24 May 2021 17:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tt2aCdeG1Qv4Av8IpO8EzxU0Ot8vSguISRVAzIEmy3c=;
        b=bPdJGQFEk57nEGbD0hgdIlYJfgBUa8/woXSJt+g3KgrL2A1QwLu6WOWVLN8M6+OS9M
         KCl4WG7N2FcSqBwSFRN+Lu8EjcSOF2s4StsziYH/u/vudm4UFY2hjOc0tgHmAk0n0Drl
         ZIXrh8yiZgdyImfbwc96SnF/RqJsGiXp+ygSbkv/6+Y3541p9+EDTS6zm8utorP3t/TI
         OkAIlhY6HmKcOc4iO8V1S3EeZ1uusumgxgJ75gdaK/1tdPKZ5x7z5DXe/8Kej4Y7yIH3
         D9yKjdOTO+N3v6mFdPUDXgEwNO6KDlWG4C+O4aZ/AykW+vWLGFv48iO+1Qai8rNEhjsb
         rckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tt2aCdeG1Qv4Av8IpO8EzxU0Ot8vSguISRVAzIEmy3c=;
        b=N4fWOohW8rqGP0dbx2zxM4RopOYcGDH5Kq0hPGn4kL322BT6fPVKemPcV2wUiTEucj
         t5GTn9CgCpTFzU1bf9MVW3Tqn7GotFRqUrvjYOp9djpxKC5UjOiNLZ23ImjVPZ6OUelH
         EybCjkShBiR2cXaxYBq6cNlGM7t63CfrVCAFlw9Q548sRIO8WWyRg87b/zLu/qYeeaKA
         /dlE2qIG3jykXJnzzqvAk1B7z4G3k45tSN8ervNBhrJTwRsrM28tUrh8ULh8p4APvygA
         DnBZcXA8auEH1GQ/wj0HBh9yfxBjihsz71m1WdkFOWUunsQsH0+m0oxsBuXixT0U/c3C
         66YQ==
X-Gm-Message-State: AOAM5322ZQ1x7UrGhOizqAHTmCd8CyOMz2AeRd8CI2rNdCHGQvBeMAle
        kAdyxGJHpdtn++4E109sUAgJHJrjnlIxULhAGkU=
X-Google-Smtp-Source: ABdhPJwU+an/8UWQ2Ts+SUkarp/G/GKMcd2SFsmxFPKesvi1mZEbSaSm/aF4QU5c6aFyiQTiDIUKvw2MOC/lWqTAURU=
X-Received: by 2002:a25:9942:: with SMTP id n2mr39907529ybo.230.1621901713044;
 Mon, 24 May 2021 17:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210521234258.1289307-1-andrii@kernel.org> <20210524234905.n6ycfsmgqhn5ai3p@ast-mbp>
In-Reply-To: <20210524234905.n6ycfsmgqhn5ai3p@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 May 2021 17:15:02 -0700
Message-ID: <CAEf4BzYQc+ijF78vX14CXi9My7hJ_+XNpnh1ZcMjpcdT1czHmA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/5] libbpf: streamline error reporting for
 high-level APIs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 4:49 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, May 21, 2021 at 04:42:58PM -0700, Andrii Nakryiko wrote:
> >
> > +/* this goes away in libbpf 1.0 */
> > +enum libbpf_strict_mode libbpf_mode = LIBBPF_STRICT_NONE;
> > +
> > +int libbpf_set_strict_mode(enum libbpf_strict_mode mode)
> > +{
> > +     /* __LIBBPF_STRICT_LAST is the last power-of-2 value used + 1, so to
> > +      * get all possible values we compensate last +1, and then (2*x - 1)
> > +      * to get the bit mask
> > +      */
> > +     if (mode != LIBBPF_STRICT_ALL
> > +         && mode & ~((__LIBBPF_STRICT_LAST - 1) * 2 - 1))
> > +             return libbpf_err(-EINVAL);
> > +
> > +     libbpf_mode = mode;
> > +     return 0;
> > +}
>
> This hunk should be in patch 1, right?
> Otherwise bisection will be broken.

Yeah, I screwed up splitting those changes into patches :( Thanks for
noticing, I'll send fixed v2 a bit later tonight.
