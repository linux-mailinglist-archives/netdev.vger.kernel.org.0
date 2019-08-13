Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D961C8C24E
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 22:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfHMUqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 16:46:40 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34350 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfHMUqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 16:46:40 -0400
Received: by mail-pf1-f196.google.com with SMTP id b24so1761244pfp.1
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 13:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lS7QbCBfWDAKJJ9AaXuhhnNJr4mtIGuJ160cegSICyM=;
        b=XbX84biYjSyDgS6LxVzDQYkOcojz78WOlfZYnpj3lki92gGfubayTt/V04/ES1ESh4
         5uieAy8/ybLD3n3wn8crXsm7826/o7NSknPmLlhmX9p+0FMDH8FnH3gjqF/T9l3XIcLo
         XMWSGcF8jlWJ05xs7S21a08YMT1zxM1DYaoSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lS7QbCBfWDAKJJ9AaXuhhnNJr4mtIGuJ160cegSICyM=;
        b=QvPuIOlYrCMisdaJjhgMBrKxIKH71NlZUVyLkBIwkBjhIdtpxWe0D8AcY7xSJq00qB
         9RoVIckhA0MWtfcXZi8z48BoO4oDnEEbMI1uPAZplx26Awknzm6GU09a1baKDTjiTYNo
         8dfS5fN/30ou6qpSfl9ZqWwcL+KLx8JhDDh0/U7SiYFrDRzCU8F6UlFd3nYShiTkGJbk
         dRMva94ddQgLN6sMXc64qjdp151cLp6/KX+eQnVo/IpY96GdL7Zie5JrQs194jUu7rWl
         ZLsIGEsYsWeof8+/z0pR5CUIAb7XwdLZRj75T2IRFFeESkx/XICK1TJ/EK2pVUBoL6O3
         zhrA==
X-Gm-Message-State: APjAAAVKmLOIy5z+5e1TB3yeBV1aat4oJJDOFIyVVMFWxCcSXAqibD1x
        iCe1UbpK5aL6I+EuGqrDqx4iCw==
X-Google-Smtp-Source: APXvYqyZj8SFNh8W8z2W8pR3iGEVcZWS7eycNEWabRA94Sd257PTZI0RRr7/3l/UmxBxc/RfktxIOg==
X-Received: by 2002:a62:38d7:: with SMTP id f206mr18947803pfa.102.1565729199815;
        Tue, 13 Aug 2019 13:46:39 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id e188sm70041869pfa.76.2019.08.13.13.46.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 13:46:38 -0700 (PDT)
Date:   Tue, 13 Aug 2019 13:46:34 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v6 4/4] net: phy: realtek: Add LED configuration support
 for RTL8211E
Message-ID: <20190813204634.GR250418@google.com>
References: <20190813191147.19936-1-mka@chromium.org>
 <20190813191147.19936-5-mka@chromium.org>
 <20190813201411.GL15047@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190813201411.GL15047@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 10:14:11PM +0200, Andrew Lunn wrote:
> > +static int rtl8211e_config_led(struct phy_device *phydev, int led,
> > +			       struct phy_led_config *cfg)
> > +{
> > +	u16 lacr_bits = 0, lcr_bits = 0;
> > +	int oldpage, ret;
> > +
> 
> You should probably check that led is 0 or 1. 

Actually this PHY has up to 3 LEDs, but yes, good point to validate
the parameter. I'll wait a day or two for if there is other feedback
and send a new version with the check.

> Otherwise this looks good.

Thanks for the reviews!

Matthias
