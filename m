Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8DC46B6A1
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbhLGJJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:09:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233462AbhLGJJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:09:12 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B78r1ni019052;
        Tue, 7 Dec 2021 09:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=02DrWvFjbCauMP4je+B1W+dHpDyLvHEQLl8OueYWzd4=;
 b=fb/eh0Q/MEAt3puptZitujyHy0xSINGAEKVKB/QrLdPGFxx+o5C9VqkHnIWun6agV0VR
 HTF3bSloo7KPVhYphxO2WQM/Stc+93Zx+MgFii6R2W+2qc+HhzEIjvW3rQAe9P/0cA7H
 1LK5gGHaUktfvnVQH2GlcOxyflv2wG/Kyk+12L2n5a9JyJBzJcWkkT19Sx4Og9HE75AD
 HBfqF63AHAMszM8t+jyqn56YiMMUMmUEQ1PVbZ5WtWJlUu0S+xPbhz0QLTN+MrirhxjN
 S3AMd56MGAPlBhSK4Tlv8qlUIjgJiUZ84gGvGV9DPSiWtcDNKRmQoKphDO550orPDI8e Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ct1sdknv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:37 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B78HkMW010577;
        Tue, 7 Dec 2021 09:05:37 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ct1sdknub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:37 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B792m2B007268;
        Tue, 7 Dec 2021 09:05:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3cqyy9bfee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:05:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B78vmCK28574000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 08:57:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F5AD11C06F;
        Tue,  7 Dec 2021 09:05:29 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48F2D11C073;
        Tue,  7 Dec 2021 09:05:28 +0000 (GMT)
Received: from [9.171.30.218] (unknown [9.171.30.218])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 09:05:28 +0000 (GMT)
Message-ID: <c6699aa1-09bf-6f3f-1627-b89d1db073e7@linux.ibm.com>
Date:   Tue, 7 Dec 2021 11:05:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net] ethtool: do not perform operations on net devices
 being unregistered
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        alexander.duyck@gmail.com, mkubecek@suse.cz, netdev@vger.kernel.org
References: <20211203101318.435618-1-atenart@kernel.org>
 <07f2df6c-d7e5-9781-dae4-b0c2411c946c@linux.ibm.com>
 <20211206071520.1fe7e18b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
In-Reply-To: <20211206071520.1fe7e18b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7pqoEbZ0LG43vrIiK1kN_Xbm3jA6YHhZ
X-Proofpoint-ORIG-GUID: iYJrBPEzhawHhl5BM3dfg8EjHe9Gv0ZV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_03,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.12.21 17:15, Jakub Kicinski wrote:
> On Mon, 6 Dec 2021 11:46:35 +0200 Julian Wiedmann wrote:
>> On 03.12.21 12:13, Antoine Tenart wrote:
>>> There is a short period between a net device starts to be unregistered
>>> and when it is actually gone. In that time frame ethtool operations
>>> could still be performed, which might end up in unwanted or undefined
>>> behaviours[1].
>>>
>>> Do not allow ethtool operations after a net device starts its
>>> unregistration. This patch targets the netlink part as the ioctl one
>>> isn't affected: the reference to the net device is taken and the
>>> operation is executed within an rtnl lock section and the net device
>>> won't be found after unregister.
>>> [...]
>>> +++ b/net/ethtool/netlink.c
>>> @@ -40,7 +40,8 @@ int ethnl_ops_begin(struct net_device *dev)
>>>  	if (dev->dev.parent)
>>>  		pm_runtime_get_sync(dev->dev.parent);
>>>  
>>> -	if (!netif_device_present(dev)) {
>>> +	if (!netif_device_present(dev) ||
>>> +	    dev->reg_state == NETREG_UNREGISTERING) {
>>>  		ret = -ENODEV;
>>>  		goto err;
>>>  	}
>>>   
>>
>> Wondering if other places would also benefit from a netif_device_detach()
>> in the unregistration sequence ...
> 
> Sounds like a good idea but maybe as a follow up to net-next? 
> The likelihood of that breaking things is low, but non-zero.
> 

Oh absolutely, only via net-next.
