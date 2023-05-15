Return-Path: <netdev+bounces-2660-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74F32702E8A
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31EC8281012
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662DCC8F8;
	Mon, 15 May 2023 13:40:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A946C8EC
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:40:32 +0000 (UTC)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4802B10F5
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:40:29 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id BF0CB5C01A0;
	Mon, 15 May 2023 09:40:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 15 May 2023 09:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684158026; x=1684244426; bh=PQIk/29GxnjHZ
	MSAhXVXKk1KOu0TeBlhB3Skn/Xvv/M=; b=ZVCPDEJOh5b9StgJPLgfehnMI7rAv
	blQ/BQK4/d3kXPUg+8ZZJXiX5Cvfi0exRIC5nP+ejxW4fd8a23H4wP3TVREb9lsY
	hPr7p6qMulA2fzPISaIbkNYRIfuUzWlb+4VxQRvFeibe7OPEDrm3duhXl70KI14G
	FVw457e0XN9KXkq4N6lQUf/2H7hBbXt1kkV2qyTSvC+c4Flm2iJKVz/KdzI76wa0
	P4vHw/aTMQsOf9hl2L1UMjvP67gNEEAuaC4e80MdfLFz7DnSbFLn60N2K8XjXAmq
	Xldc0xwrg5Y0J2aNBuDnPcG1XHghsmgxRqtaUpW+CB+LDI/7towu46u+g==
X-ME-Sender: <xms:SjZiZDXtiTutS2ZpWvR3H1z3054jf4PazM3sv3QjCdlbSS6Jbd28kQ>
    <xme:SjZiZLm5qS-f8aCLThr_p2wQx8F5TTx6ZRsbYy8eV7WtX3qhUnRAVGCwtWe8sUu5Q
    dVkOFNZAxjD7xk>
X-ME-Received: <xmr:SjZiZPahDGR7TB4FiyeSbsN91MYj9z5PxAZcq__9RznKx2la_r3YqB4O7BrD>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeehjedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepgeffteeftdejvdffteekueeivdetkeejteegudeffeeihefhffetgfduffeu
    hfejnecuffhomhgrihhnpehinhhithdrnhgvthenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:SjZiZOVlj9pjhiZuDla3pY8HefP78TwPg-i3c2Xs0dWBWbUVKVcspw>
    <xmx:SjZiZNnk-aWwSJQ9nrSVudBy9FSP8-AB1LkgrqTLhsQ1CtoM_XIRlQ>
    <xmx:SjZiZLcC9NWHEscOoqkCDvZ5ZSvV8ts1Evz8DxuGxf52RHVu6gSdEA>
    <xmx:SjZiZDUkyefHP3fiAjRgP-tBWfNi62Qzdx9ajQG_NZfwzNrEpHb8rA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 May 2023 09:40:25 -0400 (EDT)
Date: Mon, 15 May 2023 16:40:23 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, netdev@vger.kernel.org,
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, jacob.e.keller@intel.com, saeedm@nvidia.com,
	moshe@nvidia.com
Subject: Re: [patch net] devlink: change per-devlink netdev notifier to
 static one
Message-ID: <ZGI2R2oTm3/+OM5W@shredder>
References: <20230510144621.932017-1-jiri@resnulli.us>
 <CGME20230515090912eucas1p2489efdc97f9cf1fddf2aad0449e8a2c7@eucas1p2.samsung.com>
 <600ddf9e-589a-2aa0-7b69-a438f833ca10@samsung.com>
 <ZGIY9jOHkHxbnTjq@nanopsycho>
 <ZGIgIglwmOTX3IbS@shredder>
 <ZGInmY/2Rl7xheq6@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGInmY/2Rl7xheq6@nanopsycho>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 02:37:45PM +0200, Jiri Pirko wrote:
> Mon, May 15, 2023 at 02:05:54PM CEST, idosch@idosch.org wrote:
> >On Mon, May 15, 2023 at 01:35:18PM +0200, Jiri Pirko wrote:
> >> Thanks for the report. From the first sight, don't have a clue what may
> >> be wrong. Debugging.
> >
> >I guess he has CONFIG_NET_NS disabled which turns "__net_initdata" to
> >"__initdata" and frees the notifier block after init. "__net_initdata"
> >is a NOP when CONFIG_NET_NS is enabled.
> >
> >Maybe this will help:
> >
> >diff --git a/net/devlink/core.c b/net/devlink/core.c
> >index 0e58eee44bdb..c23ebabadc52 100644
> >--- a/net/devlink/core.c
> >+++ b/net/devlink/core.c
> >@@ -294,7 +294,7 @@ static struct pernet_operations devlink_pernet_ops __net_initdata = {
> >        .pre_exit = devlink_pernet_pre_exit,
> > };
> > 
> >-static struct notifier_block devlink_port_netdevice_nb __net_initdata = {
> >+static struct notifier_block devlink_port_netdevice_nb = {
> >        .notifier_call = devlink_port_netdevice_event,
> > };
> 
> Yeah I just ended up with the same assumption. That is going to fix it.
> Are you sending the proper patch?

Yes. Will send later today

