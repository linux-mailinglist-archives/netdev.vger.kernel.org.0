Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F1A5F17D0
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 03:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbiJABBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 21:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbiJABAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 21:00:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6377962C
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 17:59:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CB5660BC7
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 00:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3115C433D6;
        Sat,  1 Oct 2022 00:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664585983;
        bh=V1d8o4cuVLbPRw3xs5Z0YD2UtCx1P6AZ5xZiEnBBt6o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rQia9DIMizXdYpp8B0wQ4TjMIwUZHOtvbSegVmtezKXkGPhd81dciY97dGFRj460O
         3+j3yYxbp1yvE82M3YKbGtV6Akfz8VTnrDFM9+T4vgoWYSIAs5fKd5L3wHpr6oz9Ja
         RM5cGTEjXxCZ1GAEcSBpx9+8EcjwleZq3Mh+aeAHsoftNohpb9GkP7iG0CoT/Yb4kh
         3i4tXcJ1cAmQ0jDc6v5CBQO1fPoidpMoVDSzFNg6Krcli6MTESlUu/vXraqmbWuQOp
         XKMuhAL3KkdC5TxcBhIlU2pfjO21W/MgDZeDKZMiEVKVEnXdztim0XuJFK4rc+xF3d
         +WQzzQt6hgkvg==
Date:   Fri, 30 Sep 2022 17:59:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Yang <mmyangfl@gmail.com>
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v4] net: mv643xx_eth: support MII/GMII/RGMII modes for
 Kirkwood
Message-ID: <20220930175942.76db1900@kernel.org>
In-Reply-To: <20220930222540.966357-1-mmyangfl@gmail.com>
References: <20220930213534.962336-1-mmyangfl@gmail.com>
        <20220930222540.966357-1-mmyangfl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  1 Oct 2022 06:25:39 +0800 David Yang wrote:
> Support mode switch properly, which is not available before.
> 
> If SoC has two Ethernet controllers, by setting both of them into MII
> mode, the first controller enters GMII mode, while the second
> controller is effectively disabled. This requires configuring (and
> maybe enabling) the second controller in the device tree, even though
> it cannot be used.

Well, this version does not build:

drivers/net/ethernet/marvell/mv643xx_eth.c:1252:38: error: member reference type 'struct device' is not a pointer; did you mean to use '.'?
            of_device_is_compatible(dev->dev->of_node,
                                    ~~~~~~~~^~
                                            .
