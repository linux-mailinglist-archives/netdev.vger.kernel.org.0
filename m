Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F072251BE7
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 17:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgHYPLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 11:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgHYPLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 11:11:04 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0CAC061755;
        Tue, 25 Aug 2020 08:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=LPG5Lc7nCg6NrS7ax+6DMhtaCUehIHNu6awjAcV2BcE=; b=tB7mY0ZOpnz4kAH3i8HK3Mu2Dr
        KdjEI6mp7kDoq4wQGigAPa4qc5Uzr0yGhCJqcti2O8wuhkO6l6Y5mOSL5jBo8HryngLeovoPGDjvT
        6NodraZ/TUTwHK4CD7ro8a1FOfHYzy0YSFWm5tmdL574Q81rla/G/tPLAgmKQmu9ZnQluf4rmyxgf
        36SM1gZq65OUuvNaW1W4PtfWlUuVHkOZzx9ekjEmCBgdQC/lzKDU5CnupngOBr3GGGxzUhWMQ1ePt
        szktTlwydy0dQUcdxA0P35WDPeRCbcYF+OC7Fbzc4p7owylhuQMtnZlwQAd780JWGROiokTNr5vxl
        WvTtxoaA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kAab6-0005G5-QJ; Tue, 25 Aug 2020 15:10:53 +0000
Subject: Re: [PATCH v5 5/6] can: ctucanfd: CTU CAN FD open-source IP core -
 platform and next steps and mainlining chances
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Drew Fustini <pdp7pdp7@gmail.com>
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>
References: <cover.1597518433.git.ppisa@pikron.com>
 <4ceda3a9d68263b4e0dfe66521a46f40b2e502f7.1597518433.git.ppisa@pikron.com>
 <73e3dad8-9ab7-2f8f-312c-1957b4572b08@infradead.org>
 <202008251125.41514.pisa@cmp.felk.cvut.cz>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6f26127d-5403-3ea2-9b6d-11dc35b0d5c2@infradead.org>
Date:   Tue, 25 Aug 2020 08:10:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <202008251125.41514.pisa@cmp.felk.cvut.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/20 2:25 AM, Pavel Pisa wrote:
> Hello Randy and Rob,
> 
> thanks much for review, I have corrected FPGA spelling
> and binding YAML license.
> 
> On Sunday 16 of August 2020 01:28:13 Randy Dunlap wrote:
>> On 8/15/20 12:43 PM, Pavel Pisa wrote:
>>> diff --git a/drivers/net/can/ctucanfd/Kconfig
>>> b/drivers/net/can/ctucanfd/Kconfig index e1636373628a..a8c9cc38f216
>>> 100644
>>> --- a/drivers/net/can/ctucanfd/Kconfig
>>> +++ b/drivers/net/can/ctucanfd/Kconfig
>>> @@ -21,4 +21,15 @@ config CAN_CTUCANFD_PCI
>>>  	  PCIe board with PiKRON.com designed transceiver riser shield is
>>> available at https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd .
>>>
>>> +config CAN_CTUCANFD_PLATFORM
>>> +	tristate "CTU CAN-FD IP core platform (FPGA, SoC) driver"
>>> +	depends on OF
>>
>> Can this be
>> 	depends on OF || COMPILE_TEST
>> ?
> 
> I am not sure for this change. Is it ensured/documented somewhere that
> header files provide dummy definition such way, that OF drivers builds
> even if OF support is disabled? If I remember well, CTU CAN FD OF
> module build fails if attempted in the frame of native x86_64
> build where OF has been disabled. Does COMPILE_TEST ensure that
> such build succeeds.
> 

COMPILE_TEST won't ensure anything.
OTOH, <linux/of.h> has lots of stubs for handling the case of
CONFIG_OF not being enabled.

-- 
~Randy

