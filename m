Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE7A58C24
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfF0U4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:56:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43620 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726384AbfF0U4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:56:13 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RKr2GA072769
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 16:56:12 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2td2jaf9vq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 16:56:12 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <tlfalcon@linux.ibm.com>;
        Thu, 27 Jun 2019 21:56:11 +0100
Received: from b01cxnp23033.gho.pok.ibm.com (9.57.198.28)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 21:56:08 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RKu6qq47776204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 20:56:07 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3353AC06C;
        Thu, 27 Jun 2019 20:56:06 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0171AC05E;
        Thu, 27 Jun 2019 20:56:05 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.85.203.209])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 20:56:05 +0000 (GMT)
Subject: Re: [PATCH net] net/ibmvnic: Report last valid speed and duplex
 values to ethtool
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bjking1@us.ibm.com, pradeep@us.ibm.com, dnbanerg@us.ibm.com
References: <1561655353-17114-1-git-send-email-tlfalcon@linux.ibm.com>
 <20190627175715.GP27733@lunn.ch>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Date:   Thu, 27 Jun 2019 15:56:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190627175715.GP27733@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19062720-0064-0000-0000-000003F48B7F
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011342; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01224163; UDB=6.00644283; IPR=6.01005351;
 MB=3.00027495; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-27 20:56:10
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062720-0065-0000-0000-00003E0E5E81
Message-Id: <d35f3fd8-da0e-cc47-7c4e-664c0bb14c0e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270240
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/27/19 12:57 PM, Andrew Lunn wrote:
> On Thu, Jun 27, 2019 at 12:09:13PM -0500, Thomas Falcon wrote:
>> This patch resolves an issue with sensitive bonding modes
>> that require valid speed and duplex settings to function
>> properly. Currently, the adapter will report that device
>> speed and duplex is unknown if the communication link
>> with firmware is unavailable.
> Dumb question. If you cannot communicate with the firmware, isn't the
> device FUBAR? So setting the LACP port to disabled is the correct
> things to do.
>
>         Andrew
>
Yes, I think that is correct too.  The problem is that the link is only 
down temporarily.  In this case - we are testing with a pseries logical 
partition - the partition is migrated to another server. The driver must 
wait for a signal from the hypervisor to resume operation with the new 
device.  Once it resumes, we see that the device reboots and gets 
correct speed settings, but the port flag (AD_LACP_PORT_ENABLED) is 
still cleared.

Tom

