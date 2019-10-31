Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D92EEB5E9
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbfJaROT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:14:19 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:56589 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728547AbfJaROT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 13:14:19 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7B49622EE3;
        Thu, 31 Oct 2019 18:14:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572542056;
        bh=H+8psUup3ZCDa9zLbaL2GibnjLdJl/ZYLNn90edDLYo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EagMqH3WE92hn7Nn173jsO1ZzBo0UCnH8fjglgONoeTflWtmWz/SIStEYP/EOodtA
         keflHhOOzIIxga3jfQPyIwWk3H5m0wX+rDbpcp0PJuqtdXDzLUHUPvNHvFVrRauzv9
         PYi7RsbsJ897hu8dpHWzpV9mZzxy7gbnIQewzqig=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 31 Oct 2019 18:14:16 +0100
From:   Michael Walle <michael@walle.cc>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] dt-bindings: net: phy: Add support for AT803X
In-Reply-To: <b2c1988e-ffa7-ca13-081f-3d7f18c31233@gmail.com>
References: <20191030224251.21578-1-michael@walle.cc>
 <20191030224251.21578-3-michael@walle.cc> <20191030231706.GG10555@lunn.ch>
 <9C1BD4CD-DB02-40CA-940E-3F5579BAE5F4@walle.cc>
 <b2c1988e-ffa7-ca13-081f-3d7f18c31233@gmail.com>
Message-ID: <d68a8bef6f7d5193e7d373311c8045d7@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.2.3
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2019-10-31 17:45, schrieb Florian Fainelli:
> On 10/30/19 5:14 PM, Michael Walle wrote:
>>> So we can later add atheros,rgmii-io-2v5. That might need a regulator
>>> as well. Maybe add that 2.5V is currently not supported.
>> 
>> There is no special setting for the 2.5V mode. This is how it works: 
>> there is one voltage pad for the RGMII interface. Either you connect 
>> this pad to a 2.5V voltage or you leave it open (well you would 
>> connect some decoupling Cs). If you leave it open the internal LDO, 
>> which seems to be enabled in any case takes over, supplying 1.5V. then 
>> there is a bit in the debug register which can switch the internal LDO 
>> to 1.8V. So if you'll use 2.5V the bit is irrelevant.
>> 
>> Like I said maybe a "rgmii-io-microvolts" is a better property and 
>> only in the 1800000 setting would turn on this bit. but then both 
>> other setting would be a noop.
> 
> That would align with the regulator subsystem units, but maybe you
> should have the PHY driver be a regulator provider for itself so you 
> can
> chose wether you want to operate at 1.5V or 1.8V, or you have an
> external regulator providing I/O supplies. That would make the whole
> thing consistent from the driver's perspective and would not 
> necessarily
> be too far fetched from a HW description perspective?

Sounds good. But again, I'm not too familiar with that. Could you give 
an
example how the device tree would look like then? Maybe that way I can 
work
myself through that regulator stuff.

-- 
michael
