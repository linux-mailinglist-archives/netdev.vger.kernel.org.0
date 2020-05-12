Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0171CEF38
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 10:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgELIgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 04:36:04 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:45742 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgELIgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 04:36:03 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04C8Ziu9024445;
        Tue, 12 May 2020 03:35:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589272544;
        bh=w6SvlgwOineI01tS7SoCMkc0epnn0527dHvSR50zF18=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=c1xrQ8l4vT0z9iC94p7vdwa4vk2QOJPfW/urGqOOHCsTS1WrDxL+UjE3l2miLzVfX
         fKyaqZVtIicorRPjJToWyxmLgDRpkvcJpvtv1Yz6onG9mRnKg3kCtI9tBgWvHxB7KA
         wOEEBdNpBQn0U9tfmWJsDXll7bHKt39Z7UlywPME=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04C8ZiJf056062
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 03:35:44 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 12
 May 2020 03:35:43 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 12 May 2020 03:35:43 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04C8Zdpg056802;
        Tue, 12 May 2020 03:35:41 -0500
Subject: Re: [PATCH net v3] net: ethernet: ti: fix build and remove
 TI_CPTS_MOD workaround
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Networking <netdev@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Clay McClure <clay@daemons.net>, Dan Murphy <dmurphy@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
References: <20200508095914.20509-1-grygorii.strashko@ti.com>
 <CAK8P3a0qfFzJGya-Ydst8dwC8d7wydfNG-4Ef9zkycEd8WLOCA@mail.gmail.com>
 <7df7a64c-f564-b0cc-9100-93c9e417c2fc@ti.com>
 <CAK8P3a0-6vRpHJugnUFhNNAALmqx4CUW9ffTOojxu5a80tAQTw@mail.gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <b0e2bd21-f670-f05a-6e23-4c6c75a94868@ti.com>
Date:   Tue, 12 May 2020 11:35:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0-6vRpHJugnUFhNNAALmqx4CUW9ffTOojxu5a80tAQTw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On 08/05/2020 14:25, Arnd Bergmann wrote:
> On Fri, May 8, 2020 at 1:14 PM Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
>> On 08/05/2020 13:10, Arnd Bergmann wrote:
>>> On Fri, May 8, 2020 at 11:59 AM Grygorii Strashko
> 
>>>> That's because TI_CPTS_MOD (which is the symbol gating the _compilation_ of
>>>> cpts.c) now depends on PTP_1588_CLOCK, and so is not enabled in these
>>>> configurations, but TI_CPTS (which is the symbol gating _calls_ to the cpts
>>>> functions) _is_ enabled. So we end up compiling calls to functions that
>>>> don't exist, resulting in the linker errors.
>>>>
>>>> This patch fixes build errors and restores previous behavior by:
>>>>    - ensure PTP_1588_CLOCK=y in TI specific configs and CPTS will be built
>>>>    - use IS_REACHABLE(CONFIG_TI_CPTS) in code instead of IS_ENABLED()
>>>
>>> I don't understand what IS_REACHABLE() is needed for once all the other
>>> changes are in place. I'd hope we can avoid that. Do you still see
>>> failures without
>>> that or is it just a precaution. I can do some randconfig testing on your patch
>>> to see what else might be needed to avoid IS_REACHABLE().
>>
>> I've not changed this part of original patch, but seems you're right.
>>
>> I can drop it and resend, but, unfortunately, i do not have time today for full build testing.
> 
> I have applied to patch locally to my randconfig tree, with the IS_REACHABLE()
> changes taken out.
> 

What will be the conclusion here?

-- 
Best regards,
grygorii
