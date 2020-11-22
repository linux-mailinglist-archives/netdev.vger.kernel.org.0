Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F052BC657
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 15:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgKVO4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 09:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgKVO4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 09:56:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0B7C0613CF;
        Sun, 22 Nov 2020 06:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wxlelFGFCxCiVSAw6KoblZyEK+s/RwoBRdtshdQHcTA=; b=IHdP9cS5+aim9K2c8XsejJHGrM
        +S6gdmtkdU0PTIkPZFY+qbqZ8sMUEbhQL8b8Qdm+o2+njoM1Cm2cM6mbD/iY0TNSwZxJRLByIjVzg
        eNcrVpKlWHjnQQvQ1Go6iFjsUh68sqz8dumIdI2qfrFsd2XrVO5w3MRgBBmvjmOvnFaYJLzopUIl7
        R6ZVO/KTc63YeijcPbeFNlRWdMYtVgUZuoprtKEH7yjNmV1uGOzQEbR4NJQpt6J1Nu3N9hq7ljiYQ
        UIsENsOUDnACtwno8Bc2xaczmaEz8q4+sGKzgwN4pxETWG486xJZxN2UeB5LYfIlImw9WtEFIo9GQ
        DSwauRxg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kgqn5-0000Ms-Pt; Sun, 22 Nov 2020 14:56:36 +0000
Date:   Sun, 22 Nov 2020 14:56:35 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Tom Rix <trix@redhat.com>
Cc:     joe@perches.com, clang-built-linux@googlegroups.com,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, tboot-devel@lists.sourceforge.net,
        kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-media@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-wireless@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
        keyrings@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, alsa-devel@alsa-project.org,
        bpf@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-nfs@vger.kernel.org, patches@opensource.cirrus.com
Subject: Re: [RFC] MAINTAINERS tag for cleanup robot
Message-ID: <20201122145635.GG4327@casper.infradead.org>
References: <20201121165058.1644182-1-trix@redhat.com>
 <20201122032304.GE4327@casper.infradead.org>
 <ddb08a27-3ca1-fb2e-d51f-4b471f1a56a3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddb08a27-3ca1-fb2e-d51f-4b471f1a56a3@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 06:46:46AM -0800, Tom Rix wrote:
> 
> On 11/21/20 7:23 PM, Matthew Wilcox wrote:
> > On Sat, Nov 21, 2020 at 08:50:58AM -0800, trix@redhat.com wrote:
> >> The fixer review is
> >> https://reviews.llvm.org/D91789
> >>
> >> A run over allyesconfig for x86_64 finds 62 issues, 5 are false positives.
> >> The false positives are caused by macros passed to other macros and by
> >> some macro expansions that did not have an extra semicolon.
> >>
> >> This cleans up about 1,000 of the current 10,000 -Wextra-semi-stmt
> >> warnings in linux-next.
> > Are any of them not false-positives?  It's all very well to enable
> > stricter warnings, but if they don't fix any bugs, they're just churn.
> >
> While enabling additional warnings may be a side effect of this effort
> 
> the primary goal is to set up a cleaning robot. After that a refactoring robot.

Why do we need such a thing?  Again, it sounds like more churn.
It's really annoying when I'm working on something important that gets
derailed by pointless churn.  Churn also makes it harder to backport
patches to earlier kernels.
