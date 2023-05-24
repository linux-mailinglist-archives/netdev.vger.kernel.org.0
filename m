Return-Path: <netdev+bounces-5118-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA25170FB09
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:59:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6281A2813B8
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A738C19E41;
	Wed, 24 May 2023 15:59:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFA91951F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:59:14 +0000 (UTC)
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916B31724
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:58:50 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-564dc3dc075so11148917b3.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684943929; x=1687535929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RSx7NVpJoVUE0IuFsRNs5zc6b2qmaAfWzUGO43tnlIY=;
        b=W4rnd1RRJz1sQhwjhVZnU2ah2ujkLS+8GpiMGyaepK7Hf7O0AU/dKF3UDVTBOW2MbM
         ljOMaNUr10NQMKWDExoAKBxc4jOYEJW/taW3f+yd1AAXA9DO8SzkFB68svmrfCXzojXl
         1/qEK0Ccucb7BERzDY9sbNq5syJPaX1+yg5bxZt0/qfGVVTTOUV/VKO5UXyfvnxBp4Jk
         PfMwb7GO+CDr+tX0Veko9Jc9Z/F/b3hBJ7cor0XwUjkoYAKabYGGlsvqvjbbq8+/Z30i
         r2cHwE6SqzU9ajSbnfK8ZtA62YUo14P0Vh6LTQulkK8xVuU1uGAv9xWwY1UEyXhL0dSF
         hyFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684943929; x=1687535929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RSx7NVpJoVUE0IuFsRNs5zc6b2qmaAfWzUGO43tnlIY=;
        b=gcNlmW2bSC40xXHpuKy4pWtl9puLF7599thpcMazvXD0K9sXlyGmf8H9W43D+0o/tE
         s4hzrvHP4o8WOwg6jtP6y6tLHxMt1+nVi+IZqVbu6GOh1/lvZK8AQvw+sKsw8jmsrll9
         k9o/rIKY/WWuYqUYJWboCfPswU6HrGw05KD2K+2csWr55TI3qCielN7z71ayJ8pp1zuQ
         JJV2TW0GT466EFkY3vX0nO5rUEZtblgGKdjMH4q6Zx9AYAU5Sc3rOyC/JA87hAFZnjiw
         q0hNm9cquqaJ4vGiMYyL+FWx2oPzNga6RAU1JEsqscrIcx295tryQLZT7emwVlDsk+x3
         dNSg==
X-Gm-Message-State: AC+VfDzRE85++nlukxWNwDm8Z8xTxV8vZTU2lIEYd0N0mUwgO6DrpkO4
	kbmVIslckQH4u4cQFghnB9SsqZeyrLRmRmmIAMVzbw==
X-Google-Smtp-Source: ACHHUZ6ABZyoauJy1KJLVnDxNIWCHfHopjqyWk3TvLXtoEhC8BKA/jmE2UNecLPkHi2CXrcevbIf5qUodrw5Yd7cBT4=
X-Received: by 2002:a81:6507:0:b0:55a:6dc8:e084 with SMTP id
 z7-20020a816507000000b0055a6dc8e084mr21214734ywb.17.1684943929353; Wed, 24
 May 2023 08:58:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1684887977.git.peilin.ye@bytedance.com> <0c07bd5b72c67a2edf126cd2c6a9daadddb3ca95.1684887977.git.peilin.ye@bytedance.com>
 <5fda8703-9220-4abd-7859-0af973d0d1d7@mojatatu.com>
In-Reply-To: <5fda8703-9220-4abd-7859-0af973d0d1d7@mojatatu.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Wed, 24 May 2023 11:58:38 -0400
Message-ID: <CAM0EoMnwEUdjpA55xtK67iWAH=fh-QUvdMW9Ma0nmG_B8N=s+Q@mail.gmail.com>
Subject: Re: [PATCH v5 net 2/6] net/sched: sch_clsact: Only create under TC_H_CLSACT
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: Peilin Ye <yepeilin.cs@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, 
	Peilin Ye <peilin.ye@bytedance.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Vlad Buslov <vladbu@mellanox.com>, 
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 11:38=E2=80=AFAM Pedro Tammela <pctammela@mojatatu.=
com> wrote:
>
> On 23/05/2023 22:18, Peilin Ye wrote:
> > From: Peilin Ye <peilin.ye@bytedance.com>
> >
> > clsact Qdiscs are only supposed to be created under TC_H_CLSACT (which
> > equals TC_H_INGRESS).  Return -EOPNOTSUPP if 'parent' is not
> > TC_H_CLSACT.
> >
> > Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
> > Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
>
> Tested-by: Pedro Tammela <pctammela@mojatatu.com>
>

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
> > ---
> > change in v5:
> >    - avoid underflowing @egress_needed_key in ->destroy(), reported by
> >      Pedro
> >
> > change in v3, v4:
> >    - add in-body From: tag
> >
> >   net/sched/sch_ingress.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> >
> > diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
> > index f9ef6deb2770..35963929e117 100644
> > --- a/net/sched/sch_ingress.c
> > +++ b/net/sched/sch_ingress.c
> > @@ -225,6 +225,9 @@ static int clsact_init(struct Qdisc *sch, struct nl=
attr *opt,
> >       struct net_device *dev =3D qdisc_dev(sch);
> >       int err;
> >
> > +     if (sch->parent !=3D TC_H_CLSACT)
> > +             return -EOPNOTSUPP;
> > +
> >       net_inc_ingress_queue();
> >       net_inc_egress_queue();
> >
> > @@ -254,6 +257,9 @@ static void clsact_destroy(struct Qdisc *sch)
> >   {
> >       struct clsact_sched_data *q =3D qdisc_priv(sch);
> >
> > +     if (sch->parent !=3D TC_H_CLSACT)
> > +             return;
> > +
> >       tcf_block_put_ext(q->egress_block, sch, &q->egress_block_info);
> >       tcf_block_put_ext(q->ingress_block, sch, &q->ingress_block_info);
> >
>

