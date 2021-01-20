Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18BD2FD0B2
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 13:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbhATMtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:49:16 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:64484 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbhATLbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 06:31:41 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4DLNcF4Xp7z9v6Zt;
        Wed, 20 Jan 2021 12:30:21 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 6D0443gTD0CP; Wed, 20 Jan 2021 12:30:21 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4DLNcF3Tc8z9vBmV;
        Wed, 20 Jan 2021 12:30:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B4C4D8B7E8;
        Wed, 20 Jan 2021 12:30:22 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id VT9iB0R-mpp4; Wed, 20 Jan 2021 12:30:22 +0100 (CET)
Received: from [172.25.230.103] (po15451.idsi0.si.c-s.fr [172.25.230.103])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 7A60E8B7E6;
        Wed, 20 Jan 2021 12:30:22 +0100 (CET)
Subject: Re: [PATCH net-next v2 11/17] ethernet: ucc_geth: don't statically
 allocate eight ucc_geth_info
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
 <20210119150802.19997-12-rasmus.villemoes@prevas.dk>
 <fa391dc7-9870-dd7b-503d-c0f1468328c2@csgroup.eu>
 <582b6ef6-e913-5aaa-61d4-de75c96abb8b@prevas.dk>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <4a6ff399-b394-e6c0-9d03-a48faf5670b7@csgroup.eu>
Date:   Wed, 20 Jan 2021 12:30:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <582b6ef6-e913-5aaa-61d4-de75c96abb8b@prevas.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 20/01/2021 à 12:25, Rasmus Villemoes a écrit :
> On 20/01/2021 08.02, Christophe Leroy wrote:
>>
>>> @@ -3715,25 +3713,23 @@ static int ucc_geth_probe(struct
>>> platform_device* ofdev)
>>>        if ((ucc_num < 0) || (ucc_num > 7))
>>>            return -ENODEV;
>>>    -    ug_info = &ugeth_info[ucc_num];
>>> -    if (ug_info == NULL) {
>>> -        if (netif_msg_probe(&debug))
>>> -            pr_err("[%d] Missing additional data!\n", ucc_num);
>>> -        return -ENODEV;
>>> -    }
>>> +    ug_info = kmalloc(sizeof(*ug_info), GFP_KERNEL);
>>
>> What about using devm_kmalloc() and avoid those kfree and associated goto ?
> 
> I already replied to that: I'd rather not mix kmalloc() and
> devm_kmalloc() as that makes it much harder to reason about the order in
> which stuff gets deallocated. But sure, if you insist.
> 

I didn't remember I already did the same comment, sorry.

Christophe
