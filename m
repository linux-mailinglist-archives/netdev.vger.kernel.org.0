Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484663FEBE2
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 12:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhIBKMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 06:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbhIBKMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 06:12:52 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F07C061575;
        Thu,  2 Sep 2021 03:11:53 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ia27so3046360ejc.10;
        Thu, 02 Sep 2021 03:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=93MpCKBuP3PiexQORBIsa53hubF8PLlO4HrVUIuNKOY=;
        b=W4mrHAsQAZm6hTEWuqNoH7IrlcWs3GowYJfXBRKliSrdb6gcq+O133JWaBwN4Ql98z
         PCYW9krigql6ibTXgLPAGZEVjEQsbz9cDPWMgFD2DZmpBdeLLAYGHNKeW5YpKNK8RbSb
         AZBsec0bQfPAMIgKzcXZqNY1/yhViw3l3BnL91K1knafSvsFxBhGfiXOcAzZqoLLBAR5
         hNjt2Vhla2t4/K2nOMJG8hh/oluBUcNZYPJi0QXeqjuJEciHz4l9K9sXBCY7u2I64SRR
         N2bH8zW/h2TzeNn/cLHWcNw/qkkghF0ac9UtkUOTrBWeo3eprhv42CaKToK+7yThQipp
         tSwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=93MpCKBuP3PiexQORBIsa53hubF8PLlO4HrVUIuNKOY=;
        b=arpHu0SmIbDhAjeZWVh67Gc1p+Yr20YxmAi2mEqK3ikHJjpt6asA5ToMk2qOCeY5g1
         NFAo1etOn6l3+wt+FlO23ZBetK97c9wKBMbKQNsXT5ZptyQsTFIFw5C+f6sCzP6K5ORM
         PHwxTOAL5zSo9Iyyh+r9gIie8iIz84DFaJ/VESGNSfgK1eY+Pfp6eCcyaOF64mmOybCK
         t3yludpEmQ5aHjfu0Y3FeWahO48xP4jsrMmCqUKGdWXQwUDDoWIJlV31abnLsZ0wX9AT
         Lpi9mQX2QZS4pSiMwrDAfXpzs4gXgnla5rN06SPqtpnSY/Elaq+8CCHXqPk2YIt2o7KU
         oltw==
X-Gm-Message-State: AOAM533l99IGouBJ/71FzUzw9/9xOKREUkVTC7gLBArjsMWsEpItoEVr
        0F8FvQyOm0juI7YYBcZSJhk=
X-Google-Smtp-Source: ABdhPJypP5dnegrqCjmAhKmewx4MmREZKkKZRYYtSh5CoKij1TP/x85/FZXRWAzsK3UDs5Qxzr7T5w==
X-Received: by 2002:a17:906:26c4:: with SMTP id u4mr2830666ejc.511.1630577512412;
        Thu, 02 Sep 2021 03:11:52 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id j6sm876846edp.33.2021.09.02.03.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 03:11:51 -0700 (PDT)
Date:   Thu, 2 Sep 2021 13:11:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <20210902101150.dnd2gycc7ekjwgc6@skbuf>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com>
 <YTBkbvYYy2f/b3r2@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTBkbvYYy2f/b3r2@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 07:43:10AM +0200, Greg Kroah-Hartman wrote:
> Wait, no, this should not be a "special" thing, and why would the list
> of deferred probe show this?

Why as in why would it work/do what I want, or as in why would you want to do that?

> If a bus wants to have this type of "generic vs. specific" logic, then
> it needs to handle it in the bus logic itself as that does NOT fit into
> the normal driver model at all.  Don't try to get a "hint" of this by
> messing with the probe function list.

Where and how? Do you have an example?
