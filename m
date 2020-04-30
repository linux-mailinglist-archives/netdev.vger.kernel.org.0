Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374E41C01E7
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgD3QQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:16:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726482AbgD3QQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 12:16:05 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UG2jMZ137070;
        Thu, 30 Apr 2020 12:14:50 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mggx4qa6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 12:14:49 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03UG4F0n143995;
        Thu, 30 Apr 2020 12:14:49 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mggx4q9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 12:14:49 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UGBFMj030783;
        Thu, 30 Apr 2020 16:14:48 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 30mcu7ac7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 16:14:47 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UGEjb411666122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 16:14:45 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5F47BE04F;
        Thu, 30 Apr 2020 16:14:46 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E6A5BE054;
        Thu, 30 Apr 2020 16:14:45 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.80.239.215])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 16:14:45 +0000 (GMT)
Subject: Re: [PATCH] net/bonding: Do not transition down slave after
 speed/duplex check
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
References: <1588183759-7659-1-git-send-email-tlfalcon@linux.ibm.com>
 <29484.1588185503@famine>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <c83cbc94-c567-3366-ffb7-043bd4bba5a9@linux.ibm.com>
Date:   Thu, 30 Apr 2020 11:14:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <29484.1588185503@famine>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_10:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/29/20 1:38 PM, Jay Vosburgh wrote:
> Thomas Falcon <tlfalcon@linux.ibm.com> wrote:
>
>> The following behavior has been observed when testing logical partition
>> migration of LACP-bonded VNIC devices in a PowerVM pseries environment.
>>
>> 1. When performing the migration, the bond master detects that a slave has
>>    lost its link, deactivates the LACP port, and sets the port's
>>    is_enabled flag to false.
>> 2. The slave device then updates it's carrier state to off while it resets
>>    itself. This update triggers a NETDEV_CHANGE notification, which performs
>>    a speed and duplex update. The device does not return a valid speed
>>    and duplex, so the master sets the slave link state to BOND_LINK_FAIL.
>> 3. When the slave VNIC device(s) are active again, some operations, such
>>    as setting the port's is_enabled flag, are not performed when transitioning
>>    the link state back to BOND_LINK_UP from BOND_LINK_FAIL, though the state
>>    prior to the speed check was BOND_LINK_DOWN.
> 	Just to make sure I'm understanding correctly, in regards to
> "the state prior to the speed check was BOND_LINK_DOWN," do you mean
> that during step 1, the slave link is set to BOND_LINK_DOWN, and then in
> step 2 changed from _DOWN to _FAIL?
>
>> Affected devices are therefore not utilized in the aggregation though they
>> are operational. The simplest way to fix this seems to be to restrict the
>> link state change to devices that are currently up and running.
> 	This sounds similar to an issue from last fall; can you confirm
> that you're running with a kernel that includes:
>
> 1899bb325149 bonding: fix state transition issue in link monitoring

It did not have that fix.  I will patch the kernel and rerun the test.

Thanks,

Tom

>
> 	-J
> 	
>
>> CC: Jay Vosburgh <j.vosburgh@gmail.com>
>> CC: Veaceslav Falico <vfalico@gmail.com>
>> CC: Andy Gospodarek <andy@greyhouse.net>
>> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
>> ---
>> drivers/net/bonding/bond_main.c | 3 ++-
>> 1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index 2e70e43c5df5..d840da7cd379 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -3175,7 +3175,8 @@ static int bond_slave_netdev_event(unsigned long event,
>> 		 * speeds/duplex are available.
>> 		 */
>> 		if (bond_update_speed_duplex(slave) &&
>> -		    BOND_MODE(bond) == BOND_MODE_8023AD) {
>> +		    BOND_MODE(bond) == BOND_MODE_8023AD &&
>> +		    slave->link == BOND_LINK_UP) {
>> 			if (slave->last_link_up)
>> 				slave->link = BOND_LINK_FAIL;
>> 			else
>> -- 
>> 2.18.2
>>
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
