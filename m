Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DF66E7079
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 02:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbjDSAgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 20:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjDSAgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 20:36:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9C2186
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 17:36:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 553F963816
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 00:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2EDC433D2;
        Wed, 19 Apr 2023 00:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681864564;
        bh=GfXY00xd70B+f0KQcitarcE8kCo7zK6ckYyc4CMFciw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mw5lDhp2PRM8J14BO6hdGX+1J0xeJc0zF/5E5qFKaZNAV6Bek2fNZs0yPdD5Nqntu
         c0lZaG7FhjiPbalqmQrOh+dWUaMKl4dFyPWEO7Q3npIfoyoefwvnZrXBCjQCrY5Wmo
         a0VODTtYsbjO+2lnVCpzWnu3DSRc6OSNcQBrwaVZBO2oPC3JSlR95rYQcYsVyMVJvU
         Uwo//+AM20sBcQtHAW6aKcxtcInxUkLn0GQ9aDnSwTVg3emTD348yZhw+0acpBsLDG
         RrL9MQ/iLHlQ8IK3WlJEMd/Z5TBgP6sHuucDrgjhUBOKqPq64fPIbW0kHp2UnBvuvu
         3rXxqml3UsZ/w==
Date:   Tue, 18 Apr 2023 17:36:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <sd@queasysnail.net>, <netdev@vger.kernel.org>, <leon@kernel.org>
Subject: Re: [PATCH net-next v6 3/5] net/mlx5: Support MACsec over VLAN
Message-ID: <20230418173603.5b41e2e0@kernel.org>
In-Reply-To: <20230418083102.14326-4-ehakim@nvidia.com>
References: <20230418083102.14326-1-ehakim@nvidia.com>
        <20230418083102.14326-4-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Apr 2023 11:31:00 +0300 Emeel Hakim wrote:
> +static inline struct mlx5e_priv *macsec_netdev_priv(const struct net_device *dev)

Does the compiler really not inline this without the explicit inline
keyword?

> +{
> +#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)

That's what IS_ENABLED() is for

> +	if (is_vlan_dev(dev))
> +		return netdev_priv(vlan_dev_priv(dev)->real_dev);
> +#endif
> +	return netdev_priv(dev);
> +}

--
pw-bot: cr

