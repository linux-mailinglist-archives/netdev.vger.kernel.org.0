Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C00F56B2D9
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 02:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388896AbfGQA2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 20:28:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58744 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbfGQA2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 20:28:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H0NiWY196560;
        Wed, 17 Jul 2019 00:28:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=SH6xFydPiOlDrNFecu0GRYBK3AJPKcjSiexftCfSU44=;
 b=RIDIdAADbpSU+7t1yHapFSofc27iZURq2IDf3ptSNZ/fHBLYsqcfEl3szyehY/ulfddQ
 shVsmwn97lq1KDlfzYAzTJBPDVGe1cVHYvcHFfQ1I60EiaMKjI1DhCglqxDbEHy/yE4C
 Y1l1gMoNJHTaH89SQ9QvTlYxgmGhOoAMJrLBngCbEZxGA+ju+LPsnMqxqpc0jGQxsgkX
 wrm8zjfVIo/Ju0HaA0lbGn+1k9VhnaSQZpND6Kt6KvM5NkxoiFKILESTtWk+Ns/nAltM
 0z7G4dfyAkH3MFW2npn7KLPa3Y+Q/qJ1L2OoMFCzRBbkrC0Pqz6LDqoY1MxOoRwNGoOh NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2tq7xqye61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:28:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H0Mx70185774;
        Wed, 17 Jul 2019 00:28:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2tq4du7dw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 17 Jul 2019 00:28:02 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6H0S10Q192410;
        Wed, 17 Jul 2019 00:28:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2tq4du7dvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:28:01 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6H0S1kO012236;
        Wed, 17 Jul 2019 00:28:01 GMT
Received: from [192.168.86.192] (/69.181.241.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Jul 2019 00:28:00 +0000
Subject: Re: [PATCH net v3 4/7] net/rds: Fix NULL/ERR_PTR inconsistency
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <0b9b1d80-0be7-a2ba-82da-cdceda467fc8@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <f6101167-b7f6-10a2-c970-671a9cc0fc58@oracle.com>
Date:   Tue, 16 Jul 2019 17:27:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0b9b1d80-0be7-a2ba-82da-cdceda467fc8@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907170003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/19 3:29 PM, Gerd Rausch wrote:
> Make function "rds_ib_try_reuse_ibmr" return NULL in case
> memory region could not be allocated, since callers
> simply check if the return value is not NULL.
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
