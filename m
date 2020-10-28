Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508B329D3F7
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgJ1VsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727748AbgJ1VsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:48:15 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A060C0613CF;
        Wed, 28 Oct 2020 14:48:15 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id r127so661618lff.12;
        Wed, 28 Oct 2020 14:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jfWog0ZrcaxHMuEqGhaifBshulfBgLxnbOipJlIL3fI=;
        b=dQP/SMhThmjGShRt/dze2WLP0HamcxENAlsgeY7NHMakZzOFKzUWWM0lfUYYBwE4XC
         DC0dt0GKS72ukiCbOgP42kyZMuZAMs6pPjqYykUk9EF3uTozUkA7APWp8o5MihteJEOL
         r/jQ6b0i0ADyclSG1j2mGCPiAo+aYBO5a5tKxoH3HzZOn5eXFPJTmCQonjH9+QjyWbMr
         y68hQkWqwJT6zVP0Wsh1az9p31fWDoXTitGuAsARSCX3Unyr3DREOA2fGnlhigoCURbx
         IxPNGmyM8c/1tNA9v68iPyPJL+pCz3zFe/gUeHosrHA2IpBL5gDYjGZ3NiI9qVwlzDAz
         NQUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jfWog0ZrcaxHMuEqGhaifBshulfBgLxnbOipJlIL3fI=;
        b=YReAYjmi/5UmCUcVJC0ArGh1JJGWvBoYp4YmmWLysev72qqRK9GwWX/O2s4h28Wd15
         b6XR6mgV8fxjZYYg8iCDrFIIT926ieROkbcwPPE5K2UO5jTwTmXSjldAh7+ubtJ6FR9O
         Fb//AjANF/srbqE3Km7/gogxnCjJgDflMMAZuwRLCjVfzUH7pWVruPBmsVLAYa1i2F05
         pMiGK0oo0A1PIYfnkp/ObMlzSrTjUlOQfLL4iQ8G8AtVwDV2XP1Vy4HHlDEsc0qsA5+Y
         sjFXZzKDnPAdnfR/yk4rPtVuvvs9AbQWdZWEiUC2TD6wTI5g4rJCaHXYLTdpYE4kCCVU
         9hYw==
X-Gm-Message-State: AOAM530PoaVzxBzQkmqw0e5ui6vQF/i3K84n01BkCaGVtC28B1UCxv2S
        DGO6HK+HoQZ6zAGpwJOEiaGMiBZ+f9I=
X-Google-Smtp-Source: ABdhPJxwCBzxFArqsRtllH5S2pSy1syKHiqirj+O7FkN37SI/2kvOQ2XQiRlTh7HoI/84BifxobndA==
X-Received: by 2002:a17:906:1a11:: with SMTP id i17mr6590747ejf.381.1603880966732;
        Wed, 28 Oct 2020 03:29:26 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q19sm890797ejz.90.2020.10.28.03.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 03:29:26 -0700 (PDT)
Date:   Wed, 28 Oct 2020 12:29:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v7 3/8] net: dsa: Add DSA driver for Hirschmann
 Hellcreek switches
Message-ID: <20201028102924.s3dfuuogcso7idwb@skbuf>
References: <20201028074221.29326-1-kurt@linutronix.de>
 <20201028074221.29326-4-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028074221.29326-4-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 08:42:16AM +0100, Kurt Kanzenbach wrote:
> Add a basic DSA driver for Hirschmann Hellcreek switches. Those switches are
> implementing features needed for Time Sensitive Networking (TSN) such as support
> for the Time Precision Protocol and various shapers like the Time Aware Shaper.
> 
> This driver includes basic support for networking:
> 
>  * VLAN handling
>  * FDB handling
>  * Port statistics
>  * STP
>  * Phylink
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
