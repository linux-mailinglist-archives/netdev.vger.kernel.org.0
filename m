Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA6FFB5738
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 22:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbfIQUzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 16:55:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51574 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730060AbfIQUzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 16:55:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DfgkSXCn0GvEU9c/sjr/hYgZcienAczlPKwmPtT03fQ=; b=hyYOHDjRgK3+3iopYCkiidqhHO
        6y2Y2eWtv2y0xzAcxxfmz2QsM4KA6TKlJRzuxgOsC73INNl0HpWjwVmTE/gbUE698coAd9JJ1egJc
        RxMbtuv+L/zKNM1SRy/H6NqpK0K8PoiunhGDRkHTRkKqKDN/2s4Cf+fS6ga3T+BfycjA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iAKV7-0003mh-GK; Tue, 17 Sep 2019 22:55:05 +0200
Date:   Tue, 17 Sep 2019 22:55:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Iwan R Timmer <irtimmer@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add support for port
 mirroring
Message-ID: <20190917205505.GF9591@lunn.ch>
References: <20190917202301.GA29966@i5wan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917202301.GA29966@i5wan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 10:23:01PM +0200, Iwan R Timmer wrote:
> Add support for configuring port mirroring through the cls_matchall
> classifier. We do a full ingress and/or egress capture towards the
> capture port, configured with set_egress_port.

Hi Iwan

This looks good as far as it goes.

Have you tried adding/deleting multiple port mirrors? Do we need to
limit how many are added. A quick look at the datasheet, you can
define one egress mirror port and one ingress mirror port. I think you
can have multiple ports mirroring ingress to that one ingress mirror
port. And you can have multiple port mirroring egress to the one
egress mirror port. We should add code to check this, and return
-EBUSY if the existing configuration prevents a new mirror being
configured.

Thanks
	Andrew
