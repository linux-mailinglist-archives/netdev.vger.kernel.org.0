Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C41D5EE42
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 23:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfGCVYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 17:24:10 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46555 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfGCVYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 17:24:10 -0400
Received: by mail-pl1-f194.google.com with SMTP id c2so326752plz.13
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 14:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v2vlXPjl67SKMwWFhxyJH5w6PdqnZPQg08QW+0HWg7o=;
        b=ECWISvYPDdYHD27CqcEoHJMDMinxTVOSDWlk2tr4YmVh0risPbbZjyZJ/8WzBG1ysf
         itDw9oG9DAwxaorQ82esteEEeZuZI09qIiZUqDSgxD1M/0EVve3zRKZ95EKnP5c4KoWo
         ba4Rh808R5Zvinvhgua86qIek5/NBOuP44d2c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=v2vlXPjl67SKMwWFhxyJH5w6PdqnZPQg08QW+0HWg7o=;
        b=qLr15Pk76atLs5uEl1ivSWff/fHk075yDEg3ykfC2SSREiwIX6HFfFe8k2O9H3lx1S
         Y3ic821MosAJH0ZeO2Mtvfd8bAfngiCeqHxl0kckZxuaFubL49jzp41DlEDJvcsKb+1Q
         W3136jHwp7Q67jPmJ6xy7TlLvVCCxztxGzPbo+sFXgZTPZ5qBiAEw5XgJPOFuAiPeon+
         3T9alBaOFzwIQ8Me2AgNcZdX1T5ERCJGP7Eq8wj/Xqyt8DhtdIKychrXQe9CMZX7C1xf
         sI2FAO6YmdGQqiP+IhhI8t8CC1I0NSK7ZFuL3/2OJyZGGDGb3xsnbocCSMonneKb4hxS
         TPuQ==
X-Gm-Message-State: APjAAAWslKhKjCh37dnxC7fLDFhWyw2DYG54oBLpMdSJGnfmgj/hQE39
        udQeNS5pthM0KrSK6y+S+McPIA==
X-Google-Smtp-Source: APXvYqwHlT4x2pD/pE1d9wNBgrNtHbF+tIzS8ug8mk9SDfeO2q20ORWVmVGYed7fY3M0n+yfpljt0Q==
X-Received: by 2002:a17:902:1003:: with SMTP id b3mr45312466pla.172.1562189049492;
        Wed, 03 Jul 2019 14:24:09 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id f10sm3450912pfd.151.2019.07.03.14.24.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 14:24:09 -0700 (PDT)
Date:   Wed, 3 Jul 2019 14:24:07 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 4/7] net: phy: realtek: Enable accessing RTL8211E
 extension pages
Message-ID: <20190703212407.GI250418@google.com>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-4-mka@chromium.org>
 <dd7a569b-41e4-5925-88fc-227e69c82f67@gmail.com>
 <20190703203650.GF250418@google.com>
 <98326ec2-6e90-fd3a-32f5-cf0db26c31a9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <98326ec2-6e90-fd3a-32f5-cf0db26c31a9@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 11:01:09PM +0200, Heiner Kallweit wrote:
> On 03.07.2019 22:36, Matthias Kaehlcke wrote:
> > On Wed, Jul 03, 2019 at 10:12:12PM +0200, Heiner Kallweit wrote:
> >> On 03.07.2019 21:37, Matthias Kaehlcke wrote:
> >>> The RTL8211E has extension pages, which can be accessed after
> >>> selecting a page through a custom method. Add a function to
> >>> modify bits in a register of an extension page and a helper for
> >>> selecting an ext page.
> >>>
> >>> rtl8211e_modify_ext_paged() is inspired by its counterpart
> >>> phy_modify_paged().
> >>>
> >>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> >>> ---
> >>> Changes in v2:
> >>> - assign .read/write_page handlers for RTL8211E
> >>
> >> Maybe this was planned, but it's not part of the patch.
> > 
> > Oops, it was definitely there when I tested ... I guess this got
> > somehow lost when changing the patch order and resolving minor
> > conflicts, seems like I only build tested after that :/
> > 
> RTL8211E also supports normal pages (reg 0x1f = page).
> See e.g. rtl8168e_2_hw_phy_config in the r8169 driver, this network
> chip has an integrated RTL8211E PHY. There settings on page 3 and 5
> are done.
> Therefore I would prefer to use .read/write_page for normal paging
> in all Realtek PHY drivers. Means the code here would remain as it
> is and just the changelog would need to be fixed.

Do I understand correctly that you suggest an additional patch that
assigns .read/write_page() for all entries of realtek_drvs?
