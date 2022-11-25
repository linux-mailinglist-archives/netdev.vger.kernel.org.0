Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65FE563891F
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 12:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiKYLxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 06:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiKYLxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 06:53:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B24E2C11D;
        Fri, 25 Nov 2022 03:53:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2283162371;
        Fri, 25 Nov 2022 11:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E041C433C1;
        Fri, 25 Nov 2022 11:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669377232;
        bh=GJUGKKMFeuENkwBge1jb0Mdf5GIp2DPpvfvOPbbp7iw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GQQihBilK2RZaxGRLnomolcNP5U3RCj+AOVFaIQsIDVaiQoZm2uipr73zZ549jroy
         wLQ9pcyDXfakozCgBda/OPBv7kYn4YQoBLL9FqugcpPizWGWRtHYTJ2APimsaRS6Xc
         fRYxvTaU9vacBQddeSATsVI9/kjShokM/FYD5EbQKy34vV2gfuAEoqkFvsum6osOQN
         qOgEXpBHE3y3b/rvmd0G1ufuTTprLvvQZ0XNt+F34q28LElHnC/8WtE2/OsBenxKo0
         XX/sKoPfjyj6Ocg4HzTmgfuTdC6TZ2mdKtd6CZQ2URmrAp6XAxoTqyWGCHSVjmcyVn
         FLvT/MLY5v4TA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
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
Date:   Fri, 25 Nov 2022 13:53:43 +0200
In-Reply-To: <d03bd4d4-e4ef-681b-b4a5-02822e1eee75@linaro.org> (Konrad
        Dybcio's message of "Fri, 25 Nov 2022 12:42:29 +0100")
Message-ID: <87fse76yig.fsf@kernel.org>
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

Konrad Dybcio <konrad.dybcio@linaro.org> writes:

> On 21.11.2022 14:56, Linus Walleij wrote:
>> On Fri, Nov 18, 2022 at 5:47 PM Konrad Dybcio <konrad.dybcio@linaro.org> wrote:
>> 
>>> I can think of a couple of hacky ways to force use of 43596 fw, but I
>>> don't think any would be really upstreamable..
>> 
>> If it is only known to affect the Sony Xperias mentioned then
>> a thing such as:
>> 
>> if (of_machine_is_compatible("sony,xyz") ||
>>     of_machine_is_compatible("sony,zzz")... ) {
>>    // Enforce FW version
>> }
>> 
>> would be completely acceptable in my book. It hammers the
>> problem from the top instead of trying to figure out itsy witsy
>> details about firmware revisions.
>> 
>> Yours,
>> Linus Walleij
>
> Actually, I think I came up with a better approach by pulling a page
> out of Asahi folks' book - please take a look and tell me what you
> think about this:
>
> [1]
> https://github.com/SoMainline/linux/commit/4b6fccc995cd79109b0dae4e4ab2e48db97695e7
> [2]
> https://github.com/SoMainline/linux/commit/e3ea1dc739634f734104f37fdbed046873921af7

Instead of a directory path ("brcm/brcmfmac43596-pcie") why not provide
just the chipset name ("brcmfmac43596-pcie")? IMHO it's unnecessary to
have directory names in Device Tree.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
