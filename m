Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE05F9894
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 19:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfKLSZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 13:25:13 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:18573 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKLSZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 13:25:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573583109;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=fSJGRofWvt7LvLz9HBtmizCcIhkTJDFC2UnS/Pd8oQY=;
        b=tX2kTQUqV/HDaPoXbt6htZ4trJ23KwCCjFky/RwdwwKz0P8Bh8dzemoybyM5vcqOLK
        owoc2CrfohKUcJhYqoxVaG25WWbLIiB9az/OiUu1FUvh3omBqqGdaTYFDVP19htGkmMs
        hRY2GAArLNH2EHrtkFes8bOJxN8s8Xdq0kq6wEY1sfRHFRUbf7lFYG9fDjoxRHnVmyEP
        xMM9447PP44Q8gYkoVyF0/J9FgOkVqFHYE2Tk2pfDVzIR9aXByAYawCuLAJ25h4T6ExM
        Fg05ZtiSKOi0Ud6XXulNyBX0MqBImqbDUqPhEZzcQ7Y6UOiV8McOZqiqQDtn18QtLCuB
        /arA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMGX8h5lkuA"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id C03a03vACIOxggE
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 12 Nov 2019 19:24:59 +0100 (CET)
Subject: Re: [PATCH v1 1/9] can: af_can: export can_sock_destruct()
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        dev.kurt@vandijck-laurijssen.be, wg@grandegger.com,
        netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
References: <20191112111600.18719-1-o.rempel@pengutronix.de>
 <20191112111600.18719-2-o.rempel@pengutronix.de>
 <20191112113724.pff6atmyii5ri4my@pengutronix.de>
 <1da06748-6233-b65e-9b02-da5a867a4ecb@pengutronix.de>
 <20191112114539.zjluqnpo3cynhssi@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <5e561756-26b4-9a71-8fe2-c876e0e7d1af@hartkopp.net>
Date:   Tue, 12 Nov 2019 19:24:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191112114539.zjluqnpo3cynhssi@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/2019 12.45, Uwe Kleine-König wrote:
> Hello Marc,
> 
> On Tue, Nov 12, 2019 at 12:39:27PM +0100, Marc Kleine-Budde wrote:
>> On 11/12/19 12:37 PM, Uwe Kleine-König wrote:
>>> On Tue, Nov 12, 2019 at 12:15:52PM +0100, Oleksij Rempel wrote:
>>>> +EXPORT_SYMBOL(can_sock_destruct);
>>>
>>> If the users are only expected to be another can module, it might make
>>> sense to use a namespace here?!
>>
>> How?
> 
> Use
> 
> 	EXPORT_SYMBOL_NS(can_sock_destruct, CAN)
> 
> instead of the plain EXPORT_SYMBOL, and near the declaration of
> can_sock_destruct or in the source that makes use of the symbol add:
> 
> 	MODULE_IMPORT_NS(CAN);
> 
> See https://lwn.net/Articles/760045/ for some details.

Looks nice! Good idea!

But I would tend to introduce the symbol namespaces for this and the 
other (existing) symbols via can-next and not within this patch set that 
addresses the j1939 fixes.

Best regards,
Oliver
