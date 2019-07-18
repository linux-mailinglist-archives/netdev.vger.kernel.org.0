Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A14996D299
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 19:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfGRRPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 13:15:02 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35630 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGRRPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 13:15:02 -0400
Received: by mail-pl1-f193.google.com with SMTP id w24so14208211plp.2
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 10:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=HdQeCS0yy3AlY+iVjvUv+4AGU7isSYSAvlWIXBAYIuo=;
        b=0Wz/zTEL+Nb1qjPlwN9cpcv8WTbwB3jLVixqQwPB/liWy6mod5mP5PrhWzCB5CdB4m
         CYpmFyi3rwr2TWIJMslMXGeh7QqvRNPOh5EinjlCWCIBaLe6fso1sV11kRpom8iq7oTQ
         7+xgISsNL62FTxs0DvCGDsga8b0A81jrGmv58g6/Axzbg142TjEoLkz+pXTphU8G10pP
         YiSbIkm1Uqs/sPoFDmAiy5UM9JVxw1YKXx88SIZm197fvnKCNU/0E+uiFegzzxfy806y
         fWKKdJEOSESfH+ID1MnvWphvqf+VcWTg4jpcbOMdzoMkALg1R1A2kI7RsM6Kokkqilum
         LDkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HdQeCS0yy3AlY+iVjvUv+4AGU7isSYSAvlWIXBAYIuo=;
        b=CjDjaOEV9Q15cSNbtJ+AAwkZGzf+bJXke3ePaaa9iD7tvg56LR54kfkg2a0eRT5V7M
         PmQ9/wkA0nwqESCkOu2E82PIoN7JkXzJ3g8bqGcSQ9rTgWU812P8DxdBSS5DvHRcUi/n
         Shzp2riCvUkrOnE4guynKhg4OyFcVYrthLouwqj768ni1xDZ+OnsLINLVB7Uz/v5gzjs
         yo/oXq49ADGzdBfrq/kiYwjQXDHBZUbCss6ktef+Vk+4OUzvyXCJH6JxpHDs0OArDbg9
         +28V1T6qwl1WtFGP5XMpB12UMFMj97lOrMjewq9MeDTP/MyPwSI4zy6n57OVqQKKZS3o
         Fz0g==
X-Gm-Message-State: APjAAAV7VwSqCdDpNXukOpR1hBuZ84hMoLKb564bTSGBb3Bp4jIl2phU
        LaFHVTYVJptV3bAw5juLG1bflWuVYXY=
X-Google-Smtp-Source: APXvYqxZA2pW6xu8EE6ZBqoCDlAKPZ1CULoPTdzskVwf84Zrn9m1jHdTvKdgYviKhG6Lu9ahpd/siQ==
X-Received: by 2002:a17:902:290b:: with SMTP id g11mr50402051plb.26.1563470101795;
        Thu, 18 Jul 2019 10:15:01 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id u6sm24290437pjx.23.2019.07.18.10.15.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 10:15:01 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io> <20190709023050.GC5835@lunn.ch>
 <79f2da6f-4568-4bc8-2fa4-3aa5a41bbff1@pensando.io>
 <20190718033109.GI6962@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <2fc052de-2d08-5517-3ee2-094364c4284f@pensando.io>
Date:   Thu, 18 Jul 2019 10:14:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190718033109.GI6962@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/17/19 8:31 PM, Andrew Lunn wrote:
> On Fri, Jul 12, 2019 at 10:32:38PM -0700, Shannon Nelson wrote:
>> On 7/8/19 7:30 PM, Andrew Lunn wrote:
>>>> +static int ionic_nway_reset(struct net_device *netdev)
>>>> +{
>>>> +	struct lif *lif = netdev_priv(netdev);
>>>> +	int err = 0;
>>>> +
>>>> +	if (netif_running(netdev))
>>>> +		err = ionic_reset_queues(lif);
>>> What does ionic_reset_queues() do? It sounds nothing like restarting
>>> auto negotiation?
>>>
>>>       Andrew
>> Basically, it's a rip-it-all-down-and-start-over way of restarting the
>> connection, and is also useful for fixing queues that are misbehaving.  It's
>> a little old-fashioned, taken from the ixgbe example, but is effective when
>> there isn't an actual "restart auto-negotiation" command in the firmware.
> O.K. More comments please.

After a little more discussion with the nic connection folks, they've 
said to just flap the link to force a new auto-negotiation, so that's 
what I'm adding - set state to off, then back on.  And yes, another 
comment here.

>
> Did you consider throwing the firmware away and just letting Linux
> control the hardware? It would make this all much more transparent and
> debuggable.
>

Yes, the tension between direct driver bit twiddling and smartnic 
offloading continues.

sln

