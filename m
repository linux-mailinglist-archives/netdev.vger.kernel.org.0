Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FCB48B929
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236922AbiAKVFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245195AbiAKVE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:04:58 -0500
X-Greylist: delayed 371 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 11 Jan 2022 13:04:57 PST
Received: from mail.kmu-office.ch (mail.kmu-office.ch [IPv6:2a02:418:6a02::a2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999A3C06173F;
        Tue, 11 Jan 2022 13:04:57 -0800 (PST)
Received: from webmail.kmu-office.ch (unknown [IPv6:2a02:418:6a02::a3])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id 199B85C08F0;
        Tue, 11 Jan 2022 21:58:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1641934723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iVvlJDmHXnabUFubsGrlnwqcZ70EOBK8YyJIdSmQOWk=;
        b=LTCk4AvCHBiMbCEEwHEsQbdFoKOblEc4Zd/Cqag/y2+GKOYOExfdJCjOkEyFogWlgA3R2j
        qoZOqcQ7PrKEKE3GgxG7NI1AP1htOlV/Pi7kJpGpmtIyTCFrH/foRiis15yj+6xWjuVrTS
        pfDLoIF41VRRTU98XYXk4iR+VCDBX4Y=
MIME-Version: 1.0
Date:   Tue, 11 Jan 2022 21:58:42 +0100
From:   Stefan Agner <stefan@agner.ch>
To:     Greg KH <greg@kroah.com>
Cc:     Anders Roxell <anders.roxell@linaro.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        clang-built-linux@googlegroups.com, ulli.kroll@googlemail.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, dmitry.torokhov@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org,
        linux-input@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH 4.19 5/6] ARM: 8788/1: ftrace: remove old mcount support
In-Reply-To: <YcBhqJMLdwieZa8X@kroah.com>
References: <20211217144119.2538175-1-anders.roxell@linaro.org>
 <20211217144119.2538175-6-anders.roxell@linaro.org>
 <YcBhqJMLdwieZa8X@kroah.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <cf6f7b9e8694fa87c3e27bd6be67afd2@agner.ch>
X-Sender: stefan@agner.ch
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-20 11:57, Greg KH wrote:
> On Fri, Dec 17, 2021 at 03:41:18PM +0100, Anders Roxell wrote:
>> From: Stefan Agner <stefan@agner.ch>
>>
>> commit d3c61619568c88d48eccd5e74b4f84faa1440652 upstream.
>>
>> Commit cafa0010cd51 ("Raise the minimum required gcc version to 4.6")
>> raised the minimum GCC version to 4.6. Old mcount is only required for
>> GCC versions older than 4.4.0. Hence old mcount support can be dropped
>> too.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> 
> Why is this needed for clang builds in 4.19?

As far as I remember, Clang tripped over this part:

-#ifndef CONFIG_OLD_MCOUNT
-#if (__GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 4))
-#error Ftrace requires CONFIG_FRAME_POINTER=y with GCC older than
4.4.0.
-#endif
-#endif

Since mcount support wasn't required upstream at that point, instead of
fixing it for Clang I just removed it.

--
Stefan
