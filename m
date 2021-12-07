Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0749C46AF7D
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378866AbhLGA5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbhLGA5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:57:10 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAA1C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:53:41 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id d10so36311551ybe.3
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0B7ZKpCk1NTmxp/DdqW9UJ5jkqZ/rgSsXW0hdVLOXvQ=;
        b=kKXSI2zOAdqPyJ/tGMELHhQ45xYVBtGf3ztpzWafK4eEBvKF382XhfP2AaJplu1ZIZ
         a7+B5UULTcUfbZWlQKGOhFCmzwosYZeAFMfzXPB1vDhI8BXdGNwuoPhE1VHyME59iCnB
         fI5OKLPxiWHdMRMte1CUsVc6hLfm8QraXSykywsAhuLoE2dnnKsCnfAGF9yHOilJvE7y
         ln1+XtrbXgSuSbMdMbAKLW6bdmxrG11Uf5KqA+pOQFfG+EzXMaScOWpnrO1GFIVj8dYj
         p2RVSzTccZk0oJo7skc90Mtl3DH2j1mvH07N9ij6upd3DVshKqXLbaK/YIFWT+duV21y
         42Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0B7ZKpCk1NTmxp/DdqW9UJ5jkqZ/rgSsXW0hdVLOXvQ=;
        b=vmv+pR7xCJqo3d2sSDTzLXRbEq7T0kQpMv2TfC13bD7pegLRJeAK5ZIbbjmfawvBPs
         B/8lMYc4pBnc3NnBskbo8t2/Bro5QSgcUX6BEp3k9wLVv+L02jI2SHIY5SymHbaqsYt3
         3TRrPKrHqiwQMjjjSdVQjBSUKTvQLvv9ghW0rKoFVWXiy/+Rck8NZKTP/VSjhsyQxA6d
         sGItzsv2dCufOw4+FPHkOgLDfFjuycBaoRfPyGVubnmtyU2HNTFlg3PJxkGngEqrmg+Y
         OgRdFo79dy/DutW+Qdo8DGpILttB6HigBD2GtVTrna/UWcv9vcvPxU0wbzZ3WCx/siP8
         0QeQ==
X-Gm-Message-State: AOAM533eMvKmpAnm5wnzzioVC5egXmDV6q/0Z6I3SnhnBD8gXfiWyZbn
        bB5l7Zr5G5eb7Bs/RUZ5j+Pov9KIH+PWpJymqTKFKjMriCM=
X-Google-Smtp-Source: ABdhPJwimCYcDhbXFBi5D8te983YTYNvJ3NcfmMhumRmY+oIKLvTaax+J3y8cCJJ3cO7Vuk+4p69cZ/w+KY1q360FmU=
X-Received: by 2002:a25:6c6:: with SMTP id 189mr46830755ybg.753.1638838420139;
 Mon, 06 Dec 2021 16:53:40 -0800 (PST)
MIME-Version: 1.0
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <Ya6bj2nplJ57JPml@lunn.ch> <CANn89iLPSianJ7TjzrpOw+a0PTgX_rpQmiNYbgxbn2K-PNouFg@mail.gmail.com>
 <Ya6kJhUtJt5c8tEk@lunn.ch> <CANn89iL4nVf+N1R=XV5VRSm4193CcU1N8XTNZzpBV9-mS3vxig@mail.gmail.com>
 <Ya6m1kIqVo52FkLV@lunn.ch> <CANn89i+b_6R820Om9ZjK-E5DyvnNUKXxYODpmt1B6UHM1q7eoQ@mail.gmail.com>
 <Ya6qewYtxoRn7BTo@lunn.ch>
In-Reply-To: <Ya6qewYtxoRn7BTo@lunn.ch>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Dec 2021 16:53:28 -0800
Message-ID: <CANn89iKbAr2aqiOLWuyYADW7b4fc3fy=DFRJ5dUG7F=BPiWKZQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 00/23] net: add preliminary netdev refcount tracking
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 4:27 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Dec 06, 2021 at 04:17:11PM -0800, Eric Dumazet wrote:
> > On Mon, Dec 6, 2021 at 4:12 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > >
> > > Hard to say. It looks like some sort of race condition. Sometimes when
> > > i shut down the GNS3 simulation, i get the issues, sometimes not. I
> > > don't have a good enough feeling to say either way, is it an existing
> > > problem, or it is my code which is triggering it.
> >
> > OK got it.
> >
> > I think it might be premature to use ref_tracker yet, until we also
> > have the netns one.
>
> There is a lot of netns going on with GNS3. So it does sound too
> early.
>
> Could i get access to the full set of patches and try them out?
>
> Thanks
>         Andrew

I just sent the netns tracker series.

I will shortly send the remainder of netdev tracking patches.
