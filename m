Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9301017C3
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 07:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbfKSFjU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Nov 2019 00:39:20 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:35537 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730261AbfKSFjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 00:39:18 -0500
Received: from marcel-macbook.holtmann.net (p4FF9F0D1.dip0.t-ipconnect.de [79.249.240.209])
        by mail.holtmann.org (Postfix) with ESMTPSA id 3950ACECED;
        Tue, 19 Nov 2019 06:48:23 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH v6 3/4] dt-bindings: net: broadcom-bluetooth: Add pcm
 config
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20191118110335.v6.3.I18b06235e381accea1c73aa2f9db358645d9f201@changeid>
Date:   Tue, 19 Nov 2019 06:39:16 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-bluetooth@vger.kernel.org, dianders@chromium.org,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <079C85BE-FBC5-4A2B-9EBF-0CEDB6F30C18@holtmann.org>
References: <20191118192123.82430-1-abhishekpandit@chromium.org>
 <20191118110335.v6.3.I18b06235e381accea1c73aa2f9db358645d9f201@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3601.0.10)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> Add documentation for pcm parameters.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
> .../bindings/net/broadcom-bluetooth.txt       | 16 ++++++++++
> include/dt-bindings/bluetooth/brcm.h          | 32 +++++++++++++++++++
> 2 files changed, 48 insertions(+)
> create mode 100644 include/dt-bindings/bluetooth/brcm.h
> 
> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> index c749dc297624..8561e4684378 100644
> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> @@ -29,10 +29,20 @@ Optional properties:
>    - "lpo": external low power 32.768 kHz clock
>  - vbat-supply: phandle to regulator supply for VBAT
>  - vddio-supply: phandle to regulator supply for VDDIO
> + - brcm,bt-sco-routing: PCM, Transport, Codec, I2S
> + - brcm,bt-pcm-interface-rate: 128KBps, 256KBps, 512KBps, 1024KBps, 2048KBps
> + - brcm,bt-pcm-frame-type: short, long
> + - brcm,bt-pcm-sync-mode: slave, master
> + - brcm,bt-pcm-clock-mode: slave, master
> 
> +See include/dt-bindings/bluetooth/brcm.h for SCO/PCM parameters. The default
> +value for all these values are 0 (except for brcm,bt-sco-routing which requires
> +a value) if you choose to leave it out.
> 
> Example:
> 
> +#include <dt-bindings/bluetooth/brcm.h>
> +
> &uart2 {
>        pinctrl-names = "default";
>        pinctrl-0 = <&uart2_pins>;
> @@ -40,5 +50,11 @@ Example:
>        bluetooth {
>                compatible = "brcm,bcm43438-bt";
>                max-speed = <921600>;
> +
> +               brcm,bt-sco-routing        = <BRCM_SCO_ROUTING_TRANSPORT>;

in case you use transport which means HCI, you would not have values below. It is rather PCM here in the example.

> +               brcm,bt-pcm-interface-rate = <BRCM_PCM_IF_RATE_512KBPS>;
> +               brcm,bt-pcm-frame-type     = <BRCM_PCM_FRAME_TYPE_SHORT>;
> +               brcm,bt-pcm-sync-mode      = <BRCM_PCM_SYNC_MODE_MASTER>;
> +               brcm,bt-pcm-clock-mode     = <BRCM_PCM_CLOCK_MODE_MASTER>;
>        };
> };

And I am asking this again. Is this adding any value to use an extra include file? Inside the driver we are not really needing these values since they are handed to the hardware.

Regards

Marcel

