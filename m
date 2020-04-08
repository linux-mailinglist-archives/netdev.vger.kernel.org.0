Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E251A1D15
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 10:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgDHIGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 04:06:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726436AbgDHIGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 04:06:51 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038853sU113731
        for <netdev@vger.kernel.org>; Wed, 8 Apr 2020 04:06:51 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 309203umdh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 04:06:50 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <schnelle@linux.ibm.com>;
        Wed, 8 Apr 2020 09:06:24 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Apr 2020 09:06:21 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03886jG531391922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Apr 2020 08:06:45 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA58442045;
        Wed,  8 Apr 2020 08:06:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82F634204D;
        Wed,  8 Apr 2020 08:06:44 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.62.21])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Apr 2020 08:06:44 +0000 (GMT)
Subject: Re: [RFC] net/mlx5: Fix failing fw tracer allocation on s390
To:     Markus Elfring <Markus.Elfring@web.de>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
References: <77241c76-4836-3080-7fa6-e65fc3af5106@web.de>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Date:   Wed, 8 Apr 2020 10:06:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <77241c76-4836-3080-7fa6-e65fc3af5106@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20040808-4275-0000-0000-000003BBDC52
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040808-4276-0000-0000-000038D13FB0
Message-Id: <7eaec712-6427-7adf-98cd-2c4347dd9e85@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004080065
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/7/20 5:12 PM, Markus Elfring wrote:
>> On s390 FORCE_MAX_ZONEORDER is 9 instead of 11, thus a larger kzalloc()
>> allocation as done for the firmware tracer will always fail.
> 
> How do you think about to add the tag “Fixes” to the final change description?
> 
> Regards,
> Markus
> 
You're right that makes a lot of sense, thanks! I guess this should reference
the commit that introduced the debug trace, right?

Best regards,
Niklas

