Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48DD01147A4
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 20:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbfLETab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 14:30:31 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:45388 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfLETab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 14:30:31 -0500
Received: by mail-yw1-f65.google.com with SMTP id d12so1659777ywl.12
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 11:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3m9cN43HyDLroUi3rGFs7pTKWPjlTd1QvH65R9mYl/Q=;
        b=OCAH/J6Arz6YLrHx1hFK9z2v5JT++P0vODwMNovJaXe7fctNJxN+6UoO+lHOc97VMN
         s63Wi0KaTPVXR9qY4/RzVLukb8QRv/k9WBHhsmUYgmtKUKb8pS71b6sG3VUGAKru5JlS
         dn1azLCigGe1Qi14T52NYtpwdfpQFiA6PR5pI1EsZNXlyUAxSTxXrY+ZOxzUxXP1zAy/
         mofxV7BZIh2zUFJ7GeO3enDzzp6plSeRqXUcDY2FCYSSqYVLOSbIC4UdCa0klWZO+czB
         nbMP0Xx5biJL9n4I89OeZkfZptJizX9CZniGaTnOPKvzH9VRjttiDEM5meREZFMn59Ei
         5MvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3m9cN43HyDLroUi3rGFs7pTKWPjlTd1QvH65R9mYl/Q=;
        b=MDhsE+H/8lYRAm9BODHTHCYQhn492UXNVs8nfJTL3zDKA8zAZoY20wP6yY4AeIgZEA
         p8IXzcaIQp4Zs/RBh8XU1E0TyuQSIivXxHOGEMgLiKEGq+kiRpkIlNni9x5Nlmg8n3TE
         SEecA3Hy2hemAvNgeuh0acOLsc/NHLrVyUyaxZ7MU+eCHz/zq2EEpvcr8Il9zP1edtLY
         rrn6gSF5fuOhnriEQOisn5sEAjGNLwG102qbe/ILNaIxTvWPgFLkedIBRonmPRYAY284
         AyeLtYOxhD7fxYnE1l/MuTnM2pOApLS+zLdHbo0yi5H5OBRNCONbkMbGsRnBYoMQMeGL
         VG9Q==
X-Gm-Message-State: APjAAAXAq8dczOLneliSUvhXOhQmAG3wr0oC1eWYDblSRS7KQklTdZQY
        LZ+crDpwEDAsbBw4spzPB0kfHoY1HQYqrrdK8sl6iQ==
X-Google-Smtp-Source: APXvYqxal4KE7/XeglV/rzpbBFqsC4XfMDZWZdwLMzHbtOakjk3XiXMbtMuYyfdPTjAyB9r0S/w3zjKXyYLWf34COpc=
X-Received: by 2002:a81:b38a:: with SMTP id r132mr7732440ywh.114.1575574229565;
 Thu, 05 Dec 2019 11:30:29 -0800 (PST)
MIME-Version: 1.0
References: <cover.1575503545.git.gnault@redhat.com> <1d7e9bc77fb68706d955e4089a801ace0df5d771.1575503545.git.gnault@redhat.com>
 <80ffa7b6-bbaf-ce52-606f-d10e45644bcd@gmail.com> <20191205180019.GA16185@linux.home>
 <CANn89i+RHVmA2Mc8x0NdHZjWsw4UtgZ5ymbWBBxLgv_YczUjvg@mail.gmail.com> <20191205192252.GA18203@linux.home>
In-Reply-To: <20191205192252.GA18203@linux.home>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 5 Dec 2019 11:30:18 -0800
Message-ID: <CANn89iJJZZxUoQYFOmWiFC7Xih6Nrz5DE6Z8-LZeU7Rip-qFAA@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] tcp: tighten acceptance of ACKs not matching a
 child socket
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 5, 2019 at 11:23 AM Guillaume Nault <gnault@redhat.com> wrote:
>

> Ok, I get it now. Thanks!
> Will send v3 using 'last_overflow - HZ' as lower bound.
>
> I think READ_ONCE()/WRITE_ONCE() are still necessary to prevent reloading
> and imaginary write of last_overflow. At least that's my understanding
> after reading memory-barriers.txt again.

Sure, it can not hurt, but please make this as a separate patch, thanks !
