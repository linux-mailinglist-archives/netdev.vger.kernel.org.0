Return-Path: <netdev+bounces-7480-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 848DB7206BE
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:02:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E6D61C20CA7
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6962C1C74E;
	Fri,  2 Jun 2023 16:02:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593671B909
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:02:13 +0000 (UTC)
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0BB1BB;
	Fri,  2 Jun 2023 09:02:11 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-256766a1c43so1048763a91.1;
        Fri, 02 Jun 2023 09:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685721731; x=1688313731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xuDfprJrboRzf5u1uDrS/dCv7LltA39eqMpcIyjhXRQ=;
        b=dqnjDk+PySEns2fwhB8Ipf8F9D/wNK95+O1S6L5P+K2jN8qo1z5RZj4DqIMTiidEtj
         HZj1RorvCbyvVgoN5bP0F2rg13OoBLm+OQDDcDYH8L2x1DLCvonHORbUXSeg3sKtA27k
         1zuSbrqnZ/gbBLgAVOTlhlHDihas2E1fyhqVXQ75/fWo6EQ6VcE23xETUrD/8prYj/QT
         1OQNNba2SD5lBAjTe77HW7K09EdXlnUEJe39ctBGCEk4Pl/NPL/VvwqkMF62CNnPy3cY
         hP46xM2IHW+2ekr0q7Spe6/v4VH0t3WY12KZw20kTkN+3H5OBPh59msu6YSfn8lhY6Fq
         I9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685721731; x=1688313731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xuDfprJrboRzf5u1uDrS/dCv7LltA39eqMpcIyjhXRQ=;
        b=drncCoQ5CXaQGk5RG8du6vrkGrUXcmmXkhkHaXY1EDEvOeBqifm1SeG0lDiRrHhylp
         tN2eJKbow3IiCRB1N8MoQ/6mzWVeY3t7ys/hPV1t/lWL//GjJY8Mw9ls4JLdDFr52hZr
         4aWHuFjyGwFs+Y0ljzmNwnwinjKhgCBY2q0qTAOxO1ZHxYikdpF6yLkz/lu2lO8bSyQj
         uS/yXhrCD71LfsWZ+2rXoyKkTWfti4cgqPGVW2bPRiI+1pf9/3ltiqnRB5s6tPGpM9vX
         F0EtkL5t8uShAmnA600itwmGForuxDWVLF/Ze53AS9YkPwgPbJbUXGOwtohvBk7LAbPp
         mm0A==
X-Gm-Message-State: AC+VfDy5x8jQ+9Xmvgfwl/2omL08/u+CDARVYWivdrNO8MtR5anJRe18
	/JAa1hdr2cWacqnZLjbOgyecLZxSCluaHUjmCkXqwCur
X-Google-Smtp-Source: ACHHUZ5Gv34h4x6xVP8yrgytk9HvpKsnxASXFx2v6OgtBqglkEKB3C47eX1HIurLUsCBMlbshpA7WkhAnMstCKuighc=
X-Received: by 2002:a17:90b:1003:b0:253:360a:f6b with SMTP id
 gm3-20020a17090b100300b00253360a0f6bmr342713pjb.13.1685721730887; Fri, 02 Jun
 2023 09:02:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601112839.13799-1-dinghui@sangfor.com.cn>
 <135a45b2c388fbaf9db4620cb01b95230709b9ac.camel@gmail.com>
 <eed0cbf7-ff12-057e-e133-0ddf5e98ef68@sangfor.com.cn> <6110cf9f-c10e-4b9b-934d-8d202b7f5794@lunn.ch>
 <f7e23fe6-4d30-ef1b-a431-3ef6ec6f77ba@sangfor.com.cn> <6e28cea9-d615-449d-9c68-aa155efc8444@lunn.ch>
In-Reply-To: <6e28cea9-d615-449d-9c68-aa155efc8444@lunn.ch>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 2 Jun 2023 09:01:34 -0700
Message-ID: <CAKgT0UdyykQL-BidjaNpjX99FwJTxET51U29q4_CDqmABUuVbw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
To: Andrew Lunn <andrew@lunn.ch>
Cc: Ding Hui <dinghui@sangfor.com.cn>, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pengdonglin@sangfor.com.cn, 
	huangcun@sangfor.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 8:42=E2=80=AFAM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > Also, RTNL should be held during the time both calls are made into th=
e
> > > driver. So nothing from userspace should be able to get in the middle
> > > of these calls to change the number of queues.
> > >
> >
> > The RTNL lock is already be held during every each ioctl in dev_ethtool=
().
> >
> >     rtnl_lock();
> >     rc =3D __dev_ethtool(net, ifr, useraddr, ethcmd, state);
> >     rtnl_unlock();
>
> Yes, exactly. So the kernel should be safe from buffer overruns.
>
> Userspace will not get more than it asked for. It might get less, and
> it could be different to the previous calls. But i'm not aware of
> anything which says anything about the consistency between different
> invocations of ethtool -S.

The problem is the userspace allocation ends up requiring we make two
calls into the stack. So it takes the lock once to get the count,
performs the allocation, and then calls into ethtool again taking the
lock and by then the value may have changed.

Within each call it is held the entire time, but the userspace has to
make two calls. So in between the two the number of rings could
potentially change.

What this change is essentially doing is clamping the copied data to
the lesser of the current value versus the value when the userspace
was allocated. However I am wondering now if we shouldn't just update
the size value and return that as some sort of error for the userspace
to potentially reallocate and repeat until it has the right size.

