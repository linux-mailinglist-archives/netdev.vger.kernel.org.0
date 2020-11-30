Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B19D2C8CD7
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgK3Sbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbgK3Sba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:31:30 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CADC0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 10:30:50 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id k3so4943299ioq.4
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 10:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EcFh3eMKS38k+Nvsuveb2dE9BhdXp7nLLxWHuXbd2Ww=;
        b=Mk/8lTxeeKHe8a1LFIlB3lkgRfP6pkZ64vsmiwipMZIgvpH//KB4OA+BJRv3Bbk3G0
         4pNxReDixEHyM2p/Z1EGNjY9gZyRT/UZ4wYvIhzGVlsm5uJPHz7ZS9+G9gmJpzg5p9d/
         vDjYXZXbIy7W0jAYqdCkIT8VaJmJN+sZDKMTIkNk5aJ8l8rGFp2jW6H8/bx4oeg6uqfP
         jAsOcEwiX/opBUdeniYzGtluussVeaF4tgRcKgzRsCkgcwNTeAadl/HYmcr7zxt88nHG
         a5Gvau3eNL2AZ/JoVVBqTJYEHbSzX0c/U7AiIqg8f3Om6yWAJx2FWs6cisil+gK7Sk36
         SR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EcFh3eMKS38k+Nvsuveb2dE9BhdXp7nLLxWHuXbd2Ww=;
        b=cDt/pOiUtH48t8M/S7qKZTsR+jgn4gaALJBq23JlEYT/tQzot1jHavJPmh/zPwnQIm
         7EaH7LUcosaloHJ36bfUJanIOrIAys6nyju4ERp/n5BffgSNCIMLUxYM2tXbrYtUqeLP
         bkRDodx7EuxDSGYdDtV0mqZjNinjxOaeLfMpoq9KuQVUP2a2sXj6wYk1GPqIZ5WOp81q
         yiENo/Rrs2BEgLgY9Jw7C9/LSRHRNfzIlfMr5N2fQhw8aGDAy3Zn5U4GCBwrKkw+5NhL
         lYiaxqn6SU9PIkv7FkM8orJ/sseapruk4xMJLmA0sQw9wY6ETVKqlhZE9SGGBvg/9TQx
         ZcWw==
X-Gm-Message-State: AOAM5328U+xeQqxu45jK2Ha7Y0ezh1WwCiRTAM2n4wKEfz3D3anmZBS9
        t73KSXwPdoPuAudrvgp06gFIV6Kb+2nkRQptpqQXUQ==
X-Google-Smtp-Source: ABdhPJzga1/Ooik44wRQMeegMIH/QIZHtKzsPzDANyvcVRrNYvv/Nq4MGRGQg5BJb6+zN51VXDmlnfnjjn3xh1xpbnE=
X-Received: by 2002:a5d:83d0:: with SMTP id u16mr16136450ior.157.1606761049564;
 Mon, 30 Nov 2020 10:30:49 -0800 (PST)
MIME-Version: 1.0
References: <20201129182435.jgqfjbekqmmtaief@skbuf> <20201129205817.hti2l4hm2fbp2iwy@skbuf>
 <20201129211230.4d704931@hermes.local> <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
 <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 30 Nov 2020 19:30:38 +0100
Message-ID: <CANn89i+njuoeg7uAwWd08NKONXa4d2f47XpN4Kt83192mCZLwg@mail.gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 7:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 30 Nov 2020 11:41:10 +0100 Eric Dumazet wrote:
> > > So dev_base_lock dates back to the Big Kernel Lock breakup back in Linux 2.4
> > > (ie before my time). The time has come to get rid of it.
> > >
> > > The use is sysfs is because could be changed to RCU. There have been issues
> > > in the past with sysfs causing lock inversions with the rtnl mutex, that
> > > is why you will see some trylock code there.
> > >
> > > My guess is that dev_base_lock readers exist only because no one bothered to do
> > > the RCU conversion.
> >
> > I think we did, a long time ago.
> >
> > We took care of all ' fast paths' already.
> >
> > Not sure what is needed, current situation does not bother me at all ;)
>
> Perhaps Vladimir has a plan to post separately about it (in that case
> sorry for jumping ahead) but the initial problem was procfs which is
> (hopefully mostly irrelevant by now, and) taking the RCU lock only
> therefore forcing drivers to have re-entrant, non-sleeping
> .ndo_get_stats64 implementations.

I think bonding also calls  ndo_get_stats64() while in non-sleeping context.
