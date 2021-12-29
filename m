Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCF84812B4
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 13:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237891AbhL2MgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 07:36:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42874 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234936AbhL2MgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 07:36:13 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BTC3U6N030221;
        Wed, 29 Dec 2021 12:36:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tII1d9Doo1GAPf2XA5Hgn9TH124XuRm9fdpDsPaOCKg=;
 b=mSRJHTeJjOzYAgzXj+/ZL+0GdifeWzEIbcZOEcU2/zQHc/qDvs1CrMY6obyoNkfR2bRA
 l8Wfl0e0VFweEIgg9X4bKFmBsJd3vhW0qnNwCyf5eSBVEPFpqBZZGoZ20OEHX2X4ZoYK
 BBhzMUfMvYkqBgjpH5dFPXBQfJmhvlHHwoMtY7kNU5SBJM6OwJswKgzvByM1j2KbDRgh
 vrC+1cs384j0fJ1tLdflRwRUYWrtIE8cr4VsrpypnEaBNh4iTpinX3H3L5xkH+riAU+Q
 kUTZKoI6bYwIFqK3jbiYaS2QzrXHRwkHN/CK5t2Hh/8nQm4258/9xDgFUWZOkE1PEvLd rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d7xduvamr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 12:36:12 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BTBmAr4007663;
        Wed, 29 Dec 2021 12:36:11 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d7xduvam6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 12:36:11 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BTCX0sm020739;
        Wed, 29 Dec 2021 12:36:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3d5tjjnc7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 12:36:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BTCa60W46334368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Dec 2021 12:36:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F8E54C040;
        Wed, 29 Dec 2021 12:36:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E96C4C05A;
        Wed, 29 Dec 2021 12:36:06 +0000 (GMT)
Received: from [9.145.32.240] (unknown [9.145.32.240])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Dec 2021 12:36:06 +0000 (GMT)
Message-ID: <2b3dd919-029c-cd44-b39c-5467bb723c0f@linux.ibm.com>
Date:   Wed, 29 Dec 2021 13:36:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net 1/2] net/smc: don't send CDC/LLC message if link not
 ready
Content-Language: en-US
To:     Dust Li <dust.li@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
References: <20211228090325.27263-1-dust.li@linux.alibaba.com>
 <20211228090325.27263-2-dust.li@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211228090325.27263-2-dust.li@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W8GjISVqEibUf4brFb5EJr5YFfGJRcY8
X-Proofpoint-ORIG-GUID: i6UOAbh5OQRAtxb83ZqvVdOSc0lJoJyC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-29_04,2021-12-29_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112290068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/12/2021 10:03, Dust Li wrote:
> We found smc_llc_send_link_delete_all() sometimes wait
> for 2s timeout when testing with RDMA link up/down.
> It is possible when a smc_link is in ACTIVATING state,
> the underlaying QP is still in RESET or RTR state, which
> cannot send any messages out.

I see your point, but why do you needed to introduce a new wrapper instead of
extending the existing smc_link_usable() wrapper?
With that and without any comments the reader of the code does not know why there are
2 different functions and what is the reason for having two of them.
