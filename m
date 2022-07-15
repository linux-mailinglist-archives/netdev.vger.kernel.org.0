Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0332576A1A
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiGOWo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbiGOWoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:44:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1EE904FF;
        Fri, 15 Jul 2022 15:43:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4381B80B9D;
        Fri, 15 Jul 2022 22:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4027CC34115;
        Fri, 15 Jul 2022 22:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657924995;
        bh=SYs1CcavLTZPQ9Ht+CPL2jtfT27xIDO5hQjAOP1TFNU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KIKoFMWfzIZ5TA1kgJXoEfDnhmk1OBAGITW/xdyeC0YFlSqDqOxkUcTFCTXQDsf+G
         M8M2moR/Vb3cZTD25WQG/pLwBlhLlGHsm7i/faVG+4zjXKtAdmwAUHlF9JuhZIS4h5
         6YvpqY63DFKa3RufjHVhSLn3wxFyFZ/OnAIvQcxVq/dSdnpGVDNJHY47cgMo43B4WR
         tYd/7sALjqyDk02a+fHDxHbZUD+fZ1f7U1ipBGhvGo36EZKqvuvrGPfPRrvBaLsaqZ
         QG+4D6hGTgdoREXpxRxDj2okxy0LfZxrMdvw2O+c8Nt99Fg8yYJmdpABgaLKD9U3BX
         435n5TzDGhHgg==
Date:   Fri, 15 Jul 2022 15:43:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bernard f6bvp <f6bvp@free.fr>
Cc:     duoming@zju.edu.cn, davem@davemloft.net, edumazet@google.com,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, ralf@linux-mips.org
Subject: Re: [PATCH] net: rose: fix unregistered netdevice: waiting for
 rose0 to become free
Message-ID: <20220715154314.510ca2fb@kernel.org>
In-Reply-To: <ab0eac7b-3041-6772-21dd-273e1b8fc43e@free.fr>
References: <26cdbcc8.3f44f.181f6cc848f.Coremail.duoming@zju.edu.cn>
        <4c604039-ffb8-bca3-90bb-d8014249c9a2@free.fr>
        <ab0eac7b-3041-6772-21dd-273e1b8fc43e@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jul 2022 17:59:06 +0200 Bernard f6bvp wrote:
> Here is the context.
>=20
> This patch adds dev_put(dev) in order to allow removal of rose module=20
> after use of AX25 and ROSE via rose0 device.
>=20
> Otherwise when trying to remove rose module via rmmod rose an infinite=20
> loop message was displayed on all consoles with xx being a random number.
>=20
> unregistered_netdevice: waiting for rose0 to become free. Usage count =3D=
 xx
>=20
> unregistered_netdevice: waiting for rose0 to become free. Usage count =3D=
 xx
>=20
> ...
>=20
> With the patch it is ok to rmmod rose.
>=20
> This bug appeared with kernel 4.10 and was tentatively repaired five=20
> years ago.

Please try resending with git send-email.
Your current email contains HTML so it won't make it to netdev@
and other vger lists.

> *Subject: [BUG] unregistered netdevice: wainting for rose0 to become=20
> free. Usage count =3D xx <https://marc.info/?t=3D148811830800001&r=3D1&w=
=3D2>=20
> From: f6bvp <f6bvp () free ! fr>=20
> <https://marc.info/?a=3D128152583500001&r=3D1&w=3D2> Date: 2017-02-26 14:=
09:08=20
> <https://marc.info/?l=3Dlinux-hams&r=3D1&w=3D2&b=3D201702> Message-ID:=20
> ce03a972-a3b0-ca24-5195-2fe2fd5c44d3 () free ! fr=20
> <https://marc.info/?i=3Dce03a972-a3b0-ca24-5195-2fe2fd5c44d3%20()%20free%=
20!%20fr>*=20
>=20
>=20
> Since then the bug reamains.

Is it possible to use a link to the lore.kernel.org archive? It's the
most common way of referring to past threads these days.

> Signed-off-by: Bernard f6bvp / ai7bg

Well formed s-o-b is required, "the name you'd use if you were signing
a legal document".

> diff --git a/a/net/rose/af_rose.c b/b/net/rose/af_rose.c
> index bf2d986..41e106a 100644
> --- a/a/net/rose/af_rose.c
> +++ b/b/net/rose/af_rose.c
> @@ -711,6 +711,7 @@ static int rose_bind(struct socket *sock, struct=20
> sockaddr *uaddr, int addr_len)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rose_insert_socket(sk);
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sock_reset_flag(sk, SOCK_ZAPP=
ED);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_put(dev);
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>  =C2=A0}
