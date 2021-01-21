Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7302FEE1D
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 16:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732333AbhAUPJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 10:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732485AbhAUPIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 10:08:46 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7D0C06174A;
        Thu, 21 Jan 2021 07:08:06 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id cq1so1828388pjb.4;
        Thu, 21 Jan 2021 07:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MeuKCiboQCh2YwwlCqmAAqp8b9M4+CBUaOgidBSKRkM=;
        b=WxC6/hxau4BRwE8GXowxY8Oei4iXDoipqzfqsqASkwzGF1PTdE+d5x1VuMIcGrMuCb
         t1Em2uH71GCguQ41fSym2xQZyfFW3yEIN35y2mY8fE9DIgsumDVSd5k3q2tZKEbZxbAv
         nYOTRllCkyffYu6x/3Qpj6mEP8drktKtcElZkAKOTWR14GurYMtV9BeZvUK6xkHQgv9M
         q5tijS6YNR2ug+nUQuL0KZi/DiTLXU1jOQ8UsXKjuS4CYTp/7B1PH9a3C+IglVabFBj8
         3n7AS73T04GXMDweIlMI91XHB5QpqIpnQatv1tQkfrxQZHLyp/a4KlEjvELx9NzujknB
         koXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MeuKCiboQCh2YwwlCqmAAqp8b9M4+CBUaOgidBSKRkM=;
        b=h+YDpktgwdxh9MpsOuVtMwp3wk4W6UXl19LTF1ihVHobVa1tFHhthLIhIKsCbXZWG5
         myjnPhcrQoWpC1Bn0DAqLxZbPIfffD++dUe8HrzQG4j4iLSBrTo9HJskpyYno4KyMB8B
         J7e6uy01BBfDAeH6XdVQwVsM5/EaWtbSM+QuTDdOOQ10R9bk39HA+wl2MiMkj30w99h9
         kTtfaCJj0BTYH77BNHxXt8QdSQpPZ/Zk/f8U7kxKOirnxmGTJEFJvav7vFUnPh0PkJTj
         McnDiu28wIjfUREM2vgcz95eXIfU8Rp1MZDdvAJSDUwvO03zF8gtHgFnEjJjUeBb6wRa
         2/jw==
X-Gm-Message-State: AOAM5337YRAZtQefSRB69zMb6QVCFSnWQHTKQzKV9tir+iSeGGCe9E0Q
        K1FrMsdnr05LrTrqCZg0y2M=
X-Google-Smtp-Source: ABdhPJz2IVVoPAiIAdnm32MhyYE/K09rdGkBNiSG2mqmwfsycGO271fSxIXM9MD1+puBUZbrnsS7Hw==
X-Received: by 2002:a17:90a:5298:: with SMTP id w24mr12330486pjh.182.1611241686086;
        Thu, 21 Jan 2021 07:08:06 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id q24sm6034212pfs.72.2021.01.21.07.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 07:08:05 -0800 (PST)
Date:   Thu, 21 Jan 2021 07:08:02 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Olof Johansson <olof@lixom.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net 2/4] net: mvpp2: Remove unneeded Kconfig dependency.
Message-ID: <20210121150802.GB20321@hoboy.vegasvil.org>
References: <cover.1611198584.git.richardcochran@gmail.com>
 <1069fecd4b7e13485839e1c66696c5a6c70f6144.1611198584.git.richardcochran@gmail.com>
 <20210121102753.GO1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121102753.GO1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 10:27:54AM +0000, Russell King - ARM Linux admin wrote:
> On Wed, Jan 20, 2021 at 08:06:01PM -0800, Richard Cochran wrote:
> > The mvpp2 is an Ethernet driver, and it implements MAC style time
> > stamping of PTP frames.  It has no need of the expensive option to
> > enable PHY time stamping.  Remove the incorrect dependency.
> > 
> > Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> > Fixes: 91dd71950bd7 ("net: mvpp2: ptp: add TAI support")
> 
> NAK.

Can you please explain why mvpp2 requires NETWORK_PHY_TIMESTAMING?

Thanks,
Richard
