Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABAC3E3788
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 01:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhHGXIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 19:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhHGXIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 19:08:51 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824C9C061760;
        Sat,  7 Aug 2021 16:08:32 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id oz16so5864525ejc.7;
        Sat, 07 Aug 2021 16:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=blzJOizjsPK/xLHnGPayAC6ZePiXUNZMaLQXscMfUtI=;
        b=YUUvoZracUWO6JaLAKHvZzf+ENOGTLjRKI+Ac2+XSDun+ReWYIqKE7sr7QuHrgUpns
         jhoCvOf82vGK8kB1IiuSoFrkF0c5BFQFRNzH9nzd2Fx6U/idyt1LOX0ouGmwy44XKu8t
         c8u1luBO61/7Wwezg2mdvB60kO1u+9CWBfw1gc79TbbzRE/g8ZxinPz3AmTmtI9/Xd8g
         SOK4rjez+GshOZJmorE8jeBovYHrRTwIlOYvZpy99E7K0U5yY3mGRO/0IGJKxOPhnkzb
         qKmk7j67TFLL/Bnik3mbEaVUf9l1tFdu880hOCtu0XnumBGYZcOFxUo5PtXHBRTJHFYn
         wfGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=blzJOizjsPK/xLHnGPayAC6ZePiXUNZMaLQXscMfUtI=;
        b=QFCRgF8Us41a+BbLDj5FqGaTaReBl0f+FFocqKapNyFeBeQY4yBj65jbyVC/EqjqLr
         Wl+4RVArniZaiot1QsVJroXJyYXzCezzEejqOzmKFXvWZ+7Uqayhjsx9OqKjZ5TGHpcE
         GAFcKn38Z+eTqHYz6PkqslG93Fpc83DKTLfyEbbZVSBhxTtYPbM3qe134Ly8E57zLJwD
         PakBD2rVZ6Vd9CX3kPz4o/07r+P5EF0QFvdFCMi4ZMdX8RUAQXciG5UXGl/+H0ZAld0K
         6pCo+bThcgAPH7BoaQdBEgS914gL2DHCgtLxbCBfTGrFyhbiL6DfsuHdC7MpyRoSkwRL
         1fWg==
X-Gm-Message-State: AOAM532VJoncig3h4GD2+p5t5/mfnzhfm9a8esS0dWduq/CseMPT1O5n
        bxDlfyxw1TkMgGO1l+6TMYs=
X-Google-Smtp-Source: ABdhPJz9tOJeddhC9/Iv/oIDZ5V/HZpoEgCQKHCsFS8O6WSA8A9/e9hFCnPpkXEX6e2he6zoR/v0fw==
X-Received: by 2002:a17:907:3e1b:: with SMTP id hp27mr16254693ejc.116.1628377710897;
        Sat, 07 Aug 2021 16:08:30 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id v20sm4212798ejq.17.2021.08.07.16.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 16:08:30 -0700 (PDT)
Date:   Sun, 8 Aug 2021 02:08:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v3 5/6] net: dsa: qca: ar9331: add bridge support
Message-ID: <20210807230829.m3eymcwucjtyrgew@skbuf>
References: <20210802131037.32326-1-o.rempel@pengutronix.de>
 <20210802131037.32326-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802131037.32326-6-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Mon, Aug 02, 2021 at 03:10:36PM +0200, Oleksij Rempel wrote:
> This switch is providing forwarding matrix, with it we can configure
> individual bridges. Potentially we can configure more than one not VLAN
> based bridge on this HW.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

I don't see anywhere in this patch or in this series that the
tag_ar9331.c file is being patched to set skb->offload_fwd_mark to true
for packets sent (flooded) to the CPU that have already been forwarded
by the hardware switch. If the software bridge sees a broadcast packet
coming from your driver and it has offload_fwd_mark = false, it will
forward it a second time and the other nodes in your network will see
duplicates.
