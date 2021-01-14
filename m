Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3612F6E99
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 23:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730889AbhANWu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 17:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730814AbhANWu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 17:50:56 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60155C061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 14:50:16 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id v3so3665161plz.13
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 14:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GgN8E2uqMAuQT4TaIQ34RxheeKLnq/pep+7UIUyNaoc=;
        b=G5USJ6pAP6L/uNm8NgTYmvjqD9Jsl9D2c1YbLdGPVrBw5S0ba15BHINZ2Fs4pvO8Uw
         4+2MekI6D9HhpblctNn3Jv7dxiHHbyY1nXxZxEcQ3pAwwxFjJ1X9SQZm3gVkJhzjdPpU
         ckth1pZf+ZZFffZnUyOosVUZU3mjDGWsTvy/ptbxGCZZntDSLiTqRDb+X6nbgk9hIKKH
         +7jj39xUiH/UIHn+Q/bUlw+A38yjYfzaJfs4gege942wN8VvWOsQ9Tyfz+RGGPCbYjq8
         wccklb5aseIY961SRTrkV5x8i9UGnquuhAUZ24Oc6jM0ycABX3eftQwpzPjw5QbabS3a
         WGVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GgN8E2uqMAuQT4TaIQ34RxheeKLnq/pep+7UIUyNaoc=;
        b=hnabY8a6JznnhTDKKRCfUXHGh5bNPJJbiAYfRivQ1A8TWd63pumLYBO0RxDpBRdLMa
         BpmU4aO1Z8TdIWCPjcnKyJi0dBNbJXBg5tjU8onDT6EGoyzyTwbSrY/VI6onTpMCmMSm
         aIwr9es3N9liQsw+sOLp9APugB0RUdq2lCh5KIUEhvzCR2d8tfBrEHBDQ9j+c28gEgo6
         mhlHXy8/7NJkz01ctlVerVVGztHaOQOhSV5Yq0JuNFpd2WFpQMjnTL+wbbbjBwf+brNN
         tnTeodGlVjru/ctK2zLGptVzdYADYgXnk2ok1dcCt12tmVbr4p1eTgBp6D5FLf+iFXj9
         j1pw==
X-Gm-Message-State: AOAM530MXX6t7y8P9CPinNyegpQWWvU472SnyBgVOw6VFx2z8f4FPEvr
        6MdzzTr9UCFHbc3h3RpUkhephKXrtc9ClzImldY=
X-Google-Smtp-Source: ABdhPJw1HsTHzAiurd3bt9cIfYGpFIVHb9vjHZsVEN8mzjgcFNdLmG7gMzlUp7Yuzv7HJuKkqNSLz8VKQFBPdN9mHw4=
X-Received: by 2002:a17:902:7242:b029:db:d1ae:46bb with SMTP id
 c2-20020a1709027242b02900dbd1ae46bbmr9502858pll.77.1610664615919; Thu, 14 Jan
 2021 14:50:15 -0800 (PST)
MIME-Version: 1.0
References: <20210114210749.61642-1-xiyou.wangcong@gmail.com>
 <20210114133625.0d1ea5e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpVAer0tBocMXGa0G_8jqJVz5oJ--woPo+TrtzVemyz+rQ@mail.gmail.com> <20210114143000.4bfca23a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114143000.4bfca23a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 14 Jan 2021 14:50:04 -0800
Message-ID: <CAM_iQpUa3a4gRLSwWpC-t98iv8bCu60cwHkx9AB=81g_9d_PWQ@mail.gmail.com>
Subject: Re: [Patch net v3] cls_flower: call nla_ok() before nla_next()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 2:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 14 Jan 2021 13:57:13 -0800 Cong Wang wrote:
> > On Thu, Jan 14, 2021 at 1:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Thu, 14 Jan 2021 13:07:49 -0800 Cong Wang wrote:
> > > > -                     if (msk_depth)
> > > > -                             nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
> > > >                       break;
> > > >               default:
> > > >                       NL_SET_ERR_MSG(extack, "Unknown tunnel option type");
> > > >                       return -EINVAL;
> > > >               }
> > > > +
> > > > +             if (!nla_opt_msk)
> > > > +                     continue;
> > >
> > > Why the switch from !msk_depth to !nla_opt_msk?
> >
> > It is the same, when nla_opt_msk is NULL, msk_depth is 0.
> > Checking nla_opt_msk is NULL is more readable to express that
> > mask is not provided.
> >
> > >
> > > Seems like previously providing masks for only subset of options
> > > would have worked.
> >
> > I don't think so, every type has this check:
> >
> >                         if (key->enc_opts.len != mask->enc_opts.len) {
> >                                 NL_SET_ERR_MSG(extack, "Key and mask
> > miss aligned");
> >                                 return -EINVAL;
> >                         }
> >
> > which guarantees the numbers are aligned.
> >
> > Thanks.
>
> static int fl_set_vxlan_opt(const struct nlattr *nla, struct fl_flow_key *key,
>                             int depth, int option_len,
>                             struct netlink_ext_ack *extack)
> {
>         struct nlattr *tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1];
>         struct vxlan_metadata *md;
>         int err;
>
>         md = (struct vxlan_metadata *)&key->enc_opts.data[key->enc_opts.len];
>         memset(md, 0xff, sizeof(*md));
>
>         if (!depth)
>                 return sizeof(*md);
>                 ^^^^^^^^^^^^^^^^^^^
>
> The mask is filled with all 1s if attribute is not provided.

Hmm, then what is the length comparison check for?

fl_set_vxlan_opt() either turns negative or sizeof(*md), and negitve
is already checked when it returns, so when we hit the length comparison
it is always equal. So it must be redundant.

(Note, I am only talking about the vxlan case you pick here, because the
geneve case is different, as it returns different sizes.)

Thanks.
