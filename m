Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9F04ADF0E
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352583AbiBHRNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234690AbiBHRNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:13:52 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1233EC06157A;
        Tue,  8 Feb 2022 09:13:52 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218GMR78015620;
        Tue, 8 Feb 2022 17:13:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TOLI4z2hux2zYaTEPqS24Y2d2xJyKH7dqt62eIBHOh8=;
 b=IH+h8SWELUOBtrv/Qv0aZBSdr4KFgoTNfYbJnPmAP4I3oskGSrWR1HQl4Ihg7ojxxWmM
 8TfVmnZD96V9HyaczYsTDF/lcAb21zCHS/UEg3ObKugLuT6wsAKf4SRlIKym+RueZvGW
 O2RaViiR3aLQOBtoWn9Oo9H4lQ19ac6G1ni/QB3yGJxwdZ9EOzKXYs/Bnjd0JR3Zgz89
 xHJLl7MnvhBUYwL7NRLXUPKEibfQZ6yrfwa2X3ryHmRTgxGTG5T89Qzad40Nt5hfERlO
 bpygmgE2FuSPq0b6xioDoAoyp1SVlp42jUu9bZwisHvk4BEj4PjVjeKJ+0Vb01DiCfmB zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e236fqh82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 17:13:48 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218FTiYp028379;
        Tue, 8 Feb 2022 17:13:47 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e236fqh7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 17:13:47 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218HCfg6013975;
        Tue, 8 Feb 2022 17:13:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3e1ggk054r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 17:13:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218HDhjH47644942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 17:13:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0A38A4055;
        Tue,  8 Feb 2022 17:13:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42BDCA405B;
        Tue,  8 Feb 2022 17:13:43 +0000 (GMT)
Received: from [9.145.157.102] (unknown [9.145.157.102])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 17:13:43 +0000 (GMT)
Message-ID: <c28365d5-72e3-335b-372e-2a9069898df1@linux.ibm.com>
Date:   Tue, 8 Feb 2022 18:13:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v5 2/5] net/smc: Limit backlog connections
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1644323503.git.alibuda@linux.alibaba.com>
 <c597e6c6d004e5b2a26a9535c8099d389214f273.1644323503.git.alibuda@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <c597e6c6d004e5b2a26a9535c8099d389214f273.1644323503.git.alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YNDUrGuSa5JxSFCuWNuE-QInp5Xc0CWi
X-Proofpoint-GUID: yOP3GfkbHlqwJ7nAkezh27x-yKMJyts6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 mlxscore=0 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202080103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/02/2022 13:53, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> Current implementation does not handling backlog semantics, one
> potential risk is that server will be flooded by infinite amount
> connections, even if client was SMC-incapable.

In this patch you count the number of inflight SMC handshakes as pending and
check them against the defined max_backlog. I really like this improvement.

There is another queue in af_smc.c, the smc accept queue and any new client 
socket that completed the handshake process is enqueued there (in smc_accept_enqueue() )
and is waiting to get accepted by the user space application. To apply the correct
semantics here, I think the number of sockets waiting in the smc accept queue 
should also be counted as backlog connections, right? I see no limit for this queue
now. What do you think?
