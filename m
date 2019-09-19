Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D030EB7F37
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 18:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404378AbfISQef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 12:34:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387693AbfISQef (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 12:34:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zk34/WaepEZ6aVZJpiWjUS8UF7iUIRACXnV7zV0EX8U=; b=hwQPpg2MxAEK2mGXABpo2ESLzO
        SpXQrfoXC3ABRO1fNZowoBlu28Gf6eyfYSiciZS6nDtdLwjh1wUdRMuxSwHVLlK/AZ27MN96GGHmA
        8kttrhaKx2z4ENgRhGdAGKkdzaguSPi9+iX2Y9UmHHrJVKMKtVucLIwKNyg/2Wq5dYIA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iAzO1-0007gl-It; Thu, 19 Sep 2019 18:34:29 +0200
Date:   Thu, 19 Sep 2019 18:34:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Le Goff <David.Legoff@silabs.com>
Subject: Re: [PATCH 02/20] staging: wfx: add support for I/O access
Message-ID: <20190919163429.GB27277@lunn.ch>
References: <20190919105153.15285-1-Jerome.Pouiller@silabs.com>
 <20190919105153.15285-3-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919105153.15285-3-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 10:52:35AM +0000, Jerome Pouiller wrote:
> +static int wfx_sdio_copy_from_io(void *priv, unsigned int reg_id,
> +				 void *dst, size_t count)
> +{
> +	struct wfx_sdio_priv *bus = priv;
> +	unsigned int sdio_addr = reg_id << 2;
> +	int ret;
> +
> +	BUG_ON(reg_id > 7);

Hi Jerome

BUG_ON should only be used when the system is corrupted, and there is
no alternative than to stop the machine, so it does not further
corrupt itself. Accessing a register which does not exist is not a
reason the kill the machine. A WARN() and a return of -EINVAL would be
better.

	Andrew
