Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A063B26FA
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 07:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhFXFtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 01:49:09 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:60775 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229448AbhFXFtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 01:49:08 -0400
X-UUID: 027d604e39da4368812a6d71af8a717e-20210624
X-UUID: 027d604e39da4368812a6d71af8a717e-20210624
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1321433158; Thu, 24 Jun 2021 13:46:46 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 24 Jun 2021 13:46:45 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Jun 2021 13:46:44 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     David Ahern <dsahern@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <bpf@vger.kernel.org>,
        <wsd_upstream@mediatek.com>, <chao.song@mediatek.com>,
        <kuohong.wang@mediatek.com>, Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH 1/4] net: if_arp: add ARPHRD_PUREIP type
Date:   Thu, 24 Jun 2021 13:31:59 +0800
Message-ID: <20210624053159.22345-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <020403ac-0c2a-4ad8-236b-d32e59aef772@gmail.com>
References: <020403ac-0c2a-4ad8-236b-d32e59aef772@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-06-23 at 23:15 -0600, David Ahern wrote:
On 6/23/21 9:33 PM, Rocco Yue wrote:
>> 
>> The difference between RAWIP and PUREIP is that they generate IPv6
>> link-local address and IPv6 global address in different ways.
>> 
>> RAWIP:
>> ~~~~~~
>> In the ipv6_generate_eui64() function, using RAWIP will always return 0,
>> which will cause the kernel to automatically generate an IPv6 link-local
>> address in EUI64 format and an IPv6 global address in EUI64 format.
>> 
>> PUREIP:
>> ~~~~~~~
>> After this patch set, when using PUREIP, kernel doesn't generate IPv6
>> link-local address regardless of which IN6_ADDR_GEN_MODE is used.
>> 
>> @@  static void addrconf_dev_config(struct net_device *dev)
>> +       if (dev->type == ARPHRD_PUREIP)
>> +               return;
>> 
>> And after recving RA message, kernel iterates over the link-local address
>> that exists for the interface and uses the low 64bits of the link-local
>> address to generate the IPv6 global address.
>> The general process is as follows:
>> ndisc_router_discovery() -> addrconf_prefix_rcv() ->
>> ipv6_generate_eui64() -> ipv6_inherit_eui64()
>> 
> 
> please add that to the commit message.

Thanks for your reminding, will do.

Thanks,
Rocco

