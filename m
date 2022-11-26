Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A584063984B
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 22:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiKZVpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 16:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiKZVpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 16:45:46 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87B513EAB
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 13:45:45 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-3b5d9050e48so69150777b3.2
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 13:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pRxq+j1N3NePxiJ2JT2MTJet9Uql84OySQTRJfr9N3I=;
        b=vqK+8wvDlVZobG46JZZmctmyGzHXZF93PNREcIr7XM953PhGW6Pq5q6apgGRbjzUI8
         CzaRBcn0sdl+eJzgNeXrm+36UHmK0k4tgJ4ki4PWAsVYJ/AVJXuxokoF9TBU5Y3kWqA3
         09FUtIStJCxfbU1zQgC6yOelHFtrD+0k7REJWLcCMnb93N7FeN3odr5ud4EybrvkfoRF
         P2mtjCMYwCXifoc75QGHoKsXy9RoeybAj8A2Va5e3j/Mo+ZeupJU+EPd9XbjZkYj0Wf7
         5IR5FIzDPW1LSzIBCMslfDCMK1uCrfB8K6ktO8Lv3L2LzdeMXrk4MyN/7QbTlyTddCBd
         8Suw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pRxq+j1N3NePxiJ2JT2MTJet9Uql84OySQTRJfr9N3I=;
        b=arDo2kWwIc0G8uNN/G8iOqEvjQa4t/PSbXRdImx5luy6F5s3M6J0rFFRvJVyLT4V+7
         EdJ4xPyJspfmFMjfNMHkpTsEB5AeLmkIWpLCMKGo+FzxneT4aizDQP49+8YXWgh/gtYV
         H46J9sfSll3YZj2xEa07AYY/mU3/rDpa13Z0/p33QaDwTT2PTbwVzSi5BgO4h1s13Z17
         vapgvUkftSUYY71hzF0z5t1kVCKMFtr+lehF6I/dicU/c0AurM46xnG3otHQO2h6GN5l
         SITzF/wMBFOcmWHDlqzBFYbCRX4UjnTtM4h9agDKTupvczpQdRVMCe8sw+Ze4Wn3oQ2G
         AIYQ==
X-Gm-Message-State: ANoB5pl+OlQk5CoYwnF8SF9Wx3Zfq7Nl0BkOULFm02syTWJEOOMbfBRj
        IlfBjxDCFxNvX+ksZpLGp/Gw5YL+Hc0heoXEYeRLhg==
X-Google-Smtp-Source: AA0mqf43EmhH/k7KEVgca9O5pYenGVMwt1/G9lr9Kr07O2rgGeziMSyprL3K1L17O8T6R019ZTuW5TwbvWWK86rYXQ4=
X-Received: by 2002:a81:65c1:0:b0:376:f7e2:4b12 with SMTP id
 z184-20020a8165c1000000b00376f7e24b12mr25287377ywb.0.1669499144991; Sat, 26
 Nov 2022 13:45:44 -0800 (PST)
MIME-Version: 1.0
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st> <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
 <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st> <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
 <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
 <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk> <87sfke32pc.fsf@kernel.org>
 <4592f87a-bb61-1c28-13f0-d041a6e7d3bf@linaro.org> <CACRpkdax-3VVDd29iH51mfumakqM7jyEc8Pbb=AQwAgp2WsqFQ@mail.gmail.com>
 <d03bd4d4-e4ef-681b-b4a5-02822e1eee75@linaro.org> <87fse76yig.fsf@kernel.org>
 <fc2812b1-db96-caa6-2ecb-c5bb2c33246a@linaro.org> <87bkov6x1q.fsf@kernel.org>
In-Reply-To: <87bkov6x1q.fsf@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 26 Nov 2022 22:45:33 +0100
Message-ID: <CACRpkdbpJ8fw0UsuHXGX43JRyPy6j8P41_5gesXOmitHvyoRwQ@mail.gmail.com>
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Hector Martin <marcan@marcan.st>,
        "~postmarketos/upstreaming@lists.sr.ht" 
        <~postmarketos/upstreaming@lists.sr.ht>,
        "martin.botka@somainline.org" <martin.botka@somainline.org>,
        "angelogioacchino.delregno@somainline.org" 
        <angelogioacchino.delregno@somainline.org>,
        "marijn.suijten@somainline.org" <marijn.suijten@somainline.org>,
        "jamipkettunen@somainline.org" <jamipkettunen@somainline.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Marek Vasut <marex@denx.de>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Soon Tak Lee <soontak.lee@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 1:25 PM Kalle Valo <kvalo@kernel.org> wrote:
> Konrad Dybcio <konrad.dybcio@linaro.org> writes:
>
> > On 25.11.2022 12:53, Kalle Valo wrote:
> >> Konrad Dybcio <konrad.dybcio@linaro.org> writes:
> >>
> >>> On 21.11.2022 14:56, Linus Walleij wrote:
> >>>> On Fri, Nov 18, 2022 at 5:47 PM Konrad Dybcio <konrad.dybcio@linaro.org> wrote:
> >>>>
> >>>>> I can think of a couple of hacky ways to force use of 43596 fw, but I
> >>>>> don't think any would be really upstreamable..
> >>>>
> >>>> If it is only known to affect the Sony Xperias mentioned then
> >>>> a thing such as:
> >>>>
> >>>> if (of_machine_is_compatible("sony,xyz") ||
> >>>>     of_machine_is_compatible("sony,zzz")... ) {
> >>>>    // Enforce FW version
> >>>> }
> >>>>
> >>>> would be completely acceptable in my book. It hammers the
> >>>> problem from the top instead of trying to figure out itsy witsy
> >>>> details about firmware revisions.
> >>>>
> >>>> Yours,
> >>>> Linus Walleij
> >>>
> >>> Actually, I think I came up with a better approach by pulling a page
> >>> out of Asahi folks' book - please take a look and tell me what you
> >>> think about this:
> >>>
> >>> [1]
> >>> https://github.com/SoMainline/linux/commit/4b6fccc995cd79109b0dae4e4ab2e48db97695e7
> >>> [2]
> >>> https://github.com/SoMainline/linux/commit/e3ea1dc739634f734104f37fdbed046873921af7

Something in this direction works too.

The upside is that it tells all operating systems how to deal
with the firmware for this hardware.

> >> Instead of a directory path ("brcm/brcmfmac43596-pcie") why not provide
> >> just the chipset name ("brcmfmac43596-pcie")? IMHO it's unnecessary to
> >> have directory names in Device Tree.
> >
> > I think it's common practice to include a full $FIRMWARE_DIR-relative
> > path when specifying firmware in DT, though here I left out the board
> > name bit as that's assigned dynamically anyway. That said, if you don't
> > like it, I can change it.
>
> It's just that I have understood that Device Tree is supposed to
> describe hardware and to me a firmware directory "brcm/" is a software
> property, not a hardware property. But this is really for the Device
> Tree maintainers to decide, they know this best :)

I would personally just minimize the amount of information
put into the device tree to be exactly what is needed to find
the right firmware.

brcm,firmware-compatible = "43596";

since the code already knows how to conjure the rest of the string.

But check with Rob/Krzysztof.

Yours,
Linus Walleij
