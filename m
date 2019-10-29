Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC27E8B0C
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 15:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389446AbfJ2OnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 10:43:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63214 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388712AbfJ2OnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 10:43:14 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9TEYHi0032653;
        Tue, 29 Oct 2019 10:43:11 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vxqa8gcss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Oct 2019 10:43:10 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x9TEYST7033682;
        Tue, 29 Oct 2019 10:43:10 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vxqa8gcrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Oct 2019 10:43:10 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9TEPEXC021088;
        Tue, 29 Oct 2019 14:43:09 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 2vvds6v4dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Oct 2019 14:43:09 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9TEh86T22479298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 14:43:08 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B7526A061;
        Tue, 29 Oct 2019 14:43:08 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C92F56A04F;
        Tue, 29 Oct 2019 14:43:07 +0000 (GMT)
Received: from [9.53.179.206] (unknown [9.53.179.206])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 29 Oct 2019 14:43:07 +0000 (GMT)
Subject: Re: [next-queue PATCH v2 0/2] Address IRQ related crash seen due
 to io_perm_failure
From:   "David Z. Dai" <zdai@linux.vnet.ibm.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     alexander.h.duyck@linux.intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, zdai@us.ibm.com
In-Reply-To: <20191011153219.22313.60179.stgit@localhost.localdomain>
References: <20191011153219.22313.60179.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 29 Oct 2019 09:43:07 -0500
Message-ID: <1572360187.12281.4.camel@oc5348122405>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-36.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-29_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910290140
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-10-11 at 08:34 -0700, Alexander Duyck wrote:
> David Dai had submitted a patch[1] to address a reported issue with e1000e
> calling pci_disable_msi without first freeing the interrupts. Looking over
> the issue it seems the problem was the fact that e1000e_down was being
> called in e1000_io_error_detected without calling e1000_free_irq, and this
> was resulting in e1000e_close skipping over the call to e1000e_down and
> e1000_free_irq.
> 
> The use of the __E1000_DOWN flag for the close test seems to have come from
> the runtime power management changes that were made some time ago. From
> what I can tell in the close path we should be disabling runtime power
> management via a call to pm_runtime_get_sync. As such we can remove the
> test for the __E1000_DOWN bit. However in comparing this with other drivers
> we do need to avoid freeing the IRQs more than once. So in order to address
> that I have copied the approach taken in igb and taken it a bit further so
> that we will always detach the interface and if the interface is up we will
> bring it down and free the IRQs. In addition we are able to reuse some of
> the power management code so I have taken the opportunity to merge those
> bits.
> 
> [1]: https://lore.kernel.org/lkml/1570121672-12172-1-git-send-email-zdai@linux.vnet.ibm.com/
> 
> v2: Move e1000e_pm_thaw out of CONFIG_PM region to fix build issue on Sparc64
> 
> ---
> 
> Alexander Duyck (2):
>       e1000e: Use rtnl_lock to prevent race conditions between net and pci/pm
>       e1000e: Drop unnecessary __E1000_DOWN bit twiddling
> 
> 
>  drivers/net/ethernet/intel/e1000e/netdev.c |   75 +++++++++++++---------------
>  1 file changed, 36 insertions(+), 39 deletions(-)
> 
I am not familiar with the process. Don't mean to push you in any way.
Just want to check if these 2 v2 patches will be accepted by upstream?
or any thing else needs to be done to finish the process? 

Thanks! - David

