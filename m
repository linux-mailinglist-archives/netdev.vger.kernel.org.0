Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE653DDD89
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbhHBQXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhHBQXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 12:23:36 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A5EC06179A
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 09:23:26 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k4-20020a17090a5144b02901731c776526so32437176pjm.4
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 09:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JaILGVZ5ZfAh5yd44e+vxSRLCop37r4sy9cxjRO/kVU=;
        b=aw1kgIMmRz0YMmD8jXYt7yhGZxHLHmcNQFLrG40MdDJ4dxtp5Dp6z04FghrmAgWxls
         ibbc21J6Lj1o0KA7GwJpBkMxWoCQKSfGPfoyBryQnP/vDd6QBrsp3tbdnfeGJcBe4xv4
         fS1shEaQqJCHHvIk5MIu8rA0hZEvPYJj50Zzs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JaILGVZ5ZfAh5yd44e+vxSRLCop37r4sy9cxjRO/kVU=;
        b=cchH39j3aH0c2vUPmwNbOJE4IwPhaJ6yLznXcado7/FL4jXJmBz8gJN6WNvJTTmdJK
         zTDvhHvJ+Yjg7+aQ0z9L0E6JlF8F91NKj0qAfSFPM1cBl7M60n8sPOHldx//q7MCH4Yr
         Otcv/6dOO02JaKQ1oPFGRcklOcc1ObWCPO+dR3dKF+Klt5EoK4OaemGaPhBqkS6QRB6o
         gh2p3lJJJ8eT3xqiGFYx/QU2x2xhYXr6N43T7mJzJkMfvLMhGMy04tbDvQ+faw7HXbr4
         y3pe3jeWj4AnhmUcbaU/s77/+9q67muilfu2gnq905Vv8XSy6dQX7oDmlFZ19umCxyfi
         Jhvw==
X-Gm-Message-State: AOAM531fJcD5tSfZt3Ejj17pItDh/dqK68MpOiF1xB6ND5yJsc3mWP3u
        NL6QTBvMfNrLmcwmzCrBJmLR0g==
X-Google-Smtp-Source: ABdhPJyna/JEEPlWGNR2S+ZqJqCzOPLMMoqPYs8YB21x4PV9XLYXx00eTM9yttg27rSVI2z426vQLw==
X-Received: by 2002:a63:4a49:: with SMTP id j9mr2250552pgl.20.1627921406097;
        Mon, 02 Aug 2021 09:23:26 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s193sm13206950pfc.183.2021.08.02.09.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 09:23:25 -0700 (PDT)
Date:   Mon, 2 Aug 2021 09:23:24 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Shai Malin <smalin@marvell.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: Re: [PATCH 42/64] net: qede: Use memset_after() for counters
Message-ID: <202108020922.FE8A35C854@keescook>
References: <SJ0PR18MB3882DC88DB04C9DE68678CEDCCEF9@SJ0PR18MB3882.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR18MB3882DC88DB04C9DE68678CEDCCEF9@SJ0PR18MB3882.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 02:29:28PM +0000, Shai Malin wrote:
> 
> On Tue, Jul 31, 2021 at 07:07:00PM -0300, Kees Cook wrote:
> > On Tue, Jul 27, 2021 at 01:58:33PM -0700, Kees Cook wrote:
> > > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > > field bounds checking for memset(), avoid intentionally writing across
> > > neighboring fields.
> > >
> > > Use memset_after() so memset() doesn't get confused about writing
> > > beyond the destination member that is intended to be the starting point
> > > of zeroing through the end of the struct.
> > >
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > ---
> > > The old code seems to be doing the wrong thing: starting from not the
> > > first member, but sized for the whole struct. Which is correct?
> > 
> > Quick ping on this question.
> > 
> > The old code seems to be doing the wrong thing: it starts from the second
> > member and writes beyond int_info, clobbering qede_lock:
> 
> Thanks for highlighting the problem, but actually, the memset is redundant.
> We will remove it so the change will not be needed.
> 
> > 
> > struct qede_dev {
> >         ...
> >         struct qed_int_info             int_info;
> > 
> >         /* Smaller private variant of the RTNL lock */
> >         struct mutex                    qede_lock;
> >         ...
> > 
> > 
> > struct qed_int_info {
> >         struct msix_entry       *msix;
> >         u8                      msix_cnt;
> > 
> >         /* This should be updated by the protocol driver */
> >         u8                      used_cnt;
> > };
> > 
> > Should this also clear the "msix" member, or should this not write
> > beyond int_info? This patch does the latter.
> 
> It should clear only the msix_cnt, no need to clear the entire 
> qed_int_info structure.

Should used_cnt be cleared too? It is currently. Better yet, what patch
do you suggest I replace this proposed one with? :)

Thanks for looking at this!

-Kees

-- 
Kees Cook
