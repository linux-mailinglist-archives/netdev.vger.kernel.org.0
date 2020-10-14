Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66B728E4C4
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 18:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388641AbgJNQrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 12:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388427AbgJNQry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 12:47:54 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4774C061755;
        Wed, 14 Oct 2020 09:47:53 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id o18so163958edq.4;
        Wed, 14 Oct 2020 09:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nP06Nzu/uZ+bkygYBHbzehNzKFlWut93IYryMaUqpI8=;
        b=nhUthSWjexc4NX+kll7La73seVsGKK0GbuSgyPFWu0hTmZoZpoN+Jx3qxx22Iydty6
         E0c59Y3k/os/WLVs+b5yY45w/dUlNDkay+BbKCC7yE4a6rzoWml7O5Scl89tkMbhkI/W
         rRz5YMVsYzGqohypmD0b5Bp3LTLGL3ZW3LtzNIh96c71GdlA71sGK+AhfR1ctNFKu511
         5thEPLHsABnCPOyWnBu9WiW5mAxo0Dubxjx/QaguECpvNH5KdF6XY60qFwedB0dIFN3d
         D5ValA+W0NAeFO9XI4VNt3iRM/n+uuWQZSqXw8l2mAcnrO6/Ahjtd1jHND9PbJuF0kqB
         w09w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nP06Nzu/uZ+bkygYBHbzehNzKFlWut93IYryMaUqpI8=;
        b=Mwfm4lcRJlmxnrMLxN7b7yDd3LFj1ehz5U0vRlunuHQMRS7oPUsqngh/pYfKtog0Rx
         +5tEZNAYoS0rMwL8/RtjDxe7cfHVd8Cna7QpkSc9nW3ZYAjwy7syM+P2O/6TwuUt50jh
         PxATkAEq3/AyPBdnP3MGIvsR42z4y5KJN7GI3BoObP5oJSLnQmWPdRwVeP0+pmAtxL7Z
         QHqMbKnK6aFYwWucq8gz+3D3xk4cWy746Gd6zTcYsrRd+NQCfWRHpLYFufiCVj6Ari9j
         eF7cjezB6oa+E4TTW0EecHwQA8vF/xoSeNcR7cNnvg1lCSKER3kp9gFWUiiBeiEzw9km
         GBkw==
X-Gm-Message-State: AOAM531Bx1E0S0g76J4816YBmviSciFgEVvDAay1yyWBVyO2Ds4IPLkg
        MRrVYyyRMWuaMYVO/zk6f7Y=
X-Google-Smtp-Source: ABdhPJyzZ5vqSuQ7kds2BgZQ2RajKTrCnyzIxvRg7Pg5P8HHMr/riMAr7duxi/6GMxQ7rFkHrf2aJA==
X-Received: by 2002:aa7:d948:: with SMTP id l8mr6279207eds.159.1602694072484;
        Wed, 14 Oct 2020 09:47:52 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id i14sm43579edu.40.2020.10.14.09.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 09:47:51 -0700 (PDT)
Date:   Wed, 14 Oct 2020 19:47:50 +0300
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
Message-ID: <20201014164750.qelb6vssiubadslj@skbuf>
References: <20201014161719.30289-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014161719.30289-1-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 06:17:19PM +0200, Christian Eggers wrote:
> __skb_put_padto() is called in order to ensure a minimal size of the
> sk_buff. The required minimal size is ETH_ZLEN + the size required for
> the tail tag.
>
> The current argument misses the size for the tail tag. The expression
> "skb->len + padlen" can be simplified to ETH_ZLEN.
>
> Too small sk_buffs typically result from cloning in
> dsa_skb_tx_timestamp(). The cloned sk_buff may not meet the minimum size
> requirements.
>
> Fixes: e71cb9e00922 ("net: dsa: ksz: fix skb freeing")
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
