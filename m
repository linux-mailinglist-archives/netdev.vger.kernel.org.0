Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F08081376AF
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgAJTJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:09:28 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42288 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727448AbgAJTJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:09:28 -0500
Received: by mail-oi1-f195.google.com with SMTP id 18so2781974oin.9;
        Fri, 10 Jan 2020 11:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kcu1M9u0fKXhYde93cLWMfS1bu+/Sqpq3Xxjg8yPfgE=;
        b=uTvla9/RwAC4Gb1XeGvMf1m8nX3xtJMrNX2pzSpoHpiPGrTkPvyiO0DlRqI8OoeiU3
         e/yyUpsRaz/3i9KGgA4vqZyc/YeB0spWAiXa8n6BluiGRkHkjo9oWkNGz+OgC512X7nU
         sEVcsS6tyctLAY4EgetnFy4VzY0vMot7qSPD17Mv5G4f11XIiEthXlEizIErEomXL8BA
         lctYm9S+SwMptnfiD9BK9QP8wjSO+nKTeG4afHLpc1//TA9SmdC804IGalwd2l5Q2MC4
         IXmPqMrxoi04u/w3E7UObSi8clvspX/u+tyw84nhbVIBFQXCfzBFjSuQIX9mYMyGzZBE
         BZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kcu1M9u0fKXhYde93cLWMfS1bu+/Sqpq3Xxjg8yPfgE=;
        b=nD9XM/dYjjsiWoHvnWx4krqxuKBoqDLcniFdPdTq6a4ynpFktWKPcqeCjvhvdBmkcG
         7UYQQO0l38QkwM+VIMlRKMX0A9I9NtqoCR8DE9aSzKkhmxJHxMo4EG4ya+1OMfeYYyDD
         v+Yya1HFeCrWgQSrA/E8edODPOgtHNWvPDeCMmbG3odPxaGq/d0PPtDTMOCZ4DUQdNAF
         LgiUE2zlE+N24UgLOfZdt/+CUip82iDqwNDwpysBHE4AfJBgP7IneHqmjWsZ+mssFKzO
         jA0Umw5t6f0ICgBHltcRZeKsh9U4xYUwFvCnLgV+ATa9hSFCJAcl4uY/j0eXFAG3YWaB
         pGig==
X-Gm-Message-State: APjAAAUsLOLXixmIH2lLMAA2tJ/hlJi2qe3p1wr4qrH9PM3A1Zzb4pWn
        AtPiCdhpNf5KLQEq6OUJPM/VnKlYvkT+GG78jaA=
X-Google-Smtp-Source: APXvYqxi8sngqdAXFRdFWKg2sxSXcJ6veTc5AVMdcmdmeaQ4N96FkwDtjYoHoLdMhLBDZCprUD4l012VFOREU/wXIkU=
X-Received: by 2002:aca:1011:: with SMTP id 17mr3502147oiq.72.1578683367302;
 Fri, 10 Jan 2020 11:09:27 -0800 (PST)
MIME-Version: 1.0
References: <000000000000f744e0059bcd8216@google.com>
In-Reply-To: <000000000000f744e0059bcd8216@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 10 Jan 2020 11:09:16 -0800
Message-ID: <CAM_iQpWz+ivP2vS50rY94DiR6qSh1W0WKjqgBNKYpUH_VFPgGw@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in bitmap_port_ext_cleanup
To:     syzbot <syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com>
Cc:     Arvid Brodin <arvid.brodin@alten.se>, coreteam@netfilter.org,
        David Miller <davem@davemloft.net>, florent.fourcot@wifirst.fr,
        Florian Westphal <fw@strlen.de>, jeremy@azazel.net,
        Johannes Berg <johannes.berg@intel.com>, kadlec@netfilter.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 10:44 AM syzbot
<syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    b07f636f Merge tag 'tpmdd-next-20200108' of git://git.infr..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16c03259e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
> dashboard link: https://syzkaller.appspot.com/bug?extid=4c3cc6dbe7259dbf9054
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c365c6e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117df9e1e00000
>
> The bug was bisected to:
>
> commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Thu Jul 4 00:21:13 2019 +0000
>
>      hsr: implement dellink to clean up resources
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=118759e1e00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=138759e1e00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=158759e1e00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com
> Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")
>
> ==================================================================
> BUG: KASAN: use-after-free in test_bit
> include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
> BUG: KASAN: use-after-free in bitmap_port_ext_cleanup+0xe6/0x2a0
> net/netfilter/ipset/ip_set_bitmap_gen.h:51
> Read of size 8 at addr ffff8880a87a47c0 by task syz-executor559/9563
>
> CPU: 0 PID: 9563 Comm: syz-executor559 Not tainted 5.5.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x197/0x210 lib/dump_stack.c:118
>   print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
>   __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
>   kasan_report+0x12/0x20 mm/kasan/common.c:639
>   check_memory_region_inline mm/kasan/generic.c:185 [inline]
>   check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
>   __kasan_check_read+0x11/0x20 mm/kasan/common.c:95
>   test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
>   bitmap_port_ext_cleanup+0xe6/0x2a0

map->members is freed by ip_set_free() right before using it in
mtype_ext_cleanup() again. So I think probably we just have to
move it down:

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h
b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 1abd6f0dc227..077a2cb65fcb 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -60,9 +60,9 @@ mtype_destroy(struct ip_set *set)
        if (SET_WITH_TIMEOUT(set))
                del_timer_sync(&map->gc);

-       ip_set_free(map->members);
        if (set->dsize && set->extensions & IPSET_EXT_DESTROY)
                mtype_ext_cleanup(set);
+       ip_set_free(map->members);
        ip_set_free(map);

        set->data = NULL;

Thanks.
