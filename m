Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7103D2B8F0B
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 10:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgKSJfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 04:35:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726811AbgKSJfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 04:35:01 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ9Wjk1042772;
        Thu, 19 Nov 2020 04:34:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=7n11oeGZxFg2EEShbaxBLYYI7YyW7ABHtHZCxqRwhdU=;
 b=BdbF6nHuBmfIGURGYfJIv/1HFHao+Xzz36sSXrAg8a8TjonPsEKhsnf2pSP0NcttrlqW
 gioROhPmuKzZeMAUdr+Rg+NEQr/l2YuU9xrmdHc9EynH/rECYPkbExc1pZeReBi4GQXf
 /XvCfjJhOnNbvt0fzF8sY29ZISju6+C2n6S8XKLrnZFtYVpnnH2ucRwV7ot+QeGpBing
 RyhaqtS2GBDjrFI9ZY0jF+Ka+4KLKl16/EcGd1+oadBSSwxSNPwrEtTZLfFNNRB09vEr
 6/kUXxbQYBfFMXFiQBaqWVa2X5ZGJdIM6Iz7a6oYO2EWW98I8y89aBn2HMqJ04DE1yEV Vg== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34wg5s1bde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 04:34:51 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ9Mxsq023332;
        Thu, 19 Nov 2020 09:34:51 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 34vgjms7fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 09:34:51 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJ9YhmT5702318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 09:34:43 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73BB76A04D;
        Thu, 19 Nov 2020 09:34:49 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C6876A051;
        Thu, 19 Nov 2020 09:34:49 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 09:34:48 +0000 (GMT)
MIME-Version: 1.0
Date:   Thu, 19 Nov 2020 03:34:48 -0600
From:   ljp <ljp@linux.vnet.ibm.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, cforno12@linux.ibm.com,
        ricklind@linux.ibm.com, dnbanerg@us.ibm.com,
        drt@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com
Subject: Re: [PATCH net-next v2 1/9] ibmvnic: Introduce indirect subordinate
 Command Response Queue buffer
In-Reply-To: <1605748345-32062-2-git-send-email-tlfalcon@linux.ibm.com>
References: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
 <1605748345-32062-2-git-send-email-tlfalcon@linux.ibm.com>
Message-ID: <85651886a1e1986a43bfd16ea560c84d@linux.vnet.ibm.com>
X-Sender: ljp@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_05:2020-11-17,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=880 phishscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011190067
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-18 19:12, Thomas Falcon wrote:
> This patch introduces the infrastructure to send batched subordinate
> Command Response Queue descriptors, which are used by the ibmvnic
> driver to send TX frame and RX buffer descriptors.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Acked-by: Lijun Pan <ljp@linux.ibm.com>
