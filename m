Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998636B528E
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbjCJVJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbjCJVI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:08:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426BE11C8F1
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 13:08:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE305B82404
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 21:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712CFC433D2;
        Fri, 10 Mar 2023 21:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678482534;
        bh=2Tuou6de+wWYwF8hbtfFMCutyLRumtpNCwO63RJPc4A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=dmqqrbdKpB0I2mHJtQc6W1CW3AvcxyP1R7asJGGC9oUDNFNvcMIA7azEbIvK2BYZt
         pDwePVwMAtYNgVs0gM6l2w5eVOORsGD+LuAV2cW/yFIYVSjtzZ9erWQegxSbEl+vnL
         8h9/TP3NEm3v1eTxLNGwANUhyn6ysXE04ZqAHV8R5+UbaGtLINRoxIDp24a22tqff0
         4NQKCelQmkYPlBZLVQW5Mf0RHKe+AtINrlU2uEDdqDBrv+vc2oQ+fennlepxYgEXtc
         Rl8HFX4rtv6q8LPZQSTHBwOHVL3N5z5FUbJm09mEIXC85//k0Xxp+klnYELK9ECgBI
         nOmcZ6Wvo8URQ==
Date:   Fri, 10 Mar 2023 15:08:52 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC 3/6] r8169: enable cfg9346 config register access in
 atomic context
Message-ID: <20230310210852.GA1278511@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcd18f60-3b39-599e-8392-998bdcbde1f2@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 25, 2023 at 10:45:28PM +0100, Heiner Kallweit wrote:
> For disabling ASPM during NAPI poll we'll have to unlock access
> to the config registers in atomic context. Other code parts
> running with config register access unlocked are partially
> longer and can sleep.

"partially longer"?  Not sure what was intended.
