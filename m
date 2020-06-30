Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D233920F88E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 17:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389616AbgF3Pkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 11:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389589AbgF3Pkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 11:40:47 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B229C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 08:40:46 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id x62so15907700qtd.3
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 08:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qb3MHP+9Yx8ngAJjufY4+WZw6DGzrksHxAvRWggF9RU=;
        b=UvMDrn+tvPXGoXPFizbfY/HG3NUNSGnxAwIZNS0Ya8YxAYV11NQkSFijRi7jn9xZGa
         bzOVtx8EwCg4RtTPixvDeAg7ipv3wKgAU7EtjDYpY5wKCfw9a0tkzlWY7X2ssejnTi72
         wt6EyGS4k1htbJB7eBBIAgC8AzoP+WEzKpxTXRtwNk9VnAyoFlSqd7w/HvSEhRl4rH4K
         fnJbxVLkPiu01xgNHKeyR0K0CjCibf7ZfRi90DwpxhS/Wld4ZXVrTwLiPPALnDCBnABq
         m7fhw+txcinq+OUfOUjgXeRu//JPizClw1bidHOw6zzeIVFUwN6H53yukaD8ka9goIpl
         XpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qb3MHP+9Yx8ngAJjufY4+WZw6DGzrksHxAvRWggF9RU=;
        b=raEql1GR+TkPy6dAZHluy0wahgH5uXrAWN5M2dfpHmEuCFUbRwVmTmQjg1ysqpjq5T
         CStpNnhjN1CgLnUt9G1njL3RI8ttUTP1YCFCwbBxPOnNtgox8qTd30eCmmtjVNiusZXv
         1oQ/KL7nLq73tgjPzADAzY8GebVn6jiHL73VwpV8DSIDvIgi0b/GkqWXd2eZ8oDNsoB+
         Hi0gdViO+5HMgz6/HIMjWIPdUSmIQ+0C9QLdIEm7maN52CgJpm1uzpFIgadjLCJjT/Sq
         fSHyJ7tB3+9rSarDF55sZb2Jz7fZcW6uAWHEJvBQEJ55fj87ep2dPjkVqdWZyyDl2Xfy
         Uh9Q==
X-Gm-Message-State: AOAM530Z5UtydKyop0J/1Acbm4TpFYb15p26jxoQ856d81fsAAoIe5kU
        Srbo26zl30hUFuM7aUjvTv6lOCpp
X-Google-Smtp-Source: ABdhPJxhBiN56prk24OM9F0Frq4pM5DyZ0xN+Prc+rrrmIVdjH18r2BEnpIuimssVdWGtqllZ4hGlg==
X-Received: by 2002:aed:2492:: with SMTP id t18mr21856628qtc.353.1593531645472;
        Tue, 30 Jun 2020 08:40:45 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id l3sm3334755qtn.69.2020.06.30.08.40.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 08:40:44 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id o4so10334258ybp.0
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 08:40:44 -0700 (PDT)
X-Received: by 2002:a05:6902:6b2:: with SMTP id j18mr11803497ybt.178.1593531644030;
 Tue, 30 Jun 2020 08:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200630010625.469202-1-Jason@zx2c4.com> <20200630010625.469202-2-Jason@zx2c4.com>
In-Reply-To: <20200630010625.469202-2-Jason@zx2c4.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Jun 2020 11:40:06 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe8JiOuC1rGUqgGEjhzbhKYqWRHdATQ699s+xpkDy0F8g@mail.gmail.com>
Message-ID: <CA+FuTSe8JiOuC1rGUqgGEjhzbhKYqWRHdATQ699s+xpkDy0F8g@mail.gmail.com>
Subject: Re: [PATCH net v2 1/8] net: ip_tunnel: add header_ops for layer 3 devices
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hans Wippel <ndev@hwipl.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 9:06 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Some devices that take straight up layer 3 packets benefit from having a
> shared header_ops so that AF_PACKET sockets can inject packets that are
> recognized. This shared infrastructure will be used by other drivers
> that currently can't inject packets using AF_PACKET. It also exposes the
> parser function, as it is useful in standalone form too.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks for fixing this across all these protocols at once, Jason.
