Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B772B14BD
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 04:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgKMDbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 22:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgKMDbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 22:31:44 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E22FC0613D1;
        Thu, 12 Nov 2020 19:31:44 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id b63so2841976pfg.12;
        Thu, 12 Nov 2020 19:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t/Lu3UdKToQwiBVeUSQQ3sQ7DPauKi80eKVhQbk9Mb4=;
        b=o8xYY0BvaaysquhJMLCvdB0C1g3AXuXJoUlhj7BrXavh7di6CkfQLhFUUDnUAJfGi/
         OWA7n17t1BHzHwL8zK9KqdgFlYH2LWTcC/miVXkOLq0J6IUZd5cKbdmnNQvwglvHK0p9
         rSXGQ8i7ONvhUiovTAxxjxBFH18kj2oJDY/aZG+b2T/86wPaJLqgnXTpUWCnLTPmcv6O
         i6swrWNBcM42nsGZuZzxlIfHyDBQPfT+ZLbF0k4qKLk2v/nQm4weIxaa7WmVzV2pIy88
         dEo6AhOGcLzpSxNVTA4DdlSK2Ja/xsc/v/y5rVz1Hylwf9D1Oer2Xq7nVA2dbCAe9w4I
         kd9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t/Lu3UdKToQwiBVeUSQQ3sQ7DPauKi80eKVhQbk9Mb4=;
        b=CIwRqH4rRC1k7KICfp2YHFppcFTe3XW2TV+wp0Y8DA2rhbBU1jw+NddgjseQ8GLqKb
         9K6J7rH2ed25qQh8HQDN3PBfMRn25qHWkGAVniKQAO92k9fZQbne2Mu70EwvmIXgEJ6w
         6E5nBdIS5Tmo8JnF+JyIUn9xsPB5wDeFdAyPF0qmX7ppiNnPwKK0yb8xxHtQ7Vzm+sj4
         cl+BUBWj74o5tUQltl9i7zSdsHRQYCdhC26sOJhVhk+Fonw6J0elRNgyl7JfnU58vA9T
         PmHw8CFKawYpDoJrOu+UlaVhs28ZK7MJkflcYCLCwAPuHxAtt2vCCQztwOb6VqWMYsB4
         ez3g==
X-Gm-Message-State: AOAM5309Og3spSLtvoCK2dh9GnuHUwuFDPmb8XxFGbMKj+Tz1k3u1Pco
        5lqEiNNWYHWxnc4lzCnUI2I=
X-Google-Smtp-Source: ABdhPJxe63jr2zZ4QoY3tfHDmEeppNgHRAhVkYLDkE1ldkS5htiMTeho8maabrDNsi7r/4ZvtaUvTA==
X-Received: by 2002:a17:90b:1108:: with SMTP id gi8mr564656pjb.56.1605238303724;
        Thu, 12 Nov 2020 19:31:43 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id t64sm8330506pfd.36.2020.11.12.19.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 19:31:43 -0800 (PST)
Date:   Thu, 12 Nov 2020 19:31:39 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Christian Eggers <ceggers@arri.de>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 09/11] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201113033139.GC32138@hoboy.vegasvil.org>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-10-ceggers@arri.de>
 <20201113024020.ixzrpjxjfwme3wur@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113024020.ixzrpjxjfwme3wur@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 04:40:20AM +0200, Vladimir Oltean wrote:
> > @@ -103,6 +108,10 @@ static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
> >  	if (ret)
> >  		goto error_return;
> >
> > +	spin_lock_irqsave(&dev->ptp_clock_lock, flags);
> 
> I believe that spin_lock_irqsave is unnecessary, since there is no code
> that runs in hardirq context.

The .adjtime method is in a system call context.  If all of the code
that manipulates dev->ptp_clock_time can sleep, then you can use a
mutex.  Otherwise spin_lock_irqsave is the safe choice.

Thanks,
Richard
