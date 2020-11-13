Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF26B2B166C
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 08:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgKMH22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 02:28:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgKMH22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 02:28:28 -0500
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AA9020825;
        Fri, 13 Nov 2020 07:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605252507;
        bh=aFSZmq6CmY872NVYczWKbqeDbiFmSqUs9woe1qxA3ZM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xnIjS0kPyxsUP3PwmDqBKajxq+Bi9J3LtJzlbpTazwNtpa6xuSsB9HgPu2Aab1Xr4
         7LyA8nJYuYjRIV6PlhzCT15UBKfAhbQG75v68fb1nToGAhWrH3Aa3CHwxwCP5+g2E9
         XruFp6xfLmpU3Nt3JWr/SBdg6e1qV9xWRdwdxCKg=
Received: by mail-ed1-f44.google.com with SMTP id l5so9508078edq.11;
        Thu, 12 Nov 2020 23:28:27 -0800 (PST)
X-Gm-Message-State: AOAM530KzP0Wpd0HTDsHq/7dqW4uEay7Cmt9pwKxv4SlVgmsgvFuQxhF
        OqCMKdfEumvMMG8iuzhAKLXipOKqfWfq3/zN5+c=
X-Google-Smtp-Source: ABdhPJzX45wQROgRz6lZDn+ZiPZq+vZct6Juvf3yLDM+v4ouuidXvKY3lWVBOY0mzD/VK4YlXT5dq0joBTxrIWQTZQs=
X-Received: by 2002:aa7:d414:: with SMTP id z20mr1119954edq.143.1605252505837;
 Thu, 12 Nov 2020 23:28:25 -0800 (PST)
MIME-Version: 1.0
References: <CGME20201113050919epcms2p7487583bf846376040a9874a7eb39fdae@epcms2p7>
 <20201113050919epcms2p7487583bf846376040a9874a7eb39fdae@epcms2p7>
In-Reply-To: <20201113050919epcms2p7487583bf846376040a9874a7eb39fdae@epcms2p7>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Fri, 13 Nov 2020 08:28:14 +0100
X-Gmail-Original-Message-ID: <CAJKOXPez5ZbuG3jgjNbhAbDrWoDa+UGAiRpi_fjSpB=D6geo6A@mail.gmail.com>
Message-ID: <CAJKOXPez5ZbuG3jgjNbhAbDrWoDa+UGAiRpi_fjSpB=D6geo6A@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] nfc: s3fwrn82: Add driver for Samsung
 S3FWRN82 NFC Chip
To:     bongsu.jeon@samsung.com
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 at 06:09, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
>
>
> Add the device tree bindings for Samsung S3FWRN82 NFC controller.
> S3FWRN82 is using NCI protocol and I2C communication interface.
>
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  .../devicetree/bindings/net/nfc/s3fwrn82.txt  | 30 +++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt
>
> diff --git a/Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt b/Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt
> new file mode 100644
> index 000000000000..03ed880e1c7f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt
> @@ -0,0 +1,30 @@
> +* Samsung S3FWRN82 NCI NFC Controller
> +
> +Required properties:
> +- compatible: Should be "samsung,s3fwrn82-i2c".
> +- reg: address on the bus
> +- interrupts: GPIO interrupt to which the chip is connected
> +- en-gpios: Output GPIO pin used for enabling/disabling the chip
> +- wake-gpios: Output GPIO pin used to enter firmware mode and
> +  sleep/wakeup control
> +

The bindings should be the first file in the series. However it does
not really matter as this patch should be part of the existing s3fwrn5
driver.

When submitting bindings, please use the title to match the bindings
and use YAML format.

Best regards,
Krzysztof
