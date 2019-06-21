Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46DC44ED65
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 18:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfFUQtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 12:49:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47820 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbfFUQtv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 12:49:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=P71o6R9PwKrxfUlkCzThaAEbYlO5haANQ4Qx+hoNZ6s=; b=vkm8kqtoslv3JIikaTIBorlbNH
        s88aHYfIZiSu8Iii2S8nQ6MYb1TCC1gZzo2J9oJ+pcto5nZNRyAlbFNKPNqXuNMX4uS+ZLqNRJNUx
        Pw48ymqe6jF+YDuGxPHtBN6EDChwUDieXpmGsG1Epj6zOsfoE4hAABWRKgxb5GFI8WgI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1heMjM-0007Ft-HQ; Fri, 21 Jun 2019 18:49:40 +0200
Date:   Fri, 21 Jun 2019 18:49:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, alexandru.marginean@nxp.com,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 4/6] arm64: dts: fsl: ls1028a: Add Felix switch
 port DT node
Message-ID: <20190621164940.GL31306@lunn.ch>
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
 <1561131532-14860-5-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561131532-14860-5-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 06:38:50PM +0300, Claudiu Manoil wrote:
> The switch device features 6 ports, 4 with external links
> and 2 internally facing to the ls1028a SoC and connected via
> fixed links to 2 internal enetc ethernet controller ports.

Hi Claudiu

> +			switch@0,5 {
> +				compatible = "mscc,felix-switch";
> +				reg = <0x000500 0 0 0 0>;
> +
> +				ethernet-ports {
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +
> +					/* external ports */
> +					switch_port0: port@0 {
> +						reg = <0>;
> +					};
> +					switch_port1: port@1 {
> +						reg = <1>;
> +					};
> +					switch_port2: port@2 {
> +						reg = <2>;
> +					};
> +					switch_port3: port@3 {
> +						reg = <3>;
> +					};
> +					/* internal to-cpu ports */
> +					port@4 {
> +						reg = <4>;
> +						fixed-link {
> +							speed = <1000>;
> +							full-duplex;
> +						};
> +					};
> +					port@5 {
> +						reg = <5>;
> +						fixed-link {
> +							speed = <1000>;
> +							full-duplex;
> +						};
> +					};
> +				};
> +			};

This sounds like a DSA setup, where you have SoC ports connected to
the switch. With DSA, the CPU ports of the switch are special. We
don't create netdev's for them, the binding explicitly list which SoC
interface they are bound to, etc.

What model are you using here? I'm just trying to understand the setup
to ensure it is consistent with the swichdev model.

   Thanks
	Andrew

