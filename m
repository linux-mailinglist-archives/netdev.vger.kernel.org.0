Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE67325C7EA
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 19:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgICRQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 13:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgICRQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 13:16:34 -0400
X-Greylist: delayed 586 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Sep 2020 10:16:33 PDT
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93AAC061244;
        Thu,  3 Sep 2020 10:16:33 -0700 (PDT)
Received: from vlad-x1g6 (unknown [IPv6:2a01:d0:40b3:9801:fec2:781d:de90:e768])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 166AC1F899;
        Thu,  3 Sep 2020 20:06:42 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1599152802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cYNnDoJ2SqlCA9nFNN49olKHiWCFYIXnAJSiUk0aIBM=;
        b=o+yStLzcfvZNIJO6NNb9dvjI+5O3MhqRLR3OFTuTxow1TKMp5g7TPcIPxwLPNsZ9eYE16n
        RTxfgBicNm3PWsYaxdfm/gOTu/IBdiN7uAvb2T5Dfj7N/tYkROsPaFtukCJHK+dPYqkbhF
        WNq4uPsDA19MlOhFFcqiUFiPE0DRpg5jFMyRha7yg6Jm76Ce4CZdfxGAtfWNJcHERtGY/5
        +hDFhvX57Qms43rg1MhTD7pNTzxqPxCOHNpoN5TvznezApbqp8v+o8yWQwfZCOkH+FktQ3
        tCW7ntfmdJyUDhE3p5U09e+mBEnScYR3HbR8g8b24j5jhSoqChg4dGLd09+xBg==
References: <00000000000014fd1405ae64d01f@google.com> <000000000000fcd01005ae6a77e7@google.com>
User-agent: mu4e 1.4.10; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     syzbot <syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, eric.dumazet@gmail.com, jhs@mojatatu.com,
        jiri@mellanox.com, jiri@resnulli.us, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vladbu@mellanox.com, xiyou.wangcong@gmail.com
Subject: Re: INFO: task hung in tcf_ife_init
In-reply-to: <000000000000fcd01005ae6a77e7@google.com>
Date:   Thu, 03 Sep 2020 20:08:23 +0300
Message-ID: <878sdqg54o.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 03 Sep 2020 at 18:33, syzbot <syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com> wrote:
> syzbot has bisected this issue to:
>
> commit 4e8ddd7f1758ca4ddd0c1f7cf3e66fce736241d2
> Author: Vlad Buslov <vladbu@mellanox.com>
> Date:   Thu Jul 5 14:24:30 2018 +0000
>
>     net: sched: don't release reference on action overwrite
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14ae08e9900000
> start commit:   1996cf46 net: bcmgenet: fix mask check in bcmgenet_validat..
> git tree:       net
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=16ae08e9900000
> console output: https://syzkaller.appspot.com/x/log.txt?x=12ae08e9900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a0437fdd630bee11
> dashboard link: https://syzkaller.appspot.com/bug?extid=80e32b5d1f9923f8ace6
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=161678e1900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14f826d1900000
>
> Reported-by: syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com
> Fixes: 4e8ddd7f1758 ("net: sched: don't release reference on action overwrite")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

The trace in bisection result doesn't seem to be related to the original
report and is fixed by 32039eac4c48 ("net: sched: act_ife: always
release ife action on init error").
