Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC8B2BC663
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 16:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgKVPMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 10:12:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12988 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727728AbgKVPMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 10:12:43 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AMF1Egq025829;
        Sun, 22 Nov 2020 10:12:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=Y3i8MUffMDfSvCaRL7H8drMw1I0QcT2f7HCb/y7lYu0=;
 b=BYGA1YwGlXJ87RyPA2wXyG2/lJTI/3PK7L0jLMGssScJrjZAqPyUaqVxZvuiz/3/vOuj
 LWPOm0Q199vLZocWsOt77WmReuwsNtOZF/wcxtRmR0ugdaSzxbZgc8Unn/H6qyMzxwVY
 BzZmM/Wz2iqtHUAgBZP626DEdTMDn6SrlpQLaya+iIM70ABmvkTctN29Jn97jfRnGQEq
 GcQnMOcNC7FrPPGVcT6FkEnxd2XfhWVghRF1DoGHxuVRheJt/m45LJHHQb8t3hliebm3
 2eK6c98GK7MUzzAT7rKc8ZvYbElBs2q4eNwTd9chZDivihz957oFBO+HdBrAIq0oyzpy pg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34yq46b6m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 22 Nov 2020 10:12:40 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AMF8YxF014640;
        Sun, 22 Nov 2020 15:12:40 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 34xth8kh06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 22 Nov 2020 15:12:40 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AMFCc0G64356824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Nov 2020 15:12:38 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8095578063;
        Sun, 22 Nov 2020 15:12:38 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E9977805E;
        Sun, 22 Nov 2020 15:12:38 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 22 Nov 2020 15:12:38 +0000 (GMT)
MIME-Version: 1.0
Date:   Sun, 22 Nov 2020 07:12:38 -0800
From:   drt <drt@linux.vnet.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org,
        sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net 02/15] ibmvnic: process HMC disable command
In-Reply-To: <20201121153637.17a91ac4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
 <20201120224049.46933-3-ljp@linux.ibm.com>
 <20201121153637.17a91ac4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <aa10c3fad62841df56a6185b3b267ca9@linux.vnet.ibm.com>
X-Sender: drt@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-22_07:2020-11-20,2020-11-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011220103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-21 15:36, Jakub Kicinski wrote:
> On Fri, 20 Nov 2020 16:40:36 -0600 Lijun Pan wrote:
>> From: Dany Madden <drt@linux.ibm.com>
>> 
>> Currently ibmvnic does not support the disable vnic command from the
>> Hardware Management Console. This patch enables ibmvnic to process
>> CRQ message 0x07, disable vnic adapter.
> 
> What user-visible problem does this one solve?
This allows HMC to disconnect a Linux client from the network if the 
vNIC adapter is misbehaving and/or sending malicious traffic. The effect 
is the same as when a sysadmin sets a link down (ibmvnic_close()) on the 
Linux client. This patch extends this ability to the HMC.

Thanks!
Dany
