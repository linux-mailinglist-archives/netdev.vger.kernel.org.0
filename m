Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3FCC9961C
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 16:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387687AbfHVOQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 10:16:46 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34828 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387673AbfHVOQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 10:16:45 -0400
Received: by mail-pg1-f194.google.com with SMTP id n4so3772323pgv.2;
        Thu, 22 Aug 2019 07:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5VZDP+zY9UFzHwVTHjDjM0azlGZus3k3oidB4OI3cp0=;
        b=Ryud04X97qBBwO3cdJNnMtMYp+2s2M6RK8p8MjuFtFJf1781kRwwTA3CI6mb/zBB4R
         RqrhfzelNgFLsoxsBNLKFqRr5iUHQO0XunibnVotaoMsgghk2+LKb60U8LeYCoLBGJnT
         4eg7Tn0RjgcfGDtsfuCHSKixxjJ9tdZGDIQxdy9eCn6QjrKGH5ubBnwLPxjwKK9JHEZR
         929yatg4EyAov3rFB5K1Y5FqESRVsy2oa3DYBSBhY6l32ixeTjb4pP/MD9yHscI3DLLL
         la3b6Nh4/9psru4bcE4CvJrIGRHXnc1LSYfzp5shonQDun/zw+NhWrM9al1GDroBh6Ik
         Lw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5VZDP+zY9UFzHwVTHjDjM0azlGZus3k3oidB4OI3cp0=;
        b=XWYxXYoo6YVQexsrIzaE+0+C7IwT5Hs/AGIHT31vfy67IOUqFOB8y9YAWJUtoZyYpZ
         Xy0iXB1KsMrz0gU9O4jelcI6gZHmo1EgLDR5wwTaeA61WdCJQ5MlKMQUfupwzntH51eY
         6mwJ2b/l/3G+eOLVtm7QCulZeaj/XkRKaofSnpesuAsNwNNy8Ob38uoBpR2fJ7MKqfuZ
         1Cv/gQL8HsyeGxOwygFbvSE9kyHlJIa0G/ufnTjcrj+i/3pmhObsdDju4qTGHEBBsBza
         KJpI7Jila1zycVdznT+W8seNYbmYpQBeK7tuCwuGNcE9DIlEwYZJnYmWbRfxlH8qa14m
         Yonw==
X-Gm-Message-State: APjAAAX33EmMJ8gj8eXWL6UoMSg7wZRz2BIw7jdmbSBv9kBiWYZN01GV
        XE3egiV/7Fft4GyHOhtS5s0=
X-Google-Smtp-Source: APXvYqwhgVaaVhTig6IyVqy/taAffsMHHT8ArQW7IweA0ynp6c6lmfMrSCZ2c8rEngPQP4deOL/Npg==
X-Received: by 2002:a63:1e06:: with SMTP id e6mr14347523pge.185.1566483404879;
        Thu, 22 Aug 2019 07:16:44 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id e9sm26328184pge.39.2019.08.22.07.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 07:16:43 -0700 (PDT)
Date:   Thu, 22 Aug 2019 07:16:41 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH spi for-5.4 0/5] Deterministic SPI latency with NXP DSPI
 driver
Message-ID: <20190822141641.GB1437@localhost>
References: <20190818182600.3047-1-olteanv@gmail.com>
 <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
 <20190821043845.GB1332@localhost>
 <20190821140815.GA1447@localhost>
 <CA+h21hrtzU1XL-0m+BG5TYZvVh8WN6hgcM7CV5taHyq2MsR5dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrtzU1XL-0m+BG5TYZvVh8WN6hgcM7CV5taHyq2MsR5dw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 11:17:23PM +0300, Vladimir Oltean wrote:
> Of course PPS with a dedicated hardware receiver that can take input
> compare timestamps is always preferable. However non-Ethernet
> synchronization in the field looks to me like "make do with whatever
> you can". I'm not sure a plain GPIO that raises an interrupt is better
> than an interrupt-driven serial protocol controller - it's (mostly)
> the interrupts that throw off the precision of the software timestamp.
> And use Miroslav's pps-gpio-poll module and you're back from where you
> started (try to make a sw timestamp as precise as possible).

Right, it might be better, might not.  You can consider hacking a
local time stamp into the ISR.  Also, if one of your MACs has a input
event pin, you can feed the switch's PPS output in there.

> wouldn't be my first choice. But DSA could have that built-in, and
> with the added latency benefit of a MAC-to-MAC connection.
> Too bad the mv88e6xxx driver can't do loopback timestamping, that's
> already 50% of the DSA drivers that support PTP at all. An embedded
> solution for this is less compelling now.

Let me back track on my statement about mv88e6xxx.  At the time, I
didn't see any practical way to use the CPU port for synchronization,
but I forget exactly the details.  Maybe it is indeed possible,
somehow.  If you can find a way that will work on your switch and on
the Marvell, then I'd like to hear about it.

Thinking back...

One problem is this.  PTP requires a delay measurement.  You can send
a delay request from the host, but there will never be a reply.

Another problem is this.  A Sync message arriving on an external port
is time stamped there, but then it is encapsulated as a tagged DSA
management message and delivered out the CPU port.  At this point, it
is no longer a PTP frame and will not be time stamped at the CPU port
on egress.

Thanks,
Richard
