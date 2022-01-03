Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D450482FF8
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 11:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiACKju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 05:39:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231356AbiACKju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 05:39:50 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2037WviH028802;
        Mon, 3 Jan 2022 10:39:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oHG/dNSCqbw7TmZKLckoGmLfruiqkP7RVai5lawW3Ng=;
 b=HA7M9oTsWysBq53rbdUJNr/JfDH5ziu6kafN/VwVxYzo9LwkzcBfd4vhZXjCQGnqhM28
 VcLm2HSfHHBQVdht9jyK7KlvTCQgBfJBelGprnnYuHxiiV7pgMfwi/o+LkTAwGid/xCJ
 C8Zvl4esNDERaJWEYEqUbE37Ql7LwFNTwDpz85fECBFTsiA5tH+sPFdD9HKmGmT2Eu1r
 yHWLsOzti6eCGOsojITOts75/GRAvBUFLxBSeesFjoDrvv1dWlmOBd4KyJtorrdzObYL
 PsTxxjfZL1pob9eXJ410rHiLzOCobSzjsjBHVuxiHItZckrcb9yKXHV7egdTp7DLRJRm zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dbrpxq0m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 10:39:46 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 203A6mF5009518;
        Mon, 3 Jan 2022 10:39:46 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dbrpxq0hq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 10:39:46 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 203AZleG018355;
        Mon, 3 Jan 2022 10:39:44 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3daek99sa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 10:39:44 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 203AdfwI28836338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jan 2022 10:39:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0EF311C07B;
        Mon,  3 Jan 2022 10:39:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79B9511C082;
        Mon,  3 Jan 2022 10:39:40 +0000 (GMT)
Received: from [9.145.23.206] (unknown [9.145.23.206])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jan 2022 10:39:40 +0000 (GMT)
Message-ID: <ea8f7f9d-0188-7f0b-87b1-09bcdf03671d@linux.ibm.com>
Date:   Mon, 3 Jan 2022 11:39:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH net v2 2/2] net/smc: Resolve the race between SMC-R
 link access and clear
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com
References: <1640704432-76825-1-git-send-email-guwen@linux.alibaba.com>
 <1640704432-76825-3-git-send-email-guwen@linux.alibaba.com>
 <7311029c-2c56-d9c7-9ed5-87bc6a36511f@linux.ibm.com>
 <2c056f5a-0cd1-e7a6-6318-b2368946ae96@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <2c056f5a-0cd1-e7a6-6318-b2368946ae96@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nQfHIECi-91Urdc5g_ygb2f9oBwlDiW_
X-Proofpoint-ORIG-GUID: Qs_0RP1bnHnZiinG-jyFI27_TLiA8CWT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-03_04,2022-01-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201030071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/12/2021 10:45, Wen Gu wrote:
> Thanks for your reply.

Thanks for the explanation and discussion. 
Please post this patch to the net tree.

I sent some comments for patch 1 of this series already.
