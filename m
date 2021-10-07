Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF6A425830
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242081AbhJGQni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:43:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9632 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S242774AbhJGQnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 12:43:37 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 197GCXWP031997;
        Thu, 7 Oct 2021 12:40:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=JMFa7K9Yp8vP5sePEvczmlANz93yOQFEUa5LSRKZ17Q=;
 b=aRdT6Wh1miGJc6ObqkIOdTmpP+oYLMUmsSbFZ3njtfW7UjbzrkUUn4FIygvgg5m3m9UU
 kzWJ4o2B4oXG9B53LQZkpsIj3NbU+19Rl9GlTIQY7OYhjJ+ZUC3CNhjRkBZWVlptx9+Q
 Vhluykkbin9iFA+Mbxp0r7nBXVCKMYNXn83lWUMK8PR3P35OhEk+6MzNgUv0lSIWcXmg
 +ymUeJ7rGi7WNk5LVKyVtBKKJCyzg917AMvBVHVRZkXN03/GUY1+L3VbcQQ+JMNn79ji
 dk9dr/r2fDUAESVDnZW4RUtzOggyHLVMVLdqXeJycdpsu5on9E1aJnZrwmDUuxsWys/Q 0w== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhx6djf3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 12:40:52 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 197GXoPt011418;
        Thu, 7 Oct 2021 16:40:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3bef2atbj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 16:40:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 197Gek4f46203366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 16:40:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A214A406F;
        Thu,  7 Oct 2021 16:40:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC7E9A405B;
        Thu,  7 Oct 2021 16:40:45 +0000 (GMT)
Received: from thinkpad (unknown [9.171.6.122])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu,  7 Oct 2021 16:40:45 +0000 (GMT)
Date:   Thu, 7 Oct 2021 18:40:43 +0200
From:   Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Hamza Mahfooz <someguy@effective-light.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: DPAA2 triggers, [PATCH] dma debug: report -EEXIST errors in
 add_dma_entry
Message-ID: <20211007184043.6fdfc57e@thinkpad>
In-Reply-To: <fd4a2d8d-3f9d-51f3-1c86-8009ad50e6a1@linux.ibm.com>
References: <20210518125443.34148-1-someguy@effective-light.com>
        <fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com>
        <20210914154504.z6vqxuh3byqwgfzx@skbuf>
        <185e7ee4-3749-4ccb-6d2e-da6bc8f30c04@linux.ibm.com>
        <20211001145256.0323957a@thinkpad>
        <20211006151043.61fe9613@thinkpad>
        <4a96b583-1119-8b26-cc85-f77a6b4550a2@arm.com>
        <fd4a2d8d-3f9d-51f3-1c86-8009ad50e6a1@linux.ibm.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bJjvj8kg36i1WNR5Qp1yt3YVP6OAr_dz
X-Proofpoint-GUID: bJjvj8kg36i1WNR5Qp1yt3YVP6OAr_dz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-07_02,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 clxscore=1015 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Oct 2021 12:59:32 +0200
Karsten Graul <kgraul@linux.ibm.com> wrote:

[...]
> > 
> >>> BTW, there is already a WARN in the add_dma_entry() path, related
> >>> to cachlline overlap and -EEXIST:
> >>>
> >>> add_dma_entry() -> active_cacheline_insert() -> -EEXIST ->
> >>> active_cacheline_inc_overlap()
> >>>
> >>> That will only trigger when "overlap > ACTIVE_CACHELINE_MAX_OVERLAP".
> >>> Not familiar with that code, but it seems that there are now two
> >>> warnings for more or less the same, and the new warning is much more
> >>> prone to false-positives.
> >>>
> >>> How do these 2 warnings relate, are they both really necessary?
> >>> I think the new warning was only introduced because of some old
> >>> TODO comment in add_dma_entry(), see commit 2b4bbc6231d78
> >>> ("dma-debug: report -EEXIST errors in add_dma_entry").
> > 
> > AFAICS they are different things. I believe the new warning is supposed to be for the fundementally incorrect API usage (as above) of mapping different regions overlapping within the same cacheline. The existing one is about dma-debug losing internal consistency when tracking the *same* region being mapped multiple times, which is a legal thing to do - e.g. buffer sharing between devices - but if anyone's doing it to excess that's almost certainly a bug (i.e. they probably intended to unmap it in between but missed that out).
> 
> Thanks for the explanation Robin. 
> 
> In our case its really that a buffer is mapped twice for 2 different devices which we use in SMC to provide failover capabilities. We see that -EEXIST is returned when a buffer is mapped for the second device. Since there is a maximum of 2 parallel mappings we never see the warning shown by active_cacheline_inc_overlap() because we don't exceed ACTIVE_CACHELINE_MAX_OVERLAP.
> 
> So how to deal with this kind of "legal thing", looks like there is no way to suppress the newly introduced EEXIST warning for that case?

Thanks Karsten, very interesting. We assumed so far that we hit the
same case as Ioana, i.e. having multiple sg elements in one cacheline.
With debug output it now seems that we hit a completely different
case, not at all related to any cacheline or coherency issues.

So it really seems that the new warning is basically the same
as the already present one, with the difference that it already
triggers on the first occurrence. Looking at the code again, it
also seems rather obvious now...

IIUC, from what Robin described, this means that the "legal thing
to do - e.g. buffer sharing between devices" will now immediately
trigger the new warning? Not sure if I missed something (again),
because then I would expect much more reports on this, and of
course it would then obviously be false-positive.
