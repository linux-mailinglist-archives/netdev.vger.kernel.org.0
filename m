Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0AF3F29AE
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 11:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbhHTKAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 06:00:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237960AbhHTKAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 06:00:19 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17K9YVH1103128;
        Fri, 20 Aug 2021 05:59:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=fgec9wzmL5YIWXWVdMoacPQadvBtzmrQWOpAGnJ4gHE=;
 b=nZ8OTZtdNovFNv8mfE8wX+NXJZhiWLnkub2CWtuuwxso9nOWGt5cEO+lKjoMHe+9DmF+
 F0dirDP0G/LXzDKAUb1UpDxiYDUt0H+o3KUgcD4Sba+8XxJQJHxXNzUBoy3c9X2jM1xN
 FJzcnUcnUi3zeWvBDSfNe7gXcMCaYNxGnsZbJrclGs0JF/W3wSXT80vvvK9HXzJ7kAxM
 mkAvKxh0aa8BoYYyleKL5QBuA7H4gDFj4ZQudqdLxAvdtnq9dXV8PvyT+SwLtcatFrmS
 EZgWuiOwscjx8S21PADdKLHR2Sc7i9Wta1/IHPKlB4+CD+l5w6Xz1p8lYgRd44QSQ5mL yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ahq10727y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 05:59:37 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17K9YXFc103394;
        Fri, 20 Aug 2021 05:59:36 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ahq10727k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 05:59:36 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17K9qFG0028216;
        Fri, 20 Aug 2021 09:59:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3ae5f8gae7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 09:59:34 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17K9xWuH55509462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 09:59:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56289A405F;
        Fri, 20 Aug 2021 09:59:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4CC5A4054;
        Fri, 20 Aug 2021 09:59:31 +0000 (GMT)
Received: from sig-9-145-45-111.uk.ibm.com (unknown [9.145.45.111])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Aug 2021 09:59:31 +0000 (GMT)
Message-ID: <8a4bcb40a1c63e302fbf0c9c0f6e56822c3293b7.camel@linux.ibm.com>
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date:   Fri, 20 Aug 2021 11:59:31 +0200
In-Reply-To: <72ffff17-0b46-c12e-2f67-1a18bdcb8532@de.ibm.com>
References: <20210813203026.27687-1-rdunlap@infradead.org>
         <20210816210914.qkyd4em4rw3thbyg@bsd-mbp.dhcp.thefacebook.com>
         <16acf1ad-d626-b3a3-1cad-3fa6c61c8a22@infradead.org>
         <20210816214103.w54pfwcuge4nqevw@bsd-mbp.dhcp.thefacebook.com>
         <0e6bd492-a3f5-845c-9d93-50f1cc182a62@infradead.org>
         <72ffff17-0b46-c12e-2f67-1a18bdcb8532@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eJSLW4_X41W_ngKQwujzb0fI4wk4VdHi
X-Proofpoint-GUID: iNzcbTnJlefcH8_SQzgesuiIy6Q7wa1f
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-20_03:2021-08-20,2021-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108200053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-08-20 at 10:02 +0200, Christian Borntraeger wrote:
> 
> On 20.08.21 00:58, Randy Dunlap wrote:
> > On 8/16/21 2:41 PM, Jonathan Lemon wrote:
> > > On Mon, Aug 16, 2021 at 02:15:51PM -0700, Randy Dunlap wrote:
> > > > On 8/16/21 2:09 PM, Jonathan Lemon wrote:
> > > > > On Fri, Aug 13, 2021 at 01:30:26PM -0700, Randy Dunlap wrote:
> > > > > > There is no 8250 serial on S390. See commit 1598e38c0770.
> > > > > 
> > > > > There's a 8250 serial device on the PCI card.   Its been
> > > > > ages since I've worked on the architecture, but does S390
> > > > > even support PCI?
> > > > 
> > > > Yes, it does.
> 
> We do support PCI, but only a (very) limited amount of cards.
> So there never will be a PCI card with 8250 on s390 and
> I also doubt that we will see the "OpenCompute TimeCard"
> on s390.
> 
> So in essence the original patch is ok but the patch below
> would also be ok for KVM. But it results in a larger kernel
> with code that will never be used. So I guess the original
> patch is the better choice.

It looks to me like the SERIAL_8250 driver can be build as a module so
would then not increase the kernel image size or am I missing
something?

In that case I would vote for the patch below. For PCI on s390 we do
intend to, in principle, support arbitrary PCI devices and have already
seen cases where non-trivial cards that were never before tested on
s390 did "just work" once someone needed them.

While I do agree that both 8250 and the Time Card are unlikely to be
used on s390 never say never and compile testing a variety of driver
code against our PCI primitives is good for quality control.

In the end I'm okay with either.

> 
> > > > > > Is this driver useful even without 8250 serial?
> > > > > 
> > > > > The FB timecard has an FPGA that will internally parse the
> > > > > GNSS strings and correct the clock, so the PTP clock will
> > > > > work even without the serial devices.
> > > > > 
> > > > > However, there are userspace tools which want to read the
> > > > > GNSS signal (for holdolver and leap second indication),
> > > > > which is why they are exposed.
> > > > 
> > > > So what do you recommend here?
> > > 
> > > Looking at 1598e38c0770, it appears the 8250 console is the
> > > problem.  Couldn't S390 be fenced by SERIAL_8250_CONSOLE, instead
> > > of SERIAL_8250, which would make the 8250 driver available?
> > 
> > OK, that sounds somewhat reasonable.
> > 
> > > For now, just disabling the driver on S390 sounds reasonable.
> > > 
> > 
> > S390 people, how does this look to you?
> > 
> > This still avoids having serial 8250 console conflicting
> > with S390's sclp console.
> > (reference commit 1598e38c0770)
> > 
> > 
> > ---
> >   drivers/tty/serial/8250/Kconfig |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- linux-next-20210819.orig/drivers/tty/serial/8250/Kconfig
> > +++ linux-next-20210819/drivers/tty/serial/8250/Kconfig
> > @@ -6,7 +6,6 @@
> > 
> >   config SERIAL_8250
> >       tristate "8250/16550 and compatible serial support"
> > -    depends on !S390
> >       select SERIAL_CORE
> >       select SERIAL_MCTRL_GPIO if GPIOLIB
> >       help
> > @@ -85,6 +84,7 @@ config SERIAL_8250_FINTEK
> >   config SERIAL_8250_CONSOLE
> >       bool "Console on 8250/16550 and compatible serial port"
> >       depends on SERIAL_8250=y
> > +    depends on !S390
> >       select SERIAL_CORE_CONSOLE
> >       select SERIAL_EARLYCON
> >       help
> > 
> > 

