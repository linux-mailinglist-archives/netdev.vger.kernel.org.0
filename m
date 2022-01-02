Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EC3482CF4
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 23:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiABWPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 17:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiABWPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 17:15:52 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC24C061761;
        Sun,  2 Jan 2022 14:15:51 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id e5so66617195wrc.5;
        Sun, 02 Jan 2022 14:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nd/rqy7LQYB3nPp8vYqGAFU0gyGrEt+wKxqV1+kwnfQ=;
        b=W3gu7L4+pcs4YTq7Fk3BTLYZ5Xl7QKRYkfXmSqFulaLyaZkNaLeD6VMLKKBAfT6XuA
         9cTzTgCUbFuLlldXYEIs58W8vrQes94y52hsIbpOEw+cen7WFAW+t24h7LY3udi45T1u
         oNQqUqdJdMtHyZ1PHC7Zt8IXN2njylhTIWxt/1/wHuNAO0bjT0sXm5WwQgm3M4PfcVA6
         l5eUpKau9e4ra13c3H4xv1oi/9u4EuzOY8YYxTwIKs6yH1t2rtoCq4hqcS5wQR3WbJt6
         vve518hrkmdaWq4l/9ulIFYsxGxIshTYWbd1egarCzxI6WI8b3caQgE+GHOtzmfNl8z8
         FFjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nd/rqy7LQYB3nPp8vYqGAFU0gyGrEt+wKxqV1+kwnfQ=;
        b=fxgqUKUU78uoa67VQbazscNKjvBpMFqWDfHgtKT4NlS6Jy8jZ+pTPKg1ALBjWyyP98
         OjLEHnXIOwVztDQ+s5Cv/K+/wrzeqy/zW/Gs2/Z7BdE3iuTxqNichXUg0bovibbqDsxg
         njXRl5ZFWbksALn+w/Qr1B+R1SHUK0bQsbK0xCMBVd6Kml0jL5E2MyM9FwZ1LZXoleL3
         EpqHXmxTk7GUnRxL0OMGdzyftUUk6Kbgg0puR/aMsNXDXhOV/ASSDlpyD3oegwaQp7AL
         lZVr4NsboKJfAfTwNrXQH8I044bmsz5FpOmxpAwESQP2UsaAxldEyG3SLY0cGBDuFQGh
         EPOw==
X-Gm-Message-State: AOAM533jdXixZeXziXNCDVyknGoQGGl5o5IHhM4serSma1ymlLGULGLP
        w7jigSUCT6rkEK6yfi+CEPtMfIbUdIoTceLTGQo=
X-Google-Smtp-Source: ABdhPJy0+k3fawoMULgYO31FDesk6jo0xYfWLmkVP/K05sSdBqDYqVSdaLA9K0FySrPk8+wQP1knSa07p/KmMd+5OLk=
X-Received: by 2002:a5d:588c:: with SMTP id n12mr36991134wrf.56.1641161749098;
 Sun, 02 Jan 2022 14:15:49 -0800 (PST)
MIME-Version: 1.0
References: <CAG_fn=VDEoQx5c7XzWX1yaYBd5y5FrG1aagrkv+SZ03c8TfQYQ@mail.gmail.com>
 <20220102171943.28846-1-paskripkin@gmail.com>
In-Reply-To: <20220102171943.28846-1-paskripkin@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 2 Jan 2022 17:15:38 -0500
Message-ID: <CAB_54W6i9-fy8Vc-uypXPtj3Uy0VuZpidFuRH0DVoWJ8utcWiw@mail.gmail.com>
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

On Sun, 2 Jan 2022 at 12:19, Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> Alexander reported a use of uninitialized value in
> atusb_set_extended_addr(), that is caused by reading 0 bytes via
> usb_control_msg().
>

Does there exist no way to check on this and return an error on USB
API caller level?

> Since there is an API, that cannot read less bytes, than was requested,
> let's move atusb driver to use it. It will fix all potintial bugs with
> uninit values and make code more modern
>

If this is not possible to fix with the "old" USB API then I think the
"old" USB API needs to be fixed.
Changing to the new USB API as "making the code more modern" is a new
feature and is a candidate for next.

- Alex
