Return-Path: <netdev+bounces-4842-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7C5570EB2D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 04:12:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1175D281160
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 02:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 245CB15AA;
	Wed, 24 May 2023 02:12:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1418E15A9
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 02:12:32 +0000 (UTC)
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A661A2
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 19:12:25 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 5614622812f47-38e04d1b2b4so306032b6e.3
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 19:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684894344; x=1687486344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSj5i+Gw4omXF+Po0USTXbvuJfUNeP50nVA98ntJVAU=;
        b=l5+PitrSs37GBulO93VRYhgJoaXfnq9CeSMCSi9Bd9NVrZS0avPRULsaVrakW+BsIJ
         U4I0AI7gJwWXenjnHM74qmVJE58Zg+RH2fQKFpQ69fRcLlm4mEy5QK4jdj0auyD6pNHv
         XqGRjKUsgZXwPI0lLfDKy/JkbIztqoCtQwBS0ieGr1SOfNg2MoIDoEUpttKv+7JP7Lg1
         OFt0uw7W9fdWSH5olUygJa1JhHwRY6j169tRGNmdPGEnGH37WqBZlVr3nyJX8BaDvAXZ
         ta5r5IDVgImvf7ed2qpeFsWEuxOrqw9yMr3HhVa/Isstf/uX7cAyoKZNztn38aZSOQu5
         NBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684894344; x=1687486344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JSj5i+Gw4omXF+Po0USTXbvuJfUNeP50nVA98ntJVAU=;
        b=iL1dGqv2uZYl5CjayVQNqaM7fMryeXo2VNyLP5dwkcWq+/wE7Z7/K1YLUCm74zyG8/
         aE58QEXYkbm8B9NIbgAPUcW2jfXC/R7wPvuNs2aYhQVL7WXzCJ7Sc4GUPKnxUzsLOL6h
         aaLLSF0Ci580XzEKVpKvlih41xukluRp591Xhc1JSUTKwOz/8bL+30rSrsaBuarj0XE7
         ZAuommwKJWFidLljQ0OEgJrOmnVyYBpt/6Y8Rh8nHGaIDqXXEJVqGa6jcIX9bIzlEbVD
         6lKNiOQ6s4SdDM2hvpp1Z8qMScELKy1/bzhCoSnkL9XljimrOm+9mcjWDURL2CazVIsS
         AXJg==
X-Gm-Message-State: AC+VfDzTJjGs64xbw2VdVyA1bEFMRkO9D385treD4C5LW0bwF7Ylfbdx
	Zia0gt9tTrgHGgi6/lE7YyZ+bk7aMgWA3oGg8FiYoVwVnoZCeQ==
X-Google-Smtp-Source: ACHHUZ6XcaTFeifj5m95PsSsd3l6KKisLNzWe7XHXIvrz/DAcVsZ9PR7PBBEEEg3D8JHJsh/FnbZ6M2lK6xN++HvozI=
X-Received: by 2002:a54:4519:0:b0:394:66a3:c683 with SMTP id
 l25-20020a544519000000b0039466a3c683mr7770400oil.43.1684894344633; Tue, 23
 May 2023 19:12:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <34BAAED6-5CD0-42D0-A9FB-82A01962A2D7@linux.alibaba.com>
 <20230519080118.25539-1-cambda@linux.alibaba.com> <659eb737a46878dbf943361a5ededa8f05d0ba46.camel@redhat.com>
 <1CAC04AB-977F-46FB-81D0-70F90456CC4F@linux.alibaba.com>
In-Reply-To: <1CAC04AB-977F-46FB-81D0-70F90456CC4F@linux.alibaba.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Wed, 24 May 2023 10:11:48 +0800
Message-ID: <CAL+tcoAdjqm36JojE=0NR2_7hFor1KSziSFQLo69boLCtw0oCw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Return user_mss for TCP_MAXSEG in
 CLOSE/LISTEN state
To: Cambda Zhu <cambda@linux.alibaba.com>
Cc: Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, 
	Tony Lu <tonylu@linux.alibaba.com>, Jack Yang <mingliang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 9:05=E2=80=AFAM Cambda Zhu <cambda@linux.alibaba.co=
m> wrote:
>
>
> > On May 23, 2023, at 21:45, Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > On Fri, 2023-05-19 at 16:01 +0800, Cambda Zhu wrote:
> >> This patch removes the tp->mss_cache check in getting TCP_MAXSEG of
> >> CLOSE/LISTEN sock. Checking if tp->mss_cache is zero is probably a bug=
,
> >> since tp->mss_cache is initialized with TCP_MSS_DEFAULT. Getting
> >> TCP_MAXSEG of sock in other state will still return tp->mss_cache.
> >>
> >> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> >> Reported-by: Jack Yang <mingliang@linux.alibaba.com>
> >
> > Could you please re-submit including the Eric's tags?
> >
> > Thanks!
> >
> > Paolo
>
> Sorry for no Eric's tag. I don't know the 'Suggested-by' tag before,
> and I'll re-submit the patch.
>
> Should I add Eric's 'Reviewed-by' to the patch? Or this should be added
> by maintainer? Sorry for my ignorance again. :)

Yes. I think the next submission should include a Reviewed-by label as
the previous email said from Eric. Oh, don't forget to include your
previous discussion link :)

Thanks,
Jason

>
> Thanks,
> Cambda
>

