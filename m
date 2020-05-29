Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD001E78EA
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 11:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbgE2JAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 05:00:43 -0400
Received: from mout.web.de ([212.227.17.12]:59533 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE2JAm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 05:00:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590742821;
        bh=Gdrd8HMdFjdQQEj+OM1brUOPnk8SH+3L36xKJJxZik8=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=hKVO+KVV1IZRRdQbYBSns+FL77+9kwG7f4lnId8uAa0xQvvMtgCRjmuh0oXLy0L9R
         3unr2oULXvA7+dRLI1dDSKDAcpqz22ll0VTM5hCklyEJ6LhvUdoOT9aW44Diq6MyrG
         713VEF87gxqh2Pu2KGDb1U0dGSZnM8hiFdnC+ujM=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.165.0]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MGQGF-1jmbcX3UvF-00GrVJ; Fri, 29
 May 2020 11:00:20 +0200
Subject: Re: [02/12] net: hns3: Destroy a mutex after initialisation failure
 in hclge_init_ae_dev()
To:     Huazhong Tan <tanhuazhong@huawei.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
References: <913bb77c-6190-9ce7-a46d-906998866073@web.de>
 <9c50ab14-c5c7-129f-0e51-d40a4c552fd8@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <a877924c-cade-455a-15b7-2e97a12534a5@web.de>
Date:   Fri, 29 May 2020 11:00:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <9c50ab14-c5c7-129f-0e51-d40a4c552fd8@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:I+8NIhqc895oiWm/hSH3F0ueqNHh8XeEc3fLZ2l/IZWqio6Sh3h
 TR7tdqWRljdxwjyxSLsiw2RVHsiTC25lKUw39eGV1BbJ9ioLMUIfbBHtpPWAaeZG3yPCjsQ
 jY2jivhyD/FMJ3n3dLOhh6iSwG4zKtjJkAfhwDCJ4EFVueW9nPSMTr+7HEOcigGWix3I786
 X/uHonISNgPtqbzpuW+7A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Z7bO3NL7LXI=:+wYF7HqLQkgjNrpI2fZs12
 uvVEenQYvZMMs0xj6NJLV2UChEfI6Vg6kSOhHj1dx76jM4pQK4E/B2f6bylximBtPwuCCbDdC
 vNSkctXAqxGEnd/IbEeYJ0JLtCXhm3iaiXVNfrniAyXvY1Eet2N81PdDuDogJiO0wdbIi0h8o
 vVz6NLN9eRZtyy4bbysrpjEwsYuj1kxulEEPfR/7U+ydTihdWrfz5PqbfxAb9FnXZtjVe6QD7
 M1gKuq3veiLhWgeBER967w2K4oXNvU68xSq5L50sIlsDMd5idmB9Q/F/n5POYDd8mZIe/GpTG
 QRz1MaujYTLC+uQ84yjZkAJlXLhFmjyB2FVZyz+Zo7tk/YKGvE3ZA5UbVTEiOLzFVyVDYRMPL
 WN0VYCaezmCg1jRISMSP9JpmuhUZpm2wZwppd9+2Y6gb0eeBdGBQfedDUm5x3oJP+5yGTBmpt
 /5hxau0g3vhlVqNkUdIIlmzJb1nXzjFrQIgeb5w0lZeEVjoUrJVFSrdvGKTf15SOzToPrBNAn
 +gDtceEhURTWOdsixT5KdNMbbJRK0O0z7HN/8fusuSp9bMZstA0is9rZoVE1CQTWjS0ul5A0k
 V97taiHaGHQlaW8iBXwMOowEEAXWoEWiFohRm3rpJKGI54wRzfyWTr0kb6FK7ZSk5TMBA02Pg
 J7qe3E5dNnrz1/V4dD3mfjqbSDonBJzSvAuW7Un0Yjt/Z47BFSAp5/i9XHAeRA9vdhb1b/xya
 nPCoIBQcQs/AJjV/DLb50R7z+LPFwlRbtKNKzMZ6vswjJFfmC+zZryeKzKotYjbab14sLxeO9
 wMAY7LG2jJIAVO7M+BAdsXP1rUAZaFF/JXRNciIUC18/mGlhft4icHzUKFJdrpk7aztgjgY7o
 KOgj0FFb+J5wF1GJv4/urvQi/gxmUB6f/r2ktEsvhevRjLrbHTwlUCIVtFrR/ZwhFw+IwNC6M
 adCIknnNKrBlEKTKA4BXlOlOmVVRY/vcJGoIIkXvoJY8Yw+HzPEpZloxtNifJNlwboRSzuO0m
 U2jFpmt7WljLaxznFdksOT1nZQlRTjUPDQT5SJu7ORUhXYMv+8ZzViTAj4HZSkCFfOWtVRAoU
 aZJKfSoA65P+TgPcKgvFkdYe79+DNH+23ejeWfPLHUC8vL68h+o7murXlqCH6mM4mjSFedBRx
 Q8oXtk1vPfg7WYdciTOxL/aLidjY0wG4HMgWe9KubCrRs+AK8RcqVz1QNEs6WNOyXQR9L3TEr
 +B+bD+tipztHZKluD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the commit mes=
sage?
>
> Since it seems not a very urgent issue, so i send it to the -next

I suggest to take another look at the prioritisation for another
completion of the exception handling.


> and make it as a code optimization.

I propose to reconsider also such a view.

Regards,
Markus
