Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB1266E538
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjAQRsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbjAQRqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:46:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8043958643
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 09:36:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37148B8197A
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 17:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBF6C433D2;
        Tue, 17 Jan 2023 17:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673976980;
        bh=ewOX5YxpXGFyy0CC1ywVsdLc1iO09u+uR3XpLtsb0Yo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B6ZIL+JfM9aIIIIJbaQmqPm/ovy4o5E5wZxGUolHz7IYsD7F5K8q9/VXymq/1+D78
         pXpf6YKmtt1ueUOX/mNDnazqw4SzeCGlU3ZNHgNInXT030nTPqGuNZQsxLQrEevI4G
         CHvrHdyBxZputE1bBBN5JlE8/zd+XKdQ4B3Kj8Z0sdflChA//MoHGTSREyz+pfXyOK
         j45kLV/bcTIzuqc1dLic0Y4CPXuErcNtdvRXcvIGLg3yBRHB9kw4t3nhebrfcIFZ/M
         ZOkJu4eW4b0DsIbuTEL2nSUW/EF4ZCfdj3ZdyvMukOlr/XkZfHYvezCkILNMo9crJ+
         XiTexpCr1coag==
Date:   Tue, 17 Jan 2023 09:36:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Gal Pressman <gal@nvidia.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>,
        "Bernstein, Amit" <amitbern@amazon.com>
Subject: Re: [PATCH V1 net-next 0/5] Add devlink support to ena
Message-ID: <20230117093619.147acc3f@kernel.org>
In-Reply-To: <pj41zla62ift8o.fsf@u570694869fb251.ant.amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
        <20230109164500.7801c017@kernel.org>
        <574f532839dd4e93834dbfc776059245@amazon.com>
        <20230110124418.76f4b1f8@kernel.org>
        <865255fd30cd4339966425ea1b1bd8f9@amazon.com>
        <20230111110043.036409d0@kernel.org>
        <29a2fdae8f344ff48aeb223d1c3c78ad@amazon.com>
        <20230111120003.1a2e2357@kernel.org>
        <f2fd4262-58b7-147d-2784-91f2431c53df@nvidia.com>
        <pj41zltu0vn9o7.fsf@u570694869fb251.ant.amazon.com>
        <20230112115613.0a33f6c4@kernel.org>
        <pj41zla62ift8o.fsf@u570694869fb251.ant.amazon.com>
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

On Mon, 16 Jan 2023 16:23:56 +0200 Shay Agroskin wrote:
> Going forward, can I ask what's the community's stand on adding 
> sysfs or procfse entries to the driver as means to tweak custom 
> device attributes ?

We prefer to avoid both of those.

If you're worried about user having hard time changing the parameter
because the user space ethtool command is out of date - our solution 
to that will likely be the "Netlink protocol descriptions in YAML".

With that thing you don't really need a custom CLI tool to issue
Netlink commands. Until it gets merged you may need to hand-craft 
the right netlink message in python or another scripting language 
of choice :(
