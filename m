Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0883B2AAB23
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 14:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgKHNW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 08:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728267AbgKHNWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 08:22:11 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E7DC0613CF;
        Sun,  8 Nov 2020 05:21:53 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id x11so3411601vsx.12;
        Sun, 08 Nov 2020 05:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8JQ1el9D2LALj0FcpzFmr4ujCcSZ5M2XjTP6XGBrnow=;
        b=nPWtn0STAepOPyKQv8Ug9XcmX79xnAbr3q3Fv4QgxGFK9V1+jGtSB9TzOR2h11Z96o
         N3sX72sK3qINQ70L+et5ssvZdR2UxRkekNNFjeTcwElYtgVZuAhMM4LemD0g47WTCISc
         4xX+9+Uf1wA8pg96YVfSMf77pIHCAkJA4Jfop/t/zKtQCsreQe8oq8VjPU6uNqLefSGv
         0eO3E1JRB+Pmk8Ft/SxDhdgPHdHO23EF46svLojAOjtXuaDzJCu+gFhgxHYmdmhGa9Sp
         gR0kMOXbpL7RDufDAZDWBappNGiS93Ny+VDDCLyZQDw4/sAOwVBDUt+TGKG3j9kuHaux
         yMyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8JQ1el9D2LALj0FcpzFmr4ujCcSZ5M2XjTP6XGBrnow=;
        b=k7umAXw7auM/PHV9GRW0ZWegJkYImxpHgOXW/HRDcIgmGrLufrOk5D+dFx56aEWUGi
         dCe0SVLkuXHVxt1zlr46xZ+XEgOun+/5SAmqie6UCtj07lFQPIG+l/IsvBnfmms5IEAA
         pmjOBLirFMLmmVPwgQOVRGFPQj5OODS0huZ9eOYKICGhEjQoCPB88R2ePrlPCjo6Izaj
         q7mXEZGMmvUkAbUtl4OccUll3QNMezzXTTr/jKVoOXDOE2MgInrgWA3CRMwAunQfZKYL
         xx4556N7swEhzk0GxA+wS1pVDg7dMeiQzem2CeM7hUeRMmMPruP+5umpxwtYNdPru7Sb
         XSLg==
X-Gm-Message-State: AOAM533UjbPcw2ksJSiQk/8fwp+aeVXJxtK4hF+3FouHpAsX9b1JiP2C
        bOQ7O7MpViOFgN0uKyUdItMK0j3q/y8pz1XQJSzJDfiN
X-Google-Smtp-Source: ABdhPJwGqfEVBjMGWDHMmXDH1js+DipI1El06ign1qLqtxoCIdoYvfb1JTiEm5zXjpcLCpXX53Zxfq4zDyzVc4CKfXQ=
X-Received: by 2002:a67:2ac1:: with SMTP id q184mr5431305vsq.57.1604841712469;
 Sun, 08 Nov 2020 05:21:52 -0800 (PST)
MIME-Version: 1.0
References: <20201106134324.20656-1-TheSven73@gmail.com> <20201108041447.GZ933237@lunn.ch>
In-Reply-To: <20201108041447.GZ933237@lunn.ch>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Sun, 8 Nov 2020 08:21:41 -0500
Message-ID: <CAGngYiVk+33AUBC9mpZ4pty1w=JH6_JKRfAqbJLby919E6Lybw@mail.gmail.com>
Subject: Re: [PATCH v2] lan743x: correctly handle chips with internal PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Roelof Berg <rberg@berg-solutions.de>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 7, 2020 at 11:14 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> This also has nothing to do with the problem you are fixing. It is a
> sensible thing to do, but it should be a separate patch, and target
> net-next, since it is not a fix.
>

Agreed - I will spin a truly minimal v3.
