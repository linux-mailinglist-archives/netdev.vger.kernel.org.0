Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BAD5E9B73
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbiIZIB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbiIZIBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:01:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02614C27;
        Mon, 26 Sep 2022 00:58:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F8A36179F;
        Mon, 26 Sep 2022 07:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85251C433C1;
        Mon, 26 Sep 2022 07:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664179131;
        bh=jfuwhFd5PczoIXgvji7jNDdS65hU/TTDtOFWvgEpYkI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GCIatT1Gc/erxM3rdkI/8g7syX2EzY43d6RY9O+fWQUdcXRuyiUDtbvpnl60m7dE+
         2hHqu72oyFVsX4ntX4wXxY+UDRxa8AzF24r8pQDDmoqhG/pdyMDuzLPD8O4VauEEUl
         2XSuoHx8i7aA0x3Uj8Z3QMBfujxRHshTsS1sRVRluCpBkAN3MltLOp8V0a/pNOmEqY
         vAT7RtTC2bIb0/ClWsmnnclQtV2Im5Dl85mLrfXyuZ0Dbjt+i4BqX/ve4Hd2AbJdJ1
         0tfGBkzPGfZm8pNH/aTWBqPL4AJ/rT8cq1qQTCqdVHwvl0uR2DQiL0spjUkMyiThdb
         ZMl452H4brgTQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ruan Jinjie <ruanjinjie@huawei.com>
Cc:     Franky Lin <franky.lin@broadcom.com>, <aspriel@gmail.com>,
        <hante.meuleman@broadcom.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <marcan@marcan.st>, <linus.walleij@linaro.org>,
        <rmk+kernel@armlinux.org.uk>, <soontak.lee@cypress.com>,
        <linux-wireless@vger.kernel.org>,
        <SHA-cyfmac-dev-list@infineon.com>,
        <brcm80211-dev-list.pdl@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] wifi: brcmfmac: pcie: add missing pci_disable_device() in brcmf_pcie_get_resource()
References: <20220923093806.3108119-1-ruanjinjie@huawei.com>
        <CA+8PC_eCwv321DxoCMOrWNLw7NWkT9F0sD-=8GzygEXPJHFWWA@mail.gmail.com>
        <b5e39818-2961-ba3d-8552-f618c19f8fe6@huawei.com>
Date:   Mon, 26 Sep 2022 10:58:45 +0300
In-Reply-To: <b5e39818-2961-ba3d-8552-f618c19f8fe6@huawei.com> (Ruan Jinjie's
        message of "Sat, 24 Sep 2022 09:00:12 +0800")
Message-ID: <878rm64le2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ruan Jinjie <ruanjinjie@huawei.com> writes:

> On 2022/9/24 0:50, Franky Lin wrote:
>> On Fri, Sep 23, 2022 at 2:42 AM ruanjinjie <ruanjinjie@huawei.com> wrote:
>>>
>>> Add missing pci_disable_device() if brcmf_pcie_get_resource() fails.
>> 
>> Did you encounter any issue because of the absensent
>> pci_disable_device? A bit more context will be very helpful.
>> 
>
> We use static analysis via coccinelle to find the above issue. The
> command we use is below:
>
> spatch -I include -timeout 60 -very_quiet -sp_file
> pci_disable_device_missing.cocci
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c

Please include this information to the commit log, it helps to
understand the background of the fix.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
