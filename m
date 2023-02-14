Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CCB695E9C
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbjBNJN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjBNJNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:13:37 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20ADB24484;
        Tue, 14 Feb 2023 01:11:31 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id z5so16725359qtn.8;
        Tue, 14 Feb 2023 01:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W5HgoftjWnKaZB9WMngfkr+9a/dXo/FJFDXK14dxBTY=;
        b=NHl2Azqc+UQ5FZvagtUU968byxOtD9ULnLCAFP39b1i2dEiKtXKqz8+fdOKvxr0jdm
         kWHa0YNQ4B7tpXdzBi73woit0rKWknM8c/+ke2zcJZqxcGFcx5j5eMzdrc/ZH32CcJZ+
         gTMrq7MOnLG6NzBYpiQMIbcL8cnXJCsmL1MwKnOw+QKpWniEuFATkx8xVbtOxJV8GZ4H
         25JIXxgeIKumCKAR5QjgieJ+i0MILVcxUx4NnvD5UWdJPQb9tgfg+vTEujKOjIHgE6EX
         uvKcaydNXE7X7Tqa/njVPj7lJYj8A6NUmu3LWuDsT3ivMO1OQrKY5/tjFqdZJF9R0GBI
         MYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W5HgoftjWnKaZB9WMngfkr+9a/dXo/FJFDXK14dxBTY=;
        b=LEkM/sMN+1fYZZ+QYk0serJcNIvCpJVBYOiWUl3oF/gZBYlFVRYE3NSlWN+iISktUH
         UxqM4xBZXc+ZDmLCUG1uQF7jRd58q04TD0rLpyApmlrPgCxAc/Wi3supzwmeUbk/Hz51
         p8ieetWQpgHxXZbQpZq4OmzJOVSifXekR7iMlXvsCzrZpTZcPPT2TnN/RNSAJhQf+pAT
         kSON4lf+htTlBwli/XwKUyKYZsdxuZ7l1J9CYRth2ZYi88KCZwPY+69eW2d/M2wDvYQu
         cDOTpO3P98wYD/rtDIZl/BDXOMtjJhZJ3sxP3QO6JlHznI90gh1Gjwhg5DKhArOdjCcL
         4l0Q==
X-Gm-Message-State: AO0yUKWeLR3GF6xoRkDsRZagupU7w5Ed3P2kPlk+q2FUSdSKlMIkFH+Q
        v3F4FTVCxGh6Lbo/YWUrrAL9sVFnCMOsVFd+1as=
X-Google-Smtp-Source: AK7set+WS/yIY5Z2eiMuhpOsCXR4iacCVtUdbB4RSkt+9yamWmbLhxFi0NSrOCMHriE9cgu/fmpqsFMr2hfCIdqv2Z0=
X-Received: by 2002:a05:622a:289:b0:3b8:6b33:d92b with SMTP id
 z9-20020a05622a028900b003b86b33d92bmr171615qtw.325.1676365889757; Tue, 14 Feb
 2023 01:11:29 -0800 (PST)
MIME-Version: 1.0
References: <20230214080034.3828-1-marcan@marcan.st> <20230214080034.3828-3-marcan@marcan.st>
 <CAGRGNgV6YMhBa1bdkf_EQ0Z+nwbfhJkKcTxtc=ukWVMWtvQ2PA@mail.gmail.com> <a9281140-8b9d-41ca-bc2d-3c2d2e78259e@marcan.st>
In-Reply-To: <a9281140-8b9d-41ca-bc2d-3c2d2e78259e@marcan.st>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Tue, 14 Feb 2023 20:11:17 +1100
Message-ID: <CAGRGNgV2EALagFHKhBwDaySEFMufeK=7shF-yTRtJkFuF+W1Gg@mail.gmail.com>
Subject: Re: [PATCH 2/2] brcmfmac: pcie: Provide a buffer of random bytes to
 the device
To:     Hector Martin <marcan@marcan.st>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hector,

On Tue, Feb 14, 2023 at 8:08 PM Hector Martin <marcan@marcan.st> wrote:
>
> On 14/02/2023 18.00, Julian Calaby wrote:
> > Hi Arend,
> >
> > On Tue, Feb 14, 2023 at 7:04 PM Hector Martin <marcan@marcan.st> wrote:
> >>
> >> Newer Apple firmwares on chipsets without a hardware RNG require the
> >> host to provide a buffer of 256 random bytes to the device on
> >> initialization. This buffer is present immediately before NVRAM,
> >> suffixed by a footer containing a magic number and the buffer length.
> >>
> >> This won't affect chips/firmwares that do not use this feature, so do it
> >> unconditionally for all Apple platforms (those with an Apple OTP).
> >
> > Following on from the conversation a year ago, is there a way to
> > detect chipsets that need these random bytes? While I'm sure Apple is
> > doing their own special thing for special Apple reasons, it seems
> > relatively sensible to omit a RNG on lower-cost chipsets, so would
> > other chipsets need it?
>
> I think we could include a list of chips known not to have the RNG (I
> think it's only the ones shipped on T2 machines). The main issue is I
> don't have access to those machines so it's hard for me to test exactly
> which ones need it. IIRC Apple's driver unconditionally provides the
> randomness. I could at least test the newer chips on AS platforms and
> figure out if they need it to exclude them... but then again, all I can
> do is test whether they work without the blob, but they might still want
> it (and simply become less secure without it).
>
> So I guess the answer is "maybe, I don't know, and it's kind of hard to
> know for sure"... the joys of reverse engineering hardware without
> vendor documentation.
>
> If you mean whether other chips with non-apple firmware can use this, I
> have no idea. That's probably something for Arend to answer. My gut
> feeling is Apple added this as part of a hardening mechanism and
> non-Apple firmware does not use it (and Broadcom then probably started
> shipping chips with a hardware RNG and firmware that uses it directly
> across all vendors), in which case the answer is no.

Sorry, I should have been more clear, I wasn't expecting you to know,
I was asking Arend if he knew.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
