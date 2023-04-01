Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B2E6D3413
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 23:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjDAVaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 17:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDAVax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 17:30:53 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A7D9EFD;
        Sat,  1 Apr 2023 14:30:52 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id eh3so103104612edb.11;
        Sat, 01 Apr 2023 14:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680384651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/OPtjdnkc4rIJXkb+zY6dPao+VPWheOHSIHlDg7Dik=;
        b=eSVhHZjazNJfUknHOyalEyC063Q22SS2YwhpqmT4CT74bmof6OAwh5PYLQ1n0IkbVL
         G6WI1CASemyWacqEXBiRct94ZQJy1pUFzD6HL+Wm3VlX15043DNdoQJJcBsQbBGrG1Ao
         xcQR9rx65pgWZxeqbKr1DLtiA6sEMIGlCqxWxRvhR56mqIfjuf+UoePkqKSqV96Ay0ZP
         9KwxOOIdxktLbqHKJ/mfI45eZMmAWA5fcRh84z1vu7KI6YKJi0hWRoo3t9SOCuQb9Yjm
         xDk72tUdi9bvwvfHUeoS2hCTl0HHzTE4YYuBZJ0Y+dG+A3DwmXcZxekjaIknpic8JVyF
         8vfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680384651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t/OPtjdnkc4rIJXkb+zY6dPao+VPWheOHSIHlDg7Dik=;
        b=I81IVeITZg5eLAYXz5xcmLSfO6LxF/9ypSPuqM92qKiYpmRpIHPw8zmUG9WkeJnipW
         casg4n6kZI1FoEBHez3UQrVwqHOwZCEv72QFHijSJcV/v9m+zxeC8fQ8xyhYOSd2waVY
         lu+oPKzYqOi9X2g3vSAck0Vyu4eSy/OD6LP3bVQ+8qImzC3GDavqXz7rFBWDdkn1O3P2
         q3VwlMnAOJXazTbH6MIxGSi5ewhd93K8l4xiFxfNsiX1wa3ltE/GpERoo3w/pr/7MbVJ
         pj18mcIBLXme0xZwtfSCEtUJIRKo2xDXD89TYQYQepDEyHccgESLearm1MXOazeuCxX7
         vArQ==
X-Gm-Message-State: AAQBX9fnNL6+/ONDmFib901KVwcj+a0Pe9+xB745+FxxRhw21L+beH7/
        E+zWdkGmi+dPpCZ8cWgfiyHsl0uD9gvCZXIotA+8LyDtGiU=
X-Google-Smtp-Source: AKy350b2+86R2j+XHnH0JMEuKex86YB8zpk5QFrcjApZZ76XiRrCO5mWNAW0aNIlAWexD/z4M+GFVIgjGUPbTU4EZ+4=
X-Received: by 2002:a50:9fad:0:b0:4c1:6acc:ea5 with SMTP id
 c42-20020a509fad000000b004c16acc0ea5mr15735586edf.4.1680384651197; Sat, 01
 Apr 2023 14:30:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230108211324.442823-1-martin.blumenstingl@googlemail.com>
 <20230108211324.442823-2-martin.blumenstingl@googlemail.com> <20230331125906.GF15436@pengutronix.de>
In-Reply-To: <20230331125906.GF15436@pengutronix.de>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 1 Apr 2023 23:30:40 +0200
Message-ID: <CAFBinCB8B4-oYaFY4p-20_PCWh_6peq75O9JjV6ZusVXPKSaDw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] wifi: rtw88: Move register access from
 rtw_bf_assoc() outside the RCU
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@kernel.org, pkshih@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sascha,

On Fri, Mar 31, 2023 at 2:59=E2=80=AFPM Sascha Hauer <s.hauer@pengutronix.d=
e> wrote:
>
> On Sun, Jan 08, 2023 at 10:13:22PM +0100, Martin Blumenstingl wrote:
> > USB and (upcoming) SDIO support may sleep in the read/write handlers.
> > Shrink the RCU critical section so it only cover the call to
> > ieee80211_find_sta() and finding the ic_vht_cap/vht_cap based on the
> > found station. This moves the chip's BFEE configuration outside the
> > rcu_read_lock section and thus prevent "scheduling while atomic" or
> > "Voluntary context switch within RCU read-side critical section!"
> > warnings when accessing the registers using an SDIO card (which is
> > where this issue has been spotted in the real world - but it also
> > affects USB cards).
>
> Unfortunately this introduces a regression on my RTW8821CU chip. With
> this it constantly looses connection to the AP and reconnects shortly
> after:
Sorry to hear this! This is odd and unfortunately I don't understand
the reason for this.
rtw_bf_assoc() is only called from
drivers/net/wireless/realtek/rtw88/mac80211.c with rtwdev->mutex held.
So I don't think that it's a race condition.

There's a module parameter which lets you enable/disable BF support:
$ git grep rtw_bf_support drivers/net/wireless/realtek/rtw88/ | grep param
drivers/net/wireless/realtek/rtw88/main.c:module_param_named(support_bf,
rtw_bf_support, bool, 0644);

Have you tried disabling BF support?
Also +Cc Jernej in case he has an idea.


Best regards,
Martin
