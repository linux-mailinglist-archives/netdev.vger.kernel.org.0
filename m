Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE17E28DF86
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 13:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbgJNLBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 07:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729633AbgJNLBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 07:01:19 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600F0C061755;
        Wed, 14 Oct 2020 04:01:18 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gv6so1444673pjb.4;
        Wed, 14 Oct 2020 04:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=39vxUfo9kUr/ORglanv6XpeBZZtxBlP4sJxydSsaVzk=;
        b=Boo9/wsmz4nLf4Amren52ut9/aDpz4K3SHVOItYNSqMtsjsL7mfvV+yc99rOBfL4g5
         OP3Rk7vELk5oM0mu1mI5fhL250T3o7Gy/yNZlNU/iEgAZ7dSu+LXGR6tTFr7WzRYNEN0
         e90bMKOMOfz17BVj0UE/S23USyfGeMteJVGc2SYUw7xdgvNeM/qNgXHZFrsS02+b2L/F
         u1AnPyjy5u01T8HNk+adq5WzyUhmZJngp7O95kVdq/rT8kP9DiPh1Olml/3yRiGttEht
         /zR/6RXhG5nprSNZ16YrjQo7BZPye1+WEYJhN/MPHc7Kb8movFMlQqg9D5mLOWZgSRsO
         PPIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=39vxUfo9kUr/ORglanv6XpeBZZtxBlP4sJxydSsaVzk=;
        b=h1jxC3ueuX7lZlXlSwk8eEG7fTwSoxsyABjTcckCmMdaE3HI2rGmIPfS/nYMjYNH6v
         pOVOaXeXvs1UamjyPEtE15Tx04jNSxRbe11oi1+V+S/VSa1XfMjgM0bATf56Y4+RrmYa
         usO0Nk3gLnyHZb9pj2UQM9xv2PuGtZ2M/sOm631yA/z5abiD2W9sr7Ekh7vp1U5L5wuH
         btRKMxttirnBkChjVw99kKHvInr+6OsH3D5xgFIAzYfvw+sSw0oZP4QKSOyKn0uamY1j
         xhvA1kho48WVlPUfSj/+FR+vwVGkop6+GxHTxAwhTKt91Z2q1Xq5s9UUimMMOywdw7aF
         mwTg==
X-Gm-Message-State: AOAM530Jv3QhshaqcKVP8HuLJsp+N3ibmWjTS/2M4Xk7FD1IN3md/Wws
        vL3W5QUivXuBLQiJUfl65fg=
X-Google-Smtp-Source: ABdhPJwqJxACPzCD9HfMQhSj8RiZBsMs0NPgKDh778vtuoVaUf6L3ECp4t5sjgOlIQBpF01n2cVzfQ==
X-Received: by 2002:a17:90a:fe13:: with SMTP id ck19mr2942003pjb.207.1602673277638;
        Wed, 14 Oct 2020 04:01:17 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id v21sm2618483pjg.44.2020.10.14.04.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 04:01:16 -0700 (PDT)
Date:   Wed, 14 Oct 2020 04:01:13 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for
 hardware timestamping
Message-ID: <20201014110113.GA1646@hoboy>
References: <87lfgiqpze.fsf@kurt>
 <20201007105458.gdbrwyzfjfaygjke@skbuf>
 <87362pjev0.fsf@kurt>
 <20201008094440.oede2fucgpgcfx6a@skbuf>
 <87lfghhw9u.fsf@kurt>
 <f040ba36070dd1e07b05cc63a392d8267ce4efe2.camel@hs-offenburg.de>
 <20201008150951.elxob2yaw2tirkig@skbuf>
 <65ecb62de9940991971b965cbd5b902ae5daa09b.camel@hs-offenburg.de>
 <20201012214254.GA1310@hoboy>
 <20201014095747.xlt3xodch7tlhrhr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014095747.xlt3xodch7tlhrhr@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 12:57:47PM +0300, Vladimir Oltean wrote:
> So the discussion is about how to have the cake and eat it at the same
> time.

And I wish for a pony.  With sparkles.  And a unicorn.  And a rainbow.

> Silicon vendors eager to follow the latest trends in standards are
> implementing hybrid PTP clocks, where an unsynchronizable version of the
> clock delivers MAC timestamps to the application stack, and a
> synchronizable wrapper over that same clock is what gets fed into the
> offloading engines, like the ones behind the tc-taprio and tc-gate
> offload. Some of these vendors perform cross-timestamping (they deliver
> a timestamp from the MAC with 2, or 3, or 4, timestamps, depending on
> how many PHCs that MAC has wired to it), some don't, and just deliver a
> single timestamp from a configurable source.

Sounds like it will be nearly impossible to make a single tc-taprio
framework that fits all the hardware variants.

> The operating system is supposed to ??? in order to synchronize the
> synchronizable clock to the virtual time retrieved via TIME_STATUS_NP
> that you're talking about. The question is what to replace that ???
> with, of course.

You have a choice.  Either you synchronize the local PHC to the global
TAI time base or not.  If you do synchronize the PHC, then everything
(like the globally scheduled time slots) just works.  If you decide to
follow the nonsensical idea (following 802.1-AS) and leave the PHC
free running, then you will have a difficult time scheduling those
time windows.

So it is all up to you.

> I'm not an expert in kernel implementation either, but perhaps in the
> light of this, you can revisit the idea that kernel changes will not be
> needed (or explain more, if you still think they aren't).

I am not opposed to kernel changes, but there must be:

- A clear statement of the background context, and
- an explanation of the issue to solved, and
- a realistic solution that will support the wide variety of HW. 

> DISCLAIMER
> Yes, I know full well that everyone can write a standard, but not
> everyone can implement one. At the end of the day, I'm not trying to
> make an argument whether the end result is worth making all these
> changes.

+1

That is the question.  You can easily solve this issue by simply
synchronizing the PHC to the global time base.

Thanks,
Richard
