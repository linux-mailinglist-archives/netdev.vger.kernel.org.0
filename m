Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B20D1AF47E
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 22:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgDRUJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 16:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727927AbgDRUJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 16:09:52 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7EFC061A0C;
        Sat, 18 Apr 2020 13:09:52 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5469423061;
        Sat, 18 Apr 2020 22:09:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587240589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lwbpohXkgA8LBRIp0lZ4q/XzjtDAPv3LIIeZKlx0qvo=;
        b=D10MxJEUiC26rbD4lax+8UpzBji3cbsEhy6svKSmVTYs/aTYhWTaMNM79dEclTETomSKbS
        4+Aa6fjWCkGhSbX24oo7qi9QGEyH3qgS+j1X9uOO6V4z/havW82dBC9vCFm8qniqhdyltm
        vQHjJZkaRmNlylWtjnzbpTGTZLs7UbU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 18 Apr 2020 22:09:48 +0200
From:   Michael Walle <michael@walle.cc>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/3] net: phy: broadcom: add helper to write/read
 RDB registers
In-Reply-To: <aa126ad1-ae29-3da6-bd50-2c0444cfd691@gmail.com>
References: <20200417192858.6997-1-michael@walle.cc>
 <20200418141348.GA804711@lunn.ch>
 <aa126ad1-ae29-3da6-bd50-2c0444cfd691@gmail.com>
Message-ID: <f264bcad85571a44fabf33fe7e13664e@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 5469423061
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[10];
         NEURAL_HAM(-0.00)[-0.968];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[lunn.ch,vger.kernel.org,suse.com,roeck-us.net,gmail.com,armlinux.org.uk,davemloft.net];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-04-18 17:55, schrieb Florian Fainelli:
> On 4/18/2020 7:13 AM, Andrew Lunn wrote:
>> On Fri, Apr 17, 2020 at 09:28:56PM +0200, Michael Walle wrote:
>>> RDB regsiters are used on newer Broadcom PHYs. Add helper to read, 
>>> write
>>> and modify these registers.
>> 
>> It would be nice to give a hint what RDB means?
> 
> It means Register Data Base, it is meant to be a linear register
> offset as opposed to the more convulated shadow 18, 1c or other
> expansion registers.

Oh I just found some comment to another linux patch explaining this.
Because there is no trace what RDB actually means in the datasheets
from Broadcom I've seen so far.

-michael
