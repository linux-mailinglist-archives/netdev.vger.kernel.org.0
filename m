Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD217233603
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 17:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbgG3PuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 11:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3PuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 11:50:09 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9604EC061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 08:50:09 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id o1so14534139plk.1
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 08:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7c+YBSQ4Ugv690xaD0MPsrElB1Bf2PgeKqA5lmeDFmQ=;
        b=J+G1qk/WO+OiU8QVVjrTsaKOLMEk77JroFonEXTlQgXR/IKeVJtj2KcpbQcAYr7Cuv
         H1uD4f/18ZD5FbimHx6sqWBC4medvctHUiYwKN7aCj0RlhmIFFXrWm/yjWNWdAmoffaL
         087WokELo9d8N6hPUrkHUc31MU1UbxxjVQvTUvR9VO/vW6sEwgdT3Tjhc0BFs5kZYBeP
         H3P3EIhSzF9dyDBu6QYt1m/4ttX1zPd1wgTksEie735z7QrB+fMdZ6M+7tzSAEw7ePfC
         iaWn7Grizk7f41yoJpZj94TTx1LaKPQsCdddwaf1Ft/XciAYMRFOncfGgPvk17dsZzBo
         Qe9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7c+YBSQ4Ugv690xaD0MPsrElB1Bf2PgeKqA5lmeDFmQ=;
        b=Dz7tu+Qi/myvA7zQgqVYYswVKmJcAGQFKOzIlf9SviEPGsWq+s54VQSq4ZgVSVZK5R
         jTd57ZcaBSUK4218h2B4IY1hd7Gmhsv61IiO6evurd2K/p2z8RB7lBe0Hw7J+rbtuTzD
         /XLdknVVJhL6QXrIvSG7MtsXjxILD60ZGKklsTFGROOBOs36rYbXRFdIr1HUKfH4uOML
         YmAAc6Q1xZahMvy9/qyfM6giBHVzJnw41kO8XWDHVsAjN6TqMkBG0XlPKG6YH+iZoVuM
         I8AWKKXFhGW189E5EB+U/rCvazmJsavS5gqBcW3kKAG2lMX9BmW6xiZ2Gi+nGoaqT3ug
         sdMQ==
X-Gm-Message-State: AOAM533k8oM1jF2jyM5o7/rx38P7WRsQSA+Fie+jC03KRWRa59SZYsFE
        AaC6Dw7CpxOiv8RhRxfwO939sUOP
X-Google-Smtp-Source: ABdhPJxNsmMp+LD1M/TGjg8ObeqL+lQ89pm7htF+xFHNJcx0eEWCqwnEMt+xiMjR/S63C2DJXuTbJA==
X-Received: by 2002:a17:90b:808:: with SMTP id bk8mr3591976pjb.63.1596124209194;
        Thu, 30 Jul 2020 08:50:09 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id x23sm6352380pfi.60.2020.07.30.08.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 08:50:08 -0700 (PDT)
Date:   Thu, 30 Jul 2020 08:50:06 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20200730155006.GA28298@hoboy>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200729105807.GZ1551@shell.armlinux.org.uk>
 <20200729131932.GA23222@hoboy>
 <20200730110613.GC1551@shell.armlinux.org.uk>
 <20200730115419.GX1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730115419.GX1605@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 12:54:19PM +0100, Russell King - ARM Linux admin wrote:
> So, something in the IPv4 layer on ARM64 is silently discarding
> multicast UDP PTP packets, and I've no idea what... and I'm coming to
> the conclusion that this is all way too much effort and way too
> unreliable to be worth spending any more time trying to make work.

I've also seen this on the Marvell switch.  I'm not sure if the root
cause is in the Linux stack or in the mcast forwarding logic in the
switch.  Using the Marvell, I can make a layer2 TC or a UDPv4 BC, but
not a UDPv4 TC.

I haven't had time to dig deeper, and I think many people are happy
with a layer2 TC as that is called out in the TSN world.

Thanks,
Richard
