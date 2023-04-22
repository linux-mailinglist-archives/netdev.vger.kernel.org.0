Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF046EB956
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 15:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjDVNXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 09:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDVNXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 09:23:30 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8A510E2;
        Sat, 22 Apr 2023 06:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
        t=1682169756; i=ps.report@gmx.net;
        bh=cmUFT4OfIbNytno9emWfQm3hzQNoxBDM3Z5o7EEjaYU=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=QVXfltavTUdwOJ8zoLJGRSvD+g1HuJMOYmwwuaIbdNp1C1fo+dCNo8fkXuQQTT6tf
         0onnoPIh17nQ1et5efnxJp/AjdMcW8fTItCpjYwEkIwkKfHASSY2ozMJU0JQWiZqDu
         o8umVdhX81GkHqHKwBjhN+yZ1dS/ua8HlQKTnBHWW0fCNFnkCgR+cNyezhaFgXgidA
         30h5hVoNHlTDYde2koC2c35wJM0Uwj1Sn1bUjxwU23ABsEWsG71jDfqGXDjryqdOwJ
         HLZd2v29aQJisu/Goa0m89cG7V2MUxOJ8CqmEoobp+wJXx6nTjSsS4xBz8raMR0UG/
         3eMZjXcF302lQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost ([62.216.209.208]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MvbFs-1q89Dm31WQ-00shQn; Sat, 22
 Apr 2023 15:22:36 +0200
Date:   Sat, 22 Apr 2023 15:22:34 +0200
From:   Peter Seiderer <ps.report@gmx.net>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregg Wonderly <greggwonderly@seqtechllc.com>
Subject: Re: [PATCH v1] wifi: ath9k: fix AR9003 mac hardware hang check
 register offset calculation
Message-ID: <20230422152234.639fc98e@gmx.net>
In-Reply-To: <87bkjgmd9g.fsf@toke.dk>
References: <20230420204316.30475-1-ps.report@gmx.net>
        <ZEOf7LXAkdLR0yFI@corigine.com>
        <87bkjgmd9g.fsf@toke.dk>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/ZyPIhRP+ObOUX2XEzdAFS2huyTpaovE4UqGK62OivzVnICqXrH
 QEHeIqQZiSGwFHtrxnaS0wUxCDa/OazTe2/iF+nE5NP1XQjsnLU78eUYcf2OL3CdM+ilIM8
 CgkLTKWtPDqtvQwPd1kzVN6kXa05cxArkeaGzd9S0AmFgRQP5EjSD0+LD45xPBPyhVifomt
 4JRD5JQ7jXc23H9W2c+MA==
UI-OutboundReport: notjunk:1;M01:P0:40teIWQTOuk=;jcWNxkWtqXD+SAJ2lHoSMEIiOfe
 0pxeOtQZLLEA9fzQT3m9bUrRFmGDSiyKYpfad5cbna7tv0ezi6gE2PMXuGmRZkl222gOEH9fk
 JIUgNSr0/rxYVZLjqFkNBLx6uW8cXJNpqkAoA32971CjQSw6rW/PPyLjPEntjzxJOK3TWkHyr
 vsOPEdcSYhE6430Xq6DEWYCnVNuG1BwnXKAgNh6joz6lbC8fWS9vxISg4Dz1GGjd2CrVi/8mp
 de3GLqHBGflz37QMQ1cGyKg9GleTmwIgR5udCG3wo2lOegFhzKy9F73KafMSET34lf326FUhl
 DEN8CZDoPeoRw11UnvuY41Ir33Kn/1bUow5qebjPpbJw9nP7pnbZs63//jPU4N3Ft8Ik3gW2l
 6vZx+5eJUFi8wLG9s8msEhNBQfl2EBC64gZt70oi3nUO7SsZcpi0MuLRoSrMAjxrH7BDpWRE0
 rD38t39hA6pbTsCoEYiYAb/ZgIgPPDpqTSgrXIiPmaKyNcUdPisn05CJvXvtGztfX92A51tRq
 lr8Aj6dhdE30CuK7Xrfwumb/DEwLSIB3WNJ3/dHrxwhXQkbvebVMnLu71gXzGCAjIeGPQhGIv
 5qVkz+whFtneGILJIsbVhTtvZhTeBbEO4L+k3Ol0y+bBhPuFD6FRJJWhi4Bcpnfn26wmBiF2o
 RJm06gCwUM8OrrRGn/LAzkXhkYDbN/LtYnmR/XYI9bh4xfMoxks9h7X4O29kOdyWc5ZUuforF
 AUCxNgowFa77Z5iqQwWDSehmJ7gbEcLBOIyZtxfBm7SNw9FEMbMm1K223p1jmUxo5P4NuBXlK
 J6t7Y0/d+m06ve7iSIZPwlSm0hURkW0EWICA4SCUaqu9nrvRch/w2hkDDqSr2AP2wijdByiYc
 5IBLPbGDWWh1CSyk8+pSLsVeoyapRYj7gvxIdnmTXeeQinrIbnOjYxPTbwXrU4rRkCmylRPlg
 kQ629PdCNLKs8OcgZdtkj1hUmzE=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Apr 2023 12:18:03 +0200, Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
toke.dk> wrote:

> Simon Horman <simon.horman@corigine.com> writes:
>=20
> > On Thu, Apr 20, 2023 at 10:43:16PM +0200, Peter Seiderer wrote: =20
> >> Fix ath9k_hw_verify_hang()/ar9003_hw_detect_mac_hang() register offset
> >> calculation (do not overflow the shift for the second register/queues
> >> above five, use the register layout described in the comments above
> >> ath9k_hw_verify_hang() instead).
> >>=20
> >> Fixes: 222e04830ff0 ("ath9k: Fix MAC HW hang check for AR9003")
> >>=20
> >> Reported-by: Gregg Wonderly <greggwonderly@seqtechllc.com>
> >> Link: https://lore.kernel.org/linux-wireless/E3A9C354-0CB7-420C-ADEF-F=
0177FB722F4@seqtechllc.com/
> >> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> >> ---
> >> Notes:
> >>   - tested with MikroTik R11e-5HnD/Atheros AR9300 Rev:4 (lspci: 168c:0=
033
> >>     Qualcomm Atheros AR958x 802.11abgn Wireless Network Adapter (rev 0=
1))
> >>     card
> >> ---
> >>  drivers/net/wireless/ath/ath9k/ar9003_hw.c | 27 ++++++++++++++--------
> >>  1 file changed, 18 insertions(+), 9 deletions(-)
> >>=20
> >> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/=
wireless/ath/ath9k/ar9003_hw.c
> >> index 4f27a9fb1482..0ccf13a35fb4 100644
> >> --- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
> >> +++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
> >> @@ -1099,17 +1099,22 @@ static bool ath9k_hw_verify_hang(struct ath_hw=
 *ah, unsigned int queue)
> >>  {
> >>  	u32 dma_dbg_chain, dma_dbg_complete;
> >>  	u8 dcu_chain_state, dcu_complete_state;
> >> +	unsigned int dbg_reg, reg_offset;
> >>  	int i;
> >> =20
> >> -	for (i =3D 0; i < NUM_STATUS_READS; i++) {
> >> -		if (queue < 6)
> >> -			dma_dbg_chain =3D REG_READ(ah, AR_DMADBG_4);
> >> -		else
> >> -			dma_dbg_chain =3D REG_READ(ah, AR_DMADBG_5);
> >> +	if (queue < 6) {
> >> +		dbg_reg =3D AR_DMADBG_4;
> >> +		reg_offset =3D i * 5; =20
> >
> > Hi Peter,
> >
> > unless my eyes are deceiving me, i is not initialised here. =20
>=20
> Nice catch! Hmm, I wonder why my test compile didn't complain about
> that? Or maybe it did and I overlooked it? Anyway, Kalle, I already
> delegated this patch to you in patchwork, so please drop it and I'll try
> to do better on reviewing the next one :)

No warning reported because of Makefile:

  1038 # Enabled with W=3D2, disabled by default as noisy
  1039 ifdef CONFIG_CC_IS_GCC
  1040 KBUILD_CFLAGS +=3D -Wno-maybe-uninitialized
  1041 endif

Regards,
Peter

>=20
> -Toke

