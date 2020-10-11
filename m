Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE3528AAD0
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 00:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbgJKWCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 18:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgJKWCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 18:02:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AFB7206E9;
        Sun, 11 Oct 2020 22:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602453741;
        bh=3HWok1YI8xRkmIBv/nNgBCbcTrLSzXArCxacP/4msdI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r/vYiRrJNvss3xzTMV+pHdCPEmPwkZ5hOnH2NIRM0FL6UVN10TlIE5r86dY54xe0n
         RXsKtWOQs8UzaUvjuqTqWr/fBhLfLd8+F69SlqDTg+o11O+ghnqqPIHaLC/WkgLOd+
         Ab2CQrg3k20Xu1oqIkmrJiCOq94ULUAIHMoHGGCo=
Date:   Sun, 11 Oct 2020 15:02:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next 9/9] bnxt_en: Add stored FW version info to
 devlink info_get cb.
Message-ID: <20201011150219.14af9c57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1602411781-6012-10-git-send-email-michael.chan@broadcom.com>
References: <1602411781-6012-1-git-send-email-michael.chan@broadcom.com>
        <1602411781-6012-10-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 06:23:01 -0400 Michael Chan wrote:
> +	rc = bnxt_hwrm_nvm_get_dev_info(bp, &nvm_dev_info);
> +	if (rc)
> +		return rc;

This will not cause an error to be returned for the entire operation on
older FW or HW, right?

> +	if (!(nvm_dev_info.flags & NVM_GET_DEV_INFO_RESP_FLAGS_FW_VER_VALID))
> +		return 0;


> +	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
> +			      DEVLINK_INFO_VERSION_GENERIC_FW_ROCE, roce_ver);
>  	return rc;

return bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
			DEVLINK_INFO_VERSION_GENERIC_FW_ROCE, roce_ver);
