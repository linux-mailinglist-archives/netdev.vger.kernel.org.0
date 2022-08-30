Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC0A5A7116
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 00:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiH3WrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 18:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbiH3Wq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 18:46:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBF01FCCA;
        Tue, 30 Aug 2022 15:46:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE58BB81CCF;
        Tue, 30 Aug 2022 22:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E09C433D6;
        Tue, 30 Aug 2022 22:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661899608;
        bh=sRQfd3t8ikdf4xmAsLXvULVmyxq4y/iCGVeLXFOzMQo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FcmehepTjSzgzzBk4HX9bw+civ6uk+OQdYhQoVvQZor7BPsyEKMBRUSls216TGoTr
         HKYiizmBd+c5NATDN1GEdAXTgiL2etmEWOzw2pMUAmlRpGkC3SGtIW/0UmuWgfS6dE
         I29Q2zkujJ+qXaiyGkes8bQYm5h/KYdlIhb7YmEnjtWc6NdDAKp+s/zu4GH2piZTEn
         RKvi7uSiBhcRqBiF/8uEerG27h3uuikWdk/+43ffT6SyE6rgWoXekDhq7+y897CY6E
         NaG6BykHM3AzhzmAX42XOGa7CVu06ggMMqoXpHrjn1IaeAGDAt/fU5gae4BqhUVdFG
         r6co0hltwQ+8w==
Date:   Tue, 30 Aug 2022 15:46:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        kernel test robot <lkp@intel.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v4 5/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <20220830154646.00a6b25f@kernel.org>
In-Reply-To: <20220828063021.3963761-6-o.rempel@pengutronix.de>
References: <20220828063021.3963761-1-o.rempel@pengutronix.de>
        <20220828063021.3963761-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Aug 2022 08:30:19 +0200 Oleksij Rempel wrote:
> +  ``ETHTOOL_A_PODL_PSE_ADMIN_STATE``          u8  Operational state of the PoDL
> +                                                  PSE functions
> +  ``ETHTOOL_A_PODL_PSE_PW_D_STATUS``          u8  power detection status of the
> +                                                  PoDL PSE.

If you don't mind a nit pick - u32 on these, netlink rounds up
attribute size to 4B, there's no difference in size for the two
so no point limiting ourselves.
