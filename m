Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A90B44A670
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 06:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237357AbhKIFr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 00:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbhKIFr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 00:47:27 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660D4C061764;
        Mon,  8 Nov 2021 21:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=9LqhmCut5SF3DMae/hAoDOqrhl3+cMlgxC2F4ZihZiU=; b=1FJ+0ZuPvYziO8us2LpFYDr92n
        77BJEuUHueJJSeeMUaRkBE9AZgJw/8SgoDs0nSOg4esYiboDsEBP2CrGY5zz4vDIikwMdPzjApQCq
        2/E7XudSgM28rudY9Kpr2JCAHzWdbg1RP7LHZiX5If0X4jlEv1s3bqK6OdC94aemHucGe8yNvGgvo
        6j0kirjZ+btqsle6JMiPpk8z3+Sfcloz22JKNF67usxybXJRW6yhlr4zw+FysTjmNnnNHGXps0M2P
        /W+3TlVan6juYg0cjiXCsfxfeSvDX54tFEuYM5yZk9SM+7ajISsUgTjxkAJQo1aUxCNstZeP5FJwd
        7u/jH2aQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkJvx-008lfr-De; Tue, 09 Nov 2021 05:44:37 +0000
Subject: Re: [PATCH net v9 3/3] net/8390: apne.c - add 100 Mbit support to
 apne.c driver
To:     Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org,
        geert@linux-m68k.org
Cc:     alex@kazik.de, netdev@vger.kernel.org
References: <20211109040242.11615-1-schmitzmic@gmail.com>
 <20211109040242.11615-4-schmitzmic@gmail.com>
 <3d4c9e98-f004-755c-2f30-45b951ede6a6@infradead.org>
 <d5fa96b6-a351-1195-7967-25c26d9a04fb@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c7ab4109-9abf-dfe8-0325-7d3e113aa66c@infradead.org>
Date:   Mon, 8 Nov 2021 21:44:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <d5fa96b6-a351-1195-7967-25c26d9a04fb@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/21 8:55 PM, Michael Schmitz wrote:
> Hi Randy,
> 
> On 09/11/21 17:09, Randy Dunlap wrote:
>> On 11/8/21 8:02 PM, Michael Schmitz wrote:
>>> diff --git a/drivers/net/ethernet/8390/Kconfig
>>> b/drivers/net/ethernet/8390/Kconfig
>>> index a4130e643342..b22c3cf96560 100644
>>> --- a/drivers/net/ethernet/8390/Kconfig
>>> +++ b/drivers/net/ethernet/8390/Kconfig
>>> @@ -136,6 +136,8 @@ config NE2K_PCI
>>>   config APNE
>>>       tristate "PCMCIA NE2000 support"
>>>       depends on AMIGA_PCMCIA
>>> +    select PCCARD
>>> +    select PCMCIA
>>>       select CRC32
>>
>> Hi,
>>
>> There are no other drivers that "select PCCARD" or
>> "select PCMCIA" in the entire kernel tree.
>> I don't see any good justification to allow it here.
> 
> Amiga doesn't use anything from the core PCMCIA code, instead providing its own basic PCMCIA support code.
> 
> I had initially duplicated some of the cis tuple parser code, but decided to use what's already there instead.
> 
> I can drop these selects, and add instructions to manually select these options in the Kconfig help section. Seemed a little error prone to me.

Just make it the same as other drivers in this respect, please.

-- 
~Randy
