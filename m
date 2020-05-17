Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AE31D6D54
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 23:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgEQVDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 17:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgEQVDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 17:03:15 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE703C061A0C;
        Sun, 17 May 2020 14:03:14 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id x22so2808494otq.4;
        Sun, 17 May 2020 14:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j1pou6PElbPU5rdW+iVpvbmZNBSLhGw1lCyenaB4T5U=;
        b=jS9M2wj9nA1V30bbUECx/1Rq0X4+bk5GQTt/SQFdLJ+N0H25dr2kxHlwzlkBCKNxL4
         SEyHsFSfPtKCGTI3W+7cbY+cSpX0SrWesVo16rFbBQZe4COlfok8Pv+GpxNNmkPA6nz/
         ghSMRpkVPXDkCX5lAdfyaDMLUc5GCqoKDroCHNq2/ZcPZFLSjODDQ+xB1XcDnBU0txI7
         TMqwags3M4OSTGqZ1ubE0KdPfkOCdH8xjfpU2c6JF8JZodawaxKESuzOhPGH3iXsyYk9
         vuR+t2Vv8UWhATaG90oyMx5ef+w2FzpmD3UzcXe39hY34Vamd0ek/xakyYx0oVww7XkT
         7bEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j1pou6PElbPU5rdW+iVpvbmZNBSLhGw1lCyenaB4T5U=;
        b=UOQagg72hJxyMdXW3dpWzMBaijm1ndEq/BeZ/qf/La8ZriCjzgLi1JjurI1jdjABUa
         m4d0BDDE9CSyBSSmXix8uXNtP+8wdXRH3lYagcMlLML0+3h297ot9/v0fcfJLonf+Omo
         NLa7MTbei3lxMHO19yXWa6fbtfDswq9XgsTJtYwS4h2YkbW8E6yjq+eHzMZL9V7a5UIj
         b4sOm7Wrsv8Xn+S0P3MWq8ZWVxlCIoHMnh6JehCF6D8N21KhxsW8rkVhnOE+51M0Fkq8
         dn0BrNhq09GvzBKP94V0eKo+b3brmHvV3WZNWdVguWF+sgXE13omaPgDkdoFLPsf8G7Z
         vo1A==
X-Gm-Message-State: AOAM531I+n8OseErD4cyi5LOk8Upt/JscDBnO+c4445qhJ/kdyiCOm+7
        HQBLpVFgfeQXmP6iSgD/RPwf5evZU3wd4W4tYpk+osmmTlI=
X-Google-Smtp-Source: ABdhPJzZLM+pyfeDoGHz9WBtBEFU5u36kP0u9C0We1FlBPyRZ5MAjUk6866Cv8Cs3wi9MK2qoIcFGF6SmeOZaM3JnoY=
X-Received: by 2002:a9d:4a1:: with SMTP id 30mr7059106otm.319.1589749393779;
 Sun, 17 May 2020 14:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000735f5205a5b02279@google.com>
In-Reply-To: <000000000000735f5205a5b02279@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 17 May 2020 14:03:01 -0700
Message-ID: <CAM_iQpVknxRug8byRhEjeRcDwuvWYeD0sAQeGeZ1UarH44TG+Q@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in fl_dump_key
To:     syzbot <syzbot+9c1be56e9317b795e874@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 6:53 AM syzbot
<syzbot+9c1be56e9317b795e874@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    99addbe3 net: broadcom: Select BROADCOM_PHY for BCMGENET
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=173e568c100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b0212dbee046bc1f
> dashboard link: https://syzkaller.appspot.com/bug?extid=9c1be56e9317b795e874
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+9c1be56e9317b795e874@syzkaller.appspotmail.com
>
> BUG: unable to handle page fault for address: fffffbfff4a9538a
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 21ffe5067 P4D 21ffe5067 PUD 21ffe4067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 5831 Comm: syz-executor.3 Not tainted 5.7.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:fl_dump_key+0x8c/0x1980 net/sched/cls_flower.c:2514
> Code: 04 f2 04 f2 c7 40 0c 04 f3 f3 f3 65 48 8b 04 25 28 00 00 00 48 89 84 24 b0 00 00 00 31 c0 e8 3b 0d 20 fb 48 89 e8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 74 08 3c 03 0f 8e 6f 17 00 00 44 8b 75 00 31
> RSP: 0018:ffffc900019672d8 EFLAGS: 00010a03
> RAX: 1ffffffff4a9538a RBX: ffffffffa54a9a8f RCX: ffffc9000f733000
> RDX: 000000000000080f RSI: ffffffff86532275 RDI: ffff88808f68b800
> RBP: ffffffffa54a9c57 R08: ffff888096266200 R09: ffff888097a5603c
> R10: ffff888097a56036 R11: ffffed1012f4ac06 R12: ffff88808f68b800
> R13: ffff88806780a100 R14: dffffc0000000000 R15: ffff88806780a100
> FS:  00007f0a86395700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffffbfff4a9538a CR3: 0000000099de6000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  fl_tmplt_dump+0xcf/0x250 net/sched/cls_flower.c:2784
>  tc_chain_fill_node+0x48e/0x7c0 net/sched/cls_api.c:2707
>  tc_chain_notify+0x189/0x2e0 net/sched/cls_api.c:2733
>  tc_ctl_chain+0xb82/0x1080 net/sched/cls_api.c:2919

I guess the chain template name must be specified by user:

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 0a7ecc292bd3..bcacb7db70c6 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2782,8 +2782,10 @@ static int tc_chain_tmplt_add(struct tcf_chain
*chain, struct net *net,
        void *tmplt_priv;

        /* If kind is not set, user did not specify template. */
-       if (!tca[TCA_KIND])
-               return 0;
+       if (!tca[TCA_KIND]) {
+               NL_SET_ERR_MSG(extack, "TC chain template name is not
specified");
+               return -EINVAL;
+       }

        if (tcf_proto_check_kind(tca[TCA_KIND], name)) {
                NL_SET_ERR_MSG(extack, "Specified TC chain template
name too long");
