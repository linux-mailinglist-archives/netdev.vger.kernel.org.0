Return-Path: <netdev+bounces-9240-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D474F728277
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A8CD1C20FE4
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 14:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A329014288;
	Thu,  8 Jun 2023 14:18:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90328125BA
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 14:18:04 +0000 (UTC)
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88DF2728;
	Thu,  8 Jun 2023 07:18:02 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-256e1d87998so474243a91.3;
        Thu, 08 Jun 2023 07:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686233882; x=1688825882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bqb87njWiq4PAPELCvF47mPKr910RPrIZXjGpBtXcMQ=;
        b=LsaauPA9MU1vTGZq3AZOp7LUhSrcxi8WRgkiCLcMm92PT+z7s8sMQNsyNu78xJugpl
         RGrSMAByGFa4E5h5BMNWCdTatyi8jGbpeb8UJHF54+FPaB1vQ0bI5Wz5Ib3dB8ZxmFy7
         EvTkHH9FtYIK9u+GLtHg7Wk+45vQXqgNORvgpgi1ZAZtWZKekNLv3dqL8WUX2kjz0LSs
         GVz4fP1CcllUsj98fKAKM0GGbv01sMstfNC5CCkkZiKpZonKOsw7wF0kfo7/2TeHi+/q
         9AFpBzLWmLtMahL8Mt/qhgmp2Yu0MZM/L09KecQY+RekMskUf5s5MbBX+jB43Wia6LdH
         rSuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686233882; x=1688825882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bqb87njWiq4PAPELCvF47mPKr910RPrIZXjGpBtXcMQ=;
        b=VrjtDEEClykFEyFM5MDCpHKmXo1pMSSHCddtN4JY5NRg0KGFKUeGifM4yH35C3jAXP
         GFfuX6KjmnYynF3NL2cFSxHwuDIza9lMfRiCllRFP+5L1Ml10mSiDw24rvinKFmNofEx
         hxeZjqJVm4XQZDqPkg3As1mQbrsaYWOGG/EsQ/Hru2j5yXVuSDx4vYe1QJ4k7ySqX6mp
         SWnJahYFAYwS8DPL1ENZPVGFnWKnajSNVwgZXEtsPItPVthrsXK0ktV/CYcwVNTEa7su
         8G5eKjISF8LaQaIeCf2jLmjFo7FqTuQi4kSmg0Ac5HVq/Slg10NoDqp7zpH0K8w38PiI
         0YGQ==
X-Gm-Message-State: AC+VfDwOo1uept0jzKvIhqD+aV/qgidmRDJx6leXPs/Rj2MZxnlRwl6b
	D0hx0gauWQzCoigXq6zePQh6MUb/qd+WXBY5HdcSot98
X-Google-Smtp-Source: ACHHUZ4ZDTiym4DbxXA0gOSQJ6jg9dNkF80vq6A3wmDAUVejS7nGqWv92wnSympe85sE4l1mH2zVVf9RaAOMIp+EOm4=
X-Received: by 2002:a17:90a:598b:b0:253:26e5:765a with SMTP id
 l11-20020a17090a598b00b0025326e5765amr6848141pji.48.1686233882012; Thu, 08
 Jun 2023 07:18:02 -0700 (PDT)
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
 <CAKgT0UdyykQL-BidjaNpjX99FwJTxET51U29q4_CDqmABUuVbw@mail.gmail.com>
 <ece228a3-5c31-4390-b6ba-ec3f2b6c5dcb@lunn.ch> <CAKgT0Uf+XaKCFgBRTn-viVsKkNE7piAuDpht=efixsAV=3JdFQ@mail.gmail.com>
 <44905acd-3ac4-cfe5-5e91-d182c1959407@sangfor.com.cn> <20230602225519.66c2c987@kernel.org>
 <5f0f2bab-ae36-8b13-2c6d-c69c6ff4a43f@sangfor.com.cn> <20230604104718.4bf45faf@kernel.org>
 <f6ad6281-df30-93cf-d057-5841b8c1e2e6@sangfor.com.cn> <20230605113915.4258af7f@kernel.org>
 <034f5393-e519-1e8d-af76-ae29677a1bf5@sangfor.com.cn>
In-Reply-To: <034f5393-e519-1e8d-af76-ae29677a1bf5@sangfor.com.cn>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Thu, 8 Jun 2023 07:17:25 -0700
Message-ID: <CAKgT0UdX7cc-LVFowFrY7mSZMvN0xc+w+oH16GNrduLY-AddSA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
To: Ding Hui <dinghui@sangfor.com.cn>
Cc: Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, 
	edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org, 
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

On Thu, Jun 8, 2023 at 2:06=E2=80=AFAM Ding Hui <dinghui@sangfor.com.cn> wr=
ote:
>
> On 2023/6/6 2:39, Jakub Kicinski wrote:
> > On Mon, 5 Jun 2023 11:39:59 +0800 Ding Hui wrote:
> >> Case 1:
> >> If the user len/n_stats is not zero, we will treat it as correct usage
> >> (although we cannot distinguish between the real correct usage and
> >> uninitialized usage). Return -EINVAL if current length exceed the one
> >> user specified.
> >
> > This assumes user will zero-initialize the value rather than do
> > something like:
> >
> >       buf =3D malloc(1 << 16); // 64k should always be enough
> >       ioctl(s, ETHTOOL_GSTATS, buf)
> >
> >       for (i =3D 0; i < buf.n_stats; i++)
> >               /* use stats */
> >
> > :(
> >
>
> Sorry for late.
>
> Now I'm not sure what can I do next besides reporting the issue.

Well as I said before. The issue points to a driver problem more than
anything else.

Normally the solution is to make it so that the counts don't
fluctuate. That mostly consists of providing strings equal to the
maximum count, and then 0 populating the data for any fields that
don't exist in the case of ethtool -S.

So for example in the case of igb which you had pointed out you could
take a look at ixgbe for inspiration on how to fix it since the two
drivers should be similar and one has the issue and one does not.

