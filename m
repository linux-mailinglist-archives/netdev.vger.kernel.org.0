Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33BE3D97EB
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 23:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhG1V4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 17:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhG1V4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 17:56:34 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C812EC061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 14:56:32 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t21so4373227plr.13
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 14:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HZwmvCaIsPtNlFau8xRfO0wSxpkKiZeYhRsp0hhs6yw=;
        b=hOKYAGtG8p+bAHn079A+GM3Py/fP7BGZDuwsW4Mjq9e8qxEHkXaIX8EFN5D2fIwLEi
         ZFtJ1zO9oQPVoZsB0XSK72Q2e/dGGKnZNiWhA/JY3Rin/dkgbv2Nf8xBAGlU16+rs1d5
         sh9E8Z/HoNqY67Kuijgp3iycbdTBVU2mbaxLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HZwmvCaIsPtNlFau8xRfO0wSxpkKiZeYhRsp0hhs6yw=;
        b=AQ2hEQ0Jzi//pnXv/Ry3zWR+IG26GOLn5155f+qomCfcTogyQKTIG2HQEU7ouPAoiI
         nmwgaOwMKMZgx2roH8Tc1lSGZyqUo++K6TkTW+x/nxhWO9vt9yacJugA22tAC4vGJfXW
         3IxjZZV7d4YhXJpZQPP5ODyAnmPb8cB+SmmShnCjX/cAu+vjUyJ7MTX7ixigwNNXfjCs
         2vuLG7Z8aotgsXM96Wte8hk4KAz0a9NggPEPWbIxsSRxAssEhueAeInGMlybkxzRfUfG
         7GJfeXfxBEmv+nG0KFtxDGLJkppISm/vtzRoUOP5kZxyB9byNhkiL0xJzTIXLkiYEDaY
         il/A==
X-Gm-Message-State: AOAM5313jTwb/GNj5jsXqdre/eaTY/S27kHKWmFOAB/KP328VXltpGTa
        +5G40SmL9BJBGwMR+YWoD6AqcA==
X-Google-Smtp-Source: ABdhPJzYF1ZeTn1uxmA0auYJjoAviEKmg5jmTnExS/QLj8lRKV0fiEUKYsUTv/gKWeJm4puGljAjtg==
X-Received: by 2002:a17:90a:44:: with SMTP id 4mr1792767pjb.130.1627509392397;
        Wed, 28 Jul 2021 14:56:32 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k8sm947353pgr.91.2021.07.28.14.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 14:56:31 -0700 (PDT)
Date:   Wed, 28 Jul 2021 14:56:31 -0700
From:   Kees Cook <keescook@chromium.org>
To:     dsterba@suse.cz, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 47/64] btrfs: Use memset_after() to clear end of struct
Message-ID: <202107281455.2A0753F5@keescook>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-48-keescook@chromium.org>
 <20210728094215.GX5047@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728094215.GX5047@twin.jikos.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 11:42:15AM +0200, David Sterba wrote:
> On Tue, Jul 27, 2021 at 01:58:38PM -0700, Kees Cook wrote:
> > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > field bounds checking for memset(), avoid intentionally writing across
> > neighboring fields.
> > 
> > Use memset_after() so memset() doesn't get confused about writing
> > beyond the destination member that is intended to be the starting point
> > of zeroing through the end of the struct.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  fs/btrfs/root-tree.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> > 
> > diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> > index 702dc5441f03..ec9e78f65fca 100644
> > --- a/fs/btrfs/root-tree.c
> > +++ b/fs/btrfs/root-tree.c
> > @@ -39,10 +39,7 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
> >  		need_reset = 1;
> >  	}
> >  	if (need_reset) {
> > -		memset(&item->generation_v2, 0,
> > -			sizeof(*item) - offsetof(struct btrfs_root_item,
> > -					generation_v2));
> > -
> 
> Please add
> 		/* Clear all members from generation_v2 onwards */
> 
> > +		memset_after(item, 0, level);

Perhaps there should be another helper memset_starting()? That would
make these cases a bit more self-documenting.

+		memset_starting(item, 0, generation_v2);

> >  		generate_random_guid(item->uuid);
> 
> Acked-by: David Sterba <dsterba@suse.com>

What do you think?

-Kees

-- 
Kees Cook
