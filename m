Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE30386E12
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 02:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344799AbhERAJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 20:09:40 -0400
Received: from gateway23.websitewelcome.com ([192.185.50.107]:22612 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240964AbhERAJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 20:09:40 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id C3A55677B
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 19:08:21 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id inHZl2weSAEP6inHZlfD25; Mon, 17 May 2021 19:08:21 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WdyekvjUUs1pEaBFDAcSeN8/wgj+hgvCSZ8KDF9fgKQ=; b=QGiVLJIoIP2dNncV1y7/ndqv2q
        3Fii5GAlykxh5JZQtr4Udy9XhV8ub4XyCi6glN6VoyAEC0G/UTI+1eVgUIFf9ZBQkmEKSVpkrGBmj
        lzdo7z53e63NB73tFQKdt2KJEg9COOVrSQ3eUepQ20wzwM27VGX5NIeZWnqe2XnbENOHM5m8mawdo
        JfRhGi48eTh1ZniMzncDV/k5SzDnepe+vC9JZW8ya3z6/4XxrGdvbyd3C/P3kO8N5lsTQmg4uzzRC
        KRbI37HgNcaY0XLgkllH0p7bERfhdGiuP87d9opXrHoPvg6dveQKi9ItZPW6OIWQtw581ZuMEtSb6
        U6sTxWjw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:53398 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1linHW-002BXL-8X; Mon, 17 May 2021 19:08:18 -0500
Subject: Re: [PATCH RESEND][next] netxen_nic: Fix fall-through warnings for
 Clang
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210305094529.GA140903@embeddedor>
 <7b648909-c16d-4f52-7524-896b7e2fdb52@embeddedor.com>
Message-ID: <79286a03-5e7e-d019-2189-6811bd08c84b@embeddedor.com>
Date:   Mon, 17 May 2021 19:08:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <7b648909-c16d-4f52-7524-896b7e2fdb52@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1linHW-002BXL-8X
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:53398
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 20
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm taking this in my -next[1] branch for v5.14.

Thanks
--
Gustavo

[1] https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/log/?h=for-next/kspp

On 4/20/21 15:23, Gustavo A. R. Silva wrote:
> Hi all,
> 
> Friendly ping: who can take this, please?
> 
> Thanks
> --
> Gustavo
> 
> On 3/5/21 03:45, Gustavo A. R. Silva wrote:
>> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
>> by explicitly adding a goto statement instead of just letting the code
>> fall through to the next case.
>>
>> Link: https://github.com/KSPP/linux/issues/115
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>>  drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
>> index 08f9477d2ee8..35ec9aab3dc7 100644
>> --- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
>> +++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
>> @@ -1685,6 +1685,7 @@ netxen_process_rcv_ring(struct nx_host_sds_ring *sds_ring, int max)
>>  			break;
>>  		case NETXEN_NIC_RESPONSE_DESC:
>>  			netxen_handle_fw_message(desc_cnt, consumer, sds_ring);
>> +			goto skip;
>>  		default:
>>  			goto skip;
>>  		}
>>
