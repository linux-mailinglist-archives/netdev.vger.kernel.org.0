Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9686A1F5EA6
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 01:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgFJXVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 19:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgFJXVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 19:21:38 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F56C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 16:21:36 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id b5so3694314iln.5
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 16:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aufFfpWeMHAA+Wb1GL8Y7H3C9atZfsbH4eqs/tNyXPo=;
        b=h9yIui9En/35K6ClPu7OwVomVDOLMAKkEvn2bcq3JGpvP0iOlRfz9sgSEI4gCF5IoC
         gVvIlw4ToySfi8z3JPzk3U2qUlhgv4VQoq8/9K+Ea5ovgm0a2jMxtMYjrtvuM9C9IOIM
         MPo3+JOMYL0l8Ct30hWZz7Ey4IBTQ4FSkTl7z8dKl08l0hSfyAZNZgEYjZelzkhB3TKx
         /1u8+rr1f2VaP357S3ge84HCObEc4uyyjPmt+Szh09tzUzankeUn+OY+fa1QCngSlagY
         OYxVtgWzrcq44j6ForgaMWWTKNAVGLpBfdKHRMsRCehyrInP7AfHGdfCVHgvJVzPjADO
         iTuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aufFfpWeMHAA+Wb1GL8Y7H3C9atZfsbH4eqs/tNyXPo=;
        b=rSJALip5jFXov7AookKEzaa9RhuoJt1iOkdq6mG61PlvcU8Y0rI9tQfRRLjrHQz2F6
         Pcaaa5Nk5GsY9VNvEJrOeU2jZgDMaM6yx3dggBRNkzvu9civdxX/QUKuUV7Xrn+sPn2x
         P9o65+2l2IiUAsPu7l+O2Ikm9jb/+oIAch4+bPZRiW8hnAhFAm3KCVNHKwN/QmvnJV5U
         /9Dcfdc7zgJ2ku3czoFQL9OIpTBGqmclwsbkim5y7n8JlGRjuKrG7FRRldlpXGg8uWbW
         o38I4IAwun0ObR9oB5vBbgOP0X5hESALNeR68xNTDhd08cHADIbm9bHe9UcUzx6tatrD
         8Zfw==
X-Gm-Message-State: AOAM533+YFtrE2l1dpt2Gqi988EAMNKUAu0RfwF8P9cqL3uuLvt9g8sd
        kGlpJTQ+c8Cich+hyh8IzqHBeNFEDQNhnJWe8wRYfg==
X-Google-Smtp-Source: ABdhPJzApcO4kRt5CGEVBthgTl1ntk+nh2TFqbpeC2fAjpzyKf42TG0PMRO5CbK7Nq2YaJ4UmIQih7/sv6KskwDf990=
X-Received: by 2002:a92:dc89:: with SMTP id c9mr5527407iln.238.1591831295765;
 Wed, 10 Jun 2020 16:21:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com> <CAMArcTUmqCqyyfs+vNtxoh_UsHZ2oZrcUkdWp8MPzW0tb6hKWA@mail.gmail.com>
In-Reply-To: <CAMArcTUmqCqyyfs+vNtxoh_UsHZ2oZrcUkdWp8MPzW0tb6hKWA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 10 Jun 2020 16:21:24 -0700
Message-ID: <CAM_iQpWM5Bxj-oEuF_mYBL9Qf-eWmoVbfPCo7a=SjOJ0LnMjAA@mail.gmail.com>
Subject: Re: [Patch net] net: change addr_list_lock back to static key
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 7:48 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
> On Tue, 9 Jun 2020 at 06:53, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
>
> Hi Cong,
> Thank you for this work!
>
> > The dynamic key update for addr_list_lock still causes troubles,
> > for example the following race condition still exists:
> >
> > CPU 0:                          CPU 1:
> > (RCU read lock)                 (RTNL lock)
> > dev_mc_seq_show()               netdev_update_lockdep_key()
> >                                   -> lockdep_unregister_key()
> >  -> netif_addr_lock_bh()
> >
> > because lockdep doesn't provide an API to update it atomically.
> > Therefore, we have to move it back to static keys and use subclass
> > for nest locking like before.
> >
>
> I'm sorry for the late reply.
> I agree that using subclass mechanism to avoid too many lockdep keys.

Avoiding too many lockdep keys is not the real goal of my patch,
its main purpose is to fix a race condition shown above. Just FYI.


> But the subclass mechanism is also not updated its subclass key
> automatically. So, if upper/lower relationship is changed,
> interface would have incorrect subclass key.
> It eventually results in lockdep warning.

So dev->lower_level is not updated accordingly? I just blindly trust
dev->lower_level, as you use it in other places too.

> And, I think this patch doesn't contain bonding and team module part.
> So, an additional patch is needed.

Hmm, dev->lower_level is generic, so is addr_list_lock.

Again, I just assume you already update dev->lower_level each time
the topology changes. I added some printk() to verify it too for my
simple bond over bond case. So, I can't immediately see what is
wrong with dev->lower_level here. Do you mind to be more specific?
Or I misunderstand your point?

Thanks!
