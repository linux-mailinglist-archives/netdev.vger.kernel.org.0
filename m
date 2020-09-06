Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFF525F019
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 21:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgIFTXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 15:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgIFTXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 15:23:50 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAF6C061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 12:23:50 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id s205so13631114lja.7
        for <netdev@vger.kernel.org>; Sun, 06 Sep 2020 12:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kto4oLuGRLaPt+lV2wXWAROrxXQZC5JtvWVyufd1qpk=;
        b=pdNSxgWxbgkEv+rzE1CR9jCVxU1GtmPg2fz6JAVrc6fnTEc3gEX+LN4ytg3hfJA3Z0
         fUxcNTQbwyxfRquIntdZNDEAorDgHSfs9qMNXNOlrl9Ipx1Tkfkyz+XRyHaaugoq1BmX
         tmZgCJjl4bqNnvGgLXY++RxTof/3e2VSRZAdOYjbbLlXoXcf01FjeNG0mw1iYT0MxWJj
         vkaggKDzVsjPup3y1YLe013t/3kNB7fNFuiTy8rsmr2Yk0do55ooeYhHKZ3Uwlo15q8q
         B6i34NQlpJ0OWt9YunFGfnRdHOm/g03IXjXm9Bm/IZd7ZjXzJv1aS5f5st/GVPxNMHAL
         i9Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kto4oLuGRLaPt+lV2wXWAROrxXQZC5JtvWVyufd1qpk=;
        b=HnD/1lcU8JaCQBvHarJFFgoLM7aXD2cI9fbbPw9PVLK7Rtm67p/FMn1NQ+wxSKFGzv
         7qycdwgnbnuSRdPrOkYVFxUQZy3PIbhKXyMX23fhkOUAz/KJTbyqrNa9o71fvPzYD1tc
         2o+AajrZ4ggFr1WnW64XYMPvz9z45z8AVANmTHFswyp2oGpD9ke6124bcbQoQvPef4O/
         eps8tEEGZk+h71I8ZiZUlxOLsqFmjrvUKAvt2ohXj4xdxlcq7aIucwSafr/K+Up18v2D
         ZtVT2TJepnmWavS8n3qK5lFpNXRJEyTOGq+dnOXyxGPo1RJH76r8HsZzoLPa4LWWwdmD
         Sslw==
X-Gm-Message-State: AOAM53306tuXAfIwH7Ps5UcvObRZoXWa9SFEquS1yXJm9p07saYq+K1f
        ai54vcaHoL8NaUlqLKswGwG1S5SiGUoK3GeB5dQtiQ==
X-Google-Smtp-Source: ABdhPJzJ8hRL8/w3OPe0XUWSVufQDBZJfzpfaq8DPLo1+hx1GtElPzqJJNO9c4BBPsofMk6Uq85f9sWGQa0WIbPvM9Q=
X-Received: by 2002:a2e:4e09:: with SMTP id c9mr9104885ljb.283.1599420228703;
 Sun, 06 Sep 2020 12:23:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200905103233.16922-1-linus.walleij@linaro.org> <20200906104058.1b0ac9bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200906104058.1b0ac9bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 6 Sep 2020 21:23:37 +0200
Message-ID: <CACRpkdYyaQtptvaTUieEsSyHCB+PYHvgmzNfvhuaJ-Lc9dreFA@mail.gmail.com>
Subject: Re: [net-next PATCH] net: dsa: rtl8366: Properly clear member config
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 6, 2020 at 7:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Sat,  5 Sep 2020 12:32:33 +0200 Linus Walleij wrote:
> > When removing a port from a VLAN we are just erasing the
> > member config for the VLAN, which is wrong: other ports
> > can be using it.
> >
> > Just mask off the port and only zero out the rest of the
> > member config once ports using of the VLAN are removed
> > from it.
> >
> > Reported-by: Florian Fainelli <f.fainelli@gmail.com>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> I see you labeled this for net-net, but it reads like a fix, is it not?
>
> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
>
> Like commit 15ab7906cc92 ("net: dsa: rtl8366: Fix VLAN semantics") had?

Yes you're right, also it is pretty separate from the other patches to
this driver so there shouldn't be any annoying conflicts.

If you're applying the patch could you add it
in the process, or do you want me to resend?

Yours,
Linus Walleij
