Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83B46A27DE
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 09:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBYIPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 03:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjBYIPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 03:15:00 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF3A12068
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 00:14:58 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id ay29-20020a05600c1e1d00b003e9f4c2b623so3826623wmb.3
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 00:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CtmCJAq6Y7jOsusDSxJZMv6hxukGM5yoGfehN1vewLo=;
        b=ltxiEj4dsr5p13V1f4ZEY5Z6nv+72PWrMstmanXrrXksCEqCORgCYHrAf22wjialm2
         NQ226i5Og2wXYRLyqWgHGIU9FC37jIBEYImQLv55RkHbxpGIQ3wWEKsqmpHHJA1Tlxyo
         ldrGArsq0mEz3vZN5qBsZBTQZ3J0oXsqrC9x01LtNmToh4qZZVSafkAzCWwlAjYR+8hq
         s6aFIW8nJp9pOQStguhK2RSPKvhXCUNjloTf5RjCDy/QUS1x0rIQmteMH8sndGR+dehM
         S+zR5WX6sY38dz3CiooLFdMt0i3+tu1ppKgTs6rNTHe8TWkQqPm1LFij3FISBXLQZEGN
         Rj8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CtmCJAq6Y7jOsusDSxJZMv6hxukGM5yoGfehN1vewLo=;
        b=f1hlbsOBhCw8C1qW0mh8r3igbE3r7SC/yrcmmeF3IZCDhSSD7Uq9e/POLGaksqvymS
         SLqa+Wxfhyr3NE6tob7VyDWStyT+T1LsSaO7D+8OypExap/SwOjDFx0+/rkdTg8GM4Qe
         moUNiMHuUAropSBTt1LI7eTQdg4NElDUtVRSjfr+pHDEeR/1VduFOHhwKahygrp8XDmV
         gYE3SCu6cHbIzBmRmplFokqRaRiIBrwzhLBSgRT/Vf/pUuHFHtdsAjabe7VXzQUmcQwq
         BnN/pY7MecqY70D0u8STP2sZgCc1dEp+PoDeuRMPg/ahsYc4q2rOfcxeD0gYoxedC/j6
         3oXA==
X-Gm-Message-State: AO0yUKUgTHhpkKrv8NKM6+SIwk6ktWdQfig38St0BGRTehPLQbSIUDUY
        9XtSTHD/rxX3/6499gwLQRznBU6ZjALNhbMBJLNUsLlNyrGjKqxgzP4=
X-Google-Smtp-Source: AK7set9GMWHRR08NiWZjW496izWt2T/Chzm/2Qj/gnU72Lqm3yTEjXXFZcd1sktQPYW60MpJ8oqIMNPjacD/651lVq8=
X-Received: by 2002:a05:600c:a4c:b0:3eb:2e27:2cf4 with SMTP id
 c12-20020a05600c0a4c00b003eb2e272cf4mr598718wmq.0.1677312896641; Sat, 25 Feb
 2023 00:14:56 -0800 (PST)
MIME-Version: 1.0
References: <20230217223620.28508-1-paulb@nvidia.com> <20230217223620.28508-4-paulb@nvidia.com>
 <CANn89i+Jd6Cy5H0UWS3j+nucGu-e8HP1sqdfoGzS=vGEEGawMw@mail.gmail.com> <083dceba-cc14-5aaf-1661-0ce5e29f161a@nvidia.com>
In-Reply-To: <083dceba-cc14-5aaf-1661-0ce5e29f161a@nvidia.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 25 Feb 2023 09:14:44 +0100
Message-ID: <CANn89iLcuA-shK=eo-vYs_H3Q6GugaLn6nTpVT3dCmhcm87Q8g@mail.gmail.com>
Subject: Re: [PATCH net-next v13 3/8] net/sched: flower: Move filter handle
 initialization earlier
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 25, 2023 at 8:54=E2=80=AFAM Paul Blakey <paulb@nvidia.com> wrot=
e:
>
>
>
> On 23/02/2023 12:24, Eric Dumazet wrote:
> > On Fri, Feb 17, 2023 at 11:36=E2=80=AFPM Paul Blakey <paulb@nvidia.com>=
 wrote:
> >>
> >> To support miss to action during hardware offload the filter's
> >> handle is needed when setting up the actions (tcf_exts_init()),
> >> and before offloading.
> >>
> >> Move filter handle initialization earlier.
> >>
> >> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> >> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> >> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> >> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> >> ---
> >
> > Error path is now potentially crashing because net pointer has not
> > been initialized.
> >
> > I plan fixing this issue with the following:
> >
> > diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> > index e960a46b05205bb0bca7dc0d21531e4d6a3853e3..475fe222a85566639bac75f=
c4a95bf649a10357d
> > 100644
> > --- a/net/sched/cls_flower.c
> > +++ b/net/sched/cls_flower.c
> > @@ -2200,8 +2200,9 @@ static int fl_change(struct net *net, struct
> > sk_buff *in_skb,
> >                  fnew->flags =3D nla_get_u32(tb[TCA_FLOWER_FLAGS]);
> >
> >                  if (!tc_flags_valid(fnew->flags)) {
> > +                       kfree(fnew);
> >                          err =3D -EINVAL;
> > -                       goto errout;
> > +                       goto errout_tb;
> >                  }
> >          }
> >
> > @@ -2226,8 +2227,10 @@ static int fl_change(struct net *net, struct
> > sk_buff *in_skb,
> >                  }
> >                  spin_unlock(&tp->lock);
> >
> > -               if (err)
> > -                       goto errout;
> > +               if (err) {
> > +                       kfree(fnew);
> > +                       goto errout_tb;
> > +               }
> >          }
> >          fnew->handle =3D handle;
> >
> > @@ -2337,7 +2340,6 @@ static int fl_change(struct net *net, struct
> > sk_buff *in_skb,
> >          fl_mask_put(head, fnew->mask);
> >   errout_idr:
> >          idr_remove(&head->handle_idr, fnew->handle);
> > -errout:
> >          __fl_put(fnew);
> >   errout_tb:
> >          kfree(tb);
>
>
> Notice that the bug was before this patch as well.
> We init exts->net only in  fl_set_parms()->tcf_exts_validate(exts), and
> before this patch we called __fl_put() on two errors before that (like
> if tcf_exts_init() failed).
>
>
> Here, its the same, we can't call __fl_put(fnew) till we called
> fl_set_parms(). So you're missing this "goto errorout_idr":
>
>
>         err =3D tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp,=
 handle,
> !tc_skip_hw(fnew->flags));
>         if (err < 0)
>                 goto errout_idr;
>
> Thanks,
> Paul.
>

The bug I am talking about is triggering because ->net pointer is not
initialized.

->net pointer is initialized in  tcf_exts_init_ex(), before any error
can be returned.
