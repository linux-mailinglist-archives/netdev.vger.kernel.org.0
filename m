Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D3D1C4253
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbgEDRTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:19:44 -0400
Received: from mout.web.de ([217.72.192.78]:50559 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729751AbgEDRTn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 13:19:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588612755;
        bh=BeE/XnA78cYGRlTeteDOGlcycZ9D1xVSiYLpmUc4pE4=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=EY9kzD9akof4oERWLtjgYubA5ZeUZOPCiDbTnUYnSAkMuGa6ALtGQMk85Gu7kMzJO
         bWp3K5CH9ZU0K28cTNhNcj/f1H1prsF4caO1petGRPf7lxxH8UXr854ItULYLSQqkf
         msjoZSEqY6kCEeMzGiIVz1TKjtp9izVpLzyEtWsE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.152.69]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MREzO-1jjtqB1L8O-00NA2f; Mon, 04
 May 2020 19:19:15 +0200
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
Message-ID: <db4c6000-ccc3-6113-96db-b7a69297156d@web.de>
Date:   Mon, 4 May 2020 19:19:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CA+ASDXOJ2CSzdgos4Y8Wd7iZjRUkrMN=Ma0_-ujG8bihGzPKkQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:as2LwTzBskOWCD4Z/OJdWM4e5FnwtXplAMm/VUNVBv9JofaeTLW
 RnexyxWVE7/b70DVT8Lt6lSGP1PbitFKWTkAxmZKltdksZkl528t48vU9o8jgpj2AuIWqDS
 2puZ5mA19SLRvEzDXcfS5u1U0Q8F9kVL6FeuEBZsd7eBgGbHikA3LXzaOIMnuvOcBVfTvNU
 LhgwTARsmBHoHyhNRHugg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:s9mrU1GOSho=:geT4fKMpQO0AZEpCx05gRB
 wFEmSROKwRCycx1Jp4r05GI4/VkT5/vUl9v5PyD/+fwgp6uwSJJk9+xoRPwPcR08lNbG2a7Ug
 Tf/mH7/aMbVzASDHwjAMxyEjEI/GQSvdf0o/6+Lz1JqmZGH5yxIHerYjMUHU59k4YcdUyXNcX
 a+e/Od2UIgUAdMWOQ2+v2ilc1FUoqVawifVIjTa9WdGws8lsPqe0PbmojPstUzLSSTjNQTiR8
 6Y+RONykXjnuh3eOaH1CKEEEzJzGKDPBmjTD/X/68YdzxBZsryc+D/XoooIAHHZgGCQgD36ai
 WxC3ehqgSSlO3xqAwvDxTOiVd1rkSyW/3CC4t3Ugd0K3Qmr/gbzCJoq44Y8jiU8Yib7RzwF39
 ggCc/cgZA3CXxdzOWL9idSH8PwDt+UPvBQUe7TFhicPYfgarlMtI+g55yiipdkmBSJBxALj5P
 xpvLc5KPZzgPQWxH+atVnCkR3zHySFXvS2QOv5yzdTu7xv7TrMvevhFe/ccRgX/yhYf2/gnm0
 8nrfoS6P2Pj/UbSIMTTv2uUABuYpSrxx1sX2ekLIC27g7PCNcGb9FRWIPjFkmwA+L9CWB950l
 A1SmQhzoR9bCwShnjpL4jBoN+y24Ga0FToCU0Bndm2drAobBucwEqijCHQBFC7T5OmR/a5juv
 +WHTNaO6pWM77S99jhplc4uwUZCySVfwqF8pTYYMu5hKNCVdx3tziwEOKk+0a1xm1XIC8m8f6
 2tJfJWFWN0aC22E7Wzs9CN7OD6ZKGFnR3eTZektYo04+2Q4dmWHTGWmf6UxKD7YqpMS7utYtz
 Ayz2e7WxhgYqSX/mIxEKBVhx2MdNh/7OcxeB0SWMCi5qI3DBSc3cNU1QJFTC3YK635SkREUxe
 rYxnrSkoIvyVTYytNek92LKxO74zin24wQ/qLKUFtSJL+Cw6AIWfmINGBS6F/hbp2OoDqYvVK
 oAZybnBW/RSTH56WJDvawOJwtATUryGSAh23P3lGaTwNlGW3s9FLzZflT7sIIptkD0r8RMYk1
 vdfrDIgFWHvSkhoCooqoaMReuykZRJZIDOJQnij7oL/QwUAeu6j7VvEl7DYDH7l61yCVh01rp
 xW7MLZgpmIJN0UcB3anSUMsLo3jSqTrPpQ07sXbMfcwb8kHqGCkOBaB7xuMe4ftRb6R4cqQ2R
 jt0/43TXEYJ/Mbp6GTtynnQr9SPfZhAxUtpd4vnMG/777hesqi4umiybqwuVYGh02rRp6zJXx
 gGPiZxIan/f/J6TYc
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
