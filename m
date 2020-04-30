Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144471C06AD
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgD3ToP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:44:15 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:37095 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3ToO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:44:14 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id CE40222F43;
        Thu, 30 Apr 2020 21:44:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588275853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m9mqQtIFwi2cx27z0dXTfNxwY/mJNIYId33eB78hEgQ=;
        b=f7U1C+9kz9F5a9BznCmeUFMg4xj5YyCuEWvEX+tV58XlBMJT9+KpHqUqfwLVgxx1ZaUGvZ
        OKyf1Vl2QMuntCNPCRfRZG8Bpf8Kdzi9WhgiEZ9344aAsCFWE2k318zjQeVfkDh8lj8DKU
        n3nYbi7RYZ+kRCQKx3mgMwAAeZB1/W4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 Apr 2020 21:44:12 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     cphealy@gmail.com, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/9] Ethernet Cable test support
In-Reply-To: <20200430182331.GE76972@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200429160213.21777-1-michael@walle.cc> <20200429163247.GC66424@lunn.ch>
 <c4363f2888192efc692e08cc1a4a9a57@walle.cc> <20200430182331.GE76972@lunn.ch>
Message-ID: <30fd56d966b577a045ddeb01942a9944@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: CE40222F43
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[7];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[gmail.com,davemloft.net,suse.cz,vger.kernel.org];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-04-30 20:23, schrieb Andrew Lunn:
>> Ok. I do have one problem. TDR works fine for the AR8031 and the
>> BCM54140 as long as there is no link partner, i.e. open cable,
>> shorted pairs etc. But as soon as there is a link partner and a
>> link, both PHYs return garbage. As far as I understand TDR, there
>> must not be a link, correct?
> 
> Correct.
> 
> The Marvell PHY will down the link and then wait 1.5 seconds before
> starting TDR, if you set a bit. I _think_ it downs the link by turning
> off autoneg.

According to the Atheros datasheet the "CDT can be performed when
there is no link partner or when the link partner is auto-negotiating".
One could interpret that as is is only allowed _during_ autoneg. But
as far as I know there is no indication if autoneg is currently active,
is it?

> Maybe there is some hints in 802.3 clause 22?

I'm just skimming over that, but even if the link could be disabled
locally, shouldn't there still be link pulses from the peer?

-michael
