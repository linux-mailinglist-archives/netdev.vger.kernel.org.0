Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0E8398AAE
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 15:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhFBNda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 09:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhFBNdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 09:33:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D10CC061761;
        Wed,  2 Jun 2021 06:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Subject:Cc:To:From:Date:Message-ID:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=+0GJIyUeezLFp/ym4/vP+fC11EDSc+9M3QstIcNFnoM=; b=HwUP711Hi7fk/GRlHwhhfYuQB5
        K5vYCOeQPuOhkpRqo74FjxBE7Qmwx8Wj6GWtoLKoGosJHAwdRgo9jNLQy1TmIkJWwpfsGoVcLemhp
        yE/DBMFhvtilIfo4dv1JJaSo/mfYt/uX/LfisWcd+3wnlJLAvfkdTdiO1+HtsYKFPZ/tV6bjzqFeK
        4bo4vY52aoMqPrC7we688zYhvu7+dOw4A1kcJpeVTuCoCOtBGxbR88VN+otXu+yI9l3xV+f66r/TA
        vzFWO4ght7JIQB07yN0JwJ0Lzx83FvV5EUgJ9xU0ODmz2KYDDLO3n44qTW1zqH17jqyBTMXum4Ngk
        tEM+eMIg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1loQxe-00B8nb-51; Wed, 02 Jun 2021 13:31:08 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B184A300299;
        Wed,  2 Jun 2021 15:31:04 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 90C662C08A5B8; Wed,  2 Jun 2021 15:31:04 +0200 (CEST)
Message-ID: <20210602131225.336600299@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 02 Jun 2021 15:12:25 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        linux-perf-users@vger.kernel.org, linux-pm@vger.kernel.org,
        rcu@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Subject: [PATCH 0/6] sched: Cleanup task_struct::state
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

The task_struct::state variable is a bit odd in a number of ways:

 - it's declared 'volatile' (against current practises);
 - it's 'unsigned long' which is a weird size;
 - it's type is inconsistent when used for function arguments.

These patches clean that up by making it consistently 'unsigned int', and
replace (almost) all accesses with READ_ONCE()/WRITE_ONCE(). In order to not
miss any, the variable is renamed, ensuring a missed conversion results in a
compile error.

The first few patches fix a number of pre-existing errors and introduce a few
helpers to make the final conversion less painful.


