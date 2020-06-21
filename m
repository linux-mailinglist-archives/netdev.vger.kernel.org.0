Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62DF2029A5
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbgFUIbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:31:04 -0400
Received: from mout.web.de ([212.227.15.14]:46125 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729502AbgFUIbE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 04:31:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592728250;
        bh=rDGjwyqHZyhYOb09NrVAgaK31ewGxu238GgwO7rRebk=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=r6rF+DLR0zxY+Dw1nvKwZw7Nw0fdXaTHrW2vglwn79nBjPbHdLMObEFgH23XdRCH7
         Ta21eYF04nTZQEIpOV6XMf+uM0Fq1MRL23xAkDbK6tA2LmbEqdjjU0k0s+D/+ntRL3
         BcAqdKzxP+5QgylDsrOw2oOa59aUnpQ2Q3yrT4dU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.145.213]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MJCEk-1jkADY0Q6k-002kyS; Sun, 21
 Jun 2020 10:30:50 +0200
To:     Dejin Zheng <zhengdejin5@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Groeneveld <kgroeneveld@gmail.com>
Subject: Re: [PATCH v3] net: phy: smsc: fix printing too many logs
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <c4750876-f145-8a1e-42f2-553975e79561@web.de>
Date:   Sun, 21 Jun 2020 10:30:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:Nvw2DSUSZZqPrd4sfbe6BgrWwdNvESiVt1SjHl9vn9vPWNeaRGv
 lF6sPI9OsC7vBwv9lgSfQp8a4xm+A4inv7kkZxqwAYo16CktI1y6YHU6hNvTzp/Ox94vz5s
 RirpqT2WA+1+o6OhWeVSFh6Us86H6BPSv2UMOdR3kmNjBLHBJDcs+LAjyQH6Qh3N2XcUgHz
 z7XcUbbI7ctaxQucdIY/Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+kYNHce93mw=:LOMvYQ7igPsmAQs/3alVCj
 lwnH4w8Q2VWWUzK/ljcrAzIi0cfEsh/C7d/LvEoMDhz9WFCN7En2iAdgkTt+qKcl7FX/sEskV
 jiVFi/vLSy2lZSPFt3t9Yq6VhB7pGvPzhGMST6S2VNxODNz6G7uOiKAFBRUMUafAfYFKKBGgj
 fVLd5H4r4DJwP5t8F9Jfxjb+iubD59rFj68W1F7qjfIbsG8EUiBVhwV3gBw2siPC0VD80LaXr
 dGoeJOPey/ttFo7zg7eIsvi41CFNIUlu6cR7osx4WRgq3rO1MyTaIIVXwDtkL1Vgx+8HHf5Pb
 eLWOmEF2X1Y674NtfP5vb/KgGeW8Zg1ibloUk9DapVYAumcstaWhabMQLf2TWnyjWLWs4iBiB
 plXi6FiSeoD/ZlVRTtkQ9Eh3pH2pdnzeQd+71jI8HGRs38bkKc+rYj4teJHRTOW4EcmOkPpf9
 A7TV2xrOn3D8zUDw53kiZR8SXN8bbzwBqT63Yuut8B4G3giZZFsNXIuOZpdc22rxRVTL4INbX
 qef1A70482R5gDmiqf5mccGClsOnFIfIYwUWsinzjtVUcMJmNhgIBoE8jmPH6vQBEENaK/Hi9
 0EJd4kfuN0DnwNxTpH+wGlHMZHUjaRA0xZ8xJVJjO348m5YwAr8GhSwFZAYtHk0iv7Tm0sHp/
 isSRxiKo8aqJ7ZEJcurEAR5SD8F4K15f+jFniRP1Ivj3ACeBv6LcD2X5difY9qO/lzgg0kb3F
 dYpprXAK6RnG+w8PKXUtuibobLu3WgixGCUZwyzhCHyBejBdMn7d7Mbu+yZvMoDMyaL6tq3NF
 uf3KXnI0/6XG1jnMuKS1PeqjV9YFB3bVJUJYWlZNnXTQp+S2SRfKRH4ekndmHeDgVJqUjWGJi
 1V4aSkdLLCwAbz2/cBkZhy7/4qNn1ocb9D5Z9RGpkZl9YZEo0RrUluGrkj8SqLxtdxoAlOgkk
 6JThX+ZmF4DSgLvL1/ECJ49DywbfGRdZLKOZH94n2SmMi6DVKt9l0kNej+vKmvKybD7srVfDk
 QTuLpBMp6ubyGqNsA8XZGRsyfMkP4vIu0q6j4E2K4e/1sL0GM7vFVgoG0N7yj1telOGoF07Yg
 8RFofgU2IpBDOegmGwJHcBoLfdEgmktc8ezunefTeFwbxezC5QF5WjiIzunf77FmpOF4mphOG
 j02SfXgGEaXMPrEbTmxlbtPhiT7rikJ0ZGpcH8fizQTz5HZu7k5IeV9AiHRjFaYUwkDsL8ZQ6
 Z5xB2wGXqDBe/DsGq
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> out and this commit was modified to prints an error message. it is an
> inappropriate conversion by used phy_read_poll_timeout() to introduce
> this bug. so fix this issue by use read_poll_timeout() to replace
> phy_read_poll_timeout().

Will another wording variant be nicer (with less typos) for
this change description?

Regards,
Markus
