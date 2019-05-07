Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01C0A164F7
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 15:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfEGNt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 09:49:56 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42169 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfEGNt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 09:49:56 -0400
Received: by mail-pg1-f194.google.com with SMTP id p6so8338433pgh.9;
        Tue, 07 May 2019 06:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=S8BQEP1OV6vKoSe5VDyJlLX4UR1XhupCQW202rhq/sQ=;
        b=oMQjJcPiNX92IlwTDMAW4qr/DdkOFqHLv0mxlbPfOeLaWsnqFZadYEibjkDIgY2NoM
         /65COGgPxkzIo+amIzo6LPYgGDGhJxntl4IHC1R/RwjQFVpiP4UXGWuwbHOfyZ8euQcE
         ir9EJkZF9XcN0WR7nfl/JhEl0+MZHZx/FFJIdaszpfSQ9rsW7hA8LTHBLq1t+IWpekyS
         iyEd6m3PD3RorhuG5Xmkci0vdJw7KlYnHW5KDkeG+yBLz7q4YH3GU/dqJHBkQriNNSBe
         xEnRNdM5sxiM7Y2G+ogZwJCOOm3oWbLZc2p+U6WW1oVu9v/vdRNQ/7P9oOscBiCmAEP7
         h3lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=S8BQEP1OV6vKoSe5VDyJlLX4UR1XhupCQW202rhq/sQ=;
        b=n756w1MMj98gfY5/ecpQf2FAz6L8krOHIQ7wUp/jrNrau5HmwyznFnslDXNWE64rbO
         btBZHJwFFYthqJy513dd76mgKOj4WZ3hUOSn7+KKiqeNR0B4hrPTqbmviGPBi4h5iPIE
         kL25aBacXwwlJcLeUB6HS04s35B41QgTvFycd3tyKR8DiHS0/hhBWR2v7bcAQcQrXQBB
         8huiArFRVqKfZ+flRhl+gKr/0eQodjfw0f4pEvLlsXQyj+uO9eRR/GomCBTJ2lz0eDLM
         tNk/5TFSCNAA3qJyrURUBXcJsFhn1BUtjEOwmBJ0rxTXFINbu+3UfKPlVKYVu3CVDfMq
         MS3Q==
X-Gm-Message-State: APjAAAVU3gQ8lqLT6uUiFR+sExke+Gvht5nCTarVGQ7gDSBpYCoc9FU1
        eola/cnUUyGPY7W0RtLcj2Q=
X-Google-Smtp-Source: APXvYqwNMrdvjlCOgIU9TBbSh3DwQp1FscE2sA0W7mHk+F+dufo6InfjIlXwfy6OIa5H5Al1dkWeIA==
X-Received: by 2002:aa7:98c6:: with SMTP id e6mr2436297pfm.191.1557236995744;
        Tue, 07 May 2019 06:49:55 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id v6sm8275551pgk.77.2019.05.07.06.49.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 06:49:54 -0700 (PDT)
Date:   Tue, 7 May 2019 06:49:52 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Po Liu <po.liu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Leo Li <leoyang.li@nxp.com>, Roy Zang <roy.zang@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        "deepa.kernel@gmail.com" <deepa.kernel@gmail.com>
Subject: Re: [PATCH v1] timer:clock:ptp: add support the dynamic posix clock
 alarm set for ptp
Message-ID: <20190507134952.uqqxmhinv75actbh@localhost>
References: <1557032106-28041-1-git-send-email-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557032106-28041-1-git-send-email-Po.Liu@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 05, 2019 at 05:02:05AM +0000, Po Liu wrote:
> Current kernel code do not support the dynamic posix clock alarm set.
> This code would support it by the posix timer structure.
> 
> 319  const struct k_clock clock_posix_dynamic = {
> 
> 320         .clock_getres   = pc_clock_getres,
> 321         .clock_set      = pc_clock_settime,
> 322         .clock_get      = pc_clock_gettime,
> 323         .clock_adj      = pc_clock_adjtime,
> 324 +       .timer_create   = pc_timer_create,
> 325 +       .timer_del      = pc_timer_delete,
> 326 +       .timer_set      = pc_timer_set,
> 327 +       .timer_arm      = pc_timer_arm,
> }
> 

Sorry, NAK, since we decided some time ago not to support timer_*
operations on dynamic clocks.  You get much better application level
timer performance by synchronizing CLOCK_REALTIME to your PHC and
using clock_nanosleep() with CLOCK_REALTIME or CLOCK_MONOTONIC.

> This won't change the user space system call code. Normally the user
> space set alarm by timer_create() and timer_settime(). Reference code
> are tools/testing/selftests/ptp/testptp.c.

That program still has misleading examples.  Sorry about that.  I'll
submit a patch to remove them.

> +static int pc_timer_create(struct k_itimer *new_timer)
> +{
> +	return 0;
> +}
> +

This of course would never work.  Consider what happens when two or
more timers are created and armed.

Thanks,
Richard
