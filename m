Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0273274FD4
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390050AbfGYNmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:42:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37230 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390008AbfGYNmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 09:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FRNh0wyTll51oisS0SnbVxCH0zgOEhtHJm/E9K985lY=; b=aPB87YVNjmJlG+Z5bYRBRHM1Pk
        zWUYXjGbkiLCE++8uAOvtSNCBdvX0QWvo6N3T8ToTcESYuSfDK/JzYKDtgv/aRdj1/L2wQFMtfa3X
        ao9Xly3j7oYZMRiHbdO0xgJYm6IIUOllt/8QKaRg2QRDpoGS3UDGheNFNyoAcVuE/C6E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqe0X-0006Dy-OX; Thu, 25 Jul 2019 15:42:09 +0200
Date:   Thu, 25 Jul 2019 15:42:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: Check existence of .port_mdb_add callback
 before calling it
Message-ID: <20190725134209.GE21952@lunn.ch>
References: <20190724034702.21212-1-wens@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724034702.21212-1-wens@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 11:47:02AM +0800, Chen-Yu Tsai wrote:
> From: Chen-Yu Tsai <wens@csie.org>
> 
> With the recent addition of commit 75dad2520fc3 ("net: dsa: b53: Disable
> all ports on setup"), users of b53 (BCM53125 on Lamobo R1 in my case)
> are forced to use the dsa subsystem to enable the switch, instead of
> having it in the default transparent "forward-to-all" mode.

Hi Chen-Yu

I would do the check earlier, at the beginning of
dsa_switch_mdb_add(). It is then similar to dsa_switch_mdb_del().

	      Andrew
