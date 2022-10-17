Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F2E600B7A
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 11:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiJQJqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 05:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiJQJqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 05:46:06 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10BA5D124
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 02:45:47 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id q19so15188003edd.10
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 02:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9oP6QUpL/caecGh+0WuC4aINQ/RmOoPcukYan9ZNU8A=;
        b=WYJI6B+LFoT9C5pLnPBIsjhj7x8+qu2FF5XkqDkn1ip4p9bDsu+BpXi9K3KQ3vr7ru
         CZdyt+vMumrDGHiquIte3KHgxUQwII+snM62H3VKahAfK8P6Gb7q7p6c54lRE1kca74e
         /c1svg5jwc1DeNNT6EnZjI8Pj5eRER1qc+luhoEaxBHc+yzS3mBy/i1mgxWMBfuYgdto
         uL9RCFEYgl8N2raqVA3H1kgMvITCiJ1lRsczWLGDb7m5uDutUZwYlxq/WuFHWfgFuSpR
         nIkUHL4RFTBMv1ZIAk6ek6VhwkGhHVtxUHKrUN1GbKeMM7BtisjUKdeXeSTOI4hjZCuD
         WJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9oP6QUpL/caecGh+0WuC4aINQ/RmOoPcukYan9ZNU8A=;
        b=a2skgt3xeYSPCz20rGtS8WM7sfKGgwRDu6ssJedslQi1nJGBEND2/XCixdOK/wU4A7
         htUZ0jiCT3gK1g0u64rJwTrD85GUuZRRnjrpZ/I4D0jc/OaSFHTBFCihXUSfKkcaEz75
         AGqiSgqjW4mOGQs2tatK9gk8E5zzrXLdZmHnTZL4VrRw15eRUTbfcJkkJ+Us/OveNPSu
         X8/pvFGLEE3fT1yVU+RjnDtfc6Ig5nEl9H3sUNJjLzovo8rd/P20a/d/pwL5rjHHYICM
         xAuMNkY+M76WHYiGCWHDay++YyWpGYebMky0CCOJdCfbigL2iAPbOh4DrrlzxEElGQCG
         0YEw==
X-Gm-Message-State: ACrzQf02eM7GWVZaD4jLqqR5IWcGis1gtepSktbXAOrc3K0i1y7nxaoV
        BEky7AQ3x/siOUOXwJWYjWIvfg==
X-Google-Smtp-Source: AMsMyM7ybf4d3GEMPX9tQpDfqmEvIlvZLoJLY+kqbRjE8atQkVFhhK9MmY9m7VBJ5M4umfP70pcuhA==
X-Received: by 2002:a05:6402:169a:b0:458:fe61:d3b4 with SMTP id a26-20020a056402169a00b00458fe61d3b4mr9310127edv.140.1665999945458;
        Mon, 17 Oct 2022 02:45:45 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f19-20020a056402195300b00459cd13fd34sm7060877edz.85.2022.10.17.02.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 02:45:44 -0700 (PDT)
Date:   Mon, 17 Oct 2022 11:45:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: Multi-PHYs and multiple-ports bonding support
Message-ID: <Y00kRzNegS7Obptd@nanopsycho>
References: <20221017105100.0cb33490@pc-8.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017105100.0cb33490@pc-8.home>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 17, 2022 at 10:51:00AM CEST, maxime.chevallier@bootlin.com wrote:

[...]


>3) UAPI
>
>From userspace, we would need ways to list the ports, their state, and
>possibly to configure the bonding parameters. for now in ethtool, we
>don't have the notion of port at all, we just have 1 netdevice == 1
>port. Should we therefore create one netdevice per port ? or stick to
>that one interface and refer to its ports with some ethtool parameters ?

I don't like the idea of having 1 netdev per port. Netdev represents
mostly the MAC entity, and there is only one.

[...]

