Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA991EFE0B
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 18:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgFEQbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 12:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgFEQbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 12:31:22 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2BBC08C5C2;
        Fri,  5 Jun 2020 09:31:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id h5so10393256wrc.7;
        Fri, 05 Jun 2020 09:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tnJpzhWA7Ow5rpChea8nQL5BENWe4py/tpyt2SDLkgU=;
        b=MtC6s3hN70DmpXVtkGnX2f9SwZdSG/5PrJd6bDF5goRu1A+ZebMFlfZUVkQ110OpqY
         NRB9/YkpxZ9pfMMq05iGuV4D22kZINJr/S7RPFrLUBk7j7JoUtP67bre1ZehL31M+Kex
         LSnsqIcHEm9SE4Texd4+Hbh++4U7A4ECbgIOcCI7/tAkkFZfyKZhehX/dGiTc9r9wMOP
         yj+ZsVXJU6WSxt5ITx9a88xJb9uWI6N4tH2RcCfDrllmxAvg05j0+LxJPu5GCHhoW2b8
         ysQEV4X5m94q5Ae2wkZ6PcwxsQFIBGuHR5giXmdkCOlhJAt11IykdiSQwd6UcrDw7+kM
         mQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tnJpzhWA7Ow5rpChea8nQL5BENWe4py/tpyt2SDLkgU=;
        b=YYMsrTM7gdzllYPJlFsGpC+z6SIPnc5nFx3gQpBJ2ysjZiNoB/ipRXEKU5VzTT6FYI
         qi8jVFGFRGloVpY3/zfk+7GGmYUgx1xUGfA50uULU4671uoGWqs01wtZg46fKSoLh9iQ
         G4EVerI9RyZJkPjlOItINsGIbc7rS0TIyn8Djsq7AoGpHTRm88qG44amIJd0r+TGgMIA
         vIR0cXYC7I2QK1IfmIdoseNzCBeLl2epkDAfkDuJz/yXhaufV48SwWZRv/D1vQuyZfbq
         cRgvbyrNop1swTKh5LTCAwXHlGMq3YslYkT/BuRXel4cRdjgacrbwib6ynLeIxWF4Xbg
         yCVw==
X-Gm-Message-State: AOAM530ogqm72EdIKAvr9GJQPizXL4l3OCDEP/2T9XknopvGJigMh5xL
        Tq28vtHXP1r2LsOhh5rEJE9jJY9e
X-Google-Smtp-Source: ABdhPJyfes6XkDwAUZ3XJ8PNopMdQxLGyj2oq8sNkiA1yS7ObxPWjDwyFSEJtyNlXLfRO+a3cAg97g==
X-Received: by 2002:adf:aad7:: with SMTP id i23mr10620083wrc.331.1591374679987;
        Fri, 05 Jun 2020 09:31:19 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s7sm13071670wrr.60.2020.06.05.09.31.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 09:31:19 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: mscc: fix Serdes configuration in
 vsc8584_config_init
To:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        andrew@lunn.ch, hkallweit1@gmail.com
Cc:     michael@walle.cc, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200605140009.1352990-1-antoine.tenart@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <164ccc63-e06a-bf54-c1db-1bb74e79f20f@gmail.com>
Date:   Fri, 5 Jun 2020 09:31:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200605140009.1352990-1-antoine.tenart@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/2020 7:00 AM, Antoine Tenart wrote:
> When converting the MSCC PHY driver to shared PHY packages, the Serdes
> configuration in vsc8584_config_init was modified to use 'base_addr'
> instead of 'base' as the port number. But 'base_addr' isn't equal to
> 'addr' for all PHYs inside the package, which leads to the Serdes still
> being enabled on those ports. This patch fixes it.
> 
> Fixes: deb04e9c0ff2 ("net: phy: mscc: use phy_package_shared")
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
