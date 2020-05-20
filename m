Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8090B1DA612
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 02:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgETAGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 20:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgETAGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 20:06:46 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACFCC061A0F
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 17:06:46 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j21so596864pgb.7
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 17:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vqQJphs4dbH8l1OCiHVqe97WM4gwnpKo7IbEOxUcuq8=;
        b=WDGtbCVBE8fAUQyK7b2ulxbQd5NoTpIwjwmAiZ+xjWv23qgDFYqB+n3uEENMJF4evR
         eQybQUIovab5oL9uP2JzO7/swZQR7Lac/N+9LuMDnYRN/vux1dRM8Ai+UvXrMQDNSXds
         giu/CUiz0LCzZo+rFtSn5hr/VzyiBazjBkDWxSalBmaM+kZsF/jtgZp30ifXQT1tndDm
         K+cmlhk0mNBeLKQKLjGb4kejQKR5OPHQmKhNzy3M33KYeBeHFzFAx78BBq1Ia0Aqb/q7
         iy8kDskGmclrjdQEtx9kzAivf9ZcpoqlwCE0HuGoG13qLjJvN7c+Be8TZbWz/AnWavDM
         W6Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vqQJphs4dbH8l1OCiHVqe97WM4gwnpKo7IbEOxUcuq8=;
        b=A3rW0iB/NdYDqym57b2hSvZkheW0aSXy0k4UvNu7Q9C7EWFbke0wP5BxWNZLT09yAT
         DHRRipDmhX5dZ9I+hI2Q4rxSFBeHszspmJrHM6GXcMd0kO89WcUdVhVMAmb9/q4RaQmt
         SY+rtQn33jl++VdYcqE5V5qLK+M9d3kmSS6gR7cC9dn9YtIRRhhLb3JPYsh/wZCAdSfq
         iqfAAtOh81piZOpgcG6OY5z7MzXDBQmEYDLv4afyKrovz/tgaReloFbtlKyyYBgC61Qu
         ds1ZBTZHCl7CKqg3Z5Kzz1RAhzalKmWwwmadbp6A6JGN3HVxBA4gx31QP/Cf86Iau+FP
         0ZOA==
X-Gm-Message-State: AOAM530qIeQSRshYVapT047OXbHwZD/XzlArM9ipes6lWTY727/q/sG0
        iAvlJeGHHoqm8sTvWiOLkTTrsAhyB6+j8Q==
X-Google-Smtp-Source: ABdhPJxROAqekSmuMlHLMi/sAPCSy2KV5BTqjcZH0X10PmVEw2MHWo2h4USoKLaDBzISBwMyAVnWjg==
X-Received: by 2002:a62:1cc9:: with SMTP id c192mr1482493pfc.197.1589933205590;
        Tue, 19 May 2020 17:06:45 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v1sm452386pgl.11.2020.05.19.17.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 17:06:45 -0700 (PDT)
Date:   Tue, 19 May 2020 17:06:37 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of
 a seqcount
Message-ID: <20200519170637.56d1a20a@hermes.lan>
In-Reply-To: <87lfln5w61.fsf@nanos.tec.linutronix.de>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
        <20200519214547.352050-2-a.darwish@linutronix.de>
        <20200519150159.4d91af93@hermes.lan>
        <87v9kr5zt7.fsf@nanos.tec.linutronix.de>
        <20200519161141.5fbab730@hermes.lan>
        <87lfln5w61.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 01:42:30 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> Stephen Hemminger <stephen@networkplumber.org> writes:
> > On Wed, 20 May 2020 00:23:48 +0200
> > Thomas Gleixner <tglx@linutronix.de> wrote:  
> >> No. We did not. -ENOTESTCASE  
> >
> > Please try, it isn't that hard..
> >
> > # time for ((i=0;i<1000;i++)); do ip li add dev dummy$i type dummy; done
> >
> > real	0m17.002s
> > user	0m1.064s
> > sys	0m0.375s  
> 
> And that solves the incorrectness of the current code in which way?

Agree that the current code is has evolved over time to a state where it is not
correct in the case of Preempt-RT. The motivation for the changes to seqcount
goes back many years when there were ISP's that were concerned about scaling of tunnels, vlans etc.

Is it too much to ask for a simple before/after test of your patch as part 
of the submission. You probably measure latency changes to the nanosecond.

Getting it correct without causing user complaints.


