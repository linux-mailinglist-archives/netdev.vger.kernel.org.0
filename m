Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A75318CEB0
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgCTNUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:20:46 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:32788 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbgCTNUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:20:46 -0400
Received: by mail-ed1-f50.google.com with SMTP id z65so7110951ede.0;
        Fri, 20 Mar 2020 06:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dUEEIXwK5ES9niBblpQmidtobsRZQ/p8qQvEflwvR7Y=;
        b=Ovz1jPHkhhJXMWr1p86lFmV8kwp9F0zmQBsHj5nURFj1OHPjfpeI9eXBePgTjUGs6q
         F4XeQCwxH2ABKBKNstH7Dn/I5b2lm/f76I1Ru7fytTc9A3L1tJc+HFP7p7G0YMbQuVD0
         Z/+GAuXaQnvTlXkrnoCBVPejq4bu1Es8/Fom7djd/1ID5Gqj4fwvr1L7xZn1kGLDVLTA
         agtEJcd8A88InIo5pQDqrJgdT4VKHXjl0RWyjNKpLRERBX/29yg+KQ+gTPC6h+H5hOMI
         4l/vRvbId5dA7bWwZhYtln7/b00jt6NEiBTi0VMs9omcRHT/gDE+9Sq3MD5dpsdnFqoc
         +ZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dUEEIXwK5ES9niBblpQmidtobsRZQ/p8qQvEflwvR7Y=;
        b=IJmpOJzIsdi1q5dklFjB4zeKmoniGJX1Xmd+dA1ufsc/RaCFC77qYG6ebQw6ODpq/J
         oX8qLCVY8UGyHzOdHxqW/BJw5sTgIhxqRDjrFPdWOVHdmF67rsIbgQVFeFQvBdV9ZXde
         7GwXdpbZajFrov3QnY62s+ZkXKV/pEO2l3ikkwbFbgP4V27A4vDoCogiMqPnyVVTy3pq
         bWbLxTIMUgS1diQuE6buG8YA6cb2H4FFjYaO5jUtF3tCKWsZyzofnuVO9WNQSqnxzgkV
         AdtsyD0AgiDSq9FOVYaujpGxGg+QHoSNhhpxUnha1oAoVCgxB2PbDGe6nik3wuYXQhMT
         4BCw==
X-Gm-Message-State: ANhLgQ3BiKTzUMsFzCZFJihsry3fF4Tp7tyJ06CI1L+9Fw+Tg1o7NJ9o
        MHVZ7Kkb4ZYCmCqXaq8lsn789FjnHGy6psarKdOJzlQv4fEb/w==
X-Google-Smtp-Source: ADFU+vuf9xaZBaI2oibiYxtqEAdFjuhMPXdoHi0JJKOs4zyG3rzHxiK0YyrzxAKsNbUit5SiknX6MQF0eyGs1BNeN84=
X-Received: by 2002:a17:906:4956:: with SMTP id f22mr7897973ejt.293.1584710443930;
 Fri, 20 Mar 2020 06:20:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200320103726.32559-1-yangbo.lu@nxp.com> <20200320103726.32559-7-yangbo.lu@nxp.com>
In-Reply-To: <20200320103726.32559-7-yangbo.lu@nxp.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 20 Mar 2020 15:20:32 +0200
Message-ID: <CA+h21hoBwDuWCFbO70u1FAERB8zc5F+H5URBkn=2_bpRRRz1oA@mail.gmail.com>
Subject: Re: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yangbo,

On Fri, 20 Mar 2020 at 12:42, Yangbo Lu <yangbo.lu@nxp.com> wrote:
>
> Support 4 programmable pins for only one function periodic
> signal for now. Since the hardware is not able to support
> absolute start time, driver starts periodic signal immediately.
>

Are you absolutely sure it doesn't support absolute start time?
Because that would mean it's pretty useless if the phase of the PTP
clock signal is out of control.

I tested your patch on the LS1028A-RDB board using the following commands:

# Select PEROUT function and assign a channel to each of pins
SWITCH_1588_DAT0 and SWITCH_1588_DAT1
echo '2 0' > /sys/class/ptp/ptp1/pins/switch_1588_dat0
echo '2 1' > /sys/class/ptp/ptp1/pins/switch_1588_dat1
# Generate pulses with 1 second period on channel 0
echo '0 0 0 1 0' > /sys/class/ptp/ptp1/period
# Generate pulses with 1 second period on channel 1
echo '1 0 0 1 0' > /sys/class/ptp/ptp1/period

And here is what I get:
https://drive.google.com/open?id=1ErWufJL0TWv6hKDQdF1pRL5gn4hn4X-r

So the periodic output really starts 'now' just like the print says,
so the output from DAT0 is not even in sync with DAT1.

> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---

Thanks,
-Vladimir
