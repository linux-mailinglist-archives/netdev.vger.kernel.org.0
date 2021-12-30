Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B580C481EA9
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241431AbhL3Rld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhL3Rld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 12:41:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB417C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 09:41:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A1C6616D4
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 17:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87A2C36AE9;
        Thu, 30 Dec 2021 17:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640886091;
        bh=Kyz2w4ZSzXMNEB5vRjfO2UQYVsvzmigm55ngVjiviXI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NNUMdDg5cuwOAZZBpKjewjrnJjzVOu007xNTqu+RlLWBCeVAQoFA3QzLJ/GSrvfmy
         z44Iy4XK5IX59pcI83VFcGpZy+2END2lESPG5ehQWnqyPp8+tCE6V4cu2n/Q+2yipl
         cwVO5xufXy2OXcRIijh3wgKMst1wQLmPF1s3FAlPfyP9hPC5kgKdl5GiviDmS8n+Rq
         AgzYVbsVECJurk7yjAl+AAxyE4Nz4GN0vxCPJy0mMJkUjRs/nrOGEqivZiAVCwGAbW
         DYRVBh3T9VIc7ioNGrb5tCoijNfdW3rNH3ljIGFeCecfAGn31iNtfD6OnRd4HIyZUm
         JImHvlPz4lmfQ==
Date:   Thu, 30 Dec 2021 09:41:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 5/8] net/funeth: devlink support
Message-ID: <20211230094129.67507001@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211230163909.160269-6-dmichail@fungible.com>
References: <20211230163909.160269-1-dmichail@fungible.com>
        <20211230163909.160269-6-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Dec 2021 08:39:06 -0800 Dimitris Michailidis wrote:
> +static int fun_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
> +			   struct netlink_ext_ack *extack)
> +{
> +	int err;
> +
> +	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
> +	if (err)
> +		return err;
> +
> +	err = devlink_info_version_fixed_put(req,
> +			DEVLINK_INFO_VERSION_GENERIC_BOARD_MANUFACTURE,
> +			"Fungible");

Manufacture is a factory. This field is for reporting which contractor
produced the physical board. I doubt Fungible does its own assembly.

> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +static const struct devlink_ops fun_dl_ops = {
> +	.info_get       = fun_dl_info_get,
> +	.flash_update   = fun_dl_flash_update,
> +};

There's init clearly missing here. Please go back and make sure 
all the functionality actually works upstream.
