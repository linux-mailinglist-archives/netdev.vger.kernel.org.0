Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B1E389F06
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 09:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhETHnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 03:43:01 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:27876 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhETHnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 03:43:00 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1621496496; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=BZJ2ojaz7EzRNPbBXf6KeBTVCa9n0us/ZnsLcbgQT5Zg/mzDhIhn/zcnDGQ13/52pz
    TLDEs5qImHT0evesDyYVOi43NqV/I/6KPDYvj+WkZuA1xiuZqJ0LdAYWvTlx6sUS741a
    12XyYoEIZCiY9jrrVS3vv/+Dyvoqoz+8poV1u+zm9xTvz1IqRJJU7YNzGbixGBve7ZOS
    bPQDgPsnGdDQssHJKsQgOgbfNoxMfUXjs37gcTbpCQSu6hyBBLHH8tH+fts8RcBjE4cr
    G1y3XdB+x0/284eJSRWNDwkwqHqWZvLh5CdSGBPSfzKYrZDs1SQ4/urdSoyxPh+12fXD
    p7gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621496496;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=/AB8rpzWcGGrvWhsgbSoWj2+H6i9d45l8uVGIOA0RAI=;
    b=cdTA9oxqBfz6CXyYqNOp5OTgu4I+ca6lEoS9I9qadsBz2aOmUrOsNITsQOodqlk3nH
    NJ3p38RGFtN2gM7fBV4nojXOKV1Ux09M0ClfsHHtP/hh5ZDdfxdUuHdqomoFyjFLljB9
    q2ETnUBFlVuRihj2iLL+c6fvKqxZxVCqcPWnmS3puYwmDVPzYExrPswX4Zps77Btveq4
    BeYlT/MKjvhRcyArVRxO8aCejI3mtesQ7OYQU/+7ChHnFg5lFhVD4KSjjAO4Y+q8Tp3c
    4qt6xcFL/7ocxDaXvat1f7XTdJsh9XnznBkHzJ+Ab4ESkjk5Gs+8EpPfnI+WqFZQWNmY
    560A==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621496496;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=/AB8rpzWcGGrvWhsgbSoWj2+H6i9d45l8uVGIOA0RAI=;
    b=iyLpKJEs6v8QsGMhEn73OPCITDSHGQy5shXqJq8FccU39QzJJaqkgNpF9MJ+OWbfIE
    a/pmDpPjnY+odCaRmgIKL2L913S4D4ERxc2cOnRoXpHOFfR249BEXcq4q99yOv6UVQ1H
    dMb13c0ApzCkCmcY9MCKE93pfvaNO2FZGoFnLQymUJgZ3Bv3I6Zfun/hw+02hLP4cB6z
    gCVUuREmjB29sI53FQYICnCyihmDQnc3l3R2PLaHJKnUzEJKKLAvumkPUxXBLLGKeXHV
    GXwwYsX2v+2H5Z8ge4JhGv84Zu8u/2Z51KBdXdHW8gOLay8V37m12DQCPvRCPF32DXZf
    aDdg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j6IcfMBg=="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.26.1 DYNA|AUTH)
    with ESMTPSA id 400bd8x4K7fZ0Rw
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 20 May 2021 09:41:35 +0200 (CEST)
Date:   Thu, 20 May 2021 09:41:31 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht
Subject: Re: [linux-nfc] Re: [PATCH 2/2] nfc: s3fwrn5: i2c: Enable optional
 clock from device tree
Message-ID: <YKYSq5WTeZyMIZYn@gerhold.net>
References: <20210518133935.571298-1-stephan@gerhold.net>
 <20210518133935.571298-2-stephan@gerhold.net>
 <ac04821e-359d-aaaa-7e07-280156f64036@canonical.com>
 <YKPWgSnz7STV4u+c@gerhold.net>
 <8b14159f-dca9-a213-031f-83ab2b3840a4@canonical.com>
 <YKTHXzUhcYa5YJIs@gerhold.net>
 <10b3a50e-877c-d5b1-3e35-e5dff4ef53d8@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10b3a50e-877c-d5b1-3e35-e5dff4ef53d8@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 11:58:38AM -0400, Krzysztof Kozlowski wrote:
> > 
> > Personally, I just skip all firmware/RF configuration (which works thanks
> > to commit 4fb7b98c7be3 ("nfc: s3fwrn5: skip the NFC bootloader mode")).
> > That way, S3FWRN5 just continues using the proper configuration
> > that was loaded by the vendor drivers at some point. :)
> 
> But isn't that configuration lost after power off?
> 

I don't know exactly but I don't think it's lost. At least the firmware
and rfreg configuration seem to be preserved since I've never provided
the driver with the necessary firmware. It just works without :)

Stephan
