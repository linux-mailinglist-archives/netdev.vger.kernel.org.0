Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F5B5E9940
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 08:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbiIZGHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 02:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiIZGHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 02:07:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E99CE13
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 23:07:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA772B81675
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 06:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D533C433C1;
        Mon, 26 Sep 2022 06:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664172455;
        bh=WZUlJ87Eqt0kVG1QkrxF2BwoC5H9NHhLMKZFW9UrkOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=USoG+T0oIORcr0c0jiYFBdF/7lUzpb6SNJhC8d2Eh4BwTz/Rv5L7nWX7e7tHdfesR
         OPmIQCo5VK2bebzi/S9vBbcfgMT/FZejtxn1JkES+QSOkSXvzPwNSHO8+p/lKCFYHQ
         77TEK4qyP9yQcgZ9O0/Q2JHUkeXv2Q8Zp3y9xQNwfX9A+Ngi5Vuwpr3fDF7819vfoM
         bl/bMOIN0yL6OUQrC8Do9p9JyVv4ZK/O6L5X0GvOcOFOEOZt61m/RE6EtrlbseITLL
         azAcL6WVNf8tZTSAonKeXx8dcyUCMlEgkNIIK8vMr+a8L6C3bGBBHZdMSKa55JqUi/
         sCDHYzDXjkS5w==
Date:   Mon, 26 Sep 2022 09:07:31 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 7/8] xfrm: add support to HW update soft
 and hard limits
Message-ID: <YzFBozQTGVbmKcwN@unreal>
References: <cover.1662295929.git.leonro@nvidia.com>
 <4d8f2155e79af5a12f6358337bdc0f035f687769.1662295929.git.leonro@nvidia.com>
 <20220925092006.GT2602992@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220925092006.GT2602992@gauss3.secunet.de>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 11:20:06AM +0200, Steffen Klassert wrote:
> On Sun, Sep 04, 2022 at 04:15:41PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Both in RX and TX, the traffic that performs IPsec full offload
> > transformation is accounted by HW. It is needed to properly handle
> > hard limits that require to drop the packet.
> > 
> > It means that XFRM core needs to update internal counters with the one
> > that accounted by the HW, so new callbacks are introduced in this patch.
> > 
> > In case of soft or hard limit is occurred, the driver should call to
> > xfrm_state_check_expire() that will perform key rekeying exactly as
> > done by XFRM core.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> This looks good, thanks!
> 
> We need this for the other relevant counters too.

It is in my backlog.

Thanks
