Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F06828E4EB
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 18:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389260AbgJNQyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 12:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgJNQyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 12:54:14 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC8AC061755;
        Wed, 14 Oct 2020 09:54:14 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id 33so119141edq.13;
        Wed, 14 Oct 2020 09:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=18ljtZA9LSL961+Jz8OU98VYrwx5ZKx4rDJ11xHuE5M=;
        b=Ayxl6no/cB2pj2f7wXzDu7PpFz508hG4beG9/mGHc+34nxikbgoyw2cxTrd+ti2jkA
         fCrA9DOcL96Oru1L3TTDo15t0bSfr/eZH97rvNWURimCYmC8/Cgu3rZQ+BsD0SJbo8xf
         4rkA/cIHM6+WGCH3J46gR+6IwdORahryiTU4BrRP7DzXojru7vV5noQ4SlTVnkXSS7xP
         DzYLwu4vwJtCLQNUXOYaxZo7Pq7vSoeZuamLiIzMUWMJQBXyMxNIfN3YbZZPqTQk7caa
         nyH7U6iC/Oud9UqSwnIigxM4a2IGA5/1OSzxdCMTjKqrDv+wwfafgkR5bLV+B6oonq0M
         diJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=18ljtZA9LSL961+Jz8OU98VYrwx5ZKx4rDJ11xHuE5M=;
        b=aI6MC2UeHyHJEAbi6OJel7C+c6Jkb018ziM21AU0Wk1gJkxv3oJtyKxtZ7Tya0sVTF
         RkitQRfD+bpEa0ZIUMR4ePOGolfEfsFx8PzH5SfGfDEC8BjXk5N0BjOdNSLSkJVoiUoP
         t/r4hD1+UllNvCymMrQw2DIxxo75sAbWoxB43PkiMl0yYKYLd0VTMVc206kTPU2BXPcq
         rxQ68PycsNFGiyCwfzcPh/r2zUUgRIqdsK6IAWm6/j5JododV9zXj8jvJ2aUTKevRaig
         kK1+KN0bhO0rVA2CVWlfRsaGdPItL4OCipYPtZjLSDoE01LSFdi3uI8XJpiEB+Lp9xx8
         hegA==
X-Gm-Message-State: AOAM532L+NOcesVQaXVyCrWEw2wRhtVEa4czA/2HWZdKaSmvFRTWTonK
        UFSxmlZtHnN/nw9v1V8QACc=
X-Google-Smtp-Source: ABdhPJwVdcFOVYcyuqNZpKOMw4I521+5Kf3oBREzYHYI+OljxAwTMz/aMujdh+iKG8wokm8chmricA==
X-Received: by 2002:a05:6402:b31:: with SMTP id bo17mr6497575edb.342.1602694452768;
        Wed, 14 Oct 2020 09:54:12 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id ce14sm61389edb.25.2020.10.14.09.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 09:54:12 -0700 (PDT)
Date:   Wed, 14 Oct 2020 19:54:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net] net: dsa: ksz: fix padding size of skb
Message-ID: <20201014165410.fzvzdk3odsdjljpq@skbuf>
References: <20201014161719.30289-1-ceggers@arri.de>
 <20201014164750.qelb6vssiubadslj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014164750.qelb6vssiubadslj@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 07:47:50PM +0300, Vladimir Oltean wrote:
> On Wed, Oct 14, 2020 at 06:17:19PM +0200, Christian Eggers wrote:
> > __skb_put_padto() is called in order to ensure a minimal size of the
> > sk_buff. The required minimal size is ETH_ZLEN + the size required for
> > the tail tag.
> >
> > The current argument misses the size for the tail tag. The expression
> > "skb->len + padlen" can be simplified to ETH_ZLEN.
> >
> > Too small sk_buffs typically result from cloning in
> > dsa_skb_tx_timestamp(). The cloned sk_buff may not meet the minimum size
> > requirements.
> >
> > Fixes: e71cb9e00922 ("net: dsa: ksz: fix skb freeing")
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > ---
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Actually no, I take that back.

This statement:

> The expression "skb->len + padlen" can be simplified to ETH_ZLEN.

is false.
skb->len + padlen == ETH_ZLEN only if skb->len is less than ETH_ZLEN.
Otherwise, skb->len + padlen == skb->len.

Otherwise said, the frame must be padded to
max(skb->len, ETH_ZLEN) + tail tag length.

So please keep the "skb->len + padlen + len".

Thanks,
-Vladimir
