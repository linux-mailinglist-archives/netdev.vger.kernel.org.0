Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86EFB1BE76C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgD2Tcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgD2Tcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:32:53 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5930C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 12:32:53 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id B5FC22222E;
        Wed, 29 Apr 2020 21:32:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588188772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QqP0OaPq3shjiit/cLRvfH5CpWZGlXRXAXZrcfxe6cM=;
        b=r6oCr0if/9sAZJHZPz/blFVm5cq5DnzOhoVU8AG+ngs3J5Q/F4SP1uLxx2VNAyB2Ekmt2c
        2ub+kdVsZTV4AoRV0NDIYgHjKwA+B5TOj5b271IFVlaVYWh4o4/ufigYHoTEEly/x3unFn
        k6ZO3HZCDx4X0Mn69Eo+GGYQgf1ueeU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 29 Apr 2020 21:32:51 +0200
From:   Michael Walle <michael@walle.cc>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, cphealy@gmail.com,
        davem@davemloft.net, hkallweit1@gmail.com, mkubecek@suse.cz,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/9] net: ethtool: Add attributes for cable
 test reports
In-Reply-To: <743b2495-eab1-01af-1c1c-269f992b802a@gmail.com>
References: <20200425180621.1140452-5-andrew@lunn.ch>
 <20200429161605.23104-1-michael@walle.cc> <20200429185727.GP30459@lunn.ch>
 <743b2495-eab1-01af-1c1c-269f992b802a@gmail.com>
Message-ID: <9e8fa21bd1b51104038dbdc54fb61674@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: B5FC22222E
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[7];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,davemloft.net,suse.cz,vger.kernel.org];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-04-29 20:58, schrieb Florian Fainelli:
> On 4/29/20 11:57 AM, Andrew Lunn wrote:
>> On Wed, Apr 29, 2020 at 06:16:05PM +0200, Michael Walle wrote:
>>> Hi,
>>> 
>>>>>>> +enum {
>>>>>>> +	ETHTOOL_A_CABLE_PAIR_0,
>>>>>>> +	ETHTOOL_A_CABLE_PAIR_1,
>>>>>>> +	ETHTOOL_A_CABLE_PAIR_2,
>>>>>>> +	ETHTOOL_A_CABLE_PAIR_3,
>>>>>>> +};
>>>>>> 
>>>>>> Do we really need this enum, couldn't we simply use a number 
>>>>>> (possibly
>>>>>> with a sanity check of maximum value)?
>>>>> 
>>>>> They are not strictly required. But it helps with consistence. Are 
>>>>> the
>>>>> pairs numbered 0, 1, 2, 3, or 1, 2, 3, 4?
>>>> 
>>>> OK, I'm not strictly opposed to it, it just felt a bit weird.
>>> 
>>> Speaking of the pairs. What is PAIR_0 and what is PAIR_3? Maybe
>>> it is specified somewhere in a standard, but IMHO an example for
>>> a normal TP cable would help to prevent wild growth amongst the
>>> PHY drivers and would help to provide consistent reporting towards
>>> the user space.
>> 
>> Hi Michael
>> 
>> Good question
>> 
>> Section 25.4.3 gives the pin out for 100BaseT. There is no pair
>> numbering, just transmit+, transmit- and receive+, receive- signals.
>> 
>> 1000BaseT calls the signals BI_DA+, BI_DA-, BI_DB+, BI_DB-, BI_DC+,
>> BI_DC-, BI_DDA+, BI_DD-. Comparing the pinout 100BaseT would use
>> BI_DA+, BI_DA-, BI_DB+, BI_DB. But 1000BaseT does not really have
>> transmit and receive pairs due to Auto MDI-X.
>> 
>> BroadReach calls the one pair it has BI_DA+/BI_DA-.
>> 
>> Maybe it would be better to have:
>> 
>> enum {
>> 	ETHTOOL_A_CABLE_PAIR_A,
>> 	ETHTOOL_A_CABLE_PAIR_B,
>> 	ETHTOOL_A_CABLE_PAIR_C,
>> 	ETHTOOL_A_CABLE_PAIR_D,
>> };
> 
> Yes, that would be clearer IMHO. Broadcom PHYs tend to refer to pairs 
> A,
> B, C and D in their datasheets.

Qualcomm Atheros calls them MDI[0], MDI[1], etc.. maybe mention
the corresponding pin on an RJ45 connector for reference?

-michael

