Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D5E1E699F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391468AbgE1Smv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 14:42:51 -0400
Received: from mout.web.de ([212.227.15.4]:48951 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387957AbgE1Smt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 14:42:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590691348;
        bh=Dr1CBHpOrxp9SApbNucgC7CtWN+YIJh7k98R9//crL8=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=UmLRuMXl/UVkcegw6c+XKzm7ruTt2CiFLGqDLDRTtLDI03zCV/id/zm5iZ72Sq6HV
         qkEMuE9Cj02l4g2MA4yu89HUciBJCz3BtoZJNfJb2HgQHrIlko53/pQ0yv7KHJuiXN
         j2iKfN5WeD9RpTZatt/fSTaqK0agl2JxX3rs9P5k=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([2.244.30.242]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LyDqv-1itbxW3adB-015ZaI; Thu, 28
 May 2020 20:42:27 +0200
To:     Huazhong Tan <tanhuazhong@huawei.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH 02/12] net: hns3: Destroy a mutex after initialisation
 failure in hclge_init_ad_dev()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <913bb77c-6190-9ce7-a46d-906998866073@web.de>
Date:   Thu, 28 May 2020 20:42:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MC2UOQX5quZ0ULRGHkD3BQqj7OPFeRxXfjYllgb02PBDBasp3tf
 VbfYkNJkZi/iSElIDNL9B79PqlrdJCPruGgux7ljGWy/NySslXOvyrTe7wnnE9zu4QeXCrv
 Lg7Uh5IH5MNEOsRTHS5PDjNEldlEEHcOwwHzLF2ZH1cp8BTPe1kb7QWx8QfFpj7AzksYFl1
 NfO3Vrwiy1bWWN1l2KEKw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UIp4rW8w4Vo=:Iz71a/Guef6gMAmnUWIGwc
 8vHl5C3MtqqlbVCcSuZ04GxuUfK1Uc1OrqP8R8tpGZeFHj7gn/h1UNeT8tWeREbRJvsdRa6wz
 9rrN45Fuu+E8gzDpaPO31e9bhg3rxuPuooiLjbsKgZEKahn2NwF7xSeOBjlHnQpU/Zen9MfBL
 eVyy+ZstWQlvOIeN41jvqjjGbp8v6xuPDqQUkzY4oRMlsS5By01vs5pl9jUSm9xQsk8z23q3m
 ZdzRFudOzm0Iqew1MjrY3AqjQ5v6eOH3BsdmMC+af3UN+BCwoCx2Ne44Hwkm2Vxx23v99f/IC
 jWevpVeIQBTe0jveRbNSpGya05YUxEbTY9DgEd3dd5e0ZSaB+HnQfdhAHu2HaGIEn4SS5znmJ
 zINMlIj2+0QRHyK4LL66QpaDouAPLk/6cwgN23+gO4n0UkhiAe0sTYMkALNh4B96Wjq22M3Mp
 hF7Rgu5aJDzOdAC4trZ9tK2Y0QRpfVRYf+T+gyfMnMxoCpdT9xRNPnFwzBcfr6M4bT18y7pQW
 mrz/7qf1mWrXc82G8vKgPb+9oppTLGN5JQXzCN7v+gmz9hRcAX8r58V1zHasPNhTKvABD4SqD
 dpE51bbh3UmsjSXpmG3iiQqWwvCUNv6KbZWPHeZeLujnizRzdKMJadYaCASc6fehQ4g1RMSPi
 BPfoWeaBGnNqMn2F+eZZ5BNX809NuU9RCEannjCndk5QU/OWwhuB1TiHJTMUydi8WrY8HNJaS
 fvRb40eeZEd5M5RgUXYf3dP2VT1PzGMq5HA3Go6LBDTS3lGa4un2v4mJTbjhYf/sCwKJ9LM5l
 D4KkFyq+Y5S957gVh3MidDLAxDWUe7p7HjPYHsogqx/pQQeK+H26Zf4j6ZMQSlzmoXmB9DAek
 6BbsFG3tZJzWISMBlZQ7qch1hKmn46JdUoG7+QkAmYAq7dZEx9hbN0R4gj0bSQoWdhNwrvhXb
 TBRswmxvXp1JIz4RDJbPpOXVao6ApN1ngwU52pkT2sHHRmBPr93Ebt00yp8A5de1o7Cpqub3F
 DytBOWHnqx6xDmkAUSfELdDY94Y57aOA7iBX3SMYDSWVHwxyrYDbcQ9oxFkwqscmB+UO2Q3tQ
 GoC1tSamzIFsQLBL8O1/M3NnFwxOKIfA6yizSSP7x8FWHo1T/dG+M1bdhWes2OSR3nkPnieMT
 FDk8nIwMeP7CF5ZEOjQ8C8twPKopsdCmwWvna8Iamf3B625po2iqNKIJd15s+HDUotqA/G3xu
 7aOt2YIiZ7pSrpPdi
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Add a mutex destroy call in hclge_init_ae_dev() when fails.

How do you think about a wording variant like the following?

   Change description:
   The function =E2=80=9Cmutex_init=E2=80=9D was called before a call of
   the function =E2=80=9Chclge_pci_init=E2=80=9D.
   But the function =E2=80=9Cmutex_destroy=E2=80=9D was not called after i=
nitialisation
   steps failed.
   Thus add the missed function call for the completion of
   the exception handling.


Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the commit messag=
e?


=E2=80=A6
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> @@ -10108,6 +10108,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev=
 *ae_dev)
>  	pci_release_regions(pdev);
>  	pci_disable_device(pdev);
>  out:
> +	mutex_destroy(&hdev->vport_lock);
>  	return ret;
>  }

How do you think about to use the label =E2=80=9Cdestroy_mutex=E2=80=9D in=
stead?

Regards,
Markus
