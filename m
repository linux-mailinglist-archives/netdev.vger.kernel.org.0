Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FE4315E13
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 05:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhBJEL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 23:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhBJELz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 23:11:55 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C405C061574
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 20:11:15 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id t2so409505pjq.2
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 20:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dSsKEsHIErouA8MxuxKRRYxE/J/wUAxMENdfMsld2QY=;
        b=KRDOmNnhuvqAA4cQz2N2XJpn1wLDOEGfiKMvYnx/qx3EkGo/9mWJNoZOIYnBL/I/Le
         f6CW9AMc8UcsaMAKDEfteKg1mFAId93s9yOY6CvLeL2IFxBn/qJNUSDc2lWRJpi8ERKE
         1VD7G6fsJ0qTrru7a9XFGRIdTSqnOEZm98pp/9WOH5iu8qFG1HP5rj/iJsU9MIvTWPd4
         wBXldCLWonLYcCortemLS9hBUj0QXVhY0257LzSgIOBKUKG8KO91LW4ImezZzvEzEzoE
         DycUDQNZ/or7tTKM9PqPeOUWBEe6rps9c+0H1exVH/SkciY5UbPfN57cP/WfyoXNMsLU
         jgSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dSsKEsHIErouA8MxuxKRRYxE/J/wUAxMENdfMsld2QY=;
        b=VbhAnoibpN1xoQuDKJ+5BGhWoBVWCW4QkViPsOzVJjIOzujqYFr0o5CBwisj52vTc3
         rQ6B1Y2qpCV5w2XENBHsjDie8+6d620dyfs1dXbnjFJwGTedrj8H5+Gget6ZqPYOvV4l
         I7KT2BwldyKNjmox2x/3dlOct2hQNkNJyXZO892bqtGntySXQqop5X8vs5h+zNB/1McQ
         xwrUsfgmpvF9HdbAHaE4ErEjZwZyG2KD6X+qQU3pVUBvCb1DmoWDdaXXmutMSphEFrZL
         JwW3wSKFr7QDvHc2FfLPuJp/CeTA6s0oRZNXMtphYDzX9Lkqa/ngM7YjZ5eDOPrE0DX3
         pLmw==
X-Gm-Message-State: AOAM533DnZ4eVZ4nkGLleh1hwYKPIn0bXygR0lo6LJOz7cyV08O+Z5Y7
        mmzI9jEI/I3QzF+bO2quBnZDhJM7nag=
X-Google-Smtp-Source: ABdhPJxi1JyToUIfHKrrZyqu1qfFd+v/5f2KDmK5lhsc45w3agHgdEaIdg+uA0pg4+KIcxHymdGOSw==
X-Received: by 2002:a17:903:2292:b029:de:45c0:7005 with SMTP id b18-20020a1709032292b02900de45c07005mr1308284plh.75.1612930274123;
        Tue, 09 Feb 2021 20:11:14 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15sm411544pfb.30.2021.02.09.20.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 20:11:13 -0800 (PST)
Subject: Re: [PATCH net-next v3 4/4] net: dsa: xrs700x: add HSR offloading
 support
To:     George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
References: <20210210010213.27553-1-george.mccollister@gmail.com>
 <20210210010213.27553-5-george.mccollister@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f5b361ec-c8a1-22b7-42b3-94fbe4387525@gmail.com>
Date:   Tue, 9 Feb 2021 20:11:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210010213.27553-5-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/9/2021 5:02 PM, George McCollister wrote:
> Add offloading for HSR/PRP (IEC 62439-3) tag insertion, tag removal
> forwarding and duplication supported by the xrs7000 series switches.
> 
> Only HSR v1 and PRP v1 are supported by the xrs7000 series switches (HSR
> v0 is not).
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---
[snip]
> +	val &= ~BIT(dsa_upstream_port(ds, port));
> +	regmap_write(priv->regmap, XRS_PORT_FWD_MASK(partner->index), val);
> +	regmap_write(priv->regmap, XRS_PORT_FWD_MASK(port), val);
> +
> +	regmap_fields_write(priv->ps_forward, partner->index,
> +			    XRS_PORT_FORWARDING);
> +	regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
> +
> +	hsr_pair[0] = port;
> +	hsr_pair[1] = partner->index;
> +	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
> +		slave = dsa_to_port(ds, hsr_pair[i])->slave;
> +		slave->features |= XRS7000X_SUPPORTED_HSR_FEATURES;

It's a bit weird to change the supported features while joining, usually
you set them ahead of time to indicate what you are capable of doing and
those can get toggled by user-space to enable/disable said feature, I
suppose the goal here is to influence the HSR data path's decisions to
insert or not tags so this may be okay. This does beg several questions:

- should slave->vlan_features also include that feature set somehow (can
I have a VLAN upper?)
- should there be a notifier running to advertise NETDEV_FEAT_CHANGE?
-- 
Florian
