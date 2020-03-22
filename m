Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0715A18EC22
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 21:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgCVUX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 16:23:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50746 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgCVUX4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 16:23:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Y1E2ofj9UBjZicuoiVM7MKb+d/EIWm4bm2+rPrDxTzU=; b=OSXrgMzmOHr93LXcev85S0IwsI
        sewIA7jqbhLXVxGmor+kNr4u3ul2kB+KAsEXH4EQwH0fjC712N/N6HCoLWrTf0n+MmVnxCuGrM5r0
        D+zfZifwP1gpWsaLyV7+0Hh+YVGEu43URgCdfFjOzzFDVo/EVUj03pp+n5GqzGfvY0J0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jG78R-0002L5-Rz; Sun, 22 Mar 2020 21:23:51 +0100
Date:   Sun, 22 Mar 2020 21:23:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethtool: fix reference leak in some *_SET handlers
Message-ID: <20200322202351.GE3819@lunn.ch>
References: <20200322201551.E11BAE0FD3@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322201551.E11BAE0FD3@unicorn.suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 09:15:51PM +0100, Michal Kubecek wrote:
> Andrew noticed that some handlers for *_SET commands leak a netdev
> reference if required ethtool_ops callbacks do not exist. A simple
> reproducer would be e.g.
> 
>   ip link add veth1 type veth peer name veth2
>   ethtool -s veth1 wol g
>   ip link del veth1
> 
> Make sure dev_put() is called when ethtool_ops check fails.
> 
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
