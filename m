Return-Path: <netdev+bounces-7654-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9266A721016
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7AB71C20B4C
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 12:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CADE8832;
	Sat,  3 Jun 2023 12:35:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386F41FD9
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 12:35:18 +0000 (UTC)
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9126C133
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 05:35:16 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-565aa2cc428so28845397b3.1
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 05:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685795716; x=1688387716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iuVyWmNBcPzZ9px5HApvrbE+4UzVEeYd3n/ao4IebL4=;
        b=DPE/X+8C36OC5xHFfMvKRPL7NWsT8/ievCoAE3dGGX0hZSLuysF8HLj83SPAI8Dp/C
         gD9Frniifmn6yMIuosNNoWULw3A0iAucNHhhoRHEXjHymk/vCLsUilgeiOA32KmJvfJr
         MAz7W9HQTClxzvduMHySapUto3C/OsGxQdoU2IFpV72wg6+6QQ24t4+bNofN+aI09LKx
         fsJ6LTYoUa6wEJEt1ADnKeBgCUy1++zeDFBf1Ip6b90I2tgD2OzjBxg7z3D3ZcmVGNOY
         pNrUooHL9um5fagF8E5lBCdSR0nFNYGdEiJC1r3lEhwH08oqTX2H1ili/Mcys6xuxVs0
         nKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685795716; x=1688387716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iuVyWmNBcPzZ9px5HApvrbE+4UzVEeYd3n/ao4IebL4=;
        b=IgRsC/KxGIp5KrAtRXo5m0VilB81nXhchDLWvQtBYyGdzGjXeowBB7bFb6Ab22wPp2
         yCxVAb1pjkCNIGHItSGBjPQFjVvh8186WKEhGtwWTwg+k7Eaaa0raKW8A6iR8ioMxIfY
         DoclIBz1Yno1AG1burjIKllAUTLCKgGaJSoDHYEXW2SfioWYSYlf2By381NJKNhhVl0l
         juWUcsTo5KJy0xTRbg8hpqH5VCXHKWm2WouDTMudd0+spvq1LVg8TDb7df7haMD8MYCA
         +n5Jh4qU260TXsligbw6fjHUqzb5I+gT5GfybKtkScYW3dV9QBaq0g8tBhByVEnsSFll
         t7IA==
X-Gm-Message-State: AC+VfDzIJV08HOdCGGdh1mABeCa9HL44stjutzODwlV6dcV+aHoyJse+
	ndEbtnXpzdqwfMJTRghTZ7JRWcSzxG4f+7vbCSC2rw==
X-Google-Smtp-Source: ACHHUZ6lTNKrMmGDVmxukNct/iygaSE/KOAUNTViKMfFRpdChr9z388Vp/CwnLeUrx78ziV2Sdw0AZ+ld/4WvRkp5UU=
X-Received: by 2002:a0d:d956:0:b0:565:bf0d:e26d with SMTP id
 b83-20020a0dd956000000b00565bf0de26dmr2223614ywe.51.1685795715767; Sat, 03
 Jun 2023 05:35:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230531141556.1637341-1-lee@kernel.org> <CANn89iJw2N9EbF+Fm8KCPMvo-25ONwba+3PUr8L2ktZC1Z3uLw@mail.gmail.com>
 <CAM0EoMnUgXsr4UBeZR57vPpc5WRJkbWUFsii90jXJ=stoXCGcg@mail.gmail.com> <20230601140640.GG449117@google.com>
In-Reply-To: <20230601140640.GG449117@google.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 3 Jun 2023 08:35:04 -0400
Message-ID: <CAM0EoMmXFKNMkEFhnLReMO=jwu8ju8udV6-oZO9-yHL_7ocUYw@mail.gmail.com>
Subject: Re: [PATCH 1/1] net/sched: cls_u32: Fix reference counter leak
 leading to overflow
To: Lee Jones <lee@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, xiyou.wangcong@gmail.com, jiri@resnulli.us, 
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 1, 2023 at 10:06=E2=80=AFAM Lee Jones <lee@kernel.org> wrote:
>
> On Wed, 31 May 2023, Jamal Hadi Salim wrote:
>
> > On Wed, May 31, 2023 at 11:03=E2=80=AFAM Eric Dumazet <edumazet@google.=
com> wrote:
> > >
> > > On Wed, May 31, 2023 at 4:16=E2=80=AFPM Lee Jones <lee@kernel.org> wr=
ote:
> > > >
> > > > In the event of a failure in tcf_change_indev(), u32_set_parms() wi=
ll
> > > > immediately return without decrementing the recently incremented
> > > > reference counter.  If this happens enough times, the counter will
> > > > rollover and the reference freed, leading to a double free which ca=
n be
> > > > used to do 'bad things'.
> > > >
> > > > Cc: stable@kernel.org # v4.14+
> > >
> > > Please add a Fixes: tag.
>
> Why?
>
> From memory, I couldn't identify a specific commit to fix, which is why
> I used a Cc tag as per the Stable documentation:
>
> Option 1
> ********
>
> To have the patch automatically included in the stable tree, add the tag
>
> .. code-block:: none
>
>      Cc: stable@vger.kernel.org
>
> in the sign-off area. Once the patch is merged it will be applied to
> the stable tree without anything else needing to be done by the author
> or subsystem maintainer.
>
> > > > Signed-off-by: Lee Jones <lee@kernel.org>
> > > > ---
> > > >  net/sched/cls_u32.c | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> > > > index 4e2e269f121f8..fad61ca5e90bf 100644
> > > > --- a/net/sched/cls_u32.c
> > > > +++ b/net/sched/cls_u32.c
> > > > @@ -762,8 +762,11 @@ static int u32_set_parms(struct net *net, stru=
ct tcf_proto *tp,
> > > >         if (tb[TCA_U32_INDEV]) {
> > > >                 int ret;
> > > >                 ret =3D tcf_change_indev(net, tb[TCA_U32_INDEV], ex=
tack);
> > >
> > > This call should probably be done earlier in the function, next to
> > > tcf_exts_validate_ex()
> > >
> > > Otherwise we might ask why the tcf_bind_filter() does not need to be =
undone.
> > >
> > > Something like:
> > >
> > > diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> > > index 4e2e269f121f8a301368b9783753e055f5af6a4e..ac957ff2216ae18bcabdd=
3af3b0e127447ef8f91
> > > 100644
> > > --- a/net/sched/cls_u32.c
> > > +++ b/net/sched/cls_u32.c
> > > @@ -718,13 +718,18 @@ static int u32_set_parms(struct net *net, struc=
t
> > > tcf_proto *tp,
> > >                          struct nlattr *est, u32 flags, u32 fl_flags,
> > >                          struct netlink_ext_ack *extack)
> > >  {
> > > -       int err;
> > > +       int err, ifindex =3D -1;
> > >
> > >         err =3D tcf_exts_validate_ex(net, tp, tb, est, &n->exts, flag=
s,
> > >                                    fl_flags, extack);
> > >         if (err < 0)
> > >                 return err;
> > >
> > > +       if (tb[TCA_U32_INDEV]) {
> > > +               ifindex =3D tcf_change_indev(net, tb[TCA_U32_INDEV], =
extack);
> > > +               if (ifindex < 0)
> > > +                       return -EINVAL;
> > > +       }
>
> Thanks for the advice.  Leave it with me.
>
> > >         if (tb[TCA_U32_LINK]) {
> > >                 u32 handle =3D nla_get_u32(tb[TCA_U32_LINK]);
> > >                 struct tc_u_hnode *ht_down =3D NULL, *ht_old;
> > > @@ -759,13 +764,9 @@ static int u32_set_parms(struct net *net, struct
> > > tcf_proto *tp,
> > >                 tcf_bind_filter(tp, &n->res, base);
> > >         }
> > >
> > > -       if (tb[TCA_U32_INDEV]) {
> > > -               int ret;
> > > -               ret =3D tcf_change_indev(net, tb[TCA_U32_INDEV], exta=
ck);
> > > -               if (ret < 0)
> > > -                       return -EINVAL;
> > > -               n->ifindex =3D ret;
> > > -       }
> > > +       if (ifindex >=3D 0)
> > > +               n->ifindex =3D ifindex;
> > > +
> >
> > I guess we crossed paths ;->
>
> > Please, add a tdc test as well - it doesnt have to be in this patch,
> > can be a followup.
>
> I don't know how to do that, or even what a 'tdc' is.  Is it trivial?
>
> Can you point me towards the documentation please?

There is a README in tools/testing/selftests/tc-testing/README
If you created the scenario by running some tc command line it should
not be difficult to create such a test. Or just tell us what command
line you used to create it and we can help do one for you this time.
If you found the issue by just eyeballing the code or syzkaller then
just say that in the commit.

cheers,
jamal

> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]

