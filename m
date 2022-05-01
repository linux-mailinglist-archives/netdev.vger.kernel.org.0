Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0BB516446
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346524AbiEALwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 07:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244686AbiEALwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 07:52:36 -0400
Received: from mail.tkos.co.il (guitar.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC995AE6F
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 04:49:10 -0700 (PDT)
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id 6668B440061;
        Sun,  1 May 2022 14:48:18 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1651405698;
        bh=A2ELzr4XaHx8zslYw+2miinclFK0UitL5t5085xk/PE=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=QGK3E11vjiHcINxb+M+CDoH1Vh8m2Ocbo+xgUyvohooKgu4K1mf3UWY+zEznR+JfF
         wEy9K8sZXyKBzcadDqlznN7NfC23MAWjhmeWgJn9/MowH78oAMUrGa/XcpRb2mpqBA
         wJdUmrVq22jm0NKQPVB7ofdh+FWcemXkmvqT8/xg9RAniQLKaMI0xCemgJXQgZu7sP
         0S7AnOTSFy4QT2QWd6kY3Y9HkTzvZZGo47jlnX14JCID554xHlmMyvsxdPccgIckEn
         9Ec1PzHqG51ihv4jE/FqeAsAZLaLMlVDsDZy/d1pxLRG2SEIeJ4TFkckdlSbaRFT1N
         hVDS33NtQhPxw==
References: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
 <CAPv3WKf5dnOrzkm6uaFYHkuZZ2ANrr3PMNrUhU5SV6TFAJE2Qw@mail.gmail.com>
 <87levpzcds.fsf@tarshish>
 <CAPv3WKc1eM4gyD_VG2M+ozzvLYrDAXiKGvK6Ej_ykRVf-Zf9Mw@mail.gmail.com>
 <87czh1yn4x.fsf@tarshish> <Ym5yp9Xt094ckexX@shell.armlinux.org.uk>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marcin Wojtas <mw@semihalf.com>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
Date:   Sun, 01 May 2022 14:45:57 +0300
In-reply-to: <Ym5yp9Xt094ckexX@shell.armlinux.org.uk>
Message-ID: <87v8upxykr.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Sun, May 01 2022, Russell King (Oracle) wrote:
> Please trim so I don't have to waste my vital limited power reading
> paging through lots of unnecessary text. Thanks.
>
> On Thu, Apr 28, 2022 at 11:03:08PM +0300, Baruch Siach wrote:
>> mv88x3310 f212a600.mdio-mii:02: Firmware version 0.3.10.0
>> 
>> This is a timing sensitive issue. Slight change in firmware code might
>> be significant.
>
> That should be new enough to avoid the firmware problem - and it seems
> that 0.3.10.0 works fine on the Macchiatobin DS.
>
>> One more detail that might be important is that the PHY firmware is
>> loaded at run-time using this patch (rebased):
>> 
>>   https://lore.kernel.org/all/13177f5abf60215fb9c5c4251e6f487e4d0d7ff0.1587967848.git.baruch@tkos.co.il/
>
> Hmm, I wonder what difference that makes...
>
> Can you confirm the md5sum of your firmware please?
> 95180414ba23f2c7c2fabd377fb4c1df ?

Precisely:

$ md5sum x3310fw_0_3_10_0_10860.hdr 
95180414ba23f2c7c2fabd377fb4c1df  x3310fw_0_3_10_0_10860.hdr

Thanks,
baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
