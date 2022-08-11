Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27F858FE7B
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 16:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiHKOpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 10:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbiHKOpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 10:45:22 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2864D4C4
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 07:45:19 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 7F3897F4F5;
        Thu, 11 Aug 2022 16:45:16 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FC1C34064;
        Thu, 11 Aug 2022 16:45:16 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36F353405A;
        Thu, 11 Aug 2022 16:45:16 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Thu, 11 Aug 2022 16:45:16 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id 065F47F4F5;
        Thu, 11 Aug 2022 16:45:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1660229116; bh=wXtS1o/HSgTocLUz3sZJVxczEjGW0dN6Iugvpri01Yc=;
        h=Date:Subject:To:CC:References:From:In-Reply-To:From;
        b=hgYPuKZIapHXZCCStgsqkMmPI2v9RLrH4FEp3k+V3j5mAjQZ2/jM2S+cdwZumOWaf
         aix008CD9yXl+vfdckoZjth7gsLMij49uX3k5YJwCFvqT+U9EK/bjRia4EO4dzfx5E
         veiVYbEReO42pXg+PmnsicRhIqA8uR3ci7n34BhghpT2aHjUUCsogW11xLasGTU7QH
         YUoCgD18PpInAM6VUWqOO9QiR1fq2zPKSY5oXJ3YrhE+SdXEIelVQ997jD2Muf9Wna
         2rfTX2S3r06aXsxAtVfq9pn7YacjToMU4dlP4irDwZ3UNcNpvg1lgdHjcWfz72gjoM
         Icgs2pKO0SfrA==
Received: from [10.254.7.28] (10.254.7.28) by atlas.intranet.prolan.hu
 (10.254.0.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.9; Thu, 11
 Aug 2022 16:45:15 +0200
Message-ID: <91d6794e-9e22-2a7c-b40a-436da63c78b5@prolan.hu>
Date:   Thu, 11 Aug 2022 16:45:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] fec: Restart PPS after link state change
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
References: <20220809124119.29922-1-csokas.bence@prolan.hu>
 <YvKZNcVfYdLw7bkm@lunn.ch> <299d74d5-2d56-23f6-affc-78bb3ae3e03c@prolan.hu>
 <YvRH06S/7E6J8RY0@lunn.ch> <9aa60160-8d8e-477f-991a-b2f4cc72ddf6@prolan.hu>
 <YvUEgKl6fpHwMwuS@lunn.ch>
From:   =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <YvUEgKl6fpHwMwuS@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.254.7.28]
X-ClientProxiedBy: atlas.intranet.prolan.hu (10.254.0.229) To
 atlas.intranet.prolan.hu (10.254.0.229)
X-EsetResult: clean, is OK
X-EsetId: 37303A29971EF456617366
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022. 08. 11. 15:30, Andrew Lunn wrote:
>> `fep->pps_enable` is the state of the PPS the driver *believes* to be the
>> case. After a reset, this belief may or may not be true anymore: if the
>> driver believed formerly that the PPS is down, then after a reset, its
>> belief will still be correct, thus nothing needs to be done about the
>> situation. If, however, the driver thought that PPS was up, after controller
>> reset, it no longer holds, so we need to update our world-view
>> (`fep->pps_enable = 0;`), and then correct for the fact that PPS just
>> unexpectedly stopped.
> 
> Your way of doing it just seems very unclean. I would make
> fec_ptp_enable_pps() read the actual status from the
> hardware. fep->pps_enable then has the clear meaning of user space
> requested it should be enabled.

1. It is not "my way", it is how it was in the original code. I am 
merely following those who came before me.
2. There is already a variable which holds userspace's wish: parameter 
`uint enable` in `fec_ptp_enable_pps()`. `fep->pps_enable` is whether 
the driver already fulfilled this wish.

> 
> 	  Andrew

Honestly, I would rather see the entire `fec` driver re-written from 
scratch, it is really bad code and full of bugs. Plus, Fugang Duan's 
mail server keeps bouncing back all my emails (I can only hope he sees 
these mails through the mailing list). However, that exceeds my 
capabilities unfortunately (I know not nearly enough of the various 
fec-based controllers and their internals, I only have the i.MX6 TX6UL 
to test). So the best I can do is provide fixes to the bugs we 
experienced, while changing as little of the original driver's code as 
possible, so as to (hopefully) not introduce even more bugs.

Bence
