Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3A24167FE
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 00:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbhIWW1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 18:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243506AbhIWW1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 18:27:24 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B05C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 15:25:52 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g8so28572462edt.7
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 15:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oNgrCMKNNiWSykyU00Nw5xcA28hGOaU/qgdqoHugvj4=;
        b=a/rxxMUtFQXcxi4+EFkgs9k8IORAS/NCOREfk6j7IeoQWRcM/j6VdX1iJcHe8xi5yB
         1FldJ3pnHSBA+NE68RV1+Q9WyPHK/m7jaUuX1f7BfKjWrMUtzuJqGhcoeY0ExMO4X6Lg
         iIDs6WOUMP4Jzm4YPSETh54xdSa2fARz153+qL2CF1AsSG6t3JVYAnBZNQrNYIIpxR1S
         Q+WcERFFqnUGu+QnzOW/w/S4jRU/OOo8DiTj9X/gZLYX5dArnd+drMHQKp/V6mLjUYB7
         dLszYLEy5oF2wGoEsIOKP9UPjoyJTs0bJvx85Q7xT1h3F6512Kh4imbkg74KT44Wo8mH
         +cHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oNgrCMKNNiWSykyU00Nw5xcA28hGOaU/qgdqoHugvj4=;
        b=n7P18UCY5tamd727OsL1MDTQVh8x31EFlNIFJGrs32Ko8Z9SywSFbBbEooR+9HuLsV
         TUAYDBY0u4rNy7Ax3IHgPOZ4OCp6UVTf3GZKtaLgPmIbxDjjQeBURXp9uXLjQnkIfIx0
         EkxymKRMlx4QvAVxI9OAWiT/resmp8tR974cgDqLCB54++HfzlVnTUiqIE1cO9U1L3Ky
         wYjeQ++jPki9HPHM4y8AH+4waykdINwiV2NkFyF05C9FrASEK7fCt6Ev2k1Ul2HDO8rF
         sb+Xou2P7qSPjMQf3Kv4G5YSpHOpNkKpjILJx3PhjUexRV2HARkMzjUcQnFnhQPXwHGE
         V0Xw==
X-Gm-Message-State: AOAM533Ew1WD5tjc8u34iZlcys+a90roPyoiI/187TP/WNQDJJwZ5gB5
        rX0YafynfDN6fCQGg5At6Ro=
X-Google-Smtp-Source: ABdhPJyhR5YV3UOni0CIIPXWuzgkNsxtzjgEfRkR7mVHah0vtH5PBv2uox3NCNqROfcP6GHajyp/6w==
X-Received: by 2002:a17:906:1557:: with SMTP id c23mr7398492ejd.371.1632435951080;
        Thu, 23 Sep 2021 15:25:51 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id ml12sm3804756ejb.29.2021.09.23.15.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 15:25:50 -0700 (PDT)
Date:   Fri, 24 Sep 2021 01:25:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: tag_rtl4_a: Drop bit 9 from egress
 frames
Message-ID: <20210923222549.byri6ch2kcvowtv4@skbuf>
References: <20210913143156.1264570-1-linus.walleij@linaro.org>
 <20210915071901.1315-1-dqfext@gmail.com>
 <CACRpkdYu7Q5Y88YmBzcBBGycmW92dd0jVhJNUpDFyd65bBq52A@mail.gmail.com>
 <20210923221200.xygcmxujwqtxajqd@skbuf>
 <CACRpkdZJzHqmdfvR5kRgw1mWPQ68=-ky1xJ+VWX8v6hD_6bx6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZJzHqmdfvR5kRgw1mWPQ68=-ky1xJ+VWX8v6hD_6bx6A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 12:21:39AM +0200, Linus Walleij wrote:
> On Fri, Sep 24, 2021 at 12:12 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > > Hm I suspect it disable learning on RTL8366RB as well.
> >
> > Suspicion based on what?
> 
> I have a not yet finished patch that dumps the FDB :)
> 
> The contents change around a bit under the patch
> sets I have floating, but can certainly be determined
> when I have time to test things properly.

To be clear, if bit 9 is a "disable learning" bit, address learning is a
process that takes place on the ingress of a packet, and in this case
the ingress port is the CPU port. But the ndo_fdb_dump works with net
devices, of which CPU ports have none. So it seems unlikely that you
would see any difference in the output of "bridge fdb" that could be
attributed to that bit.

> > > Do we have some use for that feature in DSA taggers?
> >
> > Yes.
> 
> OK I'll add it to my TODO, right now trying to fix up the base
> of the RTL8366RB patch set to handle VLANs the right way.

But you didn't ask what that use is...
