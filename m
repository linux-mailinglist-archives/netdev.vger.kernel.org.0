Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7653672EB
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245197AbhDUSzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:55:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23942 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235329AbhDUSzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 14:55:20 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13LIYXGG166471;
        Wed, 21 Apr 2021 14:54:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=hoIIvLijVUEh0RcJjWarSwu+MSlAeJILzJQySf4NFpQ=;
 b=l8N6g/BUJT2vNi3BI2Zyyk3NlS3c7MWPwXgQ1WktcaI/1ip+T9VHinP0oS3duZwNv1zL
 2sWyX4WHH7PCvE6EvTLONG9SPrTVUHVIdULA3/78hmNvgFTcYuveqwbZ1h/T2luX4h0v
 M5Q2n7Y71EvabfIBoqYtZW1qB53BwzinkwrZReo/0uKmD/bBdixUC17Z4L1pJXtm56qx
 xCiQZuGvhFgmTDrYyq4GKNMSFmAr5oD3mfrtQsZOp1+Wbjmq14A8LZVT7BO/97HOpjWO
 CDA52Af0RCbfwGvlsp0K+bs0phacX6gGClAhx87B3tcG/M1yQKcdeNzXr0rkj+WZzYY+ mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382pmm6nsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 14:54:35 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13LIYcC8167078;
        Wed, 21 Apr 2021 14:54:35 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382pmm6nsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 14:54:35 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13LIhbqP010245;
        Wed, 21 Apr 2021 18:54:33 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 37yqa8jfjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 18:54:33 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13LIsV6f37814718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 18:54:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E15965204E;
        Wed, 21 Apr 2021 18:54:30 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.22.74])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 11AD852050;
        Wed, 21 Apr 2021 18:54:30 +0000 (GMT)
Subject: Re: net: bridge: propagate error code and extack from
 br_mc_disabled_update
To:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, idosch@idosch.org,
        jiri@resnulli.us, kuba@kernel.org, netdev@vger.kernel.org,
        nikolay@nvidia.com, roopa@nvidia.com, vladimir.oltean@nxp.com,
        linux-next@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20210414192257.1954575-1-olteanv@gmail.com>
 <20210421181808.5210-1-borntraeger@de.ibm.com>
 <cfc19833-01ec-08ea-881d-4101780d1d86@de.ibm.com>
 <3993fbf8-b409-f88f-c573-bf5b8f418a88@gmail.com>
 <20210421184600.qzsx6obwifcfsshq@skbuf>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <5a55f3f3-4861-6871-3b74-05361015297a@de.ibm.com>
Date:   Wed, 21 Apr 2021 20:54:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210421184600.qzsx6obwifcfsshq@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: meZk1lVbO41N9oedT5XFUsDV-F5fD8ki
X-Proofpoint-ORIG-GUID: BMX2wi3EmDEm_8l5YKvhKSRRXsW-xwAP
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_05:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104210128
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.04.21 20:46, Vladimir Oltean wrote:
> On Wed, Apr 21, 2021 at 11:37:25AM -0700, Florian Fainelli wrote:
>> On 4/21/2021 11:35 AM, Christian Borntraeger wrote:
>>> On 21.04.21 20:18, Christian Borntraeger wrote:
>>>> Whatever version landed in next, according to bisect this broke
>>>> libvirt/kvms use of bridges:
>>>>
>>>>
>>>> # virsh start s31128001
>>>> error: Failed to start domain 's31128001'
>>>> error: Unable to add bridge virbr1 port vnet0: Operation not supported
>>>>
>>>> # grep vnet0 /var/log/libvirt/libvirtd.log
>>>>
>>>> 2021-04-21 07:43:09.453+0000: 2460: info : virNetDevTapCreate:240 :
>>>> created device: 'vnet0'
>>>> 2021-04-21 07:43:09.453+0000: 2460: debug :
>>>> virNetDevSetMACInternal:287 : SIOCSIFHWADDR vnet0
>>>> MAC=fe:bb:83:28:01:02 - Success
>>>> 2021-04-21 07:43:09.453+0000: 2460: error : virNetDevBridgeAddPort:633
>>>> : Unable to add bridge virbr1 port vnet0: Operation not supported
>>>> 2021-04-21 07:43:09.466+0000: 2543: debug : udevHandleOneDevice:1695 :
>>>> udev action: 'add': /sys/devices/virtual/net/vnet0
>>>>
>>>> Christian
>>>>
>>>
>>> For reference:
>>>
>>> ae1ea84b33dab45c7b6c1754231ebda5959b504c is the first bad commit
>>> commit ae1ea84b33dab45c7b6c1754231ebda5959b504c
>>> Author: Florian Fainelli <f.fainelli@gmail.com>
>>> Date:   Wed Apr 14 22:22:57 2021 +0300
>>>
>>>     net: bridge: propagate error code and extack from br_mc_disabled_update
>>>        Some Ethernet switches might only be able to support disabling
>>> multicast
>>>     snooping globally, which is an issue for example when several bridges
>>>     span the same physical device and request contradictory settings.
>>>        Propagate the return value of br_mc_disabled_update() such that this
>>>     limitation is transmitted correctly to user-space.
>>>        Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>     Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>>     Signed-off-by: David S. Miller <davem@davemloft.net>
>>>
>>> net/bridge/br_multicast.c | 28 +++++++++++++++++++++-------
>>> net/bridge/br_netlink.c   |  4 +++-
>>> net/bridge/br_private.h   |  3 ++-
>>> net/bridge/br_sysfs_br.c  |  8 +-------
>>> 4 files changed, 27 insertions(+), 16 deletions(-)
>>>
>>> not sure if it matters this is on s390.
>>> A simple reproducer is virt-install, e.g.
>>> virt-install --name test --disk size=12 --memory=2048 --vcpus=2
>>> --location
>>> http://ports.ubuntu.com/ubuntu-ports/dists/bionic/main/installer-s390x/
>>
>> Thanks, I will kick off a reproducer and let you know.
>> -- 
>> Florian
> 
> Hey, you guys are moving fast, faster than it took me to open my email client...
> 
> Sorry for the breakage, Christian, I've just sent a patch with what I
> think is wrong, could you give it a try?

Yes, this fixes the issue. I answered on the patch.
