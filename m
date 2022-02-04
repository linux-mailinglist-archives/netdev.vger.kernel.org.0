Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0CB4A9C4E
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376273AbiBDPxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356984AbiBDPxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:53:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C228C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 07:53:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2157FB83243
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 15:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FDAC340E9;
        Fri,  4 Feb 2022 15:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643990000;
        bh=DWb7vAT/CJP2F87PNud+Vot+W/z4Z/fip4IXnPOeZ68=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PjCL8aVUkXRVoB2yusVY8tDMFlTxqGzA0uCxoM2uSZeo0TN2ECan06lg9IsP1S0qI
         hX2ateYHOOUB6QDgxAMsje5qw4hdppNEVGVCjv8hYj4dA6jH9W35WsPdtmJblM8E/P
         JQhC2+LA9hG+pIDel3EYmNqaUpwslKD+X5drQ7l8eVIipl3WJHZ3uK7dQfK2DE32xk
         gcGUwoiHR0z/mbiBUGu4uRPgfglWWKRMIHyiqJUMCWfu+MsM5o+EX3MMw9S00hjmok
         9EdRAnqRzzY4H7yYY/TYGW5wnpcamS2+RJVc94LN8CQDTEaUJhVOhj21bIw6H5NYR8
         V2iCrkNb98DEg==
Date:   Fri, 4 Feb 2022 07:53:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        alsi@bang-olufsen.dk, frank-w@public-files.de, davem@davemloft.net
Subject: Re: [PATCH net-next v6 05/13] net: dsa: realtek: convert subdrivers
 into modules
Message-ID: <20220204075319.18e43379@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <71769232-1502-bd59-0d72-129dbe72efb6@arinc9.com>
References: <20220128060509.13800-1-luizluca@gmail.com>
        <20220128060509.13800-6-luizluca@gmail.com>
        <20220203175850.5d0a8cf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <71769232-1502-bd59-0d72-129dbe72efb6@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022 10:57:22 +0300 Ar=C4=B1n=C3=A7 =C3=9CNAL wrote:
> > Why did all these new config options grow a 'default y'? Our usual
> > policy is to default drivers to disabled. =20
>=20
> NET_DSA_REALTEK_SMI and NET_DSA_REALTEK_MDIO also have got "default y".
>=20
> Respectively:
> 319a70a5fea9 ("net: dsa: realtek-smi: move to subdirectory")
> aac94001067d ("net: dsa: realtek: add new mdio interface for drivers")
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/diff/=
drivers/net/dsa/realtek/Kconfig?id=3D319a70a5fea9590e9431dd57f56191996c4787=
f4
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/diff/=
drivers/net/dsa/realtek/Kconfig?id=3Daac94001067da183455d6d37959892744fa01d=
9d

Indeed, so far we had been doing the opposite what this driver has done
- set the "vendor selection" i.e. NET_DSA_REALTEK default to y since it
doesn't build any code, and the actual code default to n. We are
considering defaulting everything to n now, but it's WIP.

Let me send a patch dropping the default y, please object if there was
a strong reason to do it this way!
