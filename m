Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4952809DD
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 00:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733098AbgJAWF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 18:05:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38558 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgJAWF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 18:05:56 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601589954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IJcSELVC6RVckkFldDPnK0A/9qc4egUUwNfx1N3iMQ0=;
        b=hYSZvjIlCvJp6mhe7Ze4zibnAoIQOm2HevzvHSTiOeN8BpodcJvTPOuz31EbixqHdWELLE
        h/fxpyGgqeiGzyq75iyf4VmXZBeVYzcjwG1nHRj1+VtXvK2VGBMj02Mlj7Mn8k0ss0epVx
        mARL5Iq0k52AKNQyYoXhbz/Puy1xebrCQU5EQGIt2k0BK1pAfP2AUs4oo3JDbXprtab5wx
        qx+4ik/A/lOLcxErJ0EWWvYlZ1C5kBB5NVCpRl3ShcdYPjqYhzgiGCbVqljHw+JvTpapkb
        7DOa+taRH5pokl0L63jsE5oEtySdzZxOasa33MR4NDKLHB5xLUlHSN8D9ZHEIw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601589954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IJcSELVC6RVckkFldDPnK0A/9qc4egUUwNfx1N3iMQ0=;
        b=f/HNZgTj8Ox4bFry60y8Ijfmnnofa+tIHeeS7NaMjPdbIkdsotWtlwm6bSwY+Yw9N1asTm
        QnMhcuUBaEDU3HAg==
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
In-Reply-To: <20201001205141.8885-3-erez.geva.ext@siemens.com>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com> <20201001205141.8885-3-erez.geva.ext@siemens.com>
Date:   Fri, 02 Oct 2020 00:05:53 +0200
Message-ID: <87wo09eh4u.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Erez,

On Thu, Oct 01 2020 at 22:51, Erez Geva wrote:

same comments as for patch 1 apply.

> Add kernel function to retrieve main clock oscillator state.

The function you are adding is named adjtimex(). adjtimex(2) is a well
known user space interface and naming a read only kernel interface the
same way is misleading.

Thanks,

        tglx


