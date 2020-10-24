Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216DF297CD4
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 16:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762028AbgJXOiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 10:38:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42840 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762019AbgJXOiH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Oct 2020 10:38:07 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kWKg8-003HXS-2m; Sat, 24 Oct 2020 16:37:56 +0200
Date:   Sat, 24 Oct 2020 16:37:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, mdf@kernel.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-fpga@vger.kernel.org, netdev@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, hao.wu@intel.com,
        Russ Weight <russell.h.weight@intel.com>
Subject: Re: [RFC PATCH 5/6] ethernet: dfl-eth-group: add DFL eth group
 private feature driver
Message-ID: <20201024143756.GI745568@lunn.ch>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-6-git-send-email-yilun.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603442745-13085-6-git-send-email-yilun.xu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +++ b/Documentation/ABI/testing/sysfs-class-net-dfl-eth-group
> @@ -0,0 +1,19 @@
> +What:		/sys/class/net/<iface>/tx_pause_frame_quanta
> +Date:		Oct 2020
> +KernelVersion:	5.11
> +Contact:	Xu Yilun <yilun.xu@intel.com>
> +Description:
> +		Read-Write. Value representing the tx pause quanta of Pause
> +		flow control frames to be sent to remote partner. Read the file
> +		for the actual tx pause quanta value. Write the file to set
> +		value of the tx pause quanta.
> +

Is this really configuring the quanta? My very limited understanding
is that the quanta is defined as 512 bit times. For this to work, you
are going to have to modify the quanta on both ends of the link,
otherwise increasing the quanta is actually going to shorten the pause
time.

> +What:		/sys/class/net/<iface>/tx_pause_frame_holdoff
> +Date:		Oct 2020
> +KernelVersion:	5.11
> +Contact:	Xu Yilun <yilun.xu@intel.com>
> +Description:
> +		Read-Write. Value representing the separation between 2
> +		consecutive XOFF flow control frames. Read the file for the
> +		actual separation value. Write the file to set value of the
> +		separation.

This is the wrong API for this. Please extend the ethtool -A|--pause
API. Now that it is netlink, adding extra attributes should be simple.

	Andrew
 
