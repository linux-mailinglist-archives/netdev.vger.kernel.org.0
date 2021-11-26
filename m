Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB5D45E41D
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 02:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238081AbhKZBor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 20:44:47 -0500
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:20894 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243805AbhKZBmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 20:42:46 -0500
Received: from spf.mail.chinamobile.com (unknown[172.16.121.15]) by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee961a03ac8629-155a2; Fri, 26 Nov 2021 09:39:21 +0800 (CST)
X-RM-TRANSID: 2ee961a03ac8629-155a2
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [192.168.26.114] (unknown[10.42.68.12])
        by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee861a03ab89f8-17210;
        Fri, 26 Nov 2021 09:39:21 +0800 (CST)
X-RM-TRANSID: 2ee861a03ab89f8-17210
Subject: Re: [PATCH] ptp: ixp46x: Fix error handling in ptp_ixp_probe()
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        wanjiabing@vivo.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211126011039.32-1-tangbin@cmss.chinamobile.com>
 <CACRpkdayKYeizBt=dspQ2VdsQvpc8iq7XeaT7SnRiCyMVO2Bsw@mail.gmail.com>
From:   tangbin <tangbin@cmss.chinamobile.com>
Message-ID: <53308403-a6b1-3af4-27ff-9e772e378bd2@cmss.chinamobile.com>
Date:   Fri, 26 Nov 2021 09:39:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CACRpkdayKYeizBt=dspQ2VdsQvpc8iq7XeaT7SnRiCyMVO2Bsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 2021/11/26 9:26, Linus Walleij wrote:
> On Fri, Nov 26, 2021 at 2:10 AM Tang Bin <tangbin@cmss.chinamobile.com> wrote:
>
>> In the function ptp_ixp_probe(), when get irq failed
>> after executing platform_get_irq(), the negative value
>> returned will not be detected here. So fix error handling
>> in this place.
>>
>> Fixes: 9055a2f591629 ("ixp4xx_eth: make ptp support a platform driver")
>> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> OK the intention is right but:
>
>> -           !ixp_clock.master_irq || !ixp_clock.slave_irq)
>> +           (ixp_clock.master_irq < 0) || (ixp_clock.slave_irq < 0))
> Keep disallowing 0. Because that is not a valid IRQ.
>
> ... <= 0 ...

Please look at the function platform_get_irq() in the file 
drivers/base/platform.c,

the example is :

     * int irq = platform_get_irq(pdev, 0);

     * if (irq < 0)

     *        return irq;

Thanks

Tang Bin



