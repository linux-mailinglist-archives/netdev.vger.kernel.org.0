Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6746F3A912B
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 07:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhFPFfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 01:35:42 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:16427 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230217AbhFPFfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 01:35:36 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4G4Ykd6FZQzBDfJ;
        Wed, 16 Jun 2021 07:33:29 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QiGHvvZE9cj6; Wed, 16 Jun 2021 07:33:29 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4G4Ykd5KtRzBDck;
        Wed, 16 Jun 2021 07:33:29 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B88498B7CA;
        Wed, 16 Jun 2021 07:33:29 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 13HZ1Y_Q6pCI; Wed, 16 Jun 2021 07:33:29 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 353858B765;
        Wed, 16 Jun 2021 07:33:29 +0200 (CEST)
Subject: Re: [PATCH] vmxnet3: prevent building with 256K pages
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pv-drivers@vmware.com, doshir@vmware.com
References: <20210615123504.547106-1-mpe@ellerman.id.au>
 <76ccb9fc-dc43-46e1-6465-637b72253385@csgroup.eu>
 <YMmKPIEk6XQsXq9T@infradead.org>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <4d153452-8d83-248e-886c-bac7aed5a90d@csgroup.eu>
Date:   Wed, 16 Jun 2021 07:33:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YMmKPIEk6XQsXq9T@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 16/06/2021 à 07:21, Christoph Hellwig a écrit :
> On Tue, Jun 15, 2021 at 02:41:34PM +0200, Christophe Leroy wrote:
>> Maybe we should also exclude hexagon, same as my patch on BTRFS https://patchwork.ozlabs.org/project/linuxppc-dev/patch/a16c31f3caf448dda5d9315e056585b6fafc22c5.1623302442.git.christophe.leroy@csgroup.eu/
> 
> Maybe we really need common config symbols for the page size instead of
> all these hacks..
> 

I agree.

Today we have:

arch/hexagon/Kconfig:config PAGE_SIZE_4KB
arch/hexagon/Kconfig:config PAGE_SIZE_16KB
arch/hexagon/Kconfig:config PAGE_SIZE_64KB
arch/hexagon/Kconfig:config PAGE_SIZE_256KB
arch/mips/Kconfig:config PAGE_SIZE_4KB
arch/mips/Kconfig:config PAGE_SIZE_8KB
arch/mips/Kconfig:config PAGE_SIZE_16KB
arch/mips/Kconfig:config PAGE_SIZE_32KB
arch/mips/Kconfig:config PAGE_SIZE_64KB
arch/sh/mm/Kconfig:config PAGE_SIZE_4KB
arch/sh/mm/Kconfig:config PAGE_SIZE_8KB
arch/sh/mm/Kconfig:config PAGE_SIZE_16KB
arch/sh/mm/Kconfig:config PAGE_SIZE_64KB


I think we should convert all other architectures to that syntax.

Christophe
