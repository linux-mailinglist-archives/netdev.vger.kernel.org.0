Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D1FF6B78
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 21:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfKJU7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 15:59:40 -0500
Received: from mout.gmx.net ([212.227.17.21]:32935 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726800AbfKJU7k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 15:59:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573419478;
        bh=uqfXg4G5FeBdW/I4b1p35uBMbYLm6L+MUVhJfx47T4I=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=PMIAQcCil92gzsIukTse9p8H06CHv1E4PXVvRcYLeaYtLTjmYmF0HyJEhw95Thyxi
         FWD6YSg+J7bkziyIpCOamWMDKcl/cYcIjBQg4B8dQOrWM8ku8LIp46D12d/V9WUCE7
         oCiOriZYCUd/968F4tyyyk0ONv8ZcTRpxBDVfd7Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.167] ([37.4.249.112]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M8ygY-1iZwga0bpe-006A91; Sun, 10
 Nov 2019 21:57:58 +0100
Subject: Re: [PATCH V3 net-next 1/7] net: bcmgenet: Avoid touching
 non-existent interrupt
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org
References: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
 <1573326009-2275-2-git-send-email-wahrenst@gmx.net>
 <fa75d3ae-147b-8537-9cc5-522a7dc5a5d2@gmail.com>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <3aaf1b3d-7425-5073-f5cf-5ae672f4b008@gmx.net>
Date:   Sun, 10 Nov 2019 21:57:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <fa75d3ae-147b-8537-9cc5-522a7dc5a5d2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:Hb7sSQGgJHcHDVUW40jJAJD/4sSf+ZYDEfZYP2AY71xiQeQhnAI
 DkzBnZvjDMZIBYj+JpH/ur74EoAw4iDmZS0g3vZ7SbtWOj3I4AIRcJWejEifgQfVjaBvWLb
 xS9nBC10Xfs4lgny6PT3MQI8F6NmXm2AEhjhLn9Xr7nvBzkzjpDSh901ZsrVHWNzNJpDuPM
 C3lG1EgZwyu+XlLlIBdzw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6yuPH3k9vWQ=:77E2eLTk4emjthghQzwkfz
 lZ+zxU2ucPD8z7+JIKuyHmwWm4Kmm5cTiQaAVfNKKYQKcNEQZLOXzF+JkFkBiN0XBUEOOn9Da
 /tgOWxym2Et6fv+IxbDIIz7VvMO17SWzqV0EvgMMLm6RjPZZhziQ56TKz/QTo6MAgm6S1Si3g
 NffEoQr3P1HZIHTnVKZbBbghLaYWCMSyHpjDzU0m2+AYWOpkwMMBuWlPazAA3o1x+T/DxBSjE
 rFFGubwXwj8BKwT+3vld37XgcQgxCyJTZ80I/MbQI5+Fj5JqhPltRonq/e8201E1AIfQgBqlL
 OnKuMKJOgHZcL3OmM2MPmI6O4ITwegNJaLblPcTtM1UjameJ/F5ibvH69OyZiPunw6gBRlAXt
 LKkzEeUNmrm+kAczwTvvxYqKkDeMDlThmDANVFmNCMfmkLgHbXyFrlVjU0tmjBBqZcPRUUm/H
 huJnbj1uA0KXPWpdr5E686clvcfIjrla4n69R6BQHoes1nPyTjFuGyHNSobmGRwU0QeHQPSMy
 mCWGJzoFRezFZgdGahUinsQLmwySmn6L5bIXE/73eWMJrMg7LFQzpQHYXncigY1D40fl8j4RP
 gAVfuYqadpONrBihtn8qEPDBQjSk2Q+ScQbxONPJsg5cAxS4KIkTSAZyBa+tF2ehzLIY8ZlGY
 gsAvzEZ/bQaSuHEDbUXTgy6RxsJp0QGFJ2TnAIlpLnbtqDDdK9VSGaqYe+MBACvVsOAcd3C7e
 yvvCyTekuLrDBYGhIXLGr3k7+YnAjZopnLKrWzpu0+Bxlj3eJluCpViTzss78RqeO/BKqPMl9
 QXLqBhWlQfmiJQjzLCPd164AAIdsmk2Gs0RQHRK7XG5lQ8vFfyW/XCK9Egq/jTP2P3qmZI1Li
 VMUyUw0utr683+9zgve2DRnuGQSXkStX0MkQr/PRuCXnCalxiTa7FZeYzCg8bza4Z8Ffe6r8s
 xTNTyQ+Xb+hHJ8XShVLdxwjkz0q8AP+iki2X7KgrjdHpXkC58ucxjWNGt5abAg7sU/9kHzjGX
 y6OgpRu7nuGlTfeiDWXqBtJH1sX+Sabn8dqdx7Lez26CX+T1JanoRVEeBUyZDl2lY84/ZdnMW
 Uufh0y2suOZVbvr+3EALc3VNtaUwU9X+Z0t8kaYzuMW/iJi9YFwYSKPMgmdyveVMy5JjXZS3t
 /H/dBu+nq5s4n9j/iyA1y0tnd8SvFPFSqLRNHD5n0YSnH5+gx6UmKzwKppLPyQZOUlPXVeii5
 8WFtYvG8uezjsUG8kyvpTM+Fy5ycJ5t4PDP+3PEyoNyIZm9FKKitMZ0PIhzI=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

Am 10.11.19 um 21:23 schrieb Florian Fainelli:
>
> On 11/9/2019 11:00 AM, Stefan Wahren wrote:
>> As platform_get_irq() now prints an error when the interrupt does not
>> exist, we are getting a confusing error message in case the optional
>> WOL IRQ is not defined:
>>
>>   bcmgenet fd58000.ethernet: IRQ index 2 not found
>>
>> Fix this by using the platform_get_irq_optional().
>>
>> Fixes: 7723f4c5ecdb8d83 ("driver core: platform: Add an error message to platform_get_irq*()")
>> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> I still don't think this warrant a Fixes tag, as this is not a bug
> per-se, just a minor annoyance:

this confuses me. In V2 you said this about patch "net: bcmgenet: Fix
error handling on IRQ retrieval".

Is it possible you commented the wrong patch last time?

