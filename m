Return-Path: <netdev+bounces-4520-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2715B70D2A8
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:02:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E41DB1C20C02
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B0579C4;
	Tue, 23 May 2023 04:02:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B763E79C1
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 04:02:37 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5965E90;
	Mon, 22 May 2023 21:02:35 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-510dabb39aeso564773a12.2;
        Mon, 22 May 2023 21:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684814554; x=1687406554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0sOU7OuPw6tSvafMs2PbLi775jtfGt2FnCBrmuEymU=;
        b=Aaf7+aX6/XTO2+fh+hX5ywZFyo3QLK8GssCuCiq7aau5mebd9CiW49NMv586c2+7Sz
         LnbKkyBJjdlEuaxZQ8G6dW+iZLiS4tXP26nkv3JV9iA7/8hM4VMBKSHb44xodx16+gSA
         d4p0aMfcc+lUSHDdAMclWX2GliR0384CxLO4sVSnBEP7rA90xNdMwSTqK0mp0pTNJSlE
         gHW1slp3X5EkntyTbUCaAX5mTlRrY6s+P3XK7QEYf//m0yAEFYkvTObcUtM2FwP91Bab
         lIYfsIA2IuVONxB3nouMTXrs3Jd8s4b/Ld37yQ8P7OlJ53omzBv3W0FnYs0al0X7UsgT
         6J1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684814554; x=1687406554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D0sOU7OuPw6tSvafMs2PbLi775jtfGt2FnCBrmuEymU=;
        b=gXTOD2TGHYJhvpnsNzAeCibOfvtVRMxI8aOGfkaXT+kUtvRqz+rbprKvhGA5h2Ehg8
         ppy47fKK1nXPmMseg8Hgi2wRNzUi8Chse+s7ch6/94pjmfJEDYpiO22d/OnN/DoxPFoO
         NVaZg9m+kUon6NMf9qkDpjqpbKeZjMEiJgZWdE1+c5ZoexgAbxRYGEfbvfW5z/7Txwf9
         xgGnSevy65UXEtmOH8vH8KCYB6dHQYT8PjakCrT9Ajq0wcLUs6rwoYoAkhInP79wvom7
         nlA7ygj9dZOFZcSwOkgrH3KsrLIprJPGUV4sTTDv79A/LEcbRfZtquJZ07j77J71AUhW
         hJHA==
X-Gm-Message-State: AC+VfDw/tOQrxr2lHLCHp3u7cOserXPIwJN4QFB3gKLrZbGgVWoKtkgY
	WE+mhzag9hitvaQB+Hmo2K4HDPyPlLBpLh1ElU0=
X-Google-Smtp-Source: ACHHUZ4IXcsOD5mIGVYskoU1lauVXE66Nf9sIUkdHXyl3dFruNVdeh9oTibD8/88oddCLyZKEtyVardOSznN0v9Tkgw=
X-Received: by 2002:a17:907:a01:b0:94f:395b:df1b with SMTP id
 bb1-20020a1709070a0100b0094f395bdf1bmr10657611ejc.21.1684814553688; Mon, 22
 May 2023 21:02:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000a589d005fc52ee2d@google.com> <13528f21-0f36-4fa2-d34f-eecee6720bc1@linux.dev>
 <CAD=hENeCo=-Pk9TWnqxOWP9Pg-JXWk6n6J19gvPo9_h7drROGg@mail.gmail.com>
In-Reply-To: <CAD=hENeCo=-Pk9TWnqxOWP9Pg-JXWk6n6J19gvPo9_h7drROGg@mail.gmail.com>
From: Zhu Yanjun <zyjzyj2000@gmail.com>
Date: Tue, 23 May 2023 12:02:20 +0800
Message-ID: <CAD=hENdoyBZaRz7aTy4mX5Kq1OYmWabx2vx8vPH0gQfHO1grzw@mail.gmail.com>
Subject: Re: [syzbot] [rdma?] INFO: trying to register non-static key in
 skb_dequeue (2)
To: Guoqing Jiang <guoqing.jiang@linux.dev>
Cc: syzbot <syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com>, jgg@ziepe.ca, 
	leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 11:47=E2=80=AFAM Zhu Yanjun <zyjzyj2000@gmail.com> =
wrote:
>
> On Tue, May 23, 2023 at 10:26=E2=80=AFAM Guoqing Jiang <guoqing.jiang@lin=
ux.dev> wrote:
> >
> >
> >
> > On 5/23/23 10:13, syzbot wrote:
> > > Hello,
> > >
> > > syzbot tried to test the proposed patch but the build/boot failed:
> > >
> > > failed to apply patch:
> > > checking file drivers/infiniband/sw/rxe/rxe_qp.c
> > > patch: **** unexpected end of file in patch
>
> This is not the root cause. The fix is not good.

This problem is about "INFO: trying to register non-static key. The
code is fine but needs lockdep annotation, or maybe"

Zhu Yanjun

>
> Zhu Yanjun
>
> > >
> > >
> > >
> > > Tested on:
> > >
> > > commit:         56518a60 RDMA/hns: Modify the value of long message l=
o..
> > > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rd=
ma.git for-rc
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3Deba589d8f49=
c73d356da
> > > compiler:
> > > patch:          https://syzkaller.appspot.com/x/patch.diff?x=3D132bea=
5a280000
> > >
> >
> > Sorry, let me attach the temp patch.
> >
> > #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
> > for-rc

