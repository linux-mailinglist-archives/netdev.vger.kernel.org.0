Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323572A2E43
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 16:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgKBPYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgKBPYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 10:24:21 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12257C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 07:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=7FDKXyrFncYvxFpou/sdWSgaXlb49M50gH+H1vEbApI=; b=Qecm2QfnZQ8+1Zwc53i2lKn43s
        PXM1YVe+9YQkNxAakj1xjLFOBOrPu2t7MX4ifUPDyMNbCqs53KrKYmopaJBIwkMIhpYzdlob0GTii
        oPbwu6iOHr1SUEKLe7im24L+CNBgFE0mnT47+EPfdpMyopul9zMlpPc07yCfCrsFn81U2WLVbzbxs
        iLT70FZcHoTdrFUrKcAiXkPncxshfz7s22sfCgAxZH5xAXIdwltNwTUlYuJVcRY5ig/q/1qGEAa6r
        1EOelCLYEtrcLEg84HivlNOcutqVskVs+vHQrN+I3yzDTRku2a51zJm6PLkM4Z0E2Z9mgVg+zv6RC
        Eekn3/QQ==;
Received: from [2601:1c0:6280:3f0::60d5]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZbgw-0001HS-OC; Mon, 02 Nov 2020 15:24:19 +0000
Subject: Re: [PATCH] staging: wimax: depends on NET
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Networking <netdev@vger.kernel.org>
References: <20201102072456.20303-1-rdunlap@infradead.org>
 <CAK8P3a39LYjQB=qJfBNsbiALohiHsrwdt6g9XUs5esF3KyV3Mw@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b0069d5b-0f58-6ca3-8956-e93bcda36abf@infradead.org>
Date:   Mon, 2 Nov 2020 07:24:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a39LYjQB=qJfBNsbiALohiHsrwdt6g9XUs5esF3KyV3Mw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/20 11:57 PM, Arnd Bergmann wrote:
> On Mon, Nov 2, 2020 at 8:25 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> Fix build errors when CONFIG_NET is not enabled. E.g. (trimmed):
>>
>> ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_alloc':
>> op-msg.c:(.text+0xa9): undefined reference to `__alloc_skb'
>> ld: op-msg.c:(.text+0xcc): undefined reference to `genlmsg_put'
>> ld: op-msg.c:(.text+0xfc): undefined reference to `nla_put'
>> ld: op-msg.c:(.text+0x168): undefined reference to `kfree_skb'
>> ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_data_len':
>> op-msg.c:(.text+0x1ba): undefined reference to `nla_find'
>> ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_send':
>> op-msg.c:(.text+0x311): undefined reference to `init_net'
>> ld: op-msg.c:(.text+0x326): undefined reference to `netlink_broadcast'
>> ld: drivers/staging/wimax/stack.o: in function `__wimax_state_change':
>> stack.c:(.text+0x433): undefined reference to `netif_carrier_off'
>> ld: stack.c:(.text+0x46b): undefined reference to `netif_carrier_on'
>> ld: stack.c:(.text+0x478): undefined reference to `netif_tx_wake_queue'
>> ld: drivers/staging/wimax/stack.o: in function `wimax_subsys_exit':
>> stack.c:(.exit.text+0xe): undefined reference to `genl_unregister_family'
>> ld: drivers/staging/wimax/stack.o: in function `wimax_subsys_init':
>> stack.c:(.init.text+0x1a): undefined reference to `genl_register_family'
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: netdev@vger.kernel.org
> 
> Good catch,
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> I wonder if we also need a dependency on NETDEVICES then,
> since that is what the drivers/net/wimax/ implicitly depended on
> before.

I haven't tested it but I think that would be safe and sensible.

-- 
~Randy

