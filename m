Return-Path: <netdev+bounces-6139-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00CEA714E42
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:27:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2DBA1C20A4C
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D85AD2E;
	Mon, 29 May 2023 16:27:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23574A926
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:27:51 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD32AB
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 09:27:49 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f6da07feb2so35715205e9.0
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 09:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685377668; x=1687969668;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xbjC2VjwBr1Fa4ahUn4Bbwe0j4qMemOqaN/QJxVqEhs=;
        b=YBe742hCD6yW7JXzne8qunMbDm2LRy4Y7GRv6qMNL8eSQAV03BdgsYOdU+5HgFKNVI
         /ewrixKdhgET4N3iLrXS29aoKhHYzO+qc2ztPgxBWII7kqaZe2ZyX2WZkitcjUGItHhX
         t8YNa83k7uIgtodMBRTACTY+d2aQPsmKes/FR8fd5m8lqf51sWyQu+Zxqu58oOEhZjWU
         qjT7anU2M+yYU1mODXsGo1LeyLw6mIGsKpv8fPuTXG7ZB1WQdqzFhfQvOISQpnO791mZ
         UZMnsWng36oYErBB4ERJ1gO7SamBBBZeq7AhBju16ocpplFNZKrsVVEtcAtooObndozF
         OgFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685377668; x=1687969668;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xbjC2VjwBr1Fa4ahUn4Bbwe0j4qMemOqaN/QJxVqEhs=;
        b=dmpJ5i6JVIGJ5wdtaUM76iZIyBn+Gf+BrNmbuTAezWJv65otgA6mQtKl3TiYrp46n3
         n64BWWaRFoo6WMb8DbBGnDVArovseKWChROm8rcqt0tWXcrOc6SlNdaL43ra+qLim8cF
         qjWpYql0mhlJFQqFXUER83I1l0W9o4W2xsGg1WCA09bh4NFQcK+XszYCypjAH+e8kbZh
         DQx5hZfXIzl+GkO1oaQXsw5xh6lPiC37hA6xcPWvXmHGw3n5TB8ZE5wHS0aPdAzwuySw
         hvMhh0P5Ep+IbM8FyPcRTDqcxv05NGaTI0mS6/gFpJG3ZpsuxJ8uayM9pmGC0PMPFIzm
         sqaQ==
X-Gm-Message-State: AC+VfDznXs/GWGOEs+HYl/aIXownNF9qAK1R4QBTdcZeMCfYTqJAY9EA
	NOq5pX6CFWOkl2wOf4DgT1k=
X-Google-Smtp-Source: ACHHUZ5Skk61SJvUSmjiHJ2cV9JMznvBTSzvzTepJTZFXr56tuXZCK3otb916kNzlE06JMhrUoEtRA==
X-Received: by 2002:a5d:4b85:0:b0:306:3319:e432 with SMTP id b5-20020a5d4b85000000b003063319e432mr9505622wrt.18.1685377667816;
        Mon, 29 May 2023 09:27:47 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id h12-20020a5d6e0c000000b002ca864b807csm509345wrz.0.2023.05.29.09.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:27:43 -0700 (PDT)
Date: Mon, 29 May 2023 19:27:41 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/6] net: pcs: xpcs: add xpcs_create_mdiodev()
Message-ID: <20230529162741.abcbe3fjvmma7qn5@skbuf>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
 <E1q2USr-008PAU-Kk@rmk-PC.armlinux.org.uk>
 <ab35060f-405d-4aaa-8e84-9f5a77e5eee3@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab35060f-405d-4aaa-8e84-9f5a77e5eee3@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 05:25:45PM +0200, Andrew Lunn wrote:
> >  void xpcs_destroy(struct dw_xpcs *xpcs)
> >  {
> > +	if (xpcs)
> > +		mdio_device_put(xpcs->mdiodev);
> >  	kfree(xpcs);
> >  }
> 
> Nit:
> 
> Is the if () needed? Can destroy be called if create was not
> successful?

No, xpcs_destroy() shouldn't be (and isn't) called if xpcs_create()
or xpcs_create_mdiodev() wasn't successful. If it was, it would be
an indication of sloppy coding style, which can easily be avoided
for minor things like this.

