Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8163DE87C
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 11:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfJUJuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 05:50:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45774 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfJUJuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 05:50:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9L9nLSo194538;
        Mon, 21 Oct 2019 09:50:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rsUd3DzB9xT/W7zLo5aVLsPVRAKbb0M7zYLFyN9ZA3M=;
 b=ECAw3huDS90YFA1/3eV5qfsj1fxNoFlQ8JRTDPMnWTSYGjnfyUoaGAAOcOS6po11+FJM
 L0lBdVda3nY4SaR1e66aEuXMwA49Mu4b2Sry26Gs9KNCQ5k6itX3nPSAjyIriJxSIEwo
 lgEWQrCW6L8UiyIZ8GUemq4Fwy3CXUmPy2FL5yfYNfbutK9CRwB13RCNzdy75d4hjPcC
 5Sa/JxzlHSRxRUhDcsqGKedC+T/R/pzP+erJicOZ5MHZ+IJN/l5BzGbGZrvaZUUkJRF7
 clTaHe3en7rH/8pQ+GXoGoJgdC1DXvgDV6LBVtJarJds54sDM2Hzim8rBFKlrbF9pq5+ 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vqtepehj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 09:50:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9L9nBWw177986;
        Mon, 21 Oct 2019 09:49:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vrbxsuwwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 09:49:59 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9L9nwlf005259;
        Mon, 21 Oct 2019 09:49:58 GMT
Received: from [10.182.71.192] (/10.182.71.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 02:49:57 -0700
Subject: Re: [PATCH] net: forcedeth: add xmit_more support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     rain.1986.08.12@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
References: <1571392885-32706-1-git-send-email-yanjun.zhu@oracle.com>
 <20191018154844.34a27c64@cakuba.netronome.com>
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <84839e5f-4543-bbd9-37db-e1777a84992c@oracle.com>
Date:   Mon, 21 Oct 2019 17:56:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191018154844.34a27c64@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9416 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=892
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910210094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9416 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=975 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910210094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/19 6:48, Jakub Kicinski wrote:
> On Fri, 18 Oct 2019 06:01:25 -0400, Zhu Yanjun wrote:
>> This change adds support for xmit_more based on the igb commit 6f19e12f6230
>> ("igb: flush when in xmit_more mode and under descriptor pressure") and
>> commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data") that
>> were made to igb to support this feature. The function netif_xmit_stopped
>> is called to check if transmit queue on device is currently unable to send
>> to determine if we must write the tail because we can add no further
>> buffers.
>> When normal packets and/or xmit_more packets fill up tx_desc, it is
>> necessary to trigger NIC tx reg.
> Looks broken. You gotta make sure you check the kick on _every_ return
> path. There are 4 return statements in each function, you only touched
> 2.

In nv_start_xmit,

2240         if (unlikely(empty_slots <= entries)) {
2241                 netif_stop_queue(dev);
2242                 np->tx_stop = 1;
2243                 spin_unlock_irqrestore(&np->lock, flags);
2244
2245                 /* When normal packets and/or xmit_more packets fill up
2246                  * tx_desc, it is necessary to trigger NIC tx reg.
2247                  */
2248                 ret = NETDEV_TX_BUSY;
2249                 goto TXKICK;
2250         }
The above indicates tx_desc is full, it is necessary to trigger NIC HW xmit.

2261                 if (unlikely(dma_mapping_error(&np->pci_dev->dev,
2262 np->put_tx_ctx->dma))) {
2263                         /* on DMA mapping error - drop the packet */
2264                         dev_kfree_skb_any(skb);
2265 u64_stats_update_begin(&np->swstats_tx_syncp);
2266                         nv_txrx_stats_inc(stat_tx_dropped);
2267 u64_stats_update_end(&np->swstats_tx_syncp);
2268                         return NETDEV_TX_OK;
2269                 }

and

2300                         if 
(unlikely(dma_mapping_error(&np->pci_dev->dev,
2301 np->put_tx_ctx->dma))) {
2302
2303                                 /* Unwind the mapped fragments */
2304                                 do {
2305                                         nv_unmap_txskb(np, 
start_tx_ctx);
2306                                         if (unlikely(tmp_tx_ctx++ 
== np->last_tx_ctx))
2307                                                 tmp_tx_ctx = 
np->tx_skb;
2308                                 } while (tmp_tx_ctx != np->put_tx_ctx);
2309                                 dev_kfree_skb_any(skb);
2310                                 np->put_tx_ctx = start_tx_ctx;
2311 u64_stats_update_begin(&np->swstats_tx_syncp);
2312 nv_txrx_stats_inc(stat_tx_dropped);
2313 u64_stats_update_end(&np->swstats_tx_syncp);
2314                                 return NETDEV_TX_OK;
2315                         }

The above are dma_mapping_error. It seems that triggering NIC HW xmit is 
not needed.

So when "tx_desc full" error, HW NIC xmit is triggerred. When 
dma_mapping_error,

NIC HW xmit is not triggerred.

That is why only 2 "return" are touched.

>
> Also the labels should be lower case.

This patch passes checkpatch.pl. It seems that "not lower case" is not a 
problem?

If you think it is a problem, please show me where it is defined.

Zhu Yanjun

>
