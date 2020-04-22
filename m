Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DFF1B42EA
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 13:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDVLQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 07:16:22 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:43544 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgDVLQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 07:16:21 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03MBGFrS062002;
        Wed, 22 Apr 2020 06:16:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587554175;
        bh=89X1lvMjHBm10I+ntaGK72ShPuo8BykYYefZWM91YCc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=J5SbB60YTkOjlSOgIX0gfiAq4s0ehSiu250MPHxgbPDIPr2/6RZRcKDGqqorUJYcB
         EIJA/xYNx+txh80hrtYzGl3PoYcflFeIvsIieYo3BrGACPBP3+QqVj+JRh+Gmkdi6H
         x8pl2vStWE/BCvde8i/jUO/BsqFlTytiPR785Qns=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03MBGFGY039190
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Apr 2020 06:16:15 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 22
 Apr 2020 06:16:14 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 22 Apr 2020 06:16:14 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03MBGAIg117679;
        Wed, 22 Apr 2020 06:16:12 -0500
Subject: Re: [PATCH] net: cpts: Condition WARN_ON on PTP_1588_CLOCK
To:     Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>
CC:     Clay McClure <clay@daemons.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200416085627.1882-1-clay@daemons.net>
 <6fef3a00-6c18-b775-d1b4-dfd692261bd3@ti.com>
 <20200420093610.GA28162@arctic-shiba-lx>
 <CAK8P3a36ZxNJxUS4UzrwJiMx8UrgYPkcv4X6yYw7EC4jRBbbGQ@mail.gmail.com>
 <20200420170051.GB11862@localhost>
 <CAK8P3a11CqpDJzjy5QfV-ebHgRxUu8SRVTJPPmsus1O1+OL72Q@mail.gmail.com>
 <20200420211819.GA16930@localhost>
 <CAK8P3a18540y3zqR=mqKhj-goinN3c-FGKvAnTHnLgBxiPa4mA@mail.gmail.com>
 <20200420213406.GB20996@localhost>
 <CAK8P3a22aSbpcVK-cZ6rhnPgbYEGU3z__G9xk1EexOPZd5Hmzw@mail.gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <c04458ed-29ee-1797-3a11-7f3f560553e6@ti.com>
Date:   Wed, 22 Apr 2020 14:16:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a22aSbpcVK-cZ6rhnPgbYEGU3z__G9xk1EexOPZd5Hmzw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 21/04/2020 00:42, Arnd Bergmann wrote:
> On Mon, Apr 20, 2020 at 11:34 PM Richard Cochran
> <richardcochran@gmail.com> wrote:
>>
>> On Mon, Apr 20, 2020 at 11:21:20PM +0200, Arnd Bergmann wrote:
>>> It's not great, but we have other interfaces like this that can return NULL for
>>> success when the subsystem is disabled. The problem is when there is
>>> a mismatch between the caller treating NULL as failure when it is meant to
>>> be "successful lack of object returned".
>>
>> Yeah, that should be fixed.
>>
>> To be clear, do you all see a need to change the stubbed version of
>> ptp_clock_register() or not?
> 
> No, if the NULL return is only meant to mean "nothing wrong, keep going
> wihtout an object", that's fine with me. It does occasionally confuse driver
> writers (as seen here), so it's not a great interface, but there is no general
> solution to make it better.

As per commit
commit d1cbfd771ce8297fa11e89f315392de6056a2181
Author: Nicolas Pitre <nicolas.pitre@linaro.org>
Date:   Fri Nov 11 00:10:07 2016 -0500

     ptp_clock: Allow for it to be optional
     
     In order to break the hard dependency between the PTP clock subsystem and
     ethernet drivers capable of being clock providers, this patch provides
     simple PTP stub functions to allow linkage of those drivers into the
     kernel even when the PTP subsystem is configured out. Drivers must be
     ready to accept NULL from ptp_clock_register() in that case.
     
     And to make it possible for PTP to be configured out, the select statement
     in those driver's Kconfig menu entries is converted to the new "imply"
     statement. This way the PTP subsystem may have Kconfig dependencies of
     its own, such as POSIX_TIMERS, without having to make those ethernet
     drivers unavailable if POSIX timers are cconfigured out. And when support
     for POSIX timers is selected again then the default config option for PTP
     clock support will automatically be adjusted accordingly.


the idea of using "imply" is to keep networking enabled even if PTP is configured out
and this exactly what happens with cpts driver.
Another question is that CPTS completely nonfunctional in this case and it was never
expected that somebody will even try to use/run such configuration (except for random build purposes).


-- 
Best regards,
grygorii
