Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8AC697C52
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 13:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbjBOMwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 07:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbjBOMwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 07:52:23 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8AA3644D;
        Wed, 15 Feb 2023 04:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=WOYSFfQ0jaebxOnsbFhwjuQF7/Ba3lkdLaUdw2j21OU=; b=YW
        9DTzbhY2DetOrcc4Hed33WxxEKGNvz0hK6keVtjE5/ERT0v+4gUFRND5ckuuXGd4aFj2b3hYyd5P1
        wtPRv6SfTLZdggSPlNEcfSE5P+5t+F06Gwa44BPyXT8Xvxuvxs8JvVuHQ8YQas+MpgTTgxD7me6Ok
        lAHiNqbw2ixbsxc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSHGO-0053CA-4X; Wed, 15 Feb 2023 13:51:56 +0100
Date:   Wed, 15 Feb 2023 13:51:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Cc:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Subject: Re: [PATCH 08/12] net: stmmac: Add glue layer for StarFive JH7100 SoC
Message-ID: <Y+zVbPppy7jvWF5r@lunn.ch>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-9-cristian.ciocaltea@collabora.com>
 <Y+e+N/aiqCctIp6e@lunn.ch>
 <d1769dac-9e80-2f0d-6a5c-386ef70e1547@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d1769dac-9e80-2f0d-6a5c-386ef70e1547@collabora.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 02:08:01AM +0200, Cristian Ciocaltea wrote:
> On 2/11/23 18:11, Andrew Lunn wrote:
> > > +
> > > +#define JH7100_SYSMAIN_REGISTER28 0x70
> > > +/* The value below is not a typo, just really bad naming by StarFive ¯\_(ツ)_/¯ */
> > > +#define JH7100_SYSMAIN_REGISTER49 0xc8
> > 
> > Seems like the comment should be one line earlier?
> > 
> > There is value in basing the names on the datasheet, but you could
> > append something meaningful on the end:
> > 
> > #define JH7100_SYSMAIN_REGISTER49_DLYCHAIN 0xc8
> > 
> > ???
> 
> Unfortunately the JH7100 datasheet I have access to doesn't provide any
> information regarding the SYSCTRL-MAINSYS related registers. Maybe Emil
> could provide some details here?

If you have no reliable source of naming, just make a name up from how
the register is used. This is why i suggested adding _DLYCHAIN,
because that is what is written to it. You should be able to do the
same with register 28.

     Andrew
