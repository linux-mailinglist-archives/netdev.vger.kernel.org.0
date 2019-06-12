Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9AEA42F5C
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfFLSwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:52:18 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:36388 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfFLSwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:52:18 -0400
Received: by mail-yb1-f195.google.com with SMTP id b22so5228083yba.3
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 11:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MvXZkHYaRJ/G5sOdpdD0Ju+Q6y1BtRzvQQbKkNY5wy0=;
        b=uBS8ftAc8/df3QcrYMqBu8yfmuiqiC96/couzCebBImBPflqWyNOQGkixJlJMXqhkZ
         QsQ+jWibExvFV14St243EggkUT1AIte1v7kpHlLEuFt1dkMLF3QLjO7oEq92yGpX6+Tu
         FDxDx1ldc4RPvMadOVlPdHoHlE4aZMrawbVyi7uPIsboktEGkH/U3wB0FtPZxApMm5v1
         an5QFFb4t/qIV455Cxw65c2j58k7bsQpRaggekc5KbnHD7P3xc4XCVfRBWaP/YiVzKRH
         Ge4ZgWO2GvRWaxJwWvLE6KJLVDERxozx9DGVn01QI4m3+H0qiiij9Xv9WoC1B1jC1N4e
         TyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MvXZkHYaRJ/G5sOdpdD0Ju+Q6y1BtRzvQQbKkNY5wy0=;
        b=W0nGcqWjH3RXX2vo7pxn2UPPDwzV9isOt1kBNJS/+28WrbhK45xjgXnAvwvsCNH+q3
         /jt1KOQ+9OnLWyK86+lLks6tfNdrvZFDqYwWTH46US2uCLHxDUDq40VLGNsQVsMyG6Sa
         Eh/+GCAtT9p1mfKWjyO/mzmK6NtHPQL5gqvAaSeFNmm0EJGQMAi0fii4+byjmBc0awGY
         3AnhM265SItcDs8FUVDcPdP2YxFLNbWH5CAwyikxB90Arbxf7FjR2DZO1mW7Bbw+iHgb
         ul2c5xtjUOn72rMbBcoZSbv/jw8dFqB8pJylbp4pn4j1EnrLLVojBaKaaWdth3tDL2ni
         6Alw==
X-Gm-Message-State: APjAAAX/J7qi7s7RMWty+CPbWzl5jAyJfMTiUzkM/+7w3dSBD3VLFvSU
        +dPPoVZCvTldutw94aLLJYHY/ezPcdGaBok/mavhOx6pdis=
X-Google-Smtp-Source: APXvYqw4H6PmylIqYof6T4gagqbYZrxVHGEuxRf/HDNzL8lYGle7hRZw85DA8D9aStGNqdPUQES7KIF/Ie3UeRi3EK4=
X-Received: by 2002:a25:4557:: with SMTP id s84mr39512633yba.504.1560365537134;
 Wed, 12 Jun 2019 11:52:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190611030334.138942-1-edumazet@google.com> <20190612.110344.817827105748265826.davem@davemloft.net>
 <20190612.112114.818829552569501636.davem@davemloft.net>
In-Reply-To: <20190612.112114.818829552569501636.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 Jun 2019 11:52:05 -0700
Message-ID: <CANn89i+sgDq4chT5EJTS_Sd+vd2jZtACUOReEPSF--tBK2CKSA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: add optional per socket transmit delay
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 11:21 AM David Miller <davem@davemloft.net> wrote:
>
> From: David Miller <davem@davemloft.net>
> Date: Wed, 12 Jun 2019 11:03:44 -0700 (PDT)
>
> > Applied to net-next and build testing.
>
> Missing symbol export it seems...
>
> ERROR: "tcp_tx_delay_enabled" [net/ipv6/ipv6.ko] undefined!
> make[1]: *** [scripts/Makefile.modpost:91: __modpost] Error 1

Oh right, I will send a v2, thanks.
