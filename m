Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30084E304C
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352350AbiCUS5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352348AbiCUS5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:57:05 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC2E30F6C;
        Mon, 21 Mar 2022 11:55:39 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id qa43so31624728ejc.12;
        Mon, 21 Mar 2022 11:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MR3IOnVCT9LNbOXV1BxoBiVDyI2EWB+kNyThZIDjlYM=;
        b=MtPDtLvcUcuCe3//kEpt8NRcCw3Q5diSr4hNsmz3s4WXTEO9ks55QSAXiAxH2+XWol
         wWB0TeZt50HBoV4u2n2plae25gCvS16qmNbRszZDKnPMbENapZs7dikJO/XqmtDSK4MG
         +R0FjKZUd+aLMsbwbcqzmjtvUMw121ApdOS2zwzsUFZ5T0UPU9bWjVNpom4OCPCtQ9dc
         Tef4hpHexzT2J8+Qw9U2raMBpzX9R+CxDmnQsTL9erz6hHqMtf9ZJXUvgoOPK9Wi/KSr
         DFpPHlk4i/4ORbXv6l/JX2T83fOBFf+j4u5jn+Ztv8Q1H26OqykEeiuGDZF/aEz8EgVO
         OU0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MR3IOnVCT9LNbOXV1BxoBiVDyI2EWB+kNyThZIDjlYM=;
        b=JU/nRZfWyGiIgN0Bg+ghvvwcIGKJeqaJ7WLA8F7vnpPS/SMUFdm8qlyXL3Rbklfgcp
         QeueIslVbsClWDR/A93ca3Tx6FdLOauN2a3W5SyhNDOn3vAht5+O3ghNGSPSSPq/1mCw
         twfFyPozxg8n0TKyuJ5ZtfFCFlfjeaDq11mlvE4ejm46yj4niqSINy+0+WhbOEgdhuMo
         Sm2uTrO4M5N/eYgxnbZ07ha2r6/CaKQ5NOpyCX6ScSNa/8f3kcV/KwG99HTSeyMmB2nB
         XqAAH40QxK71qShALEUM84fm9YOUzwvaqrr1GeF180BJvS7MSiev8Bi0epc1g+YlS9CU
         KrmA==
X-Gm-Message-State: AOAM531ssN79BgwdXQX+QNo8lZMfYPwTYqu/bAZzYDKwU4kVciVDY5oj
        s8E/2Jhth4klqaVE+LE6sCs=
X-Google-Smtp-Source: ABdhPJzK8P4HgEoQttDXc91OpVsqKWzmYVLQdNb9hOs0plYsrOnUMdyAZv6IJt7myDc9JWlhKOAduw==
X-Received: by 2002:a17:906:c113:b0:6d7:7b53:9cb with SMTP id do19-20020a170906c11300b006d77b5309cbmr22986911ejc.197.1647888937788;
        Mon, 21 Mar 2022 11:55:37 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id j22-20020a50ed16000000b00419366b2146sm2086062eds.43.2022.03.21.11.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 11:55:37 -0700 (PDT)
Date:   Mon, 21 Mar 2022 20:55:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2] net: dsa: qca8k: pack driver struct and
 improve cache use
Message-ID: <20220321185536.wabc2aw3j3doy7ih@skbuf>
References: <20220228110408.4903-1-ansuelsmth@gmail.com>
 <20220303015327.k3fqkkxunm6kihjl@skbuf>
 <Yjii20KryAsEQp1k@Ansuel-xps.localdomain>
 <20220321172200.eaccmwzfvtw7bjs2@skbuf>
 <Yji1QAMe/efWLBQE@Ansuel-xps.localdomain>
 <Yji2b6XF13E1o2x3@Ansuel-xps.localdomain>
 <20220321182226.zx2fqlntaxd7snup@skbuf>
 <Yji+j8slhKynLJIv@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yji+j8slhKynLJIv@Ansuel-xps.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 07:06:07PM +0100, Ansuel Smith wrote:
> > If you provide your own ds->slave_mii_bus there should be no reason to
> > need a ds->ops->phy_read, since your slave_mii_bus already has one.
> > 
> > Bottom line, phy_read is just there in case they it is helpful.
> > Whereas ds->slave_mii_bus is there if you want to have a non-OF based
> > phy_connect, with the implicit assumption that the phy_addr is equal to
> > the port, and it can't be in any other way.
> > 
> > So if ds->ops->phy_read / ds->ops->phy_write aren't useful, don't use them.
> > I suppose one of the drivers you saw with "custom mdiobus" was sja1105.
> > I have no interest whatsoever in converting that driver to use
> > ds->slave_mii_bus or ds->phy_read.
> 
> My idea was to provide some type of API where the switch insert some
> type of data and DSA decide to declare a dsa mdiobus or a
> dedicated one based on the config provided. Think I will have to provide
> an RFC to better describe this idea. The idea would be to drop phy_read
> and phy_write and replace them with a single op that provide a
> configuration.

Just register a non-OF based MDIO bus for the legacy_phy_port_mapping = true
case using plain mdiobus_register() and provide it to ds->slave_mii_bus,
and delete the ds->ops->phy_read and ds->ops->phy_write, instead
adapting qca8k_phy_read and qca8k_phy_write to be your bus->read and
bus->write. Problem solved. No need to touch the existing logic and
implicitly the other drivers that use it.
