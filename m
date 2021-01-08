Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79632EF39E
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 15:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbhAHODA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 09:03:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:42844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbhAHOC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 09:02:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 360C523A00;
        Fri,  8 Jan 2021 14:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610114539;
        bh=boSholyu6yw+m5FPSR6Y0IZo0VRcvZXO4/sn0BuGLLU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kskhh9mKLB8IxiYT2qlpPUH4QFaFLtBE34+cFwBxgPBKo8bH9CMaMSjxGNyUFRl8t
         nA/nmG2oU6PEfWxuwt8QAcFkDXz7oh25wlqdgvJamyrMNcqCQJEmQOIit5TNRZtlTu
         Km72/6vKHMPI6Mx3oRI7nVIPVBIxqXRZiSnn3Uyg8QYS0I1rf7MkCScfPLlV7LppJM
         20/y6UhxaQIPB/ZCJWuqhFaAvJ1Jy8bfG98V8xc3gpgfoRjO1/DPJfLtjXazVtmtgx
         XvAZYXKH40b+B5OT43nhna5A+hYDCFMmk4NdpTFcdGDBXYsryggXAJnjn7xw8SF9mF
         raWEzDTBFac4Q==
Date:   Fri, 8 Jan 2021 15:02:14 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [net-next PATCH v13 4/4] net: dsa: mv88e6xxx: Add support for
 mv88e6393x family of Marvell
Message-ID: <20210108150214.3f821204@kernel.org>
In-Reply-To: <0044dda2a5d1d03494ff753ee14ed4268f653e9c.1610071984.git.pavana.sharma@digi.com>
References: <cover.1610071984.git.pavana.sharma@digi.com>
        <0044dda2a5d1d03494ff753ee14ed4268f653e9c.1610071984.git.pavana.sharma@digi.com>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Jan 2021 19:50:56 +1000
Pavana Sharma <pavana.sharma@digi.com> wrote:

> +int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
> +		    bool on)
> +{
> +	u8 cmode;
> +
> +	if (port != 0 && port != 9 && port != 10)
> +		return -EOPNOTSUPP;
> +
> +	cmode = chip->ports[port].cmode;
> +
> +	mv88e6393x_serdes_port_config(chip, lane, on);
> +
> +	switch (cmode) {
> +	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
> +	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
> +		return mv88e6390_serdes_power_sgmii(chip, lane, on);
> +	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
> +		return mv88e6390_serdes_power_10g(chip, lane, on);

Shoudln't mv88e6390_serdes_power_10g() be called even for 5GBASER ?
Have you tested 5GBASER at all?

Marek
