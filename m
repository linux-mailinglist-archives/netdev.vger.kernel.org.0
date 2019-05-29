Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060C82E8ED
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 01:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfE2XR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 19:17:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40334 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfE2XR6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 19:17:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G7uejEGBAh0QbGk28b9gjgJ+rca6oe85/O+g5QpWq8k=; b=rCy6o+CPgbZ0J2Z1wvyV4VZLHX
        Z/dqNUGxdWPUpjA5UCQ0nvT7pBmKLdQkxUSZn3mZYhp0V6Msc4SpJ6bATzUCzdSjNaNRsZ5tVIewV
        hvYSV5p1X4vfOrmuT71axIhbBcW5mGZbzPyD1vT4jaw4nisu0sf+awkGfzrNR+WsFIeI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hW7pR-0003AS-Rr; Thu, 30 May 2019 01:17:53 +0200
Date:   Thu, 30 May 2019 01:17:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     linux@armlinux.org.uk, f.fainelli@gmail.com, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com, olteanv@gmail.com,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: Add error path handling in
 dsa_tree_setup()
Message-ID: <20190529231753.GE18059@lunn.ch>
References: <1559167943-26631-1-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559167943-26631-1-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -423,18 +434,41 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
>  
>  		err = dsa_switch_setup(ds);
>  		if (err)
> -			return err;
> +			goto setup_switch_err;

Minor nit pick.

All the other labels you add are err_*. This one is *_err.  A quick
look at dsa2.c, there is one label already in the file

out_put_node:

which has no prefix or postfix.

So maybe drop err_ and _err ?

   Andrew
