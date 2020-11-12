Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B522B027C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgKLKFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:05:37 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:45284 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgKLKFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 05:05:36 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0ACA5GcC118916;
        Thu, 12 Nov 2020 04:05:16 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605175516;
        bh=5mZL0qdohem3qi1lEyWOIBg12nManBREU6hV9hbnWsQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=oqzUHMsWgArLmS3nkD989pi4ORqwqz0Bwahk2/PFCk1/fcYauWXSgCuOSqgyv/Vt2
         vP5ZiYdIlndaZNqV+9WLwiLvw3pjPksdJiPwswFCHMUcUsI9fwTGoSUKF0/7aJ4R1X
         0viBU2OcfGbZtb+5R/LaSgDQGiW1yXXgCROGZQJo=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0ACA5Guh082266
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 04:05:16 -0600
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 12
 Nov 2020 04:05:16 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 12 Nov 2020 04:05:16 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0ACA5Eea013120;
        Thu, 12 Nov 2020 04:05:14 -0600
Subject: Re: [PATCH V4 net-bugfixs] net/ethernet: Update ret when ptp_clock is
 ERROR
To:     Arnd Bergmann <arnd@kernel.org>,
        =?UTF-8?B?546L5pOO?= <wangqing@vivo.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20201111080027.7830f756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <AFoANwC7DUvmHhxeg4sBAapD.3.1605143705212.Hmail.wangqing@vivo.com>
 <CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <64177a8e-eb60-bc27-6d64-26234be47601@ti.com>
Date:   Thu, 12 Nov 2020 12:05:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/2020 10:25, Arnd Bergmann wrote:
> On Thu, Nov 12, 2020 at 2:48 AM 王擎 <wangqing@vivo.com> wrote:
>>>> On Wed, Nov 11, 2020 at 03:24:33PM +0200, Grygorii Strashko wrote:
>>>
>>> I don't think v1 builds cleanly folks (not 100% sure, cpts is not
>>> compiled on x86):
>>>
>>>                ret = cpts->ptp_clock ? cpts->ptp_clock : (-ENODEV);
>>>
>>> ptp_clock is a pointer, ret is an integer, right?
>>
>> yeah, I will modify like: ret = cpts->ptp_clock ? PTR_ERR(cpts->ptp_clock) : -ENODEV;
> 
> This is not really getting any better. If Richard is worried about
> Kconfig getting changed here, I would suggest handling the
> case of PTP being disabled by returning an error early on in the
> function, like
> 
> struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
>                                     struct device_node *node)
> {
>          struct am65_cpts *cpts;
>          int ret, i;
> 
>          if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK))
>                   return -ENODEV;
> 
> Then you can replace the broken IS_ERR_OR_NULL() path with
> a simpler IS_ERR() case and keep the rest of the function readable.

There is proper blocker in am65-cpts.h #if IS_ENABLED(CONFIG_TI_K3_AM65_CPTS)
and in Makefile and proper dependency in Kconfig.

config TI_K3_AM65_CPTS
	tristate "TI K3 AM65x CPTS"
	depends on ARCH_K3 && OF
	depends on PTP_1588_CLOCK

But, as Richard mentioned [1], ptp_clock_register() may return NULL even if PTP_1588_CLOCK=y
(which I can't confirm neither deny - from the fast look at ptp_clock_register()
  code it seems should not return NULL)

> 
>>> Grygorii, would you mind sending a correct patch in so Wang Qing can
>>> see how it's done? I've been asking for a fixes tag multiple times
>>> already :(
>>
>> I still don't quite understand what a fixes tag means，
>> can you tell me how to do this, thanks.
> 
> This identifies which patch introduced the problem you are fixing
> originally. If you add an alias in your ~/.gitconfig such as
> 
> [alias]
>          fixes = show --format='Fixes: %h (\"%s\")' -s
> 
> then running
> 
> $ git fixes f6bd59526c
> produces this line:
> 
> Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common
> platform time sync driver")

correct

> 
> which you can add to the changelog, just above the Signed-off-by
> lines.



[1] https://lore.kernel.org/patchwork/patch/1334067/#1529232
-- 
Best regards,
grygorii
