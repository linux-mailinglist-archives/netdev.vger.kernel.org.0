Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B781D4D6D
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 14:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgEOMID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 08:08:03 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:56892 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgEOMID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 08:08:03 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04FC7ncL069619;
        Fri, 15 May 2020 07:07:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589544469;
        bh=P2WNi7x0Zj8xqyBPxb8DBbQOS164uI/PXBCVTPhezlo=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=YgpXD3qY4FRwgn8ktmFMnOrKc0z7ACElFFeK/6D1FGNS9fUe0Mmg68P+RVh1L2Vzs
         V2wbIgg3Hi3Nbsyk34iZ4EyPvLCcpLEbOVafiACntP20Wq8wU+cnjPBDKkUavmGsLr
         +Ey8hdQ46uK+0bBXKHbSp8Yq0TjN3ArpESP9xrEw=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04FC7ntd052692
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 07:07:49 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 15
 May 2020 07:07:48 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 15 May 2020 07:07:49 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04FC7ivD003821;
        Fri, 15 May 2020 07:07:45 -0500
Subject: Re: [PATCH AUTOSEL 5.6 30/62] net: Make PTP-specific drivers depend
 on PTP_1588_CLOCK
To:     Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Clay McClure <clay@daemons.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
 <20200514185147.19716-30-sashal@kernel.org>
 <CAK8P3a1Yh-qeh_CCVQZFcT0JMvhoxHx72KUWf3FXYD4yk_ptTw@mail.gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <2b087eec-98b8-dedf-410c-c966d9802c89@ti.com>
Date:   Fri, 15 May 2020 15:07:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a1Yh-qeh_CCVQZFcT0JMvhoxHx72KUWf3FXYD4yk_ptTw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15/05/2020 00:40, Arnd Bergmann wrote:
> On Thu, May 14, 2020 at 8:52 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Clay McClure <clay@daemons.net>
>>
>> [ Upstream commit b6d49cab44b567b3e0a5544b3d61e516a7355fad ]
>>
>> Commit d1cbfd771ce8 ("ptp_clock: Allow for it to be optional") changed
>> all PTP-capable Ethernet drivers from `select PTP_1588_CLOCK` to `imply
>> PTP_1588_CLOCK`, "in order to break the hard dependency between the PTP
>> clock subsystem and ethernet drivers capable of being clock providers."
> 
> I don't think this one should be backported unless 3a9dd3ecb207 ("kconfig:
> make 'imply' obey the direct dependency") is already backported to v5.6
> (which I don't think it should either).
> 
Yes. pls, drop it. It's rather optimization, not a fix.
And it might introduce build failures.

-- 
Best regards,
grygorii
