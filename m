Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA3A372101
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 21:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhECTzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 15:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhECTy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 15:54:59 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385DFC06174A;
        Mon,  3 May 2021 12:54:06 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id b11-20020a7bc24b0000b0290148da0694ffso3949980wmj.2;
        Mon, 03 May 2021 12:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=gA/wVI9R9iPR4MgFePi+U5PCvMoPg9SjYuV764rxhq0=;
        b=R4gAYZ6y6bD+z2WnwIpcXHEV+bwB6chVdzqggeErY7PBraERfOk2c9EIEks65vyd3X
         mpOWME7cQSfxK8QhdmHI6ec1nKTfDk6M14T/m3xTjOEeD5ws1eKe9dJc96jLbTWecCcT
         tn1LZoc+pEgjY7Ey/EsViylq+LEIsU4+03R4zo4QG5fc1TI92WK2sY5dsFg36nBpAD9i
         YLr/f0ab9L/Vvf0/vmNX9MYE5P4z0cf94G+JIiNzA7YB0dc4Tu8ynk6JIHbM9uy4Tkgu
         zJwW2goQ/s25M0AlVpkuPfEMUNT94oR/4wDw5cPlihhjhHj6Ac2KIYn9dgLtYMgPf5vN
         Or8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=gA/wVI9R9iPR4MgFePi+U5PCvMoPg9SjYuV764rxhq0=;
        b=AKq2P16uOWfxGWIKoSJuq+gzC+pVZVvd+83vG6pmy4R6+n1+kr/tqmL55x+KpLxRuS
         x7nkPj3Z++WMN8oCWmDLA74mXWkAzkOepTHrODjghElBhGTianAvadyR8T4QXOgk7FBP
         zbOQaQulSNdBo36tDYSAyrgbHZ5fAhHj6QLwfm6InPUWbuQem7eoYQVSsmT5HgbeMaT6
         BRKA5UzQ44hbuvdLD02LdqEaeoichI+Ubrjdr5jv8bwlmhP7/hd5zdcLvOBmwQ/U3IJJ
         lFnLEBud/GvDWUlKvWpkXs70VP6fUZrnBMGEj27Y4eNZthjFjTjYTUNdF0NX8l2/ocZR
         6EBA==
X-Gm-Message-State: AOAM530wvtdYZm+y9ARdvgC/6sKjxKQU6qT2zwLvHtGUrEn9+LiCu+tJ
        o8zhbbAPRCCbzX4uo7X+mS3uyIJJ+m56dJbYvUXeM4mgSjBmXA==
X-Google-Smtp-Source: ABdhPJwnrDfaJe9oy4G23qHlGaNvrBgvYYNBFrBHmkZ5kp7kyDlk/tO4l6eancb92Lp+gdmupAPjhPP32Bd380Ggnuo=
X-Received: by 2002:a1c:401:: with SMTP id 1mr219288wme.138.1620071644737;
 Mon, 03 May 2021 12:54:04 -0700 (PDT)
MIME-Version: 1.0
References: <20201221222502.1706-1-nick.lowe@gmail.com> <379d4ef3-02e5-f08a-1b04-21848e11a365@bluematt.me>
 <20210201084747.2cb64c3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a7a89e90bf6c3f383fa236b1128db8d012223da0.camel@intel.com>
 <20210201114545.6278ae5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <69e92a09-d597-2385-2391-fee100464c59@bluematt.me> <CADSoG1vn-T3ZL0uZSR-=TnGDdcqYDXjuAxqPaHb0HjKYSuQwXg@mail.gmail.com>
 <20210201123350.159feabd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADSoG1sf9zXj9CQfJ3kQ1_CUapmZDa6ZeKtbspUsm34c7TSKqw@mail.gmail.com> <20210503113010.774e4ca6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210503113010.774e4ca6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nick Lowe <nick.lowe@gmail.com>
Date:   Mon, 3 May 2021 20:53:48 +0100
Message-ID: <CADSoG1stdPVOE2N0dg10T6tgTUN1nqafY_m+K1CLwB6z2Y9j5Q@mail.gmail.com>
Subject: Stable inclusion request - igb: Enable RSS for Intel I211 Ethernet Controller
To:     stable@vger.kernel.org,
        Matt Corallo <linux-wired-list@bluematt.me>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Please may we request that commit 6e6026f2dd20 ("igb: Enable RSS for
Intel I211 Ethernet Controller") be backported to the 5.4 and 5.10 LTS
kernels?

The Intel i211 Ethernet Controller supports 2 Receive Side Scaling
(RSS) queues, the patch corrects the issue that the i211 should not be
excluded from having this feature enabled.

Best regards,

Nick

---------- Forwarded message ---------
From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 3 May 2021 at 19:30
Subject: Re: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
To: Nick Lowe <nick.lowe@gmail.com>
Cc: Matt Corallo <linux-wired-list@bluematt.me>, Nguyen, Anthony L
<anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
<netdev@vger.kernel.org>, davem@davemloft.net <davem@davemloft.net>,
Brandeburg, Jesse <jesse.brandeburg@intel.com>,
intel-wired-lan@lists.osuosl.org <intel-wired-lan@lists.osuosl.org>


On Mon, 3 May 2021 13:32:24 +0100 Nick Lowe wrote:
> Hi all,
>
> Now that the 5.12 kernel has released, please may we consider
> backporting commit 6e6026f2dd2005844fb35c3911e8083c09952c6c to both
> the 5.4 and 5.10 LTS kernels so that RSS starts to function with the
> i211?

No objections here. Please submit the backport request to stable@.
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#option-2
