Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3272B3174
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 00:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgKNXpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 18:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgKNXpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 18:45:32 -0500
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E82C0613D1;
        Sat, 14 Nov 2020 15:45:32 -0800 (PST)
Received: by mail-vs1-xe42.google.com with SMTP id u7so7178338vsq.11;
        Sat, 14 Nov 2020 15:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7WKFujjV8RSTVrCls9A9AzFUioMHCsrF9LLI4RsnmUk=;
        b=kIfMieYtPm64iMPj07RJAkIXt/G6aOszmRjoNaNq5o+e5PSjHPPDALSe2TP3I/m+6Q
         3KH8zTXgqpc3d7wXlc+Qr2G4vmafuS9VMPBFpnQIj0DoHi9Ld/Oelfyo4czgvfLi8r2D
         0kVsQMr35HsJ43fJ+GVqFWuYDFge2pRXrCw+bssJ5EOY7aKGHq/k5oKVbpzNM+pz22LC
         lOtgIjq6yQcbftm13AN0Kl6JXSK3rzB/2OuSx550DBsan6D7hzsimhjE/ziBwQxOGz8L
         vx12hlQ0PCOb8V98Satb/e7n+z9VwIIAD8FBxu56t+6xwNCp2lK1y0nLGLu2ouEVT3Zb
         1lTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7WKFujjV8RSTVrCls9A9AzFUioMHCsrF9LLI4RsnmUk=;
        b=AYd13Qci4TCvBFdES1CHujVBKxLUn+Yl72mBS8Ws0raW4hCLZlX8i5vVBRiJljm9VG
         0toNYnp9aMy2nHpVqIdAaXl6oU0qJUxr7KhQPeXBr8BK3JhhWR7CYoLhGG1CMOvRMT2d
         A6/vVtLhdLwCtU7Uykgxo9U9uXXBbg/IeRDSuIge0IBvldi6BZ88gvZJUbHZpetb2nNp
         gehnd7Lj38Qr6yo0FbrtescSdFe9t1p87qHaa3Phx3dyj6eiDSJq8MyO/hCffVxsNYx6
         yLld2l7iPXreiwO/edEewGmX4BndBNcASZtw3hjk/nvrzDOPGnQ/slrd476CUz5AhroS
         Rn0A==
X-Gm-Message-State: AOAM531b2db6ZNhCaLfVzoGr1yx6E3ZhWsmxyZsBxkIUc+NSHAYNgtE/
        ADLP/ZkHHEqEp7vOLDPunPmXobFcQ8Mn9IUbroyn2Xz7
X-Google-Smtp-Source: ABdhPJxbf6MmQi2snikAjmNxHLTjNXuu5MQ9uh0xEMg6+DNPbIG+QpVkIOGiJDNFW9I4NVZuz1dtnMIWQxKXWHpbnhs=
X-Received: by 2002:a67:2ac1:: with SMTP id q184mr5083402vsq.57.1605397531671;
 Sat, 14 Nov 2020 15:45:31 -0800 (PST)
MIME-Version: 1.0
References: <20201112185949.11315-1-TheSven73@gmail.com> <20201114151908.7e7a05b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201114151908.7e7a05b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Sat, 14 Nov 2020 18:45:20 -0500
Message-ID: <CAGngYiU+YDr5ZWSF5WBipfub_1jf3yVQ7uk4a7DXaGCXFKrEKQ@mail.gmail.com>
Subject: Re: [PATCH net v1] lan743x: fix issue causing intermittent kernel log warnings
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 6:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> The _irq() cases look a little strange, are you planning a refactor in
> net-next?

I'd like to, but I don't understand skbs/queues well enough (yet).
