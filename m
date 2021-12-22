Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D8A47D5BC
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 18:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344299AbhLVRTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 12:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344293AbhLVRTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 12:19:50 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D00C061574;
        Wed, 22 Dec 2021 09:19:49 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id n14so6033237wra.9;
        Wed, 22 Dec 2021 09:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MNm5zFkmDJ+1D5nLepHbZ6HxOXY1l286NAL+BsStgXs=;
        b=VecyGUi2YCXM1IE8YJ/3ihuakrNx0LqMOV6zPQqd6GGbySAoIGIey0EKYS+tQlqGyA
         vlONqWeAcXqNLrX75jl4PLPiKP5GHsdon1O6+B2pEgRLVuYVu1hZ8tUeNnGRQRq966zY
         TGo/I7hQL0pke7liLyRaayyzvkFkyjgLgOyzzRZ9ZB8y64CyS9jwedb456sPOzOlUMiZ
         PMQasow7MwMcUztNQYxemKVLqCvQasfOzrYxl+KSCU75WB7kA9LPAm8rM5l0xgDO7vN5
         7UC3vSHTeR9nZCd92q2rVUPHSUJyrqVFx8ROZOgYujjJRCCfcLet3u3/XI2hXaxalBfy
         /mLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MNm5zFkmDJ+1D5nLepHbZ6HxOXY1l286NAL+BsStgXs=;
        b=cFVkr88OEzWnZB3mkM1i59e8d8glD0sVXRxtKmiZ70graM8vemKAABodP6iQEUQVNg
         Pvw0pHzZnzvRtDAjCiGcX4h/ooGnheO1EA9olt76zuPZb7jyO98+tQlcP9o+JOIvngok
         9RoL7pHlljU9xeoDH9B3TEfxU3wZa2jOkWpN0jDfICUmpZJtZoj1+9jjOFtGuiMGlnTf
         i3DG8jXCuFATze/6bgNYeXEcyww2rX2yZyDSHiiva8LH+7S9lLGKgrqcvt/MjbB2+XqE
         odxwqeTfQb5PreSrqMd1XurNIsDAZru2l5RfbYEOiufrwOOhovTmefv3LDN+3FfdynQq
         I4CA==
X-Gm-Message-State: AOAM532Z66cOI7AZnp27pKuirfyWeEJadcQyms+QE1AhupUdqS6N0wzZ
        Bu1aJpEiCErgtUlT/mBr+LVsVW1Qf/mKOKMER7K47qtJ
X-Google-Smtp-Source: ABdhPJx3URG7wrVw1exGQrpezpinqQm3pAQ2vmxxbJNGqIBMotaY+f+YnVJRTvlpl2u+fBFhhtrNfhcajBXS5BixOIQ=
X-Received: by 2002:adf:fc02:: with SMTP id i2mr2749500wrr.154.1640193588504;
 Wed, 22 Dec 2021 09:19:48 -0800 (PST)
MIME-Version: 1.0
References: <20211222155816.256405-1-miquel.raynal@bootlin.com> <20211222155816.256405-7-miquel.raynal@bootlin.com>
In-Reply-To: <20211222155816.256405-7-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 22 Dec 2021 12:19:36 -0500
Message-ID: <CAB_54W5Nhhmz2paJ+RjscqFqHo1kZJf-3NPiGP8PAjWGjhecqA@mail.gmail.com>
Subject: Re: [wpan-tools 6/7] iwpan: Add full scan support
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I did a quick overlook of those patches and I am very happy to see
such patches and I will try them out in the next few days! Thanks.

On Wed, 22 Dec 2021 at 10:58, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> From: David Girault <david.girault@qorvo.com>
>
> Bring support for different scanning operations, such as starting or
> aborting a scan operation with a given configuration, dumping the list
> of discovered PANs, and flushing the list.
>
> It also brings support for a couple of semi-debug features, such as a
> manual beacon request to ask sending or stopping beacons out of a
> particular interface. This is particularly useful when trying to
> validate the scanning support without proper hardware.
>
> Signed-off-by: David Girault <david.girault@qorvo.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  DEST/usr/local/bin/iwpan      | Bin 0 -> 178448 bytes
>  DEST/usr/local/bin/wpan-hwsim | Bin 0 -> 45056 bytes
>  DEST/usr/local/bin/wpan-ping  | Bin 0 -> 47840 bytes

I think those binaries were added by accident, or?

- Alex
