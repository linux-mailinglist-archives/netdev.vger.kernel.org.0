Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E138D5BAA
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 08:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbfJNGvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 02:51:55 -0400
Received: from mout.web.de ([212.227.15.4]:51815 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbfJNGvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 02:51:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1571035876;
        bh=6hOOXHOM0ojoWSHKO/rWuKvDJ1A+If2nvjuSRA8J25w=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=PcK/aOPraE2lMzpiH87ZNDrcQbmiYMupkpj1GY1RgfvOc3nKPaJNKllfby5X6mMPq
         jirwHFP59oyJVViGP5zEjh4wGLIl7gM2TYsfw95sS3l5opqcC6ro1Un9AYDDlxcs0K
         AAVqHnVFU8Fn6kQyZb7T0gqm/VUnqwubjoPvMZSQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.26.106]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LgYdx-1hfdtW3AZh-00o2Di; Mon, 14
 Oct 2019 08:51:15 +0200
Subject: Re: tcp: Checking a kmemdup() call in tcp_time_wait()
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki Yoshifuji <yoshfuji@linux-ipv6.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Kangjie Lu <kjlu@umn.edu>, Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>
References: <a219235e-bad5-8a9d-0f3e-c05d5cb11df1@web.de>
 <124b41aa-7ba5-f00c-ab73-cb8e6a2ae75f@gmail.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <fc39488c-f874-5d85-3200-60001e6bda52@web.de>
Date:   Mon, 14 Oct 2019 08:51:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <124b41aa-7ba5-f00c-ab73-cb8e6a2ae75f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QkFOOfwrKM/azku7tmjFaYB8IZEn6MWWKlB+snMQnVUq1Dh0LWg
 iY5QroT524TjawmQREoV8lCinxCa/PCMQa2BY0Cofr7NdQJ42lfGtEHvATmJkAXb1Kdtel4
 AmPouZDDzXDPlTm/+5ogN1mppynqXohkHegzFFF1BvZEMawb6yKZHTRqjqXwo+4e31W4eNZ
 UF9TQKifXCRwvBsXem5MQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZyVvQoRYG1k=:SFPAYTdUtRFinXAaOp7x0c
 RG0+PLx67l+YOudLYuts8qEo0YrFNFhao9LQCAhxGBiPsQ5oPBJf2o2OszkAf0uG/LneYpMgQ
 xKesofv0LAzJ644Dr72nvrx2zxUXWR0TKatJA9fWAKhYPVtED3LxD1rjG0QAI1yB0g8iIyE/+
 Ek3dw+LOrDbQC9X5pc0pRl4hXGlo35OS7VVff1qsOSRNg9oP/EdVYuK74ctxOycx6FySJUyHX
 7DDy6euI3FILc7nHsfG0/Un+M1wb5dqD3DvcIZwqy39QPWFKa93QnxmNtXF1eeuu3jmTtk3cY
 8ykq90tX5EU+DR0CU8j7OPZtHuvSqlJ4z9kZv1th9+1vf8+gS+lznFEBDCYNfVB6S+a8aXC3T
 EhOAm0EVsuWWv8c0u/VNB/CEEZd1+65K7p16ubv7/dav2ZrwEap0MwOd4wvIN2BcYjjKCLp8N
 RA0YC1scpav0hAdCIn+pTo1+0l6l2SE5DbykUpGrKRfjEePk1RPB6dRs9NB034bFjWY769y/S
 Ty9CkA1kuH+8DBS53i6i7ti2s8cvsqNmquoCeOv07iHThyxh5XJDWQBRNX/Bq4n4JrNBe8vB5
 fsI02AiZDk41Od+mwt5x3TqA4StxuxVvdPqAPXkMXDNJzcj7hApk7zRu1DXcmWiM65arNmTv+
 fUBru4k5TL9cBAx3e0XPfUnmiAlEOsayl0jyRXq6bgwhRPyALASMsmOQPzg8hoUmU4t79iIkl
 imKaRLfqvMATbfYbRSisjNoc/IAUlz/+dKXZkX6xO1o9JzYlAxKI8TGB/oyDw1TRsnDVuh2BE
 CB7G8wyvycFn+1HFMSLuTQNVc5f1ukbPJtz7Wvt1cMqLFcRJp6ZJbTxi0jDoRHI9l+GDKVGH4
 vgf3Vrddi4t8C5V+3bbvJGyodyhVp0AYMRIMDrS6IkG0MTd11/TzsKCVxQzNxebnq9+aOedKN
 j5VwX7fwjFqQnCMsZOSLaoxMo+QG72gE9QwIe2t8uWJHDvpezsjRN9FNqynuUk+2Hpg5CNXHi
 ZoXwhyUYJbA9Ow3QVXlIEGiM2Ehpfph+0Hm2dXofl5qFHESfmqCng6J7Sb7V5nQBGmObxmtSc
 jfsc3fUMKeR7/xRqj+23XUtEcnakMBr3nwe5RiIYqMKGUKf8Vb3JB8kvkcAWNHCFaGnb3ynyh
 bJFCFqrXJsXAMsb0vMU7s8BL3vgpjN96oc2XKwp5lg5HN2Q7n8ZYP1/bRXWCVAGA711PqTY0w
 +puVle9+HPQsd+GGpMoThu7cOAOVj0XXcGbRToAe10demMDroEMpHaGjUhAs=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/net/ipv4/tcp_minisocks.c?id=3D1c0cc5f1ae5ee5a6913704c0d75a6e99604ee30a#n3=
06
>> https://elixir.bootlin.com/linux/v5.4-rc2/source/net/ipv4/tcp_minisocks=
.c#L306
=E2=80=A6
> Presumably the BUG would trigger if a really disturbing bug happened.

How =E2=80=9Cbuggy=E2=80=9D is this place if the function call =E2=80=9Ckm=
emdup=E2=80=9D failed?

Can an other error reporting approach be nicer here?

Regards,
Markus
