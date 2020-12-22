Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9242E0C4C
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 16:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgLVPBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 10:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbgLVPBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 10:01:54 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4EBC0613D3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 07:01:13 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id r5so13141567eda.12
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 07:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ist76ku/eI9g9aKNEvnTWGLg70PGAK8h1pcGHAbVGGk=;
        b=mNiPkIU6/S5cUtp4NAGUPoNlGVhni1qmY9KTYoYDvgFFa3FNNCQaIXz2KGmSW9HCuk
         jpdB3mIExFlxm+YyZr7uio347bPZov6oZ1WV4yiVAOg1kWRT5zd6tREPPkXftnrFSw+G
         m7cS4JzbpLJ50pxVdtYlm2mpER97NJwgC77BlxrkoQ13JftM957tVctqje4MpRd0OCxd
         3phA0glcbRAoCZBW2F8Tq1i4CR5A3OXBJvXGDO2GWrwKm9GLwOUOOpYGjqofhUhYCTN6
         3fKk3wBKV3Wz4Wo/7ESDA5TGR5+cs2wJQHCESu/nmwrfttlepNXPqiKHygZfnlAEadpJ
         WlKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ist76ku/eI9g9aKNEvnTWGLg70PGAK8h1pcGHAbVGGk=;
        b=AjxcDBrfnf/BPg3e+Ym7QCh7Z9az+Xnx3n762a5RqZT17kWoRPVm3wOF6irkKpx+YS
         ELexZt9F0BwjpuO3anBZR1ccEt/xkPLieXa7kZdN2GOWYPjrtbw+hwQtHgpL6i1kGjZf
         Id4IMDa2+g2DKZGfC2t8TNGHwDTpUBYFq/9X8I/bTZXKP106kjLu7abvcqTB5MJapHxj
         MDQmWd77QQ4jZRLk6pYoaHt2HHJf//xB8kDSxLAhbcAnbwy/POy4cgfooWzaw5J8FzJv
         721o5sWGVB5xi+QWvbn5zvyK/fnJ4VeIOmSMcNVnIrYZVBn5IfjiFU2p6avZSVPju0q1
         F3dg==
X-Gm-Message-State: AOAM531wxRDcIFS/5wwgj7OM2MftiFu5Jy3UeasWbPfTnwPnR2M1EZHw
        xTW9AGIBubyAQZy+aCRJPHdL7LhrJPyTKGpOA84=
X-Google-Smtp-Source: ABdhPJzJJUvdgWN4/q3xCYSPcsfAu+WsF/J/nNrdFSWIWO/ZyG67dQFtoeUa2WbfCpLxFy3PzXSudBvV1Q3MZJD55yQ=
X-Received: by 2002:a50:9f4a:: with SMTP id b68mr20503992edf.296.1608649272624;
 Tue, 22 Dec 2020 07:01:12 -0800 (PST)
MIME-Version: 1.0
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com> <20201222000926.1054993-10-jonathan.lemon@gmail.com>
In-Reply-To: <20201222000926.1054993-10-jonathan.lemon@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 22 Dec 2020 10:00:37 -0500
Message-ID: <CAF=yD-+W93Gz4QygA=J0zME=sxVwzkKw3Q9BviwzNwkjziXPmg@mail.gmail.com>
Subject: Re: [PATCH 09/12 v2 RFC] skbuff: add zc_flags to ubuf_info for ubuf setup
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> From: Jonathan Lemon <bsd@fb.com>
>
> Currently, an ubuf is attached to a new skb, the skb zc_flags
> is initialized to a fixed value.  Instead of doing this, set
> the default zc_flags in the ubuf, and have new skb's inherit
> from this default.
>
> This is needed when setting up different zerocopy types.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/linux/skbuff.h | 3 ++-
>  net/core/skbuff.c      | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index da0c1dddd0da..b90be4b0b2de 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -478,6 +478,7 @@ struct ubuf_info {
>                 };
>         };
>         refcount_t refcnt;
> +       u8 zc_flags;
>
>         struct mmpin {
>                 struct user_struct *user;

When allocating ubuf_info for msg_zerocopy, we actually allocate the
notification skb, to be sure that notifications won't be dropped due
to memory pressure at notification time. We actually allocate the skb
and place ubuf_info in skb->cb[].

The struct is exactly 48 bytes on 64-bit platforms, filling all of cb.
This new field fills a 4B hole, so it should still be fine.

Just being very explicit, as this is a fragile bit of code. Come to
think of it, this probably deserves a BUILD_BUG_ON.
