Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAEF2809C4
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733178AbgJAV41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:56:27 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38474 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgJAV41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 17:56:27 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601589385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lMRaVPTvuWTyynCpN/PrnduR2k7t8citPdkJRksAg6s=;
        b=U506vCVopd0a8GMRAfloiC9+jXJVPmB/xLrsPYjZs8hP/mwK7RS4FTG4eYJqyf6VBKrfRT
        hJvq9uer/zjKUjmSFB+XGRlhDXIeu1TISLYKAAYoxhuQBPjXbkoPQ9sxPFhO/U9nbqCOr/
        ywlK3jwQlOjpTPu2rsuMZbzBdlugQItfYYFqTDanCXYmlVxtuoVISLmH2P+FdpxbRx6OZV
        Oe+B9NJt+dPokjH7y60rYvbNIRs4qLMOPig+7DCVfJYcbHzDN+Hrx3EhuReUuYFP17pJp1
        XUIMHdrBvVINMmel1BWsspUu8RXMEphvds5iDhW5RANDLOr3kgthtiaVwObnWg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601589385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lMRaVPTvuWTyynCpN/PrnduR2k7t8citPdkJRksAg6s=;
        b=j+Okf2S6X8t0gkpUIO+757np9aFuuwZIQcOL/1h7KGh8PyVOxobLYZHb5+2m4ZZfbIEeoM
        CHfgu5N0ZcfF4GBg==
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
Subject: Re: [PATCH 1/7] POSIX clock ID check function
In-Reply-To: <20201001205141.8885-2-erez.geva.ext@siemens.com>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com> <20201001205141.8885-2-erez.geva.ext@siemens.com>
Date:   Thu, 01 Oct 2020 23:56:24 +0200
Message-ID: <87zh55ehkn.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Erez,

On Thu, Oct 01 2020 at 22:51, Erez Geva wrote:

thanks for your patches.

First of all subject lines follow the scheme:

 subsystem: Short description

The short description should be a sentence

> Add function to check whether a clock ID refer to
> a file descriptor of a POSIX dynamic clock.

The changelog should not primarily describe what the patch does, it
should describe why or which problem it is solving.

Thanks,

        tglx
