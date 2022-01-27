Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAF749E092
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbiA0LTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:19:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57780 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiA0LTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:19:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD00560C0F;
        Thu, 27 Jan 2022 11:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2CFC340E4;
        Thu, 27 Jan 2022 11:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643282386;
        bh=HoIsfZmCo1COGR24ng8ODGdggQuDnPmUWSOWb0Al+MQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mQKwD8odyYey+nCmCdK1bLh8SAlCEvhFnQCuMkn7/m3cglYxFmrK1aMWqLsIDYQPA
         m310adfPrgFfs7pIgBcOpzz/GDdspxkGfko2J8p2RASx/N2bw7kXe7WNw7dpCrB6a4
         1DVDpKlcQsaJDgtCCCeEms4B1hj3LHc2qz9oSgqg=
Date:   Thu, 27 Jan 2022 12:19:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] usbnet: add devlink support
Message-ID: <YfJ/yjPdbvKHKXI6@kroah.com>
References: <20220127110742.922752-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127110742.922752-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 12:07:42PM +0100, Oleksij Rempel wrote:
> +static int usbnet_devlink_info_get(struct devlink *devlink,
> +				 struct devlink_info_req *req,
> +				 struct netlink_ext_ack *extack)
> +{
> +	struct usbnet *usbnet = usbnet_from_devlink(devlink);
> +	char buf[10];
> +	int err;
> +
> +	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
> +	if (err)
> +		return err;
> +
> +	scnprintf(buf, 10, "%d.%d", 100, 200);

Odd magic number values :(
