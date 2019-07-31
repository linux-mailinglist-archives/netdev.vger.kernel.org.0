Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B74247CEBB
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfGaUgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:36:49 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35339 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbfGaUgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 16:36:48 -0400
Received: by mail-pg1-f196.google.com with SMTP id s1so26339538pgr.2;
        Wed, 31 Jul 2019 13:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+3m34La6ccE3Dbo0nKkW6PAk5aFsT9gCe5QCc84QY/M=;
        b=EFmwE6xHJZlI7fbJj4ayQvxsXiguUUOE/YUP+QGUdsdsqzIBCNFzDXIfMHIIReAeq0
         YxhAhukgJsf9Zk6f6yV8s2LP8u0sSr3FNuF8EyxKSURPID2YZC8Lbo6cduEjaNrfdCwf
         DDLHx35Gdmi2wKQrsQFGdxEic/BLubYM2PdbA3n+K81Up9x+c+BTo+EUmFexA3wLK1m3
         HTdCvaEPFAiwwj9xS/aDlE76GEOL8mwW7ic1UhN2QVquK+WFAQH9I/3g+WFQQCGFh/i7
         YgzaMh2a0V/ot/+SNV3Vet++cuduT7j8egp6XJg1gKkL7jCKsSeeDqSN4CHI6M9V8jx9
         7pRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+3m34La6ccE3Dbo0nKkW6PAk5aFsT9gCe5QCc84QY/M=;
        b=FoQwXb2Gd4fRQC3kd1b2VQ1KEJks1rGHoyJPJtOl9fz5dT2smrp2je2LCVpDRx8oGp
         n3a8Th9bpxbdYV6upCl7M5vXT8bZJ0rG6uzqTG+bujq2tMVDzllKCApuC2M8lL4j2sUf
         xDj5cD2sN+6yVlsNjbESKoAxaY8M224KynxrVViQYUxRDtzzmzl6aJfRUetDGFPIjgB+
         d+SDev05KcL0hGvcMYlsidLr0Pwfg1Bmo6xaS5v59dyj+YRPmE+l+FPrPKNm7sR+hvyL
         kaTCIYHvDAyq/n3c+QvOxxWhqc3xZcfSi3mcpLaOXaEZVPcvlZVQTYjhwf0He0lg/2TS
         C12w==
X-Gm-Message-State: APjAAAUJHMxv/QuhNpH6cwqz9Ke2QpUrj8n7l5HFfn95ewOrgT/A4ilU
        VzqFPu6/IZY5O9PRfNfRjx0=
X-Google-Smtp-Source: APXvYqybC01d0TByWxoDrJxw7C9lUUE3ShsoXGzUiQlHPWLWfdxiLqpUEK75wQICNDQ0Ydie1eRIGg==
X-Received: by 2002:a63:e907:: with SMTP id i7mr113621516pgh.84.1564605407843;
        Wed, 31 Jul 2019 13:36:47 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h16sm77972581pfo.34.2019.07.31.13.36.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 13:36:47 -0700 (PDT)
Date:   Wed, 31 Jul 2019 13:36:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     soc@kernel.org, Linux ARM <linux-arm-kernel@lists.infradead.org>,
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
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-serial@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        LINUXWATCHDOG <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/14] watchdog: pnx4008_wdt: allow compile-testing
Message-ID: <20190731203646.GB14817@roeck-us.net>
References: <20190731195713.3150463-1-arnd@arndb.de>
 <20190731195713.3150463-4-arnd@arndb.de>
 <20190731202343.GA14817@roeck-us.net>
 <CAK8P3a2=gqeCMtdzdqg4d1n6v1-cdaHObeUoVXeB+=Okwd1rqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2=gqeCMtdzdqg4d1n6v1-cdaHObeUoVXeB+=Okwd1rqA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 10:26:35PM +0200, Arnd Bergmann wrote:
> On Wed, Jul 31, 2019 at 10:23 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > On Wed, Jul 31, 2019 at 09:56:45PM +0200, Arnd Bergmann wrote:
> > > The only thing that prevents building this driver on other
> > > platforms is the mach/hardware.h include, which is not actually
> > > used here at all, so remove the line and allow CONFIG_COMPILE_TEST.
> > >
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >
> > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> >
> > What is the plan for this patch ? Push through watchdog
> > or through your branch ?
> 
> I would prefer my branch so I can apply the final patch without waiting
> for another release. Not in a hurry though, so if some other maintainer

Ok with me.

Guenter
