Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FC764F8A5
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 11:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiLQKMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 05:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiLQKMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 05:12:21 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE92F0C;
        Sat, 17 Dec 2022 02:12:19 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id c17so6724763edj.13;
        Sat, 17 Dec 2022 02:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wbVpRMWXESzu5NAY6mXI8/BEnKg4q4m/hRyd9McQmxQ=;
        b=ePvkIUmHJqNzuxqHUAr5wT4c7TevNdZVRHpbJ9K35I1EaJbNWlM8kD7KT/boIdQOKW
         UHjOpVjfzNVg/+g775Q4Gg5LMnBPUimlZOzoUkVwyhKIJy4WLvh3XOuDAssvn3E7waqy
         rjZIWyRIdHXtMmCQhv5Sv6XqgRwjHHXt85eMN/tts656knw4V3vEuLL7Gc2mqh27IpOy
         V1EVvCAAnVs0GVE5HScgyFNNg1XV5zcD92/0dnEgUey+n4Yx2NvPCgGG4U0S4zTP177d
         QbUs1zVAIkIDNkH6UCcWbe46+h2XRtXbhkNGhRop+SsQlq+SfT6g83NUq4iBgAecGCPa
         O4fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wbVpRMWXESzu5NAY6mXI8/BEnKg4q4m/hRyd9McQmxQ=;
        b=hpeYoy/2iis0EjtgaFVz9tco4qDl3UviVS+iULd54x+IbMMObgbNJxIDOcxo0L9ukF
         hFUnhuUsf06he+dj0EYaKBdF4gw/Piz02m4NDOypUUFbOTz4fwYglfWgs+qhDTHC00qH
         QgyysVagF8jVNgMML4R4b7mhLQbSi+JNPbypxK3Re2B9NnDQtQmlYVt6yc81x3aqVKAb
         z326gUr1MpG/iQkqIUb6uQS9fNsl8ciKpAM+giFNLkvIWrLWU99dqmoJN9ZfzD3RVIWp
         CbYbcT9K/2IciAmaOawCUCCImVFC4VMrhUYknBQbc1u/F0dzJSXAnNBC0yBrTs8LslJ4
         WjWQ==
X-Gm-Message-State: ANoB5pmHrW+54Oc6IqC9SKaxt3j18O2qsy2MSDIn3eing+qpaNIUNkHN
        1dOaLHDuU1eFfi4Md3Izkts=
X-Google-Smtp-Source: AA0mqf6mpJtVKlszW7Ag7M/Z1xrOVkRIYfyDBcpoyl+2msPA7ToGMnkomuQHUPnCuh5Jmn1M6yusKg==
X-Received: by 2002:a05:6402:3886:b0:462:330a:ce30 with SMTP id fd6-20020a056402388600b00462330ace30mr30068831edb.2.1671271938165;
        Sat, 17 Dec 2022 02:12:18 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id cq21-20020a056402221500b004678b543163sm1858683edb.0.2022.12.17.02.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 02:12:17 -0800 (PST)
Date:   Sat, 17 Dec 2022 11:12:14 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v7 net-next 2/5] drivers/net/phy: add the link modes for
 the 10BASE-T1S Ethernet PHY
Message-ID: <Y52V/l2BG1WlHdft@gvm01>
References: <cover.1671234284.git.piergiorgio.beruto@gmail.com>
 <fb30ee5dae667a5dfb398171263be7edca6b6b87.1671234284.git.piergiorgio.beruto@gmail.com>
 <20221216204808.4299a21e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216204808.4299a21e@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 08:48:08PM -0800, Jakub Kicinski wrote:
> On Sat, 17 Dec 2022 01:48:33 +0100 Piergiorgio Beruto wrote:
> > +const int phy_basic_t1s_p2mp_features_array[2] = {
> > +	ETHTOOL_LINK_MODE_TP_BIT,
> > +	ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
> > +};
> > +EXPORT_SYMBOL_GPL(phy_basic_t1s_p2mp_features_array);
> 
> Should this be exported? It's not listed in the header.
In my understanding PHY drivers can be compiled as modules, therefore
this should be exported? I see other features arrays being exported as
well. But If I'm overlooking something I'll be happy to change this.

Thanks,
Piergiorgio
