Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C3A1A0FEF
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 17:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgDGPM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 11:12:26 -0400
Received: from mout.web.de ([212.227.17.11]:47199 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728917AbgDGPMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Apr 2020 11:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586272328;
        bh=eaQCulwN4tutP4JcG6F/6ekV5+WwQnYfWRGpAq4Sno0=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=CKILv9GD6wHhKxO2u82a7484vjDQCxV7PPPJU7mo/RIolO1d4ON8nBZkXjxp3CKT+
         BH72yAxHmo0/st6dHxop9+0XKfXV0qubpIRsN7dIMP9kVO7xF2SjfF3z6T71pKQ/rz
         eJyn6o/rkae9TM4l9uvOadKtMj+3Gj1v7u4L43Eo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([78.49.5.104]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LvBV8-1jDYSI2ex8-010JHi; Tue, 07
 Apr 2020 17:12:08 +0200
To:     Niklas Schnelle <schnelle@linux.ibm.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [RFC] net/mlx5: Fix failing fw tracer allocation on s390
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <77241c76-4836-3080-7fa6-e65fc3af5106@web.de>
Date:   Tue, 7 Apr 2020 17:12:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BBB+879L09pHLCNOjgTFSNPxC88/hhITl+4GTbKJ54WW4aCUs99
 36AJ4I2H5kxq9e1Ut6UomV9mUVw+y2/VrejiiTRx2u0ZcTFyCGJu+c7y9gx0Yd7IQVYwN72
 gaj7wE9yD2hjNwoQLs6U6NAe5IhTpitlYsxFrgG9dnvP/THWxLgOSvAcfZg5yt3H3uo6zHu
 uFp+Y+eieGU6m5FR6zzXQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:igVlEAP7Nu8=:PzN90UhXhu/ZegAZCfL935
 OgoEyQT6YTcfqz0x+s7R3mtmjGHW/rI9ELiUZgKlZpGhpC00fqacnfhU1htDSe6l7UqTODOGX
 yr6N2SqoQKW6rKgr9PL89XyBFcMKPQcnUKUyclKVdiDWR/wK8xkqlG9KgGD8CwC71V1LDjh4F
 LtuyCAFvi+NNVJBcKX0aTjkcD8yzVUE5Waabpg/gGUrjp5oIIXMk4V6zy7N8TRGnH1CcZITJW
 F7FwjItKRB+tHwLmsOKWnFm1vhd+4moHkJBTdAD225Kx9TOvNknbdDS4kb7lV+LtCqkhcE8Q/
 /ezEOOnHpG+9TWWRVqO+7abgv3yMj0iETmquJZkldQ0v0vWVZBLh2eIWuepq7cihyxk0JZsLg
 SEj/SdbY2LovyjBOnfD1+gGNYGVg29aRuifCQsahHjRnPeyC+/Yjgff85njFJybulsuOpgQzf
 1S0rWWoBlawVF1DfYcuV43UStNCQZRBjtpmEh5E4wXWC3/pIU31Ac6IblgEpRlBxyf+nMxwBy
 ZIHenPnpROVZs5/zJyApuNSmE2aDJQpDIlyTK99rjTfice/W914CyyFBLa4nsf5JwAXbeXgkS
 nN9am/p9ua+Ng/85/0Qe2uSy82w9r6vpw3giCS93BFQ+09FQMlJfpHyEYck+CYRuTshxLrCoX
 jsCh18iqbIC6FSTzh5gmGmy6wPWTSutq4uliuSRoKOhgtJjR175knU2B3yiY8rkA66oq44wo7
 pUFengtxS52RR1VbtXXWbkMa8GYUNz7o+4VWTq5HVRdLeW0YWtrgYDVf0ld5mCtYJJbOlGblD
 vxyCWlMz7tIdBH/9tM8dgDn27zpNywwuIlLxVRiKdVy7azK7NnAe/wxYFE6K7eZVIt+bcuyib
 E0NAWl30dheV/UnRXnPtcKJ1jvZNDe1+Bz7Q3VP2W+d2KEnSBO3ipG9yvPuZjy+4upRYZ311F
 xBex0n6I9nLfuU42qdN94c9GnIeoEezyXGCeBOWgGnDew0okVYfH+U728LLN47/uo0IRE0uBm
 5arIfb9KpoLQ1T1U53pM+tmVKpPOcauy4S/kflJnn34GQZoWEydQeIAlPmmJP9IVf3HkjT1+a
 Wb9fDiErGSUkHjHt8mnXP8IdUVJHbF+utNb/Kzy1s1OJDuYSYc6x2CJS+T8ZcLMI6kQqzwZso
 NqwWLhN4/PM9z4pnVIZsFPR8Mr0fei7Pz0NNNTVSs2JRKVRPzw+BizemI+7mnXwZ1xkUTyFqE
 3KUEtGuQ8IwwBFucC
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On s390 FORCE_MAX_ZONEORDER is 9 instead of 11, thus a larger kzalloc()
> allocation as done for the firmware tracer will always fail.

How do you think about to add the tag =E2=80=9CFixes=E2=80=9D to the final=
 change description?

Regards,
Markus
