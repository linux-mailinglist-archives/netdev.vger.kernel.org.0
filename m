Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADCA3C9DB7
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 13:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240758AbhGOL3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 07:29:50 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7018 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239113AbhGOL3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 07:29:50 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GQX4R3FPTzXsLb;
        Thu, 15 Jul 2021 19:21:11 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Jul 2021 19:26:40 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 15 Jul
 2021 19:26:39 +0800
Subject: Re: [Patch net-next resend v2] net_sched: use %px to print skb
 address in trace_qdisc_dequeue()
To:     Cong Wang <xiyou.wangcong@gmail.com>, <netdev@vger.kernel.org>
CC:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
References: <20210715060021.43249-1-xiyou.wangcong@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <536718b6-0735-cc03-6268-c6a130b55ba7@huawei.com>
Date:   Thu, 15 Jul 2021 19:26:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210715060021.43249-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/15 14:00, Cong Wang wrote:
> From: Qitao Xu <qitao.xu@bytedance.com>
> 
> Print format of skbaddr is changed to %px from %p, because we want
> to use skb address as a quick way to identify a packet.
> 
> Note, trace ring buffer is only accessible to privileged users,
> it is safe to use a real kernel address here.

Does it make more sense to use %pK?

see: https://lwn.net/Articles/420403/

> 
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
> ---
>  include/trace/events/qdisc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
> index 330d32d84485..58209557cb3a 100644
> --- a/include/trace/events/qdisc.h
> +++ b/include/trace/events/qdisc.h
> @@ -41,7 +41,7 @@ TRACE_EVENT(qdisc_dequeue,
>  		__entry->txq_state	= txq->state;
>  	),
>  
> -	TP_printk("dequeue ifindex=%d qdisc handle=0x%X parent=0x%X txq_state=0x%lX packets=%d skbaddr=%p",
> +	TP_printk("dequeue ifindex=%d qdisc handle=0x%X parent=0x%X txq_state=0x%lX packets=%d skbaddr=%px",
>  		  __entry->ifindex, __entry->handle, __entry->parent,
>  		  __entry->txq_state, __entry->packets, __entry->skbaddr )
>  );
> 
