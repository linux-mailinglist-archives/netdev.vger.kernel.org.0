Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C11C214017C
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 02:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388434AbgAQBe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 20:34:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731058AbgAQBe4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 20:34:56 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82DF720728;
        Fri, 17 Jan 2020 01:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579224895;
        bh=XHDrehdySNX74FXFKYfxvJrD/P/H5+cb+xNkYG351/8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r8Bvb1VClAgdBHsA9hP/D6ETqxdOfS0uaQ20M0YWc581ovYAwNIkQPqnd31RFlEIt
         Dd6xHT+szHpS6Mzi4gJz0r+MqfGDRT7oKI1L1q5bmYDDu0BadbHwrmafcnpOIPPV70
         YVIH1OOtHVE8269cGA30R9xuARsCJDaSR1WH3H7U=
Date:   Thu, 16 Jan 2020 17:34:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>,
        Prakash Brahmajyosyula <bprakash@marvell.com>
Subject: Re: [PATCH v3 15/17] octeontx2-pf: ethtool RSS config support
Message-ID: <20200116173453.38bc306c@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1579204053-28797-16-git-send-email-sunil.kovvuri@gmail.com>
References: <1579204053-28797-1-git-send-email-sunil.kovvuri@gmail.com>
        <1579204053-28797-16-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jan 2020 01:17:31 +0530, sunil.kovvuri@gmail.com wrote:
> +static int otx2_set_rss_hash_opts(struct otx2_nic *pfvf,
> +				  struct ethtool_rxnfc *nfc)
> +{
> +	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
> +	u32 rxh_l4 = RXH_L4_B_0_1 | RXH_L4_B_2_3;
> +	u32 rss_cfg = rss->flowkey_cfg;
> +
> +	if (!rss->enable)
> +		netdev_err(pfvf->netdev, "RSS is disabled, cmd ignored\n");

Why not return an error here like you do in otx2_set_rxfh()?

> +	/* Mimimum is IPv4 and IPv6, SIP/DIP */
> +	if (!(nfc->data & RXH_IP_SRC) || !(nfc->data & RXH_IP_DST))
> +		return -EINVAL;
