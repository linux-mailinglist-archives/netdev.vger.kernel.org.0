Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB64B426630
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 10:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhJHIrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 04:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbhJHIru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 04:47:50 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6499C061570;
        Fri,  8 Oct 2021 01:45:55 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r18so33551500edv.12;
        Fri, 08 Oct 2021 01:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qbtc42tdcLddddPk4Nl/b0hjJZcICwZrpNrFhchyl3A=;
        b=VNU1+gt1YxzOTUPAJ/W0KbL8ooIsnJBlW/2qXPFiMmnbWof7EMgjH+aB4lWTgUP3LR
         28CoAJIgthXfOMx97mZ2OYc5JJzSTq11EscOcp6JZ0t6DFEBcJjG5jSeL53v0b9iXoFk
         oEY/5JPpAJPWgbGoWIGurqsNgK7XKjtjtuqfKdmeUxNmnZlXv8K8qhFrRIuSD6b939wX
         YX5CcgYpLx4B6FFUFdKnfNL5ewB+ciUZxCb10EBqQAmKyVC42YXXwNYY0QCTeoZcwhsl
         HVa8GxIaNwsRULrLhf1WE6wRGaGU+cZrBfuKsFTKTBT8WHzFbae9wC42xxP5SvaTBdL+
         J96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qbtc42tdcLddddPk4Nl/b0hjJZcICwZrpNrFhchyl3A=;
        b=bwnOm8vt6uqROi5N4jQlKjrL8HphxtcEGvedwVIPm6hpzgiCZ+YtZDv5adudCysJYu
         /6au92u/UFKbcuzAAYKHrJ6cWN0tCRM8n3ROYV8kVQ20o9bf136zbqnTfj6hhoyO0+rs
         wuiSesBxKLCB6/MYRn7LfxXEI6ed3WNKQ+hJXo+CbCa5fugYpo5S+VW5CyrwzwajtZS+
         P5pjZGiccsF5FJifL73Sikx6qXnPlt2nAuwn3onV8phxnf1EeBqblMbWWFN4hzIkkwmX
         1Sodvps9MZBn7hoVO1BSOIvgdDAXxEM9p8PQ3T4DSsHjvG+19u8+YWuFIPvSOkRJRgV5
         ALag==
X-Gm-Message-State: AOAM530rDFo0QjO+Yt5yYbkoLje4Woj/E9SFQOYxXDYP45mi9uYh3WMd
        I3l9MUq6p5E61mKvwXrDiiI=
X-Google-Smtp-Source: ABdhPJypgP4ryswRLVF5ukX7LG9Tu9NMaJutQfu1nojnjmTqsHUPd8w9OfgRlsfjD2BN4raRqI5lYQ==
X-Received: by 2002:a17:906:66d5:: with SMTP id k21mr2435901ejp.487.1633682754052;
        Fri, 08 Oct 2021 01:45:54 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id z19sm662331ejp.97.2021.10.08.01.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 01:45:53 -0700 (PDT)
Date:   Fri, 8 Oct 2021 10:45:51 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net PATCH v2 01/15] drivers: net: phy: at803x: fix resume for
 QCA8327 phy
Message-ID: <YWAFP/Uf4LPK2oe6@Ansuel-xps.localdomain>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-2-ansuelsmth@gmail.com>
 <20211007192304.7a9acabe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007192304.7a9acabe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 07:23:04PM -0700, Jakub Kicinski wrote:
> On Fri,  8 Oct 2021 02:22:11 +0200 Ansuel Smith wrote:
> > From Documentation phy resume triggers phy reset and restart
> > auto-negotiation. Add a dedicated function to wait reset to finish as
> > it was notice a regression where port sometime are not reliable after a
> > suspend/resume session. The reset wait logic is copied from phy_poll_reset.
> > Add dedicated suspend function to use genphy_suspend only with QCA8337
> > phy and set only additional debug settings for QCA8327. With more test
> > it was reported that QCA8327 doesn't proprely support this mode and
> > using this cause the unreliability of the switch ports, especially the
> > malfunction of the port0.
> > 
> > Fixes: 52a6cdbe43a3 ("net: phy: at803x: add resume/suspend function to qca83xx phy")
> 
> Strange, checkpatch catches the wrong hash being used, but the
> verify_fixes script doesn't. Did you mean:
> 
> Fixes: 15b9df4ece17 ("net: phy: at803x: add resume/suspend function to qca83xx phy")
> 
> Or is 52a6cdbe43a3 the correct commit hash? Same question for patch 2.
> 
> 
> The fixes have to be a _separate_ series.

Hi,
this series contains changes that depends on the fixes. (the 4th patch
that rename the define is based on this 2 patch) How to handle that?
I know it was wrong to put net and net-next patch in the same series but
I don't know how to handle this strange situation. Any hint about that?

About the wrong hash, yes I wrongly took the hash from my local branch.

-- 
	Ansuel
