Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753CC251567
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgHYJc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728059AbgHYJcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:32:24 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2D3C061574;
        Tue, 25 Aug 2020 02:32:24 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id b17so7352757ejq.8;
        Tue, 25 Aug 2020 02:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+OL1BkKHPa8TO+ySMXJR94J2ke1VHUzpaMpCsDy49Uc=;
        b=sIJwn8VJ/fl4uKwSIoVsD1/JlWGZN9GOeQe3Q7xG77WwSNi/GpYpklD+Rsx5Y9PTG8
         VPZ8np6Cg2DKZs0V/X8i+AB6H0sjxW0XkqJhozfgjGOGsD+5eK2IbXDUd1KA7i5P362Q
         eyzhzr9hUmB100MXL8FNwA8lMSs5HETaGDJmP3Rm5f6vzD2nfW6M2Ckuvx5zwbZwya7m
         JEP26uvbfGEDav8bYbzO/MEK7QI2iQHCVqmV93XGRsOYFJMldE2+DxOZhQRGSdY4JnTi
         yiZ31p4CR2kdYcLsc7OzlrTIheEZXhCJq/YjRkaw5Tfk8jogbnhmkF+q7JwLblYCxTK2
         iODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+OL1BkKHPa8TO+ySMXJR94J2ke1VHUzpaMpCsDy49Uc=;
        b=XsfHzy/nTghSTwq6/tjMcRhgvHfkVOtwwQseMSttbjawGYF7N+tDKGT9+V1H4UUIUu
         BIi7qxNFIL/Jfg2L5WcnOlZ83hcNexY/c6kw3qO6P4Cdwb8hZdRZ6lsq6q9P7RpqfpoY
         9CaSBTA7UlN39UESxJdg2zkwTxaEt51xGXQt7ZI9+mUrfA1By1agZfJQM89JKC4VOy/N
         9enlWb5Dw/qPC3kVO7DPSPDzc1j9w+6YKiIsEADd9E2SW9Kzm09vsjv0PlKBIAtfDW7h
         WpbmCYKwb7TjXqPmBAKnvN/4c8nT9uI9MGdVhCzN93niQTFsh7sC1UGpTe9yljmbuzov
         ng6g==
X-Gm-Message-State: AOAM533YQSDw9juuOIa+odpA4KfNB/h8CZ4xRG94W00aRzM6qH+zFSmA
        /I/8l5H+9K5SSXZV0Zc3hec=
X-Google-Smtp-Source: ABdhPJyJibwrKvFmGrHifck0mtLct24rvFhYheJeMPjbYsJJLnDUGC4LhSGzTJII8y99QwwCJqsmKQ==
X-Received: by 2002:a17:906:35d6:: with SMTP id p22mr1478713ejb.221.1598347942793;
        Tue, 25 Aug 2020 02:32:22 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id c4sm482930edr.49.2020.08.25.02.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 02:32:22 -0700 (PDT)
Date:   Tue, 25 Aug 2020 12:32:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
Message-ID: <20200825093219.bybzzpyfbbccjanf@skbuf>
References: <20200820081118.10105-1-kurt@linutronix.de>
 <20200820081118.10105-6-kurt@linutronix.de>
 <87pn7ftx6b.fsf@intel.com>
 <87bliz13kj.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bliz13kj.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 11:23:56AM +0200, Kurt Kanzenbach wrote:
> On Mon Aug 24 2020, Vinicius Costa Gomes wrote:
> > Hi,
> >
> > Kurt Kanzenbach <kurt@linutronix.de> writes:
> >
> [snip]
> >> +	/* Setup timer for schedule switch: The IP core only allows to set a
> >> +	 * cycle start timer 8 seconds in the future. This is why we setup the
> >> +	 * hritmer to base_time - 5 seconds. Then, we have enough time to
> >> +	 * activate IP core's EST timer.
> >> +	 */
> >> +	start = ktime_sub_ns(schedule->base_time, (u64)5 * NSEC_PER_SEC);
> >> +	hrtimer_start_range_ns(&hellcreek_port->cycle_start_timer, start,
> >> +			       NSEC_PER_SEC, HRTIMER_MODE_ABS);
> >
> > If we are talking about seconds here, I don't think you need to use a
> > hrtimer, you could use a workqueue/delayed_work. Should make things a
> > bit simpler.
> 
> I've used hrtimers for one reason: The hrtimer provides a way to fire at
> an absolute base time based on CLOCK_TAI. All the other facilities such
> as workqueues, timer list timers, etc do not.

That still doesn't justify the complexity of irqsave spinlocks and such.
You could just as well schedule a workqueue from that hrtimer and have
process context...

Thanks,
-Vladimir
