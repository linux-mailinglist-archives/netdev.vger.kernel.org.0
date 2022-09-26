Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A201D5E9D9C
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 11:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbiIZJ3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 05:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiIZJ3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 05:29:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEBD30547;
        Mon, 26 Sep 2022 02:27:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4235F60B4A;
        Mon, 26 Sep 2022 09:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88327C433C1;
        Mon, 26 Sep 2022 09:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664184470;
        bh=ptacZmb4mAiKW7hPsZLLTNmlfwI/LBzdweTZj/Svi90=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YLi8e0sIBewQtpKNnoxhs3GdUGYcSUrGG82QYkExPUiSEIxx2R7suJj5wORrJp7T7
         SkH86mu2bnHei41LHglyAS+ag87fX8BfPirX8njNhecSoxic4FzT+lXWRP9LEJPkaf
         f8e/J0oU0KgCgq3knojBQIX57CC5pSOQTjm8CyRO0Ki32YGpvpSJIDJZSBYyifwAPp
         8stFng9d7BZrpsytnsy6SLt+iZR4rstMMWE2tT8c0+Jn/nZz4EVwFt5Q0KH17WShJu
         5sZse98PYkv/kn5cNdi7o70hWDlSrxydSXMVW3yrpcHyUhky1PSBPXQe5DdOwIl7fW
         fTtI5tgvxYRYg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Hector Martin <marcan@marcan.st>,
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
Date:   Mon, 26 Sep 2022 12:27:43 +0300
In-Reply-To: <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk> ("Alvin
        \=\?utf-8\?Q\?\=C5\=A0ipraga\=22's\?\= message of "Thu, 22 Sep 2022 13:30:57 +0000")
Message-ID: <87sfke32pc.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> writes:

> On Thu, Sep 22, 2022 at 03:02:12PM +0200, Linus Walleij wrote:
>> On Thu, Sep 22, 2022 at 12:21 PM Konrad Dybcio
>> <konrad.dybcio@somainline.org> wrote:
>>=20
>> > Also worth noting is the 'somc' bit, meaning there are probably *some*=
 SONY
>> > customizations, but that's also just a guess.
>>=20
>> What I have seen from BRCM customizations on Samsung phones is that
>> the per-device customization of firmware seems to involve the set-up of
>> some GPIO and power management pins. For example if integrated with
>> an SoC that has autonomous system resume, or if some GPIO line has
>> to be pulled to enable an external regulator or PA.
>
> At least with Infineon (formerly Cypress), as a customer you might get a
> private firmware and this will be maintained internally by them on a
> separate customer branch. Any subsequent bugfixes or feature requests
> will usually be applied to that customer branch and a new firmware built
> from it. I think their internal "mainline" branch might get merged into
> the customer branches from time to time, but this seems to be done on an
> ad-hoc basis. This is our experience at least.
>
> I would also point out that the BCM4359 is equivalent to the
> CYW88359/CYW89359 chipset, which we are using in some of our
> products. Note that this is a Cypress chipset (identifiable by the
> Version: ... (... CY) tag in the version string). But the FW Konrad is
> linking appears to be for a Broadcom chipset.
>
> FYI, here's a publicly available set of firmware files for the '4359:
>
> https://github.com/NXP/imx-firmware/tree/master/cyw-wifi-bt/1FD_CYW4359
>
> Anyway, I would second Hector's suggestion and make this a separate FW.

I also recommend having a separate firmware filename. Like Hector said,
it's easy to have a symlink in userspace if same binary can be used.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
