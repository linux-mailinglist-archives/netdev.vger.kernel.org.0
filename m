Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990F85A1BA0
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244031AbiHYVu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244370AbiHYVuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:50:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF2FC2F89
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 14:49:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DED9661B30
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 21:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3EAC433C1;
        Thu, 25 Aug 2022 21:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661464161;
        bh=VJCxKeJ6suKcHN6SHogUJXGZOLOJYk5PaJU0PMcHND4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LFTAA0G9jXMaOuBPYRbto0r8Xxd9pDpduFVC4f5ZxfHS8g2pw1LXdjI8ar+dWgfXo
         ASJkbyLUbijMpIFbH1mCH22xMbjpkY2A5agjKcIRykNUCiay7Wd9j3AJIOm5oY0WXS
         BOKQ1era2dP+KGFBAGgnGe5ph7MZDJ0jguJIxvjt/v7rvB2PVWg+rmpTSLl09XOCoW
         0KsOwkuFpT8Igu6elK5zXy3ekyakFIDKyPDHhw3dOGVg+TkUnBBOl1/EKYvkx4Kgnu
         Pfb/QCXdEnqFEl/P3mEF3FNLe4T+WW70u58VSirZoCPXC0h8lrxODLkac5LRBr4MDv
         83mWTpRWj4+oA==
Date:   Thu, 25 Aug 2022 14:49:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 3/3] nfp: add support for eeprom get and set
 command
Message-ID: <20220825144920.5c709331@kernel.org>
In-Reply-To: <20220825141223.22346-4-simon.horman@corigine.com>
References: <20220825141223.22346-1-simon.horman@corigine.com>
        <20220825141223.22346-4-simon.horman@corigine.com>
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

On Thu, 25 Aug 2022 16:12:23 +0200 Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Add support for eeprom get and set operation with ethtool command.
> with this change, we can support commands as:
> 
>  #ethtool -e enp101s0np0 offset 0 length 6
>  Offset          Values
>  ------          ------
>  0x0000:         00 15 4d 16 66 33
> 
>  #ethtool -E enp101s0np0 magic 0x400019ee offset 5 length 1 value 0x88
> 
> We make this change to persist MAC change during driver reload and system
> reboot.

Is there any precedent for writing the MAC address with way?
