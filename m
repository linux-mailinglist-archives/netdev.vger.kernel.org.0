Return-Path: <netdev+bounces-5178-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41E1E710107
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 00:35:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6958228142A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 22:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50EC44400;
	Wed, 24 May 2023 22:35:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1A96087A
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 22:35:34 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E89C123
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:35:09 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f600a6a890so26245e9.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684967707; x=1687559707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3B6lMA8fNeW/gE2ngmr6HzgniDM22RVaujvMzuMnMlY=;
        b=IESF4unk72BCei8C/w6JtEMISo7965mY+cHI6Nj80JeG5+XXzC39bDWhEe4TeEvyv5
         i6LZ8SpaB7xNE3oqyQAjTyQnO+tLNBIxOktB9LgnhEsgZ/olOWXdYV3Q+yeE5KzwFsxL
         uSMC1v6XMxXKpKpmXSJuC2hr7Gt6PtEuN1Eqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684967707; x=1687559707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3B6lMA8fNeW/gE2ngmr6HzgniDM22RVaujvMzuMnMlY=;
        b=hYsHBBdv5rMhMGKunYxRvXCPvO4Y/in36ninZ8oqbaRO1zg1qLig9N2wf1nGAUMCsd
         gJRKLHcvnVoyS+vXq5VN8qTVlOiis+72Et7jm1gljLqp1bcGWngosN0u4piIfivYNUyj
         btbPzlHOwymnWby/ANPHmC1AMfKjDFGrBNufVVWjksTx9S95iwHfPeFxd3pjn/LswmTT
         ymLb2oCRxdbQVBeo6nCPUvBpNAiIOHFrf1IlZsi/mkkkuciYAjLFoH7MTrsQrK+iuJ1R
         7Fn3O/gx5z2Gsjnj0HRoLUQsHxaBesFJqDOYUrEne18lnOfGkncoGfKS6isB8iv2/17K
         TExw==
X-Gm-Message-State: AC+VfDw8vpF/h00mRspCqaXTPj0QjbKg7yRXfuZC5GXMSdwK7+avzo+G
	MMqSRzU+lsA1jGgcjqbgwGmQgSOyokMlqLQT5ZkPYg==
X-Google-Smtp-Source: ACHHUZ4kSYulxWJdqL3pmNyCJWNSacql845TBXpP7lD7xJykrXx7wkSJ8/1UOdgGq8LtySP9MrJYiTyoLDc+zDkWyKo=
X-Received: by 2002:a05:600c:1c93:b0:3f4:2736:b5eb with SMTP id
 k19-20020a05600c1c9300b003f42736b5ebmr11744wms.1.1684967707316; Wed, 24 May
 2023 15:35:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230518072657.1.If9539da710217ed92e764cc0ba0f3d2d246a1aee@changeid>
 <CALs4sv2+Uu=Bry=B3FYzWdNrHjGWDvPCDhTFcNERVpWTjpmEyA@mail.gmail.com>
 <CANEJEGuzoBa_yYHRCa0KygUe=AOhUkSg4u6gWx+QNCuGtKod2Q@mail.gmail.com>
 <52cfebaf-79f6-c318-c14b-3716555d0e8f@intel.com> <SJ0PR11MB5866456B9007E3DC55FD8728E5419@SJ0PR11MB5866.namprd11.prod.outlook.com>
 <CANEJEGsOU3KkG5rQ5ph3EQOiBvPXmhUk7aPvM3nj5V5KudP=ZA@mail.gmail.com> <82a3de3f-acef-c8d9-000c-8a54c2276b77@intel.com>
In-Reply-To: <82a3de3f-acef-c8d9-000c-8a54c2276b77@intel.com>
From: Grant Grundler <grundler@chromium.org>
Date: Wed, 24 May 2023 15:34:55 -0700
Message-ID: <CANEJEGtXQpSqd-k7YJZHMAqbbnWL4kUQmbQwNBjqUo_r3ec6xQ@mail.gmail.com>
Subject: Re: [PATCH] igb: Fix igb_down hung on surprise removal
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Grant Grundler <grundler@chromium.org>, 
	"Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>, Pavan Chebbi <pavan.chebbi@broadcom.com>, 
	"Neftin, Sasha" <sasha.neftin@intel.com>, "Ruinskiy, Dima" <dima.ruinskiy@intel.com>, 
	Ying Hsu <yinghsu@chromium.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, "Brandeburg, Jesse" <jesse.brandeburg@intel.com>, 
	Paolo Abeni <pabeni@redhat.com>, 
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 3:22=E2=80=AFPM Tony Nguyen <anthony.l.nguyen@intel=
.com> wrote:
>
> Hi Grant,
>
> On 5/24/2023 2:01 PM, Grant Grundler wrote:
> > On Wed, May 24, 2023 at 5:34=E2=80=AFAM Loktionov, Aleksandr
> > <aleksandr.loktionov@intel.com> wrote:
> >>
> >> Good day Tony
> >>
> >> We reviewed the patch and have nothing against.
> >
> > Thank you for reviewing!
> >
> > Can I take this as the equivalent of "Signed-off-by: Loktionov,
> > Aleksandr <aleksandr.loktionov@intel.com>"?
>
> Unless a tag is explicitly given, I don't believe one can be inferred.

Yes - that's what I thought and was asking in case that's what
Aleksandr meant (and could easily confirm)

>
> > Or since Tony is listed in MAINTAINERS for drivers/net/ethernet/intel,
> > is he supposed to provide that?
>
> Assuming there's no comments/issues brought up, I'll apply it to the
> respective Intel Wired LAN tree for our validation to have a pass at it.
> Upon successful completion, I'll send the patch on to netdev for them to
> pull. Hope that helps.

Yes - that's what I needed to know. Thank you Tony! :)

Ying Hsu will apply this patch to Chrome OS kernels:
   https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel=
/+/4548800

cheers,
grant

>
> Thanks,
> Tony

