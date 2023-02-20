Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493B069D43D
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 20:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbjBTTl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 14:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjBTTl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 14:41:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5033122793;
        Mon, 20 Feb 2023 11:40:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC74060E9B;
        Mon, 20 Feb 2023 19:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBBAC433EF;
        Mon, 20 Feb 2023 19:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676922018;
        bh=YJ5kJ4vkFCQ16X2IONf54Y/l4uUJnjGgf7NKBiwI380=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CbiGJ6GDUR7jHG+eDUsEysOa1xu+B6zcw17RR0JddkMTyYFPzkS/6OswFPKcTEK/w
         YZqxlMHSs9X5x0x2lW+BUqxt6VvELOZa4bbt6tNVZa7d0DFEhFRzyNLT2614LzMi/H
         dKfv8VTq/gA3kFyxlU7y2wHm3IML197ebqln04pD7e1U98F5tPtKWd+pxYFnf283bG
         v8iAdnsTf+Ho6/jQjHKCVUYTb1/xz79GCGO/B3EH+cwfuM6C4Jo1LgGBtFKWUG6oRC
         1pQUmAbMn5htEauAZxFph6kwtpxDsfriDHTDF76ShoIEtCagODtXjn8oaWY0IUnmIm
         SakJHejm7u1ug==
Date:   Mon, 20 Feb 2023 11:40:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Janne Grunau <j@jannau.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?UTF-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Ley Foon Tan <lftan@altera.com>,
        Chee Nouk Phoon <cnphoon@altera.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 0/4] dt-bindings: net: Add network-class.yaml schema
Message-ID: <20230220114016.71628270@kernel.org>
In-Reply-To: <20230203-dt-bindings-network-class-v2-0-499686795073@jannau.net>
References: <20230203-dt-bindings-network-class-v2-0-499686795073@jannau.net>
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

On Sun, 12 Feb 2023 13:16:28 +0100 Janne Grunau wrote:
> The Devicetree Specification, Release v0.3 specifies in section 4.3.1
> a "Network Class Binding". This covers MAC address and maximal frame
> size properties. "local-mac-address" and "mac-address" with a fixed
> "address-size" of 48 bits are already in the ethernet-controller.yaml
> schema so move those over.
> 
> Keep "address-size" fixed to 48 bits as it's unclear if network protocols
> using 64-bit mac addresses like ZigBee, 6LoWPAN and others are relevant for
> this binding. This allows mac address array size validation for ethernet
> and wireless lan devices.
> 
> "max-frame-size" in the Devicetree Specification is written to cover the
> whole layer 2 ethernet frame but actual use for this property is the
> payload size. Keep the description from ethernet-controller.yaml which
> specifies the property as MTU.

Rob, Krzysztof - is this one on your todo list? It's been hanging
around in my queue, I'm worried I missed some related conversation.
