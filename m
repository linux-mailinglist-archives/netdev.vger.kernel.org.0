Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76350FD784
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 09:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfKOIB5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 15 Nov 2019 03:01:57 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:37540 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbfKOIB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 03:01:56 -0500
Received: from marcel-macbook.fritz.box (p4FF9F0D1.dip0.t-ipconnect.de [79.249.240.209])
        by mail.holtmann.org (Postfix) with ESMTPSA id A8C1ECED16;
        Fri, 15 Nov 2019 09:11:00 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH v5 3/4] dt-bindings: net: broadcom-bluetooth: Add pcm
 config
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20191114180959.v5.3.I18b06235e381accea1c73aa2f9db358645d9f201@changeid>
Date:   Fri, 15 Nov 2019 09:01:54 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        dianders@chromium.org, devicetree <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <CAF11E66-CD51-47CA-82AD-3DF3302FC456@holtmann.org>
References: <20191115021008.32926-1-abhishekpandit@chromium.org>
 <20191114180959.v5.3.I18b06235e381accea1c73aa2f9db358645d9f201@changeid>
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
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
> .../bindings/net/broadcom-bluetooth.txt       | 20 +++++++++++-
> include/dt-bindings/bluetooth/brcm.h          | 32 +++++++++++++++++++
> 2 files changed, 51 insertions(+), 1 deletion(-)
> create mode 100644 include/dt-bindings/bluetooth/brcm.h
> 
> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> index c749dc297624..a92da31daa79 100644
> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> @@ -29,10 +29,22 @@ Optional properties:
>    - "lpo": external low power 32.768 kHz clock
>  - vbat-supply: phandle to regulator supply for VBAT
>  - vddio-supply: phandle to regulator supply for VDDIO
> -
> + - brcm,bt-sco-routing: PCM, Transport, Codec, I2S
> +                        This value must be set in order for the latter
> +                        properties to take effect.
> + - brcm,bt-pcm-interface-rate: 128KBps, 256KBps, 512KBps, 1024KBps, 2048KBps
> + - brcm,bt-pcm-frame-type: short, long
> + - brcm,bt-pcm-sync-mode: slave, master
> + - brcm,bt-pcm-clock-mode: slave, master
> +
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
> @@ -40,5 +52,11 @@ Example:
>        bluetooth {
>                compatible = "brcm,bcm43438-bt";
>                max-speed = <921600>;
> +
> +               brcm,bt-sco-routing        = <BRCM_SCO_ROUTING_TRANSPORT>;
> +               brcm,bt-pcm-interface-rate = <BRCM_PCM_IF_RATE_512KBPS>;
> +               brcm,bt-pcm-frame-type     = <BRCM_PCM_FRAME_TYPE_SHORT>;
> +               brcm,bt-pcm-sync-mode      = <BRCM_PCM_SYNC_MODE_MASTER>;
> +               brcm,bt-pcm-clock-mode     = <BRCM_PCM_CLOCK_MODE_MASTER>;
>        };

I am not sure this makes this all that much more readable. I would have been fine with using actual integer values with a comment behind it. Especially since in the driver itself we will never compare against the constants, we set whatever the DT gives us.

Anyway, for the names, I like Rob to ack them before applying them.

Regards

Marcel

