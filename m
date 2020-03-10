Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFF65180588
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgCJRxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:53:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42538 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgCJRxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:53:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02AHqRnG095113;
        Tue, 10 Mar 2020 17:53:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qT1ECbPEhETHAAouiX0phMVMFqQ41hr92DHNcuh9QlY=;
 b=DMlL9bXK5QNvJuQyurGwVCxQwS1F3WfINTNq3lcuPQ6AQCp2twEWTmRn8p8s1l4hTjfF
 8NN5jbCcpbZwPsVqeROKZ6PfywfcN/Ybj90wHebZ0a4vKGnxxc6RJdcguNHt82QYkQW6
 tae9pM6tUA7M18vs5W4wXw2SHzN9au8Jmiwqa3fgsD2KTMHkACCtD9VajhmFx+caSbv5
 2+dONbL7xUr01gsiOeVvlJtmVgViRgVYUL9OC3LUjyvAnQp5Ds2Ks9+l5XzlLbLDbDWW
 gpsa30khpykbQeqMZwC6nZ+7PmIQ9TAwq2XP4hHFSwp1JXyApbOZwNF9FGp/4mi7ip+G rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yp9v6273v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 17:53:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02AHqH7o139423;
        Tue, 10 Mar 2020 17:53:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2yp8psvvgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 17:53:39 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02AHrdAh013898;
        Tue, 10 Mar 2020 17:53:39 GMT
Received: from [10.209.227.41] (/10.209.227.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 10:53:39 -0700
Subject: Re: Maybe a race condition in net/rds/rdma.c?
To:     zerons <sironhide0null@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        haakon.bugge@oracle.com
References: <afd9225d-5c43-8cc7-0eed-455837b53e10@gmail.com>
 <D8EB4A77-77D7-41EB-9021-EA7BB8C3FA5B@oracle.com>
 <94b20d30-1d7d-7a66-b943-d75a05bcb46e@oracle.com>
 <e525ec74-b62f-6e7c-e6bc-aad93d349f65@gmail.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <54d1140d-3347-a2b1-1b20-9a3959d3b451@oracle.com>
Date:   Tue, 10 Mar 2020 10:53:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e525ec74-b62f-6e7c-e6bc-aad93d349f65@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003100108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/6/20 4:11 AM, zerons wrote:
> 
> 
> On 2/28/20 02:10, santosh.shilimkar@oracle.com wrote:
>>
>>>> On 18 Feb 2020, at 14:13, zerons <sironhide0null@gmail.com> wrote:
>>>>
>>>> Hi, all
>>>>
>>>> In net/rds/rdma.c
>>>> (https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/rds/rdma.c?h=v5.5.3*n419__;Iw!!GqivPVa7Brio!OwwQCLtjDsKmhaIz0sfaOVSuC4ai5t5_FgB7yqNExGOCBtACtIGLF61NNJyqSDtIAcGoPg$ ),
>>>> there may be a race condition between rds_rdma_unuse() and rds_free_mr().
>>>>
>> Hmmm.. I didn't see email before in my inbox. Please post questions/patches on netdev in future which is the correct mailing list.
>>
>>>> It seems that this one need some specific devices to run test,
>>>> unfortunately, I don't have any of these.
>>>> I've already sent two emails to the maintainer for help, no response yet,
>>>> (the email address may not be in use).
>>>>
>>>> 0) in rds_recv_incoming_exthdrs(), it calls rds_rdma_unuse() when receive an
>>>> extension header with force=0, if the victim mr does not have RDS_RDMA_USE_ONCE
>>>> flag set, then the mr would stay in the rbtree. Without any lock, it tries to
>>>> call mr->r_trans->sync_mr().
>>>>
MR won't stay in the rbtree with force flag. If the MR is used or
use_once is set in both cases its removed from the tree.
See "if (mr->r_use_once || force)"

>>>> 1) in rds_free_mr(), the same mr is found, and then freed. The mr->r_refcount
>>>> doesn't change while rds_mr_tree_walk().
>>>>
>>>> 0) back in rds_rdma_unuse(), the victim mr get used again, call
>>>> mr->r_trans->sync_mr().
>>>>
>>>> Could this race condition actually happen?
So from what I see, this race doesn't exist but let me know
if am missing something.

regards,
Santosh
