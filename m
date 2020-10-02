Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A621281CE0
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbgJBUX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:23:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34960 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgJBUX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:23:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092KDgD5031679;
        Fri, 2 Oct 2020 20:23:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=mGrqbNiIG2oSetxa9Ch2rvMCl7MD4N2YXqSt+SzFuAA=;
 b=UAgsgqU5w6jiR0pszezRNhmGDTfQs0EIlHW80khM2ZquDmUszWZQSzTnFKERXAHOSemj
 sPHcDlHQMrXLUzRYHwYs+FeL44v63YSyr+SiB0PolBy0FkLaVekZDpftEPzKYWG+IG26
 uydm3UHLJyPJE7DMciZJQhh8l+cOKF1hccRQQme5kWG2GGRmBH9bdcxH0D1EzD0Rf22h
 +pEvA9939+QofyUnj2pVfD420Z1VT2NrE0+rV08DDqJAJ3rwph4oQdv6G5sSQQvtVMJo
 DU9TI3jHF7EshsKlAcnTkXr3+y1m5k6AJ+cHgNQGs2FnrSRjgbR1zQny4ZC7fHcv+4GE vA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33swkmcsdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 20:23:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092KKi5Y150686;
        Fri, 2 Oct 2020 20:23:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33tfj3hkqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 20:23:24 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 092KNO7w015147;
        Fri, 2 Oct 2020 20:23:24 GMT
Received: from [10.159.145.96] (/10.159.145.96)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 13:23:23 -0700
Subject: Re: [PATCH 1/1] net/rds: suppress page allocation failure error in
 recv buffer refill
To:     santosh.shilimkar@oracle.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        aruna.ramakrishna@oracle.com, rama.nichanamatlu@oracle.com
References: <1601669145-13604-1-git-send-email-manjunath.b.patil@oracle.com>
 <733882f3-9bd5-8fe4-5d70-ec197455257e@oracle.com>
From:   Manjunath Patil <manjunath.b.patil@oracle.com>
Organization: Oracle Corporation
Message-ID: <60a5b017-7b59-b258-8305-760a152b8faa@oracle.com>
Date:   Fri, 2 Oct 2020 13:23:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <733882f3-9bd5-8fe4-5d70-ec197455257e@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for ack'ing.

Yeah, sorry about version. I had it in my mind to add it when I started, 
but forgot it at the last moment.

-Thanks,
Manjunath
On 10/2/2020 1:10 PM, santosh.shilimkar@oracle.com wrote:
> On 10/2/20 1:05 PM, Manjunath Patil wrote:
>> RDS/IB tries to refill the recv buffer in softirq context using
>> GFP_NOWAIT flag. However alloc failure is handled by queueing a work to
>> refill the recv buffer with GFP_KERNEL flag. This means failure to
>> allocate with GFP_NOWAIT isn't fatal. Do not print the PAF warnings if
>> softirq context fails to refill the recv buffer, instead print rate
>> limited warnings.
>>
>> Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
>> Reviewed-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
>> ---
> Thanks for the updated version. Whenever you send updated patch,
> you should add version so that it helps for archiving as well as
> review.
>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

