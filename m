Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA233281DE
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 16:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbhCAPKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 10:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbhCAPJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 10:09:36 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485D4C061756
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 07:08:56 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id c6so21210005ede.0
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 07:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xUvBhCvqgHU9uJl/dg8nlzrcYOGrjh1TuGIFOxZ4Ljc=;
        b=vdHgI2WMAlDGboU1UvdtnIaiGvs/yqtPsYDYIj3ZuDoxFJYDgiB5SrnqAOFnWYGQWZ
         uPbvJ2/C9oJRT/WARPx0e+5LrQIrtxwAxP0xYh1fpNyjoMLZ2Qquq39rge7yq7Yw9Jdb
         gHci4UvFtieR0w0Gbp5Y04pFjW9Fu2759nKvMJDp5yT/VRd2HWGbLZK00p8w5djc/6Ay
         IJocgwXuHdhZ9OfLZ1NQ+BoCxL1vM8H8w/e7Riu0tOtg3kQ+Q58Y8xxjiKMNXaPkUwz7
         pwJnKs0CUO/yDgPQGm+cG9y3Dq5pKXAW/w2bS+kpW3Tgg+FaNUW/ySl3+cZAcxQdCOGM
         X1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xUvBhCvqgHU9uJl/dg8nlzrcYOGrjh1TuGIFOxZ4Ljc=;
        b=TY+OaGzNFBV1N5GL1+JH0M2FYN7lZyjkwB4RO10jMIoxOpjRHY+wa9me+YeCbBKz/4
         dvhl1B0UH5Djr9ZG2ldIlLJ08bpfjyB0qi4qdYYDjEWglQCcOjn/btFacfHe9o2vsw7T
         O17wo9I+mtjghnoOhnIvHvKwgEJnDwDrs7Q+WGGuV2KF5V2qjsrRL28cz6eOfSBmS3mC
         aQSD7iy2Au70LX/l5gpHqaQRfy/Fzks20kKmnRIo6SgDKDMWPUoC3V6/fiA66LwuCQ86
         G00TebvpdvWogKaallbO1gTt5lllii5MwWrW7nnVVsX9mc2sWGfQyCJ87JTzLp2uI/zn
         zEag==
X-Gm-Message-State: AOAM533FEWNQp3kf4l9m+vZ5xGarHrnTX1qguvT71uTL2HP8IR9fc/1Y
        E9BzRLzzsAI++XvItUVkrJw=
X-Google-Smtp-Source: ABdhPJxwxBylD7vgakgf3fWiy07DZuesr30IOcOf5obXCe34pS7mT8UDUoI10DDm4xAGEum+n79KTA==
X-Received: by 2002:aa7:d987:: with SMTP id u7mr4672006eds.326.1614611334987;
        Mon, 01 Mar 2021 07:08:54 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id u15sm14305737ejy.48.2021.03.01.07.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 07:08:54 -0800 (PST)
Date:   Mon, 1 Mar 2021 17:08:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Markus =?utf-8?Q?Bl=C3=B6chl?= <Markus.Bloechl@ipetronik.com>
Subject: Re: [PATCH v2 net 5/6] net: enetc: don't disable VLAN filtering in
 IFF_PROMISC mode
Message-ID: <20210301150852.ejyouycigwu6o5ht@skbuf>
References: <20210225121835.3864036-1-olteanv@gmail.com>
 <20210225121835.3864036-6-olteanv@gmail.com>
 <20210226152836.31a0b1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210226234244.w7xw7qnpo3skdseb@skbuf>
 <20210226154922.5956512b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210227001651.geuv4pt2bxkzuz5d@skbuf>
 <7bb61f7190bebadb9b6281cb02fa103d@walle.cc>
 <20210228224804.2zpenxrkh5vv45ph@skbuf>
 <bfb5a084bfb17f9fdd0ea05ba519441b@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfb5a084bfb17f9fdd0ea05ba519441b@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 03:36:15PM +0100, Michael Walle wrote:
> Ok, I see, so your proposed behavior is backed by the standards. But
> OTOH there was a summary by Markus of the behavior of other drivers:
> https://lore.kernel.org/netdev/20201119153751.ix73o5h4n6dgv4az@ipetronik.com/
> And a conclusion by Jakub:
> https://lore.kernel.org/netdev/20201112164457.6af0fbaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/#t
> And a propsed core change to disable vlan filtering with promisc mode.
> Do I understand you correctly, that this shouldn't be done either?
>
> Don't get me wrong, I don't vote against or in favor of this patch.
> I just want to understand the behavior.

So you can involuntarily ignore a standard, or you can ignore it
deliberately. I can't force anyone to not ignore it in the latter case,
but indeed, now that I tried to look it up, I personally don't think
that promiscuity should disable VLAN filtering unless somebody comes up
with a good reason for which Linux should basically disregard IEEE 802.3.
In particular, Jakub seems to have been convinced in that thread by no
other argument except that other drivers ignore the standards too, which
I'm not sure is a convincing enough argument.

In my opinion, the fact that some drivers disable VLAN filtering should
be treated like a marginal condition, similar to how, when you set the
MTU on an interface to N octets, it might happen that it accepts packets
larger than N octets, but it isn't guaranteed.

> I haven't had time to actually test this, but what if you do:
>  - don't load the 8021q module (or don't enable kernel support)
>  - enable promisc
>  (1)
>  - load 8021q module
>  (2)
>  - add a vlan interface
>  (3)
>  - add another vlan interface
>  (4)
>
> What frames would you actually receive on the base interface
> in (1), (2), (3), (4) and what is the user expectation?
> I'd say its the same every time. (IIRC there is already some
> discrepancy due to the VLAN filter hardware offloading)

The default value is:
ethtool -k eno0 | grep rx-vlan-filter
rx-vlan-filter: off

so we receive all VLAN-tagged packets by default in enetc, unless VLAN
filtering is turned on.

> > I chose option 2 because it was way simpler and was just as correct.
>
> Fair, but it will also put additional burden to the user to also
> disable the vlan filtering, right?. Otherwise it would just work. And
> it will waste CPU cycles for unwanted frames.
> Although your new patch version contains a new "(yet)" ;)

True, nobody said it's optimal, but you can't make progress if you
always try to do things optimally the first time (but at least you
should do something that's not wrong).
Adding the dev_uc_add, dev_mc_add and vlan_vid_add calls to
net/sched/cls_flower.c doesn't seem an impossible task (especially since
all of them are refcounted, it should be pretty simple to avoid strange
interactions with other layers such as 8021q), but nonetheless, it just
wasn't (and still isn't) high enough on my list of priorities.
