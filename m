Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB59A3A91C9
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhFPGVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhFPGVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:21:43 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DD9C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 23:19:14 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id p184so1385222yba.11
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 23:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g2iwPdSzazimEwd1QZlBSbZT7ODL6r5ps96JiXt3kek=;
        b=YvZ0jPwTBzIBV1DYgroxmB5iFFai3dx9WIUso1PSVR6bKyI//OSRqc5+A5rYiCOA4Y
         NtZAHIVfI7evkxlrjil6X11NfvnHGsaAi9CzczXHmuFy7ci1AYPPv0JswQwRHVKcUlDT
         6MXGeOf0WOuS1G4KBADp1ckZv0mrY4s0DSK1+n1mIzDFqNFymIbHow6buQupyHIlAETP
         UaLL+zPis9nxM7j/XV15Er46i7eEmS8rv8t/Ty8WNPb46GPxgeZDppO+/RjooTiBUY76
         m+TppCeR/Kf4cxaA9/IsERXx4RAzAhZkODsk+V/e1xgf4DZBkKTy213Djdrf/hnisjmW
         cu3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g2iwPdSzazimEwd1QZlBSbZT7ODL6r5ps96JiXt3kek=;
        b=flzYjYGgu2tXCA3GRb3Q3kZbCTmgAN+4tXu+n/MsJP0hbhsoFzomhmpi+thjWceoSY
         geKvQGdvSFLa/blbvlma7WV2IJy2bHV96zCM2sMXTvHa/0NiKfmhq02wtdZVUc1zUs9G
         GIkaz3+slV1Wc2x1guI3tK2IUtXBkmwZJrQ/OJzuKZyfxbbvDEkfoZ6ESAxU2HscuzQU
         fZe6tX6pc7QjJtFFeMNgKcCf8+2+7XHMHhSy0DZrLOJo/phDiApZeS7qD/B77R7uPR23
         +fLtAMH9NIwwv7CPlGADJoiQO4pH2d8T2AOetSZbRMSgefL7iCTduiRst8wlYTwV9hbe
         tfkQ==
X-Gm-Message-State: AOAM533zOG4alv5AXveqqkrt1lB8Zad1q+nbffWEqUTPyAnaM2boKgD9
        mfhLX5izSD3y6cnH/ePJdCjc+Iw7yrMrrjmKTnYCZA==
X-Google-Smtp-Source: ABdhPJyhOfPtt31P6ajWAxgfdo5lp1tx5HIxuf/tmmag/+WhMvN+DfvPkiMAItaW1+ciODI1VDYchOk0wa8DUBbn7kI=
X-Received: by 2002:a25:4641:: with SMTP id t62mr4402440yba.253.1623824353217;
 Tue, 15 Jun 2021 23:19:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210616060604.3639340-1-zenczykowski@gmail.com>
In-Reply-To: <20210616060604.3639340-1-zenczykowski@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 16 Jun 2021 08:18:58 +0200
Message-ID: <CANn89iKb77-2TYR=kYCf=S6meHnPiQp9Ogoc9YNPyj2qmRgYrQ@mail.gmail.com>
Subject: Re: [PATCH] inet_diag: add support for tw_mark
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jon Maxwell <jmaxwell37@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 8:06 AM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> Timewait sockets have included mark since approx 4.18.
>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jon Maxwell <jmaxwell37@gmail.com>
> Fixes: 00483690552c ("tcp: Add mark for TIMEWAIT sockets")
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> ---
>

SGTM, thanks Maciej !

Reviewed-by: Eric Dumazet <edumazet@google.com>
