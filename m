Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE622F6BBF
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 21:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730331AbhANUEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 15:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbhANUEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 15:04:09 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D641C061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 12:03:29 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 15so4512106pgx.7
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 12:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OLiPrrHqpVMzY7acEpPsYUr7vWHBcAD4wkqETELKSiI=;
        b=F0brsdV0syJHRcmDWo9WwVrODRXvA7nf0RoCUAcwKtTk0zZg30fovk4bVUt4TqLR2N
         1EY5+MerSkMj0SepXe14BUTEzVeffhxFc2niuxOgR9nfOwqnZMLViSgGYqMIs6AX8iTD
         O3ij3cKDwTon+o5M9rEU+pB6sqzCN/T7l/IP4RSDAxVlRd8oYYOITeuQ42QiusaK081p
         zIjmj2dV/8b4OYAa553bPs/1l7KKMKorHRkTIyKfq048zfTvbcDlgOx5ZHDQIcsba74e
         xHKJXpEgUujOaIUtxDMUFOwR3OrwjZts5YkHEIYRhJKJgRhhqvul43+q6FSFp+VtMSUG
         /rKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OLiPrrHqpVMzY7acEpPsYUr7vWHBcAD4wkqETELKSiI=;
        b=KPblO8L0N+P4h9o8xNyvkxLozeKOQ3dprlSp5nXKTesVipFe6ncBlY6AzkEfmtK+UN
         dQ/dFNKds81dQucsu0TDusLswK35Z2g5pzIqyCZHkd/Q9BsjCXp5MLYx1Tbwkt2AZirA
         +EN32r6nOstODUg/PJfz+KNhaIKs3bAiylLe0IEVa6EqV7/k1hYk+DIqcAToNF3rtbfK
         MtXVu8MFy/ZV858hVlv28y9NTIuL0tKTkoZXwPBl4YH3n/LtzSgCRvCxQ1CKnvHFKrIC
         UPW7amgMPZdQWq9XffZavZU0hC8lpQ6xbU3vKIDe2eiVl35BwGJdmge/xeAdZ4k0/PY8
         WuLQ==
X-Gm-Message-State: AOAM53212BKijQGTf9bJsAdYMfzHGNNMGS8SFrKM13C8B+pTZG2eKq5W
        XjMO6F8m2jgd7vG7rtshRKNab7A38DD0bnAQuJQ=
X-Google-Smtp-Source: ABdhPJzO0fo6ZzvUgG0GkgC4q3z85fh9XP9um6YFSh8OvguZlVYyupO7wUDMn2Pq02az/teAEsm+zl1vRixwIReOhXE=
X-Received: by 2002:a62:808d:0:b029:19e:b084:d5b0 with SMTP id
 j135-20020a62808d0000b029019eb084d5b0mr8790462pfd.80.1610654609089; Thu, 14
 Jan 2021 12:03:29 -0800 (PST)
MIME-Version: 1.0
References: <20210114163822.56306-1-xiyou.wangcong@gmail.com> <20210114103848.5153aa5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114103848.5153aa5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 14 Jan 2021 12:03:16 -0800
Message-ID: <CAM_iQpUPzSfbQgDE+BBySFVUqYCqse0kKQ-htN81b9JRTGYfJA@mail.gmail.com>
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

On Thu, Jan 14, 2021 at 10:38 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 14 Jan 2021 08:38:22 -0800 Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > fl_set_enc_opt() simply checks if there are still bytes left to parse,
> > but this is not sufficent as syzbot seems to be able to generate
> > malformatted netlink messages. nla_ok() is more strict so should be
> > used to validate the next nlattr here.
> >
> > And nla_validate_nested_deprecated() has less strict check too, it is
> > probably too late to switch to the strict version, but we can just
> > call nla_ok() too after it.
> >
> > Reported-and-tested-by: syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com
> > Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
> > Fixes: 79b1011cb33d ("net: sched: allow flower to match erspan options")
>
> > @@ -1340,9 +1341,6 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
> >                               NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
> >                               return -EINVAL;
> >                       }
> > -
> > -                     if (msk_depth)
> > -                             nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
> >                       break;
> >               case TCA_FLOWER_KEY_ENC_OPTS_ERSPAN:
> >                       if (key->enc_opts.dst_opt_type) {
> > @@ -1373,14 +1371,17 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
> >                               NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
> >                               return -EINVAL;
> >                       }
> > -
> > -                     if (msk_depth)
> > -                             nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
> >                       break;
> >               default:
> >                       NL_SET_ERR_MSG(extack, "Unknown tunnel option type");
> >                       return -EINVAL;
> >               }
> > +
> > +             if (!nla_ok(nla_opt_msk, msk_depth)) {
> > +                     NL_SET_ERR_MSG(extack, "Mask attribute is invalid");
> > +                     return -EINVAL;
> > +             }
> > +             nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
>
> we lost the if (msk_depth) now, nla_opt_msk may be NULL -
> neither nla_ok() nor nla_next() take NULL

How is "if (msk_depth)" lost when nla_ok() has a stricter one?

1156 static inline int nla_ok(const struct nlattr *nla, int remaining)
1157 {
1158         return remaining >= (int) sizeof(*nla) &&
1159                nla->nla_len >= sizeof(*nla) &&
1160                nla->nla_len <= remaining;
1161 }

Line 1156 assures msk_depth is not only non-zero but also larger
than the nla struct size, and clearly nla won't be dereferenced unless
this check is passed.

I guess you mean we should not error out for nla_opt_msk==NULL
case as masks are optional?

Thanks.
