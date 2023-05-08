Return-Path: <netdev+bounces-900-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F39F66FB4AD
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0A131C209F6
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61DB64423;
	Mon,  8 May 2023 16:05:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAFE20F9
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 16:05:36 +0000 (UTC)
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A2E5596;
	Mon,  8 May 2023 09:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ebaZanb8mMS/3kCwPp9fvWuYfdqaIKECCeqEOV7mGaA=;
	t=1683561934; x=1684771534; b=YTxLkG7l+w7jnhPWdV7E4YhsYBHl+VZ5Yri7FmcJFi3Gjkh
	HP2jyGF2oS5zZYwZSaiM9hipdgOTWzco45fjJSPdxMlfLR+GwUSBBKOD5U60eh3RBRWiA9oj+XWkW
	nryLa0t+eXqGSDzFVHsBV5m2tPc5E1S1fDa0IiAX1+ERzeM0nSrhoSL7XlfkM1A6qMY37SvtbR9R1
	WbJtgkUuCzxfYdELgmShHhcAn0hxpGW6eAWiHNH7HwWrZSCN4MOEmiKqqEFvCVcz1BnMEkTRd7lg2
	ukhxrOhqed6EMhGC/AJ6dU8/UA5BCeRbYnO9mHq455Offlysz8xYdkSKvKXNJ4cQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1pw3MP-003Mif-0F;
	Mon, 08 May 2023 18:05:13 +0200
Message-ID: <68404955637d963f3111a60d3d99c1be8b5d4045.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: iwlwifi: Use default @max_active for
 trans_pcie->rba.alloc_wq
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: jiangshanlai@gmail.com, linux-kernel@vger.kernel.org,
 kernel-team@meta.com,  Kalle Valo <kvalo@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,  Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Gregory Greenman
 <gregory.greenman@intel.com>, Avraham Stern <avraham.stern@intel.com>, Kees
 Cook <keescook@chromium.org>, Mordechay Goodstein
 <mordechay.goodstein@intel.com>,  "Haim, Dreyfuss"
 <haim.dreyfuss@intel.com>, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org
Date: Mon, 08 May 2023 18:05:11 +0200
In-Reply-To: <ZFWIpN7HN431MVSI@slm.duckdns.org>
References: <20230421025046.4008499-1-tj@kernel.org>
	 <20230421025046.4008499-10-tj@kernel.org>
	 <fffb3e6ad76a26a9633728501b5d606864235e65.camel@sipsolutions.net>
	 <ZFWIpN7HN431MVSI@slm.duckdns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 2023-05-05 at 12:52 -1000, Tejun Heo wrote:
> trans_pcie->rba.alloc_wq only hosts a single work item and thus doesn't n=
eed
> explicit concurrency limit. Let's use the default @max_active. This doesn=
't
> cost anything and clearly expresses that @max_active doesn't matter.
>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Gregory Greenman <gregory.greenman@intel.com>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Avraham Stern <avraham.stern@intel.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Mordechay Goodstein <mordechay.goodstein@intel.com>
> Cc: "Haim, Dreyfuss" <haim.dreyfuss@intel.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
>=20

Sure, that seems fine too.

Acked-by: Johannes Berg <johannes.berg@intel.com>

For whatever that's worth, might better to get Gregory ;-)

johannes

> --- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> @@ -3577,7 +3577,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(s
>  	init_waitqueue_head(&trans_pcie->imr_waitq);
> =20
>  	trans_pcie->rba.alloc_wq =3D alloc_workqueue("rb_allocator",
> -						   WQ_HIGHPRI | WQ_UNBOUND, 1);
> +						   WQ_HIGHPRI | WQ_UNBOUND, 0);
>  	if (!trans_pcie->rba.alloc_wq) {
>  		ret =3D -ENOMEM;
>  		goto out_free_trans;
>=20


