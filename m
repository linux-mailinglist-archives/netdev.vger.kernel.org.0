Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509BC11F699
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 07:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfLOFvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 00:51:55 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42957 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfLOFvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 00:51:55 -0500
Received: by mail-pf1-f196.google.com with SMTP id 4so3775116pfz.9
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 21:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NNALDx0ZF9X5qoKVt34907rnOqErCEuqEOwJBS1O1Os=;
        b=CgxHaYxdFdUpLcVJ+Jp0XvvuPb2DRHNt0+Kv3kcto86Oo9Xo6Cq49fLIIyQ9uSDOyx
         3dn9mhwzL3G6V+RxxVzmlHuZCxiWQUnZ2f4/mhOaMmxbDpkXMw1+HewI4an2joS1w74C
         T45CnKFyXz4gYaLvm0MFrmCzQo2CnHS97zk//x7aa1j2uhRP63WQcadTrQbzPBssFzDm
         nVfD4S9zd1CsigmTGMIdq8sAvg+AjNfMDeM4PQzErcO6PSLjmbEDGgUIm35wWwD6gzr4
         KCH9HYQ4v+AW7XJyCggBFuB4d62lVQSGkWjZ6y6FSUuVbMw8Y/8FnsLypBwo755tHEyT
         ukGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NNALDx0ZF9X5qoKVt34907rnOqErCEuqEOwJBS1O1Os=;
        b=BLlz2ctp2l/vl50SYe0RaQ086BGtDaaCszfrRczrFN2Jmk7gAUlDeEIwgFlwjaEhyz
         Gt99/7yetePY7ADTYqg8eiSFNZsR518sa6CPMSzxoAt8plNszjpOptcLB47/nPVOcSIa
         d+dTFAONvWHd1c9KzuzTLeEIqIXTsX3Mgzm/hBolDt3bNLAU7Br7TLEbdI+a9+AVsBth
         9vIJoovyt/iRNuudgd+a6FXv/cDBwn7vSrS1Nrs1sWHgIikDkKHMhdaRyotWv+NixSMG
         iv9+cdfny9mx2RTToS5TxGWFeXatCAYZhvdlZQKMMZIwCE+1X0MdAZiC2gi6rMUb3ZFW
         GIyQ==
X-Gm-Message-State: APjAAAWT2isSbrWMYn8o4tKmx9q18yxZyTCXQQ2PAwgieeE2LVTjtbc4
        ZseuskQPcHHaNW8ZdzB6FC3ELg==
X-Google-Smtp-Source: APXvYqy+wR1tBXm/LOuzMh2eWkIHJIhGKle2BXIR24DS8q/yObL0nNmp5s+pEZ/db4JaPXtYCA3JIA==
X-Received: by 2002:a65:530d:: with SMTP id m13mr10329035pgq.351.1576389114988;
        Sat, 14 Dec 2019 21:51:54 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id p16sm16506684pgi.50.2019.12.14.21.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 21:51:54 -0800 (PST)
Date:   Sat, 14 Dec 2019 21:51:51 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: fix interface passed to mac_link_up
Message-ID: <20191214215151.69f0885e@cakuba.netronome.com>
In-Reply-To: <E1ifhqA-0000NQ-9y@rmk-PC.armlinux.org.uk>
References: <E1ifhqA-0000NQ-9y@rmk-PC.armlinux.org.uk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 10:06:30 +0000, Russell King wrote:
> A mismerge between the following two commits:
> 
> c678726305b9 ("net: phylink: ensure consistent phy interface mode")
> 27755ff88c0e ("net: phylink: Add phylink_mac_link_{up, down} wrapper functions")
> 
> resulted in the wrong interface being passed to the mac_link_up()
> function. Fix this up.
> 
> Fixes: b4b12b0d2f02 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied and queued for stable (5.3, 5.4). Thank you!
