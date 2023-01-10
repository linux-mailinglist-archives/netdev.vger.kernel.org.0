Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A765666455D
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 16:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238830AbjAJPxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 10:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238789AbjAJPxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 10:53:18 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFAC1649A
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 07:53:17 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v23so12830747pju.3
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 07:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bVFjfNsZmuPR3kWWnUIFSBf0TDujg13fBCdWeu8fHV0=;
        b=cTM2HsiZ1tQsQ9h0qyJE5ZpWhk4+feuxHik7V58cURnigWRUtZQ0I3FgI4IfeZ3x3u
         UH+DAidxLyjG0ENyVix1p8ayqPrfcfVPTqmTD3O68nEN/4skKhVQq3M01A/lUVt4NCZk
         EjCI/zqoQRJUFKT3Du75f9CN7+Qd2GN2GNnEtenAO5e1fz+1S3Ss3pblhxHYuf8fLHgl
         gbsBQ2GJS8jHGCG8DFBbOlatAIBMciXXWKxaEhDO7YVSGFTGF6EEwdkk4VZ97QEp2kNN
         NrpKMh3/57JTrx0KX5FdTP/6necop0AgU35IaKsf6Tg3A2wHwXnx+7me/wHiuvJaa2mA
         CVdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bVFjfNsZmuPR3kWWnUIFSBf0TDujg13fBCdWeu8fHV0=;
        b=FE+//x3xJm+ynEmdv97c/TR8jtscRnT+1fmDKjy4hau//+1tLbVokZwdnOkaHHZnqU
         Xt5ctvNnQKu8Ol3o5rnhSR+G9we5zEpi5NByxLWIzcL73Kr4lU2j6EvWOhMq7xcdT8nu
         GWx6QBi6tSU/LC4tINSqsTYxqNRjOtgj7qjrDVm70RRgiMk7zWzTrS1uUmgC9OYvjd+m
         sZQu0uC3cnWDkgbidURtPr2wbrZwIipbQcr03BtvClIg33cAC6njmOQe01kKlHyUJZ0T
         7jUPBl9qsGbTsUTuzYB5ao/IHxrlTNnqLhison6/qrMB756KS1/GE8kQi02DZcPhT7kn
         as3g==
X-Gm-Message-State: AFqh2kps3yU6PxRZKUNXi1YjGeSbC343vxiZawTIszdAb2dryhr28afU
        VfFy9wraM9LtEyez5To5fKY=
X-Google-Smtp-Source: AMrXdXspkgPwbgQ+GcQB4yV/bBBa2+71FJyY8iX1M8yV3b52lfWOWE1T7dPtJU1VoqSCPa0t7x2UeQ==
X-Received: by 2002:a17:90b:2291:b0:226:3b78:36ab with SMTP id kx17-20020a17090b229100b002263b7836abmr41183538pjb.3.1673365997336;
        Tue, 10 Jan 2023 07:53:17 -0800 (PST)
Received: from [192.168.0.128] ([98.97.37.136])
        by smtp.googlemail.com with ESMTPSA id em6-20020a17090b014600b00223ffe2ba61sm7459985pjb.15.2023.01.10.07.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 07:53:16 -0800 (PST)
Message-ID: <6ef7979d1617b669e792154c32a5f7bf8fe1682d.camel@gmail.com>
Subject: Re: [PATCH net-next v4 03/10] tsnep: Do not print DMA mapping error
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Date:   Tue, 10 Jan 2023 07:53:16 -0800
In-Reply-To: <20230109191523.12070-4-gerhard@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
         <20230109191523.12070-4-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
> Printing in data path shall be avoided. DMA mapping error is already
> counted in stats so printing is not necessary.
>=20
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep_main.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/eth=
ernet/engleder/tsnep_main.c
> index d148ba422b8c..8c6d6e210494 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -469,8 +469,6 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_bu=
ff *skb,
> =20
>  		spin_unlock_bh(&tx->lock);
> =20
> -		netdev_err(tx->adapter->netdev, "TX DMA map failed\n");
> -
>  		return NETDEV_TX_OK;
>  	}
>  	length =3D retval;

It might be nice to add a stat to indicate that this is specifically a
mapping error rather than just incrementing dropped but that could also
be done in a future patch.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
