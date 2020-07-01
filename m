Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7DD5210CAA
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbgGANtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730408AbgGANtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:49:32 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A480EC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 06:49:31 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 044AC22EDB;
        Wed,  1 Jul 2020 15:49:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1593611369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AuG6jCa8cXz/p5OzNhUjCPbf7lD55p9PKi8ZHUDwdZg=;
        b=KpF3Wtb/iEdGcNO5eXhPR++qFiMwZ8Kf6/L+4g5v/jKYfEt7FY+xw1LUaKpjEYePMIDKHo
        WdXDDrZvngpQqR7v8eU1FZDlg51EFG5tDnE+eKgCcCWEbOwjnmirZL2AMR/nk7pd1QgUXG
        INtKn9rul1ZhUHeWR8DpgEx6W+bb2mQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 01 Jul 2020 15:49:28 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v3 0/9] net: phy: add Lynx PCS MDIO module
In-Reply-To: <CA+h21hpBodyY8CtNH2ktRdc2FqPi=Fjp94=VVZvzSVbnvnfKVg@mail.gmail.com>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
 <20200622092944.GB1551@shell.armlinux.org.uk>
 <CA+h21hq146U6Zb38Nrc=BKwMu4esNtpK5g79oojxVmGs5gLcYg@mail.gmail.com>
 <0a2c0e6ea53be6c77875022916fbb33d@walle.cc>
 <CA+h21hpBodyY8CtNH2ktRdc2FqPi=Fjp94=VVZvzSVbnvnfKVg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.6
Message-ID: <1f258d5db214f9f1e644ea4b4fdb18e5@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Am 2020-07-01 15:37, schrieb Vladimir Oltean:
[..]
>> > felix does not have support code for 1000base-x, so I think it's
>> > natural to not clutter this series with things like that.
>> > Things like USXGMII up to 10G, 10GBase-R, are also missing, for much
>> > of the same reason - we wanted to make no functional change to the
>> > existing code, precisely because we wanted it to go in quickly. There
>> > are multiple things that are waiting for it:
>> > - Michael Walle's enetc patches are going to use pcs-lynx
>> 
>> How likely is it that this will be sorted out before the 5.9 merge
>> window will be closed? The thing is, we have boards out in the
>> wild which have a non-working ethernet with their stock bootloader
>> and which depend on the following patch series to get that fixed:
>> 
>> https://lore.kernel.org/netdev/20200528063847.27704-1-michael@walle.cc/
>> 
>> Thus, if this is going to take longer, I'd do a respin of that
>> series. We already missed the 5.8 release and I don't know if
>> a "Fixes:" tag (or a CC stable) is appropriate here because it
>> is kind of a new functionality.
>> 
>> -michael
> 
> From my side I think it is reasonable that you resubmit your enetc
> patches using the existing framework. Looks like we're in for some
> pretty significant API changes for phylink, not sure if you need to
> depend on those if you just need the PCS to work.

Ok, I'll resubmit them.

> But, I don't know if marketing your patches as "fixes" is going to go
> that well. In fact, you are also moving some definitions around, from
> felix to enetc. I think if you want to break dependencies from felix
> here, you should leave the definitions where they are and just
> duplicate them.

Nice idea, but I didn't intend to add the Fixes tag anyways. I'm fine
with saying, please use the newest kernel.

-michael
