Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52750C0684
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 15:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfI0Nko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 09:40:44 -0400
Received: from mout.web.de ([212.227.15.4]:35825 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbfI0Nko (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 09:40:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569591622;
        bh=3bKu3XKjBorE1hHURqVppVHhwNs947LzWK/VrwyKmcw=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=IEzEKaX9VKoVEVlsYmUH14f62Gr22AV07ohdh5LSb4zyo8KPuVXz782qDXVtiw/IY
         y+6r/88BUjAChtTw/X95M6j6qtBM4SMRpanL2ff1hQ2TI8ZKX7ueemK2LYhU26fBZF
         1WDDA125DBc7tWvR9b55GogqNw/F24gEzjWP09v4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.191.8]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lu5BO-1i3dxr3p94-011QOZ; Fri, 27
 Sep 2019 15:40:22 +0200
Cc:     Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Stephen A McCamant <smccaman@umn.edu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190927031501.GF22969@cs-dulles.cs.umn.edu>
Subject: Re: net/ncsi: prevent memory leak in ncsi_rsp_handler_gc
To:     Navid Emamdoost <navid.emamdoost@gmail.com>, netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <2bee11b1-b6f9-8d5f-1e94-5ce9d2381d9a@web.de>
Date:   Fri, 27 Sep 2019 15:40:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190927031501.GF22969@cs-dulles.cs.umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:y8wqielA7V+z/RhutSA5HTWx5Mhq4kD+x1oZNbLYL+/wJOMvUeF
 hsV4xRw55V0JS+2bEQxTInv6kyXFlv374xLnEjxjLzDTD7uM4OMyZ+jrZd+pUFGlqT7A5iz
 FUC37yQihaTTdt/d7xQCXKxOUJquB5IbzRo8iD26iu5EcPN7frqc/MJsyahPEWsjzQwrwZl
 VOgDv+J0V72dhphxjzR5w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jmAEJVSXSkU=:K6OZyOKH2sH2FJUvqQpYFW
 dRH+UBAfRf8lRF2na7F8b31cnE7FGwNhZYnsK357WNxksKgwSBQ3uA2daqz0BEa0CxP46qaHU
 t9888GTtyY0VE1l8eYUQD0xQtjbSFi+DTUGSSofUXyU+FOHayNydrhSebr2nuPFRnlV1fu41Q
 a/bpaYF4VrQguW6/kIQP5F5twe4WI90tVe8zfq1JaJNe1QTuH/J5tcR/wll2+LGOxFGoHLYn0
 MFmnLRcaylQjZprJbf8kWAFRNr46gFUtGFKjxN7IwyK6JjRC7xkXpjX9mznrcMQsL2r4aVYgR
 ITIQSf3a9OjnoagEYUN+2a5biRY92tYazinWZNSQ550V9g0cjryWrpLIfgrkCRkBFASoiHYKR
 dGMTnz63DYS8lN+jqRIHzTXgniTkJG6VNkaPaahr8SD2XDa708AI6vE88gDAUOBv1VcNKg3kS
 aTsqXwsoVtS8afd+8OtUx6d4MAeSPJZIrejScn9psVzxX3h1FGI8eloSRPHi5g8dTcAz/ZUDu
 UcKdvmwjR3LVb/65jYv64OUOYLj47zqK6zasYKXeZBOAiLeNN3LopApyvrAHd90J9NkdoaecI
 1Pa+Xd4YnIhpeF4Msyb2gbL7v5WEiapaKacewxdoMj9BFMMML28/lOgIRUEiKFB5qX4rk6seJ
 d814+EXrpHUevB2Q6+MODPXIxv4VVMbOrPkq5YjFXb09TAAPJWfOGGNHjgCCTQLIB+i387iF3
 rUP2Bdm2Xj7j5tQCy9twnqwy5AkUlmGUW+jBH1nhUlvsQzOA0lx9fSBLhFKhWBkG2J5q2JcW+
 6UKyRwOccUYCD7YQ3MTJQPZIDqrGJ1+ULzia1zYPoM2q9PjnE8vLOjOr6lvItjpVPrIv42eWR
 pc68PvX4ZoywRtknyXn91Um/Bnvyj1kO6uxZ05vd+n+zvR0cqs3zMQzLYYpFEbxpFBQYOJYvB
 kjN8+F+zWbCp4BgeFo2C65itWtLg6d6zeTD8/dORO6tUGmj31eeMAPc6p/ypqbLQ60mnBxzE5
 FwAipkJuh7KOEIOWLz3d1td1bAuGJh4wnN8UC8e1kGZ+S5MqwfPoOY5YFfrQMg+WT8rJSjX7K
 neS43yApTP3/O+yT7R4uCE7g4yyQcY1Q9IWiGe1B/aGAOjbF0UYANwzJ6xYggQ8rVYvwRfrXU
 ycavDNdXBlgRtvH7S3uFobat2lznB+nTzXHw/Xm986rQ1X3ew1ARIIHZV9hrOtCB6UAPO/+Ml
 bRCLlLrc7vZZ8X0z+iKJ+OO9d5XGgJq/FA1jduMgalP0EcfT1fPTfd0FDpGhvfnm4WN63asFW
 vvdaoj1FctQeYJyp7iGFjHBgY8wPmaYMdiiA+yrzD5Q7ra1yDhyo6GXxhxFbE4ca4yKHI0PDZ
 H8RA9MUlQkv/h18zFbTRG7IFxgOJOA5sGzqdSCR60HZa7ZU0A/C6aZxAdRo0JMGZAeYTPRcyL
 +SE5zUO9kHvh4MsBdXu8PtGavRK/sL6qsSEylKDBYKKg99kcIG5+yeESd2gKkcYRLvUkZEsGt
 bp7ohMw6KABm54i9sNjB5NYfanpyvedDVsQF7Zu4oKK+T
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > In ncsi_rsp_handler_gc if allocation for nc->vlan_filter.vids fails =
the
> > > allocated memory for nc->mac_filter.addrs should be released.
=E2=80=A6
> The problem is that just by traversing the code using tools
> like ctags or elixir I couldn't find any caller to ncsi_rsp_handler_gc
> that handles such errnos.

Would you like to collaborate with higher level source code analysis tools=
?


How do you think about to add the tag =E2=80=9CFixes=E2=80=9D here?

Regards,
Markus
