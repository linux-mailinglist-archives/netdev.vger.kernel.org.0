Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86FB9324DE
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfFBVB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:01:57 -0400
Received: from mail-it1-f181.google.com ([209.85.166.181]:38977 "EHLO
        mail-it1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfFBVB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:01:56 -0400
Received: by mail-it1-f181.google.com with SMTP id j204so18247243ite.4
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 14:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HC8vtrRsh50Ohc3EaIB0NoebMSo23njywbCwxitxUSo=;
        b=G05oV6yGANfGUrsafNDMFdY+sdiwhud8O9hlc5blEpxavx9e8NMec2fjDyxse4N94X
         2a89tU71cAzexNCkHgP9PRg5MZKqWwfvM5tdRQOUzBE+IVLhk0nxFDg1nKUAGhNgYJWK
         OTOxrwoH4oo/4pDSoZ0Fkojiw/sCTsCbJPv9w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HC8vtrRsh50Ohc3EaIB0NoebMSo23njywbCwxitxUSo=;
        b=bCF2WZMasNEC7Q9YTx3qGcsfmnx2lM2w40wt60cw11+gSa74g3y72dDmsoQDOz8t/K
         4prCCmHZgfHJ7Zk12zMhAuz2KuaWml5Chwr9i4rRFCgFfxFhhRtHkPq8qzEVV9Jy2kqR
         ryZ/S6JBFnQnE0Nmw36pgJXW+5OcD/Ni/WW+z/4Lkg+752ECM9lMuEwWXXylYd7FRuTr
         7N2A1/QaFFUNQ7oXGhjfxDaztUUMvSxLGV5YogfyxFgK5dXHiTOTatpiyc7sqUATF4pv
         DLn1bhJfEJgGkZa3ccgBNFVW6hMmN8ThOzoGUpcRPehJGiFD/7UkLoHnYvKaQEDqXhuC
         fDnA==
X-Gm-Message-State: APjAAAVPSKXvqsAaDwk6xbv4LWeUaStALaOhaisd0CHYn90oP1aA0gwj
        2gwSSEnYhxQF9EIUKpI1o76cYGwxyb4=
X-Google-Smtp-Source: APXvYqwmbn/0VJ92ZVH0Jh0y6E6MNL+UMIeeEO/hqUEgzPjszy16bKBv9mPE2GYhwBE7U3BexobTNA==
X-Received: by 2002:a05:660c:a8e:: with SMTP id m14mr14216583itk.169.1559509314758;
        Sun, 02 Jun 2019 14:01:54 -0700 (PDT)
Received: from mail-it1-f170.google.com (mail-it1-f170.google.com. [209.85.166.170])
        by smtp.gmail.com with ESMTPSA id n26sm4176978ioc.74.2019.06.02.14.01.54
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:01:54 -0700 (PDT)
Received: by mail-it1-f170.google.com with SMTP id i21so4488158ita.5
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 14:01:54 -0700 (PDT)
X-Received: by 2002:a24:5652:: with SMTP id o79mr15076656itb.164.1559508868756;
 Sun, 02 Jun 2019 13:54:28 -0700 (PDT)
MIME-Version: 1.0
References: <20150910005708.GA23369@wfg-t540p.sh.intel.com>
 <20150910102513.GA1677@fixme-laptop.cn.ibm.com> <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com> <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com> <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
In-Reply-To: <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 2 Jun 2019 13:54:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
Message-ID: <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
Subject: Re: rcu_read_lock lost its compiler barrier
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 1, 2019 at 10:56 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> You can't then go and decide to remove the compiler barrier!  To do
> that you'd need to audit every single use of rcu_read_lock in the
> kernel to ensure that they're not depending on the compiler barrier.

What's the possible case where it would matter when there is no preemption?

          Linus
