Return-Path: <netdev+bounces-1667-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04F5D6FEBB6
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 08:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D39C281185
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 06:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974E61F195;
	Thu, 11 May 2023 06:23:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F7F1773B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:23:56 +0000 (UTC)
Received: from muru.com (muru.com [72.249.23.125])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A6BCCA;
	Wed, 10 May 2023 23:23:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by muru.com (Postfix) with ESMTPS id 511618109;
	Thu, 11 May 2023 06:23:54 +0000 (UTC)
Date: Thu, 11 May 2023 09:23:53 +0300
From: Tony Lindgren <tony@atomide.com>
To: Judith Mendez <jm@ti.com>
Cc: linux-can@vger.kernel.org,
	Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Schuyler Patton <spatton@ti.com>, devicetree@vger.kernel.org,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 2/2] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <20230511062353.GE14287@atomide.com>
References: <20230510202952.27111-1-jm@ti.com>
 <20230510202952.27111-3-jm@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510202952.27111-3-jm@ti.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

* Judith Mendez <jm@ti.com> [230510 20:31]:
> Add an hrtimer to MCAN class device. Each MCAN will have its own
> hrtimer instantiated if there is no hardware interrupt found and
> poll-interval property is defined in device tree M_CAN node.
> 
> The hrtimer will generate a software interrupt every 1 ms. In
> hrtimer callback, we check if there is a transaction pending by
> reading a register, then process by calling the isr if there is.

So what about system suspend, do you need to do something to
ensure the timer does not happen to run while suspending?

Regards,

Tony

