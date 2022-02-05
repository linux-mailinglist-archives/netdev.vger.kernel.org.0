Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F474AA646
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 04:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378969AbiBEDib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 22:38:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45416 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbiBEDia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 22:38:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 178C360FC0;
        Sat,  5 Feb 2022 03:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9EBC340E8;
        Sat,  5 Feb 2022 03:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644032309;
        bh=0yo1b9rESVLdmTEjIEubGoSTCpgYkTAI8bXgOZV0fOk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bmnefaW5FHRPeG4UzzsLPkDorZ9V/Q4Gx0d+eYtx50Xq+eAfXUdFFbqlR1l6vM9SN
         m9Za0AsBaC1jBJ/L0J7WHv5I1mYeIH2XBWiVoDB3wf14kg81yw31uPP2L+nMS7g4Fi
         4f3/n0MAi9JRM72p3uz84fzzjiB6BrJjPvLANrblMPJuGawmSwPSJJnjlFb2D+MKLG
         gzItm/tuyYN/cbbfhMF47/Xm74y0yMCJW4JunBFuWdIgfFTAhSLuB0CQLuCtGWiGes
         gA1s67tXfMP6D/QHWMniWk+3JKgHgDP7lSeX6MlBKgKT6orSOR/f0mX3wFR5HruzoG
         qleymwBD5c99w==
Date:   Fri, 4 Feb 2022 19:38:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] bnx2x: Replace one-element array with
 flexible-array member
Message-ID: <20220204193827.019e7791@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204232144.GA442861@embeddedor>
References: <20220204232144.GA442861@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022 17:21:44 -0600 Gustavo A. R. Silva wrote:
> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use =E2=80=9Cflexible array members=E2=80=9D[1] for these c=
ases. The older
> style of one-element or zero-length arrays should no longer be used[2].
>=20
> This helps with the ongoing efforts to globally enable -Warray-bounds
> and get us closer to being able to tighten the FORTIFY_SOURCE routines
> on memcpy().
>=20
> This issue was found with the help of Coccinelle and audited and fixed,
> manually.
>=20
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-le=
ngth-and-one-element-arrays
>=20
> Link: https://github.com/KSPP/linux/issues/79
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Would be useful to include the analysis confirming the change is safe
in this case, beyond the boiler plate commit message.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
