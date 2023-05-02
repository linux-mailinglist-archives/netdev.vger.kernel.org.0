Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2F46F47D3
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbjEBP5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbjEBP5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:57:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069421989;
        Tue,  2 May 2023 08:57:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9566962683;
        Tue,  2 May 2023 15:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2833C433EF;
        Tue,  2 May 2023 15:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683043040;
        bh=cuMeYUIRMxPXldK9Fyk3dq6T5UKsUaI5T12XmQnVRtc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m14sDXK+FHFR1qkPCTptuU1c9w9IHLB6SgpnDydZeqQMEMYGFGbiw/zqBa8rIyPNV
         hs2KgCjPacNoySW6EKdS+1MVeTjVlRKoYujN/f5fUKEtueVKOjdWtV1CA3eoZzV2Wy
         ZJtziYbAnziP6okM7WAVyzjZHm6T+hY2C5qOgPDZIVYTR0W/cn4VGGcttVgTCVwpqi
         RZuxVHBnlMa8xYcOISULHyKd1jYnoLm6q9gr43IX23SX/yI7lkDeb7x3on3uuVlhh4
         TNV3YoL8rATe5jEQey3AFHD2nzuvIGwGIXHR8WtPo+YK5UOLE4QEDPbwW1dBr5kggj
         f9stFo7ks2ToQ==
Date:   Tue, 2 May 2023 08:57:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ganesh Babu <ganesh.babu@ekinops.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
Message-ID: <20230502085718.0551a86d@kernel.org>
In-Reply-To: <PAZP264MB406414BA18689729DDE24F3DFC659@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
References: <PAZP264MB4064279CBAB0D7672726F4A1FC889@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
        <20230328191456.43d2222e@kernel.org>
        <PAZP264MB406414BA18689729DDE24F3DFC659@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 May 2023 08:07:10 +0000 Ganesh Babu wrote:
> Thank you for your response. Regarding the proposed change to
> the mif6ctl structure in mroute6.h, I would like to clarify,
> that changing the datatype of mif6c_pifi from __u16 to __u32
> will not change the offset of the structure members, which
> means that the size of the structure remains the same and
> the ABI remains compatible. Furthermore, ifindex is treated
> as an integer in all the subsystems of the kernel and not
> as a 16-bit value. Therefore, changing the datatype of
> mif6c_pifi from __u16 to __u32 is a natural and expected
> change that aligns with the existing practice in the kernel.
> I understand that the mif6ctl structure is part of the uAPI
> and changing its geometry is not allowed. However, in this
> case, we are not changing the geometry of the structure,
> as the size of the structure remains the same and the offset
> of the structure members will not change. Thus, the proposed
> change will not affect the ABI or the user API. Instead, it
> will allow the kernel to handle 32-bit ifindex values without
> any issues, which is essential for the smooth functioning of
> the PIM6 protocol. I hope this explanation clarifies any
> concerns you may have had. Let me know if you have any further
> questions or need any more details.

Please don't top post on the list.

How does the hole look on big endian? Does it occupy the low or 
the high bytes?

There's also the problem of old user space possibly not initializing
the hole, and passing in garbage.
