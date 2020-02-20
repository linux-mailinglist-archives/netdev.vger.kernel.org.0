Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9D05165635
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 05:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgBTET7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 23:19:59 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36187 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbgBTET6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 23:19:58 -0500
Received: by mail-pl1-f195.google.com with SMTP id a6so1026297plm.3;
        Wed, 19 Feb 2020 20:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FYRx+ojWKka5dOzfxYown+hh6IqyoQrFZkYXQNdVQwQ=;
        b=cm67H6/W2R77cF1SonxMWOSDPb/Xxz0VqEWjgmb7kn9I4ShrLmsP/HORD8S+VpEX3q
         1uNIXhUlql+bIDWvHnxkipPT71yMfPSewxr55YMWkXt2bHpZQYQSEit9VUgEie7tzydS
         RCIDH5Z8KPvRdj9qwniOL8e88vKoa4f3B1FUA7u7h1kdTzz8sXoFCFeVxsN3xF8wYyOd
         HDHmDHyheDgyNyIc7kbQ3mq+G0uiyOkQGxmZKnddHOTKwu3EMA1jnUQQ9TMkqWSqbfHh
         CkaWB/nxleCHGd5bdTcan7BCDAx/TOxKSEtjqKAhyv88ypMMOCjaMjoESxelBlZTvR9u
         qoRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FYRx+ojWKka5dOzfxYown+hh6IqyoQrFZkYXQNdVQwQ=;
        b=KDHN05QLJl5mHEK9H1yaN7uIv/zVfWZqntsoTItua0gJzXIZaTFQcTnOjGmQ2CiuSo
         psTWJhM0p50b03cYSXhcAkJf8U/LkH2/Wk/F3gST80wpbjkGDwoNvJf+yAcAkodJtim/
         Svgy0+UWU/TlnDG8+swGi9OUrcJZiYUlwqoFT2UU5kCn/D7Hr/H3ZM4Tv6j6Hmz3PNnC
         elID08+zoVFRSXMLvFh5VhKQR79F3TikToyBvkRSW7ARddQiAwvZXs0NzWj1mOsbMJHf
         i7i0vV351mUzbnrUixbBPvr0CRPzcEnWJ7J9meVxKQmP3nHCdVVHFlQZOB5wMJjy4Vcw
         1Yxg==
X-Gm-Message-State: APjAAAU8lbA4PpTIppzurZce/SE2RAnHhoHSsRInARisn3RgKSzl5IBs
        EyCkjoT4GE/Ap5dbAiPqLSu6e047
X-Google-Smtp-Source: APXvYqxKVrgoGUcRaA4sFoZcAOJCUTszg1jREcxjR8hwOxGHo5rNwVGV9YX8qC3aH+ZUpjiRnmz1Zw==
X-Received: by 2002:a17:902:9a09:: with SMTP id v9mr28436709plp.341.1582172396600;
        Wed, 19 Feb 2020 20:19:56 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:3283])
        by smtp.gmail.com with ESMTPSA id r6sm1222468pfh.91.2020.02.19.20.19.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Feb 2020 20:19:55 -0800 (PST)
Date:   Wed, 19 Feb 2020 20:19:52 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC patch 14/19] bpf: Use migrate_disable() in hashtab code
Message-ID: <20200220041951.rhsr3zstl6fkbmfn@ast-mbp>
References: <20200214133917.304937432@linutronix.de>
 <20200214161504.325142160@linutronix.de>
 <20200214191126.lbiusetaxecdl3of@localhost>
 <87imk9t02r.fsf@nanos.tec.linutronix.de>
 <20200218233641.i7fyf36zxocgucap@ast-mbp>
 <1127123648.641.1582125448879.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1127123648.641.1582125448879.JavaMail.zimbra@efficios.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 10:17:28AM -0500, Mathieu Desnoyers wrote:
> ----- On Feb 18, 2020, at 6:36 PM, Alexei Starovoitov alexei.starovoitov@gmail.com wrote:
> 
> [...]
> 
> > If I can use migrate_disable() without RT it will help my work on sleepable
> > BPF programs. I would only have to worry about rcu_read_lock() since
> > preempt_disable() is nicely addressed.
> 
> Hi Alexei,
> 
> You may want to consider using SRCU rather than RCU if you need to sleep while
> holding a RCU read-side lock.
> 
> This is the synchronization approach I consider for adding the ability to take page
> faults when doing syscall tracing.
> 
> Then you'll be able to replace preempt_disable() by combining SRCU and
> migrate_disable():
> 
> AFAIU eBPF currently uses preempt_disable() for two reasons:
> 
> - Ensure the thread is not migrated,
>   -> can be replaced by migrate_disable() in RT
> - Provide RCU existence guarantee through sched-RCU
>   -> can be replaced by SRCU, which allows sleeping and taking page faults.

bpf is using normal rcu to protect map values
and rcu+preempt to protect per-cpu map values.
srcu is certainly under consideration. It hasn't been used due to performance
implications. atomics and barriers are too heavy for certain use cases. So we
have to keep rcu where performance matters, but cannot fork map implementations
to rcu and srcu due to huge code bloat. So far I've been thinking to introduce
explicit helper bpf_rcu_read_lock() and let programs use it directly instead of
implicit rcu_read_lock() that is done outside of bpf prog. The tricky part is
teaching verifier to enforce critical section.
