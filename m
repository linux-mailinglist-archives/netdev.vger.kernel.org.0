Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416D8497EB8
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238421AbiAXMND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:13:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238415AbiAXMNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:13:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643026381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jgo/S7sjlaPhT9Y19EsdD9p5FFY6hIgWybsEw2AdVf4=;
        b=jSA2vMVkNKNyy/y9u7NWm1nr3AzkYBVLqqCD681n72dbbG126z/V91wylIFGfYe2GOHaR1
        M/tKqrTDekgwIfpQOM/UDCjnpVktsFRBXmCvKL8ydiFh+eSk8KjAAS3zbJf1DxqlUWfsrK
        +9uVWT8zk4ARVHz6iOSuqmo2ouEMe7g=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-1FCGePtFN6ir84iCDSdrRg-1; Mon, 24 Jan 2022 07:12:58 -0500
X-MC-Unique: 1FCGePtFN6ir84iCDSdrRg-1
Received: by mail-ed1-f71.google.com with SMTP id h11-20020a05640250cb00b003fa024f87c2so13033227edb.4
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 04:12:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Jgo/S7sjlaPhT9Y19EsdD9p5FFY6hIgWybsEw2AdVf4=;
        b=jhBnZahpbDPo6ZpwxdHN+beHJLnk452bIYBef4nZ2afBRdwxdrkIpJENa+1ESdvzgW
         /ggrhcA4MHEjjmXrosWY3rtiw8cXkKKs0AMC2FdZJeGjI9BhzR7MkjVY0Yv5ZEbgdOlt
         CfYX1RiDkA+pHfScUUsRZ1awXOkfChxygHzJvTIfeVCleFLyq+A87cr7iFmhi3MMFfS8
         0MEW2mR0kfAFZumti4vS7xD3bovsAB8vDk1NonKi3018Fdm+0xBnfwAERiUjMUUquwyY
         /nelwydVewLuEfs2CgwOKD07MK+gXi9AMu/pTXZvjNo/byQp3vrRktDUGSxlOA047sPs
         N22g==
X-Gm-Message-State: AOAM531w/A/6cqzuADr8wzF2PI2RR1IZUo0H6LKrB8bIFBJM5DEMNqtg
        MJ/zkJKX622xNlcATBGoKNqMgF2QiyR0ZNtvzAb9mmTGTCHDObBnAvKbwPmnMrB70qzNDZSMTfe
        2ulqKie0bJb5a3m6y
X-Received: by 2002:a50:f60a:: with SMTP id c10mr15677278edn.244.1643026376215;
        Mon, 24 Jan 2022 04:12:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzeAP+ilNlgL4BcKuLW9AzZIZHsF6UJc18boCsxUW/7gD4RQkhhDnrivWREc2YP+evP+Hm8iw==
X-Received: by 2002:a50:f60a:: with SMTP id c10mr15677203edn.244.1643026374972;
        Mon, 24 Jan 2022 04:12:54 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id bl12sm4786871ejb.75.2022.01.24.04.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 04:12:54 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B0E2F18044B; Mon, 24 Jan 2022 13:12:53 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [net RFC v1 1/1] page_pool: fix NULL dereference crash
In-Reply-To: <CAADnVQ+UqKMfn+ZxgOkBcXidBWUGJDugU7gCEV+rGS6wscZjJw@mail.gmail.com>
References: <20220122005644.802352-1-colin.foster@in-advantage.com>
 <20220122005644.802352-2-colin.foster@in-advantage.com>
 <CAADnVQK8xrQ92+=wm8AoDkC93SEKz3G=CoOnkPgvs=spJk5UZA@mail.gmail.com>
 <20220122022047.GA803138@euler>
 <CAADnVQ+UqKMfn+ZxgOkBcXidBWUGJDugU7gCEV+rGS6wscZjJw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 24 Jan 2022 13:12:53 +0100
Message-ID: <87mtjl5o3e.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Jan 21, 2022 at 6:20 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
>>
>> On Fri, Jan 21, 2022 at 05:13:28PM -0800, Alexei Starovoitov wrote:
>> > On Fri, Jan 21, 2022 at 4:57 PM Colin Foster
>> > <colin.foster@in-advantage.com> wrote:
>> > >
>> > > Check for the existence of page pool params before dereferencing. This can
>> > > cause crashes in certain conditions.
>> >
>> > In what conditions?
>> > Out of tree driver?
>>
>> Hi Alexei,
>>
>> Thanks for the quick response.
>>
>> I'm actively working on a DSA driver that is currently out-of-tree, but
>> trying to get it into mainline. But I'm not convinced that's the
>> problem...
>>
>> I'm using a beagelebone black with the cpsw_new driver. There are two
>> tweaks to that driver: the default vlan port is 10 and 11 so there's no
>> conflict between cpsw_new and DSA, and the ndev->max_mtu / rx_packet_max
>> have been increased to 1600 to allow for DSA frames larger than the
>> standard MTU of 1500.
>>
>> My focus is on the DSA driver, but the crash happens as soon as I run
>> "ip link set eth0 up" which is invoking the cpsw_new driver. Therefore I
>> suspect that the issue is not directly related to the DSA section
>> (ocelot / felix, much of which uses code that is mainline)
>>
>> As I suggested, I haven't dug into what is going on around the
>> page_pool yet. If there is something that is pre-loading memory at 1500
>> byte intervals and I broke that, that's entirely on me.
>>
>> [ removes 1600 byte MTU patch and pool patch ]
>>
>> I can confirm it still crashes when I don't modify the MTU in the
>> cpsw_new driver... so that doesn't seem to be it. That crash log is
>> below.
>>
>>
>> # ip link set eth0 up
>> [   18.074704] cpsw-switch 4a100000.switch: starting ndev. mode: dual_mac
>> [   18.174286] SMSC LAN8710/LAN8720 4a101000.mdio:00: attached PHY driver (mii_bus:phy_addr=4a101000.mdio:00, irq=POLL)
>> [   18.185458] 8<--- cut here ---
>> [   18.188554] Unable to handle kernel paging request at virtual address c3104440
>> [   18.195819] [c3104440] *pgd=8300041e(bad)
>> [   18.199885] Internal error: Oops: 8000000d [#1] SMP ARM
>> [   18.205148] Modules linked in:
>> [   18.208233] CPU: 0 PID: 168 Comm: ip Not tainted 5.16.0-05302-g8bd405e6e8a0-dirty #265
>> [   18.216201] Hardware name: Generic AM33XX (Flattened Device Tree)
>> [   18.222328] PC is at 0xc3104440
>> [   18.225500] LR is at __page_pool_alloc_pages_slow+0xbc/0x2e0
>> [   18.231222] pc : [<c3104440>]    lr : [<c0ee06c8>]    psr: a00b0013
>> [   18.237523] sp : c3104440  ip : 00000020  fp : c219e580
>> [   18.242778] r10: c1a04d54  r9 : 00000000  r8 : 00000000
>> [   18.248032] r7 : c36b9000  r6 : 00000000  r5 : c36b9084  r4 : 00000000
>> [   18.254595] r3 : c07a399c  r2 : 00000000  r1 : c325784c  r0 : dfa48bc0
>> [   18.261162] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>> [   18.268343] Control: 10c5387d  Table: 836f0019  DAC: 00000051
>> [   18.274119] Register r0 information: non-slab/vmalloc memory
>> [   18.279825] Register r1 information: non-slab/vmalloc memory
>> [   18.285523] Register r2 information: NULL pointer
>> [   18.290260] Register r3 information: non-slab/vmalloc memory
>> [   18.295957] Register r4 information: NULL pointer
>> [   18.300693] Register r5 information: slab kmalloc-1k start c36b9000 pointer offset 132 size 1024
>> [   18.309569] Register r6 information: NULL pointer
>> [   18.314306] Register r7 information: slab kmalloc-1k start c36b9000 pointer offset 0 size 1024
>> [   18.322999] Register r8 information: NULL pointer
>> [   18.327736] Register r9 information: NULL pointer
>> [   18.332473] Register r10 information: non-slab/vmalloc memory
>> [   18.338257] Register r11 information: slab kmalloc-4k start c219e000 pointer offset 1408 size 4096
>> [   18.347301] Register r12 information: non-paged memory
>> [   18.352475] Process ip (pid: 168, stack limit = 0x7eb0d4ab)
>> [   18.358089] Stack: (0xc3104440 to 0xc3258000)
>> (too big a stack to show)
>>
>>
>> I can confirm that it crashes on net-next/master as well:
>> commit fe8152b38d3a, using the same DTB that defines the cpsw_new port
>> as the DSA master. Relevant DTS snippet from my in-development driver:
>>
>> +&spi0 {
>> +       #address-cells = <1>;
>> +       #size-cells = <0>;
>> +       status = "okay";
>> +
>> +       ocelot-chip@0 {
>> +               compatible = "mscc,vsc7512_mfd_spi";
>> +               spi-max-frequency = <2500000>;
>> +               reg = <0>;
>> +
>> +               ethernet-switch@0 {
>> +                       compatible = "mscc,vsc7512-ext-switch";
>> +                       ports {
>> +                               #address-cells = <1>;
>> +                               #size-cells = <0>;
>> +
>> +                               port@0 {
>> +                                       reg = <0>;
>> +                                       label = "cpu";
>> +                                       status = "okay";
>> +                                       ethernet = <&mac_sw>;
>> +                                       phy-handle = <&sw_phy0>;
>> +                                       phy-mode = "internal";
>> +                               };
>>
>>
>> I was hoping for an "oh, if a switch is set up in DSA the page_pool gets
>> set up this way" type scenario. I fully understand that might not be the
>> case, and the issue could be in something I'm doing incorrectly - it
>> certainly wouldn't be the first time.
>>
>> If this patch doesn't make sense I can look deeper. As mentioned, I'm
>> working to get this accepted upstream, so I'll have to figure it out one
>> way or another.
>
> With !pool tweak the patch makes sense.
>
> Toke, wdyt?

I don't really see how page_pool_set_pp_info() can be called with a NULL
'pool' pointer. There are only two callers:
__page_pool_alloc_page_order() and __page_pool_alloc_pages_slow(). And
both functions deref the pool pointer right before calling
page_pool_set_pp_info(), so I don't really see how this patch would
actually be a proper fix?

Looking a bit closer, actually the fault seems like it lies with the
driver; Colin, could you please check if the patch below fixes your
issue?

I'll go check all the other drivers as well and send a fix for all that
are affected...

-Toke


diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 3537502e5e8b..648c78ecf2a5 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1146,7 +1146,7 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv)
 static struct page_pool *cpsw_create_page_pool(struct cpsw_common *cpsw,
                                               int size)
 {
-       struct page_pool_params pp_params;
+       struct page_pool_params pp_params = {};
        struct page_pool *pool;
 
        pp_params.order = 0;

