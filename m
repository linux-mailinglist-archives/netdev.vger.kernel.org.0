Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5259E2FBF8
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 15:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfE3NIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 09:08:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbfE3NIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 09:08:40 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8FD0B30C120A;
        Thu, 30 May 2019 13:08:34 +0000 (UTC)
Received: from x2.localnet (ovpn-122-132.rdu2.redhat.com [10.10.122.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 437A15F9BA;
        Thu, 30 May 2019 13:08:25 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH ghak90 V6 00/10] audit: implement container identifier
Date:   Thu, 30 May 2019 09:08:22 -0400
Message-ID: <1674888.6UpDe63hFX@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhTQ0gDZoWUh1QB4b7h3AgbpkhS40jrPVpCfJb11GT_FzQ@mail.gmail.com>
References: <cover.1554732921.git.rgb@redhat.com> <CAHC9VhQYPF2ma_W+hySbQtfTztf=K1LTFnxnyVK0y9VYxj-K=w@mail.gmail.com> <CAHC9VhTQ0gDZoWUh1QB4b7h3AgbpkhS40jrPVpCfJb11GT_FzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 30 May 2019 13:08:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, May 29, 2019 6:26:12 PM EDT Paul Moore wrote:
> On Mon, Apr 22, 2019 at 9:49 AM Paul Moore <paul@paul-moore.com> wrote:
> > On Mon, Apr 22, 2019 at 7:38 AM Neil Horman <nhorman@tuxdriver.com> 
wrote:
> > > On Mon, Apr 08, 2019 at 11:39:07PM -0400, Richard Guy Briggs wrote:
> > > > Implement kernel audit container identifier.
> > > 
> > > I'm sorry, I've lost track of this, where have we landed on it? Are we
> > > good for inclusion?
> > 
> > I haven't finished going through this latest revision, but unless
> > Richard made any significant changes outside of the feedback from the
> > v5 patchset I'm guessing we are "close".
> > 
> > Based on discussions Richard and I had some time ago, I have always
> > envisioned the plan as being get the kernel patchset, tests, docs
> > ready (which Richard has been doing) and then run the actual
> > implemented API by the userland container folks, e.g. cri-o/lxc/etc.,
> > to make sure the actual implementation is sane from their perspective.
> > They've already seen the design, so I'm not expecting any real
> > surprises here, but sometimes opinions change when they have actual
> > code in front of them to play with and review.
> > 
> > Beyond that, while the cri-o/lxc/etc. folks are looking it over,
> > whatever additional testing we can do would be a big win.  I'm
> > thinking I'll pull it into a separate branch in the audit tree
> > (audit/working-container ?) and include that in my secnext kernels
> > that I build/test on a regular basis; this is also a handy way to keep
> > it based against the current audit/next branch.  If any changes are
> > needed Richard can either chose to base those changes on audit/next or
> > the separate audit container ID branch; that's up to him.  I've done
> > this with other big changes in other trees, e.g. SELinux, and it has
> > worked well to get some extra testing in and keep the patchset "merge
> > ready" while others outside the subsystem look things over.
> 
> I just sent my feedback on the v6 patchset, and it's small: basically
> three patches with "one-liner" changes needed.
> 
> Richard, it's your call on how you want to proceed from here.  You can
> post a v7 incorporating the feedback, or since the tweaks are so
> minor, you can post fixup patches; the former being more
> comprehensive, the later being quicker to review and digest.
> Regardless of that, while we are waiting on a prototype from the
> container folks, I think it would be good to pull this into a working
> branch in the audit repo (as mentioned above), unless you would prefer
> to keep it as a patchset on the mailing list?

Personally, I'd like to see this on a branch so that it's easier to build a 
kernel locally for testing.

-Steve


> If you want to go with
> the working branch approach, I'll keep the branch fresh and (re)based
> against audit/next and if we notice any problems you can just submit
> fixes against that branch (depending on the issue they can be fixup
> patches, or proper patches).  My hope is that this will enable the
> process to move quicker as we get near the finish line.




