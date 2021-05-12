Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91DE37C370
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 17:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhELPSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 11:18:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55691 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234253AbhELPQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 11:16:19 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 2AF985C00AC;
        Wed, 12 May 2021 11:15:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 12 May 2021 11:15:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=animalcreek.com;
         h=date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=mAnU4/Pyapsrj/+sgWW8cuCq7UI
        yXZHDX8wTwXmwBiE=; b=IY8yyO7/0OSJzjbgIGnxMO+95U9yFQg0ixFm7Dst/VC
        zJryKSps3RDbwXFNIQCwdbrM+A4mWYREgKzzLzWGckpOzHjxlFinCH73VOSCffVo
        iPApoZAuB1SX7m1dR77PlxmMgFTLr6zQfYxRPCEZs9aTZahjgxEcVCrw/53TB+lZ
        YmGvcCvJSForkc4F/Fi3OlOJFLxvhqwVqAQ/wR17w0LghupLkiVwMGeF+/guijqG
        VJV4DokTIVvumV5BS5HDbiX2dAfjrZNJOZIPut89HxoNml16BYKlmQTbpxsr1WMN
        rEuLFMuRHQ+iYPnUCR1cTh4aIfgDWVch2J+wyaC0rGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mAnU4/
        Pyapsrj/+sgWW8cuCq7UIyXZHDX8wTwXmwBiE=; b=TLDCXj6FhvuuXM1Qq1E5VF
        heiAjs+0vYcX3MmBN0Y/yn0dnaosN17l5ORSfluGY6egbzlirXGQhJdJJohmDhEC
        3Bq/jcjK7nson+xH5wcPiaO2vjc3e0+EV7anpH/GMG9u10lgiERhqKCQUibN35RR
        PcUVe7/waAUbMfuQUiVyaaKVxKUHjUbVfYljU3zCig6iRk5dINLH9+Fm8waI8wq7
        OnF5XGYPxRGvFe1lHChlo+zGYrSL2g4FabQ0sBxEML8STIyihpW077NhBlIUcxIk
        s9rc9c+/GIRxCV+WfWf7lAxvRyQfn8ZHEuCY1i6L5Jhfyad3L6ppVKW3FAVeVAxw
        ==
X-ME-Sender: <xms:_vCbYI8nVt3JJNAmrCc-rFA7LBbFQ5CAX2e4yLwIkrAaWzxR-ycl1w>
    <xme:_vCbYAtuA2dzfbP5JsALp9RxA90kOrZTnLAXhgk649qcEt1w2JKXqEaGbK2_E30Mz
    Do4TJlF9CuGDUFHXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjohesthdtredttddtvdenucfhrhhomhepofgrrhhk
    ucfirhgvvghruceomhhgrhgvvghrsegrnhhimhgrlhgtrhgvvghkrdgtohhmqeenucggtf
    frrghtthgvrhhnpedujeelgeejleegleevkeekvdevudfhteeuiedtleehtdduleelvdei
    fffhvdehtdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeejtddrudejvd
    drfedvrddvudeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepmhhgrhgvvghrsegrnhhimhgrlhgtrhgvvghkrdgtohhm
X-ME-Proxy: <xmx:_vCbYOAU2OSa8Oj97b4PzVi1qPJfnba9-CKyxIWRWl93hAenWgKjOQ>
    <xmx:_vCbYIePJVZbcavjrzk4A_TM6TKzbhAglWi_Bk9STy54-Jqo0o-Ewg>
    <xmx:_vCbYNMqqQuY_fc-zy9illbOC0XWLbFSRxymUb9TogkdjUMqGNlxrA>
    <xmx:__CbYOqL3fFlwK4IMh8tfPzIiVLOSDmdeEYJJPHwWmqGi_o4dHTNog>
Received: from blue.animalcreek.com (ip70-172-32-218.ph.ph.cox.net [70.172.32.218])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 11:15:10 -0400 (EDT)
Received: by blue.animalcreek.com (Postfix, from userid 1000)
        id D85DA136008B; Wed, 12 May 2021 08:15:08 -0700 (MST)
Date:   Wed, 12 May 2021 08:15:08 -0700
From:   Mark Greer <mgreer@animalcreek.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org
Subject: Re: [linux-nfc] [PATCH 1/2] MAINTAINERS: nfc: add Krzysztof
 Kozlowski as maintainer
Message-ID: <20210512151508.GB215713@animalcreek.com>
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
Organization: Animal Creek Technologies, Inc.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 10:43:18AM -0400, Krzysztof Kozlowski wrote:
> The NFC subsystem is orphaned.  I am happy to spend some cycles to
> review the patches, send pull requests and in general keep the NFC
> subsystem running.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> ---
> 
> I admit I don't have big experience in NFC part but this will be nice
> opportunity to learn something new.  I am already maintainer of few
> other parts: memory controller drivers, Samsung ARM/ARM64 SoC and some
> drviers.  I have a kernel.org account and my GPG key is:
> https://git.kernel.org/pub/scm/docs/kernel/pgpkeys.git/tree/keys/1B93437D3B41629B.asc
> 
> Best regards,
> Krzysztof
> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cc81667e8bab..adc6cbe29f78 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12899,8 +12899,9 @@ F:	include/uapi/linux/nexthop.h
>  F:	net/ipv4/nexthop.c
>  
>  NFC SUBSYSTEM
> +M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>  L:	netdev@vger.kernel.org
> -S:	Orphan
> +S:	Maintained
>  F:	Documentation/devicetree/bindings/net/nfc/
>  F:	drivers/nfc/
>  F:	include/linux/platform_data/nfcmrvl.h

FWIW,

Acked-by: Mark Greer <mgreer@animalcreek.com>
