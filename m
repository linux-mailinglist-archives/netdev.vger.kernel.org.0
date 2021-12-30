Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDBC481D89
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 16:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241284AbhL3PEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 10:04:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36602 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241274AbhL3PDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 10:03:34 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BUCUF4b014515;
        Thu, 30 Dec 2021 15:03:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jMANrreSLuC0gqJrEjbxLuoNWlZQVAoSFbMHXBX4/Mk=;
 b=kRK18YdEOm9QKHe2KinXTUv9D/x2oUz61GndQ7F98SsEmQ3qbPeSOh8f4CzYjeAphhQ5
 vvoD3ZEJRc7aFljtPbwQeDPypCB3uuJ2EAw2ijafdtI9x8dS0BGp5PdFxRU/tYtjWOA+
 hA0HjjPnHGRP4GSeHDFbwMCAHDBlCE7PKRyx+4WFefJ35qXLpzuawZMUR62ciZUNtdWN
 /2WRLBki1hFDKG0+w6If7i7Mh62vrjX+WCI6Z3gGDFm+GUt+c1l59ZQXVG2Cm4Pf75Vk
 XI2nJcvii3BmP7jIplrskf4gPJC2ydtZyfVO9vpWGpK/4W/omjrR7/Ah797LUAzMWG3T og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d844r9r4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 15:03:23 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BUEXBZg008869;
        Thu, 30 Dec 2021 15:03:23 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d844r9r4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 15:03:23 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BUEvjTS010363;
        Thu, 30 Dec 2021 15:03:21 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3d5tx9j9as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 15:03:21 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BUF3JkV38404588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Dec 2021 15:03:19 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3453742056;
        Thu, 30 Dec 2021 15:03:19 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1E3F4204D;
        Thu, 30 Dec 2021 15:03:18 +0000 (GMT)
Received: from [9.145.32.195] (unknown [9.145.32.195])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Dec 2021 15:03:18 +0000 (GMT)
Message-ID: <97ea52de-5419-22ee-7f55-b92887dcaada@linux.ibm.com>
Date:   Thu, 30 Dec 2021 16:03:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next] net/smc: Introduce TCP ULP support
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20211228134435.41774-1-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211228134435.41774-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ok5tmxyyKmLor-2JuexOo-b-FXNbPq8n
X-Proofpoint-ORIG-GUID: Pz2JW6LtT05ZB5xM5YOhZR5hnK7MIA0z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-30_05,2021-12-30_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 suspectscore=0 impostorscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112300083
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/12/2021 14:44, Tony Lu wrote:
> This implements TCP ULP for SMC, helps applications to replace TCP with
> SMC protocol in place. And we use it to implement transparent
> replacement.
> 
> This replaces original TCP sockets with SMC, reuse TCP as clcsock when
> calling setsockopt with TCP_ULP option, and without any overhead.

This looks very interesting. Can you provide a simple userspace example about 
how to use ULP with smc?

And how do you make sure that the in-band CLC handshake doesn't interfere with the
previous TCP traffic, is the idea to put some kind of protocol around it so both
sides 'know' when the protocol ended and the CLC handshake starts?
