Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF832DF492
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 10:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgLTJCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 04:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgLTJCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 04:02:15 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23438C0613CF
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 01:01:35 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id j22so9292039eja.13
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 01:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=594OU660XPtVB7gB/sqEf7A8tD1XF0YLjx8WPPPbbeQ=;
        b=ec6ch9Ehxm5jgnshYaMD/mRfLdi+6YPF/Bha3Z4GN4OaeaxcHS/xa4lx4Ynu9Be5fb
         yVRi+GgaWXCCqWf9UBliQgKom0mSZW0xTHo7+pJJ9LolqEjC3c7/ecxQQvSZn6MyLI+O
         4TxkBIL+HM0w0WaiHkzJz9Lpv+o40YdH8TccXxzqj+QpKJdyqVFek7Fkmo1UEOAk6l/w
         UkcBby2W2fUA9MfQ0YBFJCotBog5D4nvjC6mLiqmycNsxzxyOoGOp5b14JgtQrBwrxnj
         Trqz3KzTPhUIBmYFcWQtkqpj2GywRR2vn/zvkmcVXN8aOUuYtaYLIwSdXFvkg114HECG
         vMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=594OU660XPtVB7gB/sqEf7A8tD1XF0YLjx8WPPPbbeQ=;
        b=hCHq1YIThXO7P1d1N5fpb+R25DISAPG15/Uaa2HTM/xYL4cp1tCyPtB3iL9v6vISTe
         OLeqGu4h3oBY3mHdtOop4pPbSZeNVaFDKn9p//qRGXqbzPCHJkbWQ05k2P3erblEONij
         HWhHJlJXsPBXwDxaW5k/kCWqbQeMJARnHRxnukIryn6rG67JB83MiC56DC1AmcqW74OZ
         e+SuzMNiEEJWI3fqL00MfOAVO0B+ILA2ZvS/b1oCJxBrkNvL7PAjciJiic70Te61QLNX
         4PiX8epYD4ihEBAFncG2OX/TjagkSO9EHImunLpoBb04ebaAupbuwVs/k7MXS2o2v1AQ
         0aDQ==
X-Gm-Message-State: AOAM5323NcQOWtKw5eqESajWMD7mvJNjEyiws+TaCWs6i0roeeQiBGCR
        1zsp1b+AtJ3GXkWah2MqJkE=
X-Google-Smtp-Source: ABdhPJz17m+wJbvQORsYF6Y0OnUcR+WioOhGzo04GiO6wWUCTFOJ7S1XZSZb0KQMlvbgYfoL9bjAOg==
X-Received: by 2002:a17:906:4544:: with SMTP id s4mr11035691ejq.366.1608454893505;
        Sun, 20 Dec 2020 01:01:33 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id lc18sm7619073ejb.77.2020.12.20.01.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 01:01:33 -0800 (PST)
Date:   Sun, 20 Dec 2020 11:01:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Ungerer <gerg@kernel.org>,
        Rene van Dorst <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: rename MT7621 compatible
Message-ID: <20201220090131.dwqbr6z27sepnpom@skbuf>
References: <20201219162153.23126-1-dqfext@gmail.com>
 <20201219162601.GE3008889@lunn.ch>
 <47673b0d-1da8-d93e-8b56-995a651aa7fd@gmail.com>
 <20201219194831.5mjlmjfbcpggrh45@skbuf>
 <CALW65jYtW7EEnXuj2dGSDwYC=3sBLCP0Q9J=tMozkrP6W0gq0w@mail.gmail.com>
 <20201220074936.ic2mtta7ihg7n3or@skbuf>
 <CALW65jY29uPMGuMCXHsPgf2n5nNPivxmkLWuP_0zO82OL8rZrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jY29uPMGuMCXHsPgf2n5nNPivxmkLWuP_0zO82OL8rZrA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 20, 2020 at 04:36:27PM +0800, DENG Qingfang wrote:
> On Sun, Dec 20, 2020 at 3:49 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > But still, what is at memory address 0x1e110000, if the switch is
> > accessed over MDIO?
>
> It's "Ethernet GMAC", handled by mtk_eth_soc.

I see. You have some work to do with that device tree.
