Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 437B6AD35F
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 09:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731728AbfIIHEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 03:04:33 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46480 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727251AbfIIHEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 03:04:33 -0400
Received: by mail-pg1-f196.google.com with SMTP id m3so7239076pgv.13
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 00:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eqw3HOOfxTs9NaAddaBqlYZJ54dXpmL3pbtIyuj1XQo=;
        b=B5DWjLj4wI65xH6idZbnGvk1ZEJmichHhs70VnyF4HJbZkdBvessFd+RuG2i3hxQt9
         wAGUTIWIaEiSEQFxIMZEW9/tk6kDOUMu4m+YYSxm89GrnO5DVCN1CaH+N+0IEfCRkaXi
         mW43LA4m/ujfxQeLRa9UjgmtcG9ZulDs7+xL/5MCpm8SmO5EbsvrymzT1+rd2ZEcmvFr
         vbX/5+UmdXUXHjTL0HogwVfHrYjtTfYe61D0jHaya6gjSzoAGMnkMc5GUpf0zz6q9TYA
         dD8oIDastOW501cRAjPIBrGObaNe/C1otifQzpaMVjNIXjL1l41I9HP/1PLlNeaP32Lw
         oYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eqw3HOOfxTs9NaAddaBqlYZJ54dXpmL3pbtIyuj1XQo=;
        b=L5drnDNU4kaAnlnv1jvIXDoJBdSkLUDSDpYJExnLXpmgES+0voQeOyijgpEzPzskIn
         CNRh40aP2Q1eTEvgz3rUayTjairfJ13l2+UoQsk1Kcw4wV74QsJGUa7k86z3vHylUpkn
         XBvIxNtjyILrqTgLEJDYs6HKfO1dOupKWUJLDEbWZkyGHDmECI2pbTkJ4GEnBUJACpGB
         RhYKlMQYENCFchvYO0BGhnvv8++ZUl0kh/UEbj4uhATGaJdZPzZa17eTTZfn1m2Xgf0f
         r3cclV5RHpwB+5h0RgsOUxLL/VGxv5iLUYU7Sel3c0j7FwABcA4c2VVsY91X6uHA6LT2
         ALeQ==
X-Gm-Message-State: APjAAAXloCNOrnwat+XCv3dkMYj+DYJ2iAwjiaFO2rE80Y6m6a7ibGYu
        zB9rtU/kBJKRuXpcVOvWgA0=
X-Google-Smtp-Source: APXvYqzJzvgKx/IOmTtMJn060u+s7O41s0EGk/IqC78AX93+dnQqJfwBaWyj+iQi6O3cJ5n18FVvXg==
X-Received: by 2002:a63:9e56:: with SMTP id r22mr20274787pgo.221.1568012672606;
        Mon, 09 Sep 2019 00:04:32 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id y192sm19496718pfg.141.2019.09.09.00.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 00:04:31 -0700 (PDT)
Date:   Mon, 9 Sep 2019 00:04:29 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, vedang.patel@intel.com,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, netdev@vger.kernel.org
Subject: Re: [PATCH v1 net-next 00/15] tc-taprio offload for SJA1105 DSA
Message-ID: <20190909070429.GB27043@localhost>
References: <20190902162544.24613-1-olteanv@gmail.com>
 <20190906.145403.657322945046640538.davem@davemloft.net>
 <20190907144548.GA21922@lunn.ch>
 <CA+h21hqLF1gE+aDH9xQPadCuo6ih=xWY73JZvg7c58C1tC+0Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqLF1gE+aDH9xQPadCuo6ih=xWY73JZvg7c58C1tC+0Jg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 08, 2019 at 12:07:27PM +0100, Vladimir Oltean wrote:
> I think Richard has been there when the taprio, etf qdiscs, SO_TXTIME
> were first defined and developed:
> https://patchwork.ozlabs.org/cover/808504/
> I expect he is capable of delivering a competent review of the entire
> series, possibly way more competent than my patch set itself.

I am really not familiar with the taprio/qdisc stuff.  Sorry.
 
> Additionally, the 802.1AS PTP profile even calls for switches and
> end-stations to use timestamping counters that are free-running, and
> scale&rate-correct those in software - due to a perceived "double
> feedback loop", or "changing the ruler while measuring with it". Now
> I'm no expert at all, but it would be interesting if we went on with
> the discussion in the direction of what Linux is currently
> understanding by a "free-running" PTP counter. On one hand there's the
> timecounter/cyclecounter in the kernel which makes for a
> software-corrected PHC, and on the other there's the free_running
> option in linuxptp which makes for a "nowhere-corrected" PHC that is
> only being used in the E2E_TC and P2P_TC profiles. But user space
> otherwise has no insight into the PHC implementation from the kernel,
> and "free_running" from ptp4l can't really be used to implement the
> synchronization mechanism required by 802.1AS.

That just isn't true.  We have already done this for end stations.

> To me, the most striking aspect is that this particular recommendation
> from 802.1AS is at direct odds with 802.1Qbv (time-based egress) /
> 802.1Qci (time-based ingress policing) which clearly require a PTP
> counter in the NIC that ticks to the wall clock, and not to a random
> free-running time since boot up. I simply can't seem to reconcile the
> two.

Well, yeah.  The various PTP standards and profiles dream up whatever
they want.  The HW we get dictates what is actually possible.

> But let's leave 802.1AS aside for a second - that's not what the patch
> set is about, but rather a bit of background on why there are 2 PTP
> clocks in this switch, and why I'm switching from one to the other.
> Richard didn't really warm up to the phc2sys-to-itself idea in the
> past, and opted for simplicity: just use the hardware-corrected
> PTPCLKVAL for everything, which is exactly what I'm doing as of now.

If you really want to make an 802.1-AS bridge, then

1. You can leave the clock free running, and

2. you don't need to synchronize the Linux system clock at all.

Thanks,
Richard
