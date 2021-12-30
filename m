Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42523481F56
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 19:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241741AbhL3SzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 13:55:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31984 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241661AbhL3SzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 13:55:11 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BUF2laN012223;
        Thu, 30 Dec 2021 18:55:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Y2+11PFKAFAinMj5TTgQRiquEgA30BhgYDn1/Wa3RXY=;
 b=Kq9fjWXZ/LG71R78u0eHLGfoT4u0bJIxR4t7qa7gdzdWZ57bP4XDr7L3TilXs3cK+D1x
 DZLZsB8uOX5UbMaXrB0szMee5z1y0SA2ur0/v8rR4MGeez+eJGOtmnhaQHPlCmY41uJr
 szIBz8Rg8eX9cUysJUPUEtLnz3vrJWjlhN9JR0QufS9AewxuLopGv5WAO8EAsnfwSsi4
 Z3rDj1S15ogw9tvlY9IC5fECUFBOLxL9O/m9cAr4OHyDXC1JIop7pd+ZJBgR/d7+f5tm
 NXoYwzB1+zh68FqUVRdPRA9WoAiSAnQlf+H64N1dJFl1Unm98oPyt9d2TNQFLWHo+aAw 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d9f2m3bs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 18:55:06 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BUIRrm6001554;
        Thu, 30 Dec 2021 18:55:06 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d9f2m3brt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 18:55:06 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BUIqRXZ013461;
        Thu, 30 Dec 2021 18:55:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3d5txb66y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 18:55:04 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BUIt1cB37093750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Dec 2021 18:55:01 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9045D42045;
        Thu, 30 Dec 2021 18:55:01 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 365194204D;
        Thu, 30 Dec 2021 18:55:01 +0000 (GMT)
Received: from [9.145.32.195] (unknown [9.145.32.195])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Dec 2021 18:55:01 +0000 (GMT)
Message-ID: <c4f5827f-fe48-d295-6d97-3848cc144171@linux.ibm.com>
Date:   Thu, 30 Dec 2021 19:55:01 +0100
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
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211230030226.GA55356@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VVxIcB3SCYgJ6yH7qp2JlpJla32hWWk3
X-Proofpoint-ORIG-GUID: TTFxzlXsMDKiendUqJCe80E5Es3mmSmp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-30_06,2021-12-30_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112300107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/12/2021 04:02, dust.li wrote:
> On Wed, Dec 29, 2021 at 01:36:06PM +0100, Karsten Graul wrote:
>> On 28/12/2021 10:03, Dust Li wrote:
> I saw David has already applied this to net, should I send another
> patch to add some comments ?

You could send a follow-on patch with your additional information, which
I find is very helpful! Thanks.

-- 
Karsten
