Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482E1405B10
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 18:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237784AbhIIQnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 12:43:05 -0400
Received: from mout.gmx.net ([212.227.17.22]:35371 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhIIQnE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 12:43:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631205701;
        bh=h/v38rNzaDLQNDF7y73gnxHUtL/pa2yJs0+Gdx5wD0w=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ctlwwM1wjCuaOSIsmUhYRT6ulGgHwH+8zPlmAf/ZwDbnMqr646e8XHi8X1Od+XZz+
         Hs3gClzVUIZ3nfPT2KH/2f8SF11cs/byG0t+k6rAKC8ziu0+kZ5tXYJwPOdAVx4DQE
         pHCQ0beDdyofLItl2GY89vdhiQRFjvsEqPgUUsro=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([46.223.119.124]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MWzjt-1mQr1Q2LPd-00XKFe; Thu, 09
 Sep 2021 18:41:41 +0200
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <781fe00f-046f-28e2-0e23-ea34c1432fd5@gmx.de> <YToleWF8XjHjgh1S@lunn.ch>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <e3e50f74-ea20-3d7e-fc5b-1ac0b3d110fd@gmx.de>
Date:   Thu, 9 Sep 2021 18:41:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YToleWF8XjHjgh1S@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0LWLBevOY8PJ7cwKe9Kz5Pop82TimLzku0Fjeato935rbAiOJ5o
 kAf5dYWGsxuvo0nLs5XGIAiINoQeXU7yxO6KeGDotXxzWaJA9UZsvcFfQYfixzf0EtZXcFR
 WWUAMJmBp928y8doZIv6wDQZB716koeCOx9YFS50FPGkm58gw4hIajktgE6G9ckukpcYsYC
 t7YQIdzgilbZdIZRiO6Sw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sBBRrTFNvJk=:Vi1ljG6dNfFNjRZA2ZivgT
 Hsdurgee+Gsqse5p3uKE8o80opZPkt/HcDTxJaptAoNO63xnrl+SGwwULc0b7x8meeATWHtm+
 G5Z2GXclnoYsKVOsOXqFThCmz+vSTJLQS9MphcRfKjrFMbOy62/I2Znm3lrqPXbUw5DktABFM
 iytVo6UW6u2FakVoReOathjLUuA/PFzzFzWZaDE6LU0nUZJjSVuzkhWzAUievf0Ah2UxoEBen
 NHQqQ42k73zF0/kn/C31BtJC6t+OTYko5bapCNsSmw1W66I6kXOuvPPyQQWN0nbS0wGRyc7/m
 4i9t9OH9iHidtE+BWHaqTSDUqTIscsxTedJawKphFRw7H6Tj3tv1ENZdS5kDINj1RnTD0d3ec
 lfUfUtBj2d4atR05TwqfKrdOQ8zU3t3p3DLg/Oj1YC+ac/TW5vCqa7avpPr3VQR3NoqpxBhqo
 Dm3xuLaCADXRGq+2HSNa5YkCwJPSWkx/opkQ9LSPJ4QlomTfvQgCSZcK0t69+PzTmIhBej9FQ
 QrrIthwoL9koSWrUnVHKSgeXvPEmpJzHjt2128E5wiWtlk4lKGlV0RNqIt3mJKb81mjlnFXb/
 N/9PVd0jHdQi2LJQ1gcGr06EzT//cpYWk3xCyNJA4N1XlGjsCmwVoShbrr/QnGIH9KZCp2DDg
 9rWHePH396xaEcvJrTv6DeJrIGu4QzbIAbk847qeCkZ/2HTgW0q4qR6MFifsP+UHdDWXGT4h4
 4qlgRuhtJYw98P2AxpCsD0ETAgJMvcv1ZOr6n+cU+JenDTl8WYu5q5IipTBmhN5jtc9cwMVLz
 F4fM/vwcO0HT/OXZjpaLFYL0bHH/bkWcnEA94fkKNWxB0gm9JguuolYClq/1sC8vriBhK0fZE
 go+7ZnuF74L+VNRYqJaU+hTvsc2OTBJtGyG0gWY0rcb/1Wx+GLdajpbF1R1RnG5XkTYyPQdOQ
 v7rY5CV2obylMPP7m6E/bTJakM6lu2JPiQ3SUud/W6grpRK29HYFRytAbO2BnOpSULpc68UVx
 QOp/ItFpXUJqLS7hJJEWm4z4oHHq1sNVOSX7Ka5bZAkpXjwm2zVo2yl2ROC6IWfOlX8y/6b62
 0zx0Sofy685x/k=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.09.21 at 17:17, Andrew Lunn wrote:
>> This is not correct. The kernel I use right now is based on Gregs stabl=
e linux-5.10.y.
>> The commit number is correct here. Sorry for the confusion.
>
> Can you use 5.14.2?
>
> When we understand the problem, the fixes will need to be for
> net-next, which will be based on 5.15-rcX. They will then be
> backported to 5.10. So you need to do some testing on a newer
> kernel. Such testing will also help us figure out if it is a new
> problem, or a backporting problem.
>
> 	 Andrew
>


You are right, I will try to switch to a newer kernel to test future DSA i=
ssue like that
(I have the impression that DSA is an area in which a lot of progress is d=
one from
one kernel version to the next).

Regards,
Lino
