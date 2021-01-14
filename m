Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3B12F6C00
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 21:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbhANUZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 15:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbhANUZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 15:25:12 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6B8C061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 12:24:31 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id h10so4038224pfo.9
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 12:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f+Hh5Bmp/EM5EG14MTSV+M+j+nWQE8+hnQK9OWWgUFY=;
        b=gLfndlVoE16gct2qWWZosDDGnuCnC1NSERxPwOFZqwr0bJj7CiGg2u72slDAtDQYR0
         IqdQnw8nE5hyKjNwdEGXwvhRN1gzShrjhAaIxZ3f1LnkfsYGOSRo30mi/qZps1TbYu/X
         Hdn6UlPSvroHEYQmazgfEMXRnDft8v2X+gyNJikp85Z5vuFBvyIhRJYPcUX67iFl1F0x
         0I/g+skBC7dGmCPNlvipT9LwrIC6xOWq+E9XAUCv0Dlf79ZdicVdNJCcnjTfKC0jcOul
         BWBvuJ83GG9p/Xp19MlVMz4fopvDFL+YKhoN1VXA8f6m+AAklEi5KF5/DYGe60vfidDh
         FwVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f+Hh5Bmp/EM5EG14MTSV+M+j+nWQE8+hnQK9OWWgUFY=;
        b=HXmc6dpUEmMIDTEgC4RfK/XKDuyFvIBq4kLPPwkdSVZJo2BOtrgYA1uUGqkcTdUQpI
         fFa1RJJPU8x4EAxxXlsK7lpfrTh+OJd7DJwcAZw9ctYdd3TXY19SLJFbgFE2aHBAFsJg
         K3Dddg/uX4vcNlPOyI/qMEGjlBE9Spm7a0sbe/KYtod5PIczUdImcIzn6RUjwA7lJaBE
         /R7u40GfT7M432qbKgsWTyUOmhP6EfNGEOhv+uiQs1sgp1DUdm9uEGwR37+Bj5X0HIwc
         8E3R7Cvw2mG6jffHYNaDIXkyqNfMuSxBkTab4t77U2KuipmhGVIXJBXZpQRwcjlczc3Q
         JfyQ==
X-Gm-Message-State: AOAM530oopQVPRB6ZCTlb/28MA/JuWcYkfsWXZrcV9BQWPrdkIMInSec
        BA5x91spiKDJcKTQbZqG7qHVKWcc124NB7Ic4bg=
X-Google-Smtp-Source: ABdhPJyOb/mpgNvSKb5mQcq8rI+pILcIgqUZnMEngOIhSs/BS3Y7dPTZnid9afn3yTT6jDBdkAMuQHVdxIfyOUFHqo4=
X-Received: by 2002:a63:1707:: with SMTP id x7mr9122069pgl.266.1610655871494;
 Thu, 14 Jan 2021 12:24:31 -0800 (PST)
MIME-Version: 1.0
References: <20210114163822.56306-1-xiyou.wangcong@gmail.com>
 <20210114103848.5153aa5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpUPzSfbQgDE+BBySFVUqYCqse0kKQ-htN81b9JRTGYfJA@mail.gmail.com> <20210114121614.7fb64be9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114121614.7fb64be9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 14 Jan 2021 12:24:19 -0800
Message-ID: <CAM_iQpXHtGhUh7Ta+hNyzJa0SsOe_c=cAO7ObB6famnp6seuGA@mail.gmail.com>
Subject: Re: [Patch net v2] cls_flower: call nla_ok() before nla_next()
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

On Thu, Jan 14, 2021 at 12:16 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 14 Jan 2021 12:03:16 -0800 Cong Wang wrote:
> > On Thu, Jan 14, 2021 at 10:38 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Thu, 14 Jan 2021 08:38:22 -0800 Cong Wang wrote:
> > > > From: Cong Wang <cong.wang@bytedance.com>
> > > >
> > > > fl_set_enc_opt() simply checks if there are still bytes left to parse,
> > > > but this is not sufficent as syzbot seems to be able to generate
> > > > malformatted netlink messages. nla_ok() is more strict so should be
> > > > used to validate the next nlattr here.
> > > >
> > > > And nla_validate_nested_deprecated() has less strict check too, it is
> > > > probably too late to switch to the strict version, but we can just
> > > > call nla_ok() too after it.
> > > >
> > > > Reported-and-tested-by: syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com
> > > > Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
> > > > Fixes: 79b1011cb33d ("net: sched: allow flower to match erspan options")
> > >
> > > > @@ -1340,9 +1341,6 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
> > > >                               NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
> > > >                               return -EINVAL;
> > > >                       }
> > > > -
> > > > -                     if (msk_depth)
> > > > -                             nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
> > > >                       break;
> > > >               case TCA_FLOWER_KEY_ENC_OPTS_ERSPAN:
> > > >                       if (key->enc_opts.dst_opt_type) {
> > > > @@ -1373,14 +1371,17 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
> > > >                               NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
> > > >                               return -EINVAL;
> > > >                       }
> > > > -
> > > > -                     if (msk_depth)
> > > > -                             nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
> > > >                       break;
> > > >               default:
> > > >                       NL_SET_ERR_MSG(extack, "Unknown tunnel option type");
> > > >                       return -EINVAL;
> > > >               }
> > > > +
> > > > +             if (!nla_ok(nla_opt_msk, msk_depth)) {
> > > > +                     NL_SET_ERR_MSG(extack, "Mask attribute is invalid");
> > > > +                     return -EINVAL;
> > > > +             }
> > > > +             nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
> > >
> > > we lost the if (msk_depth) now, nla_opt_msk may be NULL -
> > > neither nla_ok() nor nla_next() take NULL
> >
> > How is "if (msk_depth)" lost when nla_ok() has a stricter one?
> >
> > 1156 static inline int nla_ok(const struct nlattr *nla, int remaining)
> > 1157 {
> > 1158         return remaining >= (int) sizeof(*nla) &&
> > 1159                nla->nla_len >= sizeof(*nla) &&
> > 1160                nla->nla_len <= remaining;
> > 1161 }
> >
> > Line 1156 assures msk_depth is not only non-zero but also larger
> > than the nla struct size, and clearly nla won't be dereferenced unless
> > this check is passed.
>
> Fair, depth will but 0 so first check already fails, but nla_next()
> would crash since it tries to access the length of the attribute
> unconditionally.

nla_next() is only called when nla_ok() returns true, which is not
the case for msk_depth==0, therefore NULL won't crash here.

The only problem is we become too strict to reject optionally missing
masks, we should not even call nla_ok() here, otherwise it would
break user-space. So,

+               if (!nla_opt_msk)
+                       continue;

Thanks.
