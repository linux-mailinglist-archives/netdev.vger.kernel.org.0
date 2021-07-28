Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDC43D972F
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 23:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhG1VBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 17:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbhG1VB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 17:01:29 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD47DC0613D3
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 14:01:26 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso5918931pjf.4
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 14:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v4TsexyUVtPmnWQp8z0vQybdqGDFJ+IKH3X3D8imsE4=;
        b=hg+gKirQh4CStWcllp3dCMDGaMydMxkrfDz7dI28grfxRHealC37a8xJDfYI0FVrQZ
         2tYUG05gAJbnL7ZSiMGxXN0BbgqYaSHUyURFCYtvwZV0Mx+omFId8CJj1UovnV0ee9cA
         66wsvWC92AbI6ez9cGn13eYUvZ7XhoUJQlPzE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v4TsexyUVtPmnWQp8z0vQybdqGDFJ+IKH3X3D8imsE4=;
        b=euXEnU/QEHCednM4oAoHEpCGMX0sKeKPla3kRHOx+AFk6a3wAR/DA2rjGZj9n27Dzb
         QbWrFsW0YR5ocSGfgztru9nxE4ziq9rkrEPbxCETZoV7adXYkKHeNAD0By5Rv/q3SIvj
         EzfwPbQjRISrm7Ds2DCSunzMcsAKmuy4+PqUowSwCsP+/s0mAbZ3Gr9RqKXKss0MRFYc
         0v/2d+LBQlpabmGN3olRNFgABOcpEjq0ASfLiSIuNSR6JYSRp56o8eXPnT0wc1dVqKgV
         M5lmo+wcffCca66r+qBq/L7BuofOQZnbWL7i9NqIzu/P5DW9XW/S+zGLOXRNIQ6bvcuB
         YCeg==
X-Gm-Message-State: AOAM533U32PeWgs2V+yqr/Xh7Re/zIdBezxDckfD2RCr6BZxfUK3P4dj
        W/5Jc5Ye63EXh59xKWYx+4Ts0Q==
X-Google-Smtp-Source: ABdhPJzkF5cilzb73BCpcxICFq3XUeRAJh6fZICuqCaVMVL6bCDUAwLUBtlkfh9/lXbLB+5T11D9+w==
X-Received: by 2002:a17:902:d717:b029:12c:1653:d611 with SMTP id w23-20020a170902d717b029012c1653d611mr1508273ply.51.1627506086388;
        Wed, 28 Jul 2021 14:01:26 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t3sm932392pfd.153.2021.07.28.14.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 14:01:25 -0700 (PDT)
Date:   Wed, 28 Jul 2021 14:01:24 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 19/64] ip: Use struct_group() for memcpy() regions
Message-ID: <202107281358.8E12638@keescook>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-20-keescook@chromium.org>
 <YQDxaYrHu0PeBIuX@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQDxaYrHu0PeBIuX@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 07:55:53AM +0200, Greg Kroah-Hartman wrote:
> >  struct ethhdr {
> > -	unsigned char	h_dest[ETH_ALEN];	/* destination eth addr	*/
> > -	unsigned char	h_source[ETH_ALEN];	/* source ether addr	*/
> > +	union {
> > +		struct {
> > +			unsigned char h_dest[ETH_ALEN];	  /* destination eth addr */
> > +			unsigned char h_source[ETH_ALEN]; /* source ether addr	  */
> > +		};
> > +		struct {
> > +			unsigned char h_dest[ETH_ALEN];	  /* destination eth addr */
> > +			unsigned char h_source[ETH_ALEN]; /* source ether addr	  */
> > +		} addrs;
> 
> A union of the same fields in the same structure in the same way?
> 
> Ah, because struct_group() can not be used here?  Still feels odd to see
> in a userspace-visible header.

Yeah, there is some inconsistency here. I will clean this up for v2.

Is there a place we can put kernel-specific macros for use in UAPI
headers? (I need to figure out where things like __kernel_size_t get
defined...)

-- 
Kees Cook
