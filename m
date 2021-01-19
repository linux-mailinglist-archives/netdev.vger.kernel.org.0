Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6072FBEAF
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 19:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392104AbhASSQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 13:16:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392433AbhASSPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 13:15:46 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JI2AjH191920;
        Tue, 19 Jan 2021 13:14:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=+jRQ4MLeCEyfxgyBDiWRUBdmyqZZjWjMFGyfxcSxzqo=;
 b=Cp+o6tyLMeYzyUd83MTdy9uKFkAP1y0DOSJK4rZiqo0zjbjdzZrRpPXDmDQw0pM/Vzvn
 9UmwzLDX5jlljUywLp4XsilBgCF0udhya3yc3fsTiCHTVDySYJAnjtgOHSB+fKTmWvqK
 /zo3wWOr6Z8xtWXS0dL4e8I2HASQeWr3yMk13g9Ik7n7tvXw+uBRBwLNTtHURkcPC8MM
 KY30VeUYBBQWWaeae7Mt56VkxKPWfguEyRd2YshrOkDVgxC7VTljLoWnTulYuCT1qJct
 6mG5/AEj6EbFd3n+HU7SpOkmfs015kaFO4j+8D9ew5eeiGf4L/ijZ2UkHIxReLxL0uAd KQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3664780mjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 13:14:29 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JIELbG007164;
        Tue, 19 Jan 2021 18:14:28 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 363qs904qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 18:14:28 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JIERWG26870260
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:14:27 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 145787805E;
        Tue, 19 Jan 2021 18:14:27 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 487AE7805C;
        Tue, 19 Jan 2021 18:14:26 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 18:14:26 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 19 Jan 2021 10:14:25 -0800
From:   Dany Madden <drt@linux.ibm.com>
To:     =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Lijun Pan <ljp@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Juliet Kim <julietk@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel@pengutronix.de
Subject: Re: ibmvnic: Race condition in remove callback
In-Reply-To: <20210117101242.dpwayq6wdgfdzirl@pengutronix.de>
References: <20210117101242.dpwayq6wdgfdzirl@pengutronix.de>
Message-ID: <b725079b34031595887b019d1d2f6fc7@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_07:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=873 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-17 02:12, Uwe Kleine-König wrote:
> Hello,
> 
> while working on some cleanup I stumbled over a problem in the 
> ibmvnic's
> remove callback. Since commit
> 
>         7d7195a026ba ("ibmvnic: Do not process device remove during
> device reset")
> 
> there is the following code in the remove callback:
> 
>         static int ibmvnic_remove(struct vio_dev *dev)
>         {
>                 ...
>                 spin_lock_irqsave(&adapter->state_lock, flags);
>                 if (test_bit(0, &adapter->resetting)) {
>                         spin_unlock_irqrestore(&adapter->state_lock, 
> flags);
>                         return -EBUSY;
>                 }
> 
>                 adapter->state = VNIC_REMOVING;
>                 spin_unlock_irqrestore(&adapter->state_lock, flags);
> 
>                 flush_work(&adapter->ibmvnic_reset);
>                 flush_delayed_work(&adapter->ibmvnic_delayed_reset);
>                 ...
>         }
> 
> Unfortunately returning -EBUSY doesn't work as intended. That's because
> the return value of this function is ignored[1] and the device is
> considered unbound by the device core (shortly) after ibmvnic_remove()
> returns.

Oh! I was not aware of this. In our code review, a question on whether 
or not device reset should have a higher precedence over device remove 
was raised before. So, now it is clear that this driver has to take care 
of remove over reset.

> 
> While looking into fixing that I noticed a worse problem:
> 
> If ibmvnic_reset() (e.g. called by the tx_timeout callback) calls
> schedule_work(&adapter->ibmvnic_reset); just after the work queue is
> flushed above the problem that 7d7195a026ba intends to fix will trigger
> resulting in a use-after-free.

It was proposed that when coming into ibmvnic_remove() we lock down the 
workqueue to prevent future access, flush, cleanup, then unregister the 
device. Your thought on this?

> 
> Also ibmvnic_reset() checks for adapter->state without holding the lock
> which might be racy, too.
> 
Suka started addressing consistent locking with this patch series:
https://lists.openwall.net/netdev/2021/01/08/89

He is reworking this.

> Best regards
> Uwe

Thank you for taking the time to review this driver, Uwe. This is very 
helpful for us.

Best Regards,
Dany

> 
> [1] vio_bus_remove (in arch/powerpc/platforms/pseries/vio.c) records 
> the
>     return value and passes it on. But the driver core doesn't care for
>     the return value (see __device_release_driver() in 
> drivers/base/dd.c
>     calling dev->bus->remove()).
