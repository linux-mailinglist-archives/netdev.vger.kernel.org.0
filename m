Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81944482D03
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 23:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiABWg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 17:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiABWgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 17:36:55 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217E8C061761;
        Sun,  2 Jan 2022 14:36:55 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id v7so66553140wrv.12;
        Sun, 02 Jan 2022 14:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J/+oeCXYZ5vSQikGncgP5k15zSUqzYA+Gew2jgommjI=;
        b=ZEh/3VL6mfwWiY0ZW1XF4gZ/9dmgFcIrydJ/E8RJceUXBjR1YLvLzQYyvW9rdyGkDW
         ARno+fTtI8ZQj4FTiHEX1AdRG/KQwpl65Z0B0JPUKNCbPl33O+S5iG+ipnlkbYyK4mfn
         chgV/k5MFMxUKNMnaUALxogQE27BjwOoVedGqQFMAW3oveQD0sZn7DGshK1TsA+3sAo5
         29QSUMUPLQZW8pnFmx/0qrFPlOxMD9Oar8Dp8W0Yb3HCiDhbwl6CgglhZm2TWP/Rc5BK
         SrsnakbB9XmsC8IutZN4B9oqVqMsmLm9ZeljIDYAfedXJ4puRoQnLlYbDV8pATh5CExA
         fCfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J/+oeCXYZ5vSQikGncgP5k15zSUqzYA+Gew2jgommjI=;
        b=QWlQFoJB7Iqywv/Of3/oVV1K6V1c4RHztQ/TwVj3YRNjUQod/j4FmLo+TmDff9H1Sp
         JLZPmgqAbkVDVWmTeGysT7hsmC8a0iNmqiWeojRh1muHjt+DQP9vah32+AszY2/LysSB
         5SW0E/xBfCRFBs2AqYD9i9Q3BzetprT6LltqBeorEarQzEKffrABQS9WJ0X9C8lT5t4M
         b3i2AcFlAUzbCzjUMHQnElac/U+1xBaRVCQYOWjf69H1beGHvg7CBc52GZvr0cx45RTC
         nkb9ctghOpVaDa9e7S2rcQ2OcgNh4xzsuyE/sunXmnLE1+61as2Y2huUsgqT1du+kWIB
         +r8w==
X-Gm-Message-State: AOAM531AD8Nkr665rAUa0pk2apMgawbPEQoZeAHuOabeyeInRGB41NRY
        x5KCm4OImEa6UzFMt9tGa/9nv+/JwJYWCqx6Gs0=
X-Google-Smtp-Source: ABdhPJzACikmBCmNga+QSoSY5xz73ioEyoeewlJ7AtcP9Ml2naaObVMZCGAR5ekrUOJgQZ/zV4QCVBsuccMLKtop3Xc=
X-Received: by 2002:adf:fc02:: with SMTP id i2mr36325658wrr.154.1641163013752;
 Sun, 02 Jan 2022 14:36:53 -0800 (PST)
MIME-Version: 1.0
References: <CAG_fn=VDEoQx5c7XzWX1yaYBd5y5FrG1aagrkv+SZ03c8TfQYQ@mail.gmail.com>
 <20220102171943.28846-1-paskripkin@gmail.com> <CAB_54W6i9-fy8Vc-uypXPtj3Uy0VuZpidFuRH0DVoWJ8utcWiw@mail.gmail.com>
 <81467464-630a-25c4-425d-d8c5c01a739c@gmail.com>
In-Reply-To: <81467464-630a-25c4-425d-d8c5c01a739c@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 2 Jan 2022 17:36:42 -0500
Message-ID: <CAB_54W50xKFCWZ5vYuDG2p4ijpd63cSutRrV4MLs9oasLmKgzQ@mail.gmail.com>
Subject: Re: [PATCH RFT] ieee802154: atusb: move to new USB API
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "# 3.19.x" <stable@vger.kernel.org>,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, 2 Jan 2022 at 17:21, Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> On 1/3/22 01:15, Alexander Aring wrote:
> > Hi,
> >
> > On Sun, 2 Jan 2022 at 12:19, Pavel Skripkin <paskripkin@gmail.com> wrote:
> >>
> >> Alexander reported a use of uninitialized value in
> >> atusb_set_extended_addr(), that is caused by reading 0 bytes via
> >> usb_control_msg().
> >>
> >
> > Does there exist no way to check on this and return an error on USB
> > API caller level?
> >
> >> Since there is an API, that cannot read less bytes, than was requested,
> >> let's move atusb driver to use it. It will fix all potintial bugs with
> >> uninit values and make code more modern
> >>
> >
> > If this is not possible to fix with the "old" USB API then I think the
> > "old" USB API needs to be fixed.
> > Changing to the new USB API as "making the code more modern" is a new
> > feature and is a candidate for next.
> >
>
> It can be fixed with the old one. Something like that should work:
>
> -       if (ret < 0) {
> -               atusb->err = ret;
> +       if (ret < size) {
> +               atusb->err = ret < 0: ret: -ENODATA;
>
> But I thought, that moving to new API is better fix, just because old
> one prone to uninit value bugs if error checking is wrong

A fix should have the smallest changes as possible and not use "new
stuff" which might break other things. Also I am not sure since "when"
this new USB API exists. To backport the fix into stable send a fix
using the "old USB API".
If the fix is upstream you can send patches to use the new API and
remove the additional check if this is done by using the new API.
Maybe it's worth checking that the errno stays the same.

Thanks.

- Alex
