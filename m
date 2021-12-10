Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8748F46FD20
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 09:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238852AbhLJJBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 04:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238834AbhLJJBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 04:01:21 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06905C0617A2
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 00:57:47 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id m24so5824003pls.10
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 00:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=spacecubics-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o78r8oCqesWT7jqTVPoth6IM19LStgzO1ZNNWGxpAcg=;
        b=vPd16In+A27Rtsr9JY+O/2Hhe6R2WbhGgeymIxYHdMog/u8sC6FA+A0AYVoLk8xwMA
         iDtr43nagI2JOPL5sk04xRMumKM2+C07uZI8HTbJjJZYO9NAjbuIFc+56B0kue+bMtJe
         G8JJbVJ8LmbR1w1tfl0lBJEXDZfid+5OXvO5GNNDE8U/uAN+kdpvRp7jRBFf6Q4oOUmh
         7h4Z5cwDvC8EdQOMUOGB0GNgQkU5mVVs8Y50vIRQV0gWVxVzGRsWJpXWGmdl0GGo4lis
         mb6+Ezxjoj4G28UsTlCPq2Jq0orWzGVTXEA47Ch7TO8IlC1+Euhf61FdP2jz/DPL3LZz
         aFnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o78r8oCqesWT7jqTVPoth6IM19LStgzO1ZNNWGxpAcg=;
        b=FhYJIzQPArKwmuOf60WP7hbMvzUeoV0/0x04NpLHJvufA1iJWoJQp/qimP7MoT9Lx0
         rT62KkLfztXNmoxK8R5FnGaVTFPhPPG45uDy1Z68/O7MlNhkEYpvqCq8yNnvN3nbNI4p
         RHtn8B6t7g4sq7FI5gmR+y1MJW59kKf3g7Tv1LIWg0pTD7NDLRt/EmE9kKI6sO6gZy1I
         jiMybkAhHKUi845xnFr3pJUM3jMW/j6y2i4CNQbjhXOxEwRXEJBySJIOkQ6GJB+5mgjY
         gglxx+HTfl4ppMORTdnGBO2ggQ3hlK6r+0OYUgr3RhRiQlzyLj/+faKQ6vZ9ubsKaFcp
         Gz3g==
X-Gm-Message-State: AOAM531TjXuZiacOz6mvXvthv74Hc242jkdJYCRPPCvkeo1AjboZOTmu
        xW+ab3i7NST0xh5vORskklJiaFBxFK9RLUSpdCdfvA==
X-Google-Smtp-Source: ABdhPJyStS5NlCVO8vdDsg26SLoOFytFOZeSf1AZFKF4jXizeNkyXoXGEeLcX55fgZCj2gqpe0wshFUG6BWMGgUQ+t0=
X-Received: by 2002:a17:90a:d515:: with SMTP id t21mr22452866pju.123.1639126666591;
 Fri, 10 Dec 2021 00:57:46 -0800 (PST)
MIME-Version: 1.0
References: <20211207121531.42941-1-mailhol.vincent@wanadoo.fr> <20211207121531.42941-4-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20211207121531.42941-4-mailhol.vincent@wanadoo.fr>
From:   Yasushi SHOJI <yashi@spacecubics.com>
Date:   Fri, 10 Dec 2021 17:57:35 +0900
Message-ID: <CAGLTpnJp_v3Eev61gPWRi6fzj400mUR7hLmezXGc2RmA7XDcoA@mail.gmail.com>
Subject: Re: [PATCH v5 3/5] can: do not copy the payload of RTR frames
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Jimmy Assarsson <extja@kvaser.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

On Tue, Dec 7, 2021 at 9:16 PM Vincent Mailhol
<mailhol.vincent@wanadoo.fr> wrote:
>
> The actual payload length of the CAN Remote Transmission Request (RTR)
> frames is always 0, i.e. nothing is transmitted on the wire. However,
> those RTR frames still use the DLC to indicate the length of the
> requested frame.
>
> For this reason, it is incorrect to copy the payload of RTR frames
> (the payload buffer would only contain garbage data). This patch
> encapsulates the payload copy in a check toward the RTR flag.
>
> CC: Yasushi SHOJI <yashi@spacecubics.com>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

It works and LGTM.

Tested-by: Yasushi SHOJI <yashi@spacecubics.com>
-- 
              yashi
