Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863FC95E57
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 14:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfHTMXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 08:23:49 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33276 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfHTMXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 08:23:49 -0400
Received: by mail-lf1-f66.google.com with SMTP id x3so3977719lfc.0;
        Tue, 20 Aug 2019 05:23:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xzCx8rfipqjiXyNq4gJ4Cz+X4TRNhHPHouMg4toUPfA=;
        b=lrm/1a9jKxCdouUR+V3WMek7WebdVClaXa9VmrNGP/wuX4w4UO9PrikfyKMOw2h8Ta
         lwruLbzAGB12q40g9UdcFG2IRX6seldKYPVq5X5PH/fYc471xa4XPEx7Aj1L6ir4cuow
         HQpDRbZnRsIgcsK58AWwmHZQjaXkvx4Qfv8aITLVSvOjyqZQ/v0enh+QAQAOn0Y5snDh
         /DFxrqtkSC85KNrdAcNySXeDeFyq34kMEbXatK5I6jPREFGsFcM3Q8B1MWparcA0IUkB
         +WAD4fApEX5wU9GCEDGZ7LLgGE2IUkp/JhCbn7BA6st5wAH+iiThmBlirNt1bWucFYy8
         SW0w==
X-Gm-Message-State: APjAAAXndYK2wWmj6TnvRjFvvTeIqy51s4lLlnlsyEkn6d5/40/qlMTk
        YqTOt9TT530VNLmG19+pYarZiU9RRkc=
X-Google-Smtp-Source: APXvYqxFQ2ko1xAoC/Pf3Vfq7Q5vJ1Jrs/WfZsfoPBvNjK7xuCf/JwLwk+dE/Whe5y3+eULYxc2glw==
X-Received: by 2002:ac2:48b8:: with SMTP id u24mr14915884lfg.170.1566303827572;
        Tue, 20 Aug 2019 05:23:47 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id q30sm3193284lfd.27.2019.08.20.05.23.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 05:23:46 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92)
        (envelope-from <johan@kernel.org>)
        id 1i03Au-0002Fy-JN; Tue, 20 Aug 2019 14:23:44 +0200
Date:   Tue, 20 Aug 2019 14:23:44 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     Allison Randal <allison@lohutok.net>,
        Steve Winslow <swinslow@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:NFC SUBSYSTEM" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v6 6/7] nfc: pn533: Add autopoll capability
Message-ID: <20190820122344.GK32300@localhost>
References: <20190820120345.22593-1-poeschel@lemonage.de>
 <20190820120345.22593-6-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820120345.22593-6-poeschel@lemonage.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 02:03:43PM +0200, Lars Poeschel wrote:
> pn532 devices support an autopoll command, that lets the chip
> automatically poll for selected nfc technologies instead of manually
> looping through every single nfc technology the user is interested in.
> This is faster and less cpu and bus intensive than manually polling.
> This adds this autopoll capability to the pn533 driver.
> 
> Cc: Johan Hovold <johan@kernel.org>
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
> Changes in v6:
> - Rebased the patch series on v5.3-rc5

Just two drive-by comments below.

>  drivers/nfc/pn533/pn533.c | 193 +++++++++++++++++++++++++++++++++++++-
>  drivers/nfc/pn533/pn533.h |  10 +-
>  2 files changed, 197 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
> index a8c756caa678..7e915239222b 100644
> --- a/drivers/nfc/pn533/pn533.c
> +++ b/drivers/nfc/pn533/pn533.c
> @@ -185,6 +185,32 @@ struct pn533_cmd_jump_dep_response {
>  	u8 gt[];
>  } __packed;
>  
> +struct pn532_autopoll_resp {
> +	u8 type;
> +	u8 ln;
> +	u8 tg;
> +	u8 tgdata[];
> +} __packed;

No need for __packed.

> +static int pn533_autopoll_complete(struct pn533 *dev, void *arg,
> +			       struct sk_buff *resp)
> +{
> +	u8 nbtg;
> +	int rc;
> +	struct pn532_autopoll_resp *apr;
> +	struct nfc_target nfc_tgt;
> +
> +	if (IS_ERR(resp)) {
> +		rc = PTR_ERR(resp);
> +
> +		nfc_err(dev->dev, "%s  autopoll complete error %d\n",
> +			__func__, rc);
> +
> +		if (rc == -ENOENT) {
> +			if (dev->poll_mod_count != 0)
> +				return rc;
> +			goto stop_poll;
> +		} else if (rc < 0) {
> +			nfc_err(dev->dev,
> +				"Error %d when running autopoll\n", rc);
> +			goto stop_poll;
> +		}
> +	}
> +
> +	nbtg = resp->data[0];
> +	if ((nbtg > 2) || (nbtg <= 0))
> +		return -EAGAIN;
> +
> +	apr = (struct pn532_autopoll_resp *)&resp->data[1];
> +	while (nbtg--) {
> +		memset(&nfc_tgt, 0, sizeof(struct nfc_target));
> +		switch (apr->type) {
> +		case PN532_AUTOPOLL_TYPE_ISOA:
> +			dev_dbg(dev->dev, "ISOA");

You forgot the '\n' here and elsewhere (some nfc_err as well).

Johan
