Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 581E47CE28
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbfGaUXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:23:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35051 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfGaUXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 16:23:46 -0400
Received: by mail-pf1-f194.google.com with SMTP id u14so32514440pfn.2;
        Wed, 31 Jul 2019 13:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jg6LpuBlwiakTWn00cF7QTchO6WVnUEalrcWh+rhFhQ=;
        b=NetebDi8LWfmYil4wII+z77FnbFXJrjJqOfJE4yfRYhEVtTZLt0dex72fQtD/WEivo
         /cFJJLveBYmqagG7fk1H4+lHfg/LtNxk7WkoxkBuV4gmVerwWMAyUcLKbQBX+G2CYtjX
         Jjk9ChdMFfdGYK/808Bqq9CtgLiB2k7ZLAfYZse6R+Lqnk5J4XX1LGdiIEhNflC1nHQi
         4Iwyle5nvbsRHP6DEii6yd3f3BCQmkkoZLrc4Jo3PJbHrZLSO67TMHPDl5QeMHBijXwM
         D7PJZaL60jhLYBx325ryS5L8KKWdN+zuXjZCgGtjCxhFFdU5VlqxmK7kE55ourydCBAL
         ZBvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=jg6LpuBlwiakTWn00cF7QTchO6WVnUEalrcWh+rhFhQ=;
        b=enSHLAUkPs2uiPXbaxrWhaLRn16L0K2Iw0gblwa5zIB7pTrLKJLd6RKFwMOahn8VsT
         ul/gViLZHhU7dmIalpuj+hPw+wnnlHGKBRITvf6yIVeue5LZls+HAUy7yL/lPvRXMA5z
         JG/BxqHqaO/FreJLZCgOcUizlVxlmxaEEi9qNSZ2LfWykzEzHUPPvFZTpi3WZoatiGeD
         CtsKxntVzORiTqibEzg/El3elsX7RDKAfWGmMCom6JDiMVltL9N4OVBBCPmlrWqDy+Qi
         mLobhPuuu+cK+mxRc08COBN+j7b/bawIL9m038KZ6YA+nc5k/Is8nclSh/kYbINamT95
         wqaA==
X-Gm-Message-State: APjAAAX+DorHvLR2IKijPCFCiFV5IctCvi+5kB8KTnhcADGUZO+0oVDE
        9/e+SKFq0te2jmWJB+//X6U=
X-Google-Smtp-Source: APXvYqxFP/F/KABOC41QDxnZEEDUlVlMeFDkQJOJGDPiDWt7Gv7V95ma+jPFVW4RjNICCcKISset4w==
X-Received: by 2002:aa7:8e10:: with SMTP id c16mr48041020pfr.124.1564604625848;
        Wed, 31 Jul 2019 13:23:45 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g2sm112378919pfq.88.2019.07.31.13.23.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 13:23:44 -0700 (PDT)
Date:   Wed, 31 Jul 2019 13:23:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/14] watchdog: pnx4008_wdt: allow compile-testing
Message-ID: <20190731202343.GA14817@roeck-us.net>
References: <20190731195713.3150463-1-arnd@arndb.de>
 <20190731195713.3150463-4-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731195713.3150463-4-arnd@arndb.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 09:56:45PM +0200, Arnd Bergmann wrote:
> The only thing that prevents building this driver on other
> platforms is the mach/hardware.h include, which is not actually
> used here at all, so remove the line and allow CONFIG_COMPILE_TEST.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

What is the plan for this patch ? Push through watchdog
or through your branch ?

Thanks,
Guenter
