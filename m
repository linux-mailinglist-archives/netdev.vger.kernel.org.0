Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC6D3B8CBE
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 05:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhGAD5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 23:57:10 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:46842 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232930AbhGAD5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 23:57:09 -0400
X-UUID: 4476006f41c6483896e4d1fa29978755-20210701
X-UUID: 4476006f41c6483896e4d1fa29978755-20210701
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 442614381; Thu, 01 Jul 2021 11:54:35 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 1 Jul 2021 11:54:34 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 1 Jul 2021 11:54:33 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        <rocco.yue@gmail.com>, <chao.song@mediatek.com>,
        <kuohong.wang@mediatek.com>, <zhuoliang.zhang@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH] net: ipv6: don't generate link-local address in any addr_gen_mode
Date:   Thu, 1 Jul 2021 11:39:20 +0800
Message-ID: <20210701033920.5167-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <3c0e5c52-4204-ae1e-526a-5f3a5c9738c2@gmail.com>
References: <3c0e5c52-4204-ae1e-526a-5f3a5c9738c2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-06-30 at 21:03 -0600, David Ahern wrote:
On 6/30/21 7:59 PM, Rocco Yue wrote:
>> This patch provides an ipv6 proc file named
>> "disable_gen_linklocal_addr", its absolute path is as follows:
>> "/proc/sys/net/ipv6/conf/<iface>/disable_gen_linklocal_addr".
>> 
>> When the "disable_gen_linklocal_addr" value of a device is 1,
>> it means that this device does not need the Linux kernel to
>> automatically generate the ipv6 link-local address no matter
>> which IN6_ADDR_GEN_MODE is used.
>> 
> 
> doesn't this duplicate addr_gen_mode == 1 == IN6_ADDR_GEN_MODE_NONE?
> 

Hi David,

Thanks for your review.

This patch is different with IN6_ADDR_GEN_MODE_NONE.

When the addr_gen_mode == IN6_ADDR_GEN_MODE_NONE, the Linux kernel
doesn't automatically generate the ipv6 link-local address.

But when the addr_gen_mode == IN6_ADDR_GEN_MODE_STABLE_PRIVACY, the
Linux kernel will still automatically generate an ipv6 link-local
address.

Among global mobile operators, some operators have already request
MT (Mobile Terminal) to support RFC7217, such as AT&T. In this case,
addr_gen_mode will be set to IN6_ADDR_GEN_MODE_STABLE_PRIVACY to
support RFC7217. This means that the device not only needs the IID
assigned by the GGSN to build the ipv6 link-local address to trigger
the RS message, but also needs to use the stable privacy mode to build
the ipv6 global address after receiving the RA.

After this patch, when the "disable_gen_linklocal_addr" value of a device
is 1, no matter in which addr_gen_mode, the Linux kernel will not automatically
generate an ipv6 link-local for this device.

Thanks,
Rocco
