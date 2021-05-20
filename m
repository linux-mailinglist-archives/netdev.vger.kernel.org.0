Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE847389D4C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 07:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhETFtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 01:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229547AbhETFtS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 01:49:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97ACD6108D;
        Thu, 20 May 2021 05:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621489678;
        bh=1Cf5cc1LRNKo+zO8NlQy2hSrIB+APVWfdL5tadPG43w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FYbTINiDv635zTC9y5P26D/jwXf8i18ov+MHjO8zJWYD8c5nBtTqA6mJB3RO5MM3/
         BDkd9HCdPYK5wVgVVxhJs8yTxaiCwdDzDlV4Jsvf0p9HmR3JwBbihmPGgbD9Bp/9uJ
         DAkgvGC+6YQbauNTzD9aZ1G3fT8y/IFlv+9xSKMk=
Date:   Thu, 20 May 2021 07:47:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>, fabioaiuto83@gmail.com,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: Conflict between arch/powerpc/include/asm/disassemble.h and
 drivers/staging/rtl8723bs/include/wifi.h
Message-ID: <YKX4ChOvYjPjOwco@kroah.com>
References: <6954e633-3908-d175-3030-3e913980af78@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6954e633-3908-d175-3030-3e913980af78@csgroup.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 07:30:49AM +0200, Christophe Leroy wrote:
> Hello,
> 
> I was trying to include powerpc asm/disassemble.h in some more widely used
> headers in order to reduce open coding, and I'm facing the following
> problem:
> 
> drivers/staging/rtl8723bs/include/wifi.h:237:30: error: conflicting types for 'get_ra'
> drivers/staging/rtl8723bs/include/wifi.h:237:30: error: conflicting types for 'get_ra'
> make[4]: *** [scripts/Makefile.build:272: drivers/staging/rtl8723bs/core/rtw_btcoex.o] Error 1
> make[4]: *** [scripts/Makefile.build:272: drivers/staging/rtl8723bs/core/rtw_ap.o] Error 1
> make[3]: *** [scripts/Makefile.build:515: drivers/staging/rtl8723bs] Error 2
> 
> (More details at http://kisskb.ellerman.id.au/kisskb/head/ee2dedcaaf3fe176e68498018632767d02639d03/)
> 
> Taking into account that asm/disassemble.h has been existing since 2008
> while rtl8723bs/include/wifi.h was created in 2017, and that the get_ra()
> defined in the later is used at exactly one place only, would it be possible
> to change it there ?
> (https://elixir.bootlin.com/linux/v5.13-rc2/A/ident/get_ra)

Yes, the staging code can change, I'll make a patch for it after
coffee...

