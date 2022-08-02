Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F68587AF3
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 12:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbiHBKpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 06:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236527AbiHBKpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 06:45:17 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7012AE70;
        Tue,  2 Aug 2022 03:45:13 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gk3so13032514ejb.8;
        Tue, 02 Aug 2022 03:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oenn+FiW+EmD3MHwhqhbcKw9Wt4QMIp6R6VgPQG3nag=;
        b=MZ7uHB8f0y6ycIdy7TRMK6Dt9dO8yilcbejAaAajl2cYAzHvPURUcoruFruHzJEGAw
         hlOtHC9AxGaTWa/eCkofsyB6z71vY1HsaeFV4POJSEZEOoH9YQ/CaYm5Jqv0/HpdClLA
         Jt+go89uLDCOZolotkxbKUoAki6Pfln3AH6eL7TIBK1nox/lRePHQGySKnaC+U3JVV0d
         UdjwySaVjjinTSmurK8gzLk+shfqrANgK2mS7egM4XRKO96YDiKdbt6emmK4CjUl6gUy
         jLEQ8q3AGr3+4iAiC+m3UQHtbvyN7F3iWDZlDgdU/FypOfjFlOIydoS/qaG+UZwuEDLY
         kvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oenn+FiW+EmD3MHwhqhbcKw9Wt4QMIp6R6VgPQG3nag=;
        b=evtZ9vL/THVrvHXszylZRPVXXKM6zHgEMORJaJE2ZIBpx1nWJwjMjAnnDbiFx3ULXU
         Y7LfmaFhUm4MjrNDBNzaN5GznDNuITZ4cvtvGr2OgeSIvlHGlieIz6ZYMhIBUcrpz37v
         OAt0YxvyC+c2GZGM5eFDbXpaXF93NY7qbRkkmNVpdCtVBBEzfpZC2QRVLN4VGbqzDYAQ
         305QgF8mlJJW7k1KJKS8a1ssVQ2A3M9PpFxpgYLFdvUrODf53LUER88ZK4FOg/SayKC1
         adYrEgnpGuW36qLBFfqf0woExJSLfMM/XSwgMqjDTvpRNfSeAWWt40PhVcBQ6e40v7p7
         pLCA==
X-Gm-Message-State: ACgBeo0AqkjVVHgYBgFgGEtpyjQF0WmJgGuBbe7wSIhT2MWVVas7gh2o
        aP94U7r99zzHk9ExH8EirLE=
X-Google-Smtp-Source: AA6agR76Nk5v55OH/evza5QR+dErJD6Xlbe/slaMEmFODgf5j2TL22BbH/3BLIy+vph65nlquEP3vw==
X-Received: by 2002:a17:907:2be5:b0:730:82bf:93c8 with SMTP id gv37-20020a1709072be500b0073082bf93c8mr4188428ejc.686.1659437112021;
        Tue, 02 Aug 2022 03:45:12 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id u19-20020a05640207d300b00435a62d35b5sm8052798edy.45.2022.08.02.03.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 03:45:11 -0700 (PDT)
Date:   Tue, 2 Aug 2022 13:45:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [Patch RFC net-next 3/4] net: dsa: microchip: common ksz pvid
 get and set function
Message-ID: <20220802104508.oa33tftvmkpk7hzj@skbuf>
References: <20220729151733.6032-1-arun.ramadoss@microchip.com>
 <20220729151733.6032-1-arun.ramadoss@microchip.com>
 <20220729151733.6032-4-arun.ramadoss@microchip.com>
 <20220729151733.6032-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729151733.6032-4-arun.ramadoss@microchip.com>
 <20220729151733.6032-4-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 08:47:32PM +0530, Arun Ramadoss wrote:
> Add the helper function for getting and setting the pvid which will be
> common for all ksz switches
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
