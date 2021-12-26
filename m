Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B918847F666
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 11:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhLZKT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 05:19:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41820 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhLZKT6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Dec 2021 05:19:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hJcm/o6tpABVKKhHikX1A3TCqvm4B6Et2NvcxkYsR/w=; b=3VYVIM/lS9h6XQvuxpQxRcZAZq
        uGfUAHZlZUOtHo/lENK26Cinx47xXQY/AEA1JG8UrGHUjJo+2Mtu+4m13VD36MTUDH6aSdJWO74zq
        972njgVFZ+EjW5jciyzHk5ooGQPs+qluwtsIGnpuUDRQuMvUhRRr2d2yEkhdaxML3D90=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n1Qd9-00HVL4-6X; Sun, 26 Dec 2021 11:19:55 +0100
Date:   Sun, 26 Dec 2021 11:19:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>
Subject: Re: [PATCH net-next 1/1] qed: add prints if request_firmware() failed
Message-ID: <YchBy/UOM576Yv6d@lunn.ch>
References: <20211226001408.107851-1-vbhavaraju@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211226001408.107851-1-vbhavaraju@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 25, 2021 at 04:14:08PM -0800, Venkata Sudheer Kumar Bhavaraju wrote:
> If driver load failed due to request_firmware() not finding the device
> firmware file, add prints that help remedy the situation.
> 
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Alok Prasad <palok@marvell.com>
> Signed-off-by: Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
> index 46d4207f22a3..4f5d5a1e786c 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_main.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
> @@ -65,6 +65,9 @@ MODULE_LICENSE("GPL");
>  
>  MODULE_FIRMWARE(QED_FW_FILE_NAME);
>  
> +#define QED_FW_REPO		\
> +	"https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git"

linux-firmware is vendor/product neutral. So i would suggest dropping
the QED prefix. This URL is also used in a couple of other drivers, so
you could consider places it somewhere under include/linux/

    Andrew
