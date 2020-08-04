Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA9423C019
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 21:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgHDTkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 15:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHDTkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 15:40:42 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DF9C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 12:40:41 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id s189so36246287iod.2
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 12:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w1WbHL4xQrO82T4t0murfSWumuSOok96f+Ze+58P/0w=;
        b=k8C/FbAUIx5ytYJWJrxKOvaK0pQ74ctTCR9Lb9aie8YdWkhT7MMf1VLARozE1ekgXX
         XBK8VYp6N4KKFqc9MVGxtfRRuWaiqCN1G/Hl/yymToN/2sc9z4C3kFZ5NCTnSti4cYE+
         9t7hT+afK7+L3cw1JRJabRgksLw3W/szlbQbAqRojc6idAUE8k6GGo76jZdQf9W1nuaE
         XEZgVH14NTHyPw+Tor6t57AK8H0ADOToB6/iseyhhiCTmR1Qxl7XzIx63ad5BYpSGo/d
         qAE/hoE1Hb7ZdrjbQECqtBfBsacS8/iNKpSWFHppl61x2+p5Sv0xQDUpJ3PmWa17Rry+
         fTHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w1WbHL4xQrO82T4t0murfSWumuSOok96f+Ze+58P/0w=;
        b=K2Gh2w9QgjoLYTT8Vlm2SEfwN6Gc/qkErG1RhkMpFGemb12EXp1STt9Xs8ChH6a1nZ
         uMVh+Gw8Xn9MwjmkuulKyikiT8TW0fgBieTLm37sNk1a8dTfWQJq8hX7Z6vNGKbrJfsn
         Vq2jvZ3HULgkL3hKdZVk7znavXch5tf8VtNuzdvZfdyp6w2tzRJJwI1FxVlSlCneXBoQ
         RqKoZaOjp3fgBgW3XcD8lDGrn86f6FRf0xdG+PQTTbNm/j1nlRovUqiIKMo+37y359kF
         y29SE/uTIiEsvvo8cRBCJORur5goOBLECzJ93KKQowbE1BmyPwX+AnuwrsHaeTKyncvP
         rB6Q==
X-Gm-Message-State: AOAM533hQeK9777xYy5QcCGar8NqI81N1uyS/YLPk1zxUr0qB8WVd4zJ
        7zGqsLAZfJxsQGbMcn+g26Z08kIiQboLWCYlFVqjEg==
X-Google-Smtp-Source: ABdhPJxFOmK5tfzLbKZ6lZ2sSbnY2rAcye8Jjl42oTTxT+3Op1FoX0zwawhGnXwASx3JcyGJMJJ8tvAp7aLwllWzfbU=
X-Received: by 2002:a05:6638:2493:: with SMTP id x19mr7753752jat.53.1596570036068;
 Tue, 04 Aug 2020 12:40:36 -0700 (PDT)
MIME-Version: 1.0
References: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
 <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com> <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
 <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com> <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
 <20200804142708.zjos3b6jvqjj7uas@skbuf> <CANn89iKD1H9idd-TpHQ-KS7vYHnz+6VhymrgD2cuGAUHgp2Zpg@mail.gmail.com>
 <20200804192933.pe32dhfkrlspdhot@skbuf>
In-Reply-To: <20200804192933.pe32dhfkrlspdhot@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Aug 2020 12:40:24 -0700
Message-ID: <CANn89iKw+OGo9U9iXf61ELYRo-XzC41uz-tr34KtHcW26C-z8g@mail.gmail.com>
Subject: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 4, 2020 at 12:29 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Tue, Aug 04, 2020 at 07:54:18AM -0700, Eric Dumazet wrote:
> >
> > My 2013 commit was a bug fix, and hinted that in the future (eg in
> > net-next tree) the stop-the-bleed could be refined.
> >
> > +               /* Note: we might in the future use prio bits
> > +                * and set skb->priority like in vlan_do_receive()
> > +                * For the time being, just ignore Priority Code Point
> > +                */
> > +               skb->vlan_tci = 0;
> >
> > If you believe this can be done, this is great.
>
> Do you have a reproducer for that bug? I am willing to spend some time
> understand what is going on. This has nothing to do with priority. You
> vaguely described a problem with 802.1p (VLAN 0) and used that as an
> excuse to clear the entire vlan hwaccel tag regardless of VLAN ID. I'm
> curious because we also now have commit 36b2f61a42c2 ("net: handle
> 802.1P vlan 0 packets properly") in that general area, and I simply want
> to know if your patch still serves a valid purpose or not.
>

I do not have a repro, the patch seemed to help at that time,
according to the reporter.
