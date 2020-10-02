Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B374E280B90
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 02:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733103AbgJBATa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 20:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbgJBATa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 20:19:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A73C0613D0;
        Thu,  1 Oct 2020 17:19:29 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601597967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3HcQLfTCdyVO5Aew4yZ9f7hx5197SRtmMDoZKfBBuag=;
        b=P7S+u4NBLNxK0fVe6ikV9RwnrGxIZNyvl8yuRWFknJ9pl7nY3YdYpDw8RupCMKhmX2tinY
        qUmf0CjsSB3PYraHEKhB0xgRCcla4nrWfkIhqfZqJ9KCGN3GIJiDd9Y/vY18UjqLWeGV2d
        2GkZu+snoJKYWZSIPWoHNjvAazB2xD8V6UrrcjLUG0Lh6kJMqjeNWMvPgrMWPRYLM39wmN
        0q55J/LAkrRhT3Tz5GrFjCPNHUuhyKkhC+SeZwMDytrvd8yiX2ec39vJvTM0rlxZm1J81c
        4v37xtDcHmj+8OSlk5ydqM1d0noQlDoO0YK3S7Min/6rt6d5g08l42i4mgqPFg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601597967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3HcQLfTCdyVO5Aew4yZ9f7hx5197SRtmMDoZKfBBuag=;
        b=YZz4NNIQGs9a4E3S5CeuvBnWUjebGNV7dXHwX6D7KdGacq8C2JMaZyryopYalh7J1h5VU/
        Mv3JDvWQJIjm8JDQ==
To:     Erez Geva <erez.geva.ext@siemens.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Simon Sudler <simon.sudler@siemens.com>,
        Andreas Meisinger <andreas.meisinger@siemens.com>,
        Andreas Bucher <andreas.bucher@siemens.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andreas Zirkler <andreas.zirkler@siemens.com>,
        Ermin Sakic <ermin.sakic@siemens.com>,
        An Ninh Nguyen <anninh.nguyen@siemens.com>,
        Michael Saenger <michael.saenger@siemens.com>,
        Bernd Maehringer <bernd.maehringer@siemens.com>,
        Gisela Greinert <gisela.greinert@siemens.com>,
        Erez Geva <erez.geva.ext@siemens.com>,
        Erez Geva <ErezGeva2@gmail.com>
Subject: Re: [PATCH 2/7] Function to retrieve main clock state
In-Reply-To: <87wo09eh4u.fsf@nanos.tec.linutronix.de>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com> <20201001205141.8885-3-erez.geva.ext@siemens.com> <87wo09eh4u.fsf@nanos.tec.linutronix.de>
Date:   Fri, 02 Oct 2020 02:19:27 +0200
Message-ID: <87eemheay8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02 2020 at 00:05, Thomas Gleixner wrote:
> On Thu, Oct 01 2020 at 22:51, Erez Geva wrote:
>
> same comments as for patch 1 apply.
>
>> Add kernel function to retrieve main clock oscillator state.
>
> The function you are adding is named adjtimex(). adjtimex(2) is a well
> known user space interface and naming a read only kernel interface the
> same way is misleading.

Aside of that there is no user for this function in this series. We're
not adding interfaces just because we can.

Thanks,

        tglx
