Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED14E4B8574
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 11:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbiBPKXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 05:23:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiBPKXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 05:23:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BDF1D21D7;
        Wed, 16 Feb 2022 02:23:20 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21G9GNIp000375;
        Wed, 16 Feb 2022 10:23:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9YfNhOKtNKiisXc5EMUwUYdhPrpKikZZOm741Dx/Zq8=;
 b=bvkKd18IVXatgY+g23wtkdcFWT3Qfj2wNtj7lPeOMKXR0BiI+QMhf7gHM76g1JyKVquM
 jUFiszfzC2ML2ELza5HnwrufPii7eK2j4GuXo7mCfNubcSS9izxJSAo9lKq5HkU90XhB
 O9okGJrdH73qGZUR0mvUuUEio6rNvtVjtjdungUvgnLyhEv7mtS9+gCDk2lAtJ25bLaL
 y3ej/53TGTpoKVWSoKHRwMXPfiVkzm1/jfI4YfWSBRXAxi81HiQZ7nw5zeM6exAiXPHR
 TCUMlVPcDtLDSIU3jyIYI7aJjuKgBAiVD0vh+jOp+FCOZPexpV6T1YKjNBSUB5Zn7REY Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e8xg9hd7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 10:23:16 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21GAELAx028563;
        Wed, 16 Feb 2022 10:23:16 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e8xg9hd73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 10:23:16 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21GADr1G013665;
        Wed, 16 Feb 2022 10:23:14 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3e64ha5gc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 10:23:14 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21GANBa147644998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 10:23:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6EE55204F;
        Wed, 16 Feb 2022 10:23:11 +0000 (GMT)
Received: from [9.145.68.35] (unknown [9.145.68.35])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 789B952050;
        Wed, 16 Feb 2022 10:23:11 +0000 (GMT)
Message-ID: <27b00eba-40a5-19e8-5af6-64d0d8f034fd@linux.ibm.com>
Date:   Wed, 16 Feb 2022 11:23:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] net/smc: return ETIMEDOUT when smc_connect_clc()
 timeout
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1644913490-21594-1-git-send-email-alibuda@linux.alibaba.com>
 <c85310ed-fd9c-fa8c-88d2-862b5d99dbbe@linux.ibm.com>
 <20220216031307.GA2243@e02h04389.eu6sqa>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220216031307.GA2243@e02h04389.eu6sqa>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IsVXHs7RJ5R0QEAqcdYXnTxI_cE0DgIL
X-Proofpoint-GUID: zxdqKQ27A_mHsapGvvFA9FnthRgA4OtH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_04,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 suspectscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/02/2022 04:13, D. Wythe wrote:
> On Tue, Feb 15, 2022 at 02:02:37PM +0100, Karsten Graul wrote:
>> On 15/02/2022 09:24, D. Wythe wrote:
>>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>>
>>> When smc_connect_clc() times out, it will return -EAGAIN(tcp_recvmsg
>>> retuns -EAGAIN while timeout), then this value will passed to the
>>> application, which is quite confusing to the applications, makes
>>> inconsistency with TCP.
>>>
>>> From the manual of connect, ETIMEDOUT is more suitable, and this patch
>>> try convert EAGAIN to ETIMEDOUT in that case.
>>
>> You say that the sock_recvmsg() in smc_clc_wait_msg() returns -EAGAIN?
>> Is there a reason why you translate it in __smc_connect() and not already in
>> smc_clc_wait_msg() after the call to sock_recvmsg()?
> 
> 
> Because other code that uses smc_clc_wait_msg() handles EAGAIN allready, 
> and the only exception is smc_listen_work(), but it doesn't really matter for it. 
> 
> The most important thing is that this conversion needs to be determined according to 
> the calling scene, convert in smc_clc_wait_msg() is not very suitable.

Okay I understand, thank you.

Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>
