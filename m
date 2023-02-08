Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDB468F78C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 19:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjBHS51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 13:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjBHS50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 13:57:26 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0433244A9;
        Wed,  8 Feb 2023 10:57:25 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id be8so20396796plb.7;
        Wed, 08 Feb 2023 10:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j3gXZ1TblZrGsoecGG9XeywAEV6+Fe6bvuuVedUahH8=;
        b=CbuxyoapQWbPUt7ePWLhcFTwPS2doETLWNp2qiwx70MznD3yTy9saa790VO9PQy1nc
         xeEN43TDA9yRMc2xe6ojUqrDhXj/hnqvJGYaRAtdbBaQ8pyISKWxlMMIFxFHkqyEIaqG
         Jq3e8O6tj29G/t+ljp4cLLrPObbjqOqzwAF912XaQ8W9Z4kWg/UIlpdvl2ggco3Zsj2b
         X0Bn5rIWAhpT8WX1YGP7Ev7+B0U9gGCrRRDOsLsxRrGH4/f45Mq8u7X0O68btRm+KB1W
         8ysZgt8JUXG6G8NS+rFqr/bDrnOBrbQ60EeKqYfGaK8vQaTqUR6qrjASsoVmab1CbaMo
         ycXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j3gXZ1TblZrGsoecGG9XeywAEV6+Fe6bvuuVedUahH8=;
        b=ZN0lTeIf3tO1eA0KPvbt2GjT+NNC3Srz9BdGL4AWXrEnVEXcSMssPcHPQjhXqzLJ9m
         xB+1EJr8WD8qpamGy+efBuJ+Rp0TJVnmiowT+K6pIcsG6bFDWwVslG56clZqqsaeGhiP
         kkp28ZYsStl30LInZ4Etfhdj/daO8Bc2/U1310cfwDiyxJbjviQaUQH0dc4bgmk5pWYY
         L6dKehGNQ2VvONW8XGdiooY4hYPjvFVTyXHxEyE47xyaHPNNwM2UWCojaWYlsgPUd7mu
         lW7u9nAlSy6YP1tYxHls/sVnCILSzSZ3AZ5DYoN0jLuh1bftRKgb4VVhxtj9m4AFwjTn
         ZuEA==
X-Gm-Message-State: AO0yUKW22Tezv+amPGWlk0Seq1Z5wG8iUz1GuUsvqQdr5/momiFaoCiE
        CfyZWKs7S6NGEhzlvBEZo3s=
X-Google-Smtp-Source: AK7set/JEdwxTmR+vM4phCpUX0I7186qDKLwYZqemcSS8n3IUs9nhVfnZaIAoMSGhK7Kzg70DyYy+w==
X-Received: by 2002:a17:902:f541:b0:199:4fb1:f543 with SMTP id h1-20020a170902f54100b001994fb1f543mr2502399plf.57.1675882644992;
        Wed, 08 Feb 2023 10:57:24 -0800 (PST)
Received: from [192.168.0.128] ([98.97.119.54])
        by smtp.googlemail.com with ESMTPSA id i5-20020a170902eb4500b00199204c94c9sm5864597pli.57.2023.02.08.10.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:57:24 -0800 (PST)
Message-ID: <6ded592b01ba223bce241d6ff3073246cb5dd18b.camel@gmail.com>
Subject: Re: [PATCH net v4 1/3] ixgbe: allow to increase MTU to 3K with XDP
 enabled
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Jason Xing <kerneljasonxing@gmail.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Date:   Wed, 08 Feb 2023 10:57:22 -0800
In-Reply-To: <Y+PNjcrSxKc0vD3s@boxer>
References: <20230208024333.10465-1-kerneljasonxing@gmail.com>
         <2bfcd7d92a6971416f58d9aac6e74840d5ae240a.camel@gmail.com>
         <Y+PNjcrSxKc0vD3s@boxer>
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

On Wed, 2023-02-08 at 17:27 +0100, Maciej Fijalkowski wrote:
> On Wed, Feb 08, 2023 at 07:37:57AM -0800, Alexander H Duyck wrote:
> > On Wed, 2023-02-08 at 10:43 +0800, Jason Xing wrote:
> > > From: Jason Xing <kernelxing@tencent.com>
> > >=20
> > > Recently I encountered one case where I cannot increase the MTU size
> > > directly from 1500 to a much bigger value with XDP enabled if the
> > > server is equipped with IXGBE card, which happened on thousands of
> > > servers in production environment. After appling the current patch,
> > > we can set the maximum MTU size to 3K.
> > >=20
> > > This patch follows the behavior of changing MTU as i40e/ice does.
> > >=20
> > > Referrences:
> > > [1] commit 23b44513c3e6 ("ice: allow 3k MTU for XDP")
> > > [2] commit 0c8493d90b6b ("i40e: add XDP support for pass and drop act=
ions")
> > >=20
> > > Fixes: fabf1bce103a ("ixgbe: Prevent unsupported configurations with =
XDP")
> > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> >=20
> > This is based on the broken premise that w/ XDP we are using a 4K page.
> > The ixgbe driver isn't using page pool and is therefore running on
> > different limitations. The ixgbe driver is only using 2K slices of the
> > 4K page. In addition that is reduced to 1.5K to allow for headroom and
> > the shared info in the buffer.
> >=20
> > Currently the only way a 3K buffer would work is if FCoE is enabled and
> > in that case the driver is using order 1 pages and still using the
> > split buffer approach.
>=20
> Hey Alex, interesting, we based this on the following logic from
> ixgbe_set_rx_buffer_len() I guess:
>=20
> #if (PAGE_SIZE < 8192)
> 		if (adapter->flags2 & IXGBE_FLAG2_RSC_ENABLED)
> 			set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
>=20
> 		if (IXGBE_2K_TOO_SMALL_WITH_PADDING ||
> 		    (max_frame > (ETH_FRAME_LEN + ETH_FCS_LEN)))
> 			set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
> #endif
>=20
> so we assumed that ixgbe is no different than i40e/ice in these terms, bu=
t
> we ignored whole overhead of LRO/RSC that ixgbe carries.

If XDP is already enabled the LRO/RSC cannot be enabled. I think that
is already disabled if we have XDP enabled.

> I am not actively working with ixgbe but I know that you were the main de=
v
> of it, so without premature dive into the datasheet and codebase, are you
> really sure that 3k mtu for XDP is a no go?

I think I mixed up fm10k and ixgbe, either that or I was thinking of
the legacy setup. They all kind of blur together as I had worked on
pretty much all the Intel drivers up to i40e the last time I was
updating them for all the Rx path stuff. :)

So if I am reading things right the issue is that if XDP is enabled you
cannot set a 3K MTU, but if you set the 3K MTU first then you can
enable XDP after the fact right?

Looking it over again after re-reading the code this looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>





