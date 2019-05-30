Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B25F2FCE4
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 16:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfE3OIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 10:08:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49239 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbfE3OIh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 10:08:37 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A52BA307D9CE;
        Thu, 30 May 2019 14:08:26 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.phx2.redhat.com [10.3.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 110EF7A504;
        Thu, 30 May 2019 14:08:14 +0000 (UTC)
Date:   Thu, 30 May 2019 10:08:12 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Steve Grubb <sgrubb@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V6 00/10] audit: implement container identifier
Message-ID: <20190530140812.zyosx6ee2m3zhuua@madcap2.tricolour.ca>
References: <cover.1554732921.git.rgb@redhat.com>
 <CAHC9VhQYPF2ma_W+hySbQtfTztf=K1LTFnxnyVK0y9VYxj-K=w@mail.gmail.com>
 <CAHC9VhTQ0gDZoWUh1QB4b7h3AgbpkhS40jrPVpCfJb11GT_FzQ@mail.gmail.com>
 <1674888.6UpDe63hFX@x2>
 <CAHC9VhQqiaHRxZkOZO2c5UzMOQ_NNu1pEsc4fQDX=Hj-HnGUoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQqiaHRxZkOZO2c5UzMOQ_NNu1pEsc4fQDX=Hj-HnGUoQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 30 May 2019 14:08:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-30 09:35, Paul Moore wrote:
> On Thu, May 30, 2019 at 9:08 AM Steve Grubb <sgrubb@redhat.com> wrote:
> > On Wednesday, May 29, 2019 6:26:12 PM EDT Paul Moore wrote:
> > > On Mon, Apr 22, 2019 at 9:49 AM Paul Moore <paul@paul-moore.com> wrote:
> > > > On Mon, Apr 22, 2019 at 7:38 AM Neil Horman <nhorman@tuxdriver.com>
> > wrote:
> > > > > On Mon, Apr 08, 2019 at 11:39:07PM -0400, Richard Guy Briggs wrote:
> > > > > > Implement kernel audit container identifier.
> > > > >
> > > > > I'm sorry, I've lost track of this, where have we landed on it? Are we
> > > > > good for inclusion?
> > > >
> > > > I haven't finished going through this latest revision, but unless
> > > > Richard made any significant changes outside of the feedback from the
> > > > v5 patchset I'm guessing we are "close".
> > > >
> > > > Based on discussions Richard and I had some time ago, I have always
> > > > envisioned the plan as being get the kernel patchset, tests, docs
> > > > ready (which Richard has been doing) and then run the actual
> > > > implemented API by the userland container folks, e.g. cri-o/lxc/etc.,
> > > > to make sure the actual implementation is sane from their perspective.
> > > > They've already seen the design, so I'm not expecting any real
> > > > surprises here, but sometimes opinions change when they have actual
> > > > code in front of them to play with and review.
> > > >
> > > > Beyond that, while the cri-o/lxc/etc. folks are looking it over,
> > > > whatever additional testing we can do would be a big win.  I'm
> > > > thinking I'll pull it into a separate branch in the audit tree
> > > > (audit/working-container ?) and include that in my secnext kernels
> > > > that I build/test on a regular basis; this is also a handy way to keep
> > > > it based against the current audit/next branch.  If any changes are
> > > > needed Richard can either chose to base those changes on audit/next or
> > > > the separate audit container ID branch; that's up to him.  I've done
> > > > this with other big changes in other trees, e.g. SELinux, and it has
> > > > worked well to get some extra testing in and keep the patchset "merge
> > > > ready" while others outside the subsystem look things over.
> > >
> > > I just sent my feedback on the v6 patchset, and it's small: basically
> > > three patches with "one-liner" changes needed.
> > >
> > > Richard, it's your call on how you want to proceed from here.  You can
> > > post a v7 incorporating the feedback, or since the tweaks are so
> > > minor, you can post fixup patches; the former being more
> > > comprehensive, the later being quicker to review and digest.
> > > Regardless of that, while we are waiting on a prototype from the
> > > container folks, I think it would be good to pull this into a working
> > > branch in the audit repo (as mentioned above), unless you would prefer
> > > to keep it as a patchset on the mailing list?
> >
> > Personally, I'd like to see this on a branch so that it's easier to build a
> > kernel locally for testing.
> 
> FWIW, if Richard does prefer for me to pull it into a working branch I
> plan to include it in my secnext builds both to make it easier to test
> regularly and to make the changes available to people who don't want
> to build their own kernel.

Sure, let's do a working branch.  I'll answer the issues in respective
threads...

> * http://www.paul-moore.com/blog/d/2019/04/kernel_secnext_repo.html
> 
> -- 
> paul moore
> www.paul-moore.com
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
