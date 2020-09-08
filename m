Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95BE2619DC
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731415AbgIHS1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:27:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731643AbgIHS1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 14:27:20 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088IKtQo017137;
        Tue, 8 Sep 2020 14:27:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hrdctwYlspOpbi0Y/hbxyu8ccjxfQeeJBwS5DT34G5o=;
 b=pfaCVfd1lACJMJhnEB4wP5syLgfE04w2qbjNpJECTUQpt9yaBfKp0+BHPSoCKkBD0ZNe
 VvME4WzhkPN0qaSR0fVrXEU4Lgc5WkUjdQgQKuK8fftGSTvxWVK8svSoHpOi7rHYKRiD
 nTNp45xWBTK8Wty+OGnotEB7iultXKLv9IdDKnQBmOA0eAx3SDFgK5l11wX45iUm7EQw
 aZrIAdepKDykRPIVGksZEAwlTCFchFtxmUqzCisSY6nHkC4R+oqNPYH4c5vJdf3Y9wd9
 r+TUyvlF4mihHPfULYgWyRf0lMA4eL41p0+3OZSfMtaGGRtzZNMNReriMks4U9KEuumo xg== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ef5gr3xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 14:27:16 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 088I7apj024408;
        Tue, 8 Sep 2020 18:27:15 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 33c2a8sca2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 18:27:15 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 088IREUH44892530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Sep 2020 18:27:14 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C51DFB2064;
        Tue,  8 Sep 2020 18:27:14 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63D24B205F;
        Tue,  8 Sep 2020 18:27:14 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.29.177])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  8 Sep 2020 18:27:14 +0000 (GMT)
Subject: Re: Exposing device ACL setting through devlink
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com
References: <e7f76581-8525-2b98-ec4d-e772db692318@linux.ibm.com>
 <20200904083141.GE2997@nanopsycho.orion>
 <20200904153751.17ad4b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <7e4c2c8f-a5b0-799c-3083-cfefcf37bf10@linux.ibm.com>
Date:   Tue, 8 Sep 2020 13:27:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200904153751.17ad4b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_09:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 clxscore=1011
 mlxlogscore=585 lowpriorityscore=0 adultscore=0 phishscore=0 bulkscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/20 5:37 PM, Jakub Kicinski wrote:
> On Fri, 4 Sep 2020 10:31:41 +0200 Jiri Pirko wrote:
>> Thu, Sep 03, 2020 at 07:59:45PM CEST, tlfalcon@linux.ibm.com wrote:
>>> Hello, I am trying to expose MAC/VLAN ACL and pvid settings for IBM
>>> VNIC devices to administrators through devlink (originally through
>>> sysfs files, but that was rejected in favor of devlink). Could you
>>> give any tips on how you might go about doing this?
>> Tom, I believe you need to provide more info about what exactly do you
>> need to setup. But from what you wrote, it seems like you are looking
>> for bridge/tc offload. The infra is already in place and drivers are
>> implementing it. See mlxsw for example.
> I think Tom's use case is effectively exposing the the VF which VLANs
> and what MAC addrs it can use. Plus it's pvid. See:
>
> https://www.spinics.net/lists/netdev/msg679750.html

Thanks, Jakub,

Right now, the use-case is to expose the allowed VLAN's and MAC 
addresses and the VF's PVID. Other use-cases may be explored later on 
though.

