Return-Path: <netdev+bounces-6073-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A259714B1E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:54:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56BC11C209FE
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC4E779C5;
	Mon, 29 May 2023 13:54:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A42747D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 13:54:35 +0000 (UTC)
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B261716
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:54:07 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-b9a6eec8611so6029521276.0
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685368419; x=1687960419;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fhqxTTIKwq/Gd42kBmLwJCj/xCqrY2DaQPSNBAorn4k=;
        b=Ag5hAvwqE6hUbs/B/64ka5OhNzu1UzJzyWZIen0p5pBJgz+6GI5LCxuo+g/D3+SjdV
         fvhKV4XWbCmh+UySolllAtG1abMfrc+UyRBbENBz3Uc5nPOFVyl3dbjIVjgmBCYHaXHh
         KaA2oB8SyOyoX9tXckVuC6Y2FVnKDdpIlrUHnfogPdTSQN8wDel/wvPx3KsvHbeQd8m/
         VtUVnC5ZWbBeZLQgiO9kiBbEmX42VBpL/+jEeOo8nNR9+uDfBEsGpT3s0Km35K8z8wtn
         dJkaI/2pweIdEmWVvFLeT67z9es9MvFLZqFAdBZYrVlpEuac2Bqta6LYdnSLGiYTOXVE
         v0bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685368419; x=1687960419;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fhqxTTIKwq/Gd42kBmLwJCj/xCqrY2DaQPSNBAorn4k=;
        b=YAx2vTk4Ua3X4DGKkGuqWhR5K4cyKvkujIeWvkRDsp2gUo8Q3GBZvdFbxFXo8woyrd
         hBoto6KsXtLJNC2EYoOp6l9wi38RhrsojQsthdEIiAbtuz8rIvAJ3Q+ASKuDPBJHS0AV
         MGRZVhwGc7KFgOSMrGjGC0j6Kp41gQBT2nXS8F5HPJtpEMdjHYLdGPxrBehP/PQwFjKT
         4rUWsQ+KC0EvDypydkNDYC2iXOZelcfED1xhQfB59VwaWqseJCW1U2x5asygObVvAPhw
         OCVZQxHeet1/JZt7ctUdCBLZqWgEwUvprVtnznRi+O+nsmlg0zMsWoQAltzNwAr9Kd6u
         057w==
X-Gm-Message-State: AC+VfDwTY+EbNMWJkorMwduQakC4R0HuVcF4PSf7R9p0Tz43X8hUm0Cv
	q8lycI7BlgZwAORIgjiOLVS7BkZMXa/UFWviWkwZUg==
X-Google-Smtp-Source: ACHHUZ419o78eHbUIMqHvPwt4zQN36AIiYIT+Oe1A1xf0yQq14G8Dd4lzkhnp6yngoav1tMm2o/5+HmD/GZRKucQCzQ=
X-Received: by 2002:a25:310:0:b0:bab:dd56:6519 with SMTP id
 16-20020a250310000000b00babdd566519mr9633893ybd.10.1685368419319; Mon, 29 May
 2023 06:53:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230527093747.3583502-1-shaozhengchao@huawei.com>
 <CAM0EoMkrpShprVbWSFN3FpFWtK9494Hyo+mOSNOJmXCFoieN7Q@mail.gmail.com>
 <c135ae5a-37ff-aa89-a3f7-976799181a04@huawei.com> <ZHRpfB2NatdM6fHJ@C02FL77VMD6R.googleapis.com>
In-Reply-To: <ZHRpfB2NatdM6fHJ@C02FL77VMD6R.googleapis.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 29 May 2023 09:53:28 -0400
Message-ID: <CAM0EoMk+zO0RcnJ4Uie7jU+MNdFz7Mc37W223jVZip62QMRdzQ@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: fix NULL pointer dereference in mq_attach
To: Peilin Ye <yepeilin.cs@gmail.com>
Cc: shaozhengchao <shaozhengchao@huawei.com>, netdev@vger.kernel.org, 
	xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	weiyongjun1@huawei.com, yuehaibing@huawei.com, wanghai38@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 4:59=E2=80=AFAM Peilin Ye <yepeilin.cs@gmail.com> w=
rote:
>
> On Mon, May 29, 2023 at 09:10:23AM +0800, shaozhengchao wrote:
> > On 2023/5/29 3:05, Jamal Hadi Salim wrote:
> > > On Sat, May 27, 2023 at 5:30=E2=80=AFAM Zhengchao Shao <shaozhengchao=
@huawei.com> wrote:
> > > > When use the following command to test:
> > > > 1)ip link add bond0 type bond
> > > > 2)ip link set bond0 up
> > > > 3)tc qdisc add dev bond0 root handle ffff: mq
> > > > 4)tc qdisc replace dev bond0 parent ffff:fff1 handle ffff: mq
> > >
> > > This is fixed by Peilin in this ongoing discussion:
> > > https://lore.kernel.org/netdev/cover.1684887977.git.peilin.ye@bytedan=
ce.com/
> > >
> >       Thank you for your reply. I have notice Peilin's patches before,
> > and test after the patch is incorporated in local host. But it still
> > triggers the problem.
> >       Peilin's patches can be filtered out when the query result of
> > qdisc_lookup is of the ingress type. Here is 4/6 patch in his patches.
> > +if (q->flags & TCQ_F_INGRESS) {
> > +     NL_SET_ERR_MSG(extack,
> > +                    "Cannot regraft ingress or clsact Qdiscs");
> > +     return -EINVAL;
> > +}
> >       However, the query result of my test case in qdisc_lookup is mq.
> > Therefore, the patch cannot solve my problem.
>
> Ack, they are different: patch [4/6] prevents ingress (clsact) Qdiscs
> from being regrafted (to elsewhere), and Zhengchao's patch prevents other
> Qdiscs from being regrafted to ffff:fff1.


Ok, at first glance it was not obvious.
Do we catch all combinations? for egress (0xffffffff) allowed minor is
0xfff3 (clsact::) and 0xffff. For ingress (0xfffffff1) allowed minor
is 0xfff1 and 0xfff2(clsact).

cheers,
jamal

> Thanks,
> Peilin Ye
>

