Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A3C2B126C
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgKLXE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgKLXE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:04:59 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A71C0613D1;
        Thu, 12 Nov 2020 15:04:58 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id i19so10486235ejx.9;
        Thu, 12 Nov 2020 15:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mPxmxEEa6ql8IGmfbvFo5s6OMe7dcvPzbwrwHfKOkIs=;
        b=vT2zxxv//VFs6DTSrO1+7M9JwcYpsWM7f/+FeM11EsZPy7D41ajOiTPoQ3gXIGAL7z
         XEir5Pn9Bar6i4iux0DGv3ID3IzCuYxaEwFoHscYMf2BWLegJY6l/sUYJhF0p30kDnZP
         zH+/5JVSqtiMLtXcZDGANNEa9UUVQ434PX0dIix3AfuN8/oG1wycMHNMePDBc+IHJHXo
         dIjPtXnVVXJAeVQC3M96Pl1xAnQhezfqWG/6Eu1+mSrTL+5OcBbGAU5aUtzYzF1zlOYF
         U9O7W1FkKa7/g+uu7st32FtL7gaFu7UuaJcbSLRXtz3sCQw6ZEngYNbeL1d+8eP8w9Kq
         tMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mPxmxEEa6ql8IGmfbvFo5s6OMe7dcvPzbwrwHfKOkIs=;
        b=oFdksgTP/5VVf1Sk3p/DuSdmWY9Eow5OQj3upcjaRalT+HoBaZHxJ9BJOyhWc/aLzY
         Tm61ZeyxDT6mxuNxe4SWscnw2F8Fr1GG3wy8fby7yntTNPFX5WVHmUWWXM34i88OCB05
         dbdcGbBMEIPwhFrMFLnFX0HwoLaAz8NE6iBNuLX6wlUE7AxnQ2bdx10avcOmd5TgnRwJ
         nRm6UiDFAGCtSqTJRbMUfis0gmDCy7bAHQJ4e8Wczv3iNjzU1cPNyj4l9E5I9XIBl3VN
         oPic9sJuxD8JFX9pscnTcAQe4ICR+J6m8JCYcAdOVBfx5Z5VPAljuxTPefmN3AAt+DBg
         rIXw==
X-Gm-Message-State: AOAM531VctJ8AS1o+j75IuOc9GUqyj8XSRWQl/99RZaUAjR8JlZU8Rwp
        k5spLDJMQSy2+GT5P/T04EE=
X-Google-Smtp-Source: ABdhPJxIJu19q0cjPcsEEsFMYuDBuu06iF9sQSOoYs7ix0Vlcd0WQBJxupvXDtShuVtknB05wNesqA==
X-Received: by 2002:a17:906:3e91:: with SMTP id a17mr1612852ejj.82.1605222297532;
        Thu, 12 Nov 2020 15:04:57 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id 1sm2653072ejt.107.2020.11.12.15.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:04:57 -0800 (PST)
Date:   Fri, 13 Nov 2020 01:04:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 03/11] net: dsa: microchip: split ksz_common.h
Message-ID: <20201112230455.rt2vy6czlvrvr5wm@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-4-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112153537.22383-4-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:35:29PM +0100, Christian Eggers wrote:
> Parts of ksz_common.h (struct ksz_device) will be required in
> net/dsa/tag_ksz.c soon. So move the relevant parts into a new header
> file.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---
>  MAINTAINERS                            |  1 +
>  drivers/net/dsa/microchip/ksz_common.h | 81 +---------------------
>  include/linux/dsa/ksz_common.h         | 96 ++++++++++++++++++++++++++
>  3 files changed, 98 insertions(+), 80 deletions(-)
>  create mode 100644 include/linux/dsa/ksz_common.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3d173fcbf119..de7e2d80426a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11520,6 +11520,7 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
>  F:	drivers/net/dsa/microchip/*
> +F:	include/linux/dsa/microchip/ksz_common.h

Ah, I almost forgot. This path is wrong, it has an extra "microchip".
