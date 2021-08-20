Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FE83F2814
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 10:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhHTIFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 04:05:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7222 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230363AbhHTIFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 04:05:09 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17K7XZNQ116411;
        Fri, 20 Aug 2021 04:02:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1LLkyb0PdFwV77Bc8XO1wRtPxe9DolzxOJdMvJ4iNHk=;
 b=XW0asrJQcXOMYsKkfGYpLykU467ZGg5kVEe743hTXMhgS8g0HA+0seRkYv0PyLErMC/O
 UdyKZqnSbYqkqUtyRSdLmhZ93F40SU8jkQQRMjPMOvP3q9TC7DYh0xiHN/rJvsAL6lQc
 gLHoXNtRfckoKt8oPw/P9ydY3GNX+qqbS/S5szxWWV2UU0QtYEZjq2VfzPUB1cFB7QHZ
 IMQ/uVxbdOG2yP7n3DYryKkg51EYrtLI09YZu3Uc+MwBm3qkYsIC6mQgJ4Iean9cOsz3
 vK1Kg0LCESiIPfsqpGwbPz2KdSLWrd/vjIBRJr5RfC4CooPb7ovknVLuxTGxGYeFk+Nc kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ahq0wctsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 04:02:32 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17K7XYM4116404;
        Fri, 20 Aug 2021 04:02:32 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ahq0wctrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 04:02:32 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17K82QkQ030819;
        Fri, 20 Aug 2021 08:02:30 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3ae5f8hdpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 08:02:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17K82P3d35127578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 08:02:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33DC942079;
        Fri, 20 Aug 2021 08:02:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEAB042063;
        Fri, 20 Aug 2021 08:02:24 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.53.209])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Aug 2021 08:02:24 +0000 (GMT)
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
To:     Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
References: <20210813203026.27687-1-rdunlap@infradead.org>
 <20210816210914.qkyd4em4rw3thbyg@bsd-mbp.dhcp.thefacebook.com>
 <16acf1ad-d626-b3a3-1cad-3fa6c61c8a22@infradead.org>
 <20210816214103.w54pfwcuge4nqevw@bsd-mbp.dhcp.thefacebook.com>
 <0e6bd492-a3f5-845c-9d93-50f1cc182a62@infradead.org>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <72ffff17-0b46-c12e-2f67-1a18bdcb8532@de.ibm.com>
Date:   Fri, 20 Aug 2021 10:02:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0e6bd492-a3f5-845c-9d93-50f1cc182a62@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SIESr2GvgPMdtbZVD_6xpbsNh5XNr4qv
X-Proofpoint-ORIG-GUID: B8vkqK7dSXHVtszFwyGUHu48KrFyfRYj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-20_03:2021-08-20,2021-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1011 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108200043
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20.08.21 00:58, Randy Dunlap wrote:
> On 8/16/21 2:41 PM, Jonathan Lemon wrote:
>> On Mon, Aug 16, 2021 at 02:15:51PM -0700, Randy Dunlap wrote:
>>> On 8/16/21 2:09 PM, Jonathan Lemon wrote:
>>>> On Fri, Aug 13, 2021 at 01:30:26PM -0700, Randy Dunlap wrote:
>>>>> There is no 8250 serial on S390. See commit 1598e38c0770.
>>>>
>>>> There's a 8250 serial device on the PCI card.   Its been
>>>> ages since I've worked on the architecture, but does S390
>>>> even support PCI?
>>>
>>> Yes, it does.

We do support PCI, but only a (very) limited amount of cards.
So there never will be a PCI card with 8250 on s390 and
I also doubt that we will see the "OpenCompute TimeCard"
on s390.

So in essence the original patch is ok but the patch below
would also be ok for KVM. But it results in a larger kernel
with code that will never be used. So I guess the original
patch is the better choice.

>>>
>>>>> Is this driver useful even without 8250 serial?
>>>>
>>>> The FB timecard has an FPGA that will internally parse the
>>>> GNSS strings and correct the clock, so the PTP clock will
>>>> work even without the serial devices.
>>>>
>>>> However, there are userspace tools which want to read the
>>>> GNSS signal (for holdolver and leap second indication),
>>>> which is why they are exposed.
>>>
>>> So what do you recommend here?
>>
>> Looking at 1598e38c0770, it appears the 8250 console is the
>> problem.  Couldn't S390 be fenced by SERIAL_8250_CONSOLE, instead
>> of SERIAL_8250, which would make the 8250 driver available?
> 
> OK, that sounds somewhat reasonable.
> 
>> For now, just disabling the driver on S390 sounds reasonable.
>>
> 
> S390 people, how does this look to you?
> 
> This still avoids having serial 8250 console conflicting
> with S390's sclp console.
> (reference commit 1598e38c0770)
> 
> 
> ---
>   drivers/tty/serial/8250/Kconfig |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20210819.orig/drivers/tty/serial/8250/Kconfig
> +++ linux-next-20210819/drivers/tty/serial/8250/Kconfig
> @@ -6,7 +6,6 @@
> 
>   config SERIAL_8250
>       tristate "8250/16550 and compatible serial support"
> -    depends on !S390
>       select SERIAL_CORE
>       select SERIAL_MCTRL_GPIO if GPIOLIB
>       help
> @@ -85,6 +84,7 @@ config SERIAL_8250_FINTEK
>   config SERIAL_8250_CONSOLE
>       bool "Console on 8250/16550 and compatible serial port"
>       depends on SERIAL_8250=y
> +    depends on !S390
>       select SERIAL_CORE_CONSOLE
>       select SERIAL_EARLYCON
>       help
> 
> 
