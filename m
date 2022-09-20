Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6305BD98F
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiITBnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiITBnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:43:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C9F51A19;
        Mon, 19 Sep 2022 18:41:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD15561FBE;
        Tue, 20 Sep 2022 01:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0D0C433D6;
        Tue, 20 Sep 2022 01:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663638105;
        bh=sf8a5VfaBMwyro/v9i8hYJc/kKQUtjVhSTDxLz1J1/g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ap4mJP+JQJU6yQKlMdJw/+H3ZNxTJcTDY0JW8h23Thz/E+OrcVGARyjtCkBOJBCYT
         9ipT7vq0A2jai+lfNTJ3o6smTxCmDMCfaOkDghJhtmrW77dGcGDZY61ufjC1huvuwh
         nTcSLYHVqYZyMYtj1y8V9Ftjxo+BmV4eSQD4onf+OztteH7QSGBZmjANl/UZ6PiGsV
         vI8hg6M/uTWA5WG3eR/k3imebDXyLnMieSJjlu/3aJ9M3hr4dy5HN8GoQ9sMz+pzvh
         B6/R18SAXmho/RxeBy1VFvsVjfkd3Ex2HebLZq2exs9tZYOC24dzweASLhbu86AdW7
         3hlPEQU2KEg/A==
Date:   Mon, 19 Sep 2022 18:41:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <horatiu.vultur@microchip.com>,
        <casper.casan@gmail.com>, <rmk+kernel@armlinux.org.uk>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next 2/5] net: microchip: sparx5: add support for
 offloading mqprio qdisc
Message-ID: <20220919184143.21e3b355@kernel.org>
In-Reply-To: <20220919120215.3815696-3-daniel.machon@microchip.com>
References: <20220919120215.3815696-1-daniel.machon@microchip.com>
        <20220919120215.3815696-3-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Sep 2022 14:02:12 +0200 Daniel Machon wrote:
> +#include "sparx5_main.h"

This is missing

#include "sparx5_qos.h"

otherwise we get a compiler warning on this patch

> +int sparx5_tc_mqprio_add(struct net_device *ndev, u8 num_tc)
