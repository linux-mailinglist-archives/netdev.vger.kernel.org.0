Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001E3476E88
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 11:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbhLPKIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 05:08:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235641AbhLPKIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 05:08:21 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BG7xVB9018689;
        Thu, 16 Dec 2021 10:08:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=nfJZtwi9MqijqEWjGvp+8qARqPFaSWZXZtpZIlm8QfM=;
 b=ZW1EIL+kp1NwtkU9+r3n6zIkzW1TuHxsDBVitYoIMgBoRgBJf4JsNdbo83SDnog9TA2d
 ZsCyrMOUx2sOKY2pXe0BPek9swbYUk2+oKb6/flyU7RW+IbuGITOsU83uVjNcvVDIe8z
 4+TsLh0PbXj5/YOx6FG2JqPL5KkcrBClDTvcjWYszMHyptWsXo/0MrMimQJTdAXLOD/+
 DxDp4davPJwyZmg6sPxZNoEbehGdQGZU9yJTO6a7xK01mJle9LtQ/rgc1H3nebCnoZDR
 nTwNm/jgPw2AO2doxZcqepS3J7M/PkmjQ02zPwpqCX+PiofJ3/ShJquKN6Zf+zsy5QRK yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyn1jsdr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 10:08:18 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BGA07iS006807;
        Thu, 16 Dec 2021 10:08:18 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyn1jsdq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 10:08:18 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BGA2UpS024719;
        Thu, 16 Dec 2021 10:08:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3cy7k3d270-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 10:08:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BGA8DxN24838602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 10:08:13 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 109B752052;
        Thu, 16 Dec 2021 10:08:13 +0000 (GMT)
Received: from [9.145.39.85] (unknown [9.145.39.85])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B1E575204F;
        Thu, 16 Dec 2021 10:08:12 +0000 (GMT)
Message-ID: <2c8f208f-9b14-1c79-ae6a-0ef64010b70a@linux.ibm.com>
Date:   Thu, 16 Dec 2021 11:08:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net] net/smc: Prevent smc_release() from long blocking
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1639571361-101128-1-git-send-email-alibuda@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1639571361-101128-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CmpTY8c-RTKDSt3WNqEb04JO0Cwql8ds
X-Proofpoint-GUID: fXg8nuH8yzuCs6zwYvSuYmj2RV2UOlqe
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-16_03,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=892
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 clxscore=1015 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112160053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/12/2021 13:29, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> In nginx/wrk benchmark, there's a hung problem with high probability
> on case likes that: (client will last several minutes to exit)
> 
> server: smc_run nginx
> 
> client: smc_run wrk -c 10000 -t 1 http://server
> 
> Client hangs with the following backtrace:

Good finding, thank you!

Acked-by: Karsten Graul <kgraul@linux.ibm.com>

