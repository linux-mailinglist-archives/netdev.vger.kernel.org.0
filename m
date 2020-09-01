Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6586259082
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgIAOcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbgIAOWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 10:22:49 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15A4C061244;
        Tue,  1 Sep 2020 07:22:47 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id z22so1920441ejl.7;
        Tue, 01 Sep 2020 07:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KDkiB9BCvl2LEGL4AwMELN+jD38wa8iIZfBR6WIjqwI=;
        b=FJT3ngsLt2Vv6b+aR0Xh8VuoqaF5Wi2KdXUsoXGCOQVq9GY1loIqkkAi3QcNwf8gMD
         tAGWUa2x+XdcL7mFWCQW8PHImjr0QdTTGoNc2eu9mFGLJ4ADDVl7s2bgfWMIydh1Mvfd
         Jbw7k75r1urb6b5zPVL9FdzLc0W2soApTLnspqh1wE4+/OKGxK6MWFv44RM2ttDLlKdb
         sY/w84yAFuDU2MYgA0WlGiapeUfvRUrgfJOJgtpwYciLCC05DbnMcScwdS1rPZaoWK4Z
         3wLWNTWWe67L9knRvB+Q1aadQznzY4lL8nO1woKV6lTWen3s470TRPwRX7XF7kmpm8sB
         UMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KDkiB9BCvl2LEGL4AwMELN+jD38wa8iIZfBR6WIjqwI=;
        b=eDpD8HJqAAF1sdAFECE8ZHI0A4J9NYBA9Ifj/+TR9QuF73tXOdhGwtPA3TNBSFFFaw
         Jqk/PHtZPSFYWMHLE66bwRKbHwblV8R0DwKK507lNHK7aKyyOP6CwKPdiGKVidlSGsuS
         r654xM8IpD5qY/vnxhNMbpEcFZY6WtMLljLfSxPU11YykKsS+DAavCg4ICkm15+JE1Nd
         ZD+jOMKHmrjAisdPxHKbDGPs1+pu5f80Z2zcqyObnChDbh/0EdVakdwhQDv2hOmr2UU9
         +Vs8+X0jVyclsZPm+6K52uERiLyXvqXdZ9EKmueMgh18OrLZ5F2yDdMtUcieLvA8SY/N
         r3AA==
X-Gm-Message-State: AOAM533cDdsPWWknRgCDSXhNT7MS3Nc5n64V3avnYK53ClOIF7ozNoPa
        Nd3FqmOw8dvLXSUuBs912+gf5XR6Yvs=
X-Google-Smtp-Source: ABdhPJzdzr6EGQ1iSKBuQLY3/jYf29synEUyluYJ1F4lvs1Nmo/VcaXazws3aQk3D6mF14U++m7+NQ==
X-Received: by 2002:a17:907:7215:: with SMTP id dr21mr1858191ejc.68.1598970166353;
        Tue, 01 Sep 2020 07:22:46 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id v17sm1444431ejj.55.2020.09.01.07.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 07:22:45 -0700 (PDT)
Date:   Tue, 1 Sep 2020 17:22:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v4 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek
 switches
Message-ID: <20200901142243.2jrurmfmh6znosxd@skbuf>
References: <20200901125014.17801-1-kurt@linutronix.de>
 <20200901125014.17801-3-kurt@linutronix.de>
 <20200901134020.53vob6fis5af7nig@skbuf>
 <87y2ltegnd.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2ltegnd.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 04:05:42PM +0200, Kurt Kanzenbach wrote:
> Hi Vladimir,
> 
> On Tue Sep 01 2020, Vladimir Oltean wrote:
> > Hi Kurt,
> >
> > On Tue, Sep 01, 2020 at 02:50:09PM +0200, Kurt Kanzenbach wrote:
> [snip]
> >> +struct hellcreek {
> >> +	const struct hellcreek_platform_data *pdata;
> >> +	struct device *dev;
> >> +	struct dsa_switch *ds;
> >> +	struct hellcreek_port *ports;
> >> +	struct mutex reg_lock;	/* Switch IP register lock */
> >
> > Pardon me asking, but I went back through the previous review comments
> > and I didn't see this being asked.
> 
> It was asked multiple times, why there was a spinlock without interrupts
> being registered (see e.g. [1], [2]). I've used the spinlock variant,
> because the previously used hrtimers act like interrupts. As there are
> no timers anymore, there's no need for spinlocks and mutexes can be
> used.
> 

That, yes, I remember, but not why the reg_lock exists in the first
place.

> Florian Fainelli also asked if the reg lock can be removed
> completely. See below.
> 

Missed your answer on that.

> >
> > What is the register lock protecting against, exactly?
> 
> A lot of the register operations work by:
> 
>  * Select port, priority, vlan or counter
>  * Configure it
> 
> These sequences have to be atomic. That's what I wanted to ensure.
> 

So, let me rephrase. Is there any code path that is broken, even if only
theoretically, if you remove the reg_lock?

> Thanks,
> Kurt
> 
> [1] - https://lkml.kernel.org/netdev/def49ff6-72fe-7ca0-9e00-863c314c1c3d@gmail.com/
> [2] - https://lkml.kernel.org/netdev/20200624130318.GD7247@localhost/

Thanks,
-Vladimir
