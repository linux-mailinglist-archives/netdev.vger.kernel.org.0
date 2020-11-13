Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C552B1FEE
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgKMQRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:17:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3340 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725866AbgKMQRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:17:32 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADG3Q9b073891;
        Fri, 13 Nov 2020 11:17:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ix5xI4eV4ktS+Si1szwX06PnD5N08iIL8loUbC9USd4=;
 b=lvqMGQrEocWuerl678y/36jbtoduwAl/QpBezhM8Cwf1OBT9m26dDtGplSkJVejE3HRc
 9wV/D2LZIWYRDob44R9gdZC85bzAyl1egVO9TDx2FNvMS25YTrBRAjl9/LcJWsyTWrpU
 kn4bsEkbTM32tahddVLbxoaIhTMMLREkY591XtB5ff8rB88Zgg2Ps4I7QELpC4qR/yXj
 u7HvoDLmUtVPeKtjs4YgXsK2U2fDqIWL/X0urkR27425T3S088aTqceO0aTqCX+oT+c1
 FsZpYc5Hvf+IxnZs418E0I7Zw5wbX60dND8rPY4dRxOF6ZkEJLkMJ7lMKvwH8H8+eGEs Sw== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34sw3b103y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 11:17:28 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ADGH9Zn025372;
        Fri, 13 Nov 2020 16:17:27 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 34nk79uuc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 16:17:27 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ADGHJ1k6816322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 16:17:19 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CB127805C;
        Fri, 13 Nov 2020 16:17:25 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C943E7805E;
        Fri, 13 Nov 2020 16:17:24 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.48.97])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 13 Nov 2020 16:17:24 +0000 (GMT)
Subject: Re: [PATCH net-next 02/12] ibmvnic: Introduce indirect subordinate
 Command Response Queue buffer
To:     Thomas Falcon <tlfalcon@linux.ibm.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, dnbanerg@us.ibm.com,
        pradeep@us.ibm.com, drt@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, ljp@linux.vnet.ibm.com,
        cforno12@linux.ibm.com, ricklind@linux.ibm.com
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
 <1605208207-1896-3-git-send-email-tlfalcon@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <0bfb3be4-c1fa-9020-68bd-a8d4bb741fe7@linux.vnet.ibm.com>
Date:   Fri, 13 Nov 2020 10:17:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <1605208207-1896-3-git-send-email-tlfalcon@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_10:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015
 malwarescore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

