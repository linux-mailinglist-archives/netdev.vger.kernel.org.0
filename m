Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5B018069E
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 19:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbgCJSeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 14:34:09 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44442 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgCJSeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 14:34:08 -0400
Received: by mail-ot1-f68.google.com with SMTP id v22so14137022otq.11;
        Tue, 10 Mar 2020 11:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kvx5AFxHMm/WOEF5HnQnZ+LRGkXEqn0izG5OxI9yOg4=;
        b=JBmTqLsv0jhi4ox/CpoU1wliDYVO29WUH0s8N/o7dlV+K2cRy4Xu8cEdvRRA6Unzob
         1zulcFPcd3+CDqdCZTx5hajX5Hbv/FzZvgbVOGMbbkYtpt8a9ZnlBre3LqNPexEkoU4H
         AHKiwiXftUPHnBFog3rBAOqq1N0sNQJv1fCWRcMkTMYaa73j4O5DfXr/DOlewNItFi04
         /2bmuSfcBQy19XLEg5ggOhU0UB0dhcSZWYZLdvqG/qSB8yK1XF7zFxrVcJHVLCE8Bsm+
         Q4tfN7V9sxkp7Uz4V3QE5khO4zJI+0Gm76aipfR5iJ3pUTfFbANd98+/LTXpgV2oHUFf
         d3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kvx5AFxHMm/WOEF5HnQnZ+LRGkXEqn0izG5OxI9yOg4=;
        b=F6rD8yHYmKJhTod0i5USAXKROFTaZ/TdVnNxxpu5fZrmClM93wMkOJ4GTkHXr8Eg48
         U61XrtEME54yGN0ZC/XKkPkD07g5yOaXnHCJ3I0vZ++PJ9ldITU9hbinaa51N4ZRxeJS
         zwJFTjgrnNJyQG/w156wFAH77vZTJtodLXdWddmlVNnPpYF8d6vLK2iA25hB3LW41Y6M
         J4bHgGDBajXiZ5TwnQMFgPikwRYrgIYXMC+i0LdyeVvLeEAusLtDNw0KyEBWhQkIASuS
         M0DMmDYYdsYTmJ0fH3VyCdWWcsNlSEx9BcfVbwCaNCFjhhD1JwcpeFmeA8NXq/VRpXZ7
         Q5rg==
X-Gm-Message-State: ANhLgQ1fuMvKEL5R2eYz9NxoSzQo0N6TEDe8UTmy7FK0xL3cn6VtMQJ8
        qBbsFJ5/SsMNWqMeHv29ZF7EZDLFhmlipUSICjo=
X-Google-Smtp-Source: ADFU+vsqEbDH7uuRIoc6YR/QXBvYof8HLvKsAKFpP1UL5Omu5tROekHDpSgX/VrnYxXURqUFS3TNvPSlunitMwojpaE=
X-Received: by 2002:a9d:2f44:: with SMTP id h62mr1475234otb.189.1583865247915;
 Tue, 10 Mar 2020 11:34:07 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000034513e05a05cfc23@google.com>
In-Reply-To: <00000000000034513e05a05cfc23@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 10 Mar 2020 11:33:56 -0700
Message-ID: <CAM_iQpVgQ+Mc16CVds-ywp6YHEbwbGtJwqoQXBFbrMTOUZS0YQ@mail.gmail.com>
Subject: Re: KASAN: invalid-free in tcf_exts_destroy
To:     syzbot <syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com>
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

On Sun, Mar 8, 2020 at 12:35 PM syzbot
<syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    c2003765 Merge tag 'io_uring-5.6-2020-03-07' of git://git...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10cd2ae3e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4527d1e2fb19fd5c
> dashboard link: https://syzkaller.appspot.com/bug?extid=dcc34d54d68ef7d2d53d
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1561b01de00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15aad2f9e00000
>
> The bug was bisected to:
>
> commit 599be01ee567b61f4471ee8078870847d0a11e8e
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Mon Feb 3 05:14:35 2020 +0000
>
>     net_sched: fix an OOB access in cls_tcindex
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10a275fde00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=12a275fde00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=14a275fde00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com
> Fixes: 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")
>
> IPVS: ftp: loaded support on port[0] = 21
> ==================================================================
> BUG: KASAN: double-free or invalid-free in tcf_exts_destroy+0x62/0xc0 net/sched/cls_api.c:3002
>
> CPU: 1 PID: 9507 Comm: syz-executor467 Not tainted 5.6.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:374
>  kasan_report_invalid_free+0x61/0xa0 mm/kasan/report.c:468
>  __kasan_slab_free+0x129/0x140 mm/kasan/common.c:455
>  __cache_free mm/slab.c:3426 [inline]
>  kfree+0x109/0x2b0 mm/slab.c:3757
>  tcf_exts_destroy+0x62/0xc0 net/sched/cls_api.c:3002
>  tcf_exts_change+0xf4/0x150 net/sched/cls_api.c:3059
>  tcindex_set_parms+0xed8/0x1a00 net/sched/cls_tcindex.c:456

Looks like a consequence of "slab-out-of-bounds Write in tcindex_set_parms".

Thanks.
