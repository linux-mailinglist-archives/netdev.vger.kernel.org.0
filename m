Return-Path: <netdev+bounces-7461-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69ECE720635
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:31:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 016DF281889
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 141971B8EA;
	Fri,  2 Jun 2023 15:31:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F116219E63
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:31:34 +0000 (UTC)
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00A518D;
	Fri,  2 Jun 2023 08:31:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-2563a4b6285so1090402a91.2;
        Fri, 02 Jun 2023 08:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685719892; x=1688311892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XVAhse4BY3eKaha4TswgDkvPwrD/95UarSkx0ikeHJo=;
        b=Q/sEsb2pvK1C0fTBXbmLQeHyOvJhNDYHCchkHHSe0G1w3zrDqpF8G8y86kyAE+aHRH
         sREClAqHg8vksuyG5ig/heKo/sIzu17yMmTYu9wXZoH80oBgl6wHdzqxfWC9D7jhLaZX
         infND7AifadESe1DfExi6fdKd1zU400z8WQZKJuUb8wlRFgYgNKrXzSBzJsTVVsOPUin
         43uahjTZ0ZK5WhC8a+NW70qq6tuJTiN80VtsL2CrjwnsPJDcApswMeCP7gNIKZCyREng
         twQINvyEPDly6vgI20cDqHe5xUv7BI/5AP9Jf/inG9yFr0XyYlyLp42/vCYu+c0OHUc6
         7Sww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685719892; x=1688311892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XVAhse4BY3eKaha4TswgDkvPwrD/95UarSkx0ikeHJo=;
        b=NeVDUWfdXkuBMCEhEW5C9BEC4WKzgSxtgW+C/zzNO51c6UUTfwMC8q0/Tc21PUyDdk
         LzpgVsKGOs7iiGwCdozmwJMmTuw9/d8/lJcev4j9rd+knSANOiagQelnBZHsDaCbDAU9
         08WxL6oUCnxqjqROlUUHMtn8djlmNJcTAx7dgsF8q69T76AKa5Edqzr83llVULL+ZSRK
         cqcSn351+GYy6kheBZnHFI8eTSlWjUNt+Dp8DxFtBjYsFzLlYauufNbtYXNRAQpPzpAr
         UHh8046EHg2QbmFMIi0CpYzgT/911X+sSXJedqHyc3kaeVsXezA020RucUNwj0aC+rf+
         EFcw==
X-Gm-Message-State: AC+VfDxZuS+IeLUkeznG2TdjlvYXPioi2NYOwnCo8OCvaYdRy+kEG36P
	XKUpwVNBUpC7mX+ebP1O14ZQX0FRIp7CD/Q2YBnfhZT5
X-Google-Smtp-Source: ACHHUZ6DrKOhjrQaK+eU0OhF6riRy926a05NC9lp36U78gRTIRsFRxZzJuDYgAgqfRxuhK9QG9ltA62ZO2hs+n0RM24=
X-Received: by 2002:a17:90a:19c4:b0:255:7d50:c1aa with SMTP id
 4-20020a17090a19c400b002557d50c1aamr170735pjj.44.1685719891711; Fri, 02 Jun
 2023 08:31:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601112839.13799-1-dinghui@sangfor.com.cn>
 <135a45b2c388fbaf9db4620cb01b95230709b9ac.camel@gmail.com> <eed0cbf7-ff12-057e-e133-0ddf5e98ef68@sangfor.com.cn>
In-Reply-To: <eed0cbf7-ff12-057e-e133-0ddf5e98ef68@sangfor.com.cn>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 2 Jun 2023 08:30:54 -0700
Message-ID: <CAKgT0UeV+E0B8syraLTod7SaduWh2SY8szJ9mBWyL1WBK=P8JA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
To: Ding Hui <dinghui@sangfor.com.cn>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 1, 2023 at 6:46=E2=80=AFPM Ding Hui <dinghui@sangfor.com.cn> wr=
ote:
>
> On 2023/6/1 23:04, Alexander H Duyck wrote:
> > On Thu, 2023-06-01 at 19:28 +0800, Ding Hui wrote:
> >> When we get statistics by ethtool during changing the number of NIC
> >> channels greater, the utility may crash due to memory corruption.
> >>
> >> The NIC drivers callback get_sset_count() could return a calculated
> >> length depends on current number of channels (e.g. i40e, igb).
> >>
> >
> > The drivers shouldn't be changing that value. If the drivers are doing
> > this they should be fixed to provide a fixed length in terms of their
> > strings.
> >
>
> Is there an explicit declaration for the rule?
> I searched the ethernet drivers, found that many drivers that support
> multiple queues return calculated length by number of queues rather than
> fixed value. So pushing all these drivers to follow the rule is hard
> to me.
>
> >> The ethtool allocates a user buffer with the first ioctl returned
> >> length and invokes the second ioctl to get data. The kernel copies
> >> data to the user buffer but without checking its length. If the length
> >> returned by the second get_sset_count() is greater than the length
> >> allocated by the user, it will lead to an out-of-bounds copy.
> >>
> >> Fix it by restricting the copy length not exceed the buffer length
> >> specified by userspace.
> >>
> >> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> >
> > Changing the copy size would not fix this. The problem is the driver
> > will be overwriting with the size that it thinks it should be using.
> > Reducing the value that is provided for the memory allocations will
> > cause the driver to corrupt memory.
> >
>
> I noticed that, in fact I did use the returned length to allocate
> kernel memory, and only use adjusted length to copy to user.

Ah, okay I hadn't noticed that part. Although that leads me to the
question of if any of the drivers might be modifying the length values
stored in the structures. We may want to add a new stack variable to
track what the clamped value is for these rather than just leaving the
value stored in the structure.

> >> ---
> >>   net/ethtool/ioctl.c | 16 +++++++++-------
> >>   1 file changed, 9 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> >> index 6bb778e10461..82a975a9c895 100644
> >> --- a/net/ethtool/ioctl.c
> >> +++ b/net/ethtool/ioctl.c
> >> @@ -1902,7 +1902,7 @@ static int ethtool_self_test(struct net_device *=
dev, char __user *useraddr)
> >>      if (copy_from_user(&test, useraddr, sizeof(test)))
> >>              return -EFAULT;
> >>
> >> -    test.len =3D test_len;
> >> +    test.len =3D min_t(u32, test.len, test_len);
> >>      data =3D kcalloc(test_len, sizeof(u64), GFP_USER);
> >>      if (!data)
> >>              return -ENOMEM;
> >
> > This is the wrong spot to be doing this. You need to use test_len for
> > your allocation as that is what the driver will be writing to. You
> > should look at adjusting after the allocation call and before you do
> > the copy
>
> data =3D kcalloc(test_len, sizeof(u64), GFP_USER);  // yes, **test_len** =
for kernel memory
> ...
> copy_to_user(useraddr, data, array_size(test.len, sizeof(u64)) // **test.=
len** only for copy to user

One other thought on this. Would we ever expect the length value to
change? For many of these I wonder if we shouldn't just return an
error in the case that there isn't enough space to store the test
results.

It might make sense to look at adding a return of ENOSPC or EFBIG when
we encounter a size difference where our output is too big for the
provided userspace buffer. At least with that we are not losing data.

> >
> >> @@ -1915,7 +1915,8 @@ static int ethtool_self_test(struct net_device *=
dev, char __user *useraddr)
> >>      if (copy_to_user(useraddr, &test, sizeof(test)))
> >>              goto out;
> >>      useraddr +=3D sizeof(test);
> >> -    if (copy_to_user(useraddr, data, array_size(test.len, sizeof(u64)=
)))
> >> +    if (test.len &&
> >> +        copy_to_user(useraddr, data, array_size(test.len, sizeof(u64)=
)))
> >>              goto out;
> >>      ret =3D 0;
> >>
> >
> > I don't believe this is adding any value. I wouldn't bother with
> > checking for lengths of 0.
> >
>
> Yes, we already checked the data ptr is not NULL, so we don't need checki=
ng test.len.
> I'll remove it in v2.
>
> >> @@ -1940,10 +1941,10 @@ static int ethtool_get_strings(struct net_devi=
ce *dev, void __user *useraddr)
> >>              return -ENOMEM;
> >>      WARN_ON_ONCE(!ret);
> >>
> >> -    gstrings.len =3D ret;
> >> +    gstrings.len =3D min_t(u32, gstrings.len, ret);
> >>
> >>      if (gstrings.len) {
> >> -            data =3D vzalloc(array_size(gstrings.len, ETH_GSTRING_LEN=
));
> >> +            data =3D vzalloc(array_size(ret, ETH_GSTRING_LEN));
> >>              if (!data)
> >>                      return -ENOMEM;
> >>
> >
> > Same here. We should be using the returned value for the allocations
> > and tests, and then doing the min adjustment after the allocationis
> > completed.
> >
>
> gstrings.len =3D min_t(u32, gstrings.len, ret);   // adjusting
>
> if (gstrings.len) {  // checking the adjusted gstrings.len can avoid unne=
cessary vzalloc and __ethtool_get_strings()
> vzalloc(array_size(ret, ETH_GSTRING_LEN)); // **ret** for kernel memory, =
rather than adjusted lenght
>
> At last, adjusted gstrings.len for copy to user

I see what you are talking about now.

> >> @@ -2055,9 +2056,9 @@ static int ethtool_get_stats(struct net_device *=
dev, void __user *useraddr)
> >>      if (copy_from_user(&stats, useraddr, sizeof(stats)))
> >>              return -EFAULT;
> >>
> >> -    stats.n_stats =3D n_stats;
> >> +    stats.n_stats =3D min_t(u32, stats.n_stats, n_stats);
> >>
> >> -    if (n_stats) {
> >> +    if (stats.n_stats) {
> >>              data =3D vzalloc(array_size(n_stats, sizeof(u64)));
> >>              if (!data)
> >>                      return -ENOMEM;
> >
> > Same here. We should be using n_stats, not stats.n_stats and adjust
> > before you do the final copy.
> >
> >> @@ -2070,7 +2071,8 @@ static int ethtool_get_stats(struct net_device *=
dev, void __user *useraddr)
> >>      if (copy_to_user(useraddr, &stats, sizeof(stats)))
> >>              goto out;
> >>      useraddr +=3D sizeof(stats);
> >> -    if (n_stats && copy_to_user(useraddr, data, array_size(n_stats, s=
izeof(u64))))
> >> +    if (stats.n_stats &&
> >> +        copy_to_user(useraddr, data, array_size(stats.n_stats, sizeof=
(u64))))
> >>              goto out;
> >>      ret =3D 0;
> >>
> >
> > Again. I am not sure what value is being added. If n_stats is 0 then I
> > am pretty sure this will do nothing anyway.
> >
>
> Not really no, n_stats is returned value, and stats.n_stats is adjusted v=
alue,
> if the adjusted stats.n_stats is 0, we avoid memory allocation and settin=
g data ptr
> to NULL, copy_to_user() with NULL ptr maybe cause warn log.

I see now. So data is NULL if stats.n_stats is 0.

