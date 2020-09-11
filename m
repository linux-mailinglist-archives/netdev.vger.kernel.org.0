Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587F62664E2
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgIKQrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgIKQrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 12:47:08 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50690C061573;
        Fri, 11 Sep 2020 09:47:06 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e23so14665664eja.3;
        Fri, 11 Sep 2020 09:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nOGJPFb8tqcisgKdNWRkr2oYMuaCds9kPjWo0o0S++g=;
        b=OmVPrRxbTjFVA8eJu6UseFiGVPhkZ9W5C607RsegD7zaZekS/T65r/vxggtvhdoDvF
         ZXZT8B7LvshdNN9TVMCL6LdDKewnsGAyIbEwtNBhN0OyQbb0mHxzWym5IUtId07kErMM
         zCUjfle1MPobR9Lemz6YvCYFeunAV6IRs2fLR79yml/+r2wQgZ+Q6YuPMd+DBhHjb6xW
         F0M2hS8MFGyEe9Su7dyjPlheIMCIpVbWnS1u87ff9QPCsR9fHOwP/WGJIYkhWK/N4BG6
         ktAPLsL+LudvLeGzQxhUPFNVdN4pB9byt52W+le5LVFhgrJXsbEm0iJQKtKXUU6zPB+j
         Q/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nOGJPFb8tqcisgKdNWRkr2oYMuaCds9kPjWo0o0S++g=;
        b=Tsq3IAPKq+cMNLfmlm1+FJm3bH36lqqpJzf2nTUHNwCPcYerBR0ewCvpbIKzeoSn3+
         O1gbjjiWiq23Jc5R6tpOCd3LdKX7YmNWG7QqNNOmWlbbtu8/Ml62VhoqQhtpXpvwIXue
         Rwv7W7AxvRsvfK+8oiRGvpUiJm5THM0qEFve0EGNVl2dQGaDXVCBqD7UGejLQ5f33T0+
         8D5t29w/bfFEMxP7B+hl3Kw7H7KI3RzD9JjxmEnWUFgfZHNlvLJ5ZUTCJ6DGoH9WH/pv
         be6yL8rDqghOBmGWOoDurtsG/1yY0IYRTVDXYJUuVbkZZCm3OTdffYGmaI5fjj2/lUH0
         T/0Q==
X-Gm-Message-State: AOAM5331Hrrs7bEYVBYJ16RuPXqVsje3b9nWa1xhncjkEDoAqt8xitSi
        3fkBvgeBsdn+pHeHnH9WwPAbwZLerv4=
X-Google-Smtp-Source: ABdhPJxLGtNY6xZ3UUPcj9fN2eK23dBa3FX7Aol194xPWU6GsHLK8Ppa0YW2W4BGAocAHdZP5Zn65g==
X-Received: by 2002:a17:906:b090:: with SMTP id x16mr2883008ejy.46.1599842825028;
        Fri, 11 Sep 2020 09:47:05 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id d24sm2088584edp.17.2020.09.11.09.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 09:47:04 -0700 (PDT)
Date:   Fri, 11 Sep 2020 19:47:01 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        frank-w@public-files.de, opensource@vdorst.com, dqfext@gmail.com
Subject: Re: [PATCH net-next v5 0/6] net-next: dsa: mt7530: add support for
 MT7531
Message-ID: <20200911164701.ozoj57pc6zmlsru7@skbuf>
References: <cover.1599829696.git.landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1599829696.git.landen.chao@mediatek.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 09:48:50PM +0800, Landen Chao wrote:
> This patch series adds support for MT7531.
>
> MT7531 is the next generation of MT7530 which could be found on Mediatek
> router platforms such as MT7622 or MT7629.
>
> It is also a 7-ports switch with 5 giga embedded phys, 2 cpu ports, and
> the same MAC logic of MT7530. Cpu port 6 only supports SGMII interface.
> Cpu port 5 supports either RGMII or SGMII in different HW SKU, but cannot
> be muxed to PHY of port 0/4 like mt7530. Due to support for SGMII
> interface, pll, and pad setting are different from MT7530.
>
> MT7531 SGMII interface can be configured in following mode:
> - 'SGMII AN mode' with in-band negotiation capability
>     which is compatible with PHY_INTERFACE_MODE_SGMII.
> - 'SGMII force mode' without in-band negotiation
>     which is compatible with 10B/8B encoding of
>     PHY_INTERFACE_MODE_1000BASEX with fixed full-duplex and fixed pause.
> - 2.5 times faster clocked 'SGMII force mode' without in-band negotiation
>     which is compatible with 10B/8B encoding of
>     PHY_INTERFACE_MODE_2500BASEX with fixed full-duplex and fixed pause.
>
> v4 -> v5
> - Add fixed-link node to dsa cpu port in dts file by suggestion of
>   Vladimir Oltean.

Thank you!

-Vladimir
