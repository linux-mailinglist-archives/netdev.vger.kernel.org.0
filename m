Return-Path: <netdev+bounces-3187-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50FD3705EAC
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 06:28:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4154F1C20DB8
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 04:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ABBC440D;
	Wed, 17 May 2023 04:28:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3D223D8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:28:36 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFB11BE3
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 21:28:35 -0700 (PDT)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5D54C3F436
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1684297709;
	bh=KBpfMGXFAKUC2kcFXYgmGlqf/+Ln1ijfI1krE7exXtI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=dXeCS8HdQ1Mep1Zkhxu4SEHey5ySggR2Bt7l1v7yYcX2YLIeaf/Bdderesk24+U+N
	 bpHxmgSbpNCOdcvjkcjMKimSCHxIun2Cb6Y4OFZzwhVq8CKL59Rsm0ABgbBgtpYRcn
	 0KOHRYKRpCY8e+oQp+cFEz9DyyyhjkHlqtF19Cvho03cO5xTrlP25J36HWdjai2pvY
	 9xBVuIsmbSLY4rnichW0o9KzXdjDk20yd1uCEy7Fldmgfj4wFKI5IR5rUN6q2o4TnU
	 DVozZ0bNqKFqpvdpVNAUh6LEmJ2CXIbUncYd0DNtsVEOvWTGl5f/N8xYSjYaD6qBXS
	 7CFoDv9wj2O2w==
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-51b67183546so180260a12.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 21:28:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684297708; x=1686889708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KBpfMGXFAKUC2kcFXYgmGlqf/+Ln1ijfI1krE7exXtI=;
        b=CvyLepy0eY1hStXrGm1ha9NZpm5woGpaaqHl70xS0Zj8z/y6xfIaC3hsXEFa09a2W1
         t2oJMu9FbrSxcnlxrsnlC7eKpWQjAlG5qwsAezsN/bNHJZBbJD9zkHj1iL8qnTozs0Mo
         8cuQyQSqMvRSBuI9pcsMyeWodi7i55X1lX219vjttZjJdlSSRd14rFHA1I8AyfyRs2WF
         40N4WYhg4asaDWhyTv3szuYtPcZJQjpzqU9koby1BRgRieHSqM3UiAeBru1ZBWVXA7UD
         m+fy4x9F0wLOdqDphEOCDPNC+I6uwiqOKZMJ+kAsoOrmFYWbJ6DlOF42bCdPLufXr7sQ
         qqdA==
X-Gm-Message-State: AC+VfDxZyBL+MyoZ8gXh8n6CjAn8lGHPG+0kuwmaa1gWzxTC2OBZqshm
	YGIsX/lNuV0Y/QfVDS8Oj00v+z8iPvhYZKFWkjx7uwU/7pvH4VhJf6qhdBrqd+mSfhYEo28SyD4
	C21XFpThPbbZnMHktEAej+eqP6IQXakE7zcopePcRHSGWUsaeag==
X-Received: by 2002:a05:6a21:78a0:b0:100:5082:611d with SMTP id bf32-20020a056a2178a000b001005082611dmr42889342pzc.32.1684297707767;
        Tue, 16 May 2023 21:28:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4jauJJgzn0NahJYNuK4adOWvhtRhNxmWcFWppdTKAFqALS+hCZVtqdFpLGQnZ41PvugHRjHrY1TDbErkoB4eM=
X-Received: by 2002:a05:6a21:78a0:b0:100:5082:611d with SMTP id
 bf32-20020a056a2178a000b001005082611dmr42889319pzc.32.1684297707499; Tue, 16
 May 2023 21:28:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230516080327.359825-1-kai.heng.feng@canonical.com> <ZGNeG1O1yS229nPO@nimitz>
In-Reply-To: <ZGNeG1O1yS229nPO@nimitz>
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Wed, 17 May 2023 12:28:16 +0800
Message-ID: <CAAd53p44LFmZowFjRFaNV3fFUbMp2zxJksnCTR-MyhNJYfTeJw@mail.gmail.com>
Subject: Re: [PATCH] net: wwan: t7xx: Ensure init is completed before system sleep
To: Piotr Raczynski <piotr.raczynski@intel.com>
Cc: chandrashekar.devegowda@intel.com, linuxwwan@intel.com, 
	chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com, 
	m.chetan.kumar@linux.intel.com, ricardo.martinez@linux.intel.com, 
	Loic Poulain <loic.poulain@linaro.org>, Sergey Ryazanov <ryazanov.s.a@gmail.com>, 
	Johannes Berg <johannes@sipsolutions.net>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 6:42=E2=80=AFPM Piotr Raczynski
<piotr.raczynski@intel.com> wrote:
>
> On Tue, May 16, 2023 at 04:03:27PM +0800, Kai-Heng Feng wrote:
> > When the system attempts to sleep while mtk_t7xx is not ready, the driv=
er
> > cannot put the device to sleep:
> > [   12.472918] mtk_t7xx 0000:57:00.0: [PM] Exiting suspend, modem in in=
valid state
> > [   12.472936] mtk_t7xx 0000:57:00.0: PM: pci_pm_suspend(): t7xx_pci_pm=
_suspend+0x0/0x20 [mtk_t7xx] returns -14
> > [   12.473678] mtk_t7xx 0000:57:00.0: PM: dpm_run_callback(): pci_pm_su=
spend+0x0/0x1b0 returns -14
> > [   12.473711] mtk_t7xx 0000:57:00.0: PM: failed to suspend async: erro=
r -14
> > [   12.764776] PM: Some devices failed to suspend, or early wake event =
detected
> >
> > Mediatek confirmed the device can take a rather long time to complete
> > its initialization, so wait for up to 20 seconds until init is done.
> >
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>
> Does it fix any issue? Anyway target tree would help here I guess.

It fixes "PM: failed to suspend async: error -14" mentioned in the
commit message.

>
> [...]
>
> > +static int t7xx_pci_pm_prepare(struct device *dev)
> > +{
> > +     struct pci_dev *pdev =3D to_pci_dev(dev);
> > +     struct t7xx_pci_dev *t7xx_dev;
> > +
> > +     t7xx_dev =3D pci_get_drvdata(pdev);
> > +     if (!wait_for_completion_timeout(&t7xx_dev->init_done, 20 * HZ))
>
> #define T7XX_INIT_TIMEOUT or something similar wouldn't do any harm here.

Sure, will do in next revision.

>
> > +             dev_warn(dev, "Not ready for system sleep.\n");
> > +
> > +     return 0;
>
> So in case of a timeout you still return 0, is that OK?

You are right, error code should be returned instead.

Kai-Heng

>
> [...]
> Thanks, Piotr.

