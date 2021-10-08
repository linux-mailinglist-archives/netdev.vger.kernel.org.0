Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE1F427460
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 01:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243909AbhJHXwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 19:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243797AbhJHXwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 19:52:21 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BA1C061570;
        Fri,  8 Oct 2021 16:50:25 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id d9so18130100edh.5;
        Fri, 08 Oct 2021 16:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VBpOavYaePL/4OWp+PM6HaY879JvujZlFSqs4UGphdg=;
        b=DgcV/aiPSdPqxzH43JmT6WliO2OYH8sMmoZmgYhXtN6igDNmSfv7gUkiyJIg/vgLDh
         E62x+kM7hhLrPuuyWc3BnqWq+OOOXuYJlelJvbH8Q/W1Rqgs86lgo3LI3rfPn3zQ3qUR
         8TJVe5hm0F4WPsva7Q/damnEc/PFodXfXPiU1ZCUCJsFZDCCluT8YvpjYfDqgrgRUq2W
         sf48709IKReF/QjtKB6IFgD0qenpHhjCv6W4516u1FpejCqY+gPdZCPmTEYzX+J8AqDv
         BpcU++yZ++LZOFbZrEX+9R54wJeH8QWrQv39wZuK4yYEDdbF8Vhz48NNgXfv1iT7Uoki
         cZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VBpOavYaePL/4OWp+PM6HaY879JvujZlFSqs4UGphdg=;
        b=QY8oTCRLRnosN0GxllD60Poq+xM3RUYuTXvj+hd7PV829r3KsKSfmGYdmOlejLS0Tv
         Hq2rIFM8Bl+72rkhhy1g1EHgfXs2zk/Z1hqHvN41k5/AJl9PsG4s03t5mVl0T/J2TUlB
         1IxBm8gJarqUBLKuQBLw53aON4IEFf/o/P3yFJsPvryBOf9RgcUU5o0yMD5MsAgUrEGL
         WH3oLJ+PspMrbS8tc3997W2eMFrcqM6H/gVr5PEjbmES7fADfNudLZP48bYJXsvPEoKN
         SPD0+3kSh9KLm/tktOnM0FFCYP9ib67n66Jb8YiMP3opN/h/5Xu8S3hOYacwXiwXV5fh
         kADw==
X-Gm-Message-State: AOAM530i/nMX3eC9fQoOHUriwmQDgeHoxSpm7QNnjWe9B8o8UAlaFclh
        zvlPM9ovCLQ9dDrFJVRrBu0=
X-Google-Smtp-Source: ABdhPJxIe3FvjJCwgr3Yv47xwFnQ8KU4M/hHs419Y4v2wMBgTnl4FbtUdEULBfvaWsqR0AcLJAM9zQ==
X-Received: by 2002:a05:6402:270b:: with SMTP id y11mr12579922edd.387.1633737024120;
        Fri, 08 Oct 2021 16:50:24 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id e15sm241234ejr.58.2021.10.08.16.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 16:50:23 -0700 (PDT)
Date:   Sat, 9 Oct 2021 01:50:21 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net PATCH 1/2] drivers: net: phy: at803x: fix resume for
 QCA8327 phy
Message-ID: <YWDZPfWOe+C2abWz@Ansuel-xps.localdomain>
References: <20211008233426.1088-1-ansuelsmth@gmail.com>
 <20211008164750.4007f2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008164750.4007f2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 04:47:50PM -0700, Jakub Kicinski wrote:
> On Sat,  9 Oct 2021 01:34:25 +0200 Ansuel Smith wrote:
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
> > Fixes: 15b9df4ece17 ("net: phy: at803x: add resume/suspend function to qca83xx phy")
> 
> Hm, there's some confusion here. This commit does not exist in net,
> and neither does the one from patch 2.
> 
> We should be fine with these going into net-next, right Andrew?

Took the hash from linux-next. Think this is the reason they are not in
net?

--
	Ansuel
