Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F6A4F86B9
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbiDGR7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiDGR7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:59:40 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CF122F3DA
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 10:57:39 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q19so5578216pgm.6
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 10:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9Lmir/3pCfgeTnn9ZBjEAKgqHQ0smFo5TjXcj/fKooE=;
        b=HYgBzkUSRIFG+C+mXuXArA002K7sFf7LHSsq98t7n9neqs573Io/Q/7frHVoctLOXu
         rHR+qSOnuLDS0oYX+puML796zyD/vD0JE968FPVaysc0ljS+VDTNjrXC3pyxxjScH+Zv
         rbqd7qdPhchfwnlKpEjrWGpcmY4KpfKb+pNbSmmPuObo7Zjw66tVZ6zQMhE9R6eeSIJl
         L74wsons8D/BQxgXWiFsixARHuZLb0T0JmdJA6fQRQQg2ea0Ah8NqAM2ZBwYwBQ8Ahbv
         7t1NS6O9wHPJu+4+epDTOo4DfMKBChJI4QFXIMxxui0O1FASw1l/7r5Fl0YIRdflgYD6
         6Stg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9Lmir/3pCfgeTnn9ZBjEAKgqHQ0smFo5TjXcj/fKooE=;
        b=Mo2uymg/+ROYfe11zdZt/xFOmzS1YGPcuXl/APLhOaCGpbt24ANQpNXNvO812JYGp4
         oEyOXVg0/r07j92NBRE7G2ypNgAF/5hYwunorBdPOQ47PDhmaERPAmTlrdOXZ3RgsJJ7
         yJ6Zb3HGLQjzaVDH1QSbo7XYanxSTya9s202IU68MmrgzX+8mS0hFhf7O7JjROi9Vi64
         sxocx3pmwcAhr0iQ1dbM3YPx3o/hTxYVtN9cFKDARBYYwHHHfzMzDP0XTj6IJn0dJCdD
         icxzh/NiQWsrM+4hb+KMkYwo3idx+wnBsbPHk+8PzAUVl2tWXgRoiy1FaFhzqs5CxXHu
         VeKw==
X-Gm-Message-State: AOAM5304HuVmiSK9sd4fSa1jcMDCcT97R5PH5Ieay76kwIiiS5nivOSa
        NZ7voQOv0JzE9DZxEvrwlUQ=
X-Google-Smtp-Source: ABdhPJwXNYGGIL3MwwcZTV47UD8Hdabd7z7rVaXUd8EN8e5Nd3OeP3KXmGnPAjX9yGDJ5wH0rSwlfw==
X-Received: by 2002:a65:604b:0:b0:398:ebeb:ad8f with SMTP id a11-20020a65604b000000b00398ebebad8fmr12523037pgp.89.1649354259285;
        Thu, 07 Apr 2022 10:57:39 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u18-20020a056a00125200b004fb112ee9b7sm21272739pfi.75.2022.04.07.10.57.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 10:57:38 -0700 (PDT)
Message-ID: <94b897a1-2f5a-f290-7d8c-333d61ca5e5c@gmail.com>
Date:   Thu, 7 Apr 2022 10:57:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net] net: mdio: don't defer probe forever if PHY IRQ
 provider is missing
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Saravana Kannan <saravanak@google.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
References: <20220407165538.4084809-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220407165538.4084809-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/22 09:55, Vladimir Oltean wrote:
> When a driver for an interrupt controller is missing, of_irq_get()
> returns -EPROBE_DEFER ad infinitum, causing
> fwnode_mdiobus_phy_device_register(), and ultimately, the entire
> of_mdiobus_register() call, to fail. In turn, any phy_connect() call
> towards a PHY on this MDIO bus will also fail.
> 
> This is not what is expected to happen, because the PHY library falls
> back to poll mode when of_irq_get() returns a hard error code, and the
> MDIO bus, PHY and attached Ethernet controller work fine, albeit
> suboptimally, when the PHY library polls for link status. However,
> -EPROBE_DEFER has special handling given the assumption that at some
> point probe deferral will stop, and the driver for the supplier will
> kick in and create the IRQ domain.
> 
> Reasons for which the interrupt controller may be missing:
> 
> - It is not yet written. This may happen if a more recent DT blob (with
>    an interrupt-parent for the PHY) is used to boot an old kernel where
>    the driver didn't exist, and that kernel worked with the
>    vintage-correct DT blob using poll mode.
> 
> - It is compiled out. Behavior is the same as above.
> 
> - It is compiled as a module. The kernel will wait for a number of
>    seconds specified in the "deferred_probe_timeout" boot parameter for
>    user space to load the required module. The current default is 0,
>    which times out at the end of initcalls. It is possible that this
>    might cause regressions unless users adjust this boot parameter.
> 
> The proposed solution is to use the driver_deferred_probe_check_state()
> helper function provided by the driver core, which gives up after some
> -EPROBE_DEFER attempts, taking "deferred_probe_timeout" into consideration.
> The return code is changed from -EPROBE_DEFER into -ENODEV or
> -ETIMEDOUT, depending on whether the kernel is compiled with support for
> modules or not.
> 
> Fixes: 66bdede495c7 ("of_mdio: Fix broken PHY IRQ in case of probe deferral")
> Suggested-by: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
