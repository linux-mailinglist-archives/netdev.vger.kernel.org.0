Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AF63E4E63
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbhHIVYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbhHIVYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:24:41 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553FEC061796
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 14:24:20 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id y18so25629237oiv.3
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 14:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x7djV8cU9LbMV7kajT88pgm0cyo38YSmnH16cnh0+6c=;
        b=IQnIucvNHK0pfJNN2pnmEFU/wNLWyA3Qq2owDANrdlt2wnUmmlqmJ0h0UzI5GV53Xj
         SmkwwalgbcnonkWR2ftVHdWq6N5PvSo8LlW2U2q4z6uZbJefgvN7lGVojUr4edep6OW1
         P7RW6Su7ZYx3s8DWXw1RQRIJYFZu4e7KY9qfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x7djV8cU9LbMV7kajT88pgm0cyo38YSmnH16cnh0+6c=;
        b=Fv1Mp6B2khnjL4yVN9z4rhJUFecPUG1BKmybQ8fgSkWBig7n05Czf9nfWymoEW6IyB
         M+L1UzE2U+msldV8blSKaK8LLYdw4sHEzF4V95Pn8coKqBbqGdPD4+xgOQ6ZeIeSmXG6
         A8tEVfigCqlrf3RWdNmZPieZtNLy5ieILkTMZBR9lSYk73FCcSCSic3lSwOJhNHIBhMm
         ENVEFNO9H6t0HcMjhBVbdOoED2jopAFIRgpyPdubqGXCB2pPJ+iVRDOk8t3sSmM5Ga/X
         R/b2yXwVxnuzMtZyESgLHadI2Oc9zyj2SDhPtubKJpHYG94wzAWhelwOAq91MpGjGuxj
         zcLw==
X-Gm-Message-State: AOAM533UZdTk6M//I1UzoSF0DPQBTBBGwWrtpraAr9BU1NiB5tSVyQYZ
        qvY1RP1kJ3F0NkZwFVSPJz7xS1Hz5wbJsQ==
X-Google-Smtp-Source: ABdhPJzdZduUo5fYdbWc8HutnzZ6oYiEqNLMVrMyxzXEHNtMw4gPHjVVd4Ghy8OZiS8ssJdCuQoPMg==
X-Received: by 2002:a05:6808:a02:: with SMTP id n2mr4947324oij.21.1628544259447;
        Mon, 09 Aug 2021 14:24:19 -0700 (PDT)
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id d8sm471390oic.51.2021.08.09.14.24.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 14:24:18 -0700 (PDT)
Received: by mail-oo1-f43.google.com with SMTP id y14-20020a4acb8e0000b029028595df5518so4169877ooq.6
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 14:24:18 -0700 (PDT)
X-Received: by 2002:a4a:4c55:: with SMTP id a82mr16548740oob.66.1628544258286;
 Mon, 09 Aug 2021 14:24:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210809211134.GA22488@embeddedor>
In-Reply-To: <20210809211134.GA22488@embeddedor>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 9 Aug 2021 14:24:07 -0700
X-Gmail-Original-Message-ID: <CA+ASDXO+GbP_WWVdO0=Uavh036ZhZiziE8DwGRKP-ooofd2QVw@mail.gmail.com>
Message-ID: <CA+ASDXO+GbP_WWVdO0=Uavh036ZhZiziE8DwGRKP-ooofd2QVw@mail.gmail.com>
Subject: Re: [PATCH][next] mwifiex: usb: Replace one-element array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 9, 2021 at 2:08 PM Gustavo A. R. Silva
<gustavoars@kernel.org> wrote:
>
> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use =E2=80=9Cflexible array members=E2=80=9D[1] for these c=
ases. The older
> style of one-element or zero-length arrays should no longer be used[2].
>
> This helps with the ongoing efforts to globally enable -Warray-bounds
> and get us closer to being able to tighten the FORTIFY_SOURCE routines
> on memcpy().
>
> This issue was found with the help of Coccinelle and audited and fixed,
> manually.
>
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-le=
ngth-and-one-element-arrays
>
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/109
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

An important part of your patch rationale should include determining
that the 1-length wasn't actually important anywhere. I double checked
for you, and nobody seemed to be relying on 'sizeof struct fw_data' at
all, so this should be OK:

Reviewed-by: Brian Norris <briannorris@chromium.org>
