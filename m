Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D3135F4E4
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 15:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbhDNNep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 09:34:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26968 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351396AbhDNNeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 09:34:15 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13EDXG7t194047;
        Wed, 14 Apr 2021 09:33:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ngLSvQGZtI7+pCWk1xuOSQXhwRIcc9dTj32V7JsQXQc=;
 b=lkXAvvfArOZsaqx5CwKqKmbdKfnkcmIRHJsL22HGrJQ5ZtQZWz+xmflcPYWsymS6xDb4
 mKgnajNmgkirBswRqSe8H8Sz3aDdXm1WxG2NJWNdt//Nzwh2IlOSzF2jt6xYOiXHq7yL
 cV0ltewMB1FqcLAw4ZYcHun1id0y+/ub3++9hG6dbgBVm5bR41uyIlFRPM5WayOHjEoN
 yp1uth8U/DondvvRt5kwiB6hCiaLcbildEloD8Law1MxRAq54tuZ9MpUVIWYPVeOjvZl
 95bVC6mv4OT7S0JxwwbEaub87/hhcD4TsUZUobL6Xx1JvLHHHTmsHZ+2aMfOzL/rhCqk sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37wwn1xkd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 09:33:49 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13EDXKXr194616;
        Wed, 14 Apr 2021 09:33:48 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37wwn1xkcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 09:33:48 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13EDXkcZ019483;
        Wed, 14 Apr 2021 13:33:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 37u3n8bas0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 13:33:46 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13EDXiex30933478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 13:33:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2A114203F;
        Wed, 14 Apr 2021 13:33:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CBD442045;
        Wed, 14 Apr 2021 13:33:43 +0000 (GMT)
Received: from [9.145.63.72] (unknown [9.145.63.72])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 14 Apr 2021 13:33:43 +0000 (GMT)
Subject: Re: [PATCH net v1] lan743x: fix ethernet frame cutoff issue
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210409003904.8957-1-TheSven73@gmail.com>
 <0bf00feb-a588-12e1-d606-4a5d7d45e0b3@linux.ibm.com>
 <CAGngYiXyQEui8+OiVQXe1UeypQvny_hr=qtuOri7r2guxVDm9g@mail.gmail.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <089f6b41-29ee-7a4a-dde0-c2d5de2534bf@linux.ibm.com>
Date:   Wed, 14 Apr 2021 15:33:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <CAGngYiXyQEui8+OiVQXe1UeypQvny_hr=qtuOri7r2guxVDm9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FAUZdK9IcihFH3p2XdWjgL6wPPNk4Ed8
X-Proofpoint-ORIG-GUID: sXhPc0r6wgvYl7E3xPlZtcMsrol1SrcM
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_07:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.04.21 15:19, Sven Van Asbroeck wrote:
> Hi Julian,
> 
> On Wed, Apr 14, 2021 at 8:53 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:
>>
>> On a cursory glance, using __netdev_alloc_skb_ip_align() here should
>> allow you to get rid of all the RX_HEAD_PADDING gymnastics.
>>
>> And also avoid the need for setting RX_CFG_B_RX_PAD_2_, as the
>> NET_IP_ALIGN part would no longer get dma-mapped.
> 
> That's an excellent suggestion, and I'll definitely keep that in mind
> for the future.
> 
> In this case, I'm not sure if it could work. This NIC has multi-buffer
> frames. The dma-ed skbs represent frame fragments. A flag in the
> descriptor ring indicates if an skb is "first". If first, we can
> reserve the padding. Otherwise, we cannot. because that would corrupt
> a fragment in the middle. At the time of skb allocation, we do not
> know whether that skb will be "first".
> 

__netdev_alloc_skb_ip_align() already reserves the NET_IP_ALIGN part.
So when the NIC stores into the dma-mapped skb->data parts, each
fragment will automatically have the required alignment - even when
you only care about the first fragment's alignment.

> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/microchip/lan743x_main.c?h=v5.12-rc7#n2125
> 
> Maybe I'm missing a trick here? Feel free to suggest improvements,
> it's always much appreciated.
> 
> Sven
> 

