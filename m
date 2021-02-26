Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C35325B5B
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 02:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhBZBkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 20:40:05 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13379 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhBZBkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 20:40:03 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DmsjL0d3Dz7qSf;
        Fri, 26 Feb 2021 09:37:42 +0800 (CST)
Received: from [10.174.177.244] (10.174.177.244) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Feb 2021 09:39:16 +0800
Subject: Re: [PATCH] net: bridge: Fix jump_label config
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210224153803.91194-1-wangkefeng.wang@huawei.com>
 <CAM_iQpV0NCoJF-qS1KPB+VE3FSMfGBH_SL-OxhMO-k0pGUEhwA@mail.gmail.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <1cf51ae7-3bce-3b9f-f6aa-c20499eedf7a@huawei.com>
Date:   Fri, 26 Feb 2021 09:39:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpV0NCoJF-qS1KPB+VE3FSMfGBH_SL-OxhMO-k0pGUEhwA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.177.244]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/26 5:22, Cong Wang wrote:
> On Wed, Feb 24, 2021 at 8:03 AM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>> HAVE_JUMP_LABLE is removed by commit e9666d10a567 ("jump_label: move
>> 'asm goto' support test to Kconfig"), use CONFIG_JUMP_LABLE instead
>> of HAVE_JUMP_LABLE.
>>
>> Fixes: 971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge input path")
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Hmm, why do we have to use a macro here? static_key_false() is defined
> in both cases, CONFIG_JUMP_LABEL=y or CONFIG_JUMP_LABEL=n.

It seems that all nf_hooks_needed related are using the macro,

see net/netfilter/core.c and include/linux/netfilter.h,

   #ifdef CONFIG_JUMP_LABEL
   struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
EXPORT_SYMBOL(nf_hooks_needed);
#endif

   nf_static_key_inc()/nf_static_key_dec()


>
> Thanks.
>
