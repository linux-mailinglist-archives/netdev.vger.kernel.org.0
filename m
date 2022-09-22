Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82615E576C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiIVAiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIVAiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:38:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22AAA9271
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 17:38:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49601629F5
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 00:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B32C433D6;
        Thu, 22 Sep 2022 00:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663807099;
        bh=lUVW+R5gSBFBjd/SIsi9InTtmTTHtBIIfAOYHSKwecs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d0kYf24rGt9AGwINSDj+WBLEs6ESWIbBmlnmAX1ke58q858Fuk2t1lnDpPwVbQzPi
         YjibroIvJMw4GwpcrnBMs/IFsLAGXEInhS8vOS497TlzSi7iV5wXlAtvIhbZnr27mZ
         f7TYBtuG54Q40/MaT7ruj/v+NoASevDqbijOQyIF8pCJrVTCFC1NH1/mfXh9drxGef
         sOI+xJXbRQQitV8raEHtk8X30Kb0MnU9e/J9Hug5QyB4K+8aez8xqCFq3oqW0GafWr
         IiNXoHBZRDYFmWmY1z8t9GBh6oa/8PukcbieTUFdljuSDiBFxTQ/b5ToURBcyyKOYL
         DQsYxdLepzSsA==
Date:   Wed, 21 Sep 2022 17:38:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net v2] bnxt_en: replace reset with config timestamps
Message-ID: <20220921173818.305eb52e@kernel.org>
In-Reply-To: <20220921224430.20395-1-vfedorenko@novek.ru>
References: <20220921224430.20395-1-vfedorenko@novek.ru>
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

On Thu, 22 Sep 2022 01:44:30 +0300 Vadim Fedorenko wrote:
> +		if (ptp->rx_filter == PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_ENABLE) {

Doesn't ptp->rx_filter hold the uAPI values, i.e. HWTSTAMP_FILTER_* ?

> +			rc = bnxt_close_nic(bp, false, false);
> +			if (!rc)
> +				rc = bnxt_open_nic(bp, false, false);
> +		} else
> +			bnxt_ptp_cfg_tstamp_filters(bp);

nit: missing brackets around the else branch
