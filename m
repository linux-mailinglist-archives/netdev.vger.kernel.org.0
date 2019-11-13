Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 991CEF9F34
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 01:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfKMAVI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 12 Nov 2019 19:21:08 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:44885 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKMAVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 19:21:08 -0500
Received: from marcel-macbook.fritz.box (p4FF9F0D1.dip0.t-ipconnect.de [79.249.240.209])
        by mail.holtmann.org (Postfix) with ESMTPSA id E342CCECF4;
        Wed, 13 Nov 2019 01:30:11 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH v4 4/4] dt-bindings: net: broadcom-bluetooth: Add pcm
 config
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20191112230944.48716-5-abhishekpandit@chromium.org>
Date:   Wed, 13 Nov 2019 01:21:06 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-bluetooth@vger.kernel.org, dianders@chromium.org,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <0642BE4E-D3C7-48B3-9893-11828EAFA7EF@holtmann.org>
References: <20191112230944.48716-1-abhishekpandit@chromium.org>
 <20191112230944.48716-5-abhishekpandit@chromium.org>
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
> 
> ---
> 
> Changes in v4:
> - Fix incorrect function name in hci_bcm
> 
> Changes in v3:
> - Change disallow baudrate setting to return -EBUSY if called before
>  ready. bcm_proto is no longer modified and is back to being const.
> - Changed btbcm_set_pcm_params to btbcm_set_pcm_int_params
> - Changed brcm,sco-routing to brcm,bt-sco-routing
> 
> Changes in v2:
> - Use match data to disallow baudrate setting
> - Parse pcm parameters by name instead of as a byte string
> - Fix prefix for dt-bindings commit
> 
> .../devicetree/bindings/net/broadcom-bluetooth.txt    | 11 +++++++++++
> 1 file changed, 11 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> index c749dc297624..42fb2fa8143d 100644
> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> @@ -29,6 +29,11 @@ Optional properties:
>    - "lpo": external low power 32.768 kHz clock
>  - vbat-supply: phandle to regulator supply for VBAT
>  - vddio-supply: phandle to regulator supply for VDDIO
> + - brcm,bt-sco-routing: 0-3 (PCM, Transport, Codec, I2S)
> + - brcm,pcm-interface-rate: 0-4 (128KBps, 256KBps, 512KBps, 1024KBps, 2048KBps)
> + - brcm,pcm-frame-type: 0-1 (short, long)
> + - brcm,pcm-sync-mode: 0-1 (slave, master)
> + - brcm,pcm-clock-mode: 0-1 (slave, master)

I think that all of them need to start with brcm,bt- prefix since it is rather Bluetooth specific.

> 
> 
> Example:
> @@ -40,5 +45,11 @@ Example:
>        bluetooth {
>                compatible = "brcm,bcm43438-bt";
>                max-speed = <921600>;
> +
> +               brcm,bt-sco-routing = [01];
> +               brcm,pcm-interface-rate = [02];
> +               brcm,pcm-frame-type = [00];
> +               brcm,pcm-sync-mode = [01];
> +               brcm,pcm-clock-mode = [01];
>        };

My personal taste would be to add a comment after each entry that gives the human readable setting.

Regards

Marcel

