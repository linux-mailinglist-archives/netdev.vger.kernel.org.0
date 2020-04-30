Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BF61C08FF
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgD3VQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:16:18 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:36313 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgD3VQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:16:18 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C80B022F43;
        Thu, 30 Apr 2020 23:16:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588281376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MmZbuFdEyuT7/Ar0JKwjSrMN7hNd/5zS+cxu2az51Ec=;
        b=Zs2K7hrkro/o54jtNHqrh44iewjlKOxpr3edRDPdPoZy72+uhIUJ3LIWJlsX+jx/wda545
        qAWE33digD4iiRNx8XtbwEkqWbuOiR+Kn7kiJW4LnMWe/Av3tnAtR2VRGM72brrwvLqZ0J
        jrOnAcpjrFf+H01zGpuxc24C/G5aefY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 Apr 2020 23:16:15 +0200
From:   Michael Walle <michael@walle.cc>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, cphealy@gmail.com,
        davem@davemloft.net, hkallweit1@gmail.com, mkubecek@suse.cz,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/9] Ethernet Cable test support
In-Reply-To: <c52e7043-cbd5-8fa0-96e6-e29e783d3a5f@gmail.com>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200429160213.21777-1-michael@walle.cc> <20200429163247.GC66424@lunn.ch>
 <c4363f2888192efc692e08cc1a4a9a57@walle.cc>
 <61eb35f8-3264-117d-59c2-22f0fdc36e96@gmail.com>
 <9caef9bbfaed5c75e72e083db8a552fd@walle.cc>
 <20200430194143.GF107658@lunn.ch>
 <0b157250-2b06-256f-5f48-533233b22d60@gmail.com>
 <b63498f01e64c55124c2c710fffb1047@walle.cc>
 <c52e7043-cbd5-8fa0-96e6-e29e783d3a5f@gmail.com>
Message-ID: <efe18bc054ea6e363e7f9610be123cb1@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: C80B022F43
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

Am 2020-04-30 22:19, schrieb Florian Fainelli:
> On 4/30/20 1:13 PM, Michael Walle wrote:
>> Am 2020-04-30 22:04, schrieb Florian Fainelli:
>>> On 4/30/20 12:41 PM, Andrew Lunn wrote:
>>>>> ECD. The registers looks exactly like the one from the Marvell 
>>>>> PHYs,
>>>>> which makes me wonder if both have the same building block or if 
>>>>> one
>>>>> imitated the registers of the other. There are subtle differences
>>>>> like one bit in the broadcom PHY is "break link" and is 
>>>>> self-clearing,
>>>>> while the bit on the Marvell PHY is described as "perform 
>>>>> diagnostics
>>>>> on link break".
>>>> 
>>>> Should we be sharing code between the two drivers?
>>> 
>>> Yes, I am amazed how how identical they are, nearly on a bit level
>>> identical, the coincidence is uncanny. The expansion registers are 
>>> also
>>> 0x10 - 0x15 just in the reverse order,
>> 
>> At what PHY are you looking? I've just found some datasheets where 
>> they
>> are at 0xC0 to 0xC5.
> 
> BCM54810 because that's what I have on my desk right now, but 0x10 
> would
> be the offset relative to the expansion register space, which would
> translate into this:
> 
> https://github.com/ffainelli/linux/commits/broadcom-cable-tests
> 
> (sorry for the mess it is a patchwork of tests on various platforms,
> based on an earlier branch from Andrew).

Ah thanks, now I see what you mean with CD vs ECD. In your latest WIP
you're using ECD, so did both actually work with a link?

Also according to you header files bit 14 of the ECD_CTRL is the
"run after aneg bit"; in the BCM54140 it is just marked as reserved.
I guess I'm trying the CD on the BCM54140 tomorrow.

-michael

> 
>> 
>>> you know, so as to make it not
>>> too obvious this looks about the same ;) I wonder if we managed to 
>>> find
>>> something here.
>>> 
>>>> 
>>>>> What do you mean by calibrate it?
>>>> 
>>>> Some of the Marvell documentation talks about calibrating for losses
>>>> on the PCB. Run a diagnostics with no cable plugged in, and get the
>>>> cable length to the 'fault'. This gives you the distance to the RJ45
>>>> socket. You should then subtract that from all subsequent results.
>>>> But since this is board design specific, i decided to ignore it. I
>>>> suppose it could be stuffed into a DT property, but i got the 
>>>> feeling
>>>> it is not worth it, given the measurement granularity of 80cm.
>>> 
>>> OK, accuracy is different here, they are said to be +/- 5m accurate 
>>> for
>>> cable faults and +/- 10m accurate for good cables.
>> 
>> Accuracy != granularity. But yes, if one digit correspond to 80cm it
>> doesn't really make sense to remove the PCB trace error if you assume
>> that it might add just one digit at most.
> 
> One of the test racks that I use has very short cables, but I guess it
> does not matter if they get reported as 80cm or 160cm...
