Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECE85EAE27
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 19:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiIZRZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 13:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiIZRYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 13:24:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CA5140F32
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 09:40:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22BA161022
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 16:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BEFC433C1;
        Mon, 26 Sep 2022 16:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664210451;
        bh=L1sC6caZUSqfyQY4AF3lbmkTNrXE5Nlwf4sqcu4J5N4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mYwrNBM4LTiJRxW5yyzzExkMx2YWGx0o/pVi7JNQsfuH+DjisIGNECPJnLyKHJTRi
         9IlVfxgRifQLH6rBaR/F0OsQ1owMxems8vFN+/8mtQSukOT4oMdVPEjdjUlk5eulf5
         v3dQH9tJFZakiWse02E8RTgU8QlsUS/lHiW+5ITWZ9u9DN9iJcB15WEtoDhSQQPCzs
         4ep9hH9d6scpvygcdSO3eJdgVvc7bIrSHtHVyDzm3JTruC2FQYNZ7OozLtSWh6X426
         a4UmoK1Afv07Amvz4urqHCaMFyhtnwTNrvtJLuyIHUQHSRtVEBdlQZrbSlvlMb+WyX
         RSkW6+Yr9UNAA==
Date:   Mon, 26 Sep 2022 09:40:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raed Salem <raeds@nvidia.com>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next] macsec: don't free NULL metadata_dst
Message-ID: <20220926094050.30a4fe59@kernel.org>
In-Reply-To: <DM4PR12MB5357EB2AF3F1AA4184DBF7B2C9539@DM4PR12MB5357.namprd12.prod.outlook.com>
References: <60f2a1965fe553e2cade9472407d0fafff8de8ce.1663923580.git.sd@queasysnail.net>
        <DM4PR12MB5357EB2AF3F1AA4184DBF7B2C9539@DM4PR12MB5357.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 25 Sep 2022 07:29:36 +0000 Raed Salem wrote:
> >Commit 0a28bfd4971f added a metadata_dst to each tx_sc, but that's only
> >allocated when macsec_add_dev has run, which happens after device
> >registration. If the requested or computed SCI already exists, or if linking to
> >the lower device fails, we will panic because metadata_dst_free can't handle
> >NULL.
> >
> >Reproducer:
> >    ip link add link $lower type macsec
> >    ip link add link $lower type macsec
> >
> >Fixes: 0a28bfd4971f ("net/macsec: Add MACsec skb_metadata_dst Tx Data
> >path support")
> >Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> 
> Acked by me

Thanks a lot for the review! Please prefer the full:

Acked-by: Raed Salem <raeds@nvidia.com>

format in the future, this way it will be picked up by the automation.
