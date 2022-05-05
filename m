Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1425951B66F
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 05:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240842AbiEEDUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 23:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240743AbiEEDUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 23:20:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655011F9;
        Wed,  4 May 2022 20:16:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1803DB82B1D;
        Thu,  5 May 2022 03:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B490C385AC;
        Thu,  5 May 2022 03:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651720593;
        bh=EUd+FQNjVhYPHngnfqRNiGUw9qP+rE/n5F5xlcFB4Ak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=osKma1W+URS/BXiFLBUBrRLnfzM0rDplolvKg/BjR0bm3FHE5uE+C2NU708HyQ89F
         CUBMXtrBVEFTjucpC/AcE9N5QZD/rh2rdkLHVGk1nmdA00hBYPtc0YVPQLpGlxuWxW
         URodyeuI0ii3rwQ9mY/rrbZFZpr0IR5QHL9+1aPbae/Nc95nCjEQ+xEGAUmIkHs+NU
         KyGuFyN3bS91qsRcJVr6RbnCwEOCKezOJhdogyy9UZjTJ8aH+HboHARRWS9KMgJMRv
         qrn59pYhUlQ/5DWID99rUS7REILjpq0l+CWu5/Ko3C7/+oxBNC3AnRyGqzyGcEIsvk
         ndS1OFXM1iydg==
Date:   Wed, 4 May 2022 20:16:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maximilian Heyne <mheyne@amazon.de>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] drivers, ixgbe: show VF statistics
Message-ID: <20220504201632.2a41a3b9@kernel.org>
In-Reply-To: <20220503150017.16148-1-mheyne@amazon.de>
References: <20220503150017.16148-1-mheyne@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 May 2022 15:00:17 +0000 Maximilian Heyne wrote:
> +		for (i = 0; i < adapter->num_vfs; i++) {
> +			ethtool_sprintf(&p, "VF %u Rx Packets", i);
> +			ethtool_sprintf(&p, "VF %u Rx Bytes", i);
> +			ethtool_sprintf(&p, "VF %u Tx Packets", i);
> +			ethtool_sprintf(&p, "VF %u Tx Bytes", i);
> +			ethtool_sprintf(&p, "VF %u MC Packets", i);
> +		}

Please drop the ethtool stats. We've been trying to avoid duplicating
the same stats in ethtool and iproute2 for a while now.
