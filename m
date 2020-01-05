Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 391331305B3
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 05:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgAEEmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 23:42:49 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35984 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgAEEms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 23:42:48 -0500
Received: by mail-pl1-f193.google.com with SMTP id a6so19800828plm.3
        for <netdev@vger.kernel.org>; Sat, 04 Jan 2020 20:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=55UnE/fGuQxKziii5MvlKf8Ol54YNy7G1gIgm2XCvXQ=;
        b=JpngyhXRCS07hPSBWmx6aWSfpEw7kRhcZ95LyRCJDpGYxHh+Zg3JDvViCaWWBUXRRU
         obhlcGAXWdlcTjamr9MQmA26TtBlVqKA3ZG47FE6STfcamM9l3UNeYeiS/9tS1kVyRgE
         +ErpRtmajvxNzgUOP6nyqS41rqzZx4T/caF2u1GbV5DZS9TOffYqx7ziz9OBc3y1pt/b
         6UA7fPjbvcG5b3b+IcHj5A10esPUlOuBxTXm3v/a/FocW+PrbKaWSIx6BfVkzXHzFkP1
         +3XH8Ee2j7j4bgBPys68ZRLG7mmEpfL8bWqsfZbnBLbT0NJ7v9mh39zvf7RAj//PKkZK
         wrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=55UnE/fGuQxKziii5MvlKf8Ol54YNy7G1gIgm2XCvXQ=;
        b=AHNU93vPI6j2S5I3cgz7n+WagrfRj5+gSIQmNJNtRUbGvdpV9vIIx/Lg0BrBm+dZtt
         C3JTFPVHOvNcHZia0LZ70pOs+trvEgr+tBEB99KRP26IoytBcDms37Lx+UWe6YbLwwaE
         VsWkuHwsHQTICjCPhWnfFf3EqV/1HTs/ejiRI9Xh0k4kJHzBG89wr5lUUbv6JGXVUiyG
         we4yl6smrYao3NZXNZW9lx+R5LKmAd09tL/hveQ3XHQHy9tC5zjaxt0rBSkPpNOEF69T
         aCJeS+r815D3jAvakfZbDB18aEfxbfQ2VH27oY3gCy8z0+mi+2qfapvImqsbXYYDgZik
         LUfA==
X-Gm-Message-State: APjAAAXMFtGhpQAtEwkqVBHzAe8oPuYMJf2HGgrYl9al+ExRVSscrF4N
        j/HffrWA7oYTmQUvKP9Ae5ATAFi5
X-Google-Smtp-Source: APXvYqzUsannph+A3KxvaFuApQpNuUV3iuEgnD9k5kIM9cSqC83z46ljhaqXCmMN/a+BhrROKs0Qzg==
X-Received: by 2002:a17:902:9695:: with SMTP id n21mr78989752plp.192.1578199367652;
        Sat, 04 Jan 2020 20:42:47 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y62sm76561341pfg.45.2020.01.04.20.42.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jan 2020 20:42:47 -0800 (PST)
Subject: Re: [PATCH v2 net-next 1/3] net: dsa: sja1105: Always send through
 management routes in slot 0
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20200104003711.18366-1-olteanv@gmail.com>
 <20200104003711.18366-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <352e5121-5404-b6b9-a0b0-db8cb4024dc8@gmail.com>
Date:   Sat, 4 Jan 2020 20:42:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200104003711.18366-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/3/2020 4:37 PM, Vladimir Oltean wrote:
> I finally found out how the 4 management route slots are supposed to
> be used, but.. it's not worth it.
> 
> The description from the comment I've just deleted in this commit is
> still true: when more than 1 management slot is active at the same time,
> the switch will match frames incoming [from the CPU port] on the lowest
> numbered management slot that matches the frame's DMAC.
> 
> My issue was that one was not supposed to statically assign each port a
> slot. Yes, there are 4 slots and also 4 non-CPU ports, but that is a
> mere coincidence.
> 
> Instead, the switch can be used like this: every management frame gets a
> slot at the right of the most recently assigned slot:
> 
> Send mgmt frame 1 through S0:    S0 x  x  x
> Send mgmt frame 2 through S1:    S0 S1 x  x
> Send mgmt frame 3 through S2:    S0 S1 S2 x
> Send mgmt frame 4 through S3:    S0 S1 S2 S3
> 
> The difference compared to the old usage is that the transmission of
> frames 1-4 doesn't need to wait until the completion of the management
> route. It is safe to use a slot to the right of the most recently used
> one, because by protocol nobody will program a slot to your left and
> "steal" your route towards the correct egress port.
> 
> So there is a potential throughput benefit here.
> 
> But mgmt frame 5 has no more free slot to use, so it has to wait until
> _all_ of S0, S1, S2, S3 are full, in order to use S0 again.
> 
> And that's actually exactly the problem: I was looking for something
> that would bring more predictable transmission latency, but this is
> exactly the opposite: 3 out of 4 frames would be transmitted quicker,
> but the 4th would draw the short straw and have a worse worst-case
> latency than before.
> 
> Useless.
> 
> Things are made even worse by PTP TX timestamping, which is something I
> won't go deeply into here. Suffice to say that the fact there is a
> driver-level lock on the SPI bus offsets any potential throughput gains
> that parallelism might bring.
> 
> So there's no going back to the multi-slot scheme, remove the
> "mgmt_slot" variable from sja1105_port and the dummy static assignment
> made at probe time.
> 
> While passing by, also remove the assignment to casc_port altogether.
> Don't pretend that we support cascaded setups.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
