Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25742A298E
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 00:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfH2WS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 18:18:57 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45799 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbfH2WS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 18:18:56 -0400
Received: by mail-io1-f67.google.com with SMTP id t3so10042592ioj.12;
        Thu, 29 Aug 2019 15:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=NMzxTj9QgBh2Pr7Ne/3+OQ1awCT7xR3SvdwiV+lU5kA=;
        b=MyLzrazQhX13DC7Ra6s73Pf+C0n1A5aU0ML4n8KJN3BhOX+4zDH2Q3czsXDo77LaXh
         WqJRfFEvUMQPw53Ja7xCvFA3QPN6gY/AvDitALBHQ/eM3HGKVwPmtWPjUJZb9dqAbomd
         b9CerBqFccvAHBoRWxkcF81IE9N61nKtwIMCVeP4KauUAdEqh2Yu3lvO3pH5LxyeaZsc
         wVs4pZMsJQacyjs74+yeSAhEPMafF1mPnk08K8oWMt4eiYUtKtTeK8BwW5HY8MYrRMzl
         U0o6wiVVyLE7FHSUt/gSI78JUZ0znvQNfiGRh/YHfjXklKD9di3J/6J6XG276KxPQz12
         wjQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=NMzxTj9QgBh2Pr7Ne/3+OQ1awCT7xR3SvdwiV+lU5kA=;
        b=MI0ih3eITixAYaMeWlBtCH4HOf5663seZlgm/BwI2Rr6slEJ2ONaOZ9tno6Lcb6oKS
         Q2imIu4oA70krNcJj/3PVpDWHydfeydVscPTmdr+oTxmChF6HSI90IVWpR5IOP2UZIB1
         slpFVe8pg+71qoc9pAohtC0SWyGWDxWfOGBp+p+BEcMT4GBsVWcdoAwveSzd7umYQGnw
         ajhWPRoZ6qmEgq3PngJEsdrUKNR1tnqTau+DE5B2U/isX3bjfu2q7xgoEdQgLh+m5mB/
         6Iy/4ig/D8wb2LfYj736hJYvShrWdB61z47Hud1jbJ4biL1rIlU/Yg94Ie7UlvWydgci
         cKSQ==
X-Gm-Message-State: APjAAAWGyxrEBfn0jSuS3IoZaAN9RDOSBudA5X12mnBnaCgTgb5IaK9m
        zAWB/CeJmHkTZswmCLNVaTQ=
X-Google-Smtp-Source: APXvYqxB3S1p4Y72kgiUDMNzk+Z03PVRglDS/xCD8jxWK/TxgKb5gUvU1Vau2O9BBlhMeyAqb35EQQ==
X-Received: by 2002:a5d:97d7:: with SMTP id k23mr13736369ios.129.1567117135905;
        Thu, 29 Aug 2019 15:18:55 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n25sm2821784iop.3.2019.08.29.15.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 15:18:55 -0700 (PDT)
Date:   Thu, 29 Aug 2019 15:18:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+7a6ee4d0078eac6bf782@syzkaller.appspotmail.com>,
        aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Message-ID: <5d684f46b5c51_6192b27353185bcf7@john-XPS-13-9370.notmuch>
In-Reply-To: <20190829115315.5686c18f@cakuba.netronome.com>
References: <000000000000c3c461059127a1c4@google.com>
 <20190829035200.3340-1-hdanton@sina.com>
 <20190829094343.0248c61c@cakuba.netronome.com>
 <5d681e0011c7b_6b462ad11252c5c084@john-XPS-13-9370.notmuch>
 <20190829115315.5686c18f@cakuba.netronome.com>
Subject: Re: general protection fault in tls_sk_proto_close (2)
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Thu, 29 Aug 2019 11:48:32 -0700, John Fastabend wrote:
> > Jakub Kicinski wrote:
> > > On Thu, 29 Aug 2019 11:52:00 +0800, Hillf Danton wrote:  
> > > > Alternatively work is done if sock is closed again. Anyway ctx is reset
> > > > under sock's callback lock in write mode.
> > > > 
> > > > --- a/net/tls/tls_main.c
> > > > +++ b/net/tls/tls_main.c
> > > > @@ -295,6 +295,8 @@ static void tls_sk_proto_close(struct so
> > > >  	long timeo = sock_sndtimeo(sk, 0);
> > > >  	bool free_ctx;
> > > >  
> > > > +	if (!ctx)
> > > > +		return;
> > > >  	if (ctx->tx_conf == TLS_SW)
> > > >  		tls_sw_cancel_work_tx(ctx);  
> > > 
> > > That's no bueno, the real socket's close will never get called.  
> > 
> > Seems when we refactored BPF side we dropped the check for ULP on one
> > path so I'll add that back now. It would be nice and seems we are
> > getting closer now that tls side is a bit more dynamic if the ordering
> > didn't matter.
> 
> We'd probably need some more generic way of communicating the changes
> in sk_proto stack, e.g. by moving the update into one of sk_proto
> callbacks? but yes.
> 
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index 1330a7442e5b..30d11558740e 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -666,6 +666,8 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
> >         WARN_ON_ONCE(!rcu_read_lock_held());
> >         if (unlikely(flags > BPF_EXIST))
> >                 return -EINVAL;
> > +       if (unlikely(icsk->icsk_ulp_data))
> > +               return -EINVAL;
> > 
> >         link = sk_psock_init_link();
> >         if (!link)
> 
> Thanks! That looks good, if you feel like submitting officially feel
> free to add my Reviewed-by!

I'll send it out this evening after running the selftests.

.John
