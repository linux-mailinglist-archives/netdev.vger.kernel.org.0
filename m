Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E6D127ED4
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 15:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfLTO5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 09:57:17 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34004 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfLTO5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 09:57:17 -0500
Received: by mail-pl1-f193.google.com with SMTP id x17so4214806pln.1;
        Fri, 20 Dec 2019 06:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hkWco8dRw59sMhOMYfREd70FxO1H0nWVA/bQQmTVaVs=;
        b=B4U/Cy0Jo5ZWdcTxOejAzkRKtbqu1oJ8cNX48pzKNRMx1jx7bG6GM0Fr8ZLpoMgfKR
         RmeJwCepYBDlD6HLi5Im7D7ORLfF9mdZyjTpceiiVUAGTYpTuxiMuUGANPH8pauiyk2A
         wPQlW9yUzrADqqqzH7kDOH3w0k2ahGfUr/trYz0kNaLZeVju1wXwlXOUb9gITh9BfKN7
         b4Spa9s0ePcrVUpP88/J6nHsxFPd7mqLD3LMWWKKXHAQRGiNDLi+NofQoQSy2zBPu/3q
         Ia61NeWbWgJ1dINVmjGEa0/8IUSnrS101RX4O4ID+dhea8bctn7Cz8WvCUfGCW2c2x/B
         OfJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hkWco8dRw59sMhOMYfREd70FxO1H0nWVA/bQQmTVaVs=;
        b=VAxZDqbaTxpgLhkJivKMfl5sxLsqe7SkIGApfRBHFZV6+Jr9459Qg9QXWe4GTi3gOA
         J/s5Mdz7A6MKsjP6XUjcRjBz64x9qOMLp3REFnXQdkstxORRHlk922nRn+hgYdjNbujl
         FLANia5CZgtUiKFcUoRN3FupZdIXhErqrL1eBY9IBKySer5wtLacbramWZ98IVNiR0u7
         olyT3hvR8tL89/Z9//FMonggxCFmqtpdRpqSRBSFLYjbbAvAXGeOJz2oYrzsoBL8vINv
         wLQw+qtOuzowS4RU4ybAnytZ9JSeQdtiec9W4Yawj7zdJQIyZQ/9NZKZOKzpjCh8nqnl
         kJkQ==
X-Gm-Message-State: APjAAAX+Vc1LdHHpjuUad6LCG3kwUw6KUC4TFBBR2auSBo+Kj17sgwqM
        j/hsmJwds78lhKIYCpn6hK8=
X-Google-Smtp-Source: APXvYqwy7FBGM1nmXMxgGMObkWPUX4z7afo67yur0K79OgQbDAlglTObe9TLYetTlj+g52JNcu3Mjw==
X-Received: by 2002:a17:902:bc45:: with SMTP id t5mr15255745plz.163.1576853836223;
        Fri, 20 Dec 2019 06:57:16 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id x7sm13927986pfp.93.2019.12.20.06.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 06:57:15 -0800 (PST)
Date:   Fri, 20 Dec 2019 06:57:12 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V6 net-next 06/11] net: Introduce a new MII time stamping
 interface.
Message-ID: <20191220145712.GA3846@localhost>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <28939f11b984759257167e778d0c73c0dd206a35.1576511937.git.richardcochran@gmail.com>
 <20191217092155.GL6994@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217092155.GL6994@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 10:21:55AM +0100, Andrew Lunn wrote:
> Forward declarations are considered bad.

Not by me!

> Please add a new patch to the
> series which moves code around first.

Sorry, I disagree.  For new drivers, sure, but for testing, production
drivers, moving code blocks around "just because" is only asking for
new bugs due to copy-pastos.

> When using phylink, not phylib, this call will not happen. You need to
> add a similar bit of code in phylink_mac_config().

Good to know.

> For the moment what you have is sufficient. I doubt anybody is using
> the dp83640 with phylink, and the new hardware you are targeting seems
> to be RGMII based, not SERDES, which is the main use case for PHYLINK.

Yeah, my impression is that the phyter will be the first and last phy
time stamping device ever created.  Designers reject this part because
it is 100 mbit only.  And there are no gigabit+ phys with time
stamping at all.

So I don't anticipate the phylink layer needing any of this time
stamping stuff in the foreseeable future.

Thanks,
Richard

