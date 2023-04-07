Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595656DAE39
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjDGNsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbjDGNr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:47:59 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3526CBBA0;
        Fri,  7 Apr 2023 06:46:26 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EAA13E0002;
        Fri,  7 Apr 2023 13:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680875184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mrK6C672JIt+MT68X6BCz2zMvQGZCevEhBBZbeQS/ow=;
        b=Nn5nHDR4zVw+uTAFuEC4YJkP2MYFAkbiKfISA1c6Y7w55eYMMSYEOA0TKo5SA9sCld7j1r
        yD/KFaicpHSbAxKerLFQ93nEd+DxAx5ZlCXi4o7KCr2rsmFgJePBKUeIAfrjResmWVdQ5h
        ZI6z6Npivqr7EY9yda0J6D2xDyDMC4nM7ssCyoCRHN/zwI12cmgheUlmowivlC+7bdPNF3
        f81IBukqiO7jKL+AOdi9PbYq5UmGYUqCWGtJvqfCXIApbH/9Oe1qxYdfF8ObryrSAllvyX
        8eBX9K0bpcbi5Cueo5IhIJyiRNSEnI2MlulBSJYTpPthFfuoFJLyDGazsc0txQ==
Date:   Fri, 7 Apr 2023 15:46:21 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Chen Aotian <chenaotian2@163.com>
Cc:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ieee802154: hwsim: Fix possible memory leaks
Message-ID: <20230407154517.3752e1b7@xps-13>
In-Reply-To: <20230407095301.45858-1-chenaotian2@163.com>
References: <20230407095301.45858-1-chenaotian2@163.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chen,

(resending my answer since apparently the first time it failed)

chenaotian2@163.com wrote on Fri,  7 Apr 2023 17:53:01 +0800:

> After replacing e->info, it is necessary to free the old einfo.

The title should contain:
- wpan (that's the tree you target, use --subject-prefix=3D"PATCH wpan"
  of git-format-patch)
- v2 (because that's a new version, use the -v2 option of
  git-format-patch)

Apparently I mis-wrote the stable address, just add this line to the
commit:

Cc: stable@vger.kernel.org

(right now you sent it to stable@vger.kernelorg which is incorrect,
sorry for the typo)
=20
> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")

And please carry the tags:

Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>

> Signed-off-by: Chen Aotian <chenaotian2@163.com>
> ---
>  drivers/net/ieee802154/mac802154_hwsim.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee8=
02154/mac802154_hwsim.c
> index 8445c2189..6e7e10b17 100644
> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> @@ -685,7 +685,7 @@ static int hwsim_del_edge_nl(struct sk_buff *msg, str=
uct genl_info *info)
>  static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *inf=
o)
>  {
>  	struct nlattr *edge_attrs[MAC802154_HWSIM_EDGE_ATTR_MAX + 1];
> -	struct hwsim_edge_info *einfo;
> +	struct hwsim_edge_info *einfo, *einfo_old;
>  	struct hwsim_phy *phy_v0;
>  	struct hwsim_edge *e;
>  	u32 v0, v1;
> @@ -723,8 +723,10 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, s=
truct genl_info *info)
>  	list_for_each_entry_rcu(e, &phy_v0->edges, list) {
>  		if (e->endpoint->idx =3D=3D v1) {
>  			einfo->lqi =3D lqi;
> +			einfo_old =3D rcu_dereference(e->info);
>  			rcu_assign_pointer(e->info, einfo);
>  			rcu_read_unlock();
> +			kfree_rcu(einfo_old, rcu);
>  			mutex_unlock(&hwsim_phys_lock);
>  			return 0;
>  		}


Thanks,
Miqu=C3=A8l
