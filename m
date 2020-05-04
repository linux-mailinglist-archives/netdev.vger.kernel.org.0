Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049191C4252
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbgEDRTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:19:43 -0400
Received: from mout.web.de ([217.72.192.78]:49519 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729690AbgEDRTm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 13:19:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588612756;
        bh=BeE/XnA78cYGRlTeteDOGlcycZ9D1xVSiYLpmUc4pE4=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=bhzzVJWe0KkJaOOiqUxuuFm3TeTEOuWxXehLFU1fp465VmZmHmZUIK8nI4YqbZcNx
         7aja7wl1dU7tdf1iPMtoFrButvavcRv4QVEuINV6y8z87E2S1RCRBU4ykThnJIFVV5
         +PFG5qtEvNP7/zSq0+i/E+bWictAcY4gJYCd+PWM=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.152.69]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MDP6H-1jM4VN0hdV-00Gmx9; Mon, 04
 May 2020 19:19:16 +0200
Subject: Re: net: rtw88: fix an issue about leak system resources
To:     Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>
References: <79591cab-fe3e-0597-3126-c251d41d492b@web.de>
 <20200504144206.GA5409@nuc8i5> <882eacd1-1cbf-6aef-06c5-3ed6d402c0f5@web.de>
 <CA+ASDXOJ2CSzdgos4Y8Wd7iZjRUkrMN=Ma0_-ujG8bihGzPKkQ@mail.gmail.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <70a010f9-1439-b1f2-bbd2-cb536c546dc6@web.de>
Date:   Mon, 4 May 2020 19:19:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CA+ASDXOJ2CSzdgos4Y8Wd7iZjRUkrMN=Ma0_-ujG8bihGzPKkQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:weSFy8FO26DkgvXAFWH/8IuKfF815VybzJtTuACSNMU8VyXuGuq
 2f/ix8Ml7Ao+0MzRvKmroancAkiP/v9OHLao9dCD8dSEgOGjh15Fpwx8aPTFh5QeSynTf76
 rTU8btfpwwcry0oG6qQfu5z5Z/J0mXXrfNvPQmajajJPUfDbE/+Jwk0lj+mSyaUtKbRVeM+
 S+TiuNCN9BpvVv5o0Lzmw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:eurdMbPiP2g=:ra3lkT3T2uhunMpihMLUne
 r+qv9CenweLAvXxH/pGm5SDPQ6axUTUngksHK1tqC4BDdJCtmmWu3KTBpQ6Sd5ICJoy+2i2+/
 gruUFLVIsrNTaYEO7WFDf5X4KsbqcLIIpn0r+TBWcou8SNRQ1ngUiAzhdlEvnL4cIxLostB4n
 c8mmiW+0I69aLy+KEqyzn3XJigGExt5Tn1Pxiu6T7QXYEdq4jiaGZmSTYmgCdwFhWbZkTsoWF
 uKKCni8ZL9PSpBszJQ91XleDyTE48P8YWYX+XJxKSYjhzAQrCA9uNiEdvjYKFmORku7c0MA2P
 gOka8LrGfo9xROEUDxvSabnnvgDGPTCVtsdowdJ1ZmTL0cJ5433QWNyf7VSmq7VvQh8NONDQP
 u0TPkXD+dyPicQwz7mDBhQU8ynURjqeGOxV1QYbqWnBScYjls4r8zqxnyZga8nwVQ60+EHx3C
 1UIm3p8T3D7Ddcj+prvn7ZrMDjZ+W/D2XgKYEUEpqRgGaA+44wvjbaELe1qhio1XoV5FHM8Aa
 J8XgCmQlYMUbzE1yZX7+r3UayT0JgmWCiMCNNJCalDA1SM6TbOeDTqJoEGzyFL9hsh9PSRBZP
 mbrsdxmgdjnzfePHTWqVMYNvD30ic/UgIX/mH8UqJY9NM55N1orodF3GLnHw9az95g97qXcsc
 TxruB9NBvKRwo7uuUUK9d3betoLIH9gephsYGNZy9scaNtuxNEsME8zs1SwrzRvQvG4w7upkz
 ih4nkKhO6U7jgHMIL6qS9ztKDI9kH2qAanh+EXdEOZnYfHqDZaSxPfplIfqgpAZqVhPhhuR+P
 uVuRY3v43Nw0dfBasDeLzyt3P3k173ott29Dvjh0nuxukhhf5dSdwqCZQDPVNbasegygtrHAG
 eOBnpkCAdQpa+h+FfY2+sg6BSiDKICA1Gg8TO11Csn+jVFPJqIZCGrPTFumjjR8N4KJMY3wu0
 wosqhgYMi7Ly6JLKqSU+pp8u8+Kwk9ngBNT0g7fw+PjqPFVuS5fm/izojGnNprtbyemm1nVSS
 qdon3/9LdWpLXsKY935jWD/4bYdYKqB11o4g8SD1qLafV8EPQbphVuVi+atZJCPToYiUgMrKV
 4dcjf8+5s45tKhrFlF82RzVX5IJfDhsXqR+ey2cgTVoZeTmBgU5MSIdAG8S9CubsF5hdz1Lfr
 Rnawf/cwnNV24hQ8iBApJtK25ui9a/Ll8t1mUzzETtE9quwLasIpZmgKJwnwbfW/4cdUcU6Ly
 OcyHONbKyWNBPb47U
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Markus is not really providing any value to the community.

The opinions can vary also around my contributions.


> Just search for his recent mail history -- it's all silly commit message
> nitpicking of little value.

I dare to point questionable implementation (and/or wording) details out.


> He's been blacklisted by a number of people already:

Such communication settings can happen for some reasons.


> Some people continue to humor him, but it's mostly just a waste of
> their time, as this has been going on for years. Just look at searches
> like this, and tell me whether they produce anything useful:
>
> https://lkml.kernel.org/lkml/?q=3D%22markus+elfring%22&o=3D5000

How do you think about to take another look at published software developm=
ent
statistics in constructive ways?

Regards,
Markus
