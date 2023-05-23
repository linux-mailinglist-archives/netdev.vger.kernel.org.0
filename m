Return-Path: <netdev+bounces-4555-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF66570D36F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:55:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AE7F28126F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43231B90E;
	Tue, 23 May 2023 05:55:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C481B8F1
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:55:53 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B98D120;
	Mon, 22 May 2023 22:55:49 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-969f90d71d4so1044414066b.3;
        Mon, 22 May 2023 22:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684821348; x=1687413348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQwofF3LF6+OTAfuotFjpahnRo9PFTpogdxKYoNj2Bs=;
        b=pQQYfzfWauHT8cHnTGTLfwbXA5x42YaldGgX0ySCQpej15JE3Bn/rai2Gmo5M/t0WR
         NSZZKBhIlNXU0pM4Rbdizl5fBcAa5kirKQu2aJjdnzCanKS6nH9m6oiFao1SxMxPOrwi
         17Ff6Y22ez4/R96wXaRk45h0XylCMyxFsvRbwt5efawppOGoo7ei1aJshbr7JtgJe9IS
         UtwWttRtDk4yKhbEp/5uj4mkkNb9tsA7RtCvlTNLQxtAcT3XUkMF/MYzoeEjCef6Xw7Y
         qUE7acdS+aq0d/DTQtWQ0wraqfNZb7IXqf/NOeQ94J/VxyzYghbJaFEh3/yPyspZkZoD
         yZdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684821348; x=1687413348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EQwofF3LF6+OTAfuotFjpahnRo9PFTpogdxKYoNj2Bs=;
        b=ipy3lCW/4IFEAOzBJSjMI0eQr1DPmAmRVLZDmYukwgoiLsnC8Dn86DNf5N4GunD2PP
         GxGThy/wYY1maymeNS2W5ocBh1uPix0c19aoCBvQUM/yujbn82P+bItDOneDZx1202ew
         pPLc35eXcBUOi+eIvW3/RyjtL57LerKjl2ArxF/6ZmIuyNSST0BWV2xXB5Srkey+xfB9
         O2VUnTU2vBDn1dcLiMOgH/hgl2y5RAMGv32dQF1TYTVlsbHYKz90zNIGx1eCq8EwkWMc
         +MnfrC212hdzX8GLljgxqYn7G1nQHgIiMSgUBbm+bcAlDqy8e5HbJG8rdE9YnUfvhNsM
         7a0Q==
X-Gm-Message-State: AC+VfDyO82BPJHhbnRhp5rI2OAFrLCuptXuZUS6vnuz8Qww14x5Rrwp5
	XAg30HKmPKt5M9ML3YqtpZH+YJ07f+4wSPMUe+4=
X-Google-Smtp-Source: ACHHUZ6DL6gf5i6CwxpDotwtHQv/Gscf2+KzxFqKf6AvnuiDdBaC9/sgTjpfYN1zLrLAsQjpXq8tidE4pyBpBLTJlpg=
X-Received: by 2002:a17:907:2da7:b0:970:10a9:3ca8 with SMTP id
 gt39-20020a1709072da700b0097010a93ca8mr3660981ejc.22.1684821347638; Mon, 22
 May 2023 22:55:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000a589d005fc52ee2d@google.com> <13528f21-0f36-4fa2-d34f-eecee6720bc1@linux.dev>
 <CAD=hENeCo=-Pk9TWnqxOWP9Pg-JXWk6n6J19gvPo9_h7drROGg@mail.gmail.com>
 <CAD=hENdoyBZaRz7aTy4mX5Kq1OYmWabx2vx8vPH0gQfHO1grzw@mail.gmail.com>
 <0d515e17-5386-61ba-8278-500620969497@linux.dev> <CAD=hENcqa0jQvLjuXw9bMtivCkKpQ9=1e0-y-1oxL23OLjutuw@mail.gmail.com>
 <63b9f740-3762-2ec0-9750-eb8709c886a5@linux.dev>
In-Reply-To: <63b9f740-3762-2ec0-9750-eb8709c886a5@linux.dev>
From: Zhu Yanjun <zyjzyj2000@gmail.com>
Date: Tue, 23 May 2023 13:55:34 +0800
Message-ID: <CAD=hENfRW7stx0c_uTh6KXwLwovv3wA9q-hKA6Xz6UNcEPYcNA@mail.gmail.com>
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
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 1:50=E2=80=AFPM Guoqing Jiang <guoqing.jiang@linux.=
dev> wrote:
>
>
>
> On 5/23/23 12:29, Zhu Yanjun wrote:
> > On Tue, May 23, 2023 at 12:10=E2=80=AFPM Guoqing Jiang <guoqing.jiang@l=
inux.dev> wrote:
> >>
> >>
> >> On 5/23/23 12:02, Zhu Yanjun wrote:
> >>> On Tue, May 23, 2023 at 11:47=E2=80=AFAM Zhu Yanjun <zyjzyj2000@gmail=
.com> wrote:
> >>>> On Tue, May 23, 2023 at 10:26=E2=80=AFAM Guoqing Jiang <guoqing.jian=
g@linux.dev> wrote:
> >>>>>
> >>>>> On 5/23/23 10:13, syzbot wrote:
> >>>>>> Hello,
> >>>>>>
> >>>>>> syzbot tried to test the proposed patch but the build/boot failed:
> >>>>>>
> >>>>>> failed to apply patch:
> >>>>>> checking file drivers/infiniband/sw/rxe/rxe_qp.c
> >>>>>> patch: **** unexpected end of file in patch
> >>>> This is not the root cause. The fix is not good.
> >>> This problem is about "INFO: trying to register non-static key. The
> >>> code is fine but needs lockdep annotation, or maybe"
> > This warning is from "lock is not initialized". This is a
> > use-before-initialized problem.
>
> Right, and it also applies to qp->sq.queue which is set to NULL while do
> cleanup
> still de-reference it.
>
> > The correct fix is to initialize the lock that is complained before it =
is used.
>
> The thing is it can't be initialized due to error, so I guess you want
> to always init them
> even for error cases.

The complaining is about "spinlock is not initialized".

Zhu Yanjun

>
> Guoqing

