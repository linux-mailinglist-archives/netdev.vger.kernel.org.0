Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF956D6882
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 18:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbjDDQLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 12:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235944AbjDDQLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 12:11:21 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA34F469D;
        Tue,  4 Apr 2023 09:11:19 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x15so31063631pjk.2;
        Tue, 04 Apr 2023 09:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680624679;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CLSNpBLE1zZj2pYIUNEhwYsUjIS5zTtbyz1C7DwdTc8=;
        b=a3wZ8DLBM+5b6x83GzLyseUCS2NaCJ1RHsOkEEJklmRMDa67BWIjsTj3PxWwocGCG7
         6imk0mip5Tzb68Vya/2wPqZ4M4KHcjf2C8i68L9t0PCf7oyoi9kc6HavLVzktZ0jQzip
         TUqAbQFbE3HTVyZK7HKfOPBvOvHdSQVnaH/qSOAi7piFTMOgQE9uK3mO9wmlIgHUklTC
         H2Rjf747c0m9aT0EOyKossmx75acKjl4ngbVW5Y8La6GGy0fI3dfwEM9SyLy5z2LVqbk
         yLbYJHZ9aLe0NgxWtu7dEV/rW0v7XqSQr3YdwSqlrj8jfEVBUdmLPrjTjVrhIORRsvU/
         GCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680624679;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CLSNpBLE1zZj2pYIUNEhwYsUjIS5zTtbyz1C7DwdTc8=;
        b=4Khg+HPVhTp8d9O7kJB1MSIbtcC/I+U5sqw7AdOSzUXAjUhu43wZhXLdfkdCEevmpQ
         exdACCYcgRZQXqkV9QJ0/rULWFMS2zaGtMtdUAVgWjq0TJi1JTuno3dF5FxVEIxHZ6A5
         WrhI0q+/GSGMIgcL88Vvl0LPGBNwozYKEh5RUQfaRlCrhKBnCAqOB/BQM8hnrSdmSMgA
         mt9TZRcFM0TuqOxp6x3eEJXUG/zIasZkuUF9LncRwakBUSRqY50abyU3PAywS/iydCxG
         DqjiGxPVcdrg4salEx5k1XTOVBl6UYX0X2rmFfqKI32WzR4u+28XIqHIiPSnJdqby1ro
         sGIQ==
X-Gm-Message-State: AAQBX9fBcJTDUJhefe2uPZLNO34JV8q+KPQgzLWTvPFheawfWov432j7
        gEFQ4cppQYbjb9t8YOnY2Zw=
X-Google-Smtp-Source: AKy350and3Y73d+IQ7L9nx8YhlsQ1wChDracxJniTYlJXyPMirizEFteA2SQxqK8jX6sKRzSYD/bFA==
X-Received: by 2002:a05:6a20:7a04:b0:e4:9940:d7c9 with SMTP id t4-20020a056a207a0400b000e49940d7c9mr2197897pzh.39.1680624678948;
        Tue, 04 Apr 2023 09:11:18 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.112.205])
        by smtp.googlemail.com with ESMTPSA id 13-20020aa7924d000000b006262520ac59sm8937614pfp.127.2023.04.04.09.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 09:11:18 -0700 (PDT)
Message-ID: <903f658b47d8b02695d9cd7d43b5d9cfb0558490.camel@gmail.com>
Subject: Re: [PATCH net 1/1] net: stmmac: Add queue reset into
 stmmac_xdp_open() function
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 04 Apr 2023 09:11:17 -0700
In-Reply-To: <20230404044823.3226144-1-yoong.siang.song@intel.com>
References: <20230404044823.3226144-1-yoong.siang.song@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-04-04 at 12:48 +0800, Song Yoong Siang wrote:
> Queue reset was moved out from __init_dma_rx_desc_rings() and
> __init_dma_tx_desc_rings() functions. Thus, the driver fails to transmit
> and receive packet after XDP prog setup.
>=20
> This commit adds the missing queue reset into stmmac_xdp_open() function.
>=20
> Fixes: f9ec5723c3db ("net: ethernet: stmicro: stmmac: move queue reset to=
 dedicated functions")
> Cc: <stable@vger.kernel.org> # 6.0+
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_main.c
> index 3e5bbfe3c41b..e4c27eb17bd2 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -6630,6 +6630,8 @@ int stmmac_xdp_open(struct net_device *dev)
>  		goto init_error;
>  	}
> =20
> +	stmmac_reset_queues_param(priv);
> +
>  	/* DMA CSR Channel configuration */
>  	for (chan =3D 0; chan < dma_csr_ch; chan++) {
>  		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

