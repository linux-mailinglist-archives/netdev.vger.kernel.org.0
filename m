Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C856326E741
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 23:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIQVRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 17:17:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33174 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgIQVRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 17:17:52 -0400
X-Greylist: delayed 2770 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 17:17:51 EDT
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HKVYul106387;
        Thu, 17 Sep 2020 16:31:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=x0PCALOWsgiw7nHSMa6cDtM+fttuYQs3TpJPDxmAOGQ=;
 b=XslhrVW2aXNiSCghymXT+oy1t0MCOJaZ0sFGXdc8HSZY/eUBJ9jS8uGp4m0/sn6yiYr4
 qDo6y8fxZuEvRW+e1Wm8oglZigowG+5xUcG3dU2r8ie54+w/n9t+yuRaToueLL2nWoSG
 WnoDV/tcu/WFz1oxVW7e5XAIF+v1jowb7qJPJ8/tjg9gQhjQqr6dWkiiGwlLvZRldUvS
 TGimmBDTOrFcHQZPaJzU4QPIwNGPwFUO2KB2CpbW2bbvMAa3vWDF6T1aLOGwxm2tJ7db
 2DUJojynJEMh0To0GD/S0H6YHlCJQGXgjh2XXshlGkobKwVGrJWAQYnSU7eSXTj2Xbov OA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33mda6ambm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 16:31:36 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08HKQQP6004784;
        Thu, 17 Sep 2020 20:31:12 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 33k6594jp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 20:31:12 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08HKVBFO33423642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 20:31:12 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8499AE063;
        Thu, 17 Sep 2020 20:31:11 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D4D6AE05F;
        Thu, 17 Sep 2020 20:31:11 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.243.76])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 17 Sep 2020 20:31:11 +0000 (GMT)
Subject: Re: Exposing device ACL setting through devlink
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com
References: <e7f76581-8525-2b98-ec4d-e772db692318@linux.ibm.com>
 <20200904083141.GE2997@nanopsycho.orion>
 <20200904153751.17ad4b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7e4c2c8f-a5b0-799c-3083-cfefcf37bf10@linux.ibm.com>
 <20200910070016.GT2997@nanopsycho.orion>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <f4d3923c-958c-c0b4-6aa3-f2500d4967e9@linux.ibm.com>
Date:   Thu, 17 Sep 2020 15:31:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200910070016.GT2997@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_17:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxlogscore=593 adultscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170146
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/10/20 2:00 AM, Jiri Pirko wrote:
> Tue, Sep 08, 2020 at 08:27:13PM CEST, tlfalcon@linux.ibm.com wrote:
>> On 9/4/20 5:37 PM, Jakub Kicinski wrote:
>>> On Fri, 4 Sep 2020 10:31:41 +0200 Jiri Pirko wrote:
>>>> Thu, Sep 03, 2020 at 07:59:45PM CEST, tlfalcon@linux.ibm.com wrote:
>>>>> Hello, I am trying to expose MAC/VLAN ACL and pvid settings for IBM
>>>>> VNIC devices to administrators through devlink (originally through
>>>>> sysfs files, but that was rejected in favor of devlink). Could you
>>>>> give any tips on how you might go about doing this?
>>>> Tom, I believe you need to provide more info about what exactly do you
>>>> need to setup. But from what you wrote, it seems like you are looking
>>>> for bridge/tc offload. The infra is already in place and drivers are
>>>> implementing it. See mlxsw for example.
>>> I think Tom's use case is effectively exposing the the VF which VLANs
>>> and what MAC addrs it can use. Plus it's pvid. See:
>>>
>>> https://www.spinics.net/lists/netdev/msg679750.html
>> Thanks, Jakub,
>>
>> Right now, the use-case is to expose the allowed VLAN's and MAC addresses and
>> the VF's PVID. Other use-cases may be explored later on though.
> Who is configuring those?
>
> What does mean "allowed MAC address"? Does it mean a MAC address that VF
> can use to send packet as a source MAC?
>
> What does mean "allowed VLAN"? VF is sending vlan tagged frames and only
> some VIDs are allowed.
>
> Pardon my ignorance, this may be routine in the nic world. However I
> find the desc very vague. Please explain in details, then we can try to
> find fitting solution.
>
> Thanks!

These MAC or VLAN ACL settings are configured on the Power Hypervisor.

The rules for a VF can be to allow or deny all MAC addresses or VLAN 
ID's or to allow a specified list of MAC address and VLAN ID's. The 
interface allows or denies frames based on whether the ID in the VLAN 
tag or the source MAC address is included in the list of allowed VLAN 
ID's or MAC addresses specified during creation of the VF.

Thanks for your help,

Tom

