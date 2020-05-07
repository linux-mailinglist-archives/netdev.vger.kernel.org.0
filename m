Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3341C87E1
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 13:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgEGLRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 07:17:09 -0400
Received: from mout.web.de ([212.227.17.12]:33969 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgEGLQ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 07:16:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588850193;
        bh=RgQojsSQN7qeX5hGAabXFyVCcBqUNRynHG71Z+/bqhs=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=WjCaXWKrBgagXzXqbS1WNvIkeK2F2FQfhdJL0uNJiKnfGZVNgIIxAqE3rCCf9Zsqt
         ivSGjhNjTw87A36rW1ED+MuHquFZrvNpgOJH/8Tqe1F788iw4aDiko7uzbj/LeeDY2
         Ydm6spW7fROTw8RNNAyWDZYL6VCMs/WjSb42W5PY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.29.220]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MMXxF-1joS7K1Ejn-00JmIY; Thu, 07
 May 2020 13:16:33 +0200
Subject: Re: net: broadcom: fix a mistake about ioremap resource
To:     Jonathan Richardson <jonathan.richardson@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Dejin Zheng <zhengdejin5@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?Q?Petr_=c5=a0tetiar?= <ynezz@true.cz>,
        Ray Jui <ray.jui@broadcom.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Stephen Boyd <swboyd@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f3208af6-80ad-223f-3490-30561996afff@web.de>
 <CAHrpVsWbAdf+K1+mToj-5yoj-quFoXwF5D6_aAKufBE2tNSkFA@mail.gmail.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <c33b90a6-3f4d-d3fb-7f65-928247cd2ee7@web.de>
Date:   Thu, 7 May 2020 13:16:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAHrpVsWbAdf+K1+mToj-5yoj-quFoXwF5D6_aAKufBE2tNSkFA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kmRfBFiqEuFzAVnrJIZC2LnQFz1ZV9L1QBi2ysLNltZUXZIcVTz
 W/G/wS4iqktBe9d9T4KNddWZFtLe5lkH98kuXOQvX/cPirVKQTSleQJkrVc1u71Mx2HO68b
 p69lad+RBtjd9Yopr7FOIKnqVVNxec+DIWNNoOKhMF/o+ekYhXnQzNzUdrPpA2YaTrRalAy
 HYMQabapO+n3gLArAygeA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:KXbgF4dYB6A=:pu9J28JvsZdpYmOmJoDPR8
 K7dc7SiaI21SF8jo1Y9p96fJ65USVgw3/LN+3+1NPqYjRW1/5mAoosxayhjoSF0GcGVZg2sxw
 5wo8eg3jK+hYgY178mNdvvRNSiBzegXcaUNkHrlSNq8DVMzC7ZM6sx+MCJgM/R6e54bAFutUX
 kqymUJtrMSK5TjYBSVjFCEhZ7Q0rPRRBngakte8mcwZYimzXPTxHrwVbh2YPlNzihppw1KYts
 QRaFO8VgmaKZcglS3oA0qk43MWbaEcNmt8QVL43OHLtL51CnwgyS3Qhxlk1HG3tQN/z22IqDs
 g1ja/uaTqOMN7MQlkn9PfDCKkUeGNKUN20+YzH345qSzVn0/41Twy75IpjFiyJ35U7QEQG0eb
 hxDHTOD7oN3Y3AUFjdjjx7RSrilQ5BBq9wWOnH9OjkU6sfx/Px0W+LntkPc+IkLEEEs2d4eG+
 OHnbaeStYTDXdeqA2/F++faiAdhWqDfec7oXDkCNofpJhjjJNlbxaA2FJF5bOUXELZG7q/xDS
 IoglAuOBbBief3bJgorU0f99ky0r+s4VWjiyWNRW1BeSbNzrB61ro2r7t8ycji4HJKDZ3oVEP
 LEI2MnnXehtzt3F6XbyvVtI7yYqR0VA3SRntVqEZi7NT2zrmNBYC9P4SzC6uP0DvccOu0MM7H
 yfpBhqCFyncm70hjlyvx2730BthXk0lj6/VDZH+wih2Wx9L/XxS2V8y2bf3obYYycGlG8027I
 AMCkulhnDiVdbWEbEPuIBDl0bKg9JaAlHu0fgV9AoOe74gT22y5fXV1eAhtrHY1nYJ+JY0EHO
 7wQ/jg+PYbAP3CrN+ymOnk/spMObr0G95CvSKBPXGOxO9HJRTvMfO2AzCsVxtRYhCoH7v/iWQ
 NQOIKa0rKgTgNz5fws38GZV0CBeFu7qOiKTGqMB7gonZnSlvsgO6VlwW8xQjlk5i2XBcBDbSA
 HITvRqB6EqdC0E4H88A1KMQDKXRQKntrLHs5U7pAoQjy/wgZOMgAMC0k1GiH1Di1DGfwsP/vJ
 VpXKLpEYM3p179AIcQ2fcFsysEWorxzM6G9XjizJXD8HYCtzkhTjKArRYMVGcjlSeUggxVwy1
 iBjsjrQFue+0PqGlCiKlkVPoy04xVNB5C2pqXAc6SKCGVdjFSuqfI/+X60JHqywCb0R1Q9utn
 0CG8e6cy+eDu/LB8/3nPU3QQzb3fp+7j+QYpb2+XW7rsUTtBJbU90DCkZU+ftAAUwf37/mv0C
 1RIIZ9sRkKrgJxWhs
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> I hope that other contributors can convince you to improve also this
>> commit message considerably.
>> Would you like to fix the spelling besides other wording weaknesses?
>
> How about this wording:
>
> Commit d7a5502b0bb8b ("net: broadcom: convert to
> devm_platform_ioremap_resource_byname()")
> inadvertently made idm_base and nicpm_base mandatory. These are
> optional properties.
> probe will fail when they're not defined. The commit is partially
> reverted so that they are
> obtained by platform_get_resource_byname() as before. amac_base can
> still be obtained
> by devm_platform_ioremap_resource_byname().

Is it interesting anyhow that another attempt for such an improvement
did not get the possibly desired software development attention?
https://lore.kernel.org/lkml/20200505.111206.118627398774406136.davem@dave=
mloft.net/
https://lore.kernel.org/patchwork/comment/1430759/
https://lkml.org/lkml/2020/5/5/1114

Regards,
Markus
