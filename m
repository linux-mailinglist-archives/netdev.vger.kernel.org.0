Return-Path: <netdev+bounces-1734-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 657776FF033
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:54:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AAC4281678
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CEA8174F0;
	Thu, 11 May 2023 10:54:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8301C76F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:54:50 +0000 (UTC)
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2CC59CD
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:54:47 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-b9daef8681fso7217337276.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683802487; x=1686394487;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B4GytqVhEgk48g8DyzhuT+wTefONX8H2tmAh5E87e6M=;
        b=Ut67zPA2J0cjc/lF7UcP5YwQVX711m/wTi0YUO7mHmZ1b1+ERbSa3x45R7g6vR1+uU
         TMSnAPbF916mJgAtSqG8nq/K4X62SDK0gwukviLuRK0idLO8CyG89wKnoWCQEepD6SH/
         yPJxLd4YDOHe/jwKpYCWPfeBm2BW9AJKXsfxDZ2q/fYxT/dmZ0id35X7uoDd13w4nXcD
         KyCmPxKSc+lmbHb2DTGsQwdHaja7vW1iPlpejXd/KggHhXOvys5wN5nxZjNjp3p54vd+
         auYTJiKN/3KU45W0P/CX+MiasfF7rl7K2kkWI977fuHJGc2obmicIceME+/HbhvvzWnI
         Cm9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683802487; x=1686394487;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B4GytqVhEgk48g8DyzhuT+wTefONX8H2tmAh5E87e6M=;
        b=SAGS2Kn1VFGH9ZbjKLufL8s0AyO2kmgeuZlCxg1zLOOx8XlGtiTJE10SjZG42Ez246
         77Bdqaj+7PJBNJR6gMxKbDXXZL/D4lz9WmUBe1FQuxSktSDTNZpRZ39BIJ2PEeQ4f5GO
         0cSosBHgThobiY9WSYNPMmbBVqgQ4xVkazAUZMXyyIVQTG4C7tj6RKvniUu98ZE/X4bt
         IsCbo3WyIp3CldrTJQWq6rSJXUvWuV7Ig0uKGdIyzUuqrnB4s2k7unB7aoJb7+ggJ8Zj
         bkl5+aY30bAIlPmipn+fuPk4m9JxW2TSeqGl+86Wrr2EW4zVNEu61O8KDlDxcnGJPDg2
         InbA==
X-Gm-Message-State: AC+VfDz+DsswqqNfoBdy89K5SvrHaEBMaCurywBkBr9zidGFSGy3GTmk
	F0Qzd/ORnMh+prFG6M/8wfwIT9f8s7I/Mba1N9x3mQ==
X-Google-Smtp-Source: ACHHUZ7jxTCUYsI/ITKDlQjOCkSFTz1SoM0cCfbFkfJBGdSV9QLz93N6Kba5h6hB9EmbUyyTgdDnKSpOm2WMa5K1dSQ=
X-Received: by 2002:a25:ab0e:0:b0:b67:463e:a719 with SMTP id
 u14-20020a25ab0e000000b00b67463ea719mr20489951ybi.46.1683802486909; Thu, 11
 May 2023 03:54:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230510111833.17810885@canb.auug.org.au>
In-Reply-To: <20230510111833.17810885@canb.auug.org.au>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Thu, 11 May 2023 12:54:11 +0200
Message-ID: <CAPDyKFqEkx_KhNSVdy_mLe78WLNXDRvjnMprzaYvtgF2STawVA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Abel Vesa <abel.vesa@linaro.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>, David Miller <davem@davemloft.net>, 
	Networking <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>, 
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Bjorn Andersson <andersson@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 10 May 2023 at 03:18, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the mmc tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> error: the following would cause module name conflict:
>   drivers/soc/qcom/ice.ko
>   drivers/net/ethernet/intel/ice/ice.ko
>
> Exposed by commit
>
>   31dd43d5032a ("mmc: sdhci-msm: Switch to the new ICE API")
>
> I have used the mmc tree from next-20230509 for today.

Okay, so I have dropped the offending patch from tree now.

It looks like we need to rename the ICE module - and Abel is working on that.

>
> --
> Cheers,
> Stephen Rothwell

Kind regards
Uffe

