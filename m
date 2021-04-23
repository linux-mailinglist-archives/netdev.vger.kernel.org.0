Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB52B369304
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 15:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238784AbhDWN0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 09:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhDWN0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 09:26:04 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493D2C061574;
        Fri, 23 Apr 2021 06:25:27 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id i3-20020a4ad3830000b02901ef20f8cae8so3365813oos.11;
        Fri, 23 Apr 2021 06:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YSQOUmxdffhcoZfDyn1pZOzJ9DCUbUh8m5un/UK0zCA=;
        b=YOnp4SpVNbttkDgEEP/5xkCQU2j06ktjbcNg/lYnQLu5yhkQMNLHt8GlqKtCyFl9HP
         mqdVWc9SojGcjGdQQRHeAyapZwG0wQuRTW8BzCu7HBkw6HS6pYebGDSw09F3RFMbnp0+
         fPCD7ZWswDXawUvNGgHhDtPtaL1UUUdWRxz42HDwL6w93HFh7O4ws+G8eft3EfHH0nY6
         3bCpRz1ls6I/fg4+C8bzFXExmbmYmq46+c1I0UlbaL0zTXHSj2AH7uihHbzCXoVLmYVl
         pNXkSyUq+v++i0TJi6PRjQRSYXTxEv864zFddMmbIIyhsgwUu59N4FQ4yBBPb0NhvoYS
         hFmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YSQOUmxdffhcoZfDyn1pZOzJ9DCUbUh8m5un/UK0zCA=;
        b=CSYW26qMMyBcGSxhBq8KrrFMl9ti74qyDA5fUqNKUyDbkmeTAKcCEnt8J4HcKl28aj
         j1KtWnPsVzh5AZsahisYVUC4RGEVaaMpshqGSnT1ajsRhC8PR3gRxejS0rpFx0CicUdw
         iKdi1POorvA2cj3gLfBEZbnSxbDj4weXKniry+RNyepaAQMMLsd/yVOdnq/FaBMtF4VK
         3/exvDCefcoCz1/Luc7W8OVrI+H/L98lw59hHs/fAj25EPiTwQbOlog6i/8Im7flmsTA
         G/XtzJYMvvGuJXbVRUKkobTxTbZ4teZYen4LcXLZwgIzQwccV285EcxnYGV2ORwc3578
         LllA==
X-Gm-Message-State: AOAM531IP9Yys017HcGdrf/soHVHnl+30vqLytVY/chY1HjaSxTk58yy
        JDPyGYM6q57oT+lUf49Xi/aAqv9YYKZZ6OkcMUFzmVXM4gc=
X-Google-Smtp-Source: ABdhPJyydSyE9r/cpqFz9BOj5MNgKdm2RdyKTY5UuN0UGF2KtE0bOu2EmymS1MMcmAHAuZCk35rdmmBg1q8qVzUB70s=
X-Received: by 2002:a05:6820:34b:: with SMTP id m11mr3003508ooe.49.1619184326731;
 Fri, 23 Apr 2021 06:25:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210423040214.15438-1-dan@dlrobertson.com> <20210423040214.15438-2-dan@dlrobertson.com>
In-Reply-To: <20210423040214.15438-2-dan@dlrobertson.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Fri, 23 Apr 2021 09:25:15 -0400
Message-ID: <CAB_54W4T_ZpK2GGvSwwXF0rzXg8eZLWNS6wru0sHq2kL1x4E1A@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: ieee802154: fix null deref in parse dev addr
To:     Dan Robertson <dan@dlrobertson.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 23 Apr 2021 at 00:02, Dan Robertson <dan@dlrobertson.com> wrote:
>
> Fix a logic error that could result in a null deref if the user sets
> the mode incorrectly for the given addr type.
>
> Signed-off-by: Dan Robertson <dan@dlrobertson.com>

Acked-by: Alexander Aring <aahringo@redhat.com>

Thanks.

- Alex
