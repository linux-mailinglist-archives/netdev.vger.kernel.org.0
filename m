Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A849430F8
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388389AbfFLUZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:25:55 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43056 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbfFLUZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:25:55 -0400
Received: by mail-ed1-f66.google.com with SMTP id w33so27590388edb.10;
        Wed, 12 Jun 2019 13:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rr+UcwlwJTbzLmZhG++5L+DhQclZfV3f5YAuqDmwmms=;
        b=IgwSAmIwB8o5pnvJP5+NLLZOxDikb0JvO0/F234+brtJzV8E2lrrQqCwOVsfbfj6nd
         0Z+ntNXkXCjGtA9qweTdOBTa8wN97UiTZsF+XgsJ4ScA6rfPYx02ZtTyd71R/7ecFmkR
         by1Td0EP68yHWlkLx7dzJL8mLMyjSPzoaOXtSuPFGfoyHClO0BEw13D6SkCf4yrv69/j
         KZHgKJayT5NCD7fPOTZSgAtDVquxpSuMg3INmuzzrSFt1e2JU8QYUI0PWnbRjzFL4/Fd
         ZFpFK7UMVW6mCl4OFynsy4x7J+UrB3sEUfmq6PYxWYYucF934lHL4Ke0RxhkMJz4XwNV
         eQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rr+UcwlwJTbzLmZhG++5L+DhQclZfV3f5YAuqDmwmms=;
        b=ItPVYC8e+4A+TEMuPJt5SbcSVdKkKi9ix1XRgUAgEqasYSfOezL4n89CXEpG5WoTyx
         uQie1icN2kY3PKxZQIn9JImzLdq6c3VriB/2mdtZFSnKuAJSOpookpN3yr+IO/yBLGm1
         7xmKIkkIAzNlDnR5gmnlIuva0zj1H8QyCKF3nXb0NsirOQsVjCdpf+5AzN8ZbWsh2hIw
         JIJuTKNe/kxlc5v+V7GskrfaBouPsGD3Vm39Ouhw55mQXrKb57qUKclE/jGzXQVNDtXs
         Mke1f+kX92gST5EsWgF77koRfGBz/r4RJtZ8xIxSqJ+nHmawZ9SKYG5WUm6YVSbkcOY0
         O4Kg==
X-Gm-Message-State: APjAAAWaBxdIY8Gi5/yuKIPMIXfsXn0nd+DXZWDueY6e/WxTBK/uDjtm
        3Zaun4B/uv+864yNhdNwgYKHPVu0tcQkrpc0Mps=
X-Google-Smtp-Source: APXvYqx74hE7v8eNCwzdJlUe3z2p/fD1umQGPHswC0VFB/Ly6HT5L9+CGRV6bC2Kz4csAyuk9Zqj+Q0sSUTIsIsCNKw=
X-Received: by 2002:a17:906:7712:: with SMTP id q18mr71477734ejm.133.1560371153299;
 Wed, 12 Jun 2019 13:25:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190612194409.197461-1-willemdebruijn.kernel@gmail.com> <20190612125911.509d79f2@cakuba.netronome.com>
In-Reply-To: <20190612125911.509d79f2@cakuba.netronome.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 12 Jun 2019 16:25:16 -0400
Message-ID: <CAF=yD-JAZfEG5JoNEQn60gnucJB1gsrFeT38DieG12NQb9DFnQ@mail.gmail.com>
Subject: Re: [PATCH] locking/static_key: always define static_branch_deferred_inc
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     peterz@infradead.org, Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 3:59 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 12 Jun 2019 15:44:09 -0400, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > This interface is currently only defined if CONFIG_JUMP_LABEL. Make it
> > available also when jump labels are disabled.
> >
> > Fixes: ad282a8117d50 ("locking/static_key: Add support for deferred static branches")
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> >
> > ---
> >
> > The original patch went into 5.2-rc1, but this interface is not yet
> > used, so this could target either 5.2 or 5.3.
>
> Can we drop the Fixes tag?  It's an ugly omission but not a bug fix.
>
> Are you planning to switch clean_acked_data_enable() to the helper once
> merged?

Definitely, can do.

Perhaps it's easiest to send both as a single patch set through net-next, then?
