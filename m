Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737662B5E6B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 12:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgKQLcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 06:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbgKQLcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 06:32:54 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CD8C0613CF;
        Tue, 17 Nov 2020 03:32:54 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id gi3so317426pjb.3;
        Tue, 17 Nov 2020 03:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=72x/SS97yDfmKLyCblUhiX5oYip81rPZoaO4o1zpdcE=;
        b=QYCtPyfG2qFh0OJrrWVRwzza/HzYapdghDvIWgBjSs0tzC2P/Tjvz6lhf/Z5H8UVSK
         TAZgqLInQcOla/xUWe6c8BCbJ5jBp2Nna9sG9Z9Oz5yHFe2yBhsJPUXqF284+pAr6ZBb
         zEp1HcXR5ioGnQmHofxF9N00KelVB/bHkqYlZ8vMSQqKj0IwF75tUU1EK0Kb7bBKrTh0
         KtXIkhi3h0j97ExIE2xTdjeOMbsha/AdmzMsCOVhY1dmourL2tMX/1mtqyOuarCCZdTQ
         SEgTW0lEhMipPMZIHcWLmlWj8rW7bGvuLDqF2Nq0XRFXiOmPxto83LzA15a94H5Rr/Ov
         r10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=72x/SS97yDfmKLyCblUhiX5oYip81rPZoaO4o1zpdcE=;
        b=ome3cI8xsidUsx5gdeynFApQw5xohjgHjkICre+pII22fpJKdU7xsKVT+HRX/2KR70
         uHDcoBsrJOIAyPEOZNzy2yEh5ns2f/OaAHFC93b6IzS84aR03enAcQu/5krVIyTz8+mC
         kBE7AcTFll+z1DmRMTpo62XAHbhuTW7Z2g7EVgLLYTutrI5J12X5xt1L8CNlhaJOw6VV
         vhoGUW7tvsOCNLYJ3v4nxKUtD3x9obfYl0Wzmjn8gWSfVYnEOQr6+AgByNc1tJWnBHYG
         dYlBYvxJYrfqgrYEweRY/N2vmt4HZBg2BDuMndSZW+3BoUjQ2+Ns0IbjkMwdBTJr4aGO
         wmlQ==
X-Gm-Message-State: AOAM531JnT8jp/I/b0N5IvTb8yZz9AjBFVwH/RKqTj72LKlkQI1cLu75
        KJZiddSraw20suwOxyW7RF/5n3a5q/37CeDlJKE=
X-Google-Smtp-Source: ABdhPJwScfY/DjPQFEd2vle+6muce5HTlh4+Cd4an9aVfQxa4b0pB9vs22o3uZaRC33Ba6uDx1dzrxl4REXaI5hLfAE=
X-Received: by 2002:a17:902:aa4b:b029:d8:f87e:1f3c with SMTP id
 c11-20020a170902aa4bb02900d8f87e1f3cmr3339205plr.23.1605612773875; Tue, 17
 Nov 2020 03:32:53 -0800 (PST)
MIME-Version: 1.0
References: <20201116135522.21791-1-ms@dev.tdt.de> <20201116135522.21791-6-ms@dev.tdt.de>
 <CAJht_EM-ic4-jtN7e9F6zcJgG3OTw_ePXiiH1i54M+Sc8zq6bg@mail.gmail.com> <f3ab8d522b2bcd96506352656a1ef513@dev.tdt.de>
In-Reply-To: <f3ab8d522b2bcd96506352656a1ef513@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 17 Nov 2020 03:32:42 -0800
Message-ID: <CAJht_EPN=hXsGLsCSxj1bB8yTYNOe=yUzwtrtnMzSybiWhL-9Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 5/6] net/lapb: support netdev events
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

On Tue, Nov 17, 2020 at 1:53 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> On 2020-11-16 21:16, Xie He wrote:
> > Do you mean we will now automatically establish LAPB connections
> > without upper layers instructing us to do so?
>
> Yes, as soon as the physical link is established, the L2 and also the
> L3 layer (restart handshake) is established.

I see. Looking at your code in Patch 1 and this patch, I see after the
device goes up, L3 code will instruct L2 to establish the connection,
and before the device goes down, L3 will instruct L2 to terminate the
connection. But if there is a carrier up/down event, L2 will
automatically handle this without being instructed by L3, and it will
establish the connection automatically when the carrier goes up. L2
will notify L3 on any L2 link status change.

Is this right? I think for a DCE, it doesn't need to initiate the L2
connection on device-up. It just needs to wait for a connection to
come. But L3 seems to be still instructing it to initiate the L2
connection. This seems to be a problem.

It feels unclean to me that the L2 connection will sometimes be
initiated by L3 and sometimes by L2 itself. Can we make L2 connections
always be initiated by L2 itself? If L3 needs to do something after L2
links up, L2 will notify it anyway.

> In this context I also noticed that I should add another patch to this
> patch-set to correct the restart handling.

Do you mean you will add code to let L3 restart any L3 connections
previously abnormally terminated after L2 link up?

> As already mentioned I have a stack of fixes and extensions lying around
> that I would like to get upstream.

Please do so! Thanks!

I previously found a locking problem in X.25 code and tried to address it in:
https://patchwork.kernel.org/project/netdevbpf/patch/20201114103625.323919-1-xie.he.0141@gmail.com/
But later I found I needed to fix more code than I previously thought.
Do you already have a fix for this problem?

> > If that is the case, is the one-byte header for instructing the LAPB
> > layer to connect / disconnect no longer needed?
>
> The one-byte header is still needed to signal the status of the LAPB
> connection to the upper layer.
