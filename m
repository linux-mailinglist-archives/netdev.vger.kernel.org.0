Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC8C48C07D
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351818AbiALI4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 03:56:34 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:45947 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351822AbiALI40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:56:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1641977755;
    s=strato-dkim-0002; d=fpond.eu;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=vFQStnjqXTc4v05vj6jrD+RNO0hPv0lOMdS8K36i8Ok=;
    b=ee/x4BbPz98tShI/uBLBe/W5FctSIDIYlmmeEMtEm6vhX2qM04Ub+mi4TZSnQ6yc/x
    4h2mELN6hbTA8S0D5211vGAKony4zwrL74ngAGEPXvm/jFnTWGrSMr7p1bCF+lmdH2nF
    7Koal5oHb/sm9Adh1WeYpBeaZIx5FJFqm2pT/HXtPwiIoObxk59J/gAxzp67pl9gDzz3
    b05OInMkqhOtrRZo1VwhtynqSgLCH9Kv+NP6OBjh+Nhz0LLSK4O+29MvXu0aen0dAmQl
    h2wXs2xJBk9IUlXmPRtDxNWk3rW6/bLitq8fpNKDGZISigPsiEqIIIqYHpybozNBg4YY
    kl9g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzvv3qxio1R8fCv/x28jVM="
X-RZG-CLASS-ID: mo00
Received: from oxapp06-01.back.ox.d0m.de
    by smtp.strato.de (RZmta 47.37.6 AUTH)
    with ESMTPSA id a48ca5y0C8ttK4w
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Wed, 12 Jan 2022 09:55:55 +0100 (CET)
Date:   Wed, 12 Jan 2022 09:55:55 +0100 (CET)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <387311382.2900483.1641977755599@webmail.strato.com>
In-Reply-To: <CAMuHMdVs=NWR1bRuTku09nWT+PyyVCM6Fp1GVu5brCj=VjZZ-g@mail.gmail.com>
References: <20220111162231.10390-1-uli+renesas@fpond.eu>
 <20220111162231.10390-2-uli+renesas@fpond.eu>
 <CAMuHMdVs=NWR1bRuTku09nWT+PyyVCM6Fp1GVu5brCj=VjZZ-g@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] clk: renesas: r8a779a0: add CANFD module clock
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.5-Rev33
X-Originating-Client: open-xchange-appsuite
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 01/12/2022 9:44 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Thanks for your patch!
> 
> > --- a/drivers/clk/renesas/r8a779a0-cpg-mssr.c
> > +++ b/drivers/clk/renesas/r8a779a0-cpg-mssr.c
> > @@ -136,6 +136,7 @@ static const struct mssr_mod_clk r8a779a0_mod_clks[] __initconst = {
> >         DEF_MOD("avb3",         214,    R8A779A0_CLK_S3D2),
> >         DEF_MOD("avb4",         215,    R8A779A0_CLK_S3D2),
> >         DEF_MOD("avb5",         216,    R8A779A0_CLK_S3D2),
> > +       DEF_MOD("canfd0",       328,    R8A779A0_CLK_CANFD),
> 
> The datasheet calls this "canfd".
> 
> >         DEF_MOD("csi40",        331,    R8A779A0_CLK_CSI0),
> >         DEF_MOD("csi41",        400,    R8A779A0_CLK_CSI0),
> >         DEF_MOD("csi42",        401,    R8A779A0_CLK_CSI0),
> 
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> i.e. will queue in renesas-clk-for-v5.18 with the above fixed.

Don't do that! There already is a DIV4 clock called "canfd", and using that name twice breaks stuff. The BSP calls this clock "can-fd" for that reason.

CU
Uli
