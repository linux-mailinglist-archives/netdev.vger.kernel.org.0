Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC513C3385
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 09:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhGJHnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 03:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhGJHnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 03:43:49 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6641BC0613DD;
        Sat, 10 Jul 2021 00:41:03 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id z9so12111614ljm.2;
        Sat, 10 Jul 2021 00:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J3M2lFQQkWADYzYRrw142XmW/y2EtUx80Feh7urviFw=;
        b=qqzmAnaTqwaqak1hIDu0ByN7iav3rU5iYWsPt91v6ebR+s0zkK32Hs1zekqHqmwsLM
         0VuGQffcpuHt87hMAjZxuYANOAjTBU/IfBRiWukqozPV8KW8OUi1IiezCoUpgTMBRacJ
         /rQ03IWMeDw5q3KYZHTy/6+O+PcJu22NffAmhDJ23w1ybJWD2CDedhiQnQun8LqzhuPA
         hxhV6nPvuSnFgXxk2qY1mf7W8LCoiSMnI56obfj2d1Vt5uAxjKDG3eeSCompD4/hx+LZ
         F41KJD6BxYR2zjVrIH180Eg30kfLK3Rregra+V1IL+fgvHCPsqIkOOo41YQt9cs4g9ao
         KPjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J3M2lFQQkWADYzYRrw142XmW/y2EtUx80Feh7urviFw=;
        b=fvpvKE7RNC3M/1CWSgFS2G4KPjTX0fB9DBjmshdiW/gxbxLHrSc01h5giQMwRxGu6o
         Hj4b1j6yQnWsdGnjf+s6gsN41Da6l7SmvRzsvnpZuK3AKkZ99ZaYC0U6H2id1p18h2Pw
         n/Oz5lh7L2d0Jw+MZGkZmUTbbBKF13aQhjd7zQikn1DrQnUFCowCEDuoL03PnuwpTgF8
         rL3f8irxvrXs3/FCMBWW0FBD8iW5DBZLzs1FlNCzJ+qnv+Xp7mLLv8nEOdOU2/OOxO0u
         sKLeu/iK/I79vCjKsodqfNrSqJbAnCMuuKexMPYiPPbYU39iaLiF3umGj0QBzLbHx1J1
         PuEg==
X-Gm-Message-State: AOAM532UyhhuErD07xIPQjv5Ol3LKCDlrWM40lli4ztWUcaODOoCr4Bh
        86ncknLEB6enZ2z6eNmnwDE=
X-Google-Smtp-Source: ABdhPJyx3kGSxpX+efcBmuQPlWofUdXErn2LHB5fkBwmG4GNz1ekEI9QyZJYEWztXhyk+ZaVT6qUNg==
X-Received: by 2002:a2e:504a:: with SMTP id v10mr20035915ljd.259.1625902861580;
        Sat, 10 Jul 2021 00:41:01 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id d14sm651273lfq.31.2021.07.10.00.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 00:41:01 -0700 (PDT)
Date:   Sat, 10 Jul 2021 10:40:52 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: cipso: fix memory leak in cipso_v4_doi_free
Message-ID: <20210710104052.1469c94a@gmail.com>
In-Reply-To: <CAD-N9QWcOv0s4uzPW0kGk70tpkCjorQCKpa3RrtbxyMmSW5b=Q@mail.gmail.com>
References: <cover.1625900431.git.paskripkin@gmail.com>
        <cec894625531da243df3a9f05466b83e107e50d7.1625900431.git.paskripkin@gmail.com>
        <CAD-N9QWcOv0s4uzPW0kGk70tpkCjorQCKpa3RrtbxyMmSW5b=Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Jul 2021 15:29:19 +0800
Dongliang Mu <mudongliangabcd@gmail.com> wrote:

> On Sat, Jul 10, 2021 at 3:10 PM Pavel Skripkin <paskripkin@gmail.com>
> wrote:
> >
> > When doi_def->type == CIPSO_V4_MAP_TRANS doi_def->map.std should
> > be freed to avoid memory leak.
> >
> > Fail log:
> >
> > BUG: memory leak
> > unreferenced object 0xffff88801b936d00 (size 64):
> > comm "a.out", pid 8478, jiffies 4295042353 (age 15.260s)
> > hex dump (first 32 bytes):
> > 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > 00 00 00 00 15 b8 12 26 00 00 00 00 00 00 00 00  .......&........
> > backtrace:
> > netlbl_cipsov4_add (net/netlabel/netlabel_cipso_v4.c:145
> > net/netlabel/netlabel_cipso_v4.c:416) genl_family_rcv_msg_doit
> > (net/netlink/genetlink.c:741) genl_rcv_msg
> > (net/netlink/genetlink.c:783 net/netlink/genetlink.c:800)
> > netlink_rcv_skb (net/netlink/af_netlink.c:2505) genl_rcv
> > (net/netlink/genetlink.c:813)
> >
> > Fixes: b1edeb102397 ("netlabel: Replace protocol/NetLabel linking
> > with refrerence counts")
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > ---
> >  net/ipv4/cipso_ipv4.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> > index bfaf327e9d12..e0480c6cebaa 100644
> > --- a/net/ipv4/cipso_ipv4.c
> > +++ b/net/ipv4/cipso_ipv4.c
> > @@ -472,6 +472,7 @@ void cipso_v4_doi_free(struct cipso_v4_doi
> > *doi_def) kfree(doi_def->map.std->lvl.local);
> >                 kfree(doi_def->map.std->cat.cipso);
> >                 kfree(doi_def->map.std->cat.local);
> > +               kfree(doi_def->map.std);
> >                 break;
> >         }
> >         kfree(doi_def);
> > --
> 
> Hi Paval,
> 
> this patch is already merged by Paul. See [1] for more details.
> 
> [1]
> https://lore.kernel.org/netdev/CAHC9VhQZVOmy7n14nTSRGHzwN-y=E_JTUP+NpRCgD8rJN5sOGA@mail.gmail.com/T/
> 


Hi, Dongliang!

Thank you for the information. I'm wondering, can maintainer pick only 1
patch from series, or I should send v2? 



With regards,
Pavel Skripkin
