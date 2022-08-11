Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BE3590477
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbiHKQce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238994AbiHKQbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:31:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8406BC3A;
        Thu, 11 Aug 2022 09:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBE7C61456;
        Thu, 11 Aug 2022 16:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D423C43470;
        Thu, 11 Aug 2022 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234215;
        bh=w+++LZJNZdf5vlMvLVgFrKxj6AC7kHyNpp8yxdes5kc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e4wKZOFpU8xZgXlIM/gwZ/Ebm0UBQzqXVuskzd3wF8JtkoMdJnqahs0rStKzAB1FF
         lHtgflBiXObzWKW959bvN3HzHVGXDJ9NgkFoR4M3FxeY4YU9Hm+Sk0AupOmr/KXhA+
         v4Pr08bddcKEuSwt9f6LmK4xbWv+iZlB82ZFquKz2EHarfHTpGDZE/zKBI/S8i3fdZ
         vjFkOqq4hIxh8gDrXcmMjGxs720g5cTE6xfnc8uz4pXX/MqxVHRWRON2oqfVBvZfXB
         4OWO29W7vSaeIqqSLuRC/BazGhHcVKoGx+ikycchWuPdb8vR9DBAekIIazcR+7/HWL
         l6vHjRf3eW3mA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D53CC43145;
        Thu, 11 Aug 2022 16:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: qmi_wwan: Add support for Cinterion MV32
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166023421518.9507.3595774911960025799.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 16:10:15 +0000
References: <20220810014521.9383-1-slark_xiao@163.com>
In-Reply-To: <20220810014521.9383-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     bjorn@mork.no, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 10 Aug 2022 09:45:21 +0800 you wrote:
> There are 2 models for MV32 serials. MV32-W-A is designed
> based on Qualcomm SDX62 chip, and MV32-W-B is designed based
> on Qualcomm SDX65 chip. So we use 2 different PID to separate it.
> 
> Test evidence as below:
> T:  Bus=03 Lev=01 Prnt=01 Port=02 Cnt=03 Dev#=  3 Spd=480 MxCh= 0
> D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=1e2d ProdID=00f3 Rev=05.04
> S:  Manufacturer=Cinterion
> S:  Product=Cinterion PID 0x00F3 USB Mobile Broadband
> S:  SerialNumber=d7b4be8d
> C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=500mA
> I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
> I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
> I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
> I:  If#=0x3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
> 
> [...]

Here is the summary with links:
  - net: usb: qmi_wwan: Add support for Cinterion MV32
    https://git.kernel.org/netdev/net/c/ae7107baa5bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


