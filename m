Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF516230CAF
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 16:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730514AbgG1OuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 10:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730335AbgG1OuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 10:50:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2ABC061794;
        Tue, 28 Jul 2020 07:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=QTqHP6bK9W4RFpKAMBcspR5sA1/+rrn6GZmLT6RFR2o=; b=jF9O5dfqNDC0lWxB7y/eY27PpJ
        XVJ1Zl6Xh6YxEBwVfJ7AV+OcbuFxqaCPr1o1Ko/I/V8dZfo49zDUPE42Y2plHlxH+MNcoXw+b6trg
        i03meS7XFWkTrrM2aFbUwNpXUvOWqlIhhrTGN8E5HhfkjKAFYqqmvl/q909D5aPWbgfwoYHog+Sd2
        q3BlVtdubcUIopYG8CURT7UrAcyiiJITcbWxjyvRpvB/UnvQcJWunC3Fvqx7/a6HmokqaY6/2jeIw
        VA3uFOYJs0zt9FTLtonZzQK+nCaKyk/DbimLBV/hyzuHT9MR/e4aV72HJunpTlDDbwWzCZxyMJYF9
        +LNnf8Sw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0Qvk-0001Bt-Rh; Tue, 28 Jul 2020 14:50:13 +0000
Subject: Re: linux-next: Tree for Jul 28 (drivers/net/usb/)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.org>
References: <20200728215731.00cb56d3@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d8e712fa-65c8-f616-3411-a41b88950eba@infradead.org>
Date:   Tue, 28 Jul 2020 07:50:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728215731.00cb56d3@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/20 4:57 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20200727:
> 

on i386:

CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_HUAWEI_CDC_NCM=m
CONFIG_USB_NET_CDC_MBIM=m

ld: drivers/net/usb/cdc_ncm.o:(.rodata+0x27c): undefined reference to `usbnet_cdc_update_filter'
ld: drivers/net/usb/cdc_ncm.o:(.rodata+0x2dc): undefined reference to `usbnet_cdc_update_filter'
ld: drivers/net/usb/cdc_ncm.o:(.rodata+0x33c): undefined reference to `usbnet_cdc_update_filter'

because 'usbnet_cdc_update_filter' lives in cdc_ether.c, which is being built
as a loadable module while cdc_ncm.o is builtin.


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
