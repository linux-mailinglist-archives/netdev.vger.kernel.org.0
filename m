Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C200965E759
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbjAEJHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbjAEJH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:07:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EA93B931
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:07:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6393FB81202
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 09:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F3FC433D2;
        Thu,  5 Jan 2023 09:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672909646;
        bh=OmRn7Jw++msHulWjytxe3rhKKf2HAIfKbn4SB0cyM0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mK6P3wklWnj91nfDVPnNAalobwuH8/BUVKNGOSSTKc1lmZhYxr1xN2v7abRMIzEqI
         zxSizzv6YkK3+NMEI7veKx8M8erEONAUVpDDbkcpfmrcT1rUoJUJVTipz4c3DV3o6I
         DjlFq3b2brLwxsS6U+ujR69q6o0N2LTJXrvlRKlmrdvchZFsuyvm3s2ONTHHvizKwP
         zyLRAgRdBro+x2SnEQMNx0X9t1Su/gI2R0PtwKukl2nlrXDkmYNvgEiKgu+Ns3z0l6
         9iDkfDNkdClp6ogFy703/lHWuSSVQIU3ANPGpvLdipSYS6ScmwYTxLlhw9tZIdmYlU
         2RYD69LGxZCkg==
Date:   Thu, 5 Jan 2023 11:07:22 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com
Subject: Re: [PATCH v2 net-next 3/3] net: ethernet: enetc: do not always
 access skb_shared_info in the XDP path
Message-ID: <Y7aTSlLNb7Fa+a62@unreal>
References: <cover.1672840490.git.lorenzo@kernel.org>
 <8a8d98a84ae48629564e2fb09c4a378bb0a18b1c.1672840490.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a8d98a84ae48629564e2fb09c4a378bb0a18b1c.1672840490.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 02:57:12PM +0100, Lorenzo Bianconi wrote:
> Move XDP skb_shared_info structure initialization in from
> enetc_map_rx_buff_to_xdp() to enetc_add_rx_buff_to_xdp() and do not always
> access skb_shared_info in the xdp_buff/xdp_frame since it is located in a
> different cacheline with respect to hard_start and data xdp pointers.
> Rely on XDP_FLAGS_HAS_FRAGS flag to check if it really necessary to access
> non-linear part of the xdp_buff/xdp_frame.
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
