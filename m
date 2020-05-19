Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CDC1D8D1F
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 03:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgESBaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 21:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgESBaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 21:30:10 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D225C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 18:30:10 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id be9so6098482edb.2
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 18:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c/kBhdEm/RbC/rHN7CxKNscVcq59/fXXQ+yvqikxJQk=;
        b=dKRl3GtuVwAcO4yLtYInBUsLz7uT8FTctcjI82+iipH4Fy/SlklwT+wCeX4uTOw22s
         jyniqimHiCbiPVPTSr9ugOKoUKnL49eTq8MWuZV7Qvn432hsfDFQ7Z9Bml+qRjMaJ8UA
         14/4548vcrGVTUSzP04r5+AxqVZ1aiWhCgaVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c/kBhdEm/RbC/rHN7CxKNscVcq59/fXXQ+yvqikxJQk=;
        b=EXH20keQKR6CpF3RucAGRjgPTxq+tYsavYvtEsKyxCkh6fxBql9TpgUtYPHAOv6jM8
         /+MmWmjr8tFqSWIDJ9KYJ/s/rgoeBowZFGWcuOHTAzkjLZF9Qh/xNYtO11BFVYRhC0HO
         V9cgiTw4780On4kNtXBVnNCFMGSNNp/6e1LnjAN447+D6O3jG0tXsU8cZD5B0q/rt50P
         tgaMVJocSApwtbx3RgnXBJJ/oRu4cBUQfbkfCeA3+VAJZc2JeKBj/dIiq/J0LCas4XB+
         1vZFWV8fDbqVn2InxNbOF35Su6xEHdANNZ3V0+mfIDLZPyJgCT2q/v5z/KJGBiIpSCEq
         uFaA==
X-Gm-Message-State: AOAM530mLWk4vK1eAwtaWIQn1t2Nvgi5wmVFXGJhOakl9fAibGzePo/k
        k4Ea8rsCz2TQxsTQ4wZxHRmAB3cZrYYzyw==
X-Google-Smtp-Source: ABdhPJxhBHqKl0c4Z7P3mCNACArOMBgWc9F70a30lq8QPuy0oCUjZtN1023tT3C96Me56v0rvusOsw==
X-Received: by 2002:a50:d490:: with SMTP id s16mr15492087edi.242.1589851808597;
        Mon, 18 May 2020 18:30:08 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id wr19sm1557079ejb.67.2020.05.18.18.30.08
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 18:30:08 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id n24so2443322ejd.0
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 18:30:08 -0700 (PDT)
X-Received: by 2002:ac2:4113:: with SMTP id b19mr13440886lfi.143.1589851425022;
 Mon, 18 May 2020 18:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200515212846.1347-1-mcgrof@kernel.org> <20200515212846.1347-13-mcgrof@kernel.org>
 <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net> <7306323c35e6f44d7c569e689b48f380f80da5e5.camel@sipsolutions.net>
In-Reply-To: <7306323c35e6f44d7c569e689b48f380f80da5e5.camel@sipsolutions.net>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 18 May 2020 18:23:33 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOg9oKeMJP1Mf42oCMMM3sVe0jniaWowbXVuaYZ=ZpDjQ@mail.gmail.com>
Message-ID: <CA+ASDXOg9oKeMJP1Mf42oCMMM3sVe0jniaWowbXVuaYZ=ZpDjQ@mail.gmail.com>
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, jeyu@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        aquini@redhat.com, cai@lca.pw, dyoung@redhat.com, bhe@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, gpiccoli@canonical.com,
        pmladek@suse.com, Takashi Iwai <tiwai@suse.de>, schlad@suse.de,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, daniel.vetter@ffwll.ch,
        will@kernel.org, mchehab+samsung@kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 6:51 AM Johannes Berg <johannes@sipsolutions.net> wrote:
> In addition, look what we have in iwl_trans_pcie_removal_wk(). If we
> detect that the device is really wedged enough that the only way we can
> still try to recover is by completely unbinding the driver from it, then
> we give userspace a uevent for that. I don't remember exactly how and
> where that gets used (ChromeOS) though, but it'd be nice to have that
> sort of thing as part of the infrastructure, in a sort of two-level
> notification?

<slight side track>
We use this on certain devices where we know the underlying hardware
has design issues that may lead to device failure -- then when we see
this sort of unrecoverable "firmware-death", we remove the
device[*]+driver, force-reset the PCI device (SBR), and try to
reload/reattach the driver. This all happens by way of a udev rule. We
also log this sort of stuff (and metrics around it) for bug reports
and health statistics, since we really hope to not see this happen
often.

[*] "We" (user space) don't actually do this...it happens via the
'remove_when_gone' module parameter abomination found in iwlwifi. I'd
personally rather see the EVENT=INACESSIBLE stuff on its own, and let
user space deal with when and how to remove and reset the device. But
I digress too much here ;)
</slight side track>

I really came to this thread to say that I also love the idea of a
generic mechanism (a la $subject) to report firmware crashes, but I
also have no interest in seeing a taint flag for it. For Chrome OS, I
would readily (as in, we're already looking at more-hacky /
non-generic ways to do this for drivers we care about) process these
kinds of stats as they happen, logging metrics for bug reports and/or
for automated crash statistics, when we see a firmware crash. A uevent
would suit us very well I think, although it would be nice if drivers
could also supply some small amount of informative text along with it
(e.g., a sort of "reason code", in case we can possibly aggregate
certain failure types). We already do this sort of thing for WARN()
and friends (not via uevent, but via log parsing; at least it has nice
"cut here" markers!).

Perhaps devlink (as proposed down-thread) would also fit the bill. I
don't think sysfs alone would fit our needs, as we'd like to process
these things as they happen, not only when a user submits a bug
report.

> Level 1: firmware crashed, but we're recovering, at least mostly, and
> it's more informational

Chrome OS would love to track these things too, since we'd like to see
these minimized, even if they're usually recoverable ;)

> Level 2: device is wedged, going to try to recover by some more forceful
> means (perhaps some devices can be power-cycled? etc.) but (more) state
> would be lost in these cases?

And we'd definitely want to know about these. We already get this for
the iwlwifi case described above, in a non-generic way.

In general, it's probably not that easy to tell the difference between
1 and 2, since even as you and Luis have noted, with the same driver
(and the same driver location), you find the same crashes may or may
not be recoverable. iwlwifi has extracted certain level 2 cases into
iwl_trans_pcie_removal_wk(), but even iwlwifi doesn't know all the
ways in which level 1 crashes actually lead to severe
(non-recoverable) failure.

Regards,
Brian
