Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF3E2F1F9D
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390709AbhAKThr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387466AbhAKThq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:37:46 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB73C061786;
        Mon, 11 Jan 2021 11:37:06 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id y24so948119edt.10;
        Mon, 11 Jan 2021 11:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2HOWXgoEdikJriAL9PJcBltl1AQUOwNy5rbe7pndkH8=;
        b=Q5eSMlbNa+wgWyhaAOSM+TjNCL4FLFltTFIXFMcDciLP/52wOXO3jb03ESyw/ugtAJ
         BA0Qoqw0igut2ZVBi1FAKRb0mOefOm17cDJ8AecUJABADhgh23udf6sMmED+5G/Ux4KK
         CtEm74NPoMf7Gkgc7n+TS0HBA6saW+jnlhNBsl+n9s77qbVN5L9l2Md7FNFUFnj9tYAn
         Wjzf7w5En1kPRp3HtHrm0d0vDe9+2Q+EfZyVflDRVAVL0qNPZeZnofv5++NhPk1Qxh+Q
         YPimCrRR/GPTppwGDqeXLyHkZd6yPMfdP06CiPIQ819/XEjNOnMCGDKK5ghjcRlwtHzQ
         +YRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2HOWXgoEdikJriAL9PJcBltl1AQUOwNy5rbe7pndkH8=;
        b=gnszo/2kHzSLcwS3LnfvBdo7Ey+BcBtKHy5qJdSn/Xi5klyzBynLVKtDtwxM4wGF+P
         LQiW1QqWvFjmX0LP9LEnfP+jerGIhGn+nWL9P5sjOZqRrcMgCrLZgj2gvJmCouKwCkXd
         GiIzfF4jZLHX+ujoS2N8JnLjqHNI+C8Fywarvf++lcfW4owpMnnTtGDYDljT9UxgYjKQ
         GaCwnNsxpyAQhelS3mH52avcGi9bApPf39i/ilFlC17igUCtG2RGJoYrHfjPplJwZcy3
         sQI858XHeiIp5faPAFNjJrNyrtpUJOxBxf2zWRpMU2GdZh2YSGoZWtV14R1FMUDdmEAp
         3qhA==
X-Gm-Message-State: AOAM531PaBuAoNOfXWewXRbBk4PFry+HbVsmGA7ZHCzSAWtLW2Jni61y
        3VSiUWpYxirv1jA7H3FwK/ryYltesBxbHsCM5X8=
X-Google-Smtp-Source: ABdhPJy0YE8JscLziE8TUurcaUVQVpDiHv251GYMEQ1Xjzare/H0WiJdI2obIjUcMUVoUhjd1EDuyYQg4ZPIhQoCsAY=
X-Received: by 2002:a50:fc8b:: with SMTP id f11mr686884edq.11.1610393825143;
 Mon, 11 Jan 2021 11:37:05 -0800 (PST)
MIME-Version: 1.0
References: <20210111130657.10703-1-bjarni.jonasson@microchip.com> <20210111130657.10703-2-bjarni.jonasson@microchip.com>
In-Reply-To: <20210111130657.10703-2-bjarni.jonasson@microchip.com>
From:   =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Date:   Mon, 11 Jan 2021 20:37:01 +0100
Message-ID: <CAHXqBFJSgebLn9GxgdYGdVR6_+i76uX5YyjHw5niOet9BuYj6A@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] net: phy: Add 100 base-x mode
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pon., 11 sty 2021 o 14:54 Bjarni Jonasson
<bjarni.jonasson@microchip.com> napisa=C5=82(a):
> Sparx-5 supports this mode and it is missing in the PHY core.
>
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> ---
>  include/linux/phy.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 56563e5e0dc7..dce867222d58 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -111,6 +111,7 @@ extern const int phy_10gbit_features_array[1];
>   * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
>   * @PHY_INTERFACE_MODE_USXGMII:  Universal Serial 10GE MII
>   * @PHY_INTERFACE_MODE_10GKR: 10GBASE-KR - with Clause 73 AN
> + * @PHY_INTERFACE_MODE_100BASEX: 100 BaseX
>   * @PHY_INTERFACE_MODE_MAX: Book keeping
[...]

This is kernel-internal interface, so maybe the new mode can be
inserted before 1000baseX for easier lookup?

Best Regards
Micha=C5=82 Miros=C5=82aw
