Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAC163DD60
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 19:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiK3S0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 13:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiK3S0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 13:26:44 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E6D14039;
        Wed, 30 Nov 2022 10:26:43 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id z17so12924000qki.11;
        Wed, 30 Nov 2022 10:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FgdMCq+V+XgxrwzzGwB2JIJwQhAokuYjtod4U33OFXs=;
        b=SUhJVGr7UAz7Ej0sPcQ8gotPM+yu1ALclfoKnXiWCSIpBXCa+bSMh+vLBq+7LF+rm6
         CDMPdo/WS+CM+cnc0IzL/W8MXzdPuVaxIsvskKPGH0IisYAOwgQkpNiIhPTkMZKeMleU
         cpjfdndcLkEnezELSzrZ0aTtWO+XPerpAth3CQpsk6NWy6O8z8QMoZvQ97Q7UxzUpF2R
         LTK6Z3hZtsAZ/8TGeOfZBY3FuXVuBZZmLrmXwKZPBPHaAuzsJ7V9ZsdylLcWVLVmmxla
         8sIc/e4Q5Qk24NsQy/DSz7ukVeCY8mRKaagu90ZHIWwV4bqac49WzLzDathvJPjZ4LKk
         4BHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FgdMCq+V+XgxrwzzGwB2JIJwQhAokuYjtod4U33OFXs=;
        b=AxK8vfm+qCc2lJJRa6DJSWPgsjVJfXb5XGklzg97SEHR93pQ+ue3Aj4rI+5kT0EA+H
         mPoCNe58F2f+rtZx9R9UPjaJ9Eg3jGUYBibknkM1ql7XOAv/kIhn3PYVrrMGLRSLp+vA
         WDwzmmuPmbDippDUR8ItWh8kerUHUow3DmgheK5/WsgR9L69DEXyKAPXKx9a8/oIZr6U
         EyLlapMVYqMdRtHE5yET5U5q51Jd/p8RwVkHsAeYJ4JDwGPwtMBkk/uWyAQGtdGOqDzX
         JdzFBZS1HjWMuRL4IcKLCz5q6DlMcQI2CyY7Cki0UxHipoAzdFku6jgn6C92R2wpNYQu
         fEnQ==
X-Gm-Message-State: ANoB5pl0T78N7sMRU4zPnez0CfB7Ta2l0PKNlmOlUllJ5YHjAErrB7YJ
        Zxgj7j3IpMv0JctXsv9AmRbRu3jVBiiUycC1O3MHJg==
X-Google-Smtp-Source: AA0mqf7vkjOgDY11sqplhcgYEHUmHc8ODJNb2+SZ0TRQ43kninJgp8SMxRa/jO6WIrM6SSMnN1Tujw==
X-Received: by 2002:a37:c96:0:b0:6ed:9450:9f5 with SMTP id 144-20020a370c96000000b006ed945009f5mr55296215qkm.310.1669832802088;
        Wed, 30 Nov 2022 10:26:42 -0800 (PST)
Received: from cth-desktop-dorm.rtp.nc.cth451.me ([2605:a601:a674:c801:49d0:f39a:eef4:72e0])
        by smtp.gmail.com with ESMTPSA id l10-20020ac848ca000000b003a494b61e67sm1237579qtr.46.2022.11.30.10.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 10:26:41 -0800 (PST)
Date:   Wed, 30 Nov 2022 13:26:40 -0500
From:   Tianhao Chai <cth451@gmail.com>
To:     Brian Masney <bmasney@redhat.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: atlantic: fix check for invalid ethernet addresses
Message-ID: <20221130182640.GA394566@cth-desktop-dorm.rtp.nc.cth451.me>
References: <20221130174259.1591567-1-bmasney@redhat.com>
 <Y4eZg56XBWwR+pkr@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4eZg56XBWwR+pkr@x1>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 12:57:23PM -0500, Brian Masney wrote:
> I have a question about the original commit that introduced this check:
> 553217c24426 ("ethernet: aquantia: Try MAC address from device tree").
> The commit message talks about getting the MAC address from device tree,
> however I don't see any compatible lines in this driver, nor a
> of_match_table. As far as I can tell, this driver is only setup to be
> accessed over PCIe.

In aq_nic_ndev_register(), the code calls platform_get_ethdev_address(),
which in turn access the device tree via OF interface.

> The random MAC address is not ideal for our lab since we'd like to have
> stable addresses. I'd like to have the bootloader be able to inject a
> MAC address that's generated based on the board's serial number. I
> assume that it would go in the chosen node in device tree. One of the
> issues is that there are multiple NICs on this board, so I'm not sure
> how that would go in the chosen node and identify this particular NIC.
> Does anyone know of a place in the kernel where this is already done?

I'm not familar with this particular board, but this probably shouldn't
be done in kernel. AFAIK uboot allows overriding MAC with env 'ethaddr'.
uboot then either writes this MAC into DT or calls NIC specific code to
set the MAC into NIC memory before booting the kernel.

The other way around I can think of is to use systemd-networkd or some
other network management daemon to override the mac address as it tries
to establish a network connection. This might be less hassle if you
don't want to mess with the boot loader, but for embedded devices you'd
need a different root fs image for every board.

Acked-by: Tianhao Chai <cth451@gmail.com>
