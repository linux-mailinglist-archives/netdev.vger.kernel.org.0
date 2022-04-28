Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A0D512F37
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 11:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344866AbiD1JDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 05:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344131AbiD1JDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 05:03:31 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D826409
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 02:00:11 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id w1so7418243lfa.4
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 02:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oiTdf/uwqWhjAqTpT5s33WNiE/M284X4HsQy39pCwgQ=;
        b=t3LNDtppMEZgxAJ0j3saSKEduuSUMjq4tZUVjKYaGGLHhZpW39FsMCqFirIl17KGTR
         7yK/J3NgR5o8Lx8UgIxBgINheMvxmR9OdccSOUXoHa2IiqsVFnCJaJlIHYLr6gznHAc7
         46U6IAFIMjoUQyXcN5t/dZvI1wP9YBn6/qe8QP5kRbOJyydLILSjGDA8Q2pWZsKcmLlV
         dx6DeMYfGff3W5c8AcUXri0C9BsUGKji3+epfIJxFouSFUEbzwKepglXoolBUFaZ1RsJ
         +2gkYyuzU904veXse5hhQojWZl1jZF5x/3qBQM/+iUn/0c4nIx3eo1WmKqd82dZa32OI
         W3gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oiTdf/uwqWhjAqTpT5s33WNiE/M284X4HsQy39pCwgQ=;
        b=xzbVHRjJtYTaJeaG2gKpnoPtHqR9JBFLrInkiDL7h/J4GU9mREGFL21H4KyPS2j2NQ
         gixreEO8XuLN+aNohGPG6frT/99A9PluTJFMGMPFy6xinkEvjSilCWfd38PJCEJmo7zq
         yiqVECBPINkqCG8l2UGV6GCgHEdBSreHpUxLACH2A8wFB+H8hMn+Il5xlHC39hSxB53P
         76uRbZC4/vNUo25ULvjs7FFkSduoGeNdJ1yte069n/YFY0vV/lNHwxivGllKYTHeawBe
         /AlSDPhTrlcKfXD1TFkehnwQBQ+8/lg3wbSX2zGixmLd7kYk1rNkVWRfk5jh5YV/DFIL
         PhxA==
X-Gm-Message-State: AOAM530CAeISUhLed5V3todbxA2zStE+q65Wn8bTvt4vFSnS9qqziqvd
        phIbyz6dLlaHEYs0tpjH8G2NviR6Fpd4c1WaexT6Og==
X-Google-Smtp-Source: ABdhPJzohtHXH0P9UcdveWGgKa5SrJYQje56sBeUGPCsNznjYIY4+0YKE5Yb0lPGDds5+q+6pFyBgSR6hZ8PwZsaRnw=
X-Received: by 2002:a05:6512:321c:b0:46b:b7fd:1eca with SMTP id
 d28-20020a056512321c00b0046bb7fd1ecamr10317924lfe.481.1651136409470; Thu, 28
 Apr 2022 02:00:09 -0700 (PDT)
MIME-Version: 1.0
References: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
In-Reply-To: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 28 Apr 2022 10:59:59 +0200
Message-ID: <CAPv3WKf5dnOrzkm6uaFYHkuZZ2ANrr3PMNrUhU5SV6TFAJE2Qw@mail.gmail.com>
Subject: Re: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Baruch Siach <baruch.siach@siklu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Baruch,

=C5=9Br., 27 kwi 2022 o 17:05 Baruch Siach <baruch@tkos.co.il> napisa=C5=82=
(a):
>
> From: Baruch Siach <baruch.siach@siklu.com>
>
> Without this delay PHY mode switch from XLG to SGMII fails in a weird
> way. Rx side works. However, Tx appears to work as far as the MAC is
> concerned, but packets don't show up on the wire.
>
> Tested with Marvell 10G 88X3310 PHY.
>
> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
> ---
>
> Not sure this is the right fix. Let me know if you have any better
> suggestion for me to test.
>
> The same issue and fix reproduce with both v5.18-rc4 and v5.10.110.
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index 1a835b48791b..8823efe396b1 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6432,6 +6432,8 @@ static int mvpp2_mac_prepare(struct phylink_config =
*config, unsigned int mode,
>                 }
>         }
>
> +       mdelay(10);
> +
>         return 0;
>  }
>

Thank you for the patch and debug effort, however at first glance it
seems that adding delay may be a work-around and cover an actual root
cause (maybe Russell will have more input here).

Can you share exact reproduction steps?

Best regards,
Marcin
