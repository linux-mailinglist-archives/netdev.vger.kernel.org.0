Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B5262AE6C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 23:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiKOWhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 17:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiKOWhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 17:37:37 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D76EC;
        Tue, 15 Nov 2022 14:37:36 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id kt23so39832142ejc.7;
        Tue, 15 Nov 2022 14:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UlKLpXR//UcwE/ngqXPZB9w8rILjc8ig1dwjMbGlblE=;
        b=kMTa+MZeE17QrUZWi6K9AcXDCmBcjcW50Yfy9xSM0YbLL9HanFo/1PlGq2PbXg6szW
         0Dqd9+8P4Vws5MExIT0uxrAMzWPHbrELHlTRhHBcPoBgclgNdCS38hZxluHaycmjyIXN
         MU8/+GOF5R2mWSvHY1r8ulLQalestU/jlYDECScaWPv9xS5UgPv0ejFdUEy08xG9wAN+
         LOxsIpRxJYzNiKOnMm5twcM8G1bBVEp5ckQRv4Ceon73B9/zAC8NncRy8NRtWC6kklCg
         4hHOERbtWdccJ+Wn/ts1QhTGSFuE2Rvrfg0EH8x8LNbO3YzfWYtwkNVVWkmhoApcogdE
         pRTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UlKLpXR//UcwE/ngqXPZB9w8rILjc8ig1dwjMbGlblE=;
        b=jSqbnhkAcEjxPREHNEDlrBVnbKKQMrYl+yMZGhZJ44twNVkZSdCNIG85TyWfkv61Ip
         nLaruQ0FxZHtrczL8LR8lb6YVEBni1frTeEpbAydgNHbdZ4NDPBibrsVbHCZZBBmjUTa
         XjwbS9vnN0LTlHxOfaMIxh/CSeSWj/53hbm/orsqb7XcyBazNHE/9s5JwV0dDs8bVwU1
         QUVQ5X9ls81qwO4XZH04ygRVx2TqKLFMKBezPwB6ygPOwZHwL//hrovo8l8YYnj4u57I
         2b9eWvyphiloEo1ocrKiNXaaLNMe3spclbm6NDipqvO7qiNL3bcDOw86Ue7bpy6VSMQ0
         SkQA==
X-Gm-Message-State: ANoB5pkVkl4RQuIlP1RHwRqFz93+RYtTMYjCYhJt2OLU53CA5bWwEHDC
        94ASCdMPcm1KoHLtoh2IVLU=
X-Google-Smtp-Source: AA0mqf4+0ElUFlItgyLfZQnyk9C8Rmdd55SKOsOqO3vWC00vjN4fBPfO+CwXQBeaOso4fzhNzH8yEg==
X-Received: by 2002:a17:906:1583:b0:7ad:923a:b849 with SMTP id k3-20020a170906158300b007ad923ab849mr15735274ejd.677.1668551854810;
        Tue, 15 Nov 2022 14:37:34 -0800 (PST)
Received: from skbuf ([188.26.57.19])
        by smtp.gmail.com with ESMTPSA id gv28-20020a1709072bdc00b007af75e6b6fesm1676789ejc.147.2022.11.15.14.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 14:37:34 -0800 (PST)
Date:   Wed, 16 Nov 2022 00:37:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] phy: aquantia: Configure SERDES mode by default
Message-ID: <20221115223732.ctvzjbpeaxulnm5l@skbuf>
References: <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221114210740.3332937-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221114210740.3332937-1-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 04:07:39PM -0500, Sean Anderson wrote:
> When autonegotiation completes, the phy interface will be set based on
> the global config register for that speed. If the SERDES mode is set to
> something which the MAC does not support, then the link will not come
> up. The register reference says that the SERDES mode should default to
> XFI, but for some phys lower speeds default to XFI/2 (5G XFI). To ensure
> the link comes up correctly, configure the SERDES mode.
> 
> We use the same configuration for all interfaces. We don't advertise
> any speeds faster than the interface mode, so they won't be selected.
> We default to pause-based rate adaptation, but enable USXGMII rate
> adaptation for USXGMII. I'm not sure if this is correct for
> SGMII; it might need USXGMII adaptation instead.
> 
> This effectively disables switching interface mode depending on the
> speed, in favor of using rate adaptation. If this is not desired, we
> would need some kind of API to configure things.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---

Was this patch tested and confirmed to do something sane on any platform
at all?
