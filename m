Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9413252B9
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 16:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhBYPth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 10:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbhBYPt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 10:49:27 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC72C061574;
        Thu, 25 Feb 2021 07:48:46 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id z13so6319278iox.8;
        Thu, 25 Feb 2021 07:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YiZfrscp4TeShL/P0jNh96lAxTY6sCZno4Gtn9oFuCs=;
        b=G98xRZBUXH/GpcJm9J6q7x+cXoI1UZ5g0UpYWuXINQe5wDhycNKDJxTTOxeDk7gnkt
         K6+ds/zOuKOwTIyV6OWNSgjFmskukuysxS0C97W82yYWFd3kIq+6dilxAZgXZFpOdLGp
         ONVOADx9i3Nj17CGUHjuPOb4gHWJkoLgWzYe4Nwm71MwZm/FBdPiRX02SbwBv2r31LdQ
         DfedI96IxdLtoQdHvSc7aXofJsFfBkNlg2bknoEh2u78oZvRyVjaxpSQ3/DOyXhp09nA
         K/CEcY6Gb2+zBkVA6l3DxX7do6y0dBuwrn1xpWYKMxzeXjqKvCTmD0yfzUg/yyeECNJH
         W95Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YiZfrscp4TeShL/P0jNh96lAxTY6sCZno4Gtn9oFuCs=;
        b=gizMQ1kmyOo8Tha/IKE0VF1DArtAckB05nxCdQ/yDFp7vPtBAkIgyqQlEZmYMgSrTw
         wRYp5SnunO3HX2XWBqGX/Z14Getq2yGgN6t3GhDjGkJ/6mDPi6gjl3PdWGRJECFNK+g3
         m31RoSel4ctAdpdaqkCUULb8/tfwAXXnzj89LMIXrAPPwGnmzX4Y5rNINRUvIFLs0Psb
         8YGOzLYIxtgM+LBDug2ADwf2MAG8eK0CncI6UR8Q1TpugvqJoGzME2NqPDw5MN45QTIg
         ICJcfuzXDlGMZDUduc+WPiixCIFT2UWdymFkznjSC9M3EgfPbPokIvxoP2Vk3whuq8dk
         9ARg==
X-Gm-Message-State: AOAM533g7tx+n2RAy81AlPhvpF2Ban+bOg9YP/PeEJC8pK30WOa3G5/9
        dLyB+HKV1niyybQ9ZD2p0W+nQAxtv/wpmbt7XvY=
X-Google-Smtp-Source: ABdhPJxxNqiwP59Zsi4jesv4rQhdFkIarNYiAZNjk+Zu4RFwNYFu+iQwu+0uD1Yfu/rsCjWfy1WkI0MGp9zKcdnqxcA=
X-Received: by 2002:a02:3846:: with SMTP id v6mr3899033jae.7.1614268125483;
 Thu, 25 Feb 2021 07:48:45 -0800 (PST)
MIME-Version: 1.0
References: <20210224081018.24719-1-dqfext@gmail.com> <20210224084226.idtvqtdpl5vbstup@skbuf>
In-Reply-To: <20210224084226.idtvqtdpl5vbstup@skbuf>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Thu, 25 Feb 2021 23:48:36 +0800
Message-ID: <CALW65jbCtf6PMHwuEzxqaKz55SJDzQbsu75nWOs+rPX-PXwOug@mail.gmail.com>
Subject: Re: [RFC net-next] net: dsa: mt7530: support MDB and bridge flag operations
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Wed, Feb 24, 2021 at 4:42 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> I think the comment is incorrect and this _enables_ flooding (which btw
> is ok until we get the address filtering thing sorted out).

The initial value of these FFP fields is all 1's (0xFF). Writing the
CPU port bit here will clear the other (user ports).
