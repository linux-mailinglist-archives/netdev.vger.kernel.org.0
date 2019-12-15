Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA0E11F82F
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 15:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfLOO2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 09:28:03 -0500
Received: from mout.web.de ([212.227.15.3]:55877 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbfLOO2C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 09:28:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576420062;
        bh=UJCtRNXt9dxsHq0AklEZDJ8nbHLtOvdKysh30YDXffU=;
        h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
        b=GZoHx02DOy+puPGrxWYPLQ0MIHM0RlwA2FUi+b9lYvrq15e3bt4JHJo8r6cQSINkX
         A/Lg1BOhWDP9dWRN/+reId+WZNfrg+YGPzxC6tLLCQo7iJVh6+LQtLonLT2BL4Zgo7
         wMKQw8GNZbyl5zzL9+peiyu5GZzjDcK/y1yTrClc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([2.243.76.50]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MKrC4-1igUs20xGq-0000Hw; Sun, 15
 Dec 2019 15:27:42 +0100
To:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Navid Emamdoost <emamd001@umn.edu>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>
References: <20191215011045.15453-1-navid.emamdoost@gmail.com>
Subject: Re: [PATCH] net: gemini: Fix memory leak in gmac_setup_txqs
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <403e8b6d-57df-e8d1-316c-150f833de842@web.de>
Date:   Sun, 15 Dec 2019 15:27:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191215011045.15453-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tkC7z+MpYl7P5EwBkPAiILzQEkDpkdrVtcbxSxLgvaTAGE/BMwJ
 u9MDzlGB3/OK5EzyQ8EVAcaLqbIvarTxeYyeUikZGQFBmVb12OcjNZQlpiLQ9fl8JhYMAjb
 0eQU3NihJQ25OHdwidyC9GWL/Ae66CcAiwbhwsmuE6AMb7vIhqsy9YFnwzXYX4hMA/teu41
 HkokghXClEXpuTbBMl+IA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+3hLjCV0XD0=:R+iqzKOEt5TFhA0wdOtaLg
 Hs7dw96BKPfS6/yMLdL7zkyFm6kqvDNpzvyfNzZJhUtPWKZWkKuGlKIgfsKPsz501F1x7Mffd
 kXgvUWd5vtSPIF4FVtHZeJo6SKSY7lWdEszOvpi+1Q3hZdXxDXEVpuZSE8TsXt/ZKSVkGcauS
 8qE+F3yraFT0YijSt8xGUh7lktnhK1pC7/nekiuflJSZgLh4ZmYpxVeNCJ8f1jrdqX+ftjfF/
 5e3lI7NYILKCv5WY3ailQcM83Mxqvz9m3IVDy5T25Br7aOqtPOHJAwulOAtflk86Prd9c+fwh
 v7yWbHvWEA4EnL/2W5BVzdoPuok6756bJpvj6hDD8MjY4U99LZ7RFJ5hJHqWLu89s2uodhQ91
 GFyqtt6KakwceVfmfafN/QMmZWuOaD+o1WXhEapNWHDNf5buBWgO0DPw8vjKuU3ykHqKHqd1J
 yRgzYdFZxTbSelT4NmrzkS/opT4TzMiD0+ji3j2BwsAzQOAdymA7jPCcrOUQBqgXAxDKeRV2H
 QtR6XPne5C/D2xVj66h9zROScnILMn4O4KDjGIirUgWo4wHdKMlXsHXf9K7XygMpsb8T13CsO
 xaPMrC8K81eVdRIW5gWweaKzqqNgChkJ88vZSaNY0qyX2OG2kgzzLh9lUZQi/KUb66SnAH2KP
 9LfgD2tVP3YRwLYo5+xsettkONcfNCQqU1u6bKAWu4hjZ9UFBj+OItgMVc75mnRUpB0tomwbH
 6JVUVKPVqjjLC2335FicySAvrOYtZjTYuHyiNWNv2RDjO3X4rI8NhlFF3fguGrjxc9xrxRFDr
 j5IFJGHNzGLxWJQOS5EQMJM/9EvzEOjEhtOV4fLzDNGT0P1QX/P4PmOYajfLFJBNvVTrSutGS
 nYDzMiQR1eH958RSON8p9hr879PnQxoTbWF+cOT+me7W/weMF5l67P0h/sbnnnESqaWqumF+O
 B/BwljohSbtg9vbK0MR/RWjtxa6fk78bE+n/AWzO0mqwJhszV6V9e61VWzyTrLwJmz9V1iStC
 6bmJS1pyao8uU30lAOEycfQBWiBk2mE1MhhSKDI62MJhjC3BsJNKObaYn3DyHphVXkPzh/RGL
 vwkycaBEL6pyiv75LsOS1TwQRlRYztMSouigOhtOYCqjLwrKoxxl+9iBOh+VZjkiRSHRvjuKf
 XN57qX48I60EN3XrGNh0w+RPvTDCZGfVq/pLx73s9HUlS27yqajyKlvH6TcMLyyLZf0PVacRA
 vrb+rIJcNmwGklqqHWEo02f99+S6uLEkSdqstAQ8var1G6ADKj87Nb9iMQnw=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +++ b/drivers/net/ethernet/cortina/gemini.c
> @@ -576,6 +576,8 @@ static int gmac_setup_txqs(struct net_device *netdev=
)
>
>  	if (port->txq_dma_base & ~DMA_Q_BASE_MASK) {
>  		dev_warn(geth->dev, "TX queue base is not aligned\n");
> +		dma_free_coherent(geth->dev, len * sizeof(*desc_ring),
> +				  desc_ring, port->txq_dma_base);
>  		kfree(skb_tab);
>  		return -ENOMEM;
>  	}

The added function call seems to be fine.
Would you like to avoid a bit of duplicate code for the exception handling=
?

Regards,
Markus
