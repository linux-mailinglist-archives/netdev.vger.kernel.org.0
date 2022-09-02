Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8665AAC88
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 12:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbiIBKf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 06:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235910AbiIBKfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 06:35:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF932DF7A;
        Fri,  2 Sep 2022 03:35:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2443261FEE;
        Fri,  2 Sep 2022 10:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07E7C433C1;
        Fri,  2 Sep 2022 10:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662114907;
        bh=1xr+tD3UEq9EhbT6zfYwZjUnCwTrRwLZVOlJ4WPB244=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o8lfskd/K3x2DZVa1RjQuJRF3U1IJh+pL1btht+6nJhDAExrbXKhgbPsqPUPzuPdS
         OK4EHzINabp4M5wsLYXdPNAvMd5Q8dhxgAHc4/7H/9ZHk964k3fc5TIb1M4kKM9Phm
         aR49ow3vRhvC7HgsM7sxQHxdNf3IKR5nA41F0cbigIzmpTH2DzYBCu7pkTFObubq/O
         9qI+V4Mffx0lRieGaNkQHndaYuiaNuunjMDRfOiEhhepcgqV+AakC1s1YI3LG/fLb+
         geQqEfhVWObpk9rhenX+4ujXkGxE61MSz1sD93ZMO3hpTwVK7tZwAUPsNqO/ItB75L
         Ym+Y9CIEntdPA==
Date:   Fri, 2 Sep 2022 13:35:02 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Message-ID: <YxHcVohjMlgyC8TF@unreal>
References: <20220830231330.1c618258@kernel.org>
 <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com>
 <20220830233124.2770ffc2@kernel.org>
 <20220831112150.36e503bd@kernel.org>
 <36f09967-b211-ef48-7360-b6dedfda73e3@datenfreihafen.org>
 <20220831140947.7e8d06ee@kernel.org>
 <YxBTaxMmHKiLjcCo@unreal>
 <20220901132338.2953518c@kernel.org>
 <CAK-6q+gtcDVCGB0KvhMjQ-WotWuyL7mpw99-36j_TcC7mc2qyA@mail.gmail.com>
 <20220901200012.6f04466e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901200012.6f04466e@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 08:00:12PM -0700, Jakub Kicinski wrote:
> On Thu, 1 Sep 2022 22:48:10 -0400 Alexander Aring wrote:
> > > You're right, FWIW. I didn't want to get sidetracked into that before
> > > we fix the immediate build issue. It's not the only family playing uAPI
> > > games :(
> > 
> > I am not sure how to proceed here now, if removing the
> > CONFIG_IEEE802154_NL802154_EXPERIMENTAL option is the way to go. Then
> > do it?
> 
> Right, I was kinda expecting v2 from Gal but the weekend may have
> started for him already, so let me send it myself.

We didn't know how v2 should look like and waited for some sort of
resolution.

Thanks
