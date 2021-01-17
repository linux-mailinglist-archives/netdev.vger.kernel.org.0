Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EBD2F942A
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 18:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbhAQR2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 12:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbhAQR15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 12:27:57 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A34CC061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 09:27:16 -0800 (PST)
Received: from miraculix.mork.no (fwa136.mork.no [192.168.9.136])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 10HHQt5j003973
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sun, 17 Jan 2021 18:26:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1610904416; bh=i47PqHy/XxOXMLZAW0NVDTePUMLKmi1DFXvfHx3nEJw=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=hCfQDsTjTh9vaPO6u7W3dOPTpWs5uyXaigI8ZrAkZrN6Q590Mt7oxfsZJBv7yLkNq
         bzASp1mDUJpj7oL34VqgofCFh7m8uOX5Z/ptyiSTSYdaSh+X6RLF0MzgqjqRwdP5+N
         l/Z9JNPDO1Zk6daq6A/Sxjp30cZ9SBgpzz3uNVs4=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1l1BpG-002NpQ-MU; Sun, 17 Jan 2021 18:26:54 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com
Subject: Re: [PATCH 17/18] net: iosm: readme file
Organization: m
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
        <20210107170523.26531-18-m.chetan.kumar@intel.com>
        <X/eJ/rl4U6edWr3i@lunn.ch>
Date:   Sun, 17 Jan 2021 18:26:54 +0100
In-Reply-To: <X/eJ/rl4U6edWr3i@lunn.ch> (Andrew Lunn's message of "Thu, 7 Jan
        2021 23:23:58 +0100")
Message-ID: <87turftqxt.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry about being much too late into this discussion.  I'm not having
the bandwidth to read netdev anymore, and just stumbled across this now.

Andrew Lunn <andrew@lunn.ch> writes:

> So, this is what all the Ethernet nonsense is all about. You have a
> session ID you need to somehow represent to user space. And you
> decided to use VLANs. But to use VLANs, you need an Ethernet
> header. So you added a bogus Ethernet header.

Actually, the original reasoning was the other way around.

The bogus ethernet header was added because I had seen the 3G modem
vendors do that for a few years already, in the modem firmware.  And I
didn't think enough about it to realize that it was a really bad idea,
or even that it was something I could change.  Or should change.

I cannot blame the MBIM sesison to VLAN mapping idea on anyone else.  As
far as I can remember, that was just something that popped up in my head
while working on the cdc_mbim driver. But it came as a consequence of
already having the bogus ethernet header.  And I didn't really
understand that I could define a new wwan subsystem with new device
types. I thought I had to use whatever was there already.

I was young and stupid. Now I'm not that young anymore ;-)

Never ever imagined that this would be replicated in another driver,
though.  That doesn't really make much sense.  We have learned by now,
haven't we?  This subject has been discussed a few times in the past,
and Johannes summary is my understanding as well:
"I don't think anyone likes that"

The DSS mapping sucks even more that the IPS mapping, BTW.  I don't
think there are any real users?  Not that I know of, at least.  DSS is
much better implmeneted as some per-session character device, as
requested by numerous people for years.  Sorry for not listening. Looks
like it is too late now.

> Is any of this VLAN stuff required by MBIM?

No.  It's my fault and mine alone.

> I suggest you throw away the pretence this is an Ethernet device. It
> is not.

I completely agree.  I wish I had gone for simple raw-ip devices both in
the qmi_wwan and cdc_mbim.  But qmi_wwan got them later, so there is
already support for such things in wwan userspace.


Bj=C3=B8rn
