Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C686663FF4C
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 05:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiLBECs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 23:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbiLBECq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 23:02:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E481082;
        Thu,  1 Dec 2022 20:02:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7031DB820BB;
        Fri,  2 Dec 2022 04:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B2FC433C1;
        Fri,  2 Dec 2022 04:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669953752;
        bh=CvrNWuUmSQ01k4JCpXfJeFQhiUYpB4P+Jo/odP+ZimE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i+t5oY8fPObK90uORwJ1PD9iL/jNcVuJTa+52GDSzqCKOqb/qiVlerPrLocQOnEE1
         5NfaOQ0yKw32mJQl+WE3xLn4+iERZbCCUAP5GyZD+NNOTvgntZNGMglGCKLifb3S5Q
         O2XhayY6BeqwJwH4KLfplIkfvUm7F1mtXOMBAHgw8nUosNzgFqYmqBQdQ3hlSUR+EO
         x2/KefOksYiDslqvJDiqqm/vHQxUWk+cxWKH85mOmxEesP4P+F2QWO8LiXq8aIjfxy
         ZPddtAEAE/E3WNBtmblQsOR18e6LoeSVNuw3zvYSqHeUJefg2mufuMdlctjo4xCsZh
         c5rIjcGpxtd0w==
Date:   Thu, 1 Dec 2022 20:02:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>
Subject: Re: [RFC Patch net-next 3/5] net: dsa: microchip: add eth mac
 grouping for ethtool statistics
Message-ID: <20221201200230.0f1054fe@kernel.org>
In-Reply-To: <20221130132902.2984580-4-rakesh.sankaranarayanan@microchip.com>
References: <20221130132902.2984580-1-rakesh.sankaranarayanan@microchip.com>
        <20221130132902.2984580-4-rakesh.sankaranarayanan@microchip.com>
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

On Wed, 30 Nov 2022 18:59:00 +0530 Rakesh Sankaranarayanan wrote:
> +	mac_stats->FramesTransmittedOK = ctr[ksz9477_tx_mcast] +
> +					 ctr[ksz9477_tx_bcast] +
> +					 ctr[ksz9477_tx_ucast] +
> +					 ctr[ksz9477_tx_pause];

do control frames count towards FramesTransmittedOK?
Please check the standard I don't recall.

> +	mac_stats->SingleCollisionFrames = ctr[ksz9477_tx_single_col];
> +	mac_stats->MultipleCollisionFrames = ctr[ksz9477_tx_mult_col];
> +	mac_stats->FramesReceivedOK = ctr[ksz9477_rx_mcast] +
> +				      ctr[ksz9477_rx_bcast] +
> +				      ctr[ksz9477_rx_ucast] +
> +				      ctr[ksz9477_rx_pause];
> +	mac_stats->FrameCheckSequenceErrors = ctr[ksz9477_rx_crc_err];
> +	mac_stats->AlignmentErrors = ctr[ksz9477_rx_align_err];
> +	mac_stats->OctetsTransmittedOK = ctr[ksz9477_tx_total_col];

OctetsTransmittedOK = ksz9477_tx_total_col[lisons] ?

> +	mac_stats->InRangeLengthErrors = ctr[ksz9477_rx_oversize];

You use the same counter for RMON oversize statistic, the two
definitely have different semantics, please check the standard
and the datasheet.

Remember that you don't have to fill in all the stats, if the HW does
not maintain a matching statistic - leave the field be. Kernel will
not report to user space unset fields.
