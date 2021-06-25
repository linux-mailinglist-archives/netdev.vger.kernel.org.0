Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737F13B45F0
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 16:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhFYOnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 10:43:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55916 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231521AbhFYOnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 10:43:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=w4IQO6DFVyzsolvAWmphYfHy/rPQ4YAG/FamYX4clww=; b=aAf3o6P+jbEuvDCewlGhAv0jYi
        Zc2Sx7la0Q//AkKE293wyg0aHPhF9/9XBKoM9dwYLoMZggjZkrwhJmSejyann22FOYQMZcc+/arjS
        N2RR5RRYjrLbq0aTs5r+4flsIKxF7rNwDt7cJuR3TPQ1DTM62X1cZtrWif9Vf2BBpGT4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwn0H-00B79E-MB; Fri, 25 Jun 2021 16:40:21 +0200
Date:   Fri, 25 Jun 2021 16:40:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP
 L2 switch
Message-ID: <YNXq1bp7XH8jRyx0@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
 <20210622144111.19647-3-lukma@denx.de>
 <YNH7vS9FgvEhz2fZ@lunn.ch>
 <20210623133704.334a84df@ktm>
 <YNOTKl7ZKk8vhcMR@lunn.ch>
 <20210624125304.36636a44@ktm>
 <YNSJyf5vN4YuTUGb@lunn.ch>
 <20210624163542.5b6d87ee@ktm>
 <YNSuvJsD0HSSshOJ@lunn.ch>
 <20210625115935.132922ff@ktm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625115935.132922ff@ktm>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I do believe that I can just extend the L2 switch driver (fec_mtip.c
> file to be precise) to provide full blown L2 switch functionality
> without touching the legacy FEC more than in this patch set.
> 
> Would you consider applying this patch series then?

What is most important is the ABI. If something is merged now, we need
to ensure it does not block later refactoring to a clean new
driver. The DT binding is considered ABI. So the DT binding needs to
be like a traditional switchdev driver. Florian already pointed out,
you can use a binding very similar to DSA. ti,cpsw-switch.yaml is
another good example.

So before considering merging your changes, i would like to see a
usable binding.

I also don't remember seeing support for STP. Without that, your
network has broadcast storm problems when there are loops. So i would
like to see the code needed to put ports into blocking, listening,
learning, and forwarding states.

	  Andrew
