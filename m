Return-Path: <netdev+bounces-3474-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 665CA707599
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 00:47:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FC462817A0
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 22:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15AFD2A9C8;
	Wed, 17 May 2023 22:46:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B832A9C4
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 22:46:57 +0000 (UTC)
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E7640CD
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:46:56 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-64390ae2eacso250988b3a.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684363616; x=1686955616;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Smu0dQ2FzvgA84VPM60OdLIVu6sqcMYQVKYbOduagCE=;
        b=AjIgNhKysEGiAtmWxpMC88gwO27NJTIvuPVp3QOlv1zugH1+U2XE8Lkyef90EYIsXc
         Eqtr3Dr9iolmTijhHyWA54fcxMwIqg9btEnUuVndmBGAykFKQXtQoV6OyhAgXKktcCBB
         xODxO43I6NktB4ScbQyCqWuSyhOG7Bv6DskWLINJVVRrBksm5ih7YNG5blGl1KLMbIE9
         uqJy8DZk6uAbV1U9P12CFU90sHWZkZPnaapn7Q8T+PmARclkHqSTNxc1LfnSANkoEted
         DHgC2Qd+npUZNIWJ+BjqT+GM9EcF5s6K/Z1UJtHZ9nARPP98PVJThJQCQEVJoWXq5wUf
         0KNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684363616; x=1686955616;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Smu0dQ2FzvgA84VPM60OdLIVu6sqcMYQVKYbOduagCE=;
        b=igbtdcNH0/uo21XnIIXs/j2h1zxpLRoLM1k3Lx+Gom2wzuHLUri232uQnp5R5PlMjr
         xCAoU+Hl5SL5GnwdXyR+t40nRhsU47QKEWSRQtCoyHOAPXTGh57BUOnWwkqwmU43cGAF
         1Cc+zlPy4ZYsrkygwMgMXihi3uD5217kVifa/cxsNGFS4HsR5bw/Wqjjo35dIohM/fIN
         HG6X3vxthSySvdW45BxAlwOaQrEyulH8+ae7zJtNbWq/POV9zmrkHFFtooMZPiMMjjpF
         NcsTQe/8CU3RXoBARCjaGXr7+Zp1746x5y7yvrVEQI1eLCcBiGYIGPmptYCBZ8tPYoLS
         4+WQ==
X-Gm-Message-State: AC+VfDxdz6yOQXLxYLza6u9c4T1x37BUsLObzDwnaMQCpgQu6RhiaYLY
	I5jhez4ueK1fk62gGsQhg34=
X-Google-Smtp-Source: ACHHUZ7OVsjlc5cwyrJ5J2NQO6aQ/KUUri/FGlmvvcNYkU/6F9nP2+ASBOSTc3n4+SxIad7p2lbjTg==
X-Received: by 2002:a05:6a20:6a0d:b0:102:5b5:33b3 with SMTP id p13-20020a056a206a0d00b0010205b533b3mr5848304pzk.0.1684363616182;
        Wed, 17 May 2023 15:46:56 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id bv127-20020a632e85000000b0053418f78072sm6276808pgb.2.2023.05.17.15.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 15:46:55 -0700 (PDT)
Date: Wed, 17 May 2023 15:46:53 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	=?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
	vadim.fedorenko@linux.dev, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <ZGVZXTEn+qnMyNgV@hoboy.vegasvil.org>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
 <20230406184646.0c7c2ab1@kernel.org>
 <5f9a1929-b511-707a-9b56-52cc5f1c40ba@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f9a1929-b511-707a-9b56-52cc5f1c40ba@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 03:13:06PM -0700, Jacob Keller wrote:

> For example, ice hardware captures timestamp data in its internal PHY
> well after the MAC layer finishes, but it doesn't expose the PHY to the
> host at all..
> 
> From a timing perspective it matters that its PHY, but from an
> implementation perspective there's not much difference since we don't
> support MAC timestamping at all (and the PHY isn't accessible through
> phylink...)

Here is a crazy idea:  Wouldn't it be nice to have all PHYs represented
in the kernel driver world, even those PHYs that are built in?

I've long thought that having NETWORK_PHY_TIMESTAMPING limited to
PHYLIB (and in practice device tree) systems is unfortunate.

Thanks,
Richard

