Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4843BF8F
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390211AbfFJWms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:42:48 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48836 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388328AbfFJWms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 18:42:48 -0400
X-Greylist: delayed 4513 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2019 18:42:47 EDT
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1haRpD-0007Ex-Hn; Mon, 10 Jun 2019 15:27:31 -0600
Received: from ip72-206-97-68.om.om.cox.net ([72.206.97.68] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1haRpC-0006xo-Kg; Mon, 10 Jun 2019 15:27:31 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     syzbot <syzbot+f625baafb9a1c4bfc3f6@syzkaller.appspotmail.com>
Cc:     aarcange@redhat.com, akpm@linux-foundation.org,
        andrea.parri@amarulasolutions.com, ast@kernel.org,
        avagin@gmail.com, daniel@iogearbox.net, dbueso@suse.de,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, oleg@redhat.com, prsood@codeaurora.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000c0d84e058ad677aa@google.com>
Date:   Mon, 10 Jun 2019 16:27:15 -0500
In-Reply-To: <000000000000c0d84e058ad677aa@google.com> (syzbot's message of
        "Sat, 08 Jun 2019 14:17:00 -0700")
Message-ID: <87ftoh6si4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1haRpC-0006xo-Kg;;;mid=<87ftoh6si4.fsf@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=72.206.97.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18S7yGkdj8GdsnV3+U9rf+Fa62sIZ/bY/0=
X-SA-Exim-Connect-IP: 72.206.97.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa08.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,LotsOfNums_01,T_TM2_M_HEADER_IN_MSG,XMGappySubj_01
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4996]
        *  0.5 XMGappySubj_01 Very gappy subject
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;syzbot <syzbot+f625baafb9a1c4bfc3f6@syzkaller.appspotmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 489 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 4.1 (0.8%), b_tie_ro: 3.1 (0.6%), parse: 1.02
        (0.2%), extract_message_metadata: 17 (3.4%), get_uri_detail_list: 3.2
        (0.7%), tests_pri_-1000: 11 (2.3%), tests_pri_-950: 1.45 (0.3%),
        tests_pri_-900: 1.19 (0.2%), tests_pri_-90: 26 (5.2%), check_bayes: 24
        (4.8%), b_tokenize: 5 (1.1%), b_tok_get_all: 8 (1.7%), b_comp_prob:
        1.99 (0.4%), b_tok_touch_all: 5 (1.0%), b_finish: 0.90 (0.2%),
        tests_pri_0: 416 (85.1%), check_dkim_signature: 0.60 (0.1%),
        check_dkim_adsp: 3.4 (0.7%), poll_dns_idle: 0.19 (0.0%), tests_pri_10:
        2.1 (0.4%), tests_pri_500: 6 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: general protection fault in mm_update_next_owner
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+f625baafb9a1c4bfc3f6@syzkaller.appspotmail.com> writes:

> syzbot has bisected this bug to:
>
> commit e9db4ef6bf4ca9894bb324c76e01b8f1a16b2650
> Author: John Fastabend <john.fastabend@gmail.com>
> Date:   Sat Jun 30 13:17:47 2018 +0000
>
>     bpf: sockhash fix omitted bucket lock in sock_close
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e978e1a00000
> start commit:   38e406f6 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       net
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=17e978e1a00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=13e978e1a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=60564cb52ab29d5b
> dashboard link: https://syzkaller.appspot.com/bug?extid=f625baafb9a1c4bfc3f6
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1193d81ea00000
>
> Reported-by: syzbot+f625baafb9a1c4bfc3f6@syzkaller.appspotmail.com
> Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

How is mm_update_next_owner connected to bpf?

Eric
