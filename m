Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E98048538A
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240329AbiAENZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:25:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236846AbiAENZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 08:25:50 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205B6fpb007978;
        Wed, 5 Jan 2022 13:25:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=G9b+9OF489U5MH//jS/S312fTKT1KDWwCDo6g7vxKEo=;
 b=Gd+DqsOZ0Ob3agnV+YqGGGa5vq9245wAkg3r8ZAw0anMrDo2NhQr28b5dOmJL4kqoc6Q
 ww9HPzDSFOLI8BDaXmInTno0/o0bNkOIAPaumYh6WXvEG8pMl75nSYKPnVWkyyvk6uH0
 fYcO7WgdRyOFS2T86Ipax8x21RtLEdJTXz/VuLQJ1HnDThfuprBi2jXt2qrHNr6dyNVx
 9nYv1oJyrqFsXX4auvHrgcEIh95MdDcbMyhRCJd2q2M4gxiMX51DGQXUdIEA9IYoPxqP
 IH3C78YcduqOMZURw3fv1w/pxo1nJFz5I9psZCuVH4CvzjBH4kFtfqJqnwaODMCUDDq/ 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dckxt1wum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 13:25:48 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 205DKfX0030902;
        Wed, 5 Jan 2022 13:25:47 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dckxt1wtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 13:25:47 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 205DNF9S010855;
        Wed, 5 Jan 2022 13:25:45 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3daeka8jbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 13:25:45 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 205DPgR937814774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Jan 2022 13:25:42 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77D384203F;
        Wed,  5 Jan 2022 13:25:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18E8742045;
        Wed,  5 Jan 2022 13:25:42 +0000 (GMT)
Received: from [9.145.181.244] (unknown [9.145.181.244])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Jan 2022 13:25:42 +0000 (GMT)
Message-ID: <6e2ae46c-5407-ca6a-3353-69e76f10d913@linux.ibm.com>
Date:   Wed, 5 Jan 2022 14:25:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net v3] net/smc: Reset conn->lgr when link group
 registration fails
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, dust.li@linux.alibaba.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641364133-61284-1-git-send-email-guwen@linux.alibaba.com>
 <20220105075408.GC31579@linux.alibaba.com>
 <23b607fe-95da-ea8a-8dda-900a51572b90@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <23b607fe-95da-ea8a-8dda-900a51572b90@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TF_de3s6NgVmhyoeC4dPJkURgvoxSiAn
X-Proofpoint-ORIG-GUID: UcQwaypFEWN-viMeWUHJaiJKpi3DSYVe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-05_03,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 mlxscore=0 bulkscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201050088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/01/2022 09:55, Wen Gu wrote:
> On 2022/1/5 3:54 pm, dust.li wrote:
> 
>>> -        if (rc)
>>> +        if (rc) {
>>> +            spin_lock_bh(lgr_lock);
>>> +            if (!list_empty(&lgr->list))
>>> +                list_del_init(&lgr->list);
>>> +            spin_unlock_bh(lgr_lock);
>>> +            __smc_lgr_terminate(lgr, true);
>>
>> What about adding a smc_lgr_terminate() wrapper and put list_del_init()
>> and __smc_lgr_terminate() into it ?
> 
> Adding a new wrapper is a good idea. But I think the logic here is relatively simple.
> So instead of wrapping them, I coded them like what smc_lgr_cleanup_early() does.

It might look cleaner with the following changes:
- adopt smc_lgr_cleanup_early() to take only an lgr as parameter and remove the call to smc_conn_free()
- change smc_conn_abort() (which is the only caller of smc_lgr_cleanup_early() right now), always
  call smc_conn_free() and if (local_first) additionally call smc_lgr_cleanup_early() 
  (hold a local copy of the lgr for this call)
- finally call smc_lgr_cleanup_early(lgr) from smc_conn_create()

This should be the same processing, but the smc_conn_free() is moved to smc_conn_abort() where
it looks to be a better place for this call. And smc_lgr_cleanup_early() takes only care of an lgr.

What do you think? Did I miss something?
