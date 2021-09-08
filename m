Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB28F404060
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 22:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352436AbhIHU7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 16:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhIHU7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 16:59:24 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C45C061575;
        Wed,  8 Sep 2021 13:58:15 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id z9-20020a7bc149000000b002e8861aff59so2631478wmi.0;
        Wed, 08 Sep 2021 13:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hSocSWxCXqTtY7IKswJjQcQ4A/k6XRZNGQUNO2WMnGY=;
        b=VUBU5OR6v6gVEVmrEFfx+o4vCn96JH3KGMWJo7zyAa7DlTJtK01Yt6qimX3yltc18z
         dKIJb14ozxEjNI66XlGwkXYhwClNZ0nwF2/BKIeNMFm9Wrt0/pFvP0hcZbDfroRRAy28
         pa8QSLqqfLiVEgh95eu4r8zQ3jndK8s9vqbCHVDagX0kDNnR9hMKpA069XKRXd6nPNS4
         VASY33S7Ey2PpLg6HOM/uKMKlUhBZEdhiMcgNsy8KUgymWJHyC5FN/y2EdXhaGXX+evg
         hkHrZ8u8YAu8k1fpC0RFjJFvMKgBN7YY2QqqnnYZOfl/oGM17FfyC6yFj+Cavj2qHHLZ
         qGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=hSocSWxCXqTtY7IKswJjQcQ4A/k6XRZNGQUNO2WMnGY=;
        b=HEJhwWxmDwl6RHCCEkfr3VsA5eGgnEFQdzZ387UpFZBmYuM/LTTpY4sJanxMrV9DRK
         amEu70HNhX0vUeURRdlbyjQw1dwWO9vBQUF71EY+VLjVyoH5EGv3WLRYu+nhPi2uB1S4
         PwQSSmhy9y3rTUYsJbnP25NDvtxJeAw1vkrRFfg7QBWFEZXnWuX+qIiZ5NKrcPgwSxCe
         f2ExssDG+BYKPVZRoqotW6wzeYtl0sJYizzwTCO9d8gn7TGHwHm+RllYNkAXmaVJE/rp
         A5yaMVEOG1B9t3A6uFNHZ7HVs3KV+VnPAxB3KMaEAp6fH2oxt8zfQafokiQIxFrlJFBD
         26ng==
X-Gm-Message-State: AOAM532VOf+QmIhzmOgfbU/fZsNjfERWIZ5iLEYERafh9CwQkbnbyV1N
        pnCbj+rBqYsNG90DG82YobiSNhUoNN58Ug==
X-Google-Smtp-Source: ABdhPJzGzcRN8XlxAJDijyjtEXq0U8rBWTPf+y5u0tB1o3a6kslnKemjvmsLF2GMUiU9xXFGEB+RTA==
X-Received: by 2002:a7b:c255:: with SMTP id b21mr176029wmj.44.1631134694106;
        Wed, 08 Sep 2021 13:58:14 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id f17sm231024wrt.63.2021.09.08.13.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 13:58:12 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Wed, 8 Sep 2021 22:58:11 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     syzbot <syzbot+ce96ca2b1d0b37c6422d@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        stable@vger.kernel.org, elbrus@debian.org
Subject: Re: [syzbot] general protection fault in nft_set_elem_expr_alloc
Message-ID: <YTkj4xH2Ol075+Ge@eldamar.lan>
References: <000000000000ef07b205c3cb1234@google.com>
 <20210602170317.GA18869@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602170317.GA18869@salvia>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

On Wed, Jun 02, 2021 at 07:03:17PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jun 02, 2021 at 09:37:26AM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    6850ec97 Merge branch 'mptcp-fixes-for-5-13'
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1355504dd00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=770708ea7cfd4916
> > dashboard link: https://syzkaller.appspot.com/bug?extid=ce96ca2b1d0b37c6422d
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1502d517d00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12bbbe13d00000
> > 
> > The issue was bisected to:
> > 
> > commit 05abe4456fa376040f6cc3cc6830d2e328723478
> > Author: Pablo Neira Ayuso <pablo@netfilter.org>
> > Date:   Wed May 20 13:44:37 2020 +0000
> > 
> >     netfilter: nf_tables: allow to register flowtable with no devices
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10fa1387d00000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=12fa1387d00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=14fa1387d00000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+ce96ca2b1d0b37c6422d@syzkaller.appspotmail.com
> > Fixes: 05abe4456fa3 ("netfilter: nf_tables: allow to register flowtable with no devices")
> > 
> > general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
> > CPU: 1 PID: 8438 Comm: syz-executor343 Not tainted 5.13.0-rc3-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:nft_set_elem_expr_alloc+0x17e/0x280 net/netfilter/nf_tables_api.c:5321
> > Code: 48 c1 ea 03 80 3c 02 00 0f 85 09 01 00 00 49 8b 9d c0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 70 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d9 00 00 00 48 8b 5b 70 48 85 db 74 21 e8 9a bd
> 
> It's a real bug. Bisect is not correct though.
> 
> I'll post a patch to fix it. Thanks.

So if I see it correctly the fix landed in ad9f151e560b ("netfilter:
nf_tables: initialize set before expression setup") in 5.13-rc7 and
landed as well in 5.12.13. The issue is though still present in the
5.10.y series.

Would it be possible to backport the fix as well to 5.10.y? It is
needed there as well.

Regards,
Salvatore
