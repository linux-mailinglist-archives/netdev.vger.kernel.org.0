Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4806C270920
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 01:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgIRXUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 19:20:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27936 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725945AbgIRXUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 19:20:43 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08INKWwu004547;
        Fri, 18 Sep 2020 19:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yyvYMexInj1Mgpmb0UPC0fT+rJtVUr5KDuV5ZJNHJqY=;
 b=r2Qbo9ahFfoBu20R5E5QplZhW02ptWJvoOlIE5VtpjBD4jQOLBbxFM43wkvYSlz94m4Z
 aqjldpD+KiX4RO+H+DebseiSx9x5bzduamXEJN4U10kh3bMAjjVwzM2XVu7arcHXplsA
 N2I3MKdIIK2CcGMoheMkaUIat6YdgJQP8jieA+ZB91wf1t/e0huP8U4GF/lqQmhMa81k
 fgbTI1zMSC4yL01swRXvSekwHk/nPBi0kqfazbq3IWb5RJN/uHmSXztoaxuuYZvkRAZn
 17tn+320qi7ogS440B/eqRZqHZ+rOq2AYECceLrNIE2SpxC2Mfo+Z2bd23itBMukmkdF Qw== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33n6ftg05k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 19:20:38 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08INHrH8004135;
        Fri, 18 Sep 2020 23:20:37 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 33k6q1fdne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 23:20:37 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08INKVh851708196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 23:20:31 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A45646A047;
        Fri, 18 Sep 2020 23:20:36 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8CEC6A051;
        Fri, 18 Sep 2020 23:20:35 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.10.177])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 18 Sep 2020 23:20:35 +0000 (GMT)
Subject: Re: Exposing device ACL setting through devlink
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com
References: <e7f76581-8525-2b98-ec4d-e772db692318@linux.ibm.com>
 <20200904083141.GE2997@nanopsycho.orion>
 <20200904153751.17ad4b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7e4c2c8f-a5b0-799c-3083-cfefcf37bf10@linux.ibm.com>
 <20200910070016.GT2997@nanopsycho.orion>
 <f4d3923c-958c-c0b4-6aa3-f2500d4967e9@linux.ibm.com>
 <20200918072054.GA2323@nanopsycho.orion>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <0bdb48e1-171b-3ec6-c993-0499639d0fc4@linux.ibm.com>
Date:   Fri, 18 Sep 2020 18:20:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200918072054.GA2323@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-18_18:2020-09-16,2020-09-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 suspectscore=0 phishscore=0
 adultscore=0 spamscore=0 clxscore=1015 mlxlogscore=787 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180179
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/18/20 2:20 AM, Jiri Pirko wrote:
> Thu, Sep 17, 2020 at 10:31:10PM CEST, tlfalcon@linux.ibm.com wrote:
>> On 9/10/20 2:00 AM, Jiri Pirko wrote:
>>> Tue, Sep 08, 2020 at 08:27:13PM CEST, tlfalcon@linux.ibm.com wrote:
>>>> On 9/4/20 5:37 PM, Jakub Kicinski wrote:
>>>>> On Fri, 4 Sep 2020 10:31:41 +0200 Jiri Pirko wrote:
>>>>>> Thu, Sep 03, 2020 at 07:59:45PM CEST, tlfalcon@linux.ibm.com wrote:
>>>>>>> Hello, I am trying to expose MAC/VLAN ACL and pvid settings for IBM
>>>>>>> VNIC devices to administrators through devlink (originally through
>>>>>>> sysfs files, but that was rejected in favor of devlink). Could you
>>>>>>> give any tips on how you might go about doing this?
>>>>>> Tom, I believe you need to provide more info about what exactly do you
>>>>>> need to setup. But from what you wrote, it seems like you are looking
>>>>>> for bridge/tc offload. The infra is already in place and drivers are
>>>>>> implementing it. See mlxsw for example.
>>>>> I think Tom's use case is effectively exposing the the VF which VLANs
>>>>> and what MAC addrs it can use. Plus it's pvid. See:
>>>>>
>>>>> https://www.spinics.net/lists/netdev/msg679750.html
>>>> Thanks, Jakub,
>>>>
>>>> Right now, the use-case is to expose the allowed VLAN's and MAC addresses and
>>>> the VF's PVID. Other use-cases may be explored later on though.
>>> Who is configuring those?
>>>
>>> What does mean "allowed MAC address"? Does it mean a MAC address that VF
>>> can use to send packet as a source MAC?
>>>
>>> What does mean "allowed VLAN"? VF is sending vlan tagged frames and only
>>> some VIDs are allowed.
>>>
>>> Pardon my ignorance, this may be routine in the nic world. However I
>>> find the desc very vague. Please explain in details, then we can try to
>>> find fitting solution.
>>>
>>> Thanks!
>> These MAC or VLAN ACL settings are configured on the Power Hypervisor.
>>
>> The rules for a VF can be to allow or deny all MAC addresses or VLAN ID's or
>> to allow a specified list of MAC address and VLAN ID's. The interface allows
>> or denies frames based on whether the ID in the VLAN tag or the source MAC
>> address is included in the list of allowed VLAN ID's or MAC addresses
>> specified during creation of the VF.
> At which point are you doing this ACL? Sounds to me, like this is the
> job of "a switch" which connects VFs and physical port. Then, you just
> need to configure this switch to pass/drop packets according to match.
> And that is what there is already implemented with TC-flower/u32 + actions
> and bridge offload.
>
Yes, this the filtering is done on a virtual switch in Power firmware. I 
am really just trying to report the ACL list's configured at the 
firmware level to users on the guest OS.

Tom

>> Thanks for your help,
>>
>> Tom
>>
