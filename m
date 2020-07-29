Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2192327A6
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 00:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgG2Who (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 18:37:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6770 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbgG2Whn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 18:37:43 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TMXBOl022754;
        Wed, 29 Jul 2020 18:37:39 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32k2sbsber-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 18:37:38 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06TMZvHD009671;
        Wed, 29 Jul 2020 22:37:37 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01wdc.us.ibm.com with ESMTP id 32gcycwd03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 22:37:37 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06TMbaWJ3343010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 22:37:36 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FA64BE056;
        Wed, 29 Jul 2020 22:37:36 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8DBBBE054;
        Wed, 29 Jul 2020 22:37:35 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.109.59])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 29 Jul 2020 22:37:35 +0000 (GMT)
Subject: Re: [PATCH net] ibmvnic: Fix IRQ mapping disposal in error path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        drt@linux.ibm.com
References: <1596058592-12025-1-git-send-email-tlfalcon@linux.ibm.com>
 <20200729152820.79c00fe7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <e8d8d91d-2fd6-27af-9fec-2f855e581b78@linux.ibm.com>
Date:   Wed, 29 Jul 2020 17:37:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200729152820.79c00fe7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_14:2020-07-29,2020-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 mlxlogscore=942 spamscore=0 priorityscore=1501
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007290151
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/29/20 5:28 PM, Jakub Kicinski wrote:
> On Wed, 29 Jul 2020 16:36:32 -0500 Thomas Falcon wrote:
>> RX queue IRQ mappings are disposed in both the TX IRQ and RX IRQ
>> error paths. Fix this and dispose of TX IRQ mappings correctly in
>> case of an error.
>>
>> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> Thomas, please remember about Fixes tags (for networking patches,
> at least):
>
> Fixes: ea22d51a7831 ("ibmvnic: simplify and improve driver probe function")

Sorry, Jakub, I will try not to forget next time. Thanks.

