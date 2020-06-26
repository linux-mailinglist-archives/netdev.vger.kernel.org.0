Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826E020B5A1
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgFZQHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgFZQH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 12:07:29 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3B4C03E979;
        Fri, 26 Jun 2020 09:07:29 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f18so9872031wml.3;
        Fri, 26 Jun 2020 09:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vfcHYp46j1WfUOi7vKspQV9Az5E6xO4ZTqEvKRNHDUk=;
        b=R3VZfIjAkn5iXQOyl+u1QIZmx9QX3OizHYnasCsBlJrOFSV7rmyrKL5nTLV1eq6zT5
         bS9jSm7r2rRIKHdEpwjgHviWB/oJssa35UAefXT8M5H5UA0GenffEaDxHJyDwsft+Z7J
         2e6OXeNMz9lVGqGzH3J+6vCZvnbg3l8Mpe+C/jEa3/FnQgBKjZlgcNt8CfbPJHXAbsea
         DDpHmmqLbxIcBoR0KWs4t1ANo9OsQ1GSCprw5KPHQvmBT8Y2qAPsTSibE7XR7jzbANSv
         ThxZ7LREBp+M6UhAYyLbTzBDWe6406vuy5rn0x1cRf0+uPS1YGmOLbxva2tzMNNm+D0m
         OKYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vfcHYp46j1WfUOi7vKspQV9Az5E6xO4ZTqEvKRNHDUk=;
        b=Vp1V2fnXWc3Vm87YSN3h61dxOuG7QUdTomtOoHUlQhk7+UqsKIPb5sRWULZOOrPA8w
         EP5t//d1E2lWv+EMTBr9TLro89PBMrCE34IwPQ6fg7GoOMV6pssHFQKX/9KDldmK5tnq
         kx/Iyn1xVKJtfMxMix4bb/Ly1o+Md0uSMURwhqSDMiGce2PvpvCLlhz56+1fs1kW/44y
         DyrjQq8VxoFw/tKkH/4ipf3zRwEGT7QDeu/O+pq+VabE59eAMQj3vjvPaIldUWZxWBhp
         7MsqOi3zS8hQWfETgGAe/wNHLNBoIGnSdJJ6DMhVh+6wT2dl5n9NHpiH0uYxEG9Ev98R
         G5RQ==
X-Gm-Message-State: AOAM533fcz+6NwlKjDwERhUEDLpuCEMpLxRmXYNrv4cmOLvXaDEl0eU2
        fgDMvl91zYCVC08yx1l0j/E=
X-Google-Smtp-Source: ABdhPJymaDXqJxZFKxMNTeOD1tWgjSvESTTrTOvrJl97iGQfGoq/on/7YR6Gx2ikONzKWidSD0FkEQ==
X-Received: by 2002:a1c:8094:: with SMTP id b142mr2470132wmd.122.1593187648473;
        Fri, 26 Jun 2020 09:07:28 -0700 (PDT)
Received: from [10.230.189.192] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z6sm13600436wmf.33.2020.06.26.09.07.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 09:07:27 -0700 (PDT)
Subject: Re: [PATCH 6/6] net: phy: mdio: reset MDIO devices even if probe() is
 not implemented
To:     Bartosz Golaszewski <brgl@bgdev.pl>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20200626155325.7021-1-brgl@bgdev.pl>
 <20200626155325.7021-7-brgl@bgdev.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <22760f15-656e-2adf-1d22-0a11065361fb@gmail.com>
Date:   Fri, 26 Jun 2020 09:07:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200626155325.7021-7-brgl@bgdev.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/26/2020 8:53 AM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> Similarily to PHY drivers - there's no reason to require probe() to be
> implemented in order to call mdio_device_reset(). MDIO devices can have
> resets defined without needing to do anything in probe().
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
