Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CC83E2112
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 03:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240621AbhHFBh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 21:37:29 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13283 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239868AbhHFBh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 21:37:28 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Ggnyp1xslz83FG;
        Fri,  6 Aug 2021 09:32:18 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 09:37:10 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 6 Aug 2021
 09:37:10 +0800
Subject: Re: [PATCH net-next 4/4] net: hns3: support skb's frag page recycling
 based on page pool
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <alexander.duyck@gmail.com>,
        <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <linuxarm@openeuler.org>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <thomas.petazzoni@bootlin.com>,
        <hawk@kernel.org>, <ilias.apalodimas@linaro.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <will@kernel.org>, <willy@infradead.org>, <vbabka@suse.cz>,
        <fenghua.yu@intel.com>, <guro@fb.com>, <peterx@redhat.com>,
        <feng.tang@intel.com>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <hughd@google.com>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <wenxu@ucloud.cn>, <cong.wang@bytedance.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <chenhao288@hisilicon.com>
References: <1628161526-29076-1-git-send-email-linyunsheng@huawei.com>
 <1628161526-29076-5-git-send-email-linyunsheng@huawei.com>
 <20210805182006.66133c8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <72f6a642-2efc-b2fd-7d4e-f099b63c0703@huawei.com>
Date:   Fri, 6 Aug 2021 09:37:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210805182006.66133c8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/8/6 9:20, Jakub Kicinski wrote:
> On Thu, 5 Aug 2021 19:05:26 +0800 Yunsheng Lin wrote:
>> This patch adds skb's frag page recycling support based on
>> the frag page support in page pool.
>>
>> The performance improves above 10~20% for single thread iperf
>> TCP flow with IOMMU disabled when iperf server and irq/NAPI
>> have a different CPU.
>>
>> The performance improves about 135%(14Gbit to 33Gbit) for single
>> thread iperf TCP flow IOMMU is in strict mode and iperf server
>> shares the same cpu with irq/NAPI.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
> This patch does not apply cleanly to net-next, please rebase 
> if you're targeting that tree.

It seems I forgot to rebase the net-next tree before doing
"git format-patch", thanks for mentioning that.

> .
> 
