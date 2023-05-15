Return-Path: <netdev+bounces-2551-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B5D07027C9
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A23B11C20ACE
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD08883A;
	Mon, 15 May 2023 09:04:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3101C13
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:04:38 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB63CF0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:04:35 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id F34FF6000B;
	Mon, 15 May 2023 09:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684141474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z8N/Mn6WxHvU+szGatLETLE4I1RV3FDNM7dzT4SQuUY=;
	b=Gqdy4PZDSRhXo0ejJRSFdcz2s4R7niMigVJYC5vIaXUlvaTztgbELsgfbuYnpUQiiUj8bz
	CNKEd7ZKR/GF5qBMMFQLKLDsfvwj+sozST471+Dd5j8OizgoE2V4Vt1Fdgew852eOa+P2c
	guld3+2NuMFuyeej8TnWi9QOaOvDGSx4iTUJR9AlvcCs1t4Xv3O5SGKXNYgeNdqsQJWRvh
	uc9pJSmmCiYYZX+yw36LD1eaRLTvpWP+YpB41CGSI1vBR/OoLnhvlBrHEWvfXbMmMCpkET
	3RKCNC82+LSwOCI701KejXnImQFFFrLjIux3UFfgPPKwGpphvL6W0i3zMftRWQ==
Date: Mon, 15 May 2023 11:04:32 +0200
From: =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
 glipus@gmail.com, maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
 richardcochran@gmail.com, gerhard@engleder-embedded.com,
 thomas.petazzoni@bootlin.com, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 4/5] net: Let the active time stamping
 layer be selectable.
Message-ID: <20230515110432.63b94557@kmaincent-XPS-13-7390>
In-Reply-To: <20230511163547.120f76b8@kernel.org>
References: <20230406173308.401924-5-kory.maincent@bootlin.com>
	<20230406173308.401924-5-kory.maincent@bootlin.com>
	<20230429175807.wf3zhjbpa4swupzc@skbuf>
	<20230502130525.02ade4a8@kmaincent-XPS-13-7390>
	<20230511134807.v4u3ofn6jvgphqco@skbuf>
	<20230511083620.15203ebe@kernel.org>
	<20230511155640.3nqanqpczz5xwxae@skbuf>
	<20230511092539.5bbc7c6a@kernel.org>
	<20230511205435.pu6dwhkdnpcdu3v2@skbuf>
	<20230511160845.730688af@kernel.org>
	<20230511231803.oylnku5iiibgnx3z@skbuf>
	<20230511163547.120f76b8@kernel.org>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 11 May 2023 16:35:47 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Fri, 12 May 2023 02:18:03 +0300 Vladimir Oltean wrote:
> > > Why can't we treat ndo_hwtstamp_set() == -EOPNOTSUPP as a signal 
> > > to call the PHY? ndo_hwtstamp_set() does not exist, we can give
> > > it whatever semantics we want.    
> > 
> > Hmm, because if we do that, bridged DSA switch ports without hardware
> > timestamping support and without logic to trap PTP to the CPU will just
> > spew those PTP frames with PHY hardware timestamps everywhere, instead
> > of just telling the user hey, the configuration isn't supported?  
> 
> I see, so there is a legit reason to abort. 
> 
> We could use one of the high error codes, then, to signal 
> the "I didn't care, please carry on to the PHY" condition?
> -ENOTSUPP?
> 
> I guess we can add a separate "please configure traps for PTP/NTP" 
> NDO, if you prefer. Mostly an implementation detail.

I am not as expert as you on the network stack therefore I am trying to follow
and understand all the remarks. Please correct me if I say something wrong. It
is interesting to understand all the complications that these changes bring.

To summary, what do you think is preferable for this patch series?
- New ops for TS as suggested by Russell.

- Continue on this implementation and check that Vladimir A,B and C cases are
  handled. Which imply, if I understand well, find a good way to deal with PTP
  change trap (bit or new ndo ops), convert most drivers from IOCTL to NDO
  beforehand. 

- Add MAC-DMA TS? It think it is needed as MAC-DMA TS seems already used and
  different from simple MAC TS in term of quality, as described by Jakub.

