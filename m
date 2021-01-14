Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761572F6790
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbhANR0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:26:18 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:8694 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbhANR0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:26:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1610645004;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:From:
        Subject:Sender;
        bh=HDYBwIqHsqll23hMGGlTIt+vwOJcDHTYz6NC/MTevts=;
        b=cmVxeG8r8irCu6qN8PZIQ23pvnL1M+54l9Ztn5bxSPJ3w2LaZNVaUHBLYPimpwblDZ
        pTGfsP91NlaQ1gBmlIQExJs50i0rFLijiIhkOuzU3PahPY+B0GAS3srZBzokdleZAEJM
        fNCfE2R6DoWARbSZtzWmBDiV0jBTD6DXWfnNQqfcwhMIf7VgYFKplqt9IH6YnHSRwpSU
        nUuk+3evEI2CiAzFwh0cvoMRvYuEXN09aEUbR6uqfGTWKdJADMDRQLL+ChIUiurzadNu
        8zK+VMPV8DjZImQBymsCMyBYXWlR9d0OJjsLIXHVHaETISHIcjZTEGJSpNEqxNgKlD3v
        Jn4g==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVMh7kiA="
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id k075acx0EHNFUs3
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 14 Jan 2021 18:23:15 +0100 (CET)
Subject: Re: [PATCH v10 1/1] can: usb: etas_es58X: add support for ETAS ES58X
 CAN USB interfaces
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jimmy Assarsson <extja@kvaser.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>
References: <20210112130538.14912-1-mailhol.vincent@wanadoo.fr>
 <20210112130538.14912-2-mailhol.vincent@wanadoo.fr>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <981eb251-1573-5852-4b16-2e207eb3c4da@hartkopp.net>
Date:   Thu, 14 Jan 2021 18:23:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210112130538.14912-2-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

On 12.01.21 14:05, Vincent Mailhol wrote:
> This driver supports the ES581.4, ES582.1 and ES584.1 interfaces from
> ETAS GmbH (https://www.etas.com/en/products/es58x.php).

(..)

> diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
> new file mode 100644
> index 000000000000..6b9534f23c96
> --- /dev/null
> +++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c

(..)

> +static void es58x_fd_print_bittiming(struct net_device *netdev,
> +				     struct es58x_fd_bittiming
> +				     *es58x_fd_bittiming, char *type)
> +{
> +	netdev_vdbg(netdev, "bitrate %s    = %d\n", type,
> +		    le32_to_cpu(es58x_fd_bittiming->bitrate));
> +	netdev_vdbg(netdev, "tseg1 %s      = %d\n", type,
> +		    le16_to_cpu(es58x_fd_bittiming->tseg1));
> +	netdev_vdbg(netdev, "tseg2 %s      = %d\n", type,
> +		    le16_to_cpu(es58x_fd_bittiming->tseg2));
> +	netdev_vdbg(netdev, "brp %s        = %d\n", type,
> +		    le16_to_cpu(es58x_fd_bittiming->brp));
> +	netdev_vdbg(netdev, "sjw %s        = %d\n", type,
> +		    le16_to_cpu(es58x_fd_bittiming->sjw));
> +}

What is the reason for this code?

These values can be retrieved with the 'ip' tool and are probably 
interesting for development - but not in the final code.

> +
> +static void es58x_fd_print_conf(struct net_device *netdev,
> +				struct es58x_fd_tx_conf_msg *tx_conf_msg)
> +{
> +	es58x_fd_print_bittiming(netdev, &tx_conf_msg->nominal_bittiming,
> +				 "nominal");
> +	netdev_vdbg(netdev, "samples_per_bit    = %d\n",
> +		    tx_conf_msg->samples_per_bit);
> +	netdev_vdbg(netdev, "sync_edge          = %d\n",
> +		    tx_conf_msg->sync_edge);
> +	netdev_vdbg(netdev, "physical_layer     = %d\n",
> +		    tx_conf_msg->physical_layer);
> +	netdev_vdbg(netdev, "self_reception     = %d\n",
> +		    tx_conf_msg->self_reception_mode);
> +	netdev_vdbg(netdev, "ctrlmode           = %d\n", tx_conf_msg->ctrlmode);
> +	netdev_vdbg(netdev, "canfd_enabled      = %d\n",
> +		    tx_conf_msg->canfd_enabled);
> +	if (tx_conf_msg->canfd_enabled) {
> +		es58x_fd_print_bittiming(netdev,
> +					 &tx_conf_msg->data_bittiming, "data");
> +		netdev_vdbg(netdev,
> +			    "Transmitter Delay Compensation        = %d\n",
> +			    tx_conf_msg->tdc);
> +		netdev_vdbg(netdev,
> +			    "Transmitter Delay Compensation Offset = %d\n",
> +			    le16_to_cpu(tx_conf_msg->tdco));
> +		netdev_vdbg(netdev,
> +			    "Transmitter Delay Compensation Filter = %d\n",
> +			    le16_to_cpu(tx_conf_msg->tdcf));
> +	}
> +}

Same here.

Either the information can be retrieved with the 'ip' tool OR the are 
not necessary as set to some reasonable default anyway OR we should 
implement the functionality in the general CAN driver infrastructure.

Regards,
Oliver

