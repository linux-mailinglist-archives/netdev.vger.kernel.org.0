Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9505A63DBE6
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiK3RZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiK3RZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:25:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D372A96D;
        Wed, 30 Nov 2022 09:25:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A34AC61D01;
        Wed, 30 Nov 2022 17:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DCAC43470;
        Wed, 30 Nov 2022 17:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669829119;
        bh=k16E0rOyzThmr60NjFRq66Y0fdFEqtOV3qSa5Zky12I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dewy+qawKBKEp/FbG18Un0++T0Nih8DV9u8/Tz4t+G5nSS470vLKUvCXguOmnJStn
         l+mmxkWt7l4S0wR4OnzIlJIdhsW8fvIJc0k1IrWEvITXkBa98C5MC3QIr3fytheklM
         5kk3dXQKcMWUhqo4fzVJDBK1BpQyc4K96rsOAqIGRUhJAet0USyu6tecJfcEEljItK
         mK6xOZLcPL2gceMHDxOy3ij/kbsdelEJm3n0ofsRMumOdhbmEvLcOutzSESC4MFisO
         tufty0khGb1g+XXA18TK05EoERLvuIWp24O6DSanDxSTCQp0tgTVKXMhHRGEsR/nae
         y+T93YJ3cm1LA==
Date:   Wed, 30 Nov 2022 09:25:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     zhang.songyi@zte.com.cn, saeedm@nvidia.com, pabeni@redhat.com,
        davem@davemloft.net, edumazet@google.com, mbloch@nvidia.com,
        maorg@nvidia.com, elic@nvidia.com, jerrliu@nvidia.com,
        cmi@nvidia.com, vladbu@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: remove NULL check before dev_{put,
 hold}
Message-ID: <20221130092516.024873db@kernel.org>
In-Reply-To: <Y4cbssiTgsGGNHlh@unreal>
References: <202211301541270908055@zte.com.cn>
        <Y4cbssiTgsGGNHlh@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Nov 2022 11:00:34 +0200 Leon Romanovsky wrote:
> On Wed, Nov 30, 2022 at 03:41:27PM +0800, zhang.songyi@zte.com.cn wrote:
> > From: zhang songyi <zhang.songyi@zte.com.cn>
> > 
> > The call netdev_{put, hold} of dev_{put, hold} will check NULL,
> > so there is no need to check before using dev_{put, hold}.
> > 
> > Fix the following coccicheck warning:
> > /drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:1450:2-10:
> > WARNING:
> > WARNING  NULL check before dev_{put, hold} functions is not needed.
> > 
> > Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)  
> 
> Please change all places in mlx5 in one patch.

Your call as a mlx5 maintainer, but I'd say don't change them at all.
All these trivial patches are such a damn waste of time.
