Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8773746D64B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhLHPCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbhLHPCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:02:40 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78633C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 06:59:08 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id a14so5287134uak.0
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 06:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IRg6lEKr1lOw4Rw/3dZod7sl+txhTgv9VJUKkRMWweg=;
        b=ojVIL/yMiamVrOKShlt6G7Ocdv4UflTw3qqVQjQ5hFA/k5i4YHDBDXlUhiShgqC2ur
         Hk/ylrxZOn0cR/YqL2rzyN1GioqmmaZ9bI79fTealIwFGcan123pyN7ScBzZZ1IH6V8J
         3bIooTQqGQkeRlrKKSpMZgSXRz0Fa3a7Sho23nF+ySp6gvJ6W4g1Kb9VHwGgK08FkTYm
         wI1IX0NQzQynhKg7Rr30h6+jKDW7Bu2WAvzEXz88CGA5sj9qi3zR7rGLumg7mMU3M9mP
         S6uZcVaHWFa+mhZEM/Hw4TKYOCBVDcXo5X19ghf+TLCmQKOC0NtPTrlXYnEMLU/WVYoB
         k3rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IRg6lEKr1lOw4Rw/3dZod7sl+txhTgv9VJUKkRMWweg=;
        b=iK+p/l31C67yR+bIIsLJ+4NQQLjD4vu0HVq1qtpgwQTT8SquEjOtkmQWMh4rAmyv8T
         C38YffuaAHsH4fft7Pq98hujAblp9atQznknAgl/Lv1bsd1D1c2xTHP16viaBz/4zLd8
         jTrMqOIUYHSipE69cgOeny37/NH8ftzCm+3eDWWe0xWtcuq1SsQrjF4fa3reeusMtWUR
         lBKFwFaQYz2c3M5bY6+0UHA1PsKw20d+Qm2qGPRu31fefY2KUu11CBMT6GUhOVxtDATT
         +VSq1O+teOUjpiHmZra7/1Lo91lK+BbO5qezSaUP5jeA2c8pDIBNqvlAhannJxcJSE9T
         dg8Q==
X-Gm-Message-State: AOAM531mUFMIHYoRIvNZYkjw7U3FBePsh8aXpUBepbKLMe3Kc0/k5xah
        nCALHKfvX37GhnwTBqkdYBz9jKD/ouE=
X-Google-Smtp-Source: ABdhPJyhMjIwbIGdk1NFjwRhMzaFC+drZnDSEys/brXv/h4d4aymfyiXROrC+s374zFE+42vUIcChw==
X-Received: by 2002:a67:2dc5:: with SMTP id t188mr53057594vst.2.1638975547642;
        Wed, 08 Dec 2021 06:59:07 -0800 (PST)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id y22sm1871478vsy.33.2021.12.08.06.59.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 06:59:07 -0800 (PST)
Received: by mail-ua1-f51.google.com with SMTP id j14so5120566uan.10
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 06:59:07 -0800 (PST)
X-Received: by 2002:a05:6102:4192:: with SMTP id cd18mr54036428vsb.35.1638975536987;
 Wed, 08 Dec 2021 06:58:56 -0800 (PST)
MIME-Version: 1.0
References: <900742e5-81fb-30dc-6e0b-375c6cdd7982@163.com>
In-Reply-To: <900742e5-81fb-30dc-6e0b-375c6cdd7982@163.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 8 Dec 2021 09:58:20 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfZf8XCYQEH_LZmEbrfGxhDiRkbvfrC=RULoqqVuVr=-w@mail.gmail.com>
Message-ID: <CA+FuTSfZf8XCYQEH_LZmEbrfGxhDiRkbvfrC=RULoqqVuVr=-w@mail.gmail.com>
Subject: Re: [PATCH] udp: using datalen to cap max gso segments
To:     Jianguo Wu <wujianguo106@163.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 5:03 AM Jianguo Wu <wujianguo106@163.com> wrote:
>
> From: Jianguo Wu <wujianguo@chinatelecom.cn>
>
> The max number of UDP gso segments is intended to cap to UDP_MAX_SEGMENTS,
> this is checked in udp_send_skb():
>
>     if (skb->len > cork->gso_size * UDP_MAX_SEGMENTS) {
>         kfree_skb(skb);
>         return -EINVAL;
>     }
>
> skb->len contains network and transport header len here, we should use
> only data len instead.
>
> Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>

Reviewed-by: Willem de Bruijn <willemb@google.com>

Thanks Jianguo
