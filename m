Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132E2425433
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241625AbhJGNiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbhJGNiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:38:00 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECE1C061570;
        Thu,  7 Oct 2021 06:36:06 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id i20so7529252edj.10;
        Thu, 07 Oct 2021 06:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LLTO3QrDjh/QVei5qfqmIzYzW1b3e+99yn9tgM5fLrc=;
        b=bxMowlq2UT1/oR4HsLCw6K5w9CcPlSi/h/WGxGr2gDTAtwspYCoPTdyE0Dv9ErbWBZ
         FTr/9B9AbfzZjZKy3+PzJ8g//6qFw8hLrFnKjX6brNikeRoc+mMP10nysOpYYb+x7ucB
         hx0dat2ervqH2ktxrU5oVS/WAJUGOb5FUkWFq6fqFMArAJ8oTPeq228/s/bmmjCIfWaO
         A23mqzZGI0CRtqH8E5ryE+1x5ktQTN8321EJTT3EtevVwtoqKUIV1hhtlTU/+2mtKS5f
         fU1yg0FdYbtibIzOhx6NuSpBYfZOsSlzT93ElYy7chivWaUZuGhG1TcyVAT4pk7EBQmg
         jSAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LLTO3QrDjh/QVei5qfqmIzYzW1b3e+99yn9tgM5fLrc=;
        b=32f6fqAGG6ee3YVzcMdZIqw9it6YmbFQMcOly6eqr2/hlRNAAN+Dp/K8nl2lsPNuxp
         Re4upqEh81zkE1G7rhPG3x9dn8bXy2wNMiPJLTkFN2bxMQrXpzFOpde9MUaG0wDgbURY
         1xu/zQLOc60ID00CJAGDvSzo9SsOol98B3vlg8H92UF2s1Kdu5RAgxFVj18dHG71q3r7
         XjSMIRDlfgpyx2lsNu9p4nx7PmQblGTsg19LP2W0qUQx/Hwb9aM/werF7YI8U4XIdVz1
         zANQvAdwR7NYIL0cqyzL7TcjuqQi1V5QIRPnXDlRlmZlo1rqJQnh/8zAQ6bi07SMHRkI
         yVOQ==
X-Gm-Message-State: AOAM531fVyTdjIitwlYnuNvgpjCxMncja1ujXcqoP26EqV7ZPzLpLLvd
        elPIMTk3H10U7X0UtQnFUYo=
X-Google-Smtp-Source: ABdhPJwgWK+sHihJd+oHvmODuqX5mfzQBJnoT5/PLI0rkcYNGtnWDFZ5zHDWQBTrlxttBOwRja9gag==
X-Received: by 2002:a50:d8c7:: with SMTP id y7mr6346322edj.133.1633613756590;
        Thu, 07 Oct 2021 06:35:56 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id z16sm1261825edb.16.2021.10.07.06.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 06:35:56 -0700 (PDT)
Date:   Thu, 7 Oct 2021 15:35:54 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 10/13] net: dsa: qca8k: add explicit SGMII PLL
 enable
Message-ID: <YV73umYovC0wh5hz@Ansuel-xps.localdomain>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-11-ansuelsmth@gmail.com>
 <YV4/ehy9aYJyozvy@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV4/ehy9aYJyozvy@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 02:29:46AM +0200, Andrew Lunn wrote:
> On Thu, Oct 07, 2021 at 12:36:00AM +0200, Ansuel Smith wrote:
> > Support enabling PLL on the SGMII CPU port. Some device require this
> > special configuration or no traffic is transmitted and the switch
> > doesn't work at all. A dedicated binding is added to the CPU node
> > port to apply the correct reg on mac config.
> 
> Why not just enable this all the time when the CPU port is in SGMII
> mode?

I don't know if you missed the cover letter with the reason. Sgmii PLL
is a mess. Some device needs it and some doesn't. With a wrong
configuration the result is not traffic. As it's all messy we decided to
set the PLL to be enabled with a dedicated binding and set it disabled
by default. We enouncer more device that require it disabled than device
that needs it enabled. (in the order of 70 that doesn't needed it and 2
that requires it enabled or port instability/no traffic/leds problem)

> 
> Is it also needed for 1000BaseX?
> 

We assume it really depends on the device.

> DT properties like this are hard to use. It would be better if the
> switch can decide for itself if it needs the PLL enabled.
> 

Again reason in the cover letter sgmii part. Some qca driver have some
logic based on switch revision. We tried that and it didn't work since
some device had no traffic with pll enabled (and with the revision set
to enable pll)

>        Andrew

-- 
	Ansuel
