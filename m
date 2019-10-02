Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53427C46EC
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 07:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfJBFUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 01:20:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59048 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfJBFUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 01:20:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x925IT8d041940;
        Wed, 2 Oct 2019 05:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=6u9vSbVHAHG4ySAdsyMKURtODpAw0cz0ZW5EGW53z1Q=;
 b=kImxtGpRVFy0YmGTM7xiMn5Lm9yiOseME8lBHoJ6ZBnTvWl7Z9X3YJXf8cn1ifik8wBk
 YMlJZr5QnzTpPqNMLqGJAHCOJOKeywBRKY7oKhc7/fuoJ6Zbe1wSH4RehcBmNTN4t+gi
 heya3do4Q3bWOtqn9c4WAFAGhNnQ8oLjUxbN5GI9DMGrwSJbaTERDdERdekblCeHn3wq
 I8K/Zhcc93qm3gu9uoFOkVCMch4ZVmH7aKGLYgpEg/2PhFX/Wo9HizuB5N/y8TtdiBR5
 jhUv/tWMxFsTV34agwjRNJEsAOqnGAkXaPwUzYA1viOkxS0JilCt0D5DIB7y1kN7mWkW Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2va05rtmtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 05:20:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x925Ia8t192415;
        Wed, 2 Oct 2019 05:20:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2vckynbyk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Oct 2019 05:20:32 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x925KWn7001766;
        Wed, 2 Oct 2019 05:20:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vckynbyj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 05:20:32 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x925KUi3008940;
        Wed, 2 Oct 2019 05:20:30 GMT
Received: from [10.159.211.29] (/10.159.211.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 22:20:30 -0700
Subject: Re: [PATCH net-next] net/rds: Use DMA memory pool allocation for
 rds_header
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        rds-devel@oss.oracle.com
References: <1569834480-25584-1-git-send-email-ka-cheong.poon@oracle.com>
 <20191001.101615.1260420946739435364.davem@davemloft.net>
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Organization: Oracle Corporation
Message-ID: <7a388623-b2c5-2ade-69af-2e295784afca@oracle.com>
Date:   Wed, 2 Oct 2019 13:20:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191001.101615.1260420946739435364.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910020049
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/19 1:16 AM, David Miller wrote:
> From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> Date: Mon, 30 Sep 2019 02:08:00 -0700
> 
>> Currently, RDS calls ib_dma_alloc_coherent() to allocate a large piece
>> of contiguous DMA coherent memory to store struct rds_header for
>> sending/receiving packets.  The memory allocated is then partitioned
>> into struct rds_header.  This is not necessary and can be costly at
>> times when memory is fragmented.  Instead, RDS should use the DMA
>> memory pool interface to handle this.
>>
>> Suggested-by: Håkon Bugge <haakon.bugge@oracle.com>
>> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> 
> This is trading a one-time overhead for extra levels of dereferencing
> on every single descriptor access in the fast paths.
> 
> I do not agree with this tradeoff, please implement this more
> reasonably.


The problem with the existing way of pre-allocation is
that when there are a lot of RDS connections, the call to
ib_dma_alloc_coherent() can fail because there are not
enough contiguous memory pages available.  It is causing
problems in production systems.

And the i_{recv|send|_hdrs_dma array dereferencing is done
at send/receive ring initialization and refill.  It is not
done at every access of the header.

Thanks.


-- 
K. Poon
ka-cheong.poon@oracle.com


