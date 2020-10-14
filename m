Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DBD28E92A
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 01:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgJNX06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 19:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgJNX06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 19:26:58 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E403C2072D;
        Wed, 14 Oct 2020 23:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602718017;
        bh=aJtLUT5CUqccTM2pkrFn/NwRFqdAj1DcJprXwjRRsh0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cwbBqOsazetMElUlWGrNzzYcUBOpha8aLsVcHn5DAX4zgDpW8YjqLw9ZlOU8et3We
         2d6oRpe5obXv64sp0VcDx6QjOmCRsd0Emc9M+qSNHq54K1RtYNGivqabiWxiUg+v7y
         dHcbommzec42eZbBZU0pFf56yHMa0MiByTuTfkBc=
Date:   Wed, 14 Oct 2020 16:26:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Cc:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v5 06/10] bridge: cfm: Kernel space
 implementation of CFM. CCM frame RX added.
Message-ID: <20201014162655.3cbc8664@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012140428.2549163-7-henrik.bjoernlund@microchip.com>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
        <20201012140428.2549163-7-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 14:04:24 +0000 Henrik Bjoernlund wrote:
> +	/* This CCM related status is based on the latest received CCM PDU. */
> +	u8 port_tlv_value; /* Port Status TLV value */
> +	u8 if_tlv_value; /* Interface Status TLV value */
> +
> +	/* CCM has not been received for 3.25 intervals */
> +	bool ccm_defect;
> +
> +	/* (RDI == 1) for last received CCM PDU */
> +	bool rdi;
> +
> +	/* Indications that a CCM PDU has been seen. */
> +	bool seen; /* CCM PDU received */
> +	bool tlv_seen; /* CCM PDU with TLV received */
> +	/* CCM PDU with unexpected sequence number received */
> +	bool seq_unexp_seen;

Please consider using a u8 bitfield rather than a bunch of bools,
if any of this structures are expected to have many instances. 
That'd save space.
