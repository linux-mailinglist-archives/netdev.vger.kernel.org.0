Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6CEDE97A
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 12:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfJUKaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 06:30:35 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:38201 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbfJUKaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 06:30:35 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1M597s-1iLP1p36Ga-0019Wr for <netdev@vger.kernel.org>; Mon, 21 Oct 2019
 12:30:33 +0200
Received: by mail-qt1-f181.google.com with SMTP id g50so6036805qtb.4
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 03:30:33 -0700 (PDT)
X-Gm-Message-State: APjAAAXjyfYHJ4hHARoVwUM1pMVNSMKAVuyOm627eQlk56udiCwv6w3C
        V7X9JNnuO5dPoBpx6qKrWRBXuBXumhdey1uBBo8=
X-Google-Smtp-Source: APXvYqxkmvhQQLmaf1/Lev5LoE6PtuB6cdqSpcUQDGoCObQX7zB2Ix9MRDNKJMF9Aj+KG4YAgDXiV5Hc+uALGVu3Yws=
X-Received: by 2002:a0c:fde8:: with SMTP id m8mr23209284qvu.4.1571653832671;
 Mon, 21 Oct 2019 03:30:32 -0700 (PDT)
MIME-Version: 1.0
References: <20191021000824.531-1-linus.walleij@linaro.org> <20191021000824.531-10-linus.walleij@linaro.org>
In-Reply-To: <20191021000824.531-10-linus.walleij@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 21 Oct 2019 12:30:16 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1qbJC+nFZD0ZKDqWE6ORbEEZbO_Y+MZBS--ym_VQ6fXQ@mail.gmail.com>
Message-ID: <CAK8P3a1qbJC+nFZD0ZKDqWE6ORbEEZbO_Y+MZBS--ym_VQ6fXQ@mail.gmail.com>
Subject: Re: [PATCH 09/10] net: ethernet: ixp4xx: Get port ID from base address
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:gOqQMqhwNLqhpr5IhphJte0gueIHe7hD4EVGNbPhuAyfbvKL64n
 QnOhsq6JjnS2GSlaczsCcqF7cPsUX4hjyxSWilUlL9TObE322PJJtyhxZmJJqT2QUz6oAC1
 h1SNn36wYNXm3X++Hnt9l4KTsBKZqZ3mC/v5fW7bN96Xzxk8OGsS5CWOjij+BbjQ0hJrqbn
 yjrMzOXyBxo7Vay1of6bQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sactTHwIj20=:XUz+5YRmxWnSgi6UQ63mFm
 aIWVJVoMPJwIOndB1rJtGczaW/HSw8siIWb7iULhm2OWu52RRntdzGo142qu47N5JZ2n2QZpk
 x4V/l2n2+RnHGZX1CV9nNBiCfiKmCcdriKElMJsb3X3wPHGhs9kbKyt8OpwAkC+q2YcMxfuts
 +wVqlxboJM9mKbZJC3pfLfJu0zxg/mj0b1wySTc6a8wiHiBXQ+DCBVUyijE7AfPfZzs0/pG6G
 8mdjFCp0l0ksA0pWOM/4mIdTJ8OltssMSlzZTJ6RZDP6dKLTyxNxeJ0sP6FYkfQVb+agHp39Y
 9CXkuIiX1QH0C9pcl7GHClCoHpixk3OMZ8mPP+5vvZAAFdnjac9/l+tgxZojkM0kncnINYNAc
 kAQPGdrQmET2Royd0w1twdiqIkow71bh74jXhmSAhukoyzPZ4k7VJTLyh/Q1F4QO0dI0BcjOg
 ANoACWdH3FRQJRAIMtJ5j65qXWMFna63HwZtPZSNrq7o2UGp78XmXz2PELVf2bRxIl8Q33bnE
 +R5gtXKA7DzUWRxGVsqF+6kJiz1AwFCGESD34V2j3j3voFMqUnw75PmpfBSgdNgGTuXwY0+mX
 ztVu2CexlmjRPAKDeNXBL2UlwLeLOMd626BUI+HHbewKLpQbnkqny8wRvMubC9J/7E6QvfX8w
 5gK9J8wUD96gSAwQXO59P+PcKXvI1l6P1XD3ag4K0ED3bjkUdObt1bec9e5Hf74VnQf9H2A/4
 rEwbYPbNPBN60BzljtWGH/buy+VIjdMLMTa0S2JdMjpTc0aGMdkquYdlQM9rLTrWd+reiP2dl
 PC2pJJslrPuIbb3WnSFnPEV6tBVqYaJH38gtnz0oB2KktMl2d4T1KtrjXZXyCY5+qtNCBf06c
 SBDfN8aP2NADCj35c8Wg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 2:10 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> The port->id was picked from the platform device .id field,
> but this is not supposed to be used for passing around
> random numbers in hardware. Identify the port ID number
> from the base address instead.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

I'm not sure this is better, as now the driver hardcodes the physical
address, and the port->id value is still the same as the pdev->id
value that all boards still pass.

Is this just meant to avoid setting the port id explicitly in DT?

       Arnd
