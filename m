Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A6C60534A
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiJSWoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJSWo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:44:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA5C25E1
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 15:44:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 179DD619C2
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 22:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06504C433C1;
        Wed, 19 Oct 2022 22:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666219461;
        bh=DEQVncjl7ccQ5RwZ9RHKdQqCAk9LSiNde965NC095TU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p1xFarunbxxsZ4zWMXhk1Zt5JwVIWwwoFMxgRqvYzZEgaRpfYdupyrSZXPKpGVfb2
         HmdWgkbT+fV1+V6WpGS4OAeV5/JI60O48jYzA1yal67eFotuhjeGGZZRHcyVeuK/yw
         UkkwawZhJE/uTfBL8VTgyugd69xaLxIfldgvehSV4TvGjLquv59gp936ep2BgrwA/p
         ntyvC5hFn4kyTbVHQ7Es6rMoUe6X+4A3ls+/jdIZBZxLRFh9FVp+O6BtEjcWcHtUDB
         s3trPuen+gKb0gYHtkqmWccu9Y5goP1d2aqY8q0KVdadJEW0R/JmaLhQKDHMGVPETP
         zZ67c6N6rn4cw==
Date:   Wed, 19 Oct 2022 15:44:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH RESEND net] net/mlx5e: Cleanup MACsec uninitialization
 routine
Message-ID: <20221019154420.0274374a@kernel.org>
In-Reply-To: <4bd5c6655c5970ac30adb254a1f09f4f5e992158.1666159448.git.leonro@nvidia.com>
References: <4bd5c6655c5970ac30adb254a1f09f4f5e992158.1666159448.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 09:06:43 +0300 Leon Romanovsky wrote:
> The mlx5e_macsec_cleanup() routine has pointer dereferencing if mlx5 device
                                        ^
                                NULL? _/

> doesn't support MACsec (priv->macsec will be NULL) together with useless

s/together with/. While at it delete/

> comment line, assignment and extra blank lines.
