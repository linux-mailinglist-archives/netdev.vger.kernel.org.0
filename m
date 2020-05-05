Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1281C5180
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 11:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbgEEJEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 05:04:12 -0400
Received: from mout.web.de ([217.72.192.78]:47763 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgEEJEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 05:04:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588669425;
        bh=sbmEMMiBSk8bvwWZ/D3b0FG5iaQet+xYwsgtjPy4XYY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=kqHZgxMrp6EtOUTa/gvQWxqNJbXHNRtBroLBYq6Y0THm4b0vSiIpJAmj4usA64VUq
         lCciQdSpoPT9n95zyQpivHZz2uVntqiZPttfzqKbMxtJOGMvLpLpctbH8MJJZl/Zeo
         xyaFOTTepNiEGGv4MYx8UvCup9Jc9HQ9SjNfujSM=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.132.123]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M57dy-1jDxfC38WM-00zIaY; Tue, 05
 May 2020 11:03:44 +0200
Subject: Re: net: rtw88: Fix an issue about leaking system resources
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Dejin Zheng <zhengdejin5@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>
References: <79591cab-fe3e-0597-3126-c251d41d492b@web.de>
 <20200504144206.GA5409@nuc8i5> <882eacd1-1cbf-6aef-06c5-3ed6d402c0f5@web.de>
 <CA+ASDXOJ2CSzdgos4Y8Wd7iZjRUkrMN=Ma0_-ujG8bihGzPKkQ@mail.gmail.com>
 <20200505005908.GA8464@nuc8i5>
 <CAHp75Ve43za_hAQbECPTFS0eEqSeYJtq3bvojmed=-6g=3DhvA@mail.gmail.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <7442f3d4-db99-30cc-7eb6-79badda2f8b9@web.de>
Date:   Tue, 5 May 2020 11:03:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAHp75Ve43za_hAQbECPTFS0eEqSeYJtq3bvojmed=-6g=3DhvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:8nddOyafvuTrOU8ir6S//KuAEVImUUucqnH0/fetpHYLX+iMFWh
 jeJ5ASXSmCIbHLStQ6UWwKyaywYnb7Z+u3XivVkUaDzYOgPAzy3gEDZA0zApU2E1gL6I3L5
 PdoZW4DNR56qV32/rLyft12/3THD/6DD9v3rqbYX0xqwVyzsCDrGtCJcuUOjH9p3OEX9azh
 ek8P7mnP6TRj5HjtFxpcg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Lv72e3Xl4nQ=:X1HNxaVqkqD2NsGSOaqlJc
 nQBrb2oxqR7UFRWvRJtHoSnLewYo9o/I4xzK/Dcr0avYvKzJcAmixuTIxvOB4xql1vmR6/S+4
 A6/TIhKiWZTXCmmz85QRuo+YpZOOHiz27ASgD20Avj7sy0jTEoSi+j1ddN0X5/tLAed6LetO6
 C/S0D4GUHrncXWbfot/WOpkfLeJzgDAlc2SEyuUMLf2UqYiMiZUK8jdPS+V6SK1EIAy/tDLap
 UtcWGD5i+vHJsGFKHZjJrM1neocf/p1zoIZF/yts8/ZWkMNyM5Ca3zQ99nEpAaoExVLgIEsmv
 Bib9IuIRxX5w7UdDWePq8FAFZWnVwqs7BJ7fNXIQfHyo3N5nFKKGdnLsTqx1nJsMvd9NABozZ
 8u4lS9ifO0VWluHHDWlRpi7waQqrATAWINmvl9dlHNbbtWcn73D6FrcRkyjQ7tfEuBA01f5gx
 alm7bhQ+wM4LQeB5Ie02t0OGVX0lKZcBASbACxu9RvDom9SuarUJdSu4txAyLEzMK6YJQezg/
 92w2v1Blv6AU1lsxV6pnLfk9IIc2VzhycM5WrFtZCLA5uftuZEqbcQWtY93fagv3f7Ho93Cdq
 1tSR4Tyou4SbD2ZSCYdCkskqi4LtWTWYt7FU1nXIxufzGhJ+S1EWTl+QvgRPrE8pSvmQ7L79l
 JUIelBE9+TB9jKeeJJ8Gov86JWdj5g5889ZE6bLSrSAY+Gw2/EMsdsF+WyEODzw22rVGbIm6d
 s7mdscUxDobijScAbvjLZC/nlgsc4YVZMnBLL8vHPJIN+NUneJDNDU+YKptrEMNKK/M01cM9V
 AnGil804YPpq3FxG8+s/yy65PZJex1Csk8OyBnBNpTQBfyZkDGf4SeJ5Ds3CYeN4sGZB1ZKnu
 87Mxw4bIX7sqjD/Yj3p1Rs375ZSKnGI2Fwwp0Uq8o8yxAwXi7yBfpBC9pq9wV4DRFRP6O4FwL
 BvNm6H4h/JUc4MQwkt6SaGYy+psbE8QlCV5fy5Mkfu5gH2XRR0vw+hFzApZV1aJeY+W4jmUHr
 L45M03wGMtD6IcSQlW21caSUGFedQY/ovVUNDUxjcvvVYTVt3lpDmb5lLjkZLi9vnWs9AJ3Vg
 1ayDUzxtECyHcE2uffViSdjhS7EqQpGa1rukp+bRgYPTPZjKZDRaZ32wnPx9aHAzHggsQuOo9
 cfUQz3/LvhsNtMkwn3y+fWY/WvNtyb1sdrW6Giony2h+s/Lvz+BkQ3DuW4Us+8jTqn7qaMZNo
 o5FeYYDsqfYdgJGnP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Perhaps we need to find a good researcher student who may do a MD
> dissertation out of the case :-)

I got the impression that some research is performed already around
affected areas.
Would you like to reuse any more experiences from there?

Regards,
Markus
