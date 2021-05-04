Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4ADD37309E
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhEDTSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 15:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbhEDTSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 15:18:39 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6312DC061574;
        Tue,  4 May 2021 12:17:43 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id f24so14885189ejc.6;
        Tue, 04 May 2021 12:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o/YSgyoStELVjmwvVjY4WityzMhKVw/+pPPsl07P0wA=;
        b=QQ4FJRoTLq3jR8e6Rys7S0/eyU7qiTDxmTstOxeY0MLFeLxcqBBqM0o/0cDON6pRUV
         4qHk+m5N5Fw+xsCy/5dKTVasE6SJe8dR7Wrk3TW7fauwlK26u0A//xsnPogiLhRaFfzP
         fXW1xNh0zaF/MEMa1vEvCdZDnPNsmP54PFfhauz2Ob5z03al0wmXNzJ0lPwqWbAcv3mJ
         6U25GbDwn3O+MlCup2kP9y/Im50l1lV5XAc5ughsts6NGQTAx7rpix8VQ/XNgIRHWQi/
         jcyMJ7sTIoamkTxtALkKv/iVFpdrLrlIrlL3pJLEq7n1tALP4Pmo3/PwhRkrX7XvlhUs
         z+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o/YSgyoStELVjmwvVjY4WityzMhKVw/+pPPsl07P0wA=;
        b=i66Clq390WKf0MnlqqOY6l/Swfo7A0SyCxA/TwYNrXV0zYVkELMPykCFlxoMOJXVG6
         MrmJ2BPOjkiO859wxAKoqk3ENzPH+G0H4vRQPSGeSIcJukAajNWZZnN7iBYi+P3WxrE9
         VhlMre+ly/EwCOTxkGPj4RhdG/u6wz0v2vmYVx6ISgiqbZkU7KUx7Rj6Fp5JLwC1DwSv
         UtankVyzP7hkocuHOQLfdZjath3UL1k+0FBHIOTZStr2L4kNIEoDSH/k37cWHBjJohcc
         8JLmMJdLF6kRvdGuS3mf4kaBVcgkon1wuZmXATq7VYPR8qbL9ZqpLH2A5ClXSanXV8G+
         x7wg==
X-Gm-Message-State: AOAM531GgJwaGEj0UgNubO8ELoy5VMjkQezgYGwFMY4j9ITxlahTeYJZ
        2QWc81+Vv0Yih8lfNKr8IGA=
X-Google-Smtp-Source: ABdhPJx9hKET6uKlNJAPMjx6REVTSM5pk2Kuya7T+YEUEScYmsfsXcvnk+IeKD2BaZsT0GgPGVpOEA==
X-Received: by 2002:a17:906:2287:: with SMTP id p7mr23238378eja.377.1620155862013;
        Tue, 04 May 2021 12:17:42 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id lc1sm1833882ejb.39.2021.05.04.12.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 12:17:41 -0700 (PDT)
Date:   Tue, 4 May 2021 22:17:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     xiaoliang.yang_1@nxp.com, Arvid.Brodin@xdin.com,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, andre.guedes@linux.intel.com,
        claudiu.manoil@nxp.com, colin.king@canonical.com,
        davem@davemloft.net, idosch@mellanox.com,
        ivan.khoronzhuk@linaro.org, jiri@mellanox.com,
        joergen.andreasen@microchip.com, leoyang.li@nxp.com,
        linux-kernel@vger.kernel.org, m-karicheri2@ti.com,
        michael.chan@broadcom.com, mingkai.hu@nxp.com,
        netdev@vger.kernel.org, po.liu@nxp.com, saeedm@mellanox.com,
        vinicius.gomes@intel.com, vladimir.oltean@nxp.com,
        yuehaibing@huawei.com
Subject: Re: [net-next] net: dsa: felix: disable always guard band bit for
 TAS config
Message-ID: <20210504191739.73oejybqb6z7dlxr@skbuf>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210504170514.10729-1-michael@walle.cc>
 <20210504181833.w2pecbp2qpuiactv@skbuf>
 <c7618025da6723418c56a54fe4683bd7@walle.cc>
 <20210504185040.ftkub3ropuacmyel@skbuf>
 <ccb40b7fd18b51ecfc3f849a47378c54@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccb40b7fd18b51ecfc3f849a47378c54@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 09:08:00PM +0200, Michael Walle wrote:
> > > > > As explained in another mail in this thread, all queues are marked as
> > > > > scheduled. So this is actually a no-op, correct? It doesn't matter if
> > > > > it set or not set for now. Dunno why we even care for this bit then.
> > > >
> > > > It matters because ALWAYS_GUARD_BAND_SCH_Q reduces the available
> > > > throughput when set.
> > > 
> > > Ahh, I see now. All queues are "scheduled" but the guard band only
> > > applies
> > > for "non-scheduled" -> "scheduled" transitions. So the guard band is
> > > never
> > > applied, right? Is that really what we want?
> > 
> > Xiaoliang explained that yes, this is what we want. If the end user
> > wants a guard band they can explicitly add a "sched-entry 00" in the
> > tc-taprio config.
> 
> You're disabling the guard band, then. I figured, but isn't that
> suprising for the user? Who else implements taprio? Do they do it in the
> same way? I mean this behavior is passed right to the userspace and have
> a direct impact on how it is configured. Of course a user can add it
> manually, but I'm not sure that is what we want here. At least it needs
> to be documented somewhere. Or maybe it should be a switchable option.
> 
> Consider the following:
> sched-entry S 01 25000
> sched-entry S fe 175000
> basetime 0
> 
> Doesn't guarantee, that queue 0 is available at the beginning of
> the cycle, in the worst case it takes up to
> <begin of cycle> + ~12.5us until the frame makes it through (given
> gigabit and 1518b frames).
> 
> Btw. there are also other implementations which don't need a guard
> band (because they are store-and-forward and cound the remaining
> bytes). So yes, using a guard band and scheduling is degrading the
> performance.

What is surprising for the user, and I mentioned this already in another
thread on this patch, is that the Felix switch overruns the time gate (a
packet taking 2 us to transmit will start transmission even if there is
only 1 us left of its time slot, delaying the packets from the next time
slot by 1 us). I guess that this is why the ALWAYS_GUARD_BAND_SCH_Q bit
exists, as a way to avoid these overruns, but it is a bit of a poor tool
for that job. Anyway, right now we disable it and live with the overruns.

FWIW, the ENETC does not overrun the time gate, the SJA1105 does. You
can't really tell just by looking at the driver code, just by testing.
It's a bit of a crapshoot.

> > Sorry, I don't understand what you mean to say here.
> 
> I doubt that ALWAYS_GUARD_BAND_SCH_Q is a per-port setting. But that is
> only a guess. One would have to check with the IP vendor.

Probably not, but I'm not sure that this is relevant one way or another,
as the driver unconditionally clears it regardless of port (or unconditionally
set it, before Xiaoliang's patch).

> > > > May I know what drew your attention to this patch? Is there something
> > > > wrong?
> 
> See private mail.

Responded. I'm really curious if this change makes any difference at all
to your use case.
