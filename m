Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBF14D374F
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbiCIRCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236997AbiCIRBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:01:55 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCB01662D7;
        Wed,  9 Mar 2022 08:50:34 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id x5so3623019edd.11;
        Wed, 09 Mar 2022 08:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=idcrIwJK7fv1u+7sZxPAu9s/3XQBSoZ4lKPrU7eypvY=;
        b=KAbNH7RFZU0IFVTEIfD5beiz4M/f7a5r4KvxR4aOJUOz0/EhqD4d+uQv1ua0Mp5j+Z
         H6AwMswXpXDWAQwJkfPPiEHURc+zvge67kQd3uDEwckdBMvi8izjzX3wNgA+cW/EbCXJ
         CdDZCZ8SAnWkyYy6Dan7R7VQDR8xmcTY7bCmJx6FT0CCYzn47t+SYnolS/4aX3iDn8o7
         YaLiofiaT1KXp+uvBuwDEyBvNJziZ50zkOv5GDbJWrwRDGQzOd5i24qkWGx/kOxx+knM
         ZBrUltdk/YbV/nLH4O+HHTGTC2aBTTfhLTj0ELaNhBgWRUSfbxxUYnu1Drg3Qui0ttb7
         KFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=idcrIwJK7fv1u+7sZxPAu9s/3XQBSoZ4lKPrU7eypvY=;
        b=SY13b6tk00JOFrTSPuwAvhjQL7kWdekz5v5p4rj4hvjW+T+2sU1h+4AAB6mHJbbRY+
         j8DCvaBpAJTFBFUhjraZVhv2GXtQ2AXXNRowY9WyXkNvVZ4BcsI5SoX16xAv5djEVKiu
         8gv1BCxeA6bgPxc2z2RnO3isjVDreOb2TZxxoszwr6BB2aUpE8Y1d+gkycsYGxJvjuYg
         wW9yuF4sSOGq0u5kXHS7RX97gZ2Tm1J0h6hn1w6y0BSifz9seILS5Y9xtyYXKnf9xuyX
         viV84ESjKQj7+Fji1WVABQIoU4Fsu2N4TvUXdHd96c/ccph0tZzWWuMLxV/wVjFXUZLO
         Ateg==
X-Gm-Message-State: AOAM530B+iUaSBL6vTgMPsKLKIrwHzVTqkiBYqRg7rIWMl/zm5V7lFkA
        4W/GZcf9vKTWzzJqB8ezjnCnTeSJ7Pmqf34gTsY=
X-Google-Smtp-Source: ABdhPJwU0XjsVoaNhPHrZb9HZjY0WszBLpO5VvlqeYE6B/5Nog0HNksBCUflkAQcMwh+XdrGYDQcMMeczRSfaK4QOa4=
X-Received: by 2002:a50:9d0f:0:b0:416:95a3:1611 with SMTP id
 v15-20020a509d0f000000b0041695a31611mr337493ede.77.1646844632418; Wed, 09 Mar
 2022 08:50:32 -0800 (PST)
MIME-Version: 1.0
References: <20220305204720.2978554-1-festevam@gmail.com> <12992128.uLZWGnKmhe@steina-w>
In-Reply-To: <12992128.uLZWGnKmhe@steina-w>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 9 Mar 2022 13:50:20 -0300
Message-ID: <CAOMZO5B=btQKAT5HKBTfJRFc880ygzOLWN=65DdAHdce18QxTw@mail.gmail.com>
Subject: Re: (EXT) [PATCH v2 net] smsc95xx: Ignore -ENODEV errors when device
 is unplugged
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, fntoth@gmail.com,
        Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

On Wed, Mar 9, 2022 at 11:02 AM Alexander Stein
<alexander.stein@ew.tq-group.com> wrote:

> Oh BTW, is this queued for stable? Which versions? If 'Fixes: a049a30fc27c
> ("net: usb: Correct PHY handling of smsc95xx")' is the indicator, it's not
> enough. This errors also shows up on v5.15.27 and is fixed with this patch.

("net: usb: Correct PHY handling of smsc95xx")' is also present in 5.15:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/drivers/net/usb/smsc95xx.c?h=v5.15.27

so the fix should land in 5.15 too.

For 5.10, when the fix reaches Linus' tree, then I will ping
Dave/Jakub/Greg to apply the 3 latest smsc95xx commits
to 5.10 stable tree:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/log/drivers/net/usb/smsc95xx.c?id=c70c453abcbf

I have been running 5.10 + the 3 commits above and no more smsc95xx
errors are seen.
