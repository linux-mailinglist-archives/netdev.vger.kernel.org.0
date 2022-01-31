Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429CD4A4776
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377995AbiAaMqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:46:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8276 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377935AbiAaMqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 07:46:31 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VCbqif036194;
        Mon, 31 Jan 2022 12:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nh+RVENpbA1r3RMZCSSKROR/LLLUwDVrN3w9Pumuon8=;
 b=Bc+nFuL5dQ9Em0ZXdRak04eTq4eJojGzJlpJoqpo7VgxW3mPndw12fpRcQoT70ZU5aE0
 6MwpZNxT+d9gGkPIoH2VqitYQVMbezRfozmJIxlfDJeUtpkZfASoo/d5dNX485XTmC7R
 uLESJ/QynnaO/BrX6+XB8C5vrgJb2K6WKOTgnC5csqDdG3kgvVFXvTvCso8CZslavNF8
 4I2YRS4ZELZP9EFWGBhSQPULfzu1yj45gb2anYNHF253EBHmCK91wlKhFTlSNSQ3s+xT
 8qrW5WAzKM9vyN6JX/PJwh9NgE3w/2KtwcONDtzZNoMjDp5Fs/EJwNozRP64fQVn8s71 uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dx5a6tuah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 12:46:28 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20VCfQ1b008949;
        Mon, 31 Jan 2022 12:46:28 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dx5a6tu9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 12:46:28 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20VCgCl2002823;
        Mon, 31 Jan 2022 12:46:25 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3dvw79bdqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 12:46:25 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20VCkNcK39387484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 12:46:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C31C11C052;
        Mon, 31 Jan 2022 12:46:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A55511C04C;
        Mon, 31 Jan 2022 12:46:23 +0000 (GMT)
Received: from [9.145.79.147] (unknown [9.145.79.147])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Jan 2022 12:46:23 +0000 (GMT)
Message-ID: <83f520b1-d272-cafc-37b1-d086d68f2e9c@linux.ibm.com>
Date:   Mon, 31 Jan 2022 13:46:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 0/3] net/smc: Optimizing performance in
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        matthieu.baerts@tessares.net
References: <cover.1643380219.git.alibuda@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <cover.1643380219.git.alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jp6sQAvkvPGwbrZFyc7RIG3WTR821-lw
X-Proofpoint-GUID: WezDvuRvtofA6cZSN92KaH3o9r5641GK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_05,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310083
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/01/2022 15:44, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 

Cover letter subject: "Optimizing performance in" ??
