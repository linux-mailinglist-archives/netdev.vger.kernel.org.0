Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4734863A6EB
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiK1LRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiK1LRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:17:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3754E6172;
        Mon, 28 Nov 2022 03:17:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD4316106C;
        Mon, 28 Nov 2022 11:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DD3C433D7;
        Mon, 28 Nov 2022 11:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669634234;
        bh=xJRkcM/s19gYAXNwC6geD/5BTDYu4MnGAhHKzNufA+0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Zc3z3ZpSWt3HdcyaFQb77lXWXGjgErqrJLoSYdVZXy55Aku3lOHxFJeoyY+mqiho9
         FpATB+axPKq/E+U+UnKlRr+Z6LW3qFLAwE3sQgQO5PEL+DJmn9VpqYxW7ujWqypOgv
         SRFrEK4IkYwYcrQSVYVpdZyynw163vlOh2qv4cHcMmxWkojKIeSrpsrxc13CndztAO
         EDWWNA7nvxDsYGAxW0IOKWxq7S3E+8/cV0OLh5Ehj5/XskASIiV1w4RNcqqNWs/31u
         WY8q5uxsB6ch/bCuMWP6ZDQnuifHYj6zXndMSfeu38QkSPTW71cgLsdtk43eW+2p+i
         d7fB78QwN1GfA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0iprag?= =?utf-8?Q?a?= 
        <ALSI@bang-olufsen.dk>, Hector Martin <marcan@marcan.st>,
        "~postmarketos\/upstreaming\@lists.sr.ht" 
        <~postmarketos/upstreaming@lists.sr.ht>,
        "martin.botka\@somainline.org" <martin.botka@somainline.org>,
        "angelogioacchino.delregno\@somainline.org" 
        <angelogioacchino.delregno@somainline.org>,
        "marijn.suijten\@somainline.org" <marijn.suijten@somainline.org>,
        "jamipkettunen\@somainline.org" <jamipkettunen@somainline.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Marek Vasut <marex@denx.de>,
        "Zhao\, Jiaqing" <jiaqing.zhao@intel.com>,
        "Russell King \(Oracle\)" <rmk+kernel@armlinux.org.uk>,
        Soon Tak Lee <soontak.lee@cypress.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl\@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list\@infineon.com" 
        <SHA-cyfmac-dev-list@infineon.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
        <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st>
        <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
        <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st>
        <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
        <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
        <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk>
        <87sfke32pc.fsf@kernel.org>
        <4592f87a-bb61-1c28-13f0-d041a6e7d3bf@linaro.org>
        <CACRpkdax-3VVDd29iH51mfumakqM7jyEc8Pbb=AQwAgp2WsqFQ@mail.gmail.com>
        <d03bd4d4-e4ef-681b-b4a5-02822e1eee75@linaro.org>
        <87fse76yig.fsf@kernel.org>
        <fc2812b1-db96-caa6-2ecb-c5bb2c33246a@linaro.org>
        <87bkov6x1q.fsf@kernel.org>
        <CACRpkdbpJ8fw0UsuHXGX43JRyPy6j8P41_5gesXOmitHvyoRwQ@mail.gmail.com>
Date:   Mon, 28 Nov 2022 13:17:06 +0200
In-Reply-To: <CACRpkdbpJ8fw0UsuHXGX43JRyPy6j8P41_5gesXOmitHvyoRwQ@mail.gmail.com>
        (Linus Walleij's message of "Sat, 26 Nov 2022 22:45:33 +0100")
Message-ID: <87wn7f5nwt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Walleij <linus.walleij@linaro.org> writes:

>> >> Instead of a directory path ("brcm/brcmfmac43596-pcie") why not provide
>> >> just the chipset name ("brcmfmac43596-pcie")? IMHO it's unnecessary to
>> >> have directory names in Device Tree.
>> >
>> > I think it's common practice to include a full $FIRMWARE_DIR-relative
>> > path when specifying firmware in DT, though here I left out the board
>> > name bit as that's assigned dynamically anyway. That said, if you don't
>> > like it, I can change it.
>>
>> It's just that I have understood that Device Tree is supposed to
>> describe hardware and to me a firmware directory "brcm/" is a software
>> property, not a hardware property. But this is really for the Device
>> Tree maintainers to decide, they know this best :)
>
> I would personally just minimize the amount of information
> put into the device tree to be exactly what is needed to find
> the right firmware.
>
> brcm,firmware-compatible = "43596";
>
> since the code already knows how to conjure the rest of the string.

FWIW I like this.

> But check with Rob/Krzysztof.

Indeed, they are the experts here.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
