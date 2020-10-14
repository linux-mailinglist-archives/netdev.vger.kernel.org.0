Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4739828E954
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 01:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732116AbgJNX6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 19:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbgJNX6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 19:58:13 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4457214D8;
        Wed, 14 Oct 2020 23:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602719893;
        bh=L7UCKOTdWynoiFyVPSWZbaE+sfMJmnLvmIsIfCqA6eo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=czuxawW6ED7Vt/u7ytASQ1GcZU87fecWL6WdZg2ZRFuM0tYSA+NPl35mji1/XcIQM
         rhdu+gUwSfBQyURu4cmVac55O+ZpLaQkbhXCvBHd2+PcDB2cEisaPmnQkRRDC3Z6I6
         RgA9WXntiqMdwWNq6iSPwNGI8RIHGRp2lUAiiF7U=
Date:   Wed, 14 Oct 2020 16:58:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>
Subject: Re: [PATCH v7,net-next,04/13] drivers: crypto: add Marvell
 OcteonTX2 CPT PF driver
Message-ID: <20201014165811.7f2d8ced@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012105719.12492-5-schalla@marvell.com>
References: <20201012105719.12492-1-schalla@marvell.com>
        <20201012105719.12492-5-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 16:27:10 +0530 Srujana Challa wrote:
> +union otx2_cptx_lf_misc_int {
> +	u64 u;
> +	struct otx2_cptx_lf_misc_int_s {
> +		u64 reserved_0:1;
> +		u64 nqerr:1;
> +		u64 irde:1;
> +		u64 nwrp:1;
> +		u64 reserved_4:1;
> +		u64 hwerr:1;
> +		u64 fault:1;
> +		u64 reserved_7_63:57;
> +	} s;
> +};

AFAIK bitfields don't jive with endianness, please don't use them.
The Linux kernel is supposed to work regardless of host CPU endian.
