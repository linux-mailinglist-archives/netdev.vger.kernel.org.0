Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CC32975EB
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 19:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461757AbgJWRl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 13:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S461716AbgJWRlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 13:41:55 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4E8C0613D2
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 10:41:55 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w21so1898126pfc.7
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 10:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LXf+ps04hNA8w+H1+miMvzPAvHztSBOVbDdk9iOmq8k=;
        b=MnFi588vQfQJmITiUeRUTl7N1y3NTrdlvWnV+UsAmYTKoHTRgUZ3s0jjA/mkUTrzsw
         4jBvh0zMjF1cYrjvYrjJbeTW8e6RtzRIFzoi6nIfhIvJAN1Cut8E0Xh/fVSBmFcIecJE
         d5IYeehTuGOCPdYKx4qrcIiIQaAthk1Q1km2k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LXf+ps04hNA8w+H1+miMvzPAvHztSBOVbDdk9iOmq8k=;
        b=HfKNIHYhlxrmEs0B7odtMITZy57rGKbq2K8X0/f2p6iT/RfH62SesTAQtufcmGzl3h
         ZpbkFR+VcOxA1i5/7YNn75amZPDRruN7bm6xkZlPhwTlrMtxbwSG0m2IOg3ysQp2cx9t
         5yfGZeEFACxRzKra8rsLVxJ0O6vVYsuk70yDu2ozCscLtw96CzpEO/j6tuVVUO1jFkfb
         /gFwxkqWKX4xk0oDiuHDjAWuOQjwrLCXwMmnaIfkHiy6NzgiPTvEINSPL0bR1AEN22XI
         17pUnsoXHltnIzNTx3sRoGR+cQUu5hyv45F48BblMqNRn/eUU++koLf057g9YX7teiEB
         9SjQ==
X-Gm-Message-State: AOAM533bhz9k1TxmIpLUiROtXqILJKpdTZBvrMgdLUYAFEb+NS1mr2js
        4taJmKPr9LTIU/j1HRtWxQ3vfw==
X-Google-Smtp-Source: ABdhPJzNjzldV09CDkT31lkmu0Subn56dMJ8RuLmx5OlvCyYHBlYpnyIwPrAXMJJyGw5A+/mQH1xqw==
X-Received: by 2002:aa7:83c9:0:b029:158:11ce:4672 with SMTP id j9-20020aa783c90000b029015811ce4672mr3221655pfn.23.1603474915101;
        Fri, 23 Oct 2020 10:41:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 197sm2787448pfa.170.2020.10.23.10.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 10:41:54 -0700 (PDT)
Date:   Fri, 23 Oct 2020 10:41:53 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC][PATCH v3 3/3] Rename nla_strlcpy to nla_strscpy.
Message-ID: <202010231041.9FAB4A2714@keescook>
References: <20201020164707.30402-1-laniel_francis@privacyrequired.com>
 <20201020164707.30402-4-laniel_francis@privacyrequired.com>
 <202010211649.ABD53841B@keescook>
 <2286512.66XcFyAlgq@machine>
 <202010221302.5BA047AC9@keescook>
 <20201022160551.33d85912@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <b55d502089c44b3589973fa4e0d90617@AcuMS.aculab.com>
 <20201023082920.6addf3cb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023082920.6addf3cb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 08:29:20AM -0700, Jakub Kicinski wrote:
> On Fri, 23 Oct 2020 08:07:44 +0000 David Laight wrote:
> > FWIW I suspect  the 'return -ERR on overflow' is going to bite us.
> > Code that does p += strsxxx(p, ..., lim - p, ...) assuming (or not
> > caring) about overflow goes badly wrong.
> 
> I don't really care either way, but in netlink there's usually an
> attribute per value, nothing combines strings like p += strx..().
> Looking at the conversion in patch 2 the callers just want to 
> check for overflow.

Right -- this is a very narrow use-case (NLA). I think this series is
fine as-is.

-- 
Kees Cook
