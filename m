Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA13D3B5ED3
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 15:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbhF1NZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 09:25:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60010 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232507AbhF1NZn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 09:25:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bSkz8XGnJiW02FSnzZBKRHgloSBrP+z/kUoQN/yD/1c=; b=heB0EHmd6jCJFYtVHHcYbvVs+G
        00K7hRR8R5gOk384kxzFQSc6CwwpHYBWJ1sNsbe64HS0NulfZrZfXrvH+HsOPhasV9RtfZ8Ipeb3Z
        fd1xN/RaE4EMijA7ns1vLkGFkTku5s0NYjLWV6lUZ9QckqceYbfvneYTNZYdAj45tbng=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lxrE6-00BQnQ-Jf; Mon, 28 Jun 2021 15:23:02 +0200
Date:   Mon, 28 Jun 2021 15:23:02 +0200
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
Message-ID: <YNnNNkjOiH6hd2l9@lunn.ch>
References: <YNH7vS9FgvEhz2fZ@lunn.ch>
 <20210623133704.334a84df@ktm>
 <YNOTKl7ZKk8vhcMR@lunn.ch>
 <20210624125304.36636a44@ktm>
 <YNSJyf5vN4YuTUGb@lunn.ch>
 <20210624163542.5b6d87ee@ktm>
 <YNSuvJsD0HSSshOJ@lunn.ch>
 <20210625115935.132922ff@ktm>
 <YNXq1bp7XH8jRyx0@lunn.ch>
 <20210628140526.7417fbf2@ktm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628140526.7417fbf2@ktm>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The best I could get would be:
> 
> &eth_switch {
> 	compatible = "imx,mtip-l2switch";
> 	reg = <0x800f8000 0x400>, <0x800fC000 0x4000>;
> 
> 	interrupts = <100>;
> 	status = "okay";
> 
> 	ethernet-ports {
> 		port1@1 {
> 			reg = <1>;
> 			label = "eth0";
> 			phys = <&mac0 0>;
> 		};
> 
> 		port2@2 {
> 			reg = <2>;
> 			label = "eth1";
> 			phys = <&mac1 1>;
> 		};
> 	};
> };
> 
> Which would abuse the "phys" properties usages - as 'mac[01]' are
> referring to ethernet controllers.

This is not how a dedicated driver would have its binding. We should
not establish this as ABI.

So, sorry, but no.

    Andrew
