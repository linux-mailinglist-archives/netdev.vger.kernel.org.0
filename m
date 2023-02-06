Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D64868C1F4
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 16:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjBFPmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 10:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjBFPmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 10:42:17 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154862DE66
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 07:41:32 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id t19so1251605pfe.2
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 07:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4KjsCerYeEN8ApddjszhvOIPOo0zONsGmUCqqqH1U/c=;
        b=hbUBxN2KxD3E0DUImemyihB3s7OZpoCR7k6q3VuzLrS6BMCmsG1u/b1myeQX+hG9yd
         sNh4tk0h8fuOnqwEBhBj2oWFQ2WFggpRsL79oXH5TRVMDIdHdccb3nUTVXl1vUSkeUre
         Ywd69tdCk3Cdx019hNU69m2VHOgw8jv3AoQZvuyepfTCd7oQjtxC6vuhHl3GS5aLswGA
         xNZoZIzscuMqEKWKy3QYClpFuCjjjmu6OVtNEy6h2INQDpevHZ1FsbKYL5Ps/WSdjYyg
         YTDhfetVv4Q8mxcpaFzzdu/TD7XCCvv8mTWxThb6be6Fpd1wyqL3cVCQ5H7Bn9qHcBL9
         86jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4KjsCerYeEN8ApddjszhvOIPOo0zONsGmUCqqqH1U/c=;
        b=a9zVGljHe8gWTfOoHOKWlIh18f/mZwNM3TmMTELo6+FRQZdZZVb5utNOZuowOCpJVH
         6iw/cPPJdGB78yRu+wYt/cdqi/feVqLA4KG6lnZlYPPoNJguyhbwabJC4rXilDBxkvQB
         u3AXAMJ9CVRYjdc4kMAnpWkllKvGT0+MN8YS3kF/VkFDPbY3ZmYnmJHw76q+DSQ9CgHw
         2gr1GcWGuWIQzJ+HyqfOORdcE/079T6Vh3OUKp57Kj5nxr1FAXCy8jA3dGkZhyKD7sq7
         NH7cCYlSOT++sF0X9yylG+mwfkeNprqB+6ZCPPn/aWh6+Ug3PAthGPj5oSjUgN795FXR
         3KBQ==
X-Gm-Message-State: AO0yUKWiiYKUVPPpMLYuNyjBKC8wuGSwn9DUuQ370rNQljKcJFRESxzI
        f+raEWYYMyAObmOtPwXBbLU=
X-Google-Smtp-Source: AK7set/HuytIDHLsmuBHTohLRVZXSga0gpEbCcNcayiTAf0KVG02qK8s5f9pc32dSdUXJ55CF1m5AQ==
X-Received: by 2002:a62:1c89:0:b0:59c:3fd7:45de with SMTP id c131-20020a621c89000000b0059c3fd745demr6788938pfc.30.1675698045181;
        Mon, 06 Feb 2023 07:40:45 -0800 (PST)
Received: from [192.168.0.128] ([98.97.112.127])
        by smtp.googlemail.com with ESMTPSA id y2-20020a626402000000b0058a7bacd31fsm7306077pfb.32.2023.02.06.07.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 07:40:44 -0800 (PST)
Message-ID: <86b7936aa6c306c61a782950c762fe3124229c51.camel@gmail.com>
Subject: Re: [PATCH net-next v8 4/7] net/mlx5: Kconfig: Make tc offload
 depend on tc skb extension
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Date:   Mon, 06 Feb 2023 07:40:43 -0800
In-Reply-To: <20230205154934.22040-5-paulb@nvidia.com>
References: <20230205154934.22040-1-paulb@nvidia.com>
         <20230205154934.22040-5-paulb@nvidia.com>
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

On Sun, 2023-02-05 at 17:49 +0200, Paul Blakey wrote:
> Tc skb extension is a basic requirement for using tc
> offload to support correct restoration on action miss.
>=20
> Depend on it.
>=20
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/Kconfig     | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 2 --
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     | 2 --
>  3 files changed, 1 insertion(+), 5 deletions(-)
>=20

So one question I had is what about the use of the SKB_EXT check in
mlx5/core/en_tc.h? Seems like you could remove that one as well since
it is wrapped in a check for MLX5_CLS_ACT before the check for
NET_TC_SKB_EXT.
