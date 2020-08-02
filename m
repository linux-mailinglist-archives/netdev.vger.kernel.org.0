Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C061A235A59
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgHBUR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgHBUR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:17:56 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D32C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 13:17:56 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id kr4so7896597pjb.2
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=izCJhOGIu354j1uF+gtD3v3f21U9NHRh6uNsPAemTPQ=;
        b=KCVt6soJI6hU2wGvXNaEiX/U1Us6vDvxdwYsh4GWQLJAiaDraOZ62JgSlXYVrMmdb/
         tDMqFfzGC0IPzi4w+wYjrFpXC18x4GM8ddm/GjWjzbeTrNHlEx043nI2lgPYy0Aud4Dq
         9aHXFrx8c34i/sGB7DD7Vatvca/FvCZ8RkrI9Xk54ei6JrZ0YxJ+yw1dj4zQy0jhEwzJ
         dfLyZjI6ZQAPjBbfzw/yXuPFIS6FYVG87v3NBbu1/b+9DgPH35SCmEc5Iqv3jJSlkGv2
         AtivyQzYAyV9VY+A6h4jCZ2fj3Xl1jiesRSGVmpQczVC6VXIkorEs122NujZeWLT+AGI
         RTMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=izCJhOGIu354j1uF+gtD3v3f21U9NHRh6uNsPAemTPQ=;
        b=jN8xuiOjO8I2R5DDC1kUA9ltfr9Fm+kZvDRS+5gx6MNOl0qE/MwCPid7c19pvP3mjl
         xUTHlvLUGYlHwPMdyRLm6nIi0PsjZ/i/8fo0K20FGPyr8i7xLImIGvJMgszUp2PeCqAs
         mUsuiqBvQCnTDbZcS9CeOGswp2n25VmlfmF99mf2T9+7NwuZr8XPNqIwLA1Vte61FxES
         HMrSG8lqdXYx6LxVYuRUryp6ASEqfSQh9uQDjTIcatXgrd017uIe9hz2V+w3lFBdo1x+
         2yEPhO4AzcmiF6l8u2rCfPuHqGyHm8VS9OkmEnzb+YMEDpXW6AFyBgQqkv2914niKcgw
         ypIg==
X-Gm-Message-State: AOAM532EgA4bMhGD3844v/aRCIiESVl0AeVeBW+p+3jRC95rNFrCoY46
        4qItjIpi4fD+K0Op5SOWAAoMYiJl
X-Google-Smtp-Source: ABdhPJxjgwHWz3ue/kKRIH/f5d4h5Y0glzXWpQj+tqLUCXT3Iojp3IYn4OuU7/bBAK1Nws5leigwpA==
X-Received: by 2002:a17:90a:c295:: with SMTP id f21mr13887666pjt.208.1596399475274;
        Sun, 02 Aug 2020 13:17:55 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id w2sm15463004pjt.19.2020.08.02.13.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 13:17:54 -0700 (PDT)
Subject: Re: [PATCH v2 2/4 net-next] net: mdiobus: use flexible sleeping for
 reset-delay-us
To:     Bruno Thomsen <bruno.thomsen@gmail.com>,
        netdev <netdev@vger.kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Fabio Estevam <festevam@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
References: <20200730195749.4922-1-bruno.thomsen@gmail.com>
 <20200730195749.4922-3-bruno.thomsen@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0dd1461e-ef43-767e-bb22-658e4f9f8543@gmail.com>
Date:   Sun, 2 Aug 2020 13:17:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730195749.4922-3-bruno.thomsen@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 12:57 PM, Bruno Thomsen wrote:
> MDIO bus reset pulse width is created by using udelay()
> and that function might not be optimal depending on
> device tree value. By switching to the new fsleep() helper
> the correct delay function is called depending on
> delay length, e.g. udelay(), usleep_range() or msleep().
> 
> Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
