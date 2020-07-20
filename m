Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC5E226A30
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388836AbgGTQbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388823AbgGTQb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:31:26 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6DCC061794;
        Mon, 20 Jul 2020 09:31:26 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id d16so13216801edz.12;
        Mon, 20 Jul 2020 09:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iuVszLORzUqiZj6M6YeAEQFI1sJEhteSIqt1C5FLYSo=;
        b=tCiCsdFigGdR6jDfWT2r8Temvk3eYrQ1lb2q9SMowTyEb3Za8wIRp87riivkeMys0i
         xBXnFNxBnP0Vo67C/S8tkPr6MIxJCcUlrBq/9EXLRMTjINGxy04/VLPz6gL1bXh3YYK+
         QhR78xqShjNpIKPU612cQlbITCx6Ofn9okGMmrabEMDekda/gLLf4286uPeYb8D/QgFe
         VqzPwLmPE4rgpzviJ2+wppw47WlXjovZV6wHPe6CteG2fkw+kLLNCEpi4+8FDel1Tmrc
         Hk/2+53bQOBtIgp/rFy2NVk+bofuIBigHVjhrNeSznHcXjQOEAGuLnIxhdnThLm3E0Je
         ZPtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iuVszLORzUqiZj6M6YeAEQFI1sJEhteSIqt1C5FLYSo=;
        b=DYdLPQHGE/T5C3rJrPnizrkLFTSS6WpnSrfb5uBLEm/CEpDZc1+0zoI+todowpepaG
         o7na5QS5mZrr2pyYzTgJTL1gW0LQueK47Vveq0pTpP4mCsi3oJoR7a0UtjJ+juPDdu1B
         bI3ILKaXB6ac3Rwxjz9Et6L58cs9gFJs0zyTbwpw5XbociyPiRN72+KTKhbo1Dh9EGpi
         MIvWKWQMY8o3969Zf4dneS7lwA1GvcGjIN6fqzmVlv2F9xQ3A+OC3Z3yeEYJGetcEXUV
         eGe1XGUVezsr7UBxvuBvU4nxU4AvyEmTvgbeYjoMj4XG3PnN3kMCRcE0CL9IDZc5vpoP
         m0gQ==
X-Gm-Message-State: AOAM532vfiXjoFu5EwGYDl3Ol6JDOzHpntdmBSYNaKMs6pG2T7S39LTt
        5xDP4TQgrnrz+lj+J0NB0dE=
X-Google-Smtp-Source: ABdhPJzGO0wAKSG+S1bZNUexBZlC3AoA78Q1akQIDEE3n4fqzgWrb+9EJzVvfeH+uNLscsOwxZMQ5Q==
X-Received: by 2002:aa7:d297:: with SMTP id w23mr21514702edq.49.1595262684956;
        Mon, 20 Jul 2020 09:31:24 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id q21sm14941656ejc.112.2020.07.20.09.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 09:31:24 -0700 (PDT)
Date:   Mon, 20 Jul 2020 19:31:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: net: phy: continue searching for C45 MMDs even if first returned
 ffff:ffff
Message-ID: <20200720163121.sihkkncthvwnfqd7@skbuf>
References: <4131864f-9e3e-9814-5f4d-16c93648bce2@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4131864f-9e3e-9814-5f4d-16c93648bce2@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 05:21:13PM +0100, Colin Ian King wrote:
> Hi,
> 
> Static analysis by Coverity has found a potential issue with the
> following commit in /drivers/net/phy/phy_device.c:
> 
> commit bba238ed037c60242332dd1e4c5778af9eba4d9b
> Author: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date:   Sun Jul 12 19:48:15 2020 +0300
> 
>     net: phy: continue searching for C45 MMDs even if first returned
> ffff:ffff
> 
> The analysis is as follows:
> 
> 735         * for 802.3 c45 complied PHYs, so don't probe it at first.
> 736         */
> 
> dead_error_condition: The condition (devs_in_pkg & 0x1fffffffU) ==
> 0x1fffffffU cannot be true.
> 
> 737        for (i = 1; i < MDIO_MMD_NUM && devs_in_pkg == 0 &&
> 
> const: At condition (devs_in_pkg & 0x1fffffffU) == 0x1fffffffU, the
> value of devs_in_pkg must be equal to 0.
> 
> 738             (devs_in_pkg & 0x1fffffff) == 0x1fffffff; i++) {
> 
> Logically dead code (DEADCODE)dead_error_line: Execution cannot reach
> this statement: if (i == 30 || i == 31) {
> 
> To summarize, if devs_in_pkg is zero, then (devs_in_pkg & 0x1fffffffU)
> == 0x1fffffffU can never be true, so the loop is never iterated over.
> 
> Colin

You are absolutely correct. The check should have been || and not &&.
I have a patch in my tree where I am fixing that. I was giving it some
more thorough testing to understand why it was working, though, and how
I could've missed it. One hypothesis I can't rule out is that I tested
it using || but submitted it using && somehow (although I don't remember
doing that).

Thanks,
-Vladimir
