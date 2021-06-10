Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C873A34F1
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhFJUil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:38:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60366 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230059AbhFJUik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 16:38:40 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AKWwBQ170786;
        Thu, 10 Jun 2021 16:36:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=Qg8F5bpHm9upwUm940/1y/8iuglrZTeh5EMJnr/H3o8=;
 b=G6PBKidbXNKntuqQCDbE3O68SgkLzZVVED/e2v6G6aFn+UM+F77vuQAnQT6YRJXjvrMn
 XFKIbo/2LA7t2emoIe5z+AzLz3pyeCvZm7EcfrseV8j34jGwYv6dOSHJ+mcvsN2EPJ6G
 6WzGqy7GW/KW5BrPDHvHBoom2pijg9nMyvL2JV7j0EACKH2Fw84vrLH1OBo/313DQLLm
 XAZ6TesJFF/GBwsDpmi+UrLHgiCM6IpJJ0PYEP8KrqNF6blw6QL6n/GPbQKD8l0XtC+2
 spcfk4vxYUIezJgsKrqsEliEknXBQMw1u612piT58tuMft6+kAouoR5tVgVjXPTvO1MP Fw== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393njwfwhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 16:36:29 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15AKCs3b001196;
        Thu, 10 Jun 2021 20:36:29 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 3900wa30h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 20:36:29 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15AKaRZ628901784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 20:36:28 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB7A6BE04F;
        Thu, 10 Jun 2021 20:36:27 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5769FBE053;
        Thu, 10 Jun 2021 20:36:27 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 10 Jun 2021 20:36:27 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 10 Jun 2021 13:36:27 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Cristobal Forno <cforno12@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, davem@davemloft.net,
        kuba@kernel.org, Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: Re: [PATCH, net-next, v2] ibmvnic: Allow device probe if the device
 is not ready at boot
In-Reply-To: <20210610170835.10190-1-cforno12@linux.ibm.com>
References: <20210610170835.10190-1-cforno12@linux.ibm.com>
Message-ID: <b72a543228cde360d35a710f72fb8968@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dJ1nXqwCyKHcTxhx7BuB6B0IF0pukRD8
X-Proofpoint-GUID: dJ1nXqwCyKHcTxhx7BuB6B0IF0pukRD8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_13:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=674 suspectscore=0 adultscore=0 spamscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100130
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-10 10:08, Cristobal Forno wrote:
> Allow the device to be initialized at a later time if
> it is not available at boot. The device will be allowed to probe but
> will be given a "down" state. After completing device probe and
> registering the net device, the driver will await an interrupt signal
> from its partner device, indicating that it is ready for boot. The
> driver will schedule a work event to perform the necessary procedure
> and begin operation.
> 
> Co-developed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> Signed-off-by: Cristobal Forno <cforno12@linux.ibm.com>
> 
> ---
Reviewed-by: Dany Madden <drt@linux.ibm.com>
