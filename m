Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9AD31F07C
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhBRTwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:52:39 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:49715 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbhBRTq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 14:46:56 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id EF91B2223A;
        Thu, 18 Feb 2021 20:46:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613677571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z5S6cwt2CcE8hxMtwivXz5lbV2t0IeOPy56yfgrcEng=;
        b=R97wNe44Tf/tyV2/2VLt1OJarVrKClHXeJaipYUrI1mbB7H+UmlHAvwUChCfevvgvaPm56
        gQFePSgL0quElhHtwyxNzfFI421k9fM1csAugQbnjIN39Fu0HxEehz1gsn2+6rmNuUGaeW
        D4xQw4ZzbVPFBhXhswHZPxQDefONRl0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 18 Feb 2021 20:46:10 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 0/2] net: phy: at803x: paging support
In-Reply-To: <20210218192647.m5l4wkboxms47urw@skbuf>
References: <20210218185240.23615-1-michael@walle.cc>
 <20210218192647.m5l4wkboxms47urw@skbuf>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <15a6833c0db85fc3871a1d926d6636d6@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-18 20:26, schrieb Vladimir Oltean:
> On Thu, Feb 18, 2021 at 07:52:38PM +0100, Michael Walle wrote:
>> Add paging support to the QCA AR8031/33 PHY. This will be needed if we
>> add support for the .config_inband_aneg callback, see series [1].
>> 
>> The driver itself already accesses the fiber page (without proper 
>> locking).
>> The former version of this patchset converted the access to
>> phy_read_paged(), but Vladimir Oltean mentioned that it is dead code.
>> Therefore, the second patch will just remove it.
>> 
>> changes since v1:
>>  - second patch will remove at803x_aneg_done() altogether
> 
> I'm pretty sure net-next is closed now, since David sent the pull
> request, and I didn't come to a conclusion yet regarding the final
> form of the phy_config_inband_aneg method either.

Yeah I wasn't sure. http://vger.kernel.org/~davem/net-next.html says
it is still open. But anyway, if not, I'll resend the patch after
the merge window. I've also thought about splitting it into two
individual patches, because they aren't dependent on each other
anymore.

We'll need the page support anyway, even if phy_config_inband_aneg
will change. Ok granted, the cover letter might be misleading then.

-michael
