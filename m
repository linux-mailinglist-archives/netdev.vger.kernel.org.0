Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E2168A96
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730249AbfGONd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:33:26 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46867 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730205AbfGONdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 09:33:25 -0400
Received: by mail-ed1-f68.google.com with SMTP id d4so15492989edr.13
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 06:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zV3/vbwe0/Qeasu0YBAGg2gUXm0o6TWO07FywBLuSLQ=;
        b=L0rWdGhfirmWchYFN/Q49dCPtNkTSUF3ESjkzSzpadWF5LFHu4NvYRUuhk+wNwHj3D
         mv/14J1m7xMRKxXNODwINfKzMhNmgo1C9L1BadzLgwBfp/t+zEe37+/YvPAyllAg1dX/
         bvYMmwDngb7snArunyuOmk242XB7+Alu5rmPDBDT7Xb5qOZS3D2AcJ+ZLT4MIX4pYNiI
         pRzhrQ0esLbdO4/EFBbPcX4u9puEdb+OX1NjQTvGCOChvfXte34esi7oseASPbcHYMHq
         eRam9KQbFBBkUyF2ZDX8gZmem8guJOs+oiK7kcbT+RXbL024SPqXfMXOfEtMRucPhzPd
         AA5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zV3/vbwe0/Qeasu0YBAGg2gUXm0o6TWO07FywBLuSLQ=;
        b=YX0zCjRxvqt9C/XGSVC3nmXtCspefgugxap9k5QgeEo+v8YR5sNwO9xX51IqSWO3zd
         UoCYHRKbTmfUdY4CSW/eYmxvMB6+HypmaEg76sOQckf5Ex9XvzeJw7TLR5x7OfipI/b5
         RDCdibdKEGqPwMCp8yvblShNh6yx7uzI1egegC4VIy2LtTVtptLbrG/vXEIVyCAechCz
         2wuL5jxi4a734VeZzfhLpavjg+CXdauRc3IeV31/f+Las/H7fGrpSfDE7ZNqUZ73DhQp
         yKdBBly7CVNcTfdT5ZWRV0oOZed4Gq/l+SUp/RQZJzkz7V/abwNUZbzI/yv7oAeMjoK1
         k1RA==
X-Gm-Message-State: APjAAAVGJcc1gur68hhrtYsMOUnrIUZcbl+rZVs0Hp+StJSFKV6kfbpf
        J+HVfl/MEPA04HazTIIf4pjZTF8Feur5SDXNPD2tbA==
X-Google-Smtp-Source: APXvYqxiyIGV3CkBm6teN0cFq4U4X8od+WIc9m+37oG40chmdHcr6+lg/DGbEVZHpjhTDNKzo6KAT/7YUwUuInGxIX4=
X-Received: by 2002:a17:906:6dd4:: with SMTP id j20mr20664132ejt.173.1563197603166;
 Mon, 15 Jul 2019 06:33:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190705151658.GP26519@linux.ibm.com> <CACT4Y+aNLHrYj1pYbkXO7CKESLeB-5enkSDK7ksgkMA3KtwJ+w@mail.gmail.com>
 <20190705191055.GT26519@linux.ibm.com> <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com> <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com> <20190707011655.GA22081@linux.ibm.com>
 <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
 <20190714184915.GK26519@linux.ibm.com> <20190715132911.GG3419@hirez.programming.kicks-ass.net>
In-Reply-To: <20190715132911.GG3419@hirez.programming.kicks-ass.net>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 15 Jul 2019 15:33:11 +0200
Message-ID: <CACT4Y+bmgdOExBHnLJ+jgWKWQzNK9CFT6_eTxFE3hoK=0YresQ@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in ext4_write_checks
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        David Miller <davem@davemloft.net>, eladr@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 3:29 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Sun, Jul 14, 2019 at 11:49:15AM -0700, Paul E. McKenney wrote:
> > On Sun, Jul 14, 2019 at 05:48:00PM +0300, Dmitry Vyukov wrote:
> > > But short term I don't see any other solution than stop testing
> > > sched_setattr because it does not check arguments enough to prevent
> > > system misbehavior. Which is a pity because syzkaller has found some
> > > bad misconfigurations that were oversight on checking side.
> > > Any other suggestions?
> >
> > Keep the times down to a few seconds?  Of course, that might also
> > fail to find interesting bugs.
>
> Right, if syzcaller can put a limit on the period/deadline parameters
> (and make sure to not write "-1" to
> /proc/sys/kernel/sched_rt_runtime_us) then per the in-kernel
> access-control should not allow these things to happen.

Since we are racing with emails, could you suggest a 100% safe
parameters? Because I only hear people saying "safe", "sane",
"well-behaving" :)
If we move the check to user-space, it does not mean that we can get
away without actually defining what that means.

Now thinking of this, if we come up with some simple criteria, could
we have something like a sysctl that would allow only really "safe"
parameters?
