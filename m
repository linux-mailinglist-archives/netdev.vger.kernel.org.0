Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0498252531E
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356771AbiELRBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356825AbiELRBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:01:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC3737A3F
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:01:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6396B82A07
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 17:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122B0C34117;
        Thu, 12 May 2022 17:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652374868;
        bh=UsRakaNz3MAkZWp4O2jURixUUy0FIUv4SEVyIf1z0VE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rs+GvXBMOG5TS3BPA3SXvEIKFuFH4pG0AD/yDjAwDMVQ4EfV5tvHgK3WjC5ON7Hbf
         sJReN1eZbieTae0UTjVux6e6OyjtnixmxP+xealLICGJBtpt7WAM52ZJud75AUmlq7
         xfgruE/w5c1kJLLkO2CFk3+fLZkqkmEPRBwtolofAYvUmZkC+ZX/y0NiaTB3sl9xMD
         k+q19sA644Ysu02gjAPN53br8Ia7x0ZlyMQRaCnXw38zeWbw0RPxliZ922JBTp9v+h
         7IbRanVpRhEI7NN+HeCD3pT5B3UL3priFMolPYSebfubPYnX9Fzs3XqrnEksn7MdAK
         b2uuVYXpAKuPQ==
Date:   Thu, 12 May 2022 10:01:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        amaftei@solarflare.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Tianhao Zhao <tizhao@redhat.com>
Subject: Re: [PATCH net 1/2] sfc: fix wrong tx channel offset with
 efx_separate_tx_channels
Message-ID: <20220512100106.15bb15d6@kernel.org>
In-Reply-To: <20220511125941.55812-2-ihuguet@redhat.com>
References: <20220511125941.55812-1-ihuguet@redhat.com>
        <20220511125941.55812-2-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 14:59:40 +0200 =C3=8D=C3=B1igo Huguet wrote:
>  	if (efx_separate_tx_channels) {
> -		efx->n_tx_channels =3D
> -			min(max(n_channels / 2, 1U),
> -			    efx->max_tx_channels);
> -		efx->tx_channel_offset =3D
> -			n_channels - efx->n_tx_channels;
> -		efx->n_rx_channels =3D
> -			max(n_channels -
> -			    efx->n_tx_channels, 1U);
> +		efx->n_tx_channels =3D min(max(n_channels / 2, 1U), efx->max_tx_channe=
ls);
> +		efx->tx_channel_offset =3D n_channels - efx->n_tx_channels;
> +		efx->n_rx_channels =3D max(n_channels - efx->n_tx_channels, 1U);

No whitespace cleanups in fixes, please.

Besides, I still prefer to stay under 80 chars.
