Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0CD51019F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352049AbiDZPPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352527AbiDZPOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:14:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3D3159482;
        Tue, 26 Apr 2022 08:09:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 597DF618F7;
        Tue, 26 Apr 2022 15:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F3AC385A0;
        Tue, 26 Apr 2022 15:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650985794;
        bh=ETaJUv7P/rGpy+MmZXEjTLEuck6SMxqcHJ63Z3uDugk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rVAsSizpKSh0hgTFP2ZqxDw/bk38ROmihs47bEQbs6h9wiELx+Kb3zzTAKxQORbRU
         FjpA902GrmPhQeWY4Au62pb6vN1FXHZuJsQF6ZoQ9CirDS43tYueqTLlcKNkJU2vbY
         GRHPWpz8MsqEi//0V2/RUuMsG4Ts7aRKmWW6pf3qQrDzaSVVBwRzWon7liPaEq9XJB
         A83AlXFUwuShJaggiLsuTgl9lxL4PvBh5JLwFLV1Ueu751LL503ou9rsnve0P1IJl8
         hpVZXOlob/tI4smrzLACEIvvT5qEsK6WLtp+I2rdW1fDCHqay30iHXVOtJXwQXad+B
         7Rr8yecrX1CKw==
Date:   Tue, 26 Apr 2022 08:09:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maximilian Heyne <mheyne@amazon.de>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers, ixgbe: show VF statistics via ethtool
Message-ID: <20220426080953.4e5b744d@kernel.org>
In-Reply-To: <20220426084636.31609-1-mheyne@amazon.de>
References: <20220426084636.31609-1-mheyne@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Apr 2022 08:46:35 +0000 Maximilian Heyne wrote:
> +		for (i = 0; i < adapter->num_vfs; i++) {
> +			ethtool_sprintf(&p, "VF %u Rx Packets", i);
> +			ethtool_sprintf(&p, "VF %u Rx Bytes", i);
> +			ethtool_sprintf(&p, "VF %u Tx Packets", i);
> +			ethtool_sprintf(&p, "VF %u Tx Bytes", i);
> +			ethtool_sprintf(&p, "VF %u MC Packets", i);

Please use ndo_get_vf_stats / IFLA_VF_STATS.
