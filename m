Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53935172631
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 19:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgB0SK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 13:10:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41956 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729281AbgB0SK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 13:10:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RHrhVM154358;
        Thu, 27 Feb 2020 18:10:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0FrS3v3k8vbIeLvn+8otv9P7Ef3vUqdbxGkRnElK4ao=;
 b=eqRBD6Od/VbG8UXwq1qRGzwKnhuBBOh6kmZZi0WB9HY/WrPxD2IH015f9fVlrx0SVwiX
 Djr2NHa2we1SAPr35ecWN976QTGZR4wYLMWTVzJ02M/Ks/YboKN7Wd0SCI9IoW5zleLs
 yP/zby5auhBa6g6uWlLikLBn7h/3bCxOlOaUkvw0HB/OKTjaumiMQv5rqN9hh7Pl3hsy
 dgGNGi7C+MmRUJ22uLBj1eTvwfwqFgUH6CHOC/rVSOxP1ecxAjjjV/1Utm9RibmRk0IO
 5QydNneHoK5mzJOAnZJmb2ZcILz+PYP48jiJVZc4DGs4VCoSnJn5AGcB6EqiBnUGJ9Cf 8A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ydcsnmtgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 18:10:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RHupRE132146;
        Thu, 27 Feb 2020 18:10:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ydcsd1p70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 18:10:54 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01RIAsdW011618;
        Thu, 27 Feb 2020 18:10:54 GMT
Received: from [10.159.143.63] (/10.159.143.63)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 10:10:54 -0800
Subject: Re: Maybe a race condition in net/rds/rdma.c?
To:     zerons <sironhide0null@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>
References: <afd9225d-5c43-8cc7-0eed-455837b53e10@gmail.com>
 <D8EB4A77-77D7-41EB-9021-EA7BB8C3FA5B@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <94b20d30-1d7d-7a66-b943-d75a05bcb46e@oracle.com>
Date:   Thu, 27 Feb 2020 10:10:53 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <D8EB4A77-77D7-41EB-9021-EA7BB8C3FA5B@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1011 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> On 18 Feb 2020, at 14:13, zerons <sironhide0null@gmail.com> wrote:
>>
>> Hi, all
>>
>> In net/rds/rdma.c
>> (https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/rds/rdma.c?h=v5.5.3*n419__;Iw!!GqivPVa7Brio!OwwQCLtjDsKmhaIz0sfaOVSuC4ai5t5_FgB7yqNExGOCBtACtIGLF61NNJyqSDtIAcGoPg$ ),
>> there may be a race condition between rds_rdma_unuse() and rds_free_mr().
>>
Hmmm.. I didn't see email before in my inbox. Please post 
questions/patches on netdev in future which is the correct mailing list.

>> It seems that this one need some specific devices to run test,
>> unfortunately, I don't have any of these.
>> I've already sent two emails to the maintainer for help, no response yet,
>> (the email address may not be in use).
>>
>> 0) in rds_recv_incoming_exthdrs(), it calls rds_rdma_unuse() when receive an
>> extension header with force=0, if the victim mr does not have RDS_RDMA_USE_ONCE
>> flag set, then the mr would stay in the rbtree. Without any lock, it tries to
>> call mr->r_trans->sync_mr().
>>
>> 1) in rds_free_mr(), the same mr is found, and then freed. The mr->r_refcount
>> doesn't change while rds_mr_tree_walk().
>>
>> 0) back in rds_rdma_unuse(), the victim mr get used again, call
>> mr->r_trans->sync_mr().
>>
>> Could this race condition actually happen?
>>
force=0 is an interesting scenario. Let me think about it and get back.
Thanks for report.

Regards,
Santosh
