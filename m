Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC044D4999
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbfJKVBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:01:31 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]:43630 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729102AbfJKVBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 17:01:30 -0400
Received: by mail-qk1-f169.google.com with SMTP id h126so10150832qke.10
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 14:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbuki-mvuki-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gP/Ra7/7NFzVHASAiihwvWITFKy1RdtjWNZKOjmnOLU=;
        b=hYwQHZojNaucbmUh4agwr5tlEm1iP7cIYHeAB3umlOtwOniYgZBb4CO3OhPD2B10ig
         2JkSSQU5xftOnt1XskY+aET21xaRgZ2Ao615Ea3L0yKrYJsvwToIFh352la8pUtWTdwG
         HvJib+kpVXGlOJEz5tUydHTcR8l4Axna99tRdD1ARoD8doSUUe6yyKGfCRwYv5E56p5H
         hbc6D4B4F8BT6+JQ2mWmJt6+9qM9YVGIlYx2TQpN2nYGiNsA0+R8BjNLCngOn43faryQ
         Xk6j5XeDwBG8OBv6Ca0FFE/2e4ZB5v6D69LbHWPqm7ghdEtTWY53S9IcJQRFxjGcztfF
         v+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gP/Ra7/7NFzVHASAiihwvWITFKy1RdtjWNZKOjmnOLU=;
        b=PE+j57DNPHvbG3az8XTvsfsvcIuQHH8tRS+OMqcegkqm2caxgPDBl8YQV3DrspcVvw
         /0RQiuCP1Bm8dQ2gswyE545Nps0mjTf+fYycvR1n2QMD5ZcbkNUTen7UNC3dGKGLiK8F
         hmO4hB/KzfPgLKZYtR/ji0bqJ+MoA5ccOC8kIkTUHGWTlsQ7s8wfUuDUgI1gbA5oapeH
         NMB572rBrTLrWLzjD1bC732RnEESdXb4R49biPrZ63bksF6QC3PTS5pdFpvB09gu8l/I
         QSyfEb51uZ0nJn8pxDmSLIjNS1IkYKTu7zj8bJtug9DYJpZk0Y7u1PjOnCRVqOck7GIR
         C08w==
X-Gm-Message-State: APjAAAWEhRV/+OAWO1YGHXC1NVTNh2I+4f6sSOCTMNg4vMQXzk6hB28j
        larEazB6ZId5SMBKPuIcbydLOIKHI3uKUx2cE8p6Tw==
X-Google-Smtp-Source: APXvYqz8rL7U+g6ZhdbJ9Sk7HS9jo31q8XsJY2PX8ZyCEpZ/3KalyHPzGh+mXgFjGkiezeM61S7uF+zMRHyj0TuI7NM=
X-Received: by 2002:a37:6114:: with SMTP id v20mr17657591qkb.339.1570827689562;
 Fri, 11 Oct 2019 14:01:29 -0700 (PDT)
MIME-Version: 1.0
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter> <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
 <20191011154224.GA23486@splinter> <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
 <20191011181737.GA30138@splinter> <20191011182508.GA30970@splinter>
 <CAEA6p_CXZyUQf_DKhs7nQ5D0C7j1kM7bzgcyS2=D_k_U7Czu8w@mail.gmail.com> <20191011185250.GA31385@splinter>
In-Reply-To: <20191011185250.GA31385@splinter>
From:   Jesse Hathaway <jesse@mbuki-mvuki.org>
Date:   Fri, 11 Oct 2019 16:01:18 -0500
Message-ID: <CANSNSoUp=wK7zYezQgMs-uX=1jYy1txCFEGJH=GuoNEpb4d7Lw@mail.gmail.com>
Subject: Re: Race condition in route lookup
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 1:52 PM Ido Schimmel <idosch@idosch.org> wrote:
> I think this is fine.
>
> Jesse, can you please test Wei's patch?

I tested with a patched kernel using the same scripts and it does seem to
resolve the issue, thanks!
