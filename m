Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E040624305F
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 23:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgHLVH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 17:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgHLVH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 17:07:27 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A15C061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 14:07:26 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b14so3423234qkn.4
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 14:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fJAXiWtv3ENsVIdhVjykYqtG1mE3q0gWd4cfM6Uu6RI=;
        b=Wy2XrhQPxQURScDdynKkkj9CvVAozBUCH6dRkMuUHiGAftZNug/9drAE7zWmrg9Dt4
         UTqrvt0QUSCpZiCntddL6sxqa208yifZdA86B25XMHf6BQ5Q005WgFXN+BBKN0/KOHey
         j6XjXK7pe0KQsMobKUcJ1zI96zsVBsNt5isS2/pbGvLFL7ZaRI7LGITKpec9rGXz8ng8
         rDsyeGGcjuIn7kLRHaUTHAd0R5bIp7gvL4944PeecfGLr9LX//sISR3h4HNidCsTvVOD
         DVEyB4TdJX82296B6v3BfImAOyOIIHGjfzYSqkauOXBxXxmIZyQs+N1vFYG82cYRH5Nn
         uF4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fJAXiWtv3ENsVIdhVjykYqtG1mE3q0gWd4cfM6Uu6RI=;
        b=Xz0dnsakCOPooAfZSeaPE5fj32mEeMjc9BPrHZsi5btQ5RkWKFJFWc0LZu7/WVUAY7
         H9wqZQchUY6g2nDMe+oea88KP+9qGtX1H4VrxS3Yrn/vTasTZIAvbIpkDKK9o2EGjRVZ
         GWZjIJqXRRB32EQxAwqwhUYoH4aEEFwpSN3CPmPpvgcy+z1+rlJNMuXOySfZ78vhBFk4
         /KqlaEmQJspycI3YMWHpQF/pCqupTeBENWU8bSagOcm0VXdykZ17Ou+U3FOTnjHdUU4A
         8eRzWhQqKwiapPkSgk8INIaadlaeHLRYlDJ9GrtmycgmwSE2G/MxSPwdIZCOMpAMCSq8
         yQCw==
X-Gm-Message-State: AOAM530EMYgFtrjic8KKzOeKgcR2hUElNQuxWUnxSJ2q8N6Y4WDpfebZ
        OTmaLe6zVPfIcXRf1FHsyzA=
X-Google-Smtp-Source: ABdhPJzo+AfEDzPuo6MHgfvM3Zq0UnBMqruHA9NrVBWzmm/pizOVCN2B9+gAT53YdGFdMxc7h3mMdA==
X-Received: by 2002:a37:5b41:: with SMTP id p62mr1833305qkb.369.1597266445849;
        Wed, 12 Aug 2020 14:07:25 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:db46:8842:d6f4:b048:5fb1])
        by smtp.gmail.com with ESMTPSA id j72sm3450743qke.20.2020.08.12.14.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 14:07:24 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 15EDFC3259; Wed, 12 Aug 2020 18:07:22 -0300 (-03)
Date:   Wed, 12 Aug 2020 18:07:21 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [PATCH net-next 1/1] net/sched: Introduce skb hash classifier
Message-ID: <20200812210721.GE3398@localhost.localdomain>
References: <20200807222816.18026-1-jhs@emojatatu.com>
 <CAM_iQpU6j2TVOu2uYFcFWhBdMj_nu1TuLWfnR3O+2F2CPG+Wzw@mail.gmail.com>
 <3ee54212-7830-8b07-4eed-a0ddc5adecab@mojatatu.com>
 <CAM_iQpU6KE4O6L1qAB5MjJGsc-zeQwx6x3HjgmevExaHntMyzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpU6KE4O6L1qAB5MjJGsc-zeQwx6x3HjgmevExaHntMyzA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 04:25:43PM -0700, Cong Wang wrote:
> On Sun, Aug 9, 2020 at 4:41 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >
> > Interesting idea. Note: my experience is that typical setup is
> > to have only one of those (from offload perspective). Ariel,
> > are your use cases requiring say both fields?
> >
> >  From policy perspective, i think above will get more complex
> > mostly because you have to deal with either mark or hash
> > being optional. It also opens doors for more complex matching
> > requirements. Example "match mark X AND hash Y" and
> > "match mark X OR hash Y".
> > The new classifier will have to deal with that semantic.
> >
> > With fw and hash being the complex/optional semantics are easy:
> >
> > "match mark X AND hash Y":
> > $TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle X
> > skbhash flowid 1:12 action continue
> > $TC filter add dev $DEV1 parent ffff: protocol ip prio 4 handle Y fw
> > flowid 1:12 action ok
> >
> > "match mark X OR hash Y":
> > $TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle X
> > skbhash flowid 1:12 action ok
> > $TC filter add dev $DEV1 parent ffff: protocol ip prio 4 handle Y fw
> > flowid 1:12 action ok
> 
> Not sure if I get you correctly, but with a combined implementation
> you can do above too, right? Something like:
> 
> (AND case)
> $TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle 1
> skb hash Y mark X flowid 1:12 action ok

I probably missed something, but this kind of matching is pretty much
what flower does today. Is it just to avoid key extraction/flow
dissector or did I miss something?  I know there was a thread on how
to match on this hash before, but other than what I just said, I can't
recall other arguments.
