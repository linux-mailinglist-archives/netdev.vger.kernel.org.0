Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DB7314848
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 06:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhBIFht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 00:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhBIFhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 00:37:47 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CE7C061788
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 21:37:07 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id e9so991101pjj.0
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 21:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3h7lDUclV/nKqAmEyyfsC2t10o2kj96ONrEpjhwkfd8=;
        b=jcz4AxOfFci5C4obM8/06JlwNsFGVQ2TKADXjPfB6fk/5dz/RQiGZHwMR+0aE5B/ls
         XNnk95jLJ9xf+Ni6HkDaUXiZelM0zEaR3/BoVz8LvPBAOWuCH5U+lE0ZxYA8NCY4h7h8
         N0OqV4CmUSpFig8oI4r9Rotkqn/ECLd8dTkctb+WE3Tmb2sS7yR8aXnYHII0/AicCdL5
         gdeo0/RYluJ3sptgKm4Yf0F+TPMeoyAfMiQ8O64hX9uNEymENcd0OcrsOZVI/glAyPeS
         BBS0xfB6QDd+rTK2jTv6CvuEYF281+4J72Ke56p+ZvbofqCigAQBQPys4HK6jTrskTST
         qiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3h7lDUclV/nKqAmEyyfsC2t10o2kj96ONrEpjhwkfd8=;
        b=DrPFIJEhbnCeFGQg8oNvv0D+PTk77DdoYXiTglxf7/kT0vuGcs7Q+iHO6Sq6+uKnay
         cys0IMHrCMXUtqTktUqgb7aonNlXE1ykxukOt7l4IxDjzgxjqgO+ovgLcrzjyTbA2AIZ
         4qvRgXfy2uIvkW5pBNXo/QmJrCfb0leMJcXaljMMopa/6LNnXGayZalPLMY6bpMFqCkL
         47GfRzEpJ5+RYlp6fp8L3ebU+nP0bCx3uBXimVVc5U4SIyZdYfLhUL1ELzNv8WttjYSK
         d7tWHeRZCfNr7cIPgtBlFgXxOrhfFoFre9lH8HEPqmOXgUlx/WHqVoZk0jPLbAslJtZc
         px9Q==
X-Gm-Message-State: AOAM533HeB/xIO9ZAIEAlZmBw95PmYHftOjJS8rDG1U9usMc+AAo17ts
        yxsL5YTIzeaapnzjwoTKw+Z8QNuUh1E6D1VqddaTXO+XoM5l6w==
X-Google-Smtp-Source: ABdhPJzxJq4TtKjTrdB7OZEZva6eo8KU4mlo2YvFPd/xZf+icK+0c0MxHu3n2H0RIfFcfhkgoQGDE7d+iTZJyQnIuEU=
X-Received: by 2002:a17:90a:cf17:: with SMTP id h23mr2332310pju.191.1612849027145;
 Mon, 08 Feb 2021 21:37:07 -0800 (PST)
MIME-Version: 1.0
References: <1612674803-7912-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpXojFaYogRu76=jGr6cp74YcUyR_ZovRnSmKp9KaugBOw@mail.gmail.com> <20210208104759.77c247c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210208104759.77c247c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 8 Feb 2021 21:36:56 -0800
Message-ID: <CAM_iQpVidNVgJ3HERa2m1UXkQB8V8CjebSGJXO9QS5fDXRQ73Q@mail.gmail.com>
Subject: Re: [PATCH net v4] net/sched: cls_flower: Reject invalid ct_state
 flags rules
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     wenxu <wenxu@ucloud.cn>, Jamal Hadi Salim <jhs@mojatatu.com>,
        mleitner@redhat.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 10:48 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 8 Feb 2021 10:41:35 -0800 Cong Wang wrote:
> > On Sat, Feb 6, 2021 at 9:26 PM <wenxu@ucloud.cn> wrote:
> > > +       if (state && !(state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
> > > +               NL_SET_ERR_MSG_ATTR(extack, tb,
> > > +                                   "ct_state no trk, no other flag are set");
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
> > > +           state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED) {
> > > +               NL_SET_ERR_MSG_ATTR(extack, tb,
> > > +                                   "ct_state new and est are exclusive");
> >
> > Please spell out the full words, "trk" and "est" are not good abbreviations.
>
> It does match user space naming in OvS as well as iproute2:
>
>         { "trk", TCA_FLOWER_KEY_CT_FLAGS_TRACKED },
>         { "new", TCA_FLOWER_KEY_CT_FLAGS_NEW },
>         { "est", TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED },
>         { "inv", TCA_FLOWER_KEY_CT_FLAGS_INVALID },
>         { "rpl", TCA_FLOWER_KEY_CT_FLAGS_REPLY },
>
> IDK about netfilter itself.

It makes sense now, but still they are bad abbreviations, especially
"est" is usually short for "estimated" not "established".

More importantly, we do not have to use abbreviations in ext ack,
we have enough room there.

Thanks.
