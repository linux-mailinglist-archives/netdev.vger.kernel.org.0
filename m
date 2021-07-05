Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB3D3BC2D5
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 20:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhGESqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 14:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhGESqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 14:46:43 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42501C06175F;
        Mon,  5 Jul 2021 11:44:05 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 17so17129563pfz.4;
        Mon, 05 Jul 2021 11:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q9B674I/+/MTqKFyAT06vY9UMY1nLlYo82cmty5TYFU=;
        b=U76TMLXOV4pdFDQFVwfpz4YW7eAM3VMSh+sg+dkwJDnf5Wyu2diLJptad2GOzoaJhj
         9K27nXn0+L6f/KD5uuiR7ez//OnVNMSyK77IQ7ytOlmH6cDgOYcefVnITNhc4efdDhmC
         eW6mYSiUh26B1kMlcJ1VZJOWZpWRL+cIs4OkuPEut6GN8jaSsojbfSIZBXruzABLFXa4
         LXn+hPgjIIVsIsCTY0uNkwbuX0fmjFuYJ/urIhLx7BrAhzSDiCVBqg46y7GXL4uKG+Jw
         QoFDNEJwBjUrGaPSLLNZ1YASrGV/MQOMNJgLldQCac4k880XzGqFMF110w+TKtJHHDdC
         oO9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=q9B674I/+/MTqKFyAT06vY9UMY1nLlYo82cmty5TYFU=;
        b=Ymeex6Ms0jM58OjBh9ZTWc4TCxhZfJ9LbmB9yT3rRD2YX+iSE4fxn7eNkgaBZB0ElR
         WmhrXEmlY2t5MP/Ez5FZB4zIdOUhVZ+NBPOjIsPQFvbMgp5pLTmXxb8cLIwB97VhOFKc
         O6TMav/imOlyqjHB13CzRbVuWzfMg5EqW7gYxIl5YXQWgsARCzvlQL9kPamHZexzIiu9
         2NRQzJYvu+jodsb3Ep9WWuebnnxDqAqho+MXZ8JsZctZfwG5bN1JGMlN/Ea76OmEcksR
         vCCzxQwAHYG4tS3g6WWXgom372zE1cmq/47dSuwPtjiQDgfY62TkKfASgA7G8WLN9adQ
         SyPw==
X-Gm-Message-State: AOAM533kE7ms4ycYo62DefVSGb9E2GvreeiWZxqRTZkq0exOsSwOLSG/
        S4JjQ/0ud7aSVwchu9bUigA=
X-Google-Smtp-Source: ABdhPJyFPZFlKa0i+0rwZcF+zTp1p31HnTBY1c4ty+efUwLDX1BzuLrPZs1aVYGImcZW2oWQ6iM2Jg==
X-Received: by 2002:a63:dd51:: with SMTP id g17mr17197215pgj.238.1625510644823;
        Mon, 05 Jul 2021 11:44:04 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 31sm4292038pgu.17.2021.07.05.11.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 11:44:04 -0700 (PDT)
Date:   Mon, 5 Jul 2021 11:44:01 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mptcp@lists.linux.dev" <mptcp@lists.linux.dev>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: Re: [net-next, v5, 08/11] net: sock: extend SO_TIMESTAMPING for PHC
 binding
Message-ID: <20210705184401.GA16128@hoboy.vegasvil.org>
References: <20210630081202.4423-1-yangbo.lu@nxp.com>
 <20210630081202.4423-9-yangbo.lu@nxp.com>
 <20210704133331.GA4268@hoboy.vegasvil.org>
 <DB7PR04MB50174906EE8CCEB4A02F4C17F81C9@DB7PR04MB5017.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB7PR04MB50174906EE8CCEB4A02F4C17F81C9@DB7PR04MB5017.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 05, 2021 at 08:19:30AM +0000, Y.b. Lu wrote:
> When several ptp virtual clocks are created, the ptp physical clock is guaranteed for free running.
> 
> What I think is, for timestamping, if no flag SOF_TIMESTAMPING_BIND_PHC, the timestamping keeps using ptp physical clock.
> If application wants to bind one ptp virtual clock for timestamping, the flag SOF_TIMESTAMPING_BIND_PHC should be set and clock index should be provided.
> After all, several ptp virtual clocks created are likely for different timescale/use case. There should be a method for any of applications to select the right one to use.
> 
> Does it make sense?

Yes, indeed.  I totally forgot that the user space PTP stack has
network sockets bond to interfaces, and they are completely separate
from the PHC clockid_t.  Need more sleep...

Thanks,
Richard
