Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B50B2AEE96
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 11:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgKKKNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 05:13:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726725AbgKKKN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 05:13:28 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ABA1Aap132528;
        Wed, 11 Nov 2020 05:13:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZGyhlyiYifkLV/TgqfNMbKgbufi/lc8BlaPt1/lyDFY=;
 b=YSKR4mbAAku59VvKYFUzXTPYKavAih8mNaYDmlRotPIeKNCJ79SnIN5rZSz3RC+NhjCK
 UkXQQhQwXEN+6hMfen3m7TEvXFvA2OQsUagMMzY3wpN09ECGqqJ3OBiQknLkoTrJBrXE
 dp0jUya0/ZmQROR0Uct2RX9JZRPpWLa56yKAU4H6w5TSs0BIWhnjjubWg/2GPnDVNpUI
 uff8/QWd4yrYmOBFHyP433xkwp7p9uVAmYOKsO+uCCbPOpuLHl5Wn9F8kfoS9h+mfXz3
 KTv2We5rgyXgTjZgkw1nAb9iVtQDEZgzYYCePmJ6fm2j7z6nF+4XOKFifQOAKtzUtwD9 SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34r384rpjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Nov 2020 05:13:09 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ABA44j8150664;
        Wed, 11 Nov 2020 05:13:08 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34r384rpj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Nov 2020 05:13:08 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ABAD765011863;
        Wed, 11 Nov 2020 10:13:07 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 34nk78a4hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Nov 2020 10:13:06 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ABAD44d4522620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 10:13:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1D7411C04C;
        Wed, 11 Nov 2020 10:13:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FC5611C066;
        Wed, 11 Nov 2020 10:13:04 +0000 (GMT)
Received: from Alexandras-MBP.fritz.box (unknown [9.145.12.245])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Nov 2020 10:13:04 +0000 (GMT)
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: listen for
 SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
To:     Vladimir Oltean <olteanv@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
From:   Alexandra Winter <wintera@linux.ibm.com>
Message-ID: <c35d48cd-a1ea-7867-a125-0f900e1e8808@linux.ibm.com>
Date:   Wed, 11 Nov 2020 11:13:03 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201108172355.5nwsw3ek5qg6z7yx@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-11_02:2020-11-10,2020-11-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 impostorscore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110052
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08.11.20 18:23, Vladimir Oltean wrote:
> On Sun, Nov 08, 2020 at 10:09:25PM +0800, DENG Qingfang wrote:
>> Can it be turned off for switches that support SA learning from CPU?
> 
> Is there a good reason I would add another property per switch and not
> just do it unconditionally?
> 
I have a similar concern for a future patch, where I want to turn on or off, whether the
device driver listens to SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE for a certain interface.
(Options will be: static MACs only, learning in the device or learning in bridge and notifications to device)
What about 'bridge link set dev $netdev learning_sync on self' respectively the corresponding netlink message?
