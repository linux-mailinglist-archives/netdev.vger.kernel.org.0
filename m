Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C67264A733
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbiLLShE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbiLLSg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:36:58 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1736D11C08;
        Mon, 12 Dec 2022 10:36:57 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id s5so14214823edc.12;
        Mon, 12 Dec 2022 10:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rN9HrhJGorMhLAYh3gvbHLJnLxFvXe7WSHGYbddfpHI=;
        b=NymybZQFWQLZb9uiHzpqjMtEA1Vp4tW3h5P8FCpncxIgO2C0Q3zCKkbE+X0JsbfO+w
         D8YvnOxmDoQdHDRPc5Gij9pgSPdER59XrBYW1Otx0uidH+5fkot5UwivF25CqfCdqlmd
         r3J4t/iKeR7M8wJE4ECtFK6m3cszTX02dte+PtO4c01fWHVK0wQ98lVGhbG5iOy2/4AC
         bUbZphVo3Rz7znO93tqBLsFNJ6iVOHyaDa1X9k2V73It45+e0JnI97l3VuwZ7chu+P8l
         Q602wezTpNpyvTDVcRDZTjGMd1tZnC78ZzPWoNEeg+G4M2wYa7TAJcurq/55YE1A0X8D
         ZN6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rN9HrhJGorMhLAYh3gvbHLJnLxFvXe7WSHGYbddfpHI=;
        b=BMRPw+x+azOxLMDG6lO1CvnsGk0oeW1A1B8TjUt2DDGHdjxehuBhEDre/eysblXp1I
         iXDuZC+HYkl+qk1Ys5Dq99gZA6uYXbI/bfJc6lJf6c1VWh2yvXMJQ90SoLc6KWVemB02
         kXrl9qu9sqJWpjJ2BwyrMg+0XU/77K3ky2IkM6UhjnupsODQU5JYDVFM55leO9FwisSZ
         unZ+8dx47cFgem+IOboRgNvFbnF1etzbcoQL0L7zuvfxwNJiKK/gAobszpSiAQSpa/sD
         NInho6ru3c5MwNbLWFFhgGYHDC1y7ZcumXVp//PL8qZZDz9vUgOncg6jeTK2DpMkx+jb
         qwXg==
X-Gm-Message-State: ANoB5pmkeIskq6nu29JBOqJgY1jtqKK8skXbrY4o2cxEwExyl6hWSYtY
        VZvOTewcR2ZuT0pvwvFZK/g=
X-Google-Smtp-Source: AA0mqf5vZA4IW7ixO6CVHL2IhOHlX1IzMN/2jZiuTrhAue4NogpmnwJfif/fMhTYF5zUhKBV/cl/hA==
X-Received: by 2002:a05:6402:1107:b0:468:3d69:ac85 with SMTP id u7-20020a056402110700b004683d69ac85mr14056162edv.27.1670870215530;
        Mon, 12 Dec 2022 10:36:55 -0800 (PST)
Received: from skbuf ([188.27.185.63])
        by smtp.gmail.com with ESMTPSA id e8-20020a056402148800b0046c5dda6b32sm4089730edv.31.2022.12.12.10.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 10:36:55 -0800 (PST)
Date:   Mon, 12 Dec 2022 20:36:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry.Ray@microchip.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jbe@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v5 5/6] dsa: lan9303: Determine CPU port based
 on dsa_switch ptr
Message-ID: <20221212183652.7wtzgcvtjgwsqwbr@skbuf>
References: <20221209224713.19980-1-jerry.ray@microchip.com>
 <20221209224713.19980-6-jerry.ray@microchip.com>
 <20221211224608.rdlcuqg4d37f7z66@skbuf>
 <MWHPR11MB1693284A37657C11F91ADFD0EFE29@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1693284A37657C11F91ADFD0EFE29@MWHPR11MB1693.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 05:42:01PM +0000, Jerry.Ray@microchip.com wrote:
> > It looks like there is potentially more code to unlock than this simple
> > API change, which is something you could look at.
> 
> I understand your point. The LAN9303 is very flexible, supporting an I2C
> method for managing the switch and allowing the xMII to operate as either
> MAC or PHY.
> 
> The original driver was written targeting the primary configuration most
> widely used by our customers. The host CPU has an xMII interface and the
> MDIO bus is used for control. Adding in the flexibility to support other
> configurations is something I will investigate as I expand the driver to
> support LAN9353/LAN9354/LAN9355 devices. Adding the
> private->info->supports_mii[] as was done in the ksz drivers is the most
> likely approach. I see this as a separate patch series.  Would you agree?
> 
> I will hardcode for port 0 at this point rather than looking at CPU port.

Yes, I think that would be ok. Thanks for at least not baking in any
more assumptions in the driver that already exist.
