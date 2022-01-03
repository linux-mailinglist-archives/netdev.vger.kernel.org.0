Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CC7482FFB
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 11:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbiACKkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 05:40:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64246 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231356AbiACKkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 05:40:31 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 203ACDgC009726;
        Mon, 3 Jan 2022 10:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/6MvUMslpcD6P4u33Dh9nG1ZzbIm8jv4Ton+Fd14lUM=;
 b=poES1cbi2ykMYzrVdCXKLPaNFZOu95g1C5KveEZA0sumVf8JNE90D9TsFkAfb2evfTxm
 KhuVZOWEA0xDK6xHo1KM+s6NNtZwAE9O0bEJQlKEWAebh3VEYJgradOMT5Xoutup4p2+
 D4qDiJajOOz4mYaMCPqLbOb/opCY5Rb2/Il6D8Jb7DAYHmdMqnGu24e0wldDl2e9JolZ
 /NBTs9+drbOuUDgL+p2XIcRUcAAdGdzPuYfAjZBSlSwIyjL3HntKPYj2Xq2dQWfpfJe+
 kySeUvsM+UVsXGSZtH+9ghYtmzDgFJiJAij3y2PXIh7MWYfyIdFAlaxAw2ADRkni0O31 JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dbupxm9k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 10:40:29 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 203Ack6l011356;
        Mon, 3 Jan 2022 10:40:28 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dbupxm9jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 10:40:28 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 203AdktF023742;
        Mon, 3 Jan 2022 10:40:26 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3daek99svh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 10:40:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 203AeNIn9765166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jan 2022 10:40:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8474C11C052;
        Mon,  3 Jan 2022 10:40:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27E2711C06F;
        Mon,  3 Jan 2022 10:40:23 +0000 (GMT)
Received: from [9.145.23.206] (unknown [9.145.23.206])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jan 2022 10:40:23 +0000 (GMT)
Message-ID: <752679fd-274b-eeab-b31e-c3754f22c382@linux.ibm.com>
Date:   Mon, 3 Jan 2022 11:40:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net 1/2] net/smc: don't send CDC/LLC message if link not
 ready
Content-Language: en-US
To:     dust.li@linux.alibaba.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
References: <20211228090325.27263-1-dust.li@linux.alibaba.com>
 <20211228090325.27263-2-dust.li@linux.alibaba.com>
 <2b3dd919-029c-cd44-b39c-5467bb723c0f@linux.ibm.com>
 <20211230030226.GA55356@linux.alibaba.com>
 <c4f5827f-fe48-d295-6d97-3848cc144171@linux.ibm.com>
 <20211231031544.GA31579@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211231031544.GA31579@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zcTHRjoKSRQxb1FL3jsU0ieINaws9gcZ
X-Proofpoint-GUID: PzJt1ti8zOrFkd_T_cuEjeFdKlTTB4cU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-03_04,2022-01-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 clxscore=1015 spamscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201030071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/12/2021 04:15, dust.li wrote:
> On Thu, Dec 30, 2021 at 07:55:01PM +0100, Karsten Graul wrote:
>> On 30/12/2021 04:02, dust.li wrote:
>>> On Wed, Dec 29, 2021 at 01:36:06PM +0100, Karsten Graul wrote:
>>>> On 28/12/2021 10:03, Dust Li wrote:
>>> I saw David has already applied this to net, should I send another
>>> patch to add some comments ?
>>
>> You could send a follow-on patch with your additional information, which
>> I find is very helpful! Thanks.
> 
> Sure, will do

Thank you!
