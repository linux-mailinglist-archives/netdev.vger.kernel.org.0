Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81B0222E6C
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 00:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgGPWJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 18:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgGPWJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 18:09:27 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC97C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 15:09:27 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id n2so5962828edr.5
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 15:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qo9YgtANKG6Cu4+qif6q6sPYAw1xw8BScEZei/6Vk2Y=;
        b=CCwBACh1aE7wfQVnqovJuGI1oYItl06Xsvrhdyj3DXFH6PTnmq+7gMdJMRU1AFe5x1
         Cz8AkO/MoCrO0s2ZusBU56mVS9F5F9lHGqwihP59vx8j4ri6JbYYYoea5hPfriidivHf
         siiyXvzrN1F3cebhs/KgxaKsfuNjuMdHnKNSMXT+4QeOkUDWkEUCYUWE/ScALHKQp7+W
         JsRiXeA09EFz224VE87v0Y2NRUKE+de63+pYJNkV97+SB8ZO9DhTgBrQsM+2rywhPzU7
         FoKehZMtgbGYFuOI+qkEckDmb0Eo8+/ehXGXWnVBYC93yMPA+v+M4eDGOxL2jRx13C9l
         GgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qo9YgtANKG6Cu4+qif6q6sPYAw1xw8BScEZei/6Vk2Y=;
        b=hFtBH4+z+3Qy8whW5MuE3zKTWIAzLO6Fis44Fzag1FFK64L5OON0tnQX0HtkryEVwl
         PzzvPahIb6CT+yiPy8hHNo5GcztdZGY8d2a1wJEE2g+c8O02Oxw4iZq6MSTF9CgE9paM
         2/2xA0BXTl9gkIheHtxBAJtx42MSiR7npRC2PdgJuWB/U+5Yzb0sAArs7LyUnxnuzWvp
         h5OXYwOTEqkn9rSBjK1pwux6FPYc30t324JuLlBPsEqW1r7MbctOO4zrZN0X3mLgBAvS
         3NOH5h4ubSQjzVWOy+hVnWXS6Kp/T8enztHBWGpZnncNRy4mrUSsthDmhctvVNYUSNFh
         rWAQ==
X-Gm-Message-State: AOAM53170wK9Ibz8Ad7H9ujc/dq8T2aHJo4sXP/ucI+v7y6uQeM/5ZQe
        N5N4JhBWUfBPMnA8BpQ02xc=
X-Google-Smtp-Source: ABdhPJwhN4yN2bd+c2sR0sV1QGowZ6Ahx7hqZ3P5x6vg3YtL/CJ/ZKJ0nYa1ur5zOCcUhqKv94/58A==
X-Received: by 2002:a05:6402:1494:: with SMTP id e20mr6329723edv.2.1594937365640;
        Thu, 16 Jul 2020 15:09:25 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id w8sm6187383ejb.10.2020.07.16.15.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 15:09:25 -0700 (PDT)
Date:   Fri, 17 Jul 2020 01:09:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/3] ptp: add ability to configure duty cycle
 for periodic output
Message-ID: <20200716220923.k6vwsjdk2os4rlrp@skbuf>
References: <20200716212032.1024188-1-olteanv@gmail.com>
 <20200716212032.1024188-2-olteanv@gmail.com>
 <56860b5e-95ff-ae59-a20d-9873af44de67@intel.com>
 <20200716214927.s4uu36twwegarznm@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716214927.s4uu36twwegarznm@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 12:49:27AM +0300, Vladimir Oltean wrote:
> On Thu, Jul 16, 2020 at 02:36:45PM -0700, Jacob Keller wrote:
> > 
> > 
> > On 7/16/2020 2:20 PM, Vladimir Oltean wrote:
> > > There are external event timestampers (PHCs with support for
> > > PTP_EXTTS_REQUEST) that timestamp both event edges.
> > > 
> > > When those edges are very close (such as in the case of a short pulse),
> > > there is a chance that the collected timestamp might be of the rising,
> > > or of the falling edge, we never know.
> > > 
> > > There are also PHCs capable of generating periodic output with a
> > > configurable duty cycle. This is good news, because we can space the
> > > rising and falling edge out enough in time, that the risks to overrun
> > > the 1-entry timestamp FIFO of the extts PHC are lower (example: the
> > > perout PHC can be configured for a period of 1 second, and an "on" time
> > > of 0.5 seconds, resulting in a duty cycle of 50%).
> > > 
> > > A flag is introduced for signaling that an on time is present in the
> > > perout request structure, for preserving compatibility. Logically
> > > speaking, the duty cycle cannot exceed 100% and the PTP core checks for
> > > this.
> > 
> > I was thinking whether it made sense to support over 50% since in theory
> > you could change start time and the duty cycle to specify the shifted
> > wave over? but I guess it doesn't really make much of a difference to
> > support all the way up to 100%.
> > 
> 
> Only if you also support polarity, and we don't support polarity. It's
> always high first, then low.
> 

Sorry for the imprecise statement.
If you look at things from the perspective of the signal itself, the
statement is correct.
If you look at them from the perspective of the imaginary grid drawn by
the integer multiples of the period, in the PHC's time (a digital
counter), the correct statement would be that "it's always rising edge
first, then falling edge".  And then the phase is just the delta between
these 2 points of reference.

Let me annotate this:

     t_on
     <------>
     t_period
     <--------->
phase
   <->
>    +------+  +------+  +------+  +------+  +------+  +------+  +------+
>    |      |  |      |  |      |  |      |  |      |  |      |  |      |
>  --+      +--+      +--+      +--+      +--+      +--+      +--+      +
> 
>  +---------+---------+---------+---------+---------+---------+--------->
   t=1000    t=1010    t=1020    t=1030    t=1040    t=1050    t=1060
>  period=10                                                          time
>  phase=2
>  on = 7
> 
> There's no other way to obtain this signal which has a duty cycle > 50%
> by specifying a duty cycle < 50%.
> 

Thanks,
-Vladimir
