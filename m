Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCAA6CA989
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 17:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbjC0PtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 11:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbjC0Psz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 11:48:55 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314302D4F
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 08:48:46 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-17aceccdcf6so9701160fac.9
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 08:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1679932125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2WzWdOkMmL2ARZAHaRbWQlIl6UiNK21f4bsUfN4KyZY=;
        b=VpFwKQAVABRwmNJgaoe+ZTR83STLlnjEhrdFpEKM29g9f4o+3btJik1wwF0fKc9B8f
         w3Nzb3/FG+bcXTZ3ZRj06jh4iGr2zJxkpBka/3zkoRfwMUgEwhZinkE7FzjjKvHNqKIl
         9QLSG/qW3zdkfuq6q4FN4zR0IDqtKOWQz4V0zSXhLM7MYFenZIO/ecd3xjhFH/a3kz6P
         1hobJIuhYiIyX/mA4X7/bO1T+K7FPnGql/2RLqP4ckzYulh+inVG6RdXGD6NnfLZ0aCh
         WjYATYDWWE9VmOGVGhIXYzmCojp49cxEhgNW7wS4lXFBliiVsORmMquWM+ZYYLFidjOF
         7izw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679932125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2WzWdOkMmL2ARZAHaRbWQlIl6UiNK21f4bsUfN4KyZY=;
        b=eYWcPTWgGq+M2U5OcBoDNR3WihPbyM04km2sqYV93YzRHr8bWGjXiZEYYJ+FNORKwS
         sSAUBnAJwQvJCmAaHqrlX+neindactjvQzipw9+p63GDWd6yv1hePownpdJuV4RTN2zg
         tU3bmkz6jCGAc6a26Z+YYiy2JBX1mDvGe/NTj/ndBIGST5YuF631HSKX/1PKSPMDRBrH
         oQIuZGoYtjDyj0Etn+wH2wxyFRWhGqpj8wtZdlGSI5Xx6gjf/WNpsqBa6Jbedp8p7EiV
         d0xIfsO/TfvI0ZquLN2/5Sd1CmnHTj+/jv7q21drcLNAXmYKN7rk4HUzXZZZe0PwMx03
         d/Jw==
X-Gm-Message-State: AAQBX9ew3AU0e13ovzbB9wXIa9FSDmj6LzFMqAAr5S1HRcfc0bviVUs4
        /XExQtMrSeS8Gkc4AswwnIML07TeFkqFhE0ai1FwOw==
X-Google-Smtp-Source: AKy350YOtQd3L3jqYZ91D82c2xngjlihzvj3uKYmL7/+HfkKqyJaBRnbpDWpA8i7z/TiIo/QfkIZ2sJKvftQcvxWtds=
X-Received: by 2002:a05:687c:10b:b0:177:b393:4007 with SMTP id
 ym11-20020a05687c010b00b00177b3934007mr3846656oab.0.1679932125169; Mon, 27
 Mar 2023 08:48:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230325164053.hiwjuxksscjm3ov4@Svens-MacBookPro.local>
In-Reply-To: <20230325164053.hiwjuxksscjm3ov4@Svens-MacBookPro.local>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Mon, 27 Mar 2023 17:48:33 +0200
Message-ID: <CAPv3WKcmQezyvUY8T1y=wRNn-w_0fMqgzU3+GoQMHRXNM_MXNA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] net: mvpp2: parser fix QinQ
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, maxime.chevallier@bootlin.com,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sob., 25 mar 2023 o 17:40 Sven Auhagen <sven.auhagen@voleatech.de> napisa=
=C5=82(a):
>
> The mvpp2 parser entry for QinQ has the inner and outer VLAN
> in the wrong order.
> Fix the problem by swapping them.
>
> Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 net=
work unit")
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> ---
>
> Change from v2:
>         * Formal fixes
>
> Change from v1:
>         * Added the fixes tag
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net=
/ethernet/marvell/mvpp2/mvpp2_prs.c
> index 75ba57bd1d46..ed8be396428b 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
> @@ -1539,8 +1539,8 @@ static int mvpp2_prs_vlan_init(struct platform_devi=
ce *pdev, struct mvpp2 *priv)
>         if (!priv->prs_double_vlans)
>                 return -ENOMEM;
>
> -       /* Double VLAN: 0x8100, 0x88A8 */
> -       err =3D mvpp2_prs_double_vlan_add(priv, ETH_P_8021Q, ETH_P_8021AD=
,
> +       /* Double VLAN: 0x88A8, 0x8100 */
> +       err =3D mvpp2_prs_double_vlan_add(priv, ETH_P_8021AD, ETH_P_8021Q=
,
>                                         MVPP2_PRS_PORT_MASK);
>         if (err)
>                 return err;
> --
> 2.33.1
>

Reviewed-by: Marcin Wojtas <mw@semihalf.com>

Thanks,
Marcin
