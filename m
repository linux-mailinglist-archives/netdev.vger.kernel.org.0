Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAE93D0019
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhGTQlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 12:41:31 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:34700
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231200AbhGTQl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 12:41:28 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 23D074190E;
        Tue, 20 Jul 2021 17:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626801724;
        bh=Ip6Rp0Zs3Mz+GD26okTHK+imxxzHuHxOc8fIEFOc4VU=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=qScOn4nb8aSvqu7e39vzfQCcFAAGDIImMmDPIv1XezgPp3zSe/XpnH7/ffhAv1Jwf
         xmZvXGulHZl/qPFifyuVJcS80UJ8i16uib5DfGWXq7khB2bvC/c4kZ4qZz/gbOSxyN
         /4tmxEmRXjAdGyLSEpRpSJwi4ROJ/SQHccjTBgQ8K2mr3aEvWTGb2n/lSsMxR0ky8G
         FpmmIci5cr0hQPQ7HEifnDkUacOEnkU49G6ws/uAXh26nLU54stl72joaWAXiuBe5d
         arg/igK+mRoun/O6mgUQLZabPax14b8yZNLqKPI4agVof5hSqRrISSHez+77q3qjVm
         iUEmrLfwcFNsw==
Subject: Re: [PATCH] atm: idt77252: clean up trigraph warning on ??) string
To:     Nathan Chancellor <nathan@kernel.org>,
        Chas Williams <3chas3@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        clang-built-linux@googlegroups.com
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210720124813.59331-1-colin.king@canonical.com>
 <fd4f465b-86bd-129d-c6d9-e802b7c4815e@kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <5dc1f201-791e-3ca6-0b2d-49c270e572cf@canonical.com>
Date:   Tue, 20 Jul 2021 18:21:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <fd4f465b-86bd-129d-c6d9-e802b7c4815e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/07/2021 18:17, Nathan Chancellor wrote:
> On 7/20/2021 5:48 AM, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The character sequence ??) is a trigraph and causes the following
>> clang warning:
>>
>> drivers/atm/idt77252.c:3544:35: warning: trigraph ignored [-Wtrigraphs]
>>
>> Clean this by replacing it with single ?.
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> This looks good to me but I am curious how you say this warning in the
> first place since the main Makefile disables this unconditionally. Did
> you just pass -Wtrigraphs via KCFLAGS or something similar?

I used W=1

> 
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> 
>> ---
>>   drivers/atm/idt77252.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
>> index 9e4bd751db79..81ce81a75fc6 100644
>> --- a/drivers/atm/idt77252.c
>> +++ b/drivers/atm/idt77252.c
>> @@ -3536,7 +3536,7 @@ static int idt77252_preset(struct idt77252_dev
>> *card)
>>           return -1;
>>       }
>>       if (!(pci_command & PCI_COMMAND_IO)) {
>> -        printk("%s: PCI_COMMAND: %04x (???)\n",
>> +        printk("%s: PCI_COMMAND: %04x (?)\n",
>>                  card->name, pci_command);
>>           deinit_card(card);
>>           return (-1);
>>

