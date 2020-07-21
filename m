Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32D0227578
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgGUCPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUCPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:15:00 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFE4C0619D5;
        Mon, 20 Jul 2020 19:15:00 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id l17so19708424iok.7;
        Mon, 20 Jul 2020 19:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=taQyUla0gh1Msgupukn5NQHCGtr6xZmca5OHYc79YLQ=;
        b=F89qB9/WewL/48og69aTlySBGeIgrvww2BBkkRYotygQTo1RlgGrkOPvkmBq8H8beh
         ebRU/4WhGI9hg5WPN6TQYzlqkuWWvUXpKJsdFq03/u5koSwebQRRML3aic+FBHxZhIOH
         H6TF3EWlEzV5Hehnpe/IZxTgcAHLeTuPsm0uteifPJwtXf8aiAIOLLIaLDR2mMWMTK7T
         OC6DoBTEqJbN0QQRJvWsz7VA+I6BTJToeq6GkMatQ7uEzwJTB5n3LqwwOjJXT1vM7Oft
         KcEyhasCCjlo6sPg1sWuCvmHHjgKx2A2Q9Og2ghFJyazd8XNxPNjSjUwQs9ivlWiUJT6
         YgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=taQyUla0gh1Msgupukn5NQHCGtr6xZmca5OHYc79YLQ=;
        b=UQ69maQ4hDeUgycvzR5drjh1/FYp2j/AHhKwZfYFqfDNoqg67MNxBXDBDge/kqqvfA
         ckCdMnCGl5No4FlzZOD9Qf7Y/CAqKZUOvSY+117JWkOwEFWVb/L6zBqAc+iRI3KRk8MG
         1aYXuJwvDkv7SzTLIIDPhtvMDm7CiGMoefMIF2atbVt6fY+FXqAnl8/NdTzVGIcdXBwl
         MMRr9rdgOBHEUhjrS9HPm69ScFtTnHoSvSvgu/49sKoF9MQ7ChB4c2peAnEjiAiBWL7f
         EgSUGtXb4MKo/LnKmniRR46tlc0HOLZgwwfq9uSXn2NQHle+Y1f14+YWB6RSqjdZu99e
         D1ug==
X-Gm-Message-State: AOAM531BQpv+oese4+OJzscl1kJO2DfUxt45d2VvrZ5KtnHjG3uoB/a2
        ms7/fOjn76QvV3QVvKwzo9f18AyW0eZIVmOj2DH38aBjQibP4g==
X-Google-Smtp-Source: ABdhPJwnobcj0HNdBWHIdOr9cfiCq7pJuPK5NSpzHVDts6X2epSQmXer9ZPjh/d95NpE7fcJ3QRlLJrE7G0SJ3A1JT0=
X-Received: by 2002:a02:a408:: with SMTP id c8mr29911094jal.59.1595297699389;
 Mon, 20 Jul 2020 19:14:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200717225543.32126-1-Tony.Ambardar@gmail.com> <fdd2d23f-773d-172c-fce1-0f2641763580@isovalent.com>
In-Reply-To: <fdd2d23f-773d-172c-fce1-0f2641763580@isovalent.com>
From:   Tony Ambardar <tony.ambardar@gmail.com>
Date:   Mon, 20 Jul 2020 19:14:50 -0700
Message-ID: <CAPGftE-WNgEHxDWHVF9aFNK-ZnY=V66SdQPkPpni4qxRZ4rHZA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] bpftool: use only nftw for file tree parsing
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 at 01:13, Quentin Monnet <quentin@isovalent.com> wrote:
>
> On 17/07/2020 23:55, Tony Ambardar wrote:
> > The bpftool sources include code to walk file trees, but use multiple
> > frameworks to do so: nftw and fts. While nftw conforms to POSIX/SUSv3 and
> > is widely available, fts is not conformant and less common, especially on
> > non-glibc systems. The inconsistent framework usage hampers maintenance
> > and portability of bpftool, in particular for embedded systems.
> >
> > Standardize code usage by rewriting one fts-based function to use nftw and
> > clean up some related function warnings by extending use of "const char *"
> > arguments. This change helps in building bpftool against musl for OpenWrt.

[...]

> >  int build_pinned_obj_table(struct pinned_obj_table *tab,
> >                          enum bpf_obj_type type)
> >  {
>
> [...]
>
> >       while ((mntent = getmntent(mntfile))) {
>
> [...]
>
> > -             while ((ftse = fts_read(fts))) {
>
> [...]
>
> > +             if (nftw(path, do_build_table_cb, nopenfd, flags) == -1)
> > +                     break;
>
> Sorry I missed that on the previous reviews; but I think a simple break
> out of the loop changes the previous behaviour, we should instead
> "return -1" from build_pinned_obj_table() if nftw() returns -1, as we
> were doing so far.

Thanks for the catch. Sorry, that's totally my fault: this was meant
to be an "err = nftw(...)" with a "return err" on the common exit
path, similar to the rest of the patch. Let me fix and resend.

Kind regards,
Tony

> Looks good otherwise.
>
> >       }
> >       fclose(mntfile);
> >       return 0;
