Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB4281A2004
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgDHLlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbgDHLlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 07:41:00 -0400
Received: from coco.lan (ip5f5ad4d8.dynamic.kabel-deutschland.de [95.90.212.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 759AF20747;
        Wed,  8 Apr 2020 11:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586346059;
        bh=igLuiZn52qB1kj2vKxCTjSGs9/VNYNbdH6sNTlgRisY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lNMtsoG3BeTIbawLBoa0nrrwd0el6dj9ixd/wEe67LD2atI1u1lEiKmTJiKJA0hjV
         FXR8cQCs+m+ksv+uue55PKV997wAUH/UarzRCS6hVK+lXwWdeotoHeiFSlypmHOYoN
         dm4usj1My3oZ7OaxsoqH8jwAufqemuBwo1R1j8fs=
Date:   Wed, 8 Apr 2020 13:40:48 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ricardo Ribalda Delgado <ribalda@kernel.org>,
        Luca Ceresoli <luca@lucaceresoli.net>,
        dmaengine@vger.kernel.org, Matthias Maennich <maennich@google.com>,
        Harry Wei <harryxiyou@gmail.com>, x86@kernel.org,
        ecryptfs@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        target-devel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Tyler Hicks <code@tyhicks.com>, Vinod Koul <vkoul@kernel.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 0/2] Don't generate thousands of new warnings when
 building docs
Message-ID: <20200408134048.5329427d@coco.lan>
In-Reply-To: <87lfn8klf4.fsf@mpe.ellerman.id.au>
References: <cover.1584716446.git.mchehab+huawei@kernel.org>
        <87lfn8klf4.fsf@mpe.ellerman.id.au>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, 07 Apr 2020 13:46:23 +1000
Michael Ellerman <mpe@ellerman.id.au> escreveu:

> Mauro Carvalho Chehab <mchehab+huawei@kernel.org> writes:
> > This small series address a regression caused by a new patch at
> > docs-next (and at linux-next).
> >

...

> > This solves almost all problems we have. Still, there are a few places
> > where we have two chapters at the same document with the
> > same name. The first patch addresses this problem.  
> 
> I'm still seeing a lot of warnings. Am I doing something wrong?
> 
> cheers
> 
> /linux/Documentation/powerpc/cxl.rst:406: WARNING: duplicate label powerpc/cxl:open, other instance in /linux/Documentation/powerpc/cxl.rst
...
> /linux/Documentation/powerpc/syscall64-abi.rst:86: WARNING: duplicate label powerpc/syscall64-abi:parameters and return value, other instance in /linux/Documentation/powerpc/syscall64-abi.rst
...
> /linux/Documentation/powerpc/ultravisor.rst:339: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
...

I can't reproduce your issue here at linux-next (+ my pending doc patches).

So, I can only provide you some hints.

If you see the logs you posted, all of them are related to duplicated
labels inside the same file.

-

The new Sphinx module we're using (sphinx.ext.autosectionlabel) generates
references for two levels, within the same document file (after this patch).


Looking at the first document (at linux-next version), it has:

1) A first level document title:

   Coherent Accelerator Interface (CXL)

2) Several second level titles:

   Introduction
   Hardware overview
   AFU Modes
   MMIO space
   Interrupts
   Work Element Descriptor (WED)
   User API
   Sysfs Class
   Udev rules

Right now, there's no duplication, but if someone adds, for example, 
another first-level or second-level title called "Interrupts", then 
the file will produce a duplicated label and Sphinx will warn.

The same would happen if someone adds another title (either first
level or second level) called "Coherent Accelerator Interface (CXL)",
as this will conflict with the document title.

-

Now, if the title "Coherent Accelerator Interface (CXL)" got removed,
then "Introduction".."Udev rules" will become first level titles.

Then, the sections at the "User API": "open", "ioctl"... will become
second level titles and it will produce lots of warnings.

-

That's said, IMHO, this document needs section titles for the two
sections under "User API". Adding it would allow removing the document
title. See enclosed.

Thanks,
Mauro

powerpc: docs: cxl.rst: mark two section titles as such

The User API chapter contains two sub-chapters. Mark them as
such.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>


diff --git a/Documentation/powerpc/cxl.rst b/Documentation/powerpc/cxl.rst
index 920546d81326..d2d77057610e 100644
--- a/Documentation/powerpc/cxl.rst
+++ b/Documentation/powerpc/cxl.rst
@@ -133,6 +133,7 @@ User API
 ========
 
 1. AFU character devices
+^^^^^^^^^^^^^^^^^^^^^^^^
 
     For AFUs operating in AFU directed mode, two character device
     files will be created. /dev/cxl/afu0.0m will correspond to a
@@ -395,6 +396,7 @@ read
 
 
 2. Card character device (powerVM guest only)
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
     In a powerVM guest, an extra character device is created for the
     card. The device is only used to write (flash) a new image on the

