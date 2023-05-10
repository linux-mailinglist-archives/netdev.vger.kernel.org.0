Return-Path: <netdev+bounces-1590-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E0246FE661
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 23:41:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDF192815CD
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF3E91D2DC;
	Wed, 10 May 2023 21:41:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ABA21CC1
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 21:41:36 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B59640E0
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=bbdyZ4AHjmUXQpGB4aUIi/4l/r/LYNRv5iFVSr4XHkY=; b=KB
	x0VgN0vx2aZHgSnqIU4PsGb5eBSH4I6P1u3Rr3abhApOQ3AynzN3AHTkdancesyV6ArIM/DIQPrIe
	wLg2Es4Hmd4JxDkd/K+Qo43/7S1D3NzjhXjeft6gK9oxFiABRgsw7TFuD3xYHjGjydvmCTtN0mYES
	pLipc2+FeuW+GUQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pwrYm-00CUDy-Kd; Wed, 10 May 2023 23:41:20 +0200
Date: Wed, 10 May 2023 23:41:20 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Wei Fang <wei.fang@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Fugang Duan <fugang.duan@nxp.com>,
	Chuhong Yuan <hslester96@gmail.com>, netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [PATCH net] net: fec: Better handle pm_runtime_get() failing in
 .remove()
Message-ID: <461cd40d-1576-419b-978e-1a195cd3531c@lunn.ch>
References: <20230510200020.1534610-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230510200020.1534610-1-u.kleine-koenig@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 10:00:20PM +0200, Uwe Kleine-König wrote:
> In the (unlikely) event that pm_runtime_get() (disguised as
> pm_runtime_resume_and_get()) fails, the remove callback returned an
> error early. The problem with this is that the driver core ignores the
> error value and continues removing the device. This results in a
> resource leak. Worse the devm allocated resources are freed and so if a
> callback of the driver is called later the register mapping is already
> gone which probably results in a crash.
> 
> Fixes: a31eda65ba21 ("net: fec: fix clock count mis-match")
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

