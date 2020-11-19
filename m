Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1C92B988F
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgKSQsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:48:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:58002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbgKSQst (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 11:48:49 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A40A22242;
        Thu, 19 Nov 2020 16:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605804528;
        bh=0VW9i/MRv/dowxOLQMhKyWVBY86nUeYSHiMsy+PChd0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NvKf2R7KIby+PLuw8bgAzh75MSbT/KaFX5mo7/Wbw2476MIlb0x52w+nyAfsjSl+P
         6OfEfx0Eomju/QSBQHAHaaQDrWJQWDFYxdrd06+MdcfFSmD84MZavjPG4yAPCeps63
         HtIjwMpRn7Iki0Uk34lo55+EP1w1x9/+fybUXYu0=
Date:   Thu, 19 Nov 2020 08:48:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next v7 0/4] GVE Raw Addressing
Message-ID: <20201119084847.3f48da4b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118232014.2910642-1-awogbemila@google.com>
References: <20201118232014.2910642-1-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 15:20:10 -0800 David Awogbemila wrote:
> Patch 1: Use u8 instead of bool for raw_addressing bit in gve_priv structure.
>         Simplify pointer arithmetic: use (option + 1) in gve_get_next_option.
>         Separate option parsing switch statement into individual function.
> Patch 2: Use u8 instead of bool for raw_addressing bit in gve_gve_rx_data_queue structure.
>         Correct typo in gve_desc.h comment (s/than/then/).
>         Change gve_rx_data_slot from struct to union.
>         Remove dma_mapping_error path change in gve_alloc_page - it should
>         probably be a bug fix.
>         Use & to obtain page address from data_ring->addr.
>         Move declarations of local variables i and slots to if statement where they
>         are used within gve_rx_unfill_pages.
>         Simplify alloc_err path by using "while(i--)", eliminating need for extra "int j"
>         variable in gve_prefill_rx_pages.
>         Apply byteswap to constant in gve_rx_flip_buff.
>         Remove gve_rx_raw_addressing as it does not do much more than gve_rx_add_frags.
>         Remove stats update from elseif block, no need to optimize for infrequent case of
>         work_done = 0.
> Patch 3: Use u8 instead of bool for can_flip in gve_rx_slot_page_info.
>         Move comment in gve_rx_flip_buff to earlier, more relevant patch.
>         Fix comment wrap in gve_rx_can_flip_buffers.
>         Use ternary statement for gve_rx_can_flip_buffers.
>         Correct comment in gve_rx_qpl.
> Patch 4: Use u8 instead of bool in gve_tx_ring structure.
>         Get rid of unnecessary local variable "dma" in gve_dma_sync_for_device.

You need to start CCing people who gave you feedback, and discuss the
feedback _before_ you send another version of the patchset.

CCing Alex and Saeed
