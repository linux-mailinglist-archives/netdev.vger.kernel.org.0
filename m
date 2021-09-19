Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED78410DDD
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 01:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbhISXyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 19:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhISXyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 19:54:13 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CEEC061574;
        Sun, 19 Sep 2021 16:52:47 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so13237818pjb.2;
        Sun, 19 Sep 2021 16:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N4skwtsf086FxZVEYApSdLohPlkZnRA4CUZGUIx4mzk=;
        b=UZm053QVwJ2XS2Em25JrOAFuvOS+0ariuZyJWoWL1g9KVa1dOMr1r/8JmQwU2kD1hY
         WMT8urZ24lJdrQww/4vAK4K4CANNR1xmbNGueFrz4aTioIHDI1RfUe9bigsVy/LOcjCV
         awi8+vN0Fq0ezF7CIcS1chCvRnE2obmJxD02MFLX7OIHIlCa/QRBJCXY1rDRNS+XOpVd
         dbWX93gqIA2Wvt2lj0iTbYz3jYEoZtnq10pI77wCeM6djVCYxVy4DjFoSv+BWdBvQ3WQ
         MBPm18IvaAHx8xOpqR9/O7tqgpfdK97Sux/XFQj5ubO+r0343vO7oApDNX0K2nS7RzOY
         3eBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N4skwtsf086FxZVEYApSdLohPlkZnRA4CUZGUIx4mzk=;
        b=2DTPLhbM7c5ikOCLK/GRGLiA/NZJ7hMNJ9AzmXe2u6v9KPkboKePC8Ch04KtPVrpyl
         evXTzP1LD6DArqRUTJCe9OCihtjewb6KSpiegveQGnKLcz30UGj20JqfXCXgYzWXCNiO
         R7hHEeBbwH/iBngyGFTTfge+HEP6o2JkXCft422HisFeCLtbhp6NkR7MIZBuvrIgo8n4
         FnxHJ0gAcw6JoLfegOy71DPDyc/vaXe5gU0rhuWzLsdjNOEHXzaN3dc8yIJYQBlgmfR9
         uEabdUrUtksDpac5LYSMg/YMijdXsGf9G+erMsg1TWEo10SPLsXysIZdwd+c4T+GuGUC
         A+Pw==
X-Gm-Message-State: AOAM533kZo7C0xm1P1fUeH4W4NZFITTxnJeMjRBB2w3nNMIOiwNbhEbo
        jWrdg4jdpyYf4KiZITbDw87vUr1Co/cIEC2LwCk=
X-Google-Smtp-Source: ABdhPJzi3Ud2RvVT0nhiUGeAuzxB3xnFs8f20/aXrCyrqb5+JJNXmz6YM1P3qyzErgrdl4AePnP354n5ADL28GpBSZk=
X-Received: by 2002:a17:903:102:b0:13a:66a8:f28 with SMTP id
 y2-20020a170903010200b0013a66a80f28mr20201925plc.62.1632095566733; Sun, 19
 Sep 2021 16:52:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210916122943.19849-1-yajun.deng@linux.dev> <20210917183311.2db5f332@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87275ec67ed69d077e0265bc01acd8a2@linux.dev>
In-Reply-To: <87275ec67ed69d077e0265bc01acd8a2@linux.dev>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 19 Sep 2021 16:52:35 -0700
Message-ID: <CAM_iQpXcqpEFpnyX=wLQFTWJBjWiAMofighQkpnrV2a0Fh83AQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: socket: add the case sock_no_xxx support
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 18, 2021 at 5:11 AM <yajun.deng@linux.dev> wrote:
>
> September 18, 2021 9:33 AM, "Jakub Kicinski" <kuba@kernel.org> wrote:
>
> > On Thu, 16 Sep 2021 20:29:43 +0800 Yajun Deng wrote:
> >
> >> Those sock_no_{mmap, socketpair, listen, accept, connect, shutdown,
> >> sendpage} functions are used many times in struct proto_ops, but they are
> >> meaningless. So we can add them support in socket and delete them in struct
> >> proto_ops.
> >
> > So the reason to do this is.. what exactly?
> >
> > Removing a couple empty helpers (which is not even part of this patch)?
> >
> > I'm not sold, sorry.
>
> When we define a struct proto_ops xxx, we only need to assign meaningful member variables that we need.
> Those {mmap, socketpair, listen, accept, connect, shutdown, sendpage} members we don't need assign
> it if we don't need. We just need do once in socket, not in every struct proto_ops.
>
> These members are assigned meaningless values far more often than meaningful ones, so this patch I used likely(!!sock->ops->xxx) for this case. This is the reason why I send this patch.

But you end up adding more code:

 1 file changed, 58 insertions(+), 13 deletions(-)

I don't see this as a gain from any perspective.

Thanks.
