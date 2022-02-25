Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099DB4C422B
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239455AbiBYKUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239399AbiBYKUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:20:52 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DFF1C2333
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:20:18 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id p15so9860968ejc.7
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B7uKk+WrkQiVBxJ429nBmWyoS/zfDQ6QyaaF7ny/QpI=;
        b=FEe2rihWrHBpiyLBMoiplMajT684Aok/iAgpWNL6uZb9RTg8XmrJejKDIgoS+8VA0Q
         bh6gGSlrDUSyRM5OxKY9U9BqH4Tr/ag9NxoDflg3b03vU7Xd9dOQuO3UlmXzhwlluJbp
         iAUK5u89RdF1bsjmnXR8rRv+5HbsfKu0Ib87p4YiIR2c0G4LlPORyF7tO6lza19Raxpb
         13PrufftBeMyW1VlX1m0PHhWP6/Cd8VZiNDgbpdpTlFgQ7LKxkgnP7sPjWspDaGfJzeI
         oXXorxURdaJb33RixbMUbjeX+NP+QBdEoMXt0SzxK/VzoOY+OTn7kTwi9usxinyQuZAO
         NZiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B7uKk+WrkQiVBxJ429nBmWyoS/zfDQ6QyaaF7ny/QpI=;
        b=da9UTiZAa0YgqwpsyMty/xIbiWI7mpBQO6FSkAXuAJElnteW7mcW+3AnIwQLSNG4sK
         FBd5wkiouta//uxy5bjwaV3EfLsqppg5SYNow3ok7IsuYyJiAS2YwfsuI1tZ7tIqtWhI
         j5AgAHrYDyNxF5HraCMA+60Vddhpb823uDeA0pCdjUYpwXpH9pbijDHYBc+TaK86ILL9
         m2UajlWDrND9hUYTSxWa8ured4gIyQku9TchFIWCXOnwqYdaQdpUWgD0AQnoGvsuZz8C
         whlgqEdxwN3OVNlX+hJKI4ZqjmN+RVDzWTVWXYtCYWc1ysnJv++s4YqfGKB479IHqktF
         2IUA==
X-Gm-Message-State: AOAM531jte/Y2CWCSIbjbWo+GW3cSDv1FFiIctsVLs45K3JJNZHGAfOf
        yEg89DZTbEqk+KsTpLS9Ems=
X-Google-Smtp-Source: ABdhPJxOZfP69vB3rqGyN2AN8Uyyr2Y86ACfpE6zMYhfepfs8oe0GjzvGvEVHu5Nr9W5RxECdSUUJg==
X-Received: by 2002:a17:906:4f0a:b0:6ce:e4fc:34d0 with SMTP id t10-20020a1709064f0a00b006cee4fc34d0mr5518708eju.717.1645784416642;
        Fri, 25 Feb 2022 02:20:16 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id ho12-20020a1709070e8c00b006ce3f158e87sm836891ejc.2.2022.02.25.02.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 02:20:16 -0800 (PST)
Date:   Fri, 25 Feb 2022 12:20:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 2/6] net: dsa: sja1105: remove interface
 checks
Message-ID: <20220225102015.jj3cgnkfpyaoeptp@skbuf>
References: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
 <E1nNGm1-00AOij-3q@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nNGm1-00AOij-3q@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 04:15:21PM +0000, Russell King (Oracle) wrote:
> When the supported interfaces bitmap is populated, phylink will itself
> check that the interface mode is present in this bitmap. Drivers no
> longer need to perform this check themselves. Remove these checks.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
