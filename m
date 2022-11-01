Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F4E6142CD
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 02:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiKABld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 21:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKABlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 21:41:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4582910050;
        Mon, 31 Oct 2022 18:41:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D49B2614E1;
        Tue,  1 Nov 2022 01:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CCAC433D6;
        Tue,  1 Nov 2022 01:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667266890;
        bh=XJvNcCvYTd4PK+vO4pqCyIW2MQydHQ5BXboQR88RVrI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ng5IKB72OvrAGnyyDLPsp+VJEDvkimJgEQ5XQs9rLxfH/2OVyZdacii0xI0OlpoGw
         ROslgGRfdYZZOh9H6G/swxBr9nFGNVSxJyGWLEO4Hz6KVFI9SOnoOTW91fo1091TnF
         mCKNYHVe9nCllh7xOnQfYedyII7LWbrx07rSr27Yz8qTSiqL/H/6hbV58ZR6jnpyXo
         Wu+q6tcCHdEcaJ1R9KZLJc545bPCwNlVDBmUAHmZZKVO4hpIy3SoXPS1xhzpwqgfYw
         kJSPv5NsIga5PV6bxwB2qp7BXnnoiWtu3tuviHu322iBWxuiM0b/MqSo7nteLJJ221
         fWaP/FKhuezTg==
Date:   Mon, 31 Oct 2022 18:41:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Casper Andersson <casper.casan@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "Wan Jiabing" <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next v2 2/5] net: microchip: sparx5: Adding more tc
 flower keys for the IS2 VCAP
Message-ID: <20221031184128.1143d51e@kernel.org>
In-Reply-To: <51622bfd3fe718139cece38493946c2860ebdf77.camel@microchip.com>
References: <20221028144540.3344995-1-steen.hegelund@microchip.com>
        <20221028144540.3344995-3-steen.hegelund@microchip.com>
        <20221031103747.uk76tudphqdo6uto@wse-c0155>
        <51622bfd3fe718139cece38493946c2860ebdf77.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Oct 2022 13:14:33 +0100 Steen Hegelund wrote:
> > I'm not able to get this working on PCB135. I tested the VLAN tags and
> > did not work either (did not test the rest). The example from the
> > previous patch series doesn't work either after applying this series.  

Previous series in this context means previous revision or something
that was already merged?

> tc filter add dev eth3 ingress chain 8000000 prio 10 handle 10 \

How are you using chains?

I thought you need to offload FLOW_ACTION_GOTO to get to a chain,
and I get no hits on this driver.
