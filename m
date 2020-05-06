Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8281C6E28
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 12:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgEFKPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 06:15:06 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:58645 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgEFKPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 06:15:06 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E833922EDE;
        Wed,  6 May 2020 12:15:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588760104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nAAw+xDlfmFE1PfS+rEU4ez9NFhnFnvHiViZ3xvNAjw=;
        b=EqiyYX8rMFKm4ilqILTgN1nc1EwQkfTsMRvUtxdbWGDMPV//E1lru0wM/ukjLURl1X48OP
        suuwpvyMemfPmvR3qgZJnnwXlzuKxxEmGxXjSBH8fRm8/1qJXxxp/olDPtcEQEmsriMABz
        MQang03KtcdxXv6b0rpAvfz54QJGy4A=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 06 May 2020 12:15:01 +0200
From:   Michael Walle <michael@walle.cc>
To:     Matthias May <matthias.may@neratec.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC net-next] net: phy: at803x: add cable diagnostics support
In-Reply-To: <00e8202e-1786-27f4-3bfc-accc5a01787d@neratec.com>
References: <20200503181517.4538-1-michael@walle.cc>
 <00e8202e-1786-27f4-3bfc-accc5a01787d@neratec.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <c09c5c851e64f374fe9f7f575113f432@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-05-06 11:01, schrieb Matthias May:
> I've worked with this PHY quite often and we've hacked together some
> support for the CDT in uboot.
> 
> Have you done any tests with the cable on the other side being plugged 
> in?

yes

> 
> With the cable being plugged in, we something (1 out of 10 or so)
> observed that the test returns with a failure.
> --> AT803X_CDT_STATUS_STAT_FAIL in AT803X_CDT_STATUS
> 
> Often you get the correct result if you simply try again. Sometimes
> however it gets into a "stuck" state where it just
> returns FAIL for ~3~10 seconds. After some that it seems to recover
> and gets the correct result again.

its actually pretty stable for the following sequence (see also code
above):

restart AN -> wait 1.5s -> start test

Only thing I've noticed is that if you perform the test without
waiting for the AN to complete beforehand there might be some
failed states. Seems like the "restart an" doesn't work while
AN is still running. But that seems to be the link partner
who disturbs the measurement.
And it seems that AN is a requirement to do successful testing
(or to silence the link partner I guess).

-michael
