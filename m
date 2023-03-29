Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191706CF239
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjC2Shq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjC2Shp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:37:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867B04697
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:37:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07D1B61DEA
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 18:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1F2C433D2;
        Wed, 29 Mar 2023 18:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680115057;
        bh=pH1yedddVGto4VYcLj4sXdOJyRHHZXgU6gYcxOpacIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kw5665AckD4m48qr9ZSPc5ZN4fndTc2u1SPeItidNYTos9zLBhZUDQeK6LjKGpE9k
         8yxI8KD6yd2TJvyjeH/Q6Hraj7S+Fc85Y3GF7fghfWsHY9Kg/Y5UIZ2euWTUO7eFGI
         6CpE0ur1vgzEp9AfwJT82rKezHt53afhHJEic7jr/jZYxGvb5MwZiXdKXtEnBDC3Km
         V022fkvBo67FCGve8mHmHgNtLKaufvnGDkOmgLjo4E52MZmlCutDFOeC2Bqn16+PXr
         cs8zY0/B/sswKDtESoS4d/UZen6JprGP9YrR8n/VfY5sulYiQusGjq83dqcPna+JHO
         TNmoWAAC4iTCg==
Date:   Wed, 29 Mar 2023 21:37:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, sd@queasysnail.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] Support MACsec VLAN
Message-ID: <20230329183732.GA831478@unreal>
References: <20230329122107.22658-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329122107.22658-1-ehakim@nvidia.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 03:21:03PM +0300, Emeel Hakim wrote:
> Dear maintainers,
> 
> This patch series introduces support for hardware (HW) offload MACsec
> devices with VLAN configuration. The patches address both scenarios
> where the VLAN header is both the inner and outer header for MACsec.
> 
> The changes include:
> 
> 1. Adding MACsec offload operation for VLAN.
> 2. Considering VLAN when accessing MACsec net device.
> 3. Currently offloading MACsec when it's configured over VLAN with
> current MACsec TX steering rules would wrongly insert the MACsec sec tag
> after inserting the VLAN header. This resulted in an ETHERNET | SECTAG |
> VLAN packet when ETHERNET | VLAN | SECTAG is configured. The patche
> handles this issue when configuring steering rules.
> 4. Adding MACsec rx_handler change support in case of a marked skb and a
> mismatch on the dst MAC address.
> 
> Please review these changes and let me know if you have any feedback or
> concerns.
> 
> Updates since v1:
> - Consult vlan_features when adding NETIF_F_HW_MACSEC.
> - Allow grep for the functions.
> - Add helper function to get the macsec operation to allow the compiler
>   to make some choice.

Please mark all your patches as vXXX and not only one.

Thanks
