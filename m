Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5E61655B2
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 04:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgBTDc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 22:32:27 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33925 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbgBTDc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 22:32:27 -0500
Received: by mail-oi1-f195.google.com with SMTP id l136so26162080oig.1;
        Wed, 19 Feb 2020 19:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FkF0ycPRGHhqzquEy6JKzkt16I6SXZOg50EECEsoAiY=;
        b=MTI5Gd1odwsP1ifJMDwJ3udM7XXRm2aOaT9itFusiMLqMH+q77dzB0aV7wlPQrXnl0
         itcvg0OrhmlW9ELGwiLzBZbwaTggXILZ+G/TYWwpPywvfVldZopn/zx1wfuBYdnQNgzU
         C4pKHt7c2RzB91iUQN1Ill/1VQfHI5pduLkcnZusWUClFoiG+3US6iZ3c07VT8lkgasG
         9NrKuQX8nrs4tVjS4GskKvh1uRgpRqwq7LgI3AFtAO5rulnbPbnNlqv8IWKfhdf8bmCd
         A1Tzmi50256FJEFVehxS5PycRVR5ntiWJw2QI6hbIUuMfI+E8gic/v8L1uwj803hzGad
         Sk1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FkF0ycPRGHhqzquEy6JKzkt16I6SXZOg50EECEsoAiY=;
        b=FDHl5s9++hMbOgIMCV9B+Fkv7o54RRKawFOLM7xbHkvXeeTyl6R/NQZNpNC7gKYCtZ
         um36bEU7xBj7rrpUiFSfut19ncqoJWCYx/Vjc3GfLY8Y5806uS0Fo/KKHaxIhZbN12Hq
         qKlt76bseH+PFFbzP0LjnCTwKJuGR31Px9o3MBpb8CK1G1xtWqPRZb40zYkpB4K/b5as
         ug3WnTDzuPrV8zfbl9Yw/Ekikk8cA6J1f+qICagroCUGddKhpgl+VH7xpe7TgKWv23sH
         5lOqWAxW6RQ9D4ByMFaELDMhlvIrxG7QrE5xOPK9YRKSlJopGAxONKq2mdv/Wmj0QCH8
         FVQQ==
X-Gm-Message-State: APjAAAVrmR+6QTBVEezRF6qzWoCigAlGWvC/3rcEXPp4UCFHvBg0IN8k
        s/JWw7pK/lHQJoYELDVtAOeXaaUiQ0tiQzwAeyfQ2CDzxZc=
X-Google-Smtp-Source: APXvYqyD/un22q+qtTZ5LbIhFY9b09HssAnOPAoOqILbRFYkBGepPyk20TZodlXmSEsdn4jjTarhxHgtBWVFSc4kUCI=
X-Received: by 2002:aca:1011:: with SMTP id 17mr693298oiq.72.1582169544773;
 Wed, 19 Feb 2020 19:32:24 -0800 (PST)
MIME-Version: 1.0
References: <20200213065352.6310-1-xiyou.wangcong@gmail.com>
 <20200218213524.5yuccwnl2eie6p6x@salvia> <CAM_iQpWfb7xgd2LuRmaXhRSJskJPsupFk0A7=dRXtMEjZJjr3w@mail.gmail.com>
 <20200218220507.cqlhd4kj4ukyjhuu@salvia>
In-Reply-To: <20200218220507.cqlhd4kj4ukyjhuu@salvia>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 19 Feb 2020 19:32:13 -0800
Message-ID: <CAM_iQpUYGVpUCatMHVKSx4jM9c6kbYxcWBV0--1mrQi6NbPhhg@mail.gmail.com>
Subject: Re: [Patch nf] netfilter: xt_hashlimit: unregister proc file before
 releasing mutex
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzbot <syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 2:05 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Tue, Feb 18, 2020 at 01:40:26PM -0800, Cong Wang wrote:
> > On Tue, Feb 18, 2020 at 1:35 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > On Wed, Feb 12, 2020 at 10:53:52PM -0800, Cong Wang wrote:
> > > > Before releasing the global mutex, we only unlink the hashtable
> > > > from the hash list, its proc file is still not unregistered at
> > > > this point. So syzbot could trigger a race condition where a
> > > > parallel htable_create() could register the same file immediately
> > > > after the mutex is released.
> > > >
> > > > Move htable_remove_proc_entry() back to mutex protection to
> > > > fix this. And, fold htable_destroy() into htable_put() to make
> > > > the code slightly easier to understand.
> > >
> > > Probably revert previous one?
> >
> > The hung task could appear again if we move the cleanup
> > back under mutex.
>
> How could the hung task appear again by reverting
> c4a3922d2d20c710f827? Please elaborate.

Because the cfg.max could be as large as 8*HASHLIMIT_MAX_SIZE:

 311         if (hinfo->cfg.max == 0)
 312                 hinfo->cfg.max = 8 * hinfo->cfg.size;
 313         else if (hinfo->cfg.max < hinfo->cfg.size)
 314                 hinfo->cfg.max = hinfo->cfg.size;

Not sure whether we can finish cleaning up 8*HASHLIMIT_MAX_SIZE
entries within the time a hung task tolerates. This largely depends on
how much contention the spinlock has, at least I don't want to bet
on it.

Thanks.
