Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2D817B1E7
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 23:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgCEWud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 17:50:33 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53712 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgCEWud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 17:50:33 -0500
Received: by mail-pj1-f65.google.com with SMTP id cx7so213879pjb.3;
        Thu, 05 Mar 2020 14:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=9wmNPNHvPzl03zU+ZS6fT44giqtOJxkPxqlP1GJ+L+Y=;
        b=aB3inAsugYdiR4ysoj3GGdImJscU9hgchE0DXvF2f0i7sBeVC3TiWtzWIftIG2lx9x
         3/gXxLJsyEWJLbR1OGcEFrNzTm1D/Uwgy14Oz6R8xcCZjYJic9mWoJCs3j9s7rOHtRfU
         lghMQn+8O/WhCRs37JD9LfTi1p42xxMQhv+27c8DE0QAywKMWKzuCDIUc/DhDP4csG7O
         drfobQCorbROxwdZqm44aqGOeRaYyZpXFzO5TCIv66MQPdxuxnBTlgHt6hNOiOTuokzw
         x8dkZhm16aJczECg29S4FhDp3dooJzV8z7Q6m9TcuTNdjuOriqapZTta/X1raiK7sB/f
         iKIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=9wmNPNHvPzl03zU+ZS6fT44giqtOJxkPxqlP1GJ+L+Y=;
        b=tFxljT9HtQ6S46RQku/dOPZCsRaBnqNVm7uXayRnWvBA2pC0SruY7hiXke7ZT3aZpJ
         ng1wYDBLjLv40vZfNI2TNeC5nlkBfpyb/qk0AqQvahhc/WgTtxQlZ7UDUTjLQ3pii/wC
         yVxmqTZXGcTskj5/ILudeJxyjYTcLdIK1kVLK2c56nJcSXM3AclG8juR3I9Mp5wOzRj6
         BBoBmuKX+eSE6yoP0aXrbBOHcHJwgECVCgGDTtvx5PAhU/JBlolIJzh/d0muuqR/gB27
         SWRMfieykDJBNgZQcqRcyIKrMvkaGIhMJ0mpi4yaRaxVBV1Y2RpDrxlRD7ZBwAO7zDhj
         Jn2g==
X-Gm-Message-State: ANhLgQ2lBhUa8nKOlBn4uO/l6N9uWhhlESTIttZwTI7iEF59cuShrynp
        q4b31jt7SXQ8bsNj8g2+UtI=
X-Google-Smtp-Source: ADFU+vtvyR1Nx0lEoZOjcJdNpgmOsEwyQ7TtmCygPLOglH3wbqpE+9CuchW27iL94idvzoFR3NUL6w==
X-Received: by 2002:a17:90a:254c:: with SMTP id j70mr415106pje.122.1583448632121;
        Thu, 05 Mar 2020 14:50:32 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:f0e7])
        by smtp.gmail.com with ESMTPSA id y14sm3692413pfp.59.2020.03.05.14.50.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2020 14:50:31 -0800 (PST)
Date:   Thu, 5 Mar 2020 14:50:28 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
Message-ID: <20200305225027.nazs3gtlcw3gjjvn@ast-mbp>
References: <87pndt4268.fsf@toke.dk>
 <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
 <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com>
 <87k1413whq.fsf@toke.dk>
 <20200304043643.nqd2kzvabkrzlolh@ast-mbp>
 <87h7z44l3z.fsf@toke.dk>
 <20200304154757.3tydkiteg3vekyth@ast-mbp>
 <874kv33x60.fsf@toke.dk>
 <20200305163444.6e3w3u3a5ufphwhp@ast-mbp>
 <473a3e8a-03ea-636c-f054-3c960bf0fdbd@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <473a3e8a-03ea-636c-f054-3c960bf0fdbd@iogearbox.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 11:34:18PM +0100, Daniel Borkmann wrote:
> On 3/5/20 5:34 PM, Alexei Starovoitov wrote:
> > On Thu, Mar 05, 2020 at 11:37:11AM +0100, Toke Høiland-Jørgensen wrote:
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > > > On Wed, Mar 04, 2020 at 08:47:44AM +0100, Toke Høiland-Jørgensen wrote:
> [...]
> > > Anyway, what I was trying to express:
> > > 
> > > > Still that doesn't mean that pinned link is 'immutable'.
> > > 
> > > I don't mean 'immutable' in the sense that it cannot be removed ever.
> > > Just that we may end up in a situation where an application can see a
> > > netdev with an XDP program attached, has the right privileges to modify
> > > it, but can't because it can't find the pinned bpf_link. Right? Or am I
> > > misunderstanding your proposal?
> > > 
> > > Amending my example from before, this could happen by:
> > > 
> > > 1. Someone attaches a program to eth0, and pins the bpf_link to
> > >     /sys/fs/bpf/myprog
> > > 
> > > 2. eth0 is moved to a different namespace which mounts a new sysfs at
> > >     /sys
> > > 
> > > 3. Inside that namespace, /sys/fs/bpf/myprog is no longer accessible, so
> > >     xdp-loader can't get access to the original bpf_link; but the XDP
> > >     program is still attached to eth0.
> > 
> > The key to decide is whether moving netdev across netns should be allowed
> > when xdp attached. I think it should be denied. Even when legacy xdp
> > program is attached, since it will confuse user space managing part.
> 
> There are perfectly valid use cases where this is done already today (minus
> bpf_link), for example, consider an orchestrator that is setting up the BPF
> program on the device, moving to the newly created application pod during
> the CNI call in k8s, such that the new pod does not have the /sys/fs/bpf/
> mount instance and if unprivileged cannot remove the BPF prog from the dev
> either. We do something like this in case of ipvlan, meaning, we attach a
> rootlet prog that calls into single slot of a tail call map, move it to the
> application pod, and only out of Cilium's own pod and it's pod-local bpf fs
> instance we manage the pinned tail call map to update the main programs in
> that single slot w/o having to switch any netns later on.

Right. You mentioned this use case before, but I managed to forget about it.
Totally makes sense for prog to stay attached to netdev when it's moved.
I think pod manager would also prefer that pod is not able to replace
xdp prog from inside the container. It sounds to me that steps 1,2,3 above
is exactly the desired behavior. Otherwise what stops some application
that started in a pod to override it?
