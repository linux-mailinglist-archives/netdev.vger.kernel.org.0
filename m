Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35481C3DF3
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 17:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgEDPBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 11:01:13 -0400
Received: from mout.web.de ([217.72.192.78]:45637 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728165AbgEDPBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 11:01:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588604443;
        bh=t0Fhy+TbkKQdUlUiQQWRSsl/lwJ1Qmb1XkVpr9bmbOk=;
        h=X-UI-Sender-Class:Subject:To:References:From:Cc:Date:In-Reply-To;
        b=URgCbDrsCfZ8VQtUhqfIH3SEOvXjb5SnYkF/tnmmjXEtKTt2MwFCDDRGtjmdQYDpF
         uGDoGseD/fQvHZSQjqzSJIUIh5F//AoT9VqzvUpCp5BjdiK1qbDNm1dc6r4DNQltRC
         cYwEnfPqqDY2gX3HK8fi55uuJed6PWY63x4/KWcw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.152.69]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MQvkQ-1jiI3Z0M4U-00UMxJ; Mon, 04
 May 2020 17:00:43 +0200
Subject: Re: [PATCH] net: rtw88: fix an issue about leak system resources
To:     Dejin Zheng <zhengdejin5@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <79591cab-fe3e-0597-3126-c251d41d492b@web.de>
 <20200504144206.GA5409@nuc8i5>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>
Message-ID: <882eacd1-1cbf-6aef-06c5-3ed6d402c0f5@web.de>
Date:   Mon, 4 May 2020 17:00:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504144206.GA5409@nuc8i5>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:a0BUZE4f+oVWjdLKKU/Q1IptQqypiXinFpRhF8BapHAJeM85yPv
 MIhMHpkKKaTlkQ47VA0itg/JZ5OCzf+70/zEbaTmcMz9VOBEn6ar6nsknusXNAPTbFHm2AF
 jgXt6JKRebNL9iAL351vsS9t/8du2Y9xop1uHQQKnqQZ306XPnErT3b215U/T9ygrx+1dWA
 8YM+dGeEBmDDQbUJeGCIA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NdE/1pgD8Xs=:LnxbXX0Xus26yfL2TBaM+W
 doYUryQNy7UJV3boA4xcbtMZBOMzMCgW7U8Pmg0AlTjwDRZEwWY0UFiforifcSba9ezSo83Df
 yc2aAGH39WbP8Zh59F5ZDZf01t38GcQKgGynkEA+vcymifyO/+30BqD1uK+7O5Zi8Zbhc5Y+D
 Kz3TWkPRT0MjKPBMGak/StClVux1OK0ZF30gTs0lVC/hz++s8O9Muv6YT/6JjnYZhevUDPop/
 7peFLwLJkRchtjWTIT7gl4iFyR/Xmzw0MN/Wm2mSdz+bRBNz2rvHRqROwutHz2yJcmcjmnBY4
 KefByhKVk2cKrEWDjJibCccD8wNwhc6eBZhdxPkhDCpAgtNBTmcs4i3Ld6+pTBxuZgrH0VxJu
 Psh+Egy/kzHHrkSLQjP7ieN+8sBgt08i3zmT+KNQozq7QQuyTR6uq1wgkjAV92G/4qPE1LVbX
 8HMFPA+kXQzWrJQbJr2pbf3He8lx7NVqgR5TA4qGEKKNeacVgCO9NKbR0PCkMCFhbl6ltKzpV
 FxAauqJFg6izLUvvx12a5ifoaXokvso3cPHqxAa3EIlcVc3X2D5lcqsRfrYGCk3Iiv0Y1TLNY
 5z0WerhpuP3wISjvj88S3Opq5aGbTc739oAf7rJjiY/AEccfBfeSX++nd2Sp8ECH+UOWgknBz
 ZOXwxF5UpOl4Ut4QHSedYfHh7vGp3ZTpQCNNbiTLLKJ47O/RHrpwe72QZ83w9vgE5oofNlI4L
 Pqgwxh7VRbuWtfRCBQTFBS1LpDQKomJeJBetEMy8VInpzOSwpNvqwHXfAk+zb6SkOuRTJB9LP
 4VpkMwh9nXWq/563232YmYCFF6kSwPDnBDV6+b7X2lylll7f11GAloc5wsn32okkU+ZddRGrU
 O5lZzqFdPRPF+ILQta2kRbt/KL1KBJVwqc90XNiXFMvuhEtAl3jxMTCW3dhA5xjqRjI/JXw0Z
 jjuYKOH+kIvYzFIUGaD9zwGox8LxIP2y9fXSnIchZV8vrogMQdI6RsElg6n8mf/feuZCrOgUo
 hsqz38Snb7mR8BsZfOkUcRGKulm3TVu4+HRj/ueZQk3EgakwpmA9Z8NCSV54dV6KcK9J3uU3H
 vkGRSjKkUQI/0lQL9OCya+1CvwfcBypg8oDrWPN73r9mUJ4s9gkqWFJ8akhAJao5TO/xD4qYu
 Ssm3jqtLOU5hsAdSeOWHv2DcS3kfCrFzv7YcShkTS0olhSJvHerLIHqudWWgMX0V75BilBwyw
 SHvSglWdIq/DEanKv
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> the related system resources were not released when pci_iomap() return
>>> error in the rtw_pci_io_mapping() function. add pci_release_regions() =
to
>>> fix it.
>>
>> How do you think about a wording variant like the following?
>>
>>    Subject:
>>    [PATCH v2] net: rtw88: Complete exception handling in rtw_pci_io_map=
ping()
>>
>>    Change description:
>>    A call of the function =E2=80=9Cpci_request_regions=E2=80=9D can fai=
l here.
>>    The corresponding system resources were not released then.
>>    Thus add a call of the function =E2=80=9Cpci_release_regions=E2=80=
=9D.
>>
>>
> Markus, I think my commit comments is a sufficiently clear description
> for this patch.

I got an other impression for specific aspects.


> Someone has told me not to send commit comments again and again
> when it is enough clear.

My patch review tries should give you hints where I noticed wording weakne=
sses.
The corresponding change tolerance can vary by involved contributors.


> Because it only wastes the precious time of the maintainer
> and very very little help for patch improvement.

I hope that also your commit messages will improve.


> BTW, In the past week, you asked me to change the commit comments in my
> 6 patches like this one. Let me return to the essence of patch, point
> out the code problems and better solutions will be more popular.

I would appreciate if various update suggestions would become nicer someho=
w.

Regards,
Markus
