Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343EA2B3E3F
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 09:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgKPICx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 03:02:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23576 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727731AbgKPICw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 03:02:52 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AG7XFlT150281;
        Mon, 16 Nov 2020 03:02:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=moASLWAKrNxqe/J9x1OwqewY4ObBALR9kK+SaBGWa5k=;
 b=F/IdgHIic+0sXqSQty+8161ahlOHE6u7zAuvkr9o6j2Qvo/ONkeAjiXrFKijo2+HGmnt
 VrJjTHTiRxruUNjXx9XcmpO4T6M43JnfOvm+92MacrDZQ/PkASqc9i+YEYNag2zG3vsz
 iqawfhQolzn+jzD0PMrROAgNFfuNYclorQRElRbWFxVguFATRYEyBJ7aOU2eZQ6Jnk29
 4mdSD7AiVPTLbQUN7eUuYiQkg+y4m0/oBnklEt2be4tJIDTnUVtt+RLM9TrC4YfKHLJp
 AH0/4nNdEV8mn1Gax0lWK1py9G2ZfAonUneG8wiczhScXiXHOUCSTsabYhV4Qj+L5u3Y jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34uet1qvu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 03:02:38 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AG7Y1n7156646;
        Mon, 16 Nov 2020 03:02:37 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34uet1qvsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 03:02:37 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AG82RgH015440;
        Mon, 16 Nov 2020 08:02:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 34t6v80xjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 08:02:34 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AG82Vxg53674364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 08:02:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE725A417A;
        Mon, 16 Nov 2020 08:02:30 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AE12A416B;
        Mon, 16 Nov 2020 08:02:30 +0000 (GMT)
Received: from Alexandras-MBP.fritz.box (unknown [9.145.23.221])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Nov 2020 08:02:30 +0000 (GMT)
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: listen for
 SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
References: <20201108131953.2462644-1-olteanv@gmail.com>
 <20201108131953.2462644-4-olteanv@gmail.com>
 <CALW65jb+Njb3WkY-TUhsHh1YWEzfMcXoRAXshnT8ke02wc10Uw@mail.gmail.com>
 <20201108172355.5nwsw3ek5qg6z7yx@skbuf>
 <c35d48cd-a1ea-7867-a125-0f900e1e8808@linux.ibm.com>
 <20201111103601.67kqkaphgztoifzl@skbuf>
 <dd9c1f37-a049-ef69-b915-214c869edb51@linux.ibm.com>
 <20201112134910.jpbfrjfwlb3734im@skbuf>
From:   Alexandra Winter <wintera@linux.ibm.com>
Message-ID: <e8aa4a48-b8b2-99e1-b308-b54adb5f0dc4@linux.ibm.com>
Date:   Mon, 16 Nov 2020 09:02:29 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201112134910.jpbfrjfwlb3734im@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_02:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011160043
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12.11.20 14:49, Vladimir Oltean wrote:
> On Wed, Nov 11, 2020 at 03:14:26PM +0100, Alexandra Winter wrote:
>> On 11.11.20 11:36, Vladimir Oltean wrote:
>>> Hi Alexandra,
>>>
>>> On Wed, Nov 11, 2020 at 11:13:03AM +0100, Alexandra Winter wrote:
>>>> On 08.11.20 18:23, Vladimir Oltean wrote:
>>>>> On Sun, Nov 08, 2020 at 10:09:25PM +0800, DENG Qingfang wrote:
>>>>>> Can it be turned off for switches that support SA learning from CPU?
>>>>>
>>>>> Is there a good reason I would add another property per switch and not
>>>>> just do it unconditionally?
>>>>>
>>>> I have a similar concern for a future patch, where I want to turn on or off, whether the
>>>> device driver listens to SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE for a certain interface.
>>>> (Options will be: static MACs only, learning in the device or learning in bridge and notifications to device)
>>>> What about 'bridge link set dev $netdev learning_sync on self' respectively the corresponding netlink message?
>>>
>>> My understanding is that "learning_sync" is for pushing learnt addresses
>>> from device to bridge, not from bridge to device.
>>>
>> uh, sorry copy-paste error. I meant:
>> 'bridge link set dev $netdev learning on self'
> 
> Even with "learning" instead of "learning_sync", I don't understand what
> the "self" modifier would mean and how it would help, sorry.
> 
With the self modifier, the command is not executed by the linux bridge but instead sent to the device driver of the
respective bridgeport. So AFAIU 'learning on self' would mean, that instead of only the bridge doing the learning on this
bridgeport, the device itself should do the learning. Which sounds to me like a good fit for SA learning from CPU.

It seems that the self modifier is not used on hardware switches today, but rather on virtualized network cards, where
it is e.g. used ot turn VEPA mode on or off per virtual interface. In drivers/s390/net/qeth we use 'learning_sync on self',
to control whether a virtualized interface should synchronize the card's fdb with an attached linux bridge.
