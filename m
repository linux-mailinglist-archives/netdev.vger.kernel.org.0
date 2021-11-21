Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9C44585EE
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 19:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238732AbhKUShV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 13:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238727AbhKUShV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 13:37:21 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13F8C061574;
        Sun, 21 Nov 2021 10:34:15 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r25so29935510edq.7;
        Sun, 21 Nov 2021 10:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lxtYFOZht5ghtZeAl8CrzBMPOKet8ZplgLy4M8R06os=;
        b=ezsC3n00xwUb4lV47lFAMJ6wQu0AKDn6bxkeKwu+n4qefSVbPnBkiD5/GBT1Y+KTd1
         6p9QvePFK2m1+qrtmllGx3Z+j0/PSG8ZYk121y8+gD8ZkzG/TR84v1Uu/K6mclxCOxd2
         T/YzegY3KMjNEFfmurdOgePaVi6R0/ZwfL+75AG4HYyYGUtC0znjFrDC1NvqMkJDv94C
         RAwnjGffQ3sCiw29IvMM3Bh2Q6sHdFsCGGaUxoy/qrsD/+ualB9wBMQFMicunCAnVXok
         QuZOUi9UvJamx8/7TO+4iQ7xcAjvhZLCkwc5acxRGtoImJu7aiDjd2qyPMWXHLw2CTz1
         BzLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lxtYFOZht5ghtZeAl8CrzBMPOKet8ZplgLy4M8R06os=;
        b=BruiHRCerQvVLQdTzEshgTDkkKqk0w1nnxs1l+zUlIE5+XKDyGn2TPj8lPK1fAomQc
         eHqGbNvV8VSbcJ23lBPwYhSajT24L9xVVnCe/kpJNAaeh2XmLuP0uPGlQnJfELP7c9pg
         gE/wx3IR7ZrFNbfG9J8IR3NZv0AlR+4NhRzmJSy+tSQ7Cr898NP100njjkSTiWjlarjB
         364nA9eJTPQ/hwuG0HshUPT+5nxj2mCgA4qoq7MPPwqMi3mZ1nKOcwCENFY9gAzW1JvK
         wHBBQaNraoI3zV27EIFHrgaOXJKEsqNY6tJqUvIHVX5XUw15rADJmCx6i5YBigMVv+ZG
         01UQ==
X-Gm-Message-State: AOAM532CTjIBtJ7Mco8fcEZRrggVheqdiRPn6hvNu9tsl4/OiXhTmuSj
        SaR7hjrVvCWIirteje+QLIA=
X-Google-Smtp-Source: ABdhPJwoKe7gKcAy+JfuqRQc58LQbXrR2iG0I1mN8tmxohClHOjZtDDzlGMCBxW7jS4i5rlETHAFAw==
X-Received: by 2002:a17:906:b2d0:: with SMTP id cf16mr32372973ejb.52.1637519654324;
        Sun, 21 Nov 2021 10:34:14 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id z8sm3005018edb.5.2021.11.21.10.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 10:34:14 -0800 (PST)
Date:   Sun, 21 Nov 2021 20:34:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 05/19] net: dsa: qca8k: move read switch id
 function in qca8k_setup
Message-ID: <20211121183413.zjxs6yqbxq3a3a5h@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-6-ansuelsmth@gmail.com>
 <20211119010305.4atvwt6zn3dorq2p@skbuf>
 <6196f92e.1c69fb81.5e6a3.271b@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6196f92e.1c69fb81.5e6a3.271b@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 02:08:59AM +0100, Ansuel Smith wrote:
> On Fri, Nov 19, 2021 at 03:03:05AM +0200, Vladimir Oltean wrote:
> > On Wed, Nov 17, 2021 at 10:04:37PM +0100, Ansuel Smith wrote:
> > > Move read_switch_id function in qca8k_setup in preparation for regmap
> > > conversion. Sw probe should NOT contain function that depends on reading
> > > from switch regs.
> > 
> > It shouldn't? Why? We have plenty of switch drivers that use regmap in
> > the probe function.
> >
> 
> The initial idea was to make a shared probe function. (when the ipq40xx
> code will be proposed)
> Currently the regmap is init in the setup function so we can both 
> move the switch id to setup or move regmap to probe.
> What should be better in your opinion?

Either one is fine, but it seems a bit backwards to call
dsa_register_switch() only to find out later, during the ->setup()
callback, that you're in fact talking to a potato. So from that point of
view maybe you could keep the device id check in ->probe, and therefore
also move the regmap initialization there.
