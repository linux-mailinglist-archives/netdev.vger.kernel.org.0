Return-Path: <netdev+bounces-5971-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CE3C713BE8
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 20:54:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEEE8280E70
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 18:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 150DE567E;
	Sun, 28 May 2023 18:54:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F5F10E8
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 18:54:42 +0000 (UTC)
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6E7C4
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 11:54:41 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-bad05c6b389so3819357276.2
        for <netdev@vger.kernel.org>; Sun, 28 May 2023 11:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685300080; x=1687892080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nvLpGwhLqxmzIjeM5Pp0PwEDxQ65zFAIve6CK+Uzmtc=;
        b=148a9VA/ra91xTHV2qnau9bvjRVJoCTTwqnuQHb8nTLu5DjKdgP6cS5SzsYnq1kTn1
         fJZX2uMFgYQX8VAdlseG1yol1ByyjA4zv7K/bn0pEGc/qZIEnmUFobTv7/PnorkGoc/I
         5aBFIeroC15nPH+maaZmJ+KxHQn23EG6JAJ2lGPgpEwKGVfg0qXv1WLui2g9Yyarv6iM
         H9KGobSQflw3NIgGQD6ggUvcIhHvExlxFYW1OSElW0cy5FmfZQMmw7q/0PnANd1PjQDs
         D7AiaDHemu2GCXa8hvMJsnQL3J1ASNqbyYI7Nkms8gqVkJ397i0ho7b81WCQKej+1r4y
         3TXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685300080; x=1687892080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nvLpGwhLqxmzIjeM5Pp0PwEDxQ65zFAIve6CK+Uzmtc=;
        b=geSCARKEeEXU8G94KN9sogss1JfgLgGuFUOC3WO+BVQ3eszmc3G9noSf0lhdR+wMAL
         z/MLWV5zFhrII2yeJK258h76T46AHa6g02YmDZ+vV7UUWMgSbZQLLHsiH9Les5pGXFOH
         jNbLltsbWtR8DsIfo8vZ+6YTM6d8PIzqwxv3xC+M8cP68w9pM6tw8blyNTnVdEd2X8Qf
         gDVDhrRQ4WHF+YdzEk62Fk2KL+1ijo03p7LCfrtVdYnFBdIapFoCsY0DJETqzwK35tY1
         o7InB3pLbAyL7c1RstA46QfnZHCi3qgFBWRljgeKMIpRycW8BwJ0D6221YeYUJuP7HQ4
         65pw==
X-Gm-Message-State: AC+VfDxjaHzgKBiE9d6NBlKqsS0sLvluDtZzyLhB0sKVQGDKf57p8bfD
	tw8zqT+04Gkr1O315KX4n1jBoOqfcBD626THtGoVUg==
X-Google-Smtp-Source: ACHHUZ7lKH7bVRbEdroSsPQfdxyup2qt0Xb72w8sguubPZhhFI4kMlEfz3vGpmXPvDWraKrAXqyeD2MQ2lIsMIbgVE4=
X-Received: by 2002:a25:df04:0:b0:ba8:2c58:be73 with SMTP id
 w4-20020a25df04000000b00ba82c58be73mr9999769ybg.32.1685300080170; Sun, 28 May
 2023 11:54:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1684887977.git.peilin.ye@bytedance.com> <429357af094297abbc45f47b8e606f11206df049.1684887977.git.peilin.ye@bytedance.com>
 <faaeb0b0-8538-9dfa-4c1e-8a225e3534f4@mojatatu.com> <CAM0EoM=3iYmmLjnifx_FDcJfRbN31tRnCE0ZvqQs5xSBPzaqXQ@mail.gmail.com>
 <CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
 <7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com> <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org> <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
In-Reply-To: <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sun, 28 May 2023 14:54:29 -0400
Message-ID: <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
To: Peilin Ye <yepeilin.cs@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Pedro Tammela <pctammela@mojatatu.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jiri Pirko <jiri@resnulli.us>, Peilin Ye <peilin.ye@bytedance.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, 
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org, 
	Cong Wang <cong.wang@bytedance.com>, Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023 at 4:23=E2=80=AFAM Peilin Ye <yepeilin.cs@gmail.com> w=
rote:
>
> Hi Jakub and all,
>
> On Fri, May 26, 2023 at 07:33:24PM -0700, Jakub Kicinski wrote:
> > On Fri, 26 May 2023 16:09:51 -0700 Peilin Ye wrote:
> > > Thanks a lot, I'll get right on it.
> >
> > Any insights? Is it just a live-lock inherent to the retry scheme
> > or we actually forget to release the lock/refcnt?
>
> I think it's just a thread holding the RTNL mutex for too long (replaying
> too many times).  We could replay for arbitrary times in
> tc_{modify,get}_qdisc() if the user keeps sending RTNL-unlocked filter
> requests for the old Qdisc.
>
> I tested the new reproducer Pedro posted, on:
>
> 1. All 6 v5 patches, FWIW, which caused a similar hang as Pedro reported
>
> 2. First 5 v5 patches, plus patch 6 in v1 (no replaying), did not trigger
>    any issues (in about 30 minutes).
>
> 3. All 6 v5 patches, plus this diff:
>
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 286b7c58f5b9..988718ba5abe 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1090,8 +1090,11 @@ static int qdisc_graft(struct net_device *dev, str=
uct Qdisc *parent,
>                          * RTNL-unlocked filter request(s).  This is the =
counterpart of that
>                          * qdisc_refcount_inc_nz() call in __tcf_qdisc_fi=
nd().
>                          */
> -                       if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_s=
leeping))
> +                       if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_s=
leeping)) {
> +                               rtnl_unlock();
> +                               rtnl_lock();
>                                 return -EAGAIN;
> +                       }
>                 }
>
>                 if (dev->flags & IFF_UP)
>
>    Did not trigger any issues (in about 30 mintues) either.
>
> What would you suggest?


I am more worried it is a wackamole situation. We fixed the first
reproducer with essentially patches 1-4 but we opened a new one which
the second reproducer catches. One thing the current reproducer does
is create a lot rtnl contention in the beggining by creating all those
devices and then after it is just creating/deleting qdisc and doing
update with flower where such contention is reduced. i.e it may just
take longer for the mole to pop up.

Why dont we push the V1 patch in and then worry about getting clever
with EAGAIN after? Can you test the V1 version with the repro Pedro
posted? It shouldnt have these issues. Also it would be interesting to
see how performance of the parallel updates to flower is affected.

cheers,
jamal

> Thanks,
> Peilin Ye
>

