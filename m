Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1B0275E1B
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgIWRBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:01:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30512 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726342AbgIWRBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 13:01:42 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NH1Ybi039636;
        Wed, 23 Sep 2020 13:01:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hKDbefOQarTj7YrT/ldi1Z3CfTDgUTsZi0+cHmSD3as=;
 b=Ji8NC14vfo/Xu9KF6Y+6OKFOFzObliAVetbYj+jVrE3OWvFBqDlA7XffJhwYKGdE1s6C
 egjrKEwtX0dFgdbMpDhI5YFntNNk1Clqlq4yFUYp/Vt8GBjflhFMwfWwUvkWTHlItm5d
 a6+UHg5qUhIxF5LEigNeNQtDgFGLNf7a3Nje+Y1B/dvHF6LpZ/mFlrV295Rqo8+VE4ha
 7TLIDDhrEaQC0LVosBu/McA8H30XxMrfUIS+oe9cFp5y0SS/p6K+PQsVyFCFQ7URNO8a
 hqaPCBrW03S9YRDARgrvV9YIXAi5jD5SjbIQvRI7BVv8G00HS2sA5jipipoG2fsqtx4B kA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33r7ws5bf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 13:01:36 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08NGs1RJ029364;
        Wed, 23 Sep 2020 17:01:17 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma05wdc.us.ibm.com with ESMTP id 33n9m99jjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 17:01:17 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08NH1GSo53936524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 17:01:16 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8330D28059;
        Wed, 23 Sep 2020 17:01:16 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0774128065;
        Wed, 23 Sep 2020 17:01:16 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.81.245])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 17:01:15 +0000 (GMT)
Subject: Re: Exposing device ACL setting through devlink
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com
References: <e7f76581-8525-2b98-ec4d-e772db692318@linux.ibm.com>
 <20200904083141.GE2997@nanopsycho.orion>
 <20200904153751.17ad4b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7e4c2c8f-a5b0-799c-3083-cfefcf37bf10@linux.ibm.com>
 <20200910070016.GT2997@nanopsycho.orion>
 <f4d3923c-958c-c0b4-6aa3-f2500d4967e9@linux.ibm.com>
 <20200918072054.GA2323@nanopsycho.orion>
 <0bdb48e1-171b-3ec6-c993-0499639d0fc4@linux.ibm.com>
 <20200920152136.GB2323@nanopsycho.orion>
 <20200921133704.5ad64b6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <447a0b01-bd40-35f5-cdfc-babdc2a968e5@linux.ibm.com>
Date:   Wed, 23 Sep 2020 12:01:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200921133704.5ad64b6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_12:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/21/20 3:37 PM, Jakub Kicinski wrote:
> On Sun, 20 Sep 2020 17:21:36 +0200 Jiri Pirko wrote:
>>> Yes, this the filtering is done on a virtual switch in Power firmware. I am
>>> really just trying to report the ACL list's configured at the firmware level
>>> to users on the guest OS.
>> We have means to model switches properly in linux and offload to them.
>> I advise you to do that.
> I think it may have gotten lost in the conversation, but Tom is after
> exposing the information to the client side of the switch. AFAIU we
> don't have anything like that right now, perhaps the way to go is to
> expose enum devlink_port_function_attr on the client side?
>
> Still - it feels hacky when I think about it.
>
> IMHO kernel device APIs are not the place to expose network config.
> It's not like MVRP results pop up as a netdev attribute.
>
> Tomorrow Amazon, Google, and all other cloud providers will want to
> expose some other info, and we'll have to worry about how to make it
> common, drawing the lines, reviewing etc.
>
> Tom, is there no way higher layer (cloud) APIs can be used to
> communicate this information to the guest?

None that I know of, Jakub. As far as I know, this information can only 
be retrieved through the device driver if the user only has access to 
the guest.

Tom

