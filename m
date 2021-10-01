Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E97B41EDE1
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 14:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhJAMzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 08:55:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25250 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231437AbhJAMzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 08:55:08 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 191BfekC013864;
        Fri, 1 Oct 2021 08:53:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=9afJ2qjLSKuBEwPIpFU1S7G+NnaAmmNbXe5Ffp/3qDs=;
 b=BIdyLzU8+DR4xEHOZMM3pkRvuryxZNpz3CHw984QmRmBX6OkBaBQc1ScWYU5rkPyP+1L
 heu1TEUtLHYh/cnmeC2Hn290SBLHD/MGO3e0h+xw6pk3pMrCW9kjG3UJNxjN7are4S7i
 kY/+W1ZaoKJVC+dpuBJTZ1zIdPU3kPpoCFIkBmunQwZmsOkCFD3pMeSeb0C+LDSLtTcc
 Bd231YXS9zAM7tPx4rm46PZQjxAgJFqHU+/OB/jZqKzZHPzPt2+lxEGgjlW+1lm+tLdx
 RLaPdrV/84CUAZQT1OOMqagJGF3wdAh6HGRTg9hs1iG8jeYJu5Sh1NSdGKH3fI9wn+Ag tg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3be1p7snef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Oct 2021 08:53:04 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 191CmIrO007842;
        Fri, 1 Oct 2021 12:53:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3b9u1ku464-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Oct 2021 12:53:02 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 191ClmNf49676696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Oct 2021 12:47:48 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A282D5205F;
        Fri,  1 Oct 2021 12:52:58 +0000 (GMT)
Received: from thinkpad (unknown [9.171.7.108])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id EFA3E52051;
        Fri,  1 Oct 2021 12:52:57 +0000 (GMT)
Date:   Fri, 1 Oct 2021 14:52:56 +0200
From:   Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Hamza Mahfooz <someguy@effective-light.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: Re: DPAA2 triggers, [PATCH] dma debug: report -EEXIST errors in
 add_dma_entry
Message-ID: <20211001145256.0323957a@thinkpad>
In-Reply-To: <185e7ee4-3749-4ccb-6d2e-da6bc8f30c04@linux.ibm.com>
References: <20210518125443.34148-1-someguy@effective-light.com>
        <fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com>
        <20210914154504.z6vqxuh3byqwgfzx@skbuf>
        <185e7ee4-3749-4ccb-6d2e-da6bc8f30c04@linux.ibm.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: F9ueB-YXoaqxOVwjoXdiCvjjdDtsFi5z
X-Proofpoint-GUID: F9ueB-YXoaqxOVwjoXdiCvjjdDtsFi5z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-01_02,2021-10-01_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 phishscore=0 clxscore=1011
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110010079
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Sep 2021 15:37:33 +0200
Karsten Graul <kgraul@linux.ibm.com> wrote:

> On 14/09/2021 17:45, Ioana Ciornei wrote:
> > On Wed, Sep 08, 2021 at 10:33:26PM -0500, Jeremy Linton wrote:
> >> +DPAA2, netdev maintainers
> >> Hi,
> >>
> >> On 5/18/21 7:54 AM, Hamza Mahfooz wrote:
> >>> Since, overlapping mappings are not supported by the DMA API we should
> >>> report an error if active_cacheline_insert returns -EEXIST.
> >>
> >> It seems this patch found a victim. I was trying to run iperf3 on a
> >> honeycomb (5.14.0, fedora 35) and the console is blasting this error message
> >> at 100% cpu. So, I changed it to a WARN_ONCE() to get the call trace, which
> >> is attached below.
> >>
> > 
> > These frags are allocated by the stack, transformed into a scatterlist
> > by skb_to_sgvec and then DMA mapped with dma_map_sg. It was not the
> > dpaa2-eth's decision to use two fragments from the same page (that will
> > also end un in the same cacheline) in two different in-flight skbs.
> > 
> > Is this behavior normal?
> > 
> 
> We see the same problem here and it started with 5.15-rc2 in our nightly CI runs.
> The CI has panic_on_warn enabled so we see the panic every day now.

Adding a WARN for a case that be detected false-positive seems not
acceptable, exactly for this reason (kernel panic on unaffected
systems).

So I guess it boils down to the question if the behavior that Ioana
described is legit behavior, on a system that is dma coherent. We
are apparently hitting the same scenario, although it could not yet be
reproduced with debug printks for some reason.

If the answer is yes, than please remove at lease the WARN, so that
it will not make systems crash that behave valid, and have
panic_on_warn set. Even a normal printk feels wrong to me in that
case, it really sounds rather like you want to fix / better refine
the overlap check, if you want to report anything here.

BTW, there is already a WARN in the add_dma_entry() path, related
to cachlline overlap and -EEXIST:

add_dma_entry() -> active_cacheline_insert() -> -EEXIST ->
active_cacheline_inc_overlap()

That will only trigger when "overlap > ACTIVE_CACHELINE_MAX_OVERLAP".
Not familiar with that code, but it seems that there are now two
warnings for more or less the same, and the new warning is much more
prone to false-positives.

How do these 2 warnings relate, are they both really necessary?
I think the new warning was only introduced because of some old
TODO comment in add_dma_entry(), see commit 2b4bbc6231d78
("dma-debug: report -EEXIST errors in add_dma_entry").

That comment was initially added by Dan long time ago, and he
added several fix-ups for overlap detection after that, including
the "overlap > ACTIVE_CACHELINE_MAX_OVERLAP" stuff in
active_cacheline_inc_overlap(). So could it be that the TODO
comment was simply not valid any more, and better be removed
instead of adding new / double warnings, that also generate
false-positives and kernel crashes?
