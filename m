Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56C4423E74
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 15:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238584AbhJFNOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 09:14:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57036 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230008AbhJFNOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 09:14:17 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 196CmhMx021012;
        Wed, 6 Oct 2021 09:10:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=s9K5Ipde3dftytgvZMayo8mNzgFKiuukbRQGJiKnxTM=;
 b=Udac3sgtIPThpqyE22P9xEAYP7BzyVVo1V0malK02beMpqEzpNO7eUefjSO9O4IiB5Qd
 Igeo8dcI+VKV+/oGQ73NKm5Hzq6Q+zHPH3Y+bBSixCSdEnTFyX0+vgdGOiut0w+/43H3
 A/8f4qxWDnwBC33n6t3xmf9cOxJAU48cSXahr9+huTaKT6Xr8ONRSU3srwMlyJMZEQGJ
 6zyy8tW91mjmsURp2m0z9pxWCWnMRsDLLNRcElwu1ELZWpxaTpGDwMqgJDE33+Zoj0Rm
 joxk17eK17FArTzz8Ma1X5o2Mk1tUbl8nco9TDKXSnM6ZinFi77Fd6Zm6v6BECEA02Xp nQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh11u6a9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 09:10:53 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 196D2ef1008269;
        Wed, 6 Oct 2021 13:10:51 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3beepjwpse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 13:10:50 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 196DAk6t62652756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Oct 2021 13:10:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CD9311C066;
        Wed,  6 Oct 2021 13:10:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B77F11C05E;
        Wed,  6 Oct 2021 13:10:45 +0000 (GMT)
Received: from thinkpad (unknown [9.171.8.189])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed,  6 Oct 2021 13:10:45 +0000 (GMT)
Date:   Wed, 6 Oct 2021 15:10:43 +0200
From:   Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To:     Hamza Mahfooz <someguy@effective-light.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     Karsten Graul <kgraul@linux.ibm.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: DPAA2 triggers, [PATCH] dma debug: report -EEXIST errors in
 add_dma_entry
Message-ID: <20211006151043.61fe9613@thinkpad>
In-Reply-To: <20211001145256.0323957a@thinkpad>
References: <20210518125443.34148-1-someguy@effective-light.com>
        <fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com>
        <20210914154504.z6vqxuh3byqwgfzx@skbuf>
        <185e7ee4-3749-4ccb-6d2e-da6bc8f30c04@linux.ibm.com>
        <20211001145256.0323957a@thinkpad>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dsDMR_TMvH-Qy8XSrAP_p36Qp2E3zSZi
X-Proofpoint-GUID: dsDMR_TMvH-Qy8XSrAP_p36Qp2E3zSZi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_02,2021-10-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 spamscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110060082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Oct 2021 14:52:56 +0200
Gerald Schaefer <gerald.schaefer@linux.ibm.com> wrote:

> On Thu, 30 Sep 2021 15:37:33 +0200
> Karsten Graul <kgraul@linux.ibm.com> wrote:
> 
> > On 14/09/2021 17:45, Ioana Ciornei wrote:
> > > On Wed, Sep 08, 2021 at 10:33:26PM -0500, Jeremy Linton wrote:
> > >> +DPAA2, netdev maintainers
> > >> Hi,
> > >>
> > >> On 5/18/21 7:54 AM, Hamza Mahfooz wrote:
> > >>> Since, overlapping mappings are not supported by the DMA API we should
> > >>> report an error if active_cacheline_insert returns -EEXIST.
> > >>
> > >> It seems this patch found a victim. I was trying to run iperf3 on a
> > >> honeycomb (5.14.0, fedora 35) and the console is blasting this error message
> > >> at 100% cpu. So, I changed it to a WARN_ONCE() to get the call trace, which
> > >> is attached below.
> > >>
> > > 
> > > These frags are allocated by the stack, transformed into a scatterlist
> > > by skb_to_sgvec and then DMA mapped with dma_map_sg. It was not the
> > > dpaa2-eth's decision to use two fragments from the same page (that will
> > > also end un in the same cacheline) in two different in-flight skbs.
> > > 
> > > Is this behavior normal?
> > > 
> > 
> > We see the same problem here and it started with 5.15-rc2 in our nightly CI runs.
> > The CI has panic_on_warn enabled so we see the panic every day now.
> 
> Adding a WARN for a case that be detected false-positive seems not
> acceptable, exactly for this reason (kernel panic on unaffected
> systems).
> 
> So I guess it boils down to the question if the behavior that Ioana
> described is legit behavior, on a system that is dma coherent. We
> are apparently hitting the same scenario, although it could not yet be
> reproduced with debug printks for some reason.
> 
> If the answer is yes, than please remove at lease the WARN, so that
> it will not make systems crash that behave valid, and have
> panic_on_warn set. Even a normal printk feels wrong to me in that
> case, it really sounds rather like you want to fix / better refine
> the overlap check, if you want to report anything here.

Dan, Christoph, any opinion?

So far it all looks a lot like a false positive, so could you please
see that those patches get reverted? I do wonder a bit why this is
not an issue for others, we surely cannot be the only ones running
CI with panic_on_warn.

We would need to disable DEBUG_DMA if this WARN stays in, which
would be a shame. Of course, in theory, this might also indicate
some real bug, but there really is no sign of that so far.

Having multiple sg elements in the same page (or cacheline) is
valid, correct? And this is also not a decision of the driver
IIUC, so if it was bug, it should be addressed in common code,
correct?

> 
> BTW, there is already a WARN in the add_dma_entry() path, related
> to cachlline overlap and -EEXIST:
> 
> add_dma_entry() -> active_cacheline_insert() -> -EEXIST ->
> active_cacheline_inc_overlap()
> 
> That will only trigger when "overlap > ACTIVE_CACHELINE_MAX_OVERLAP".
> Not familiar with that code, but it seems that there are now two
> warnings for more or less the same, and the new warning is much more
> prone to false-positives.
> 
> How do these 2 warnings relate, are they both really necessary?
> I think the new warning was only introduced because of some old
> TODO comment in add_dma_entry(), see commit 2b4bbc6231d78
> ("dma-debug: report -EEXIST errors in add_dma_entry").
> 
> That comment was initially added by Dan long time ago, and he
> added several fix-ups for overlap detection after that, including
> the "overlap > ACTIVE_CACHELINE_MAX_OVERLAP" stuff in
> active_cacheline_inc_overlap(). So could it be that the TODO
> comment was simply not valid any more, and better be removed
> instead of adding new / double warnings, that also generate
> false-positives and kernel crashes?

