Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CBE6A49DE
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjB0Sfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB0Sfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:35:33 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEE7198F
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:35:31 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id t129so2907765iof.12
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UTh4OFbqJSpT5IaxeTjsSLuZQoN9DS8rD2n8LR+Pb0g=;
        b=nTw5Xc90tpgpR5LWu8201dYe26Q1JmfGapV1FQtdPQ1FlsnanGqErYpvVCRol2b0an
         sSDlxpjxTpoj1EhRK6bFW1TvSD1SPF8sX7eRiSJ8s6XIqgi5I7BNAwHCZQ93UzTGPdbG
         Jd+8gZp41YwayEX8fVpPJekQ5AazoCjTH5fC44ef0XAhMD9aUYmq4EV0o/TwHSt/ADbI
         VlQeIfCrnkdzgM4RSpN4r9J5UNgojOxxFxnS9UzaaPM0O+wFk5zRMBhcbhVRf+NeEaXk
         4ZSxwzsD1B9ur/oDm6k7yNFpbg78aXhb4B1B71eNrbdEl+vPoPrnUvudjf+PfyBcyPL0
         aURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UTh4OFbqJSpT5IaxeTjsSLuZQoN9DS8rD2n8LR+Pb0g=;
        b=7JR0lWUg8/uZr6FCKCFf0+tsQ5px7tYVtz4oRc+n1ZDavZ3xgjEzfVPfxfbd4XUKxO
         esCS1cQtNjYflBni0Wz8TNdYLyAnjyRzm5EWaxBDYQ+q5eOVQVHZnfilJbfySvh4D2zY
         7gPS3LfllsMOoRXanNUyswxP2SVw7c7MPfMxpUrCMUvxezWmHXo0gFK2QRGTEeXh9OGY
         IIXqhLbGzerbfHBH9uSO4hU8dbk+uvPTHR5t3HueLL5ji9qRltAuOSN905QpYbVBkoUX
         q5lWtVEXI3btoMuUwf8QOY/pXbRmJUmYIbYGTKRtlCeC2Krwi6WDIFo2Mn2mn6yKol94
         v5Vw==
X-Gm-Message-State: AO0yUKV6i4lSrUc2OoDYJNLupYIpoxMHYOwbbVy1m/2oAug7sqa8Oek3
        Xk2NDnFgQmkyUbdcMub2iZ1bJAhJsTgMGhtqUKWHlw==
X-Google-Smtp-Source: AK7set+Hy8ZvyzNcRuMZfFpYWj+WcL1GepzBPGfkByV6oLHmY6bfyj4ZUDWFItDHm/z8LxYz1Gf/ZOlCKjXmcJg37U0=
X-Received: by 2002:a02:620d:0:b0:3c5:df3:a58b with SMTP id
 d13-20020a02620d000000b003c50df3a58bmr31490jac.2.1677522931078; Mon, 27 Feb
 2023 10:35:31 -0800 (PST)
MIME-Version: 1.0
References: <Y/p5sDErhHtzW03E@schwarzgerat.orthanc> <20230227102339.08ddf3fb@kernel.org>
 <Y/z2olg1C4jKD5m9@schwarzgerat.orthanc>
In-Reply-To: <Y/z2olg1C4jKD5m9@schwarzgerat.orthanc>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Feb 2023 19:35:18 +0100
Message-ID: <CANn89iLPW5P62sd6N15OwhOHaPDdRCge7nJHjDyKWXRnky4ywg@mail.gmail.com>
Subject: Re: [PATCH] [net] add rx_otherhost_dropped sysfs entry
To:     nick black <dankamongmen@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeffrey Ji <jeffreyji@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 7:29=E2=80=AFPM nick black <dankamongmen@gmail.com>=
 wrote:
>
> Jakub Kicinski left as an exercise for the reader:
> > "All the other stats are there" is not a strong enough reason
> > to waste memory on all systems. You need to justify the change
> > based on how important the counter is. I'd prefer to draw a
> > line on adding the sysfs stats entries. We don't want to have
> > to invent a new stats struct just to avoid having sysfs entries
> > for each stat.
>
> In that case, I think a comment here is warranted explaining why
> this stat, out of 24 total, isn't important enough to reproduce
> in sysfs. I'm not sure what this comment would be:
> rx_otherhost_dropped certainly seems as useful as, say
> rx_compressed (only valid on e.g. CSLIP and PPP).
>
> If this stat is left out of the sysfs interface, I'm likely to
> just grab the rtnl_link_stats64 directly via netlink, and forgo
> the sysfs interface entirely. If, in a modern switched world,
> I'm receiving many packets destined for other hosts, that's at
> least as interesting to me as several other classes of RX error.

We do not want to add more sysfs files, unless absolutely needed.

This sysfs thing adds costs at every interface creation and dismantle,
even if the sysfs file is never to be used.

netlink is the primary interface, sysfs is legacy from old days.
netlink code is basically free if code is not run.

So please, forget about sysfs, and switch to netlink :)
