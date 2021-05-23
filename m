Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D2C38DB6F
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 16:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhEWOkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 10:40:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53256 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231769AbhEWOkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 10:40:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iGMgZiKnpMmGI8GF/PlcxqdvzTENt4I1mUB7ce0c6SE=; b=my0KWHvNDYWbMe9ZBBqgUBfBMI
        z/qQLm2HrkAQDWHBISqXry59OzTZY+ep23G+xPWtptLHaLOb0MzkEJeCb0Wbt40Ie9EdfstazUZDL
        a95oYr8FO9c4j7F5d8H0/y52LwA1N0p6OSEd8Jc9RGXbATJKDB0Imo8jWblXugAqQP4o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lkpFd-005n4o-PU; Sun, 23 May 2021 16:38:45 +0200
Date:   Sun, 23 May 2021 16:38:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [RFC net-next 2/2] net: fec: add ndo_select_queue to fix TX
 bandwidth fluctuations
Message-ID: <YKpo9fs9lEqCOx9l@lunn.ch>
References: <20210523102019.29440-1-qiangqing.zhang@nxp.com>
 <20210523102019.29440-3-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210523102019.29440-3-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -76,6 +76,8 @@ static void fec_enet_itr_coal_init(struct net_device *ndev);
>  
>  #define DRIVER_NAME	"fec"
>  
> +static const u16 fec_enet_vlan_pri_to_queue[8] = {1, 1, 1, 1, 2, 2, 2, 2};

I wonder if priority 0 should be sent to queue 0?

  Andrew
