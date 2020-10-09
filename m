Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B416288CF4
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389340AbgJIPj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389165AbgJIPj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:39:56 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82229C0613D2;
        Fri,  9 Oct 2020 08:39:56 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602257994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DKIXFbRq/5saVEqi5e9AJzND0fz4fM2p8K38phy76Vg=;
        b=Fc6iiw16D29AtwKBY60vWjppr2aupIpDaNl1hH2g77wDTT57xkgogSwE8P1rAOd5F2TEtQ
        PzxaUcdtwE5DH1HRhXZgt0iXDB0LLDm4C11qukXlSXZy42d6EcU23o9VJT7beYXQmVFv0A
        9j+O1lC3T6Hoz3VXegXfCoMNxbghrKjPs6Y8p6qO3X7U1QnzlwfEs9/z+3uCq7rcJL7qUz
        PpCggkf6KUoCkA0g/+S2QdCcE/F3TSkWoSlcrVnaI7nlBPxnpMIXIyxaTcPI95Pn2DNjDl
        DPonhCjXCL2jM1EA3KRNx64l3B5Rz7E2++f8INXwe9g/wh8AVLowQrwg8kuvLw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602257994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DKIXFbRq/5saVEqi5e9AJzND0fz4fM2p8K38phy76Vg=;
        b=laJxFen859ZoMvaXCNvBrCfBIVOaA1gIbWEPmNsDPChDjbgoucSBnnLQFHbvRMVgEXYxa1
        XEQBSwcE9OFa+GBQ==
To:     "Meisinger\, Andreas" <andreas.meisinger@siemens.com>,
        "vinicius.gomes\@intel.com" <vinicius.gomes@intel.com>,
        "Geva\, Erez" <erez.geva.ext@siemens.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong\@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "jhs\@mojatatu.com" <jhs@mojatatu.com>,
        "jiri\@resnulli.us" <jiri@resnulli.us>,
        "avagin\@gmail.com" <avagin@gmail.com>,
        "0x7f454c46\@gmail.com" <0x7f454c46@gmail.com>,
        "ebiederm\@xmission.com" <ebiederm@xmission.com>,
        "mingo\@kernel.org" <mingo@kernel.org>,
        "john.stultz\@linaro.org" <john.stultz@linaro.org>,
        "mkubecek\@suse.cz" <mkubecek@suse.cz>,
        "oleg\@redhat.com" <oleg@redhat.com>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "richardcochran\@gmail.com" <richardcochran@gmail.com>,
        "sboyd\@kernel.org" <sboyd@kernel.org>,
        "vdronov\@redhat.com" <vdronov@redhat.com>,
        "bigeasy\@linutronix.de" <bigeasy@linutronix.de>,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "edumazet\@google.com" <edumazet@google.com>
Cc:     "jesus.sanchez-palencia\@intel.com" 
        <jesus.sanchez-palencia@intel.com>,
        "vedang.patel\@intel.com" <vedang.patel@intel.com>,
        "Sudler\, Simon" <simon.sudler@siemens.com>,
        "Bucher\, Andreas" <andreas.bucher@siemens.com>,
        "henning.schild\@siemens.com" <henning.schild@siemens.com>,
        "jan.kiszka\@siemens.com" <jan.kiszka@siemens.com>,
        "Zirkler\, Andreas" <andreas.zirkler@siemens.com>,
        "Sakic\, Ermin" <ermin.sakic@siemens.com>,
        "anninh.nguyen\@siemens.com" <anninh.nguyen@siemens.com>,
        "Saenger\, Michael" <michael.saenger@siemens.com>,
        "Maehringer\, Bernd" <bernd.maehringer@siemens.com>,
        "gisela.greinert\@siemens.com" <gisela.greinert@siemens.com>,
        "Geva\, Erez" <erez.geva.ext@siemens.com>,
        "ErezGeva2\@gmail.com" <ErezGeva2@gmail.com>,
        "guenter.steindl\@siemens.com" <guenter.steindl@siemens.com>
Subject: Re: AW: [PATCH 0/7] TC-ETF support PTP clocks series
In-Reply-To: <AM0PR10MB30737E10A86AD50ECBB3A128FA080@AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com> <87eemg5u5i.fsf@intel.com> <87tuvccgpr.fsf@nanos.tec.linutronix.de> <AM0PR10MB30737E10A86AD50ECBB3A128FA080@AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM>
Date:   Fri, 09 Oct 2020 17:39:54 +0200
Message-ID: <87ft6ntnlh.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andreas,

On Fri, Oct 09 2020 at 11:17, Andreas Meisinger wrote:

please do not top-post and trim your replies.

> Yet we do already have usecases where this can't be done. Additionally
> a lot of discussions at this topic are ongoing in 60802 profile
> creation too.  Some of our usecases do require a network which does
> not depend on any external timesource. This might be due to the
> network not being connected (to the internet) or just because the
> network may not be able to rely on or trust an external
> timesource. Some reasons for this might be safety, security,
> availability or legal implications ( e.g. if a machine builder has to
> guarantee operation of a machine which depends on an internal tsn
> network).

I'm aware of the reasons for these kind of setups.

> About your question if an application needs to be able to sync to
> multiple timescales. A small count of usecases even would require
> multiple independent timesources to be used. At the moment they all
> seem to be located in the area of extreme high availability. There's
> ongoing evaluation about this issues and we're not sure if there's a
> way to do this without special hardware so we didn't address it here.

Reading several raw PTP clocks is always possible through the existing
interfaces and if the coordidation between real TAI and the raw PTP
clocks is available, then these interfaces could be extended to provide
time normalized to real TAI.

But that does not allow to utilize the magic clocks for arming timers so
these have to be based on some other clock and the application needs to do
the conversion back and forth.

Now I said that we could abuse time name spaces for providing access to
_one_ magic TAI clock which lets the kernel do that work, but thinking
more about it, it should be possible to do so for all of them even
without name spaces.

The user space daemon which does the correlation between these PTP
domains and TAI is required in any case, so the magic clock TAI_PRIVATE
is not having any advantage.

If that correlation exists then at least clock_nanosleep() should be
doable. So clock_nanosleep(clock PTP/$N) would convert the sleep time to
TAI and queue a timer internally on the CLOCK_TAI base.

Depending on the frequency drift between CLOCK_TAI and clock PTP/$N the
timer expiry might be slightly inaccurate, but surely not more
inaccurate than if that conversion is done purely in user space.

The self rearming posix timers would work too, but the self rearming is
based on CLOCK_TAI, so rounding errors and drift would be accumulative.
So I'd rather stay away from them.

If there is no deamon which manages the correlation then the syscall
would fail.

If such a coordination exists, then the whole problem in the TSN stack
is gone. The core can always operate on TAI and the network device which
runs in a different time universe would use the same conversion data
e.g. to queue a packet for HW based time triggered transmission. Again
subject to slight inaccuracy, but it does not come with all the problems
of dynamic clocks, locking issues etc. As the frequency drift between
PTP domains is neither fast changing nor randomly jumping around the
inaccuracy might even be a mostly academic problem.

Thoughts?

Thanks,

        tglx
