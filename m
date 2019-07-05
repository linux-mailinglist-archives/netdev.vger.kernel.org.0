Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEC06067B
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 15:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbfGENSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 09:18:18 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34393 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728664AbfGENSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 09:18:18 -0400
Received: by mail-io1-f66.google.com with SMTP id k8so19147093iot.1
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 06:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pRtQGOFldLgGE7qJqe1c/CUsqsRLF9F1riuLbw6yyJs=;
        b=lJIBBAa4dahLP/b9AXN6UgjzFVq0DrkIuIt64/jaRG20TBTpO3CnEPoPccNo6QbN51
         Rn889prtBvG0KxRt98TgSvQSWsDPFicrLqsuVPEN7IwewqSzO5TvAUG/87lLsqDH5tw4
         ejt7pCK0lFDN0EOFSf9x3L02OlEYPq3w5ZHv/+z7da0E+d/CNtKw45lIKPhTpZrQ2nYt
         C6YBCClsw8L58BDpl3mJ2RUk1UnMxKFQPopYvw83EAfI4S1Se/H61yPYj3UQFbsx3nBi
         lwojRqpap0CC6R14IJyex23CYqqVBmQy5r02PRJG4HhZDR4aoQY2qiQOyJvTapTakmNS
         sTmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pRtQGOFldLgGE7qJqe1c/CUsqsRLF9F1riuLbw6yyJs=;
        b=OMIEisUIpFJ/at8A977NjXVJ8D/eS+DyfvUYwyr/RfnyH3oUD9vgsYXOrUDHDJDxTL
         W6+mWGlwlzjk+qnYZyt0KF440LZ9q3yBDsI3HNJZylp7oXoIp1wkYhuGNaosdhpADWHl
         3ukfdp4MKe6KDyQaL/lhqrJJkFj9ddW+3mMGIQGhXh88G/NzIPzrQGbooHacN1uFS3tB
         uKgDTupnbd3qnAQrpWxGJC1eFNSMRPJP0QDigN+rng9dwG4h4SVcG9A/fs4olwYpe6nO
         Y/zS4s7TZ/XwCNh0SEJ/c8bVA/2g5n9R3u6cyvIkvRSUCXG8KoPekARV8pgpxY7zp88M
         h/tA==
X-Gm-Message-State: APjAAAVJFV8IkZqkHzLbqmlnPPyszad56mxxx2S2YJShVG+NPbBnlDsl
        2QmnK/nEF/IKFHGPqF4+wzvNcM+pGQuskjDsepxaNA==
X-Google-Smtp-Source: APXvYqwHcTdVO68Zki0+63QSWBONxJLklr7LXnf8O1UNup1dM0NT4WpEphqYVGaOt5adDzriIMut7G9Wn7lr0NEz8U0=
X-Received: by 2002:a6b:641a:: with SMTP id t26mr4198845iog.3.1562332697230;
 Fri, 05 Jul 2019 06:18:17 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d3f34b058c3d5a4f@google.com> <20190626184251.GE3116@mit.edu>
In-Reply-To: <20190626184251.GE3116@mit.edu>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 5 Jul 2019 15:18:06 +0200
Message-ID: <CACT4Y+aHgz9cPa7OnVsNeHim72i6zVdjnbvVb0Z1oN2B8QLZqg@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in ext4_write_checks
To:     "Theodore Ts'o" <tytso@mit.edu>,
        syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        David Miller <davem@davemloft.net>, eladr@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 8:43 PM Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Wed, Jun 26, 2019 at 10:27:08AM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org=
/pu..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1435aaf6a00=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3De5c77f8090a=
3b96b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D4bfbbf28a2e50=
ab07368
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D11234c41a=
00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D15d7f026a00=
000
> >
> > The bug was bisected to:
> >
> > commit 0c81ea5db25986fb2a704105db454a790c59709c
> > Author: Elad Raz <eladr@mellanox.com>
> > Date:   Fri Oct 28 19:35:58 2016 +0000
> >
> >     mlxsw: core: Add port type (Eth/IB) set API
>
> Um, so this doesn't pass the laugh test.
>
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D10393a89=
a00000
>
> It looks like the automated bisection machinery got confused by two
> failures getting triggered by the same repro; the symptoms changed
> over time.  Initially, the failure was:
>
> crashed: INFO: rcu detected stall in {sys_sendfile64,ext4_file_write_iter=
}
>
> Later, the failure changed to something completely different, and much
> earlier (before the test was even started):
>
> run #5: basic kernel testing failed: failed to copy test binary to VM: fa=
iled to run ["scp" "-P" "22" "-F" "/dev/null" "-o" "UserKnownHostsFile=3D/d=
ev/null" "-o" "BatchMode=3Dyes" "-o" "IdentitiesOnly=3Dyes" "-o" "StrictHos=
tKeyChecking=3Dno" "-o" "ConnectTimeout=3D10" "-i" "/syzkaller/jobs/linux/w=
orkdir/image/key" "/tmp/syz-executor216456474" "root@10.128.15.205:./syz-ex=
ecutor216456474"]: exit status 1
> Connection timed out during banner exchange
> lost connection
>
> Looks like an opportunity to improve the bisection engine?

Hi Ted,

Yes, these infrastructure errors plague bisections episodically.
That's https://github.com/google/syzkaller/issues/1250

It did not confuse bisection explicitly as it understands that these
are infrastructure failures rather then a kernel crash, e.g. here you
may that it correctly identified that this run was OK and started
bisection in v4.10 v4.9 range besides 2 scp failures:

testing release v4.9
testing commit 69973b830859bc6529a7a0468ba0d80ee5117826 with gcc (GCC) 5.5.=
0
run #0: basic kernel testing failed: failed to copy test binary to VM:
failed to run ["scp" ...]: exit status 1
Connection timed out during banner exchange
run #1: basic kernel testing failed: failed to copy test binary to VM:
failed to run ["scp" ....]: exit status 1
Connection timed out during banner exchange
run #2: OK
run #3: OK
run #4: OK
run #5: OK
run #6: OK
run #7: OK
run #8: OK
run #9: OK
# git bisect start v4.10 v4.9

Though, of course, it may confuse bisection indirectly by reducing
number of tests per commit.

So far I wasn't able to gather any significant info about these
failures. We gather console logs, but on these runs they are empty.
It's easy to blame everything onto GCE but I don't have any bit of
information that would point either way. These failures just appear
randomly in production and usually in batches...
