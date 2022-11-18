Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5A662EF9D
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 09:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbiKRIfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 03:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiKRIey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 03:34:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BCD8EB6A;
        Fri, 18 Nov 2022 00:34:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B551B822A9;
        Fri, 18 Nov 2022 08:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A8EC433C1;
        Fri, 18 Nov 2022 08:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668760451;
        bh=IOj/GiYagUGnVOGJEzutZQawFTK6GTzvsmI3Kj7AE8w=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=CNjYfCGvsCrglg+uj3KUjbD+rJc+xgvTsqflC7I+JVnSj1YTrgUPcfPC/oIhiEvTR
         NnnRhMWJ7HeaFobc8Os3uran+o21ZcPtXUeYg0AMh8ua2RfVrAXC6XojC2eWCQyX/j
         dBm980XQ6iMQi+pG5P11vovELHlY22lxWEVfL+o8vcubrdy79l3rSZmDp+YkfSOSFv
         yA9Ne5bCV6GFFnIh8Rk2ca75nY0ZIHogPuNlzkIZvFqygyM5u9WLeaiJZfOUpJLjtn
         09WVDbdG7cgm1dKZlc3LK27lzDDa7gvwODfDvnC0+N11gVQbUxdoUINg/Ta2AqP8ev
         mxAexT0ZAxpZw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221118011249.48112-1-yuehaibing@huawei.com>
References: <20221118011249.48112-1-yuehaibing@huawei.com>
Subject: Re: [PATCH] macsec: Fix invalid error code set
From:   Antoine Tenart <atenart@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        YueHaibing <yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Date:   Fri, 18 Nov 2022 09:34:02 +0100
Message-ID: <166876044229.7589.614742433983865@kwain.local>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting YueHaibing (2022-11-18 02:12:49)
> 'ret' is defined twice in macsec_changelink(), when it is set in macsec_i=
s_offloaded
> case, it will be invalid before return.
>=20
> Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Antoine Tenart <atenart@kernel.org>

Thanks!

> ---
>  drivers/net/macsec.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index a7b46219bab7..d73b9d535b7a 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -3835,7 +3835,6 @@ static int macsec_changelink(struct net_device *dev=
, struct nlattr *tb[],
>         if (macsec_is_offloaded(macsec)) {
>                 const struct macsec_ops *ops;
>                 struct macsec_context ctx;
> -               int ret;
> =20
>                 ops =3D macsec_get_ops(netdev_priv(dev), &ctx);
>                 if (!ops) {
> --=20
> 2.20.1
>
