Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CE75A904A
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 09:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbiIAH3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 03:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbiIAH2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 03:28:24 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473E312CB13
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 00:26:22 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id u18so8437400wrq.10
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 00:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=6URCR0Wpeb5bQwy5urRdO0hju2iSMx2+jAWiT1nTtYU=;
        b=i9ZaVzgL8K3GGHTwz2QyJmc8n7L7qiM/bBnfx/nSkWGefaZQ4zA/eCl/SUs++RWrW+
         9kln9KIUdPPWlFXp8r53l8+ZxNmLb6Fu85zL9/ifiDdm1BBcnglO/sKPceEDzdAwhOFq
         59mXVSFlC6SaaTzMEld8AvynlHJpUj6bRDvwDHazLlZhEKl9EGKh7LRhEOTiAefzSfHS
         u+b7bQPpe5g7XGtuSWGUUDtnWQBHGr6cPMSAsZCkvatNduKM1t9WPbaWt36CwMYL82XM
         Mnn5lvLYn+50F5jsJ384+PwWdxp54C9SYkscTd5A0DOC3SIKRXiLeiAgfiJrn7GtjKuN
         Tu5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=6URCR0Wpeb5bQwy5urRdO0hju2iSMx2+jAWiT1nTtYU=;
        b=azjkxoYaXo7BJKhi5+EF1DK9lZacPplccosqi7Ijc0nOLxrJjp6UPrCdF/KCvF8Sp0
         z8S5xBXyGMK6d/Og4tuNeCM7mH5RHimD8qK0MC7BfulBdyYVPo2Up8SRgvZiNb7wPBn8
         mtkt/+IJzNzzxqfP/PTkNhcgKI7Jf6o91B/YlcRGp+WvJgaAXQhlsLXJQ/I6LdRLW6N4
         m0k9CJD37iJZ8OhKP42vNd4snM2VnKNBQCASipGsfpkTsN7zpBAMUvQCS8nPXe5CfZqn
         B1/eouMMDpXcppKYq9zclUAttuwm15nuWF+Hh+SoaaRtzhifEdXjorMBURIcOTg5ImlO
         sKgw==
X-Gm-Message-State: ACgBeo1pcP2D6L21b0a6WRB+hDBzlRAthziQtVLCqt36WuaDQQWc94Hf
        os7MGewcUoPaO65t937JraVzTkV6IcH+l/kAmrXOGA==
X-Google-Smtp-Source: AA6agR4uWYbjZlVSMUEptQVzKN0UtnQh2gv8/PRyEudCuSAsJ2mxPXVlecKHf7qG3XkS1wn1a3vxDtN4k03iipWQw0Q=
X-Received: by 2002:a05:6000:1549:b0:225:652e:45d4 with SMTP id
 9-20020a056000154900b00225652e45d4mr14211030wry.15.1662017179994; Thu, 01 Sep
 2022 00:26:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220829065044.1736-1-anand@edgeble.ai> <20220829065044.1736-2-anand@edgeble.ai>
 <Ywy6o2d9j4Z7+WYX@lunn.ch>
In-Reply-To: <Ywy6o2d9j4Z7+WYX@lunn.ch>
From:   Jagan Teki <jagan@edgeble.ai>
Date:   Thu, 1 Sep 2022 12:56:09 +0530
Message-ID: <CA+VMnFzNcPesS8Mn2mwr-RDXf5sRz-2A3K+syDmpCo1va6JwMw@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: ethernet: stmicro: stmmac: dwmac-rk: Add rv1126 support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Anand Moon <anand@edgeble.ai>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Sugar Zhang <sugar.zhang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Aug 2022 at 18:40, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Aug 29, 2022 at 06:50:42AM +0000, Anand Moon wrote:
> > Rockchip RV1126 has GMAC 10/100/1000M ethernet controller
> > via RGMII and RMII interfaces are configured via M0 and M1 pinmux.
> >
> > This patch adds rv1126 support by adding delay lines of M0 and M1
> > simultaneously.
>
> What does 'delay lines' mean with respect to RGMII?

These are MAC receive clock delay lengths.

>
> The RGMII signals need a 2ns delay between the clock and the data
> lines. There are three places this can happen:
>
> 1) In the PHY
> 2) Extra long lines on the PCB
> 3) In the MAC
>
> Generally, 1) is used, and controlled via phy-mode. A value of
> PHY_INTERFACE_MODE_RGMII_ID passed to the PHY driver means it will add
> these delays.
>
> You don't want both the MAC and the PHY adding delays.

Yes, but these are specific to MAC, not related to PHY delays. Similar
to what is there in other Rockchip SoC families like RK3366, 3368,
3399, 3128, but these MAC clock delay lengths are grouped based on the
iomux group in RV1126. We have iomux group 0 (M0) and group 1 (M1), so
the rgmii has to set these lengths irrespective of whether PHY add's
or not.

Thanks,
Jagan.
