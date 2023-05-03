Return-Path: <netdev+bounces-63-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E09476F4FB3
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:24:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EC83280D27
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 05:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16CFEA32;
	Wed,  3 May 2023 05:24:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085D17E4
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 05:24:50 +0000 (UTC)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475961FCA
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 22:24:49 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1aaf7067647so22936275ad.0
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 22:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683091489; x=1685683489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOUoq2h7vQ2LWWrpk317bbMBg/boRTbmCAyqMEvibz4=;
        b=fd80pO8hjMMTw9/q7ulxs4BZQokKcUWbvMEVMrkM/p8T/yyzmNMcaMTdGLfN+U2msy
         X5xud6DX2KvVoZj1RAumvzq+0M6yeFppVLqDE4E3fxZLXuX/Fdja8HxsVJscZJIdlppo
         BbeNUd93l6L3xP/CBszZszgXxoknBHdDll8g+ll/4vrZHtyAfECZkLVRUAmI+3b7TunQ
         TU/t4Bfr1+pHh1gmLUFaEke+sXsdTUfrcATOOBLugi5Qw+PfGgNTxhFcGJCHjrnUeyhr
         NbwQ8kFQU/0PrGyMYlduES5Wtlb0Bg75cmzi5NwfJzeZk2G84kXigUGwhIjD4snZW7nh
         gbug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683091489; x=1685683489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOUoq2h7vQ2LWWrpk317bbMBg/boRTbmCAyqMEvibz4=;
        b=RYDAGOtKWVfvj6tWuja+H45Oqs6Tijt9rIBEYjUClbjwI0zWQzufG+z/LlLBkXWVOe
         zZIMIL4VK4EBdEYhjqxEjfTnTMdBbQnlVyw0blx4V2nq/H2xgNvMTS/bCksntcHDyJnZ
         /KVaD0RgPg4OAxGIs51ef3cZx0P++4LAK876xXuOUfpl1QCIXXohR/A81cJVbQQpXFdp
         7th1EYXpMRRIXL9Jc6Rd2YuhxTdb6orkqZc4O0hdqDLjq4v7jQ/PWwQSTJ2rMdFEfQJz
         ODLw2jyJdadxgMSXTJTa4MWrcQb+DKOPLkZfKsTKrU9CNLBehfiC37cEcVeqhA1lK71l
         vuPg==
X-Gm-Message-State: AC+VfDxAZtZ+Qq3AvEFraJxYmVZ2PqupZCqDfk1WjWykhrrLJ6k4CNaN
	f5yp49SgqA+z+641ci26fFWLa3qPoJxxDRSny8w=
X-Google-Smtp-Source: ACHHUZ5wzguVJYnaugGvN7Uz/KX0MppSEMUynEeagv7DdXBiptvQ3l2jKlvYoLIUuCIGBhFpHAVKZWjXsCqBLdJWOJY=
X-Received: by 2002:a17:902:f544:b0:1a6:b1a2:5f21 with SMTP id
 h4-20020a170902f54400b001a6b1a25f21mr1188643plf.8.1683091488575; Tue, 02 May
 2023 22:24:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230423032908.285475-1-glipus@gmail.com> <ZFDbCjkMr7kQ153F@nanopsycho>
In-Reply-To: <ZFDbCjkMr7kQ153F@nanopsycho>
From: Max Georgiev <glipus@gmail.com>
Date: Tue, 2 May 2023 23:24:37 -0600
Message-ID: <CAP5jrPExqDBYG9q4ydS=cX=J55R6L+T_irL1dT2sTDeENmxOnA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 5/5] Implement ndo_hwtstamp_get/set methods in
 netdevsim driver
To: Jiri Pirko <jiri@resnulli.us>
Cc: kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org, 
	maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com, 
	vadim.fedorenko@linux.dev, richardcochran@gmail.com, 
	gerhard@engleder-embedded.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 2, 2023 at 3:42=E2=80=AFAM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Sun, Apr 23, 2023 at 05:29:08AM CEST, glipus@gmail.com wrote:
> >Implementing ndo_hwtstamp_get/set methods in  netdevsim driver
> >to use the newly introduced ndo_hwtstamp_get/setmake it respond to
> > SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs.
> > Also adding .get_ts_info ethtool method allowing to monitor
> > HW timestamp configuration values set using SIOCSHWTSTAMP=C2=B7IOCTL.
> >
> >Suggested-by: Jakub Kicinski <kuba@kernel.org>
> >Signed-off-by: Maxim Georgiev <glipus@gmail.com>
>
> You need to bundle selftest using this feature in to patch.

Yes, Jakub mentioned that, but I didn't get to it.
Thank you for pointing it out! I'll add the selftest.

