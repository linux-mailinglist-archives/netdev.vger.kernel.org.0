Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A90F389D1F
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 07:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhETFcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 01:32:13 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:58749 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhETFcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 01:32:12 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Flyy20rlnz9sVL;
        Thu, 20 May 2021 07:30:50 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ijUkvh1s94uX; Thu, 20 May 2021 07:30:50 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Flyy171F7z9sVK;
        Thu, 20 May 2021 07:30:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D3FEF8B805;
        Thu, 20 May 2021 07:30:49 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 5MQwqMwzIuDs; Thu, 20 May 2021 07:30:49 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 74B368B804;
        Thu, 20 May 2021 07:30:49 +0200 (CEST)
To:     Larry Finger <Larry.Finger@lwfinger.net>, fabioaiuto83@gmail.com,
        Greg KH <gregkh@linuxfoundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Conflict between arch/powerpc/include/asm/disassemble.h and
 drivers/staging/rtl8723bs/include/wifi.h
Message-ID: <6954e633-3908-d175-3030-3e913980af78@csgroup.eu>
Date:   Thu, 20 May 2021 07:30:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I was trying to include powerpc asm/disassemble.h in some more widely used headers in order to 
reduce open coding, and I'm facing the following problem:

drivers/staging/rtl8723bs/include/wifi.h:237:30: error: conflicting types for 'get_ra'
drivers/staging/rtl8723bs/include/wifi.h:237:30: error: conflicting types for 'get_ra'
make[4]: *** [scripts/Makefile.build:272: drivers/staging/rtl8723bs/core/rtw_btcoex.o] Error 1
make[4]: *** [scripts/Makefile.build:272: drivers/staging/rtl8723bs/core/rtw_ap.o] Error 1
make[3]: *** [scripts/Makefile.build:515: drivers/staging/rtl8723bs] Error 2

(More details at http://kisskb.ellerman.id.au/kisskb/head/ee2dedcaaf3fe176e68498018632767d02639d03/)

Taking into account that asm/disassemble.h has been existing since 2008 while 
rtl8723bs/include/wifi.h was created in 2017, and that the get_ra() defined in the later is used at 
exactly one place only, would it be possible to change it there ? 
(https://elixir.bootlin.com/linux/v5.13-rc2/A/ident/get_ra)

Thanks
Christophe
