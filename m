Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0337F35D2F0
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 00:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343652AbhDLWR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 18:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240100AbhDLWR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 18:17:56 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7952C061574;
        Mon, 12 Apr 2021 15:17:37 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k21so1148476pll.10;
        Mon, 12 Apr 2021 15:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eqMfZ9uDSMPVYNe4oF3x3rg/XnK6ZxSzgJH1Um+dq1g=;
        b=Ju2zF6bVacD6Eu+b7uVnDJyLnM9tiGwBUtNLK879GvPrXdKLiTI2ur+5NB+yCzapkX
         btcZ3vnvxrKGaU0q0VCwCEQuf3n+bs9HRV3VFPyhzISzZ2VWaFr1PkZ41waH7CjtyvOk
         xxHz7Wwd4cj0yUo0BlhLWxntoMKmMJkyASKdtt/NEaCfy3hDjUibz3prZzEEQ64G2loN
         zmPTedh/kZVxlgZuRc6Oksx2x4w6ayjkWbzuqeMAjplEaV94Ihkq2q2upvAql6IfQne/
         61JuGu8eit+llUlu2tVkhN2t3v0lfAq+Q+Wtwlrf/3YiN0ooCzydsP7M+eetBO6tZeYZ
         Jbzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eqMfZ9uDSMPVYNe4oF3x3rg/XnK6ZxSzgJH1Um+dq1g=;
        b=Y391mVAJSVnG06efmPpb+JOm1z6+xP7TDiRkPbqJoOYzBIxvyXTYR5tm6JlM4bfmJK
         uRN0Hpu+ovDkFPwHACkoaTOFxACJAgCTEvLZKPgyyReG0Y7Zlu/+r/bURAuq7Vt+CSXD
         7RDDTD0OjMeF+X0b0ay0UP1jQmhT5xVQUmegJrIZfAzz1sLEZPFsKJaEtjYr0ovX0TEz
         QdUInzLZ9PayQL/wtU4TjAhwDOCp6g93uQMvpFnJ6fJJemKYsCsYWUhZQRy3Bn3kItkp
         wRF3dyZmIxNgfM9LNSnoVZ4FPJCaOisZkvQQOZg48G57hDEcGNq0HYiGNCl7PfZg2Q5L
         CejA==
X-Gm-Message-State: AOAM531MAuwSXlBmTek9SOwV8roTEPelV6Kg2oShN4TILqM/tqZ+5JGU
        JrdSZ91IUUwg+6LXx1QehCE=
X-Google-Smtp-Source: ABdhPJx+aIDD2NkWc6lwFtvcBzE0mkVok62Wqoc4sdLaWOOtSmYZP4Xdcd+5CDYJQVyFf5ofeOAqKg==
X-Received: by 2002:a17:90b:3656:: with SMTP id nh22mr1347599pjb.112.1618265857365;
        Mon, 12 Apr 2021 15:17:37 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id v135sm12829858pgb.82.2021.04.12.15.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 15:17:36 -0700 (PDT)
Date:   Tue, 13 Apr 2021 01:17:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20210412221721.3gszur3hbrkhe76m@skbuf>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
 <20210411200135.35fb5985@thinkpad>
 <20210411185017.3xf7kxzzq2vefpwu@skbuf>
 <20210412150045.929508-1-dqfext@gmail.com>
 <20210412163211.jrqtwwz2f7ftyli6@skbuf>
 <20210413000457.61050ea3@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413000457.61050ea3@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 12:04:57AM +0200, Marek Behun wrote:
> On Mon, 12 Apr 2021 19:32:11 +0300
> Vladimir Oltean <olteanv@gmail.com> wrote:
>
> > On Mon, Apr 12, 2021 at 11:00:45PM +0800, DENG Qingfang wrote:
> > > On Sun, Apr 11, 2021 at 09:50:17PM +0300, Vladimir Oltean wrote:
> > > >
> > > > So I'd be tempted to say 'tough luck' if all your ports are not up, and
> > > > the ones that are are assigned statically to the same CPU port. It's a
> > > > compromise between flexibility and simplicity, and I would go for
> > > > simplicity here. That's the most you can achieve with static assignment,
> > > > just put the CPU ports in a LAG if you want better dynamic load balancing
> > > > (for details read on below).
> > > >
> > >
> > > Many switches such as mv88e6xxx only support MAC DA/SA load balancing,
> > > which make it not ideal in router application (Router WAN <--> ISP BRAS
> > > traffic will always have the same DA/SA and thus use only one port).
> >
> > Is this supposed to make a difference? Choose a better switch vendor!
>
> :-) Are you saying that we shall abandon trying to make the DSA
> subsystem work with better performace for our routers, in order to
> punish ourselves for our bad decision to use Marvell switches?

No, not at all, I just don't understand what is the point you and
Qingfang are trying to make. LAG is useful in general for load balancing.
With the particular case of point-to-point links with Marvell Linkstreet,
not so much. Okay. With a different workload, maybe it is useful with
Marvell Linkstreet too. Again okay. Same for static assignment,
sometimes it is what is needed and sometimes it just isn't.
It was proposed that you write up a user space program that picks the
CPU port assignment based on your favorite metric and just tells DSA to
reconfigure itself, either using a custom fancy static assignment based
on traffic rate (read MIB counters every minute) or simply based on LAG.
All the data laid out so far would indicate that this would give you the
flexibility you need, however you didn't leave any comment on that,
either acknowledging or explaining why it wouldn't be what you want.
