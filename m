Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1694D2C7B4A
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 22:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgK2VHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 16:07:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:38990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgK2VHc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 16:07:32 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6F7220757;
        Sun, 29 Nov 2020 21:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606684012;
        bh=Hl+Yto9GomcGVi/UwqRwnPVmA6LiDPHsQ53LHLdabm8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hN3AY0vwAvQ+nCH0zXWRe2bBjvNgGLJ8mlzqYvlqwZJNIELR2VYnbkMaYS8q+7x+1
         WSSaYJIWITRQuA+NHH/9ZEBPXOl0CB9aPs3W15SPwkZ9h8XXNygjwzTJw4N6g+r3du
         /cAVWRYjBGVNWQhn5WOW6iEWf0NAhbgDIfVyzNGs=
Date:   Sun, 29 Nov 2020 16:06:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
Message-ID: <20201129210650.GP643756@sasha-vm>
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 29, 2020 at 06:34:01PM +0100, Paolo Bonzini wrote:
>On 29/11/20 05:13, Sasha Levin wrote:
>>>Which doesn't seem to be suitable for stable either...  Patch 3/5 
>>>in
>>
>>Why not? It was sent as a fix to Linus.
>
>Dunno, 120 lines of new code?  Even if it's okay for an rc, I don't 
>see why it is would be backported to stable releases and release it 
>without any kind of testing.  Maybe for 5.9 the chances of breaking 

Lines of code is not everything. If you think that this needs additional
testing then that's fine and we can drop it, but not picking up a fix
just because it's 120 lines is not something we'd do.

>things are low, but stuff like locking rules might have changed since 
>older releases like 5.4 or 4.19.  The autoselection bot does not know 
>that, it basically crosses fingers that these larger-scale changes 
>cause the patches not to apply or compile anymore.

Plus all the testing we have for the stable trees, yes. It goes beyond
just compiling at this point.

Your very own co-workers (https://cki-project.org/) are pushing hard on
this effort around stable kernel testing, and statements like these
aren't helping anyone.

If on the other hand, you'd like to see specific KVM/virtio/etc tests as
part of the stable release process, we should all work together to make
sure they're included in the current test suite.

>Maybe it's just me, but the whole "autoselect stable patches" and 
>release them is very suspicious.  You are basically crossing fingers 

Historically autoselected patches were later fixed/reverted at a lower
ratio than patches tagged with a stable tag. I *think* that it's because
they get a longer review cycle than some of the stable tagged patches.

>and are ready to release any kind of untested crap, because you do not 
>trust maintainers of marking stable patches right.  Only then, when a 

It's not that I don't trust - some folks forget, or not realize that
something should go in stable. We're all humans. This is to complement
the work done by maintainers, not replace it.

>backport is broken, it's maintainers who get the blame and have to fix 
>it.

What blame? Who's blaming who?

>Personally I don't care because I have asked you to opt KVM out of 
>autoselection, but this is the opposite of what Greg brags about when 
>he touts the virtues of the upstream stable process over vendor 
>kernels.

What, that we try and include all fixes rather than the ones I'm paid to
pick up?

If you have a vendor you pay $$$ to, then yes - you're probably better
off with a vendor kernel. This is actually in line (I think) with Greg's
views on this
(http://kroah.com/log/blog/2018/08/24/what-stable-kernel-should-i-use/).

-- 
Thanks,
Sasha
