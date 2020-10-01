Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A5D280B5D
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733103AbgJAXgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:36:02 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39096 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgJAXgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 19:36:02 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601595359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=3bLXIEr80y97HxN2avit1abmvcPedPzxpX5HrJY66eU=;
        b=TYXfSssbA27+U7rvgAEv1+r0MLc02A1qL7tBVFTCn92ZXT/0hU0g25+7YYJ9+eqxA890+x
        B8Vj/1uvphGaVcf+XCOziDUD3XvZ0M3JSMOzPt99T2VOrgek4zG8Zh3PwqL2nIXETjdzS5
        XO7pxYElHz6Gpcit5ofiM0KGT2oc7uT5YBeucV5q8aFwSOgGUrSMW953W5uJHviSDDMob+
        hVKEg+/JyhV/oGkK7XnPG3Dse4F57kUdo5vkou0sdvK8PzqulhbiYz8AcjWevms8v/xI19
        x0aImkyZQoU0GRAAM6OgtBaFjC66dqle/eW6Zko+LgJf+7EUX59aPuKGEwtadQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601595359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=3bLXIEr80y97HxN2avit1abmvcPedPzxpX5HrJY66eU=;
        b=8J9vPfi2zXAFae/LTOhYPhvlIQJkGUH6QTe73K/DZdZcGumxoPTSJfhWp4MhC4MABdp9rl
        lFo+Xkpuvp/XeyDQ==
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
Subject: Re: [PATCH 3/7] Functions to fetch POSIX dynamic clock object
In-Reply-To: <20201001205141.8885-4-erez.geva.ext@siemens.com>
Date:   Fri, 02 Oct 2020 01:35:59 +0200
Message-ID: <87h7rdecyo.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01 2020 at 22:51, Erez Geva wrote:
> Add kernel functions to fetch a pointer to a POSIX dynamic clock
> using a user file description dynamic clock ID.

And how is that supposed to work. What are the lifetime rules?
  
> +struct posix_clock *posix_clock_get_clock(clockid_t id)
> +{
> +	int err;
> +	struct posix_clock_desc cd;

The core code uses reverse fir tree ordering of variable declaration
based on the length:

	struct posix_clock_desc cd;
        int err;

> +	/* Verify we use posix clock ID */
> +	if (!is_clockid_fd_clock(id))
> +		return ERR_PTR(-EINVAL);
> +
> +	err = get_clock_desc(id, &cd);

So this is a kernel interface and get_clock_desc() does:

	struct file *fp = fget(clockid_to_fd(id));

How is that file descriptor valid in random kernel context?

> +	if (err)
> +		return ERR_PTR(err);
> +
> +	get_device(cd.clk->dev);

The purpose of this is? Comments are overrated...

> +	put_clock_desc(&cd);
> +
> +	return cd.clk;
> +}
> +EXPORT_SYMBOL_GPL(posix_clock_get_clock);
> +
> +int posix_clock_put_clock(struct posix_clock *clk)
> +{
> +	if (IS_ERR_OR_NULL(clk))
> +		return -EINVAL;
> +	put_device(clk->dev);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(posix_clock_put_clock);
> +
> +int posix_clock_gettime(struct posix_clock *clk, struct timespec64 *ts)
> +{
> +	int err;
> +
> +	if (IS_ERR_OR_NULL(clk))
> +		return -EINVAL;
> +
> +	down_read(&clk->rwsem);

Open coding the logic of get_posix_clock() and having a copy here and
in the next function is really useful.

Thanks,

        tglx
