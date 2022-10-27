Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CDE60EDAA
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 03:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbiJ0B6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 21:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbiJ0B6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 21:58:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79ACC696C
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 18:58:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74A8B60EA0
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 01:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3635C433C1;
        Thu, 27 Oct 2022 01:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666835885;
        bh=sTUvWB1zCXo/kHIUmEerbIULP3sWxWGDRvg/YVh8aJY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mb/+s/EHvVszmMn1S0loAVJA0wp+maKn49LiQWxdB9TJ747WyOFUCHnEXAednwNlp
         7gSKLeWXwV7Ab+69g9N5Gk639dBIxWzUC2C3bsQuLJSkgJd5buiDPgZWaNlQm0EJyC
         GjHAbVqXrikrQ9INVdHeCrzJvaH6NKwp73UrNFhXtyoeUyTOO15y3jfMbevBvqRZdR
         nDoQCaXEFvJT/N1tK2kMbl7btXaRLCPNkpGaK3A3k/UE6ovWlPEDnfalYP9LUVoaBy
         F0IGus4YQR2p6ZX9X+S2b2Vh/D3TN7YwRPVN/Bci7JZmbRaDGnooO+1TOfp+7cmJ1p
         EPZRGN74lO3hw==
Date:   Wed, 26 Oct 2022 18:58:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] xfrm: fix inbound ipv4/udp/esp packets to UDPv6
 dualstack sockets
Message-ID: <20221026185804.0ee5ba1e@kernel.org>
In-Reply-To: <CANP3RGdWDSmvBDsSEWXf+9u_8KQRBzr8NcQCjHB_DPMa83B6PQ@mail.gmail.com>
References: <20221026083203.2214468-1-zenczykowski@gmail.com>
        <CAHo-Ooy5JB-0R5ZNMmEXaPfGjWKBw8VdXVp0d-XW2CNeO6u34A@mail.gmail.com>
        <20221026182426.2173105d@kernel.org>
        <CANP3RGdWDSmvBDsSEWXf+9u_8KQRBzr8NcQCjHB_DPMa83B6PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 10:52:03 +0900 Maciej =C5=BBenczykowski wrote:
> Looking at the Kconfigs/Makefiles, perhaps you have ipv6 as a module?

Yup, allmodconfig, just a note for when you send a v2.

> Why would you do that ;-)

No joke, IMHO it may be time to stop allowing IPV6=3Dm.
