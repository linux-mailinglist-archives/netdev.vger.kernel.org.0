Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2902CCAB9
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 00:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgLBXvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 18:51:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6898 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727773AbgLBXvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 18:51:43 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2NX97R025507;
        Wed, 2 Dec 2020 18:51:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=awwsz0WgE267gBHpNikIBP3apkg2y//HaIjvVRvItzo=;
 b=G2SS1qSIAkfSK/PcWmg1sk6Zyxc2alS+eMI9m5YicJMhXM0AA9XpY3HB38T2/hN+RuNw
 5I/G5aW1cxNjRENuTB6Y30WxKrg2kk1T6bKEAoQKSo5etqsDT0OtIO+IJr+CvlMyDi8Q
 SPASlCl+NGfgfdc/73MicwNjIfHb0uhAmEF1KVXOQZUW+S9TIwIHP6vyx8oAwzJbYtYB
 wITUpPBzG+UiprltBVXY9H/qCzDOis+AZugI9XgK/rDuR1+0EkWTCqNKTBShALowV1m3
 7vz5zvCl4xWIP4R+dKeYkkTRQMxkq4IDi+ZcD/eigRM9KmkUHCORGquMlfheTsCm32qR gQ== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 356jfrun63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 18:51:00 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B2NgQWe028975;
        Wed, 2 Dec 2020 23:51:00 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 353e69n8yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 23:50:59 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B2NoxWt3605110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Dec 2020 23:50:59 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23EE8B2066;
        Wed,  2 Dec 2020 23:50:59 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9213B205F;
        Wed,  2 Dec 2020 23:50:58 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  2 Dec 2020 23:50:58 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 02 Dec 2020 15:50:58 -0800
From:   Dany Madden <drt@linux.ibm.com>
To:     drt@linux.ibm.com
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        sukadev@linux.ibm.com, ljp@linux.ibm.com
Subject: Re: [PATCH net-next v2] ibmvnic: process HMC disable command
In-Reply-To: <b4177b1aa6eaaab4a77f96fb272714cb@imap.linux.ibm.com>
References: <20201123235841.6515-1-drt@linux.ibm.com>
 <20201125130855.7eb08d0f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a0d2426ed35a02e14882bd1ce51e4e8e@imap.linux.ibm.com>
 <75f4529be5cfab14ec2b0decf47dcd86@imap.linux.ibm.com>
 <b4177b1aa6eaaab4a77f96fb272714cb@imap.linux.ibm.com>
Message-ID: <270f309212915ad2b4a0513222039f20@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_14:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1011 mlxlogscore=771
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020142
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-02 12:02, drt wrote:
> On 2020-11-30 10:19, drt wrote:
>> On 2020-11-25 15:55, drt wrote:
>>> On 2020-11-25 13:08, Jakub Kicinski wrote:
>>>> On Mon, 23 Nov 2020 18:58:41 -0500 Dany Madden wrote:
>>>>> Currently ibmvnic does not support the "Disable vNIC" command from
>>>>> the Hardware Management Console. The HMC uses this command to 
>>>>> disconnect
>>>>> the adapter from the network if the adapter is misbehaving or 
>>>>> sending
>>>>> malicious traffic. The effect of this command is equivalent to 
>>>>> setting
>>>>> the link to the "down" state on the linux client.
>>>>> 
>>>>> Enable support in ibmvnic driver for the Disable vNIC command.
>>>>> 
>>>>> Signed-off-by: Dany Madden <drt@linux.ibm.com>
>>>> 
>>>> It seems that (a) user looking at the system where NIC was disabled 
>>>> has
>>>> no idea why netdev is not working even tho it's UP, and (b) AFAICT
>>>> nothing prevents the user from bringing the device down and back up
>>>> again.
>>> 
>>> User would see the interface as DOWN. ibmvnic_close() requests the
>>> vnicserver to do a link down. The vnicserver responds with a link
>>> state indication CRQ message with logical link down, client would 
>>> then
>>> do netif_carrier_off().
>>> 
>>> You are correct, nothing is preventing the user from bringing the
>>> device back online.
>>> 
>>>> 
>>>> You said this is to disable misbehaving and/or sending malicious 
>>>> vnic,
>>>> obviously the guest can ignore the command so it's not very 
>>>> dependable,
>>>> anyway.
>>> 
>>> Without this patch, ibmvnic would ignore the command. With this 
>>> patch,
>>> it will handle the disable command from the HMC. If the guest insists
>>> on being bad, the HMC does have the ability to remove vnic adapter
>>> from the guest.
>>> 
>>>> 
>>>> Would it not be sufficient to mark the carrier state as down to cut 
>>>> the
>>>> vnic off?
>>> Essentially, this is what ibmvnic_disable does.
>> 
>> Hello Jakub, did I address your concern? If not, please let me know.
> 
> Hello Jakub,
> 
> I am pulling this patch. Suka pointed out that rwi lock is not being
> held when it walks the rwi_list, also the reset bit is incorrectly
> checked. We will send a v3.
> 
> Apologize for any inconvenient.

It appears that my email is not showing up in the mailing archive 
because of email aliases. I hope this is going thru.

Please do not commit this patch.

> 
> thanks you!
> Dany
>> 
>> Thanks!
