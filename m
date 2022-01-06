Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28B6486498
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiAFMvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:51:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61204 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229795AbiAFMvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:51:19 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 206Cfh0B004224;
        Thu, 6 Jan 2022 12:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bOHfExT8Oy+ZkDhWWwWXo4vV7y+gMBYcJxF9HkPayBs=;
 b=g36w4tMB8b0nioEUmc3sOwm2zrKvca+oKUkyY3Yb4xSeG+z+1N4bMPZ0I9QQ1Imiuv2D
 4B0ZYkjxJ6Eau1xmTemA2GFOgNryLUls/g1WyNr0uvbCUAPgvRH4w7e9l+PxrO+W1Wr+
 PQgQCV7BtusxxMFMlyTf/u9Jod9Tq35D//OEZoLVaMLY1pzka6mO9vjZB26I3+YTHeDj
 fOHFsULNGrc/AxS1ji09IEfxjUrd+Bla9ZAdfv4F4vlCKg3NbFhLgShLdTTNNnS1uJMe
 QUW+/3wXPMZPkvD9SltbQUJohBis2N+tA4/7/OldGfMvmFDHwSgGzOmfumN+sLEcoJNX XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3de0na04j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 12:51:17 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 206CiBk1018766;
        Thu, 6 Jan 2022 12:51:16 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3de0na04hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 12:51:16 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 206CmdLW000594;
        Thu, 6 Jan 2022 12:51:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3ddn4u4wye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 12:51:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 206CpB0l39059760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jan 2022 12:51:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A425AA4062;
        Thu,  6 Jan 2022 12:51:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51DF9A4066;
        Thu,  6 Jan 2022 12:51:11 +0000 (GMT)
Received: from [9.145.19.45] (unknown [9.145.19.45])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jan 2022 12:51:11 +0000 (GMT)
Message-ID: <27773185-8bfc-b373-2c9d-d741751e025b@linux.ibm.com>
Date:   Thu, 6 Jan 2022 13:51:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net v5] net/smc: Reset conn->lgr when link group
 registration fails
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641472928-55944-1-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1641472928-55944-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: a5hXCUqjJdviabr5UnXnV6tvZem_hT3j
X-Proofpoint-GUID: GeymJvnkY-KCRNYpVruy3HCv6GWIpjf6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-06_04,2022-01-06_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=951 malwarescore=0
 phishscore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2112160000 definitions=main-2201060088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2022 13:42, Wen Gu wrote:
> v4->v5:
> - Hold a local copy of lgr in smc_conn_abort().

Looks good to me!

Acked-by: Karsten Graul <kgraul@linux.ibm.com>

