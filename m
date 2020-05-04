Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC061C47C1
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 22:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgEDUOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 16:14:32 -0400
Received: from mout.web.de ([212.227.15.4]:40017 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgEDUOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 16:14:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588623251;
        bh=fM0qlrt2nxlUHS4Lo23+CVfKwk8o4EthxceeGf2zWcQ=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=gRGwNFL4aqk3ftRPT/XVgKszD4NxC5QJwT7DfO5aAVvSRyUP77T3BgNnDOOXkx4v5
         pHP08SLR542bd3AYKhm1IsScaseSL+w3MB1vdW97c84WYhAvGsFdSTviZJZVVjAv+f
         /1Y/o67CKfREnINCTw7reg1Tm9zg1V+4m3rt/6oI=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.152.69]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LtXDY-1j6Qpr0KAe-010scS; Mon, 04
 May 2020 22:14:11 +0200
Subject: Re: [v3] nfp: abm: Fix incomplete release of system resources in
 nfp_abm_vnic_set_mac()
To:     Qiushi Wu <wu000273@umn.edu>, netdev@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>, oss-drivers@netronome.com,
        Kangjie Lu <kjlu@umn.edu>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20200503204932.11167-1-wu000273@umn.edu>
 <20200504100300.28438c70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMV6ehFC=efyD81rtNRcWW9gbiD4t6z4G2TkLk7WqLS+Qg9X-Q@mail.gmail.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <ca694a38-14c5-bb9e-c140-52a6d847017b@web.de>
Date:   Mon, 4 May 2020 22:13:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAMV6ehFC=efyD81rtNRcWW9gbiD4t6z4G2TkLk7WqLS+Qg9X-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:+3OdVBq/w0xTpg7DCIQ/+khai6nBBgVHN2yAtWx3B13sQPoMJ2b
 jKJndxmjJmCwOQp/bNhZ1jjRQFDctmm7HHcrTbvqi1NYtTF3ETyFmbUamQNTjtiT10ixQgp
 J3fIY/oR5qKEjBQUqn2039XAkPDurHMhf2P91tf6jxAI/kdPvPq/HcCqSwjVkaIPeyGJ5p9
 y9rLV6k+aGy28Ke8mjQ9g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8i6+Wn1gR/0=:I1mENXJuiVPFqYBrETs/Mq
 81G8JhG1T0GzJmbx+VF/4miHfL7eVSC5a9lnzBvyFJcyzxDFZE50RUKTXC3Iid0rGnVZsgocq
 M85MEfrf9VpTUqvD+Xnk+QI1ZjBDkzscPP+i/3gpzUwJ18qQEDw4eEKM5KQJ9hRXaJdg2NBxk
 W2R8BHxVn5Fd3Jx955PnxNNoKOL90KI4gTfBMfy5UGczeUgtTANGZLKdZD4UIUbSj0NhnCFet
 pt5/YV0Lt9G9o9QzFpmVNg7iRN7K4SNv0egqKNHplXZyqOTG6rgyquQwKmPWNCnWvaSEdXlNK
 Y6Gr54hNyTxCC/GXOqK5Xpr051/j4hT/jzK4BQFGKG3RhvHr0yLT5AyPBwebRRofO/s8pwNOd
 7SYUFAff2jOn4zNdXMkd2sqelTikFr/ax+qCI/N4amMB4db2jo4eEmVV6np1cbqHbWe5rTteo
 X4duCW/ocx5/BWS9ePhkWvhiIEYoF12l4VZ1woei6X9My7bZHIcCEF5fENWd0ZB3kp7Ld994C
 noHiR0Yo2pHUzvhDwAOWZvLZ9NLM8eF38U+NFX4tVdpxo4HW87dKMeh0tVAe5K01OPieLErgA
 yIqxA1r/f/kkL7ObbeG57p9cfktG9ByhyEvfouktOUpuh+6j/Y+BqLg2RdwaGUdgixpISW4fh
 fwRtzgipkFJW1iSHtphNiFSzMAPG28CJKXEEdGmhpT0KNRtY/PNIEm9MwELORShr7fSfypsWl
 G210kDpdh/AYewDUkp3kHdHRPKbAyuMtMFgZawT/qZpkSvcu7ULPJb8CVt8NEiVyhX3oU9wfq
 2IhV56xl6CsHJGeCtFAnFs/563yDC9OPQ4AOk60ltFUyOskldBzr6EsHFQ4WwQU8Q0lm9v8ux
 7N58MifQwP0SeUGRj8PAWKuUHZ5ruLpqrKUDDGVJ27Pfxz4rdrzh75vYDYLdejoJHa2O4fx2o
 U9D+PQ5XjuEB0/LSGXQvFB9W69FViszJhloDemRkhxORr9O2CAyVPj6dY2RvwJB2mW5wbPf6w
 fhe67IBxCtYuz/rgnGqnStkkdbe6aSOpGURd906GXbmmJEfqH4pPGmBSUmZHzyKMuKDyMZ9eY
 klXJS62YBVQK4Mli0IzXfiH+tZ+A1WI8Ewlf+A8AAtOQpKkrKer4v+5QeHR7OXvZpyKImMOMY
 vGEkofNqkadDyjgaa6CGHe5xQ+TWRCYztIXysp1ttroESXbQmHIKxeQTtihfZGZPk/F6a4idn
 +NkhnL5ZNnY1MYSOD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> By the way, is there anything else that I need to improve for this patch?

I became curious if you would like to adjust further details from
the change description.
Other contributors might care less for presented concerns.

Regards,
Markus
