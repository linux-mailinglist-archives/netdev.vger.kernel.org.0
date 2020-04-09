Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 661641A3977
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 20:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgDISAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 14:00:21 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38402 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDISAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 14:00:20 -0400
Received: by mail-pl1-f196.google.com with SMTP id w3so4092330plz.5
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 11:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=zmgHj370LBNKV1cbwyo1caCm3JQLWtu1rtTInvPHiUM=;
        b=tzNrLp6SmTl4zuvoJWbv/IhrraqC8y+wpruozs/0zZ2WxqUK+8LU0L9I4hzVj2ua9U
         KY4iUimjpe58mMHQ5aLQgiS86vHoYVT/MPfC/f04JDPoelZ7dXayZ2gxrJoZJFqWqlAW
         tyC5H1xGmGRb3Es0DTFD6S73K5nQgskuaNMbgkZqBFc2BUEe7mEjWpXrG4IMCVehJ+K9
         mV7IN/uS5qiJOsvVoX7uMjJXer1hGe247YoLfdMK4bapF4kUSj1XtqPwbXfUvPZqUfTw
         +FmtN9UGx2prFh+/QoNprDQvyAWYCBn4UgnDGGocPkf5wCqL2lbyaPVsgzPfXKK0MFtg
         Wb+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=zmgHj370LBNKV1cbwyo1caCm3JQLWtu1rtTInvPHiUM=;
        b=EBHKXOuXbP7g1nt9NGL9F4Ap9Sgyf3Z8JZVLNe5768OTAXSR9jcOVTd5Q8T2jc6FJT
         c8vzMMETGWjbEydI3coZirhuG6cKQ/NX4/AmTpjSU0HiZOoL1dUmKKXs2SbD5mjA+bHO
         4DXrIfQVzuEXpM+5Zz+pfKbcHzZXoyuGG2fCaO7GSGGnkxHnaXmOWUkW7O/cNQq7GyEB
         +bmjSnbNT6scVCGZwIcgYbcjKdV2jvXPWQY25AXAfH95cxGHxaa1QgkTpkO3MdEqkAWm
         oxBLgTMy2BhnqpBS6qsb2Qs1FxT7xu1+iiuwdqpvERsCscaKQI/0VAX3SMCohNHiTd+K
         OQ/A==
X-Gm-Message-State: AGi0PuYzxRkzkY3ETzABejMsXValY1+0THaG/c4p1PowEanS4CI6ncWd
        6HVIVXrpoy+fZI5GBNFBS48dIw==
X-Google-Smtp-Source: APiQypIyuBEG4mydIIZ8UiVlFa6tJQNZqilN3DYnHlSeONtErGyrPOPpHqhOZbnewz+YO15faSZe2w==
X-Received: by 2002:a17:902:ff14:: with SMTP id f20mr731344plj.206.1586455218768;
        Thu, 09 Apr 2020 11:00:18 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:d3f:18b:ffcb:12f6? ([2601:646:c200:1ef2:d3f:18b:ffcb:12f6])
        by smtp.gmail.com with ESMTPSA id c3sm2461610pfa.160.2020.04.09.11.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 11:00:18 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v3 04/13] task_isolation: userspace hard isolation from kernel
Date:   Thu, 9 Apr 2020 11:00:16 -0700
Message-Id: <915489BC-B2C9-4D47-A205-FC597FC68B98@amacapital.net>
References: <58995f108f1af4d59aa8ccd412cdff92711a9990.camel@marvell.com>
Cc:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <58995f108f1af4d59aa8ccd412cdff92711a9990.camel@marvell.com>
To:     Alex Belits <abelits@marvell.com>
X-Mailer: iPhone Mail (17E255)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 9, 2020, at 8:21 AM, Alex Belits <abelits@marvell.com> wrote:
>=20
> =EF=BB=BFThe existing nohz_full mode is designed as a "soft" isolation mod=
e
> that makes tradeoffs to minimize userspace interruptions while
> still attempting to avoid overheads in the kernel entry/exit path,
> to provide 100% kernel semantics, etc.
>=20
> However, some applications require a "hard" commitment from the
> kernel to avoid interruptions, in particular userspace device driver
> style applications, such as high-speed networking code.
>=20
> This change introduces a framework to allow applications
> to elect to have the "hard" semantics as needed, specifying
> prctl(PR_TASK_ISOLATION, PR_TASK_ISOLATION_ENABLE) to do so.
>=20
> The kernel must be built with the new TASK_ISOLATION Kconfig flag
> to enable this mode, and the kernel booted with an appropriate
> "isolcpus=3Dnohz,domain,CPULIST" boot argument to enable
> nohz_full and isolcpus. The "task_isolation" state is then indicated
> by setting a new task struct field, task_isolation_flag, to the
> value passed by prctl(), and also setting a TIF_TASK_ISOLATION
> bit in the thread_info flags. When the kernel is returning to
> userspace from the prctl() call and sees TIF_TASK_ISOLATION set,
> it calls the new task_isolation_start() routine to arrange for
> the task to avoid being interrupted in the future.
>=20
> With interrupts disabled, task_isolation_start() ensures that kernel
> subsystems that might cause a future interrupt are quiesced. If it
> doesn't succeed, it adjusts the syscall return value to indicate that
> fact, and userspace can retry as desired. In addition to stopping
> the scheduler tick, the code takes any actions that might avoid
> a future interrupt to the core, such as a worker thread being
> scheduled that could be quiesced now (e.g. the vmstat worker)
> or a future IPI to the core to clean up some state that could be
> cleaned up now (e.g. the mm lru per-cpu cache).
>=20
> Once the task has returned to userspace after issuing the prctl(),
> if it enters the kernel again via system call, page fault, or any
> other exception or irq, the kernel will kill it with SIGKILL.

I could easily imagine myself using task isolation, but not with the SIGKILL=
 semantics. SIGKILL causes data loss. Please at least let users choose what s=
ignal to send.=
