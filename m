Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0ADF4AEB92
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 08:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240016AbiBIH4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237823AbiBIH4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:56:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF31C05CB88;
        Tue,  8 Feb 2022 23:56:49 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2196bOD0003820;
        Wed, 9 Feb 2022 07:56:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dlQPDsNlOZunq//ValhUq36eKcqLebgJqTNvy2VhbFE=;
 b=PbJttPWM9IFkkSVPMHxjMk2mKqMpnuAW8YQPaPrQO9onyfqMLm8pmVacx2Utrs4qdojY
 uglFuw5f8DPhtg2xyQEJ6fEo4n1ACaChjBZ9aTKAw/bFivL0nc+ssSnIZoLs+PnJw3oV
 huxufQf+LrD+zOpaOZMYCE/dNNt+a8g7q4oZWlKcwug/8WrhwDUJhFuFwQ0ZLJY0FpMd
 KdyTmQcD7H7b9YcgF7y2u4a9YZNEMBEjKQShfwbdT+yg9/OQwKBLuGKg6hVWYA8XA+VN
 ld3cuUX8DZ4J0jwICsysX7wzhDpkK7TL6lShYwDxbXmK2lqycr4FL0Mk+1c5jd2VipUH 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e44v6penj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 07:56:45 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2197o2LG002560;
        Wed, 9 Feb 2022 07:56:45 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e44v6pen2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 07:56:45 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2197qfEL011863;
        Wed, 9 Feb 2022 07:56:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gv9me1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 07:56:42 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2197ueaL42926438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 07:56:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94EB54C046;
        Wed,  9 Feb 2022 07:56:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AA744C044;
        Wed,  9 Feb 2022 07:56:40 +0000 (GMT)
Received: from [9.145.24.227] (unknown [9.145.24.227])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 07:56:40 +0000 (GMT)
Message-ID: <e4244627-86e6-8999-05a8-ba9a15630c55@linux.ibm.com>
Date:   Wed, 9 Feb 2022 08:56:41 +0100
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
 <c28365d5-72e3-335b-372e-2a9069898df1@linux.ibm.com>
 <7f35f47b-af31-a07e-752a-11bb15aa0db9@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <7f35f47b-af31-a07e-752a-11bb15aa0db9@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CgfR1315L56KpqU9ARexbnvHrjfS44EZ
X-Proofpoint-ORIG-GUID: YzBeSV6lyGNzPHOv3RxfWyVhI13YuVQ0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_04,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2022 08:11, D. Wythe wrote:
> 
> There are indirectly limits on smc accept queue with following code.
> 
> +    if (sk_acceptq_is_full(&smc->sk)) {
> +        NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
> +        goto drop;
> +    }
> 
> 
> In fact, we treat the connections in smc accept queue as Full establisted connection. As I wrote in patch commits, there are trade-offs to this implemets.
> 

Thanks for the clarification, I got your point. You refer to the call to sk_acceptq_added()
in smc_accept_enqueue().
