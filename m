Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9CF06CCFD3
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 04:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjC2CPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 22:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjC2CO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 22:14:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF16271C;
        Tue, 28 Mar 2023 19:14:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B661619C4;
        Wed, 29 Mar 2023 02:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B089AC4339B;
        Wed, 29 Mar 2023 02:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680056097;
        bh=GMZxOMb07ezvMItY7QupneC0McChBLFio51bQ337A5U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LpIuE1MO2g6H75THTzXsOc3+S6/vcszA3x/W5cTb60WxSpTmbOvsznIpG/7Z2jsMO
         dddgJfzIdZn6rs79r4GnwFunALS+SkqE6ewRTnpBfQl0xOCF+ooaZ7s/Gw8ZWktM5W
         s5NQOwtE8KxA7Kh5l4ZfW44ljfvv2HDuQsHapvcOHvVZXyAMYUhN79jAPQpqsJNG7I
         bl6kScmrGyyMH8ZixbCBnx/6m/8AEfxaqcej80pnRGFWkPuzXEQtAOy47hHTCLjTtK
         F4UxCM37W2GGVx+vOsgT0FMeD9/HR8EcOegB2poNESA2dWShf93Hz+BleM2uQf9qoP
         xz3S02vx1X3Xw==
Date:   Tue, 28 Mar 2023 19:14:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ganesh Babu <ganesh.babu@ekinops.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
Message-ID: <20230328191456.43d2222e@kernel.org>
In-Reply-To: <PAZP264MB4064279CBAB0D7672726F4A1FC889@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
References: <PAZP264MB4064279CBAB0D7672726F4A1FC889@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Mar 2023 07:13:03 +0000 Ganesh Babu wrote:
> From a91f11fe060729d0009a3271e3a92cead88e2656 Mon Sep 17 00:00:00 2001
> From: "Ganesh Babu" <ganesh.babu@ekinops.com>
> Date: Wed, 15 Mar 2023 15:01:39 +0530
> Subject: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
>=20
> Increase mif6c_pifi field in mif6ctl struct
> from 16 to 32 bits to support 32-bit ifindices.
> The field stores the physical interface (ifindex) for a multicast group.
> Passing a 32-bit ifindex via MRT6_ADD_MIF socket option
> from user space can cause unpredictable behavior in PIM6.
> Changing mif6c_pifi to __u32 allows kernel to handle
> 32-bit ifindex values without issues.

The patch is not formatted correctly.
Maybe try git send-email next time?

> diff --git a/include/uapi/linux/mroute6.h b/include/uapi/linux/mroute6.h
> index 1d90c21a6251..90e6e771beab 100644
> --- a/include/uapi/linux/mroute6.h
> +++ b/include/uapi/linux/mroute6.h
> @@ -75,7 +75,7 @@ struct mif6ctl {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 mifi_t =C2=A0mif6c_mifi; =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 /* Index of MIF */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned char mif6c_flags; =C2=A0 =C2=A0 =C2=
=A0/* MIFF_ flags */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned char vifc_threshold; =C2=A0 /* ttl l=
imit */
> - =C2=A0 =C2=A0 =C2=A0 __u16 =C2=A0 =C2=A0mif6c_pifi; =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* the index of the physical IF */
> + =C2=A0 =C2=A0 =C2=A0 __u32 =C2=A0 =C2=A0mif6c_pifi; =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* the index of the physical IF */

Unfortunately we can't do this. The structure is part of uAPI,
we can't change it's geometry. The kernel must maintain binary
backward compatibility.=20

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int vifc_rate_limit; =C2=A0 /* Rate =
limiter values (NI) */
> =C2=A0};
>=20
> --
> 2.11.0
>=20
> Signed-off-by: Ganesh Babu <ganesh.babu@ekinops.com>
> ---

