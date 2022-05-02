Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3705179CA
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 00:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242820AbiEBWLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 18:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiEBWLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 18:11:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38283B18;
        Mon,  2 May 2022 15:08:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5769B81A55;
        Mon,  2 May 2022 22:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA59C385B1;
        Mon,  2 May 2022 22:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651529281;
        bh=zNho/4N04+NeGQSzfupmpEQiwHYD9VHrhcjl2ZDwQlQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dytCZxrm5+zEAXJxCIuY6kac3Ch1OkjLqDmPFUUtvCxx0V5N7cQ392uHcVOoBgPkO
         bv2wneYfmOYipW3KNqDndzjMm8Naf99rMvpTuMcq9fnugQ4oktvtsbyQxJFOt5VeCB
         6nJX53GsaNvUWBL/C1kn3V14ot+OYCJYlL+6SE+c2llCW0rBI0uY91VlebPysmC0L5
         zW6qXKBxc7RENVhKQSjG4e7W2FEbY72jlGXvCwTKhipcXUuxAC+Vb/GclZD7ojzizo
         kQLn4ecwxD2ZRxkXpIFrUFepMtG4xMZMKR3MC2+ROu3caBsPt1fCOdxXz3h8exP7g2
         eBUZiZOpPakyA==
Date:   Mon, 2 May 2022 15:07:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [Patch net-next v12 05/13] net: dsa: microchip: add DSA support
 for microchip LAN937x
Message-ID: <20220502150759.06fe9393@kernel.org>
In-Reply-To: <20220502155848.30493-6-arun.ramadoss@microchip.com>
References: <20220502155848.30493-1-arun.ramadoss@microchip.com>
        <20220502155848.30493-6-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 May 2022 21:28:40 +0530 Arun Ramadoss wrote:
> Basic DSA driver support for lan937x and the device will be
> configured through SPI interface.
> 
> drivers/net/dsa/microchip/ path is already part of MAINTAINERS &
> the new files come under this path. Hence no update needed to the
> MAINTAINERS
> 
> Reused KSZ APIs for port_bridge_join() & port_bridge_leave() and
> added support for port_stp_state_set().
> 
> RGMII internal delay values for the mac is retrieved from
> rx-internal-delay-ps & tx-internal-delay-ps as per the feedback from
> v3 patch series.
> https://lore.kernel.org/netdev/20210802121550.gqgbipqdvp5x76ii@skbuf/
> 
> It supports standard delay 2ns only. If the property is not found, the
> value will be forced to 0.

Transient build failure here. Please allow 24h before posting v13 to
give a chance for additional feedback to come in.
