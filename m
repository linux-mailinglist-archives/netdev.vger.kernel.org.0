Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3E9309044
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 23:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhA2WrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 17:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhA2WrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 17:47:18 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4915C061573;
        Fri, 29 Jan 2021 14:46:33 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id c12so10369977wrc.7;
        Fri, 29 Jan 2021 14:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e+kYw5wu2PYjqFL+U98CVrn2rtPzopQguQ10OriQ15g=;
        b=BuS70KQPyDyBsTR27sZMW4xb1tgHULYhnjZI7Bb6Q4BblLPLxVqdgYY8GCPaPZs1ZG
         ccVf3BMR18LV1pGCMKZlxroV27NLzb98XaumIFbsplsWYrmC+Vqlkp51Q6pWARJeXQel
         q5I+//maed2JjqayjUqRJZWetexDUsK0L/yeKese1zlVtDTAObr1N+DCi96H9LQaGjJ1
         DdVOKWFCfUrcA/GY0elL0eTFd0oMTWaFzaXxeIq80Fx69zQ787KhNVw0uTPD87yBpRtQ
         NptoBysrTAutfT9bcA5VD8jW8P6aeFdF6cmhtFHQXrkbbMVgZHSYjqIXaeTABq/7TkZO
         c/yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e+kYw5wu2PYjqFL+U98CVrn2rtPzopQguQ10OriQ15g=;
        b=frR3nleH2uO/nq6Vf/b48pU7LfWr2pCTaSWZ4PVgNIqFx7YN/FH9wxQSUMzEYIYfv/
         v3nTM+IKAmKkNGgZpl0mT3VocHgtiALnnxlm2rOGEmSMKGr2Z7iP9Bd/6glx8isJvY26
         XKMFdQT4Y7XFSwzchXDHz4T7JC/rT6FjpH85LIMCrs4uC0Xd9FgNuWh2CsIJ2B5OEKCi
         gKGO/gqt51Xw4c/5Ez93ECHt0+bHFR9fuj+uI4TCbtmN+ZEjvPQ/zZya1FbWQAyEFi+D
         Vrq3QFpfcd5pxIU05Ewy4Q8IMm1mY2csUxJuCfHxozb3uwySqv4ckYFGaOPZPVaNozDx
         R1Og==
X-Gm-Message-State: AOAM533/rV91Ki1j83zj9QM1DWMfEYaM4hoYHuQanwTWlIfbYpUDO9/C
        BPaM5vVG8aG+0Z2rtxaEsnahaQ4aNnEz5+2pZJg=
X-Google-Smtp-Source: ABdhPJxA6OGWrNE7utWJn9uxzTUEL5KMVJxh/BE7PWhRiEzgzB5p7I2dYaRGCa6Uak5O8+y2cfse3iN6dm7zmmYS+Vg=
X-Received: by 2002:a5d:65ca:: with SMTP id e10mr6975718wrw.166.1611960392423;
 Fri, 29 Jan 2021 14:46:32 -0800 (PST)
MIME-Version: 1.0
References: <20210129195240.31871-1-TheSven73@gmail.com> <20210129195240.31871-2-TheSven73@gmail.com>
 <20210129140120.29ae5062@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129140120.29ae5062@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Fri, 29 Jan 2021 17:46:21 -0500
Message-ID: <CAGngYiUyA10XEi4m18CP4AH1YAc3p+3tdb2G36vKZ=9eDxdmGQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/6] lan743x: boost performance on cpu archs
 w/o dma cache snooping
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 5:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> You may need to rebase to see this:
>
> drivers/net/ethernet/microchip/lan743x_main.c:2123:41: warning: restricted __le32 degrades to integer

Good catch. The problem goes away with the next commit in the set.
This is probably because I rebased to the little endian/big endian patch at
the last minute. I'll fix it up in v2.
