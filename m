Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5191D2D573D
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 10:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbgLJJcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 04:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgLJJcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 04:32:42 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3C4C0613CF;
        Thu, 10 Dec 2020 01:32:01 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id c79so3504186pfc.2;
        Thu, 10 Dec 2020 01:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VYZF6b0eAf0D2UpGn/w+5r6w0iBI6SckFUc4KZtxYx4=;
        b=GVbKgxRpIEs8XnfazLphorUnKvkhAwtOtzBGMkORRuLBGzivBRbhyeouw5NbFmvjg8
         0jLQHOCcMrlZl0i/H+b4dCCr6IozvyUIiFzADzIMTOHEQ/21DjUVDKxGM3Xjldl5aaks
         51TMQ44PaAK/FjHA0Df9Qxh4rUuiBDJLGQEWHkDNK4dn9howBkrnLYgxn8a6DnA/vzzD
         PcUywu3uqdDuFFOsUK3teD8hma8lg4wsLl4dX7edxBQb7wz4tWIR88Fk+T3LYMUDmKgQ
         tP4h4FcAuHJwMBwV2AhMXSydvdE9/FVDsiagfJX++sqICT/FYkO0rdnxSw9b1HoVjPqH
         XNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VYZF6b0eAf0D2UpGn/w+5r6w0iBI6SckFUc4KZtxYx4=;
        b=NsMJbpAxKbUJ2a3DMFYCZ56L/biNYVc69wTW+x3/7EJS521UjN7UmAx2dWiqcRfjfP
         ONZCRJBl+prKlChlKo9xfa093JaL085qY5kBVdxC1srEnBkboYTYFmK3AX7e3mZktkxa
         qnQWm2Q+gGmh6N/kPR3UoeUFFxpTjJU/U0KEqGb8K15/y4xKiuSK32Te7Wq0BUrKxFqk
         FibC3F6vgNcPhS4SzacAAmxfUp5rU+pc2NxJ+YYOuqPItFveCFYiPrjlpItnaseXlVP6
         Pfq4rAoHeXUSzB/uIDES1DIlD7LWFq+eIqt+w7Lsjx497/ACBfRicUDc3wy+zmK9io6b
         OpFw==
X-Gm-Message-State: AOAM531BvWHNa4jP6D+uWdbyOqZq7EOy4Cwx3PgySv2gfLQ3AMPvgX3x
        s5hCcMZMGaU7R7PmwK1QvzfvUCtr7syOMTEGUhI=
X-Google-Smtp-Source: ABdhPJwxS6fMkV7PHkuKMjTg+iosxkOj73yi6Hz8CQfmmSCFA6/GZfAIOwvd/iCob4KXDshfDyyo0VSrImE288FC+rI=
X-Received: by 2002:a63:d312:: with SMTP id b18mr5864602pgg.233.1607592721531;
 Thu, 10 Dec 2020 01:32:01 -0800 (PST)
MIME-Version: 1.0
References: <20201126063557.1283-1-ms@dev.tdt.de> <20201126063557.1283-5-ms@dev.tdt.de>
 <CAJht_EMZqcPdE5n3Vp+jJa1sVk9+vbwd-Gbi8Xqy19bEdbNNuA@mail.gmail.com>
 <CAJht_ENukJrnh6m8FLrHBwnKKyZpzk6uGWhS4_eUCyDzrCG3eA@mail.gmail.com>
 <3e314d2786857cbd5aaee8b83a0e6daa@dev.tdt.de> <CAJht_ENOhnS7A6997CAP5qhn10NMYSVD3xOxcbPGQFLGb8z_Sg@mail.gmail.com>
 <CAJht_EPj-4bv6D=Ojz5KCbk0NTVfjRyEA3NmMw7etxrq8GKu8Q@mail.gmail.com> <458f89938c565b82fe30087fb33602b9@dev.tdt.de>
In-Reply-To: <458f89938c565b82fe30087fb33602b9@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 10 Dec 2020 01:31:50 -0800
Message-ID: <CAJht_ENaD2N8UHOXYsFGzzRsf=yVqd7RsqDG3p62NAHagnwCGQ@mail.gmail.com>
Subject: Re: [PATCH net-next v7 4/5] net/x25: fix restart request/confirm handling
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 10:27 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> > Hi Martin,
> >
> > When you submit future patch series, can you try ensuring the code to
> > be in a completely working state after each patch in the series? This
> > makes reviewing the patches easier. After the patches get applied,
> > this also makes tracing bugs (for example, with "git bisect") through
> > the commit history easier.
>
> Well I thought that's what patch series are for:
> Send patches that belong together and should be applied together.
>
> Of course I will try to make each patch work on its own, but this is not
> always possible with major changes or ends up in monster patches.
> And nobody wants that.

Thanks! I admit that this series is a big change and is not easy to
split up properly. If I were you, I may end up sending a very big
patch first, and then follow up with small patches for "restart
request/confirm handling" and "add/remove x25_neigh on
device-register/unregister instead of device-up/down". (The little
change in x25_link_established should belong to the first big patch
instead of "restart request/confirm handling".)

But making each patch work on its own is indeed preferable. I see
https://www.kernel.org/doc/html/latest/process/submitting-patches.html
says:
When dividing your change into a series of patches, take special care
to ensure that the kernel builds and runs properly after each patch in
the series. Developers using git bisect to track down a problem can
end up splitting your patch series at any point; they will not thank
you if you introduce bugs in the middle.
