Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4242565ED4E
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 14:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbjAENjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 08:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233815AbjAENj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 08:39:27 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED4134757;
        Thu,  5 Jan 2023 05:39:10 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id m18so89931071eji.5;
        Thu, 05 Jan 2023 05:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UgbHyDIg1UpvRWoP7FT1pLYch906VM3MibctMjquEGs=;
        b=YyDdvIrgCIZu26dMcsyngRC/Dhukn5+AlaEDZLLskx/G+QVE4wP7HCp3GTWk9fkFZQ
         0wW6wSGvHLIIHd0Iv/ReX4ODy5afy6+OaXgxp/44SinSwpWVE+pxOcNQ4YPD9hZ0w0ZO
         Guoh4klRUCz3jaQ/HCyKCMcc9iTmEtzU4OWTYeyXAEuJgZIi2Sx15tD3dfBMxUS+WwWn
         N9OZD6pdD9edxAH1X/gpKKeHOQeStqJYj1h/w3UePdi1JZ/URxCimyCXiagYhghov0Cu
         ul9r6bvX0LNWiSuc8HcVqA+hIN4FRIBXHU7PlTtYZTlOMKatXwiVrLajKGSsWgAxPhJf
         EKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UgbHyDIg1UpvRWoP7FT1pLYch906VM3MibctMjquEGs=;
        b=zbEVribF9obN3vSnGFnYEFHiaywck2hSHU9FMQgZfsM6UZRQz5fggku3TQUEu8i0Sn
         hlgdbxOrhdYU6bK3ZfSeEKV0PmvTrBvEGRtlalPCIyJIW/YdBPcrrEBlp8CT34FVNF1F
         O+HNSnYhandTfvYzJGgNWsFktSzbnciBEE65M+888j4cJS/Eh1lXBSL8KgNvjP7lP0l4
         ACuTKFklH5JMbyq42GeM+pvoQY89EdLrsWJffBmruMPvotfS0z9gw2hVhJAjVDciRQNp
         5UhFVWZPVC5sUAURV75Ai+1jZsHNIs9zXO0gAL2zvCZ7IgIDMvfn0S7wy5xY0iaH8+87
         eatw==
X-Gm-Message-State: AFqh2kpqDuxJdw+MCD1ACTrqaYCfx1CnaBJ6PpS89CEoUFQLmGvGx8nT
        1UzrGKouUm4YHlaPyW5xixw=
X-Google-Smtp-Source: AMrXdXvAHrW0gtWpfT6u/It9KMyxjm5r4CFgzqADETsHCfstdnNfvWo5fe+A0U+EZpmIDqXYBCThkw==
X-Received: by 2002:a17:906:7e46:b0:78d:f454:37a0 with SMTP id z6-20020a1709067e4600b0078df45437a0mr43665800ejr.67.1672925949228;
        Thu, 05 Jan 2023 05:39:09 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id o17-20020a1709062e9100b007bd9e683639sm16468173eji.130.2023.01.05.05.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 05:39:08 -0800 (PST)
Date:   Thu, 5 Jan 2023 15:39:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 0/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <20230105133906.srx57bkfdl4ey32f@skbuf>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103220511.3378316-1-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

On Tue, Jan 03, 2023 at 05:05:07PM -0500, Sean Anderson wrote:
> This attempts to address the problems first reported in [1]. Tim has an
> Aquantia phy where the firmware is set up to use "5G XFI" (underclocked
> 10GBASE-R) when rate adapting lower speeds. This results in us
> advertising that we support lower speeds and then failing to bring the
> link up. To avoid this, determine whether to enable rate adaptation
> based on what's programmed by the firmware. This is "the worst choice"
> [2], but we can't really do better until we have more insight into
> what the firmware is doing. At the very least, we can prevent bad
> firmware from causing us to advertise the wrong modes.

After this patch set, is there any reason why phydev->rate_matching
still exists and must be populated by the PHY driver?
