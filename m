Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F8B2AF34A
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 15:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgKKOOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 09:14:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55306 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726579AbgKKOOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 09:14:47 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ABE4A6i000777;
        Wed, 11 Nov 2020 09:14:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cHXVAY0fd+tYs+jDZoHzFAggoj7yOsxXuwyonRI/dYw=;
 b=SE1IkHoxVCSy6JJipO3oqonK86ozKI5TAA8J+L2RAgPlrF0oXB9+z+zNXLdN6pVAYl4q
 mmzMB4k7htnuIvNwk3ao9dXcW1RTnD7CP0iOgpQNsLOLgB2PcQMiGGjdDWPy+4e2W76S
 E63wxFOHCQZ7ppB7AbNdMva8x+PX8nXa4gbZOn1B1uhVHh5qu7T24XqTCmpP99cZdn6S
 O+MVtLyBY9t+41YKAN5sgwlcUDkkPcVuVC3mibMWfYrUzswcrNw0J91QNY39rfVVbNd6
 bFJ/SY+n8eAyu2lBSf/Vbl0uI04/Qsk/q7AJcfKdMRGc6uatjPcKpgzucqwBvP6f/xzx 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34r6k0apy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Nov 2020 09:14:32 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ABE4W5r002814;
        Wed, 11 Nov 2020 09:14:32 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34r6k0apwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Nov 2020 09:14:32 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ABECCK9024073;
        Wed, 11 Nov 2020 14:14:29 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 34njuh4euq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Nov 2020 14:14:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ABEERdE10683020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 14:14:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76AD2A4062;
        Wed, 11 Nov 2020 14:14:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBD22A405F;
        Wed, 11 Nov 2020 14:14:26 +0000 (GMT)
Received: from Alexandras-MBP.fritz.box (unknown [9.145.163.254])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Nov 2020 14:14:26 +0000 (GMT)
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
From:   Alexandra Winter <wintera@linux.ibm.com>
Message-ID: <dd9c1f37-a049-ef69-b915-214c869edb51@linux.ibm.com>
Date:   Wed, 11 Nov 2020 15:14:26 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201111103601.67kqkaphgztoifzl@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-11_07:2020-11-10,2020-11-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110083
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11.11.20 11:36, Vladimir Oltean wrote:
> Hi Alexandra,
> 
> On Wed, Nov 11, 2020 at 11:13:03AM +0100, Alexandra Winter wrote:
>> On 08.11.20 18:23, Vladimir Oltean wrote:
>>> On Sun, Nov 08, 2020 at 10:09:25PM +0800, DENG Qingfang wrote:
>>>> Can it be turned off for switches that support SA learning from CPU?
>>>
>>> Is there a good reason I would add another property per switch and not
>>> just do it unconditionally?
>>>
>> I have a similar concern for a future patch, where I want to turn on or off, whether the
>> device driver listens to SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE for a certain interface.
>> (Options will be: static MACs only, learning in the device or learning in bridge and notifications to device)
>> What about 'bridge link set dev $netdev learning_sync on self' respectively the corresponding netlink message?
> 
> My understanding is that "learning_sync" is for pushing learnt addresses
> from device to bridge, not from bridge to device.
> 
uh, sorry copy-paste error. I meant:
'bridge link set dev $netdev learning on self'
