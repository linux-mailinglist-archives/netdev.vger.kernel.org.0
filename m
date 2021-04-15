Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C67436157C
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbhDOW2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbhDOW2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 18:28:17 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EC9C061574;
        Thu, 15 Apr 2021 15:27:53 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 53E4A2224D;
        Fri, 16 Apr 2021 00:27:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1618525668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4EpAThp1KbLIOtaa6ziaIprjD37b45cKEYo+IUj/xDc=;
        b=RADHosZmWWj2QD7mjS4sz9BVJiaQERQe0Bcb7BXZpDpOfvtxEOplhXLMYDSwYK+S4V5ZQ0
        b+Zd4SNiE5Ahu0UYMQkOUv498tZhLqOXS4P9LAlKjuxzZnVRZAKrUHR/71v8j3vAwnTxBq
        pEVrfONiHlfZ2usUT9gjS36RKk4W1t4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 16 Apr 2021 00:27:46 +0200
From:   Michael Walle <michael@walle.cc>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: add
 nvmem-mac-address-offset property
In-Reply-To: <20210415215955.GA1937954@robh.at.kernel.org>
References: <20210414152657.12097-1-michael@walle.cc>
 <20210414152657.12097-2-michael@walle.cc> <YHcNtdq+oIYcB08+@lunn.ch>
 <20210415215955.GA1937954@robh.at.kernel.org>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <fefde522146d18aa7f8fbb8fa698cb58@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-04-15 23:59, schrieb Rob Herring:
> On Wed, Apr 14, 2021 at 05:43:49PM +0200, Andrew Lunn wrote:
>> On Wed, Apr 14, 2021 at 05:26:55PM +0200, Michael Walle wrote:
>> > It is already possible to read the MAC address via a NVMEM provider. But
>> > there are boards, esp. with many ports, which only have a base MAC
>> > address stored. Thus we need to have a way to provide an offset per
>> > network device.
>> 
>> We need to see what Rob thinks of this. There was recently a patchset
>> to support swapping the byte order of the MAC address in a NVMEM. Rob
>> said the NVMEM provider should have the property, not the MAC driver.
>> This does seems more ethernet specific, so maybe it should be an
>> Ethernet property?
> 
> There was also this one[1]. I'm not totally opposed, but don't want to
> see a never ending addition of properties to try to describe any
> possible transformation.

Agreed, that stuff like ASCII MAC address parsing should be done
elsewhere. But IMHO adding an offset is a pretty common one (as also
pointed out in [1]). And it also need to be a per ethernet device
property.

-michael

[1] 
https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20200920095724.8251-4-ansuelsmth@gmail.com/
