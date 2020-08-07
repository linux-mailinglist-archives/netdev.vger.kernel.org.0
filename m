Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F32323EAD7
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 11:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgHGJsO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 Aug 2020 05:48:14 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3008 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727012AbgHGJsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 05:48:13 -0400
Received: from dggeme751-chm.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 32A3FA343AFD2D9F7DEE;
        Fri,  7 Aug 2020 17:48:11 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme751-chm.china.huawei.com (10.3.19.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 7 Aug 2020 17:48:10 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Fri, 7 Aug 2020 17:48:10 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] net: Set fput_needed iff FDPUT_FPUT is set
Thread-Topic: [PATCH 3/5] net: Set fput_needed iff FDPUT_FPUT is set
Thread-Index: AdZr620tBH193zydRFGWcrvlIYey9g==
Date:   Fri, 7 Aug 2020 09:48:10 +0000
Message-ID: <f9487fa9e24148dc98f22ebe9c3e9478@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.177.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Al Viro <viro@zeniv.linux.org.uk> wrote:
>On Thu, Aug 06, 2020 at 12:59:16PM +0100, Al Viro wrote:
>> On Thu, Aug 06, 2020 at 07:53:16PM +0800, linmiaohe wrote:
>> > From: Miaohe Lin <linmiaohe@huawei.com>
>> > 
>> > We should fput() file iff FDPUT_FPUT is set. So we should set 
>> > fput_needed accordingly.
>> > 
>> > Fixes: 00e188ef6a7e ("sockfd_lookup_light(): switch to fdget^W^Waway 
>> > from fget_light")
>> 
>> Explain, please.  We are getting it from fdget(); what else can we get in flags there?
>
>FWIW, struct fd ->flags may have two bits set: FDPUT_FPUT and FDPUT_POS_UNLOCK.
>The latter is set only by __fdget_pos() and its callers, and that only for regular files and directories.
>
>Nevermind that sockfd_lookup_light() does *not* use ..._pos() family of primitives, even if it started to use e.g. fdget_pos() it *still* would not end up with anything other than FDPUT_FPUT to deal with on that path - it checks that what it got is a socket.  Anything else is dropped right there, without leaving fput() to caller.
>
>So could you explain what exactly the bug is - if you are seeing some breakage and this patch fixes it, something odd is definitely going on and it would be nice to figure out what that something is.

I'am sorry, but I did not find something odd. I do this because this would make code more clear and consistent. It's pure a clean up patch.
Maybe Fixes tag makes this looks like a bugfix.

Thanks for your reply and detailed explaination. :)

And sorry for my rookie mistake, I wasn't meant to make these as a patch set...

