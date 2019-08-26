Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7D99D01D
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 15:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732051AbfHZNLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 09:11:04 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38242 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731526AbfHZNLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 09:11:04 -0400
Received: by mail-ed1-f67.google.com with SMTP id r12so26445933edo.5;
        Mon, 26 Aug 2019 06:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eOkLkN7smSq0ns/S0LMZmqF1Dy+3J7PTJleOy2NTrNQ=;
        b=rchSLhS3jEcWGALrvZS9lg42bPsK+L4jmE1ofythOxOBFt7Knwin/H0gKk5aRQuMqV
         sMjx6Gng5zvInucUI+Os13OMlYXLtmWfaUPakz6Z2BMP8OrRt+P+mnqKucmGjCumX1WV
         f2H6RxTohS0XkJThfe5T3FSYC9FmzWltRieYOjQSQ7nvVWcqkx9nmBLJ+srikJlGrdct
         DHLoaF6wbuuCOrjORLwQG56Z+SU2Ua6Xynon+2CfT1CioS14peeajnB0XJVrr66r/EmL
         1k2QS54FRjqtfCg1SpgSnVOmxY0OZsVNi2e9+Ow+gOZFCJLTy1AF1X2ESTkxR/L3meL/
         /BnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eOkLkN7smSq0ns/S0LMZmqF1Dy+3J7PTJleOy2NTrNQ=;
        b=qJHagZL9F7QZWfvGEDvPp7RcChorCfl/B/KPC8HYizyaRvnFf1vUElFlibCiHte7lW
         ZiJh4R+m9aT6NAAzjAP7ojYiS6OqtdN4asWe2b4Oks7cdO1sil8g1Kellz92QCZA66M6
         uUaGs8DkV0T9QnUhQElR/X3xymao38drSHMrKlMI3c5pylTqq/Vutt6u1dJpQJGNFOYk
         2YahMT8st+gGF8iXp8c5saPcYECd6msUDm24wfLRppLEXcX5lsrRqWhwONHXYEwAYlFx
         qO7yC3Aoc9iTsgS1QPbUoNETYpjAv+rjDtKAbhvGg8GhJto+MsVVEk9u6oCDvtzssxuY
         xUSA==
X-Gm-Message-State: APjAAAVbon+AtouMLqItjUTG0Ia92+geTxjFygT910OwiR2peL6KPcXK
        S3xL1MfapVMC2qB4fp3DbsjKzdShNxy9BcB6aw0=
X-Google-Smtp-Source: APXvYqzVG/D+nD3b6ZSB8+NOgE1MImyQOAkmB/HnjzZUVCfTlt4Y95bver8du7USLt/XYwZBHYH/6rWKoRxCKOxxu5c=
X-Received: by 2002:a17:907:2069:: with SMTP id qp9mr16385256ejb.90.1566825062311;
 Mon, 26 Aug 2019 06:11:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190822211514.19288-1-olteanv@gmail.com> <20190822211514.19288-6-olteanv@gmail.com>
In-Reply-To: <20190822211514.19288-6-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 26 Aug 2019 16:10:51 +0300
Message-ID: <CA+h21hqWGDCfTg813W1WaXFnRsMdE30WnaXw5TJvpkSp0-w5JA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] ARM: dts: ls1021a-tsn: Use the DSPI controller in
 poll mode
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, Shawn Guo <shawnguo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

On Fri, 23 Aug 2019 at 00:15, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Connected to the LS1021A DSPI is the SJA1105 DSA switch. This
> constitutes 4 of the 6 Ethernet ports on this board.
>
> As the SJA1105 is a PTP switch, constant disciplining of its PTP clock
> is necessary, and that translates into a lot of SPI I/O even when
> otherwise idle.
>
> Switching to using the DSPI in poll mode has several distinct
> benefits:
>
> - With interrupts, the DSPI driver in TCFQ mode raises an IRQ after each
>   transmitted byte. There is more time wasted for the "waitq" event than
>   for actual I/O. And the DSPI IRQ count is by far the largest in
>   /proc/interrupts on this board (larger than Ethernet). I should
>   mention that due to various LS1021A errata, other operating modes than
>   TCFQ are not available.
>
> - The SPI I/O time is both lower, and more consistently so. For a TSN
>   switch it is important that all SPI transfers take a deterministic
>   time to complete.
>   Reading the PTP clock is an important example.
>   Egressing through the switch requires some setup in advance (an SPI
>   write command). Without this patch, that operation required a
>   --tx_timestamp_timeout 50 (ms), now it can be done with
>   --tx_timestamp_timeout 10.
>   Yet another example is reconstructing timestamps, which has a hard
>   deadline because the PTP timestamping counter wraps around in 0.135
>   seconds. Combined with other I/O needed for that to happen, there is
>   a real risk that the deadline is not always met.
>
> See drivers/net/dsa/sja1105/ for more info about the above.
>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Shawn Guo <shawnguo@kernel.org>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  arch/arm/boot/dts/ls1021a-tsn.dts | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
> index 5b7689094b70..1c09cfc766af 100644
> --- a/arch/arm/boot/dts/ls1021a-tsn.dts
> +++ b/arch/arm/boot/dts/ls1021a-tsn.dts
> @@ -33,6 +33,7 @@
>  };
>
>  &dspi0 {
> +       /delete-property/ interrupts;
>         bus-num = <0>;
>         status = "okay";
>
> --
> 2.17.1
>

I noticed you skipped applying this patch, and I'm not sure that Shawn
will review it/take it.
Do you have a better suggestion how I can achieve putting the DSPI
driver in poll mode for this board? A Kconfig option maybe?

Regards,
-Vladimir
