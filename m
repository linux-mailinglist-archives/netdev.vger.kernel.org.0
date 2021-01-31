Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6431A309996
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 02:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbhAaBOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 20:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbhAaBOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 20:14:03 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236D5C061574;
        Sat, 30 Jan 2021 17:13:23 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id a17so2711642ioc.0;
        Sat, 30 Jan 2021 17:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=27qz2GuA6S5CIOKEAlyrG3vxRJP5QFx9HzB2FPVmpSI=;
        b=ZFB1HE6kumV0WAxB1njJj9kRhuo7ZqhUHMGsXk8mHs3fp4am4hYXgxPA+quklQuDoP
         e2zaEojYMpxS05ykS/aYsdLRiW3wtI8rE9/IsyD6YNGRYQ5yqBT5PWM2K1Kvg//V5syf
         bRoym31fGl2C8TffByZ9nl1Rmy8Z/Lm++mNAA/nrDw9NX0EizvLr1BbPw0yt6fvrJk7r
         ImldLyxoKy6HYaNS4VfxTJ/FyvfWdglHUe3KjxdNhKDcgJ/xB/0/UifNN+fwVt6UvEms
         WAIudzFQ4gQt8wFBGmNrMDMxHxbAzWaTh7eaqC7AE0lgqppe09s+QrrQA+IEPRpbuB0/
         IByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=27qz2GuA6S5CIOKEAlyrG3vxRJP5QFx9HzB2FPVmpSI=;
        b=tSoeNNJXPgBbtr4ss+ccR/mxMBXh18FeDPG3KaKuUhdCd6mtuST2bHXjeMlH2ksSH5
         XnYOffWfEpdd9yvuHYhPttJpGfPycKYTVD9spjLOt29MxurcJLZy1mCbZ++qE3MwNees
         pI35Vvtws2AQyxVYKV0LjSkvq7w0VxuOuB7pGgQ/QZhFe0c3A5LioD+SXHP/w+KnZCDB
         VyY6vPGoO8jdcJhAAwAX0/AGH6QBVPB0K20v4lRcqimyjYI/DGBa2TICZ/tmauV1+QnK
         amfOGN3JqYW1v2v2temT2v5ZrkVzkoreJCbvwd2QkqJqHQ3L5hFtrQnDX/tDqpfkqdNp
         0K3g==
X-Gm-Message-State: AOAM5330yaXUCUF2bzqxciHC2zniixBBQijR/fp9eU1g97GUhYoTvqOJ
        idqI4JlEddxehn+BYbgxwLVIl968SALmN1I2H6U=
X-Google-Smtp-Source: ABdhPJy2b4lM/Pqcah0dy5A9UOVnddxyR7+TNT8LpLGxzRIQUD37+NAUJnRTA5B0rq9HnOj8BLnTmYtB6xKPgfDQW6U=
X-Received: by 2002:a05:6638:25d4:: with SMTP id u20mr9028095jat.76.1612055602512;
 Sat, 30 Jan 2021 17:13:22 -0800 (PST)
MIME-Version: 1.0
References: <20210130134334.10243-1-dqfext@gmail.com> <20210131003929.2rlr6pv5fu7vfldd@skbuf>
In-Reply-To: <20210131003929.2rlr6pv5fu7vfldd@skbuf>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Sun, 31 Jan 2021 09:13:15 +0800
Message-ID: <CALW65jYF5jpm+wQQ9yPZPa_gCSwr4gWiPZ35rBXiACmzCbABLA@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: override existent unicast
 portvec in port_fdb_add
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 8:39 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Tobias has a point in a way too, you should get used to adding the
> 'master static' flags to your bridge fdb commands, otherwise weird
> things like this could happen. The faulty code can only be triggered
> when going through dsa_legacy_fdb_add, but it is still faulty
> nonetheless.

This bug is exposed when I try your patch series on kernel 5.4
https://lore.kernel.org/netdev/20210106095136.224739-1-olteanv@gmail.com/
https://lore.kernel.org/netdev/20210116012515.3152-1-tobias@waldekranz.com/

Without this patch, DSA will add a new port bit to the existing
portvec when a client moves to the software part of a bridge. When it
moves away, DSA will clear the port bit but the existing one will
remain static. This results in connection issues when the client moves
to a different port of the switch, and the kernel log below.

mv88e6085 f1072004.mdio-mii:00: ATU member violation for
xx:xx:xx:xx:xx:xx portvec dc00 spid 0
