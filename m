Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFD96EB846
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 11:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjDVJnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 05:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVJnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 05:43:31 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88A7E58;
        Sat, 22 Apr 2023 02:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
        t=1682156558; i=ps.report@gmx.net;
        bh=QsCBdx8nHvBDP3aG819b7lVVpo4Rb0udMPzn6QUwN44=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=jNOXqtZJ4V6/vpeSYe4AmMbs/qxr04bLrjZwRPKsfPl685fFZ0R0oAk2yJuTb3fhP
         xJBgxoz4imVLjdvVkuuML/pKjrIOQvXjR+e/WoxfqB3UtSObp4xDFWlZkCqVdn/YU0
         oChCInj5yVuhatHvzM++4UzmZXw7tWS3uc06wRezwu4MXc9EhuYZtFJTcS5cdkYe2o
         gEjTXm3LUNlqPltt+lEy3ERRyvhqlmd4IZrPUStnuJBPURPCws2t8M8ivioj+4wq6m
         DEVkxBAkGybF7k2lMPbQTVjR1TgheNOV0naVtCJx5j2I6OIS7V1zdN8N7iavTE+pnC
         is0SjhDcDmeNg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost ([62.216.209.208]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MryT9-1qdDlz1ZkD-00nwDf; Sat, 22
 Apr 2023 11:42:38 +0200
Date:   Sat, 22 Apr 2023 11:42:36 +0200
From:   Peter Seiderer <ps.report@gmx.net>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     linux-wireless@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <toke@toke.dk>, Kalle Valo <kvalo@kernel.org>,
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
Message-ID: <20230422114236.133aa253@gmx.net>
In-Reply-To: <ZEOf7LXAkdLR0yFI@corigine.com>
References: <20230420204316.30475-1-ps.report@gmx.net>
        <ZEOf7LXAkdLR0yFI@corigine.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jK/t3kz+S1y87/qahwOrSjkL1vTQWbgSzaX0+kJ2UFCXpZ9O4sB
 Lwa7jGafrb3t6yUVIrIgNZlbGzlyJjyHZhAUMEVhJDEdrZFlIs+iTpFlOglxJmzNKF3KsnL
 SXLeCwEfLRNC2Y9JuPnZSafDqXW966P1qrLfEdnK3vOves0zsS0TzGGvD17IeEDrggGUUKb
 UHzyXKRgF7vTP/Q+/HMFQ==
UI-OutboundReport: notjunk:1;M01:P0:cZtHvyLybUQ=;8X0l6SRcHY4L6p8s/igb+WGTnKW
 jjX2GKNs1213uBUVbRFmFvyYttVb2nKLZVDoGewqDakpBUhlHPwF20o2/Rn6vKFaTXnty+HL3
 0dZKLQNWSBMQviolKAKSqsJdauHMHVtd+37GlZbCLpUV7so283Rz0wR6ZPfoOKg4yJfmHuC1o
 bLQPqzgs0eDirvgLuyszP2aoGQZmrade3zwu65m1wEBV5heCQ2X2mqwBZCHde+XNk2Us+YY4w
 9JTkjiQMEdSHw9QHZ4WxGtTmvN1G7oGd0WnUWsPStDTA4NuIEVCD9T6fomR/3XOAfcNF7/eKO
 EDe09RIVyp3QtdEIWk7gJ2Z7x83wDJ6d6uILyQSNJPf46DQp/5++nhLnRNs3aWqQs3PQJ/YC0
 oXS5g8W6S9OkSdOp4acpcEpzGgSTcmrFzEcK8fFn8x0XOglBkHzSdf+/Mm213pjfh7WudPwLS
 nvy4ZOyvYCeshZvsrQrzODdf+jMST27EkJBWkyW+PQoDmT9JYAaF+I+QQFqB5AP4+lQM8vN96
 HgyAAr3u4DIP1uZj8yry8O/ddNfhySsMS710HkRjRpES6M0wSe15GGsU9xyx/py0iK//nS7ly
 iwca67HKsboQUqg1saW9qAZ0dlK0sz+Gb7vnQNXy0+R3KsigZCryPqOtEkxEbGn2r74Xb4xue
 0lDzkdxK4UCjftZLcI/xNNqjlP6Yh2fyJUyKSiLQoOUODyE+SB7AdTGZwFY8EyHjQGvyLitDQ
 FnOmusqGtodWrfBwe8SzA5QSjFPKo7jfzcXqVXUiZl0TLdELEA6ZIDLU2LJb0Q8BNNkXyUhiw
 x2z1qQW6e9996CJ4HVJkc4VuVAXHNFvwkNnfE7ZwLu3ifed3e6f1CUNIq/pdp8ZvVxAsmvHXV
 VwGa4VFce8ivPG8PGthdtXiPOPaGJFsLBDL0lOTtjt+gpqiCQl3fL+89N2Gblth94TEbDTWww
 sc46FHDFqa24qlGs3Qwsh2XzXKc=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Simon,

On Sat, 22 Apr 2023 10:50:52 +0200, Simon Horman <simon.horman@corigine.co=
m> wrote:

> On Thu, Apr 20, 2023 at 10:43:16PM +0200, Peter Seiderer wrote:
> > Fix ath9k_hw_verify_hang()/ar9003_hw_detect_mac_hang() register offset
> > calculation (do not overflow the shift for the second register/queues
> > above five, use the register layout described in the comments above
> > ath9k_hw_verify_hang() instead).
> >
> > Fixes: 222e04830ff0 ("ath9k: Fix MAC HW hang check for AR9003")
> >
> > Reported-by: Gregg Wonderly <greggwonderly@seqtechllc.com>
> > Link: https://lore.kernel.org/linux-wireless/E3A9C354-0CB7-420C-ADEF-F=
0177FB722F4@seqtechllc.com/
> > Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> > ---
> > Notes:
> >   - tested with MikroTik R11e-5HnD/Atheros AR9300 Rev:4 (lspci: 168c:0=
033
> >     Qualcomm Atheros AR958x 802.11abgn Wireless Network Adapter (rev 0=
1))
> >     card
> > ---
> >  drivers/net/wireless/ath/ath9k/ar9003_hw.c | 27 ++++++++++++++-------=
-
> >  1 file changed, 18 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/=
wireless/ath/ath9k/ar9003_hw.c
> > index 4f27a9fb1482..0ccf13a35fb4 100644
> > --- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
> > +++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
> > @@ -1099,17 +1099,22 @@ static bool ath9k_hw_verify_hang(struct ath_hw=
 *ah, unsigned int queue)
> >  {
> >  	u32 dma_dbg_chain, dma_dbg_complete;
> >  	u8 dcu_chain_state, dcu_complete_state;
> > +	unsigned int dbg_reg, reg_offset;
> >  	int i;
> >
> > -	for (i =3D 0; i < NUM_STATUS_READS; i++) {
> > -		if (queue < 6)
> > -			dma_dbg_chain =3D REG_READ(ah, AR_DMADBG_4);
> > -		else
> > -			dma_dbg_chain =3D REG_READ(ah, AR_DMADBG_5);
> > +	if (queue < 6) {
> > +		dbg_reg =3D AR_DMADBG_4;
> > +		reg_offset =3D i * 5;
>
> Hi Peter,
>
> unless my eyes are deceiving me, i is not initialised here.
>
> > +	} else {
> > +		dbg_reg =3D AR_DMADBG_5;
> > +		reg_offset =3D (i - 6) * 5;
>
> Or here.

You are absolutely right, it should be queue instead if i here...,
will provide (and test) an updated version of the patch...,
many thanks for review!

Regards,
Peter


>
> > +	}
> >
> > +	for (i =3D 0; i < NUM_STATUS_READS; i++) {
> > +		dma_dbg_chain =3D REG_READ(ah, dbg_reg);
> >  		dma_dbg_complete =3D REG_READ(ah, AR_DMADBG_6);
> >
> > -		dcu_chain_state =3D (dma_dbg_chain >> (5 * queue)) & 0x1f;
> > +		dcu_chain_state =3D (dma_dbg_chain >> reg_offset) & 0x1f;
> >  		dcu_complete_state =3D dma_dbg_complete & 0x3;
> >
> >  		if ((dcu_chain_state !=3D 0x6) || (dcu_complete_state !=3D 0x1))

