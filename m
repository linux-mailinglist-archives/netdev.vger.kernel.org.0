Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B1C2301AE
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgG1FZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgG1FZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 01:25:18 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488EDC061794;
        Mon, 27 Jul 2020 22:25:17 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id o2so8598715qvk.6;
        Mon, 27 Jul 2020 22:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uMG2E9ERlheSGqhkueag38fHAjdWXtqM4nID+dc8E/g=;
        b=KC1N6Z6hWjSjz3GGPoqv9xQ5D9wn4C7XIVUQNWu1zBxbmPPOcek1uoJbXhTMFkI7Q4
         mTlOy2b23FMMTL1god2xSgOgahW81J8EBM6oEP2d6T9YEhbVsTWjtiINp9nwoSx0J/zi
         BI9dFdVHMTM3RLdM9wnpiQ7jgEwH9QDqo2aHb2SDpeaeMOVzEO+MTXWtDMjE/x/HnWn4
         uV3DiAQOlmQNf+hVqr3KK48+BS1Ik+0llFVq6kTJZj10wCC0u0ZnOJdW9T9SScK0p+Cm
         DDd1EW6C7FSD5ocoVc9QDGqwUrqSro0j94pH2irvNuUhqqx/EoznyskUrQZ4KR8y2W6r
         wjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uMG2E9ERlheSGqhkueag38fHAjdWXtqM4nID+dc8E/g=;
        b=ZpEyhAGJJ4cOVnIUhsW1PxDwoupB3pLnsjmYg6XYU1cEaZ9c3qwdScOKy9oRPbQZYk
         tfWzU+75YSqeYO9sCIgO40VZnscXA12gqn10UU5v2gAISBFaSF1+KE+eByxAHrHBYL7E
         l7pf6Sh7WQMbuuXHQp3EMGYzlW2EJwrQ+Ma3Q6P4FDPQjsGd9rc9xzggqqgh7OUHVM3S
         tw7h/Deu2pJfS+HVaa71N/cprwFpkpNM5nej4/hOu30h9Ufc8FIrWFLQDEpxwB5EtVmr
         87CJsdEfDu20sSUuzQRd+z3zLRGJzS0phKnB/tr/7upw1xC9kmC34W7qjm6qQsUYwQ1u
         Kq7Q==
X-Gm-Message-State: AOAM531ZSESBRMnQDY6INV9swCsmanZEo0A+4avkTphtYiU0Xtvdl1pb
        y9tDiNLHeE0aIbIzszK9yw==
X-Google-Smtp-Source: ABdhPJxEAi3ePhzTiJgG1WNKZ47AnDwjuRfnIggpeFZH5/C/YrbhEcBx+RahM842JsUDgJfcEj76zw==
X-Received: by 2002:a05:6214:2d2:: with SMTP id g18mr25385356qvu.215.1595913916460;
        Mon, 27 Jul 2020 22:25:16 -0700 (PDT)
Received: from PWN (c-76-119-149-155.hsd1.ma.comcast.net. [76.119.149.155])
        by smtp.gmail.com with ESMTPSA id b8sm17235205qtg.45.2020.07.27.22.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 22:25:15 -0700 (PDT)
Date:   Tue, 28 Jul 2020 01:25:12 -0400
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Song Liu <song@kernel.org>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-kernel-mentees] [PATCH net] xdp: Prevent kernel-infoleak
 in xsk_getsockopt()
Message-ID: <20200728052512.GA404005@PWN>
References: <20200728022859.381819-1-yepeilin.cs@gmail.com>
 <CAPhsuW7L6KWAM55=oLgQ2MtoJOB9i4mwZHOVF+KJj7W5ht_+YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW7L6KWAM55=oLgQ2MtoJOB9i4mwZHOVF+KJj7W5ht_+YQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 10:07:20PM -0700, Song Liu wrote:
> On Mon, Jul 27, 2020 at 7:30 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
> >
> > xsk_getsockopt() is copying uninitialized stack memory to userspace when
> > `extra_stats` is `false`. Fix it by initializing `stats` with memset().
> >
> > Cc: stable@vger.kernel.org
> 
> 8aa5a33578e9 is not in stable branches yet, so we don't need to Cc stable.
> 
> > Fixes: 8aa5a33578e9 ("xsk: Add new statistics")
> > Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> > ---
> >  net/xdp/xsk.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index 26e3bba8c204..acf001908a0d 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -844,6 +844,8 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
> >                 bool extra_stats = true;
> >                 size_t stats_size;
> >
> > +               memset(&stats, 0, sizeof(stats));
> > +
> 
> xsk.c doesn't include linux/string.h directly, so using memset may break
> build for some config combinations. We can probably just use
> 
> struct xdp_statistics stats = {};

I see. I will send v2 soon. Thank you for reviewing the patch!

Peilin Ye
