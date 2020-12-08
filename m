Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29422D362A
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 23:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbgLHWXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 17:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730450AbgLHWXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 17:23:34 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E3DC06179C
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 14:22:54 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id p187so133997iod.4
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 14:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zODQNDl2eR7WnhMarF0t9VWZdOlgYwxnP7QCCvwEWrg=;
        b=afqZy57Fw/IozfOvHIcUSdb/IZoOpgSJiMimk4XW6U3cj/fz+TYQUpVJkNAby95Asi
         JV+prEnmO1NPzaBz/XrKPIzAM6AKDM3SAPl7z0myMyEzaDi+8aG93GUjOAiIyBXpQmiZ
         fd0MwpwL4+rTB1PYK1gdhFF0Jym6JRqGn2EjV3aOV76h0zXpbA0yP+TvTEYsc1LUwRtm
         dmg034ZHJHLs+JTRMxkRvnv5nv2ktf5JRLFeuryxu3uhLfsU6//4aUybnomKE6jIyooe
         j6HfXCodkLmyy4Zjix4dKn9bGysWuUnreMMRyyTbo5BgBnH/xC7QA+YfckEBjbZUWRk2
         juHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zODQNDl2eR7WnhMarF0t9VWZdOlgYwxnP7QCCvwEWrg=;
        b=AhEvIKG1uqTa54l1zkFsxffyO8vc6aHA3GBFjdRRwPdYSe31nsYhwvnC6V+RUHT8yI
         2rlnaQU6U6G3OP6lKFpupE+975nHc9GJJHlUD7zftS0HDFUJdauL4T5FFiOyz3kaWBbM
         /H9DGAxpdh0jZilhYfNzmGDSytdDxvHw7TWDiTqOQOYtzWrdK3Y8J/JUigsKT1DTEhik
         wuMihAu3l7NyEDe9aEdUYk7p4j4oJDvXJESAFscBOIOKN+BCHc132/KCnJvACdLQBt9e
         /Ys0YU0nauyENBATMcFw8OQTDaAUA3mUWIWiVlKrux6qwjFUSzbou7ckC0I25B5QOwoF
         E6pQ==
X-Gm-Message-State: AOAM532zJS3RK4vvyYxMMWa5tPlItpat9LvZGgwUPQhiyBw0wafn6sp2
        1+klp6FA10yPSbC6wkqxAEhhNZYe86nnLE9yJ3w4P/3RC+Y=
X-Google-Smtp-Source: ABdhPJxZJpAuMIDaY3+27BrZosu8WrGOpuUUFsGcZ1jI3+JxmKIFtJyNNihXvJQTLQ6tLBYF2SYrI9g4SADUf0M/Ddk=
X-Received: by 2002:a5d:8344:: with SMTP id q4mr69603ior.38.1607466173153;
 Tue, 08 Dec 2020 14:22:53 -0800 (PST)
MIME-Version: 1.0
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
 <20201113214429.2131951-6-anthony.l.nguyen@intel.com> <CAKgT0UeQ5q2M-uiR0-1G=30syPiO8S5OFHvDuN1XtQg5700hCg@mail.gmail.com>
 <fd0fc6f95f4c107d1aed18bf58239fda91879b26.camel@intel.com>
 <CAKgT0Uewo+Rr19EVf9br9zBPsyOUANGMSQ0kqNVAzOJ8cjWMdw@mail.gmail.com>
 <20201123152137.00003075@intel.com> <CAKgT0UcoYrfONNVrRcTydahgH8zqk=ans+w0RcdqugzRdodsWQ@mail.gmail.com>
 <4bd4d1e76cd74319ab54aa5ff63a1e3979c62887.camel@intel.com>
 <CAKgT0Uf+Q_dcx5Jj99XFVwf=AxbAWAD_r9PUAsbOCXdR46cMig@mail.gmail.com> <15a6887213b9ba894b113bb8aee834b992e0958a.camel@intel.com>
In-Reply-To: <15a6887213b9ba894b113bb8aee834b992e0958a.camel@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 8 Dec 2020 14:22:42 -0800
Message-ID: <CAKgT0Ucxd5-gvEwWAdbL04ER2o++RX_oekUV3E0rYquEgFKj1w@mail.gmail.com>
Subject: Re: [net-next v3 05/15] ice: create flow profile
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Cao, Chinh T" <chinh.t.cao@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Valiquette, Real" <real.valiquette@intel.com>,
        "Behera, BrijeshX" <brijeshx.behera@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 8, 2020 at 2:01 PM Nguyen, Anthony L
<anthony.l.nguyen@intel.com> wrote:
>
> On Tue, 2020-12-08 at 11:00 -0800, Alexander Duyck wrote:
> > On Tue, Dec 8, 2020 at 8:58 AM Nguyen, Anthony L
> > <anthony.l.nguyen@intel.com> wrote:
> > >
> > > On Mon, 2020-11-23 at 17:11 -0800, Alexander Duyck wrote:
> > > > On Mon, Nov 23, 2020 at 3:21 PM Jesse Brandeburg
> > > > <jesse.brandeburg@intel.com> wrote:
> > > > >
> > > > > Alexander Duyck wrote:
> > > > >
> > > > > > > > I'm not sure this logic is correct. Can the flow director
> > > > > > > > rules
> > > > > > > > handle
> > > > > > > > a field that is removed? Last I knew it couldn't. If that
> > > > > > > > is
> > > > > > > > the case
> > > > > > > > you should be using ACL for any case in which a full mask
> > > > > > > > is
> > > > > > > > not
> > > > > > > > provided. So in your tests below you could probably drop
> > > > > > > > the
> > > > > > > > check
> > > > > > > > for
> > > > > > > > zero as I don't think that is a valid case in which flow
> > > > > > > > director
> > > > > > > > would work.
> > > > > > > >
> > > > > > >
> > > > > > > I'm not sure what you meant by a field that is removed, but
> > > > > > > Flow
> > > > > > > Director can handle reduced input sets. Flow Director is
> > > > > > > able
> > > > > > > to handle
> > > > > > > 0 mask, full mask, and less than 4 tuples. ACL is
> > > > > > > needed/used
> > > > > > > only when
> > > > > > > a partial mask rule is requested.
> > > > > >
> > > > > > So historically speaking with flow director you are only
> > > > > > allowed
> > > > > > one
> > > > > > mask because it determines the inputs used to generate the
> > > > > > hash
> > > > > > that
> > > > > > identifies the flow. So you are only allowed one mask for all
> > > > > > flows
> > > > > > because changing those inputs would break the hash mapping.
> > > > > >
> > > > > > Normally this ends up meaning that you have to do like what
> > > > > > we
> > > > > > did in
> > > > > > ixgbe and disable ATR and only allow one mask for all inputs.
> > > > > > I
> > > > > > believe for i40e they required that you always use a full 4
> > > > > > tuple. I
> > > > > > didn't see something like that here. As such you may want to
> > > > > > double
> > > > > > check that you can have a mix of flow director rules that are
> > > > > > using 1
> > > > > > tuple, 2 tuples, 3 tuples, and 4 tuples as last I knew you
> > > > > > couldn't.
> > > > > > Basically if you had fields included they had to be included
> > > > > > for
> > > > > > all
> > > > > > the rules on the port or device depending on how the tables
> > > > > > are
> > > > > > set
> > > > > > up.
> > > > >
> > > > > The ice driver hardware is quite a bit more capable than the
> > > > > ixgbe
> > > > > or
> > > > > i40e hardware, and uses a limited set of ACL rules to support
> > > > > different
> > > > > sets of masks. We have some limits on the number of masks and
> > > > > the
> > > > > number of fields that we can simultaneously support, but I
> > > > > think
> > > > > that is pretty normal for limited hardware resources.
> > > > >
> > > > > Let's just say that if the code doesn't work on an E810 card
> > > > > then
> > > > > we
> > > > > messed up and we'll have to fix it. :-)
> > > > >
> > > > > Thanks for the review! Hope this helps...
> > > >
> > > > I gather all that. The issue was the code in ice_is_acl_filter().
> > > > Basically if we start dropping fields it will not trigger the
> > > > rule to
> > > > be considered an ACL rule if the field is completely dropped.
> > > >
> > > > So for example I could define 4 rules, one that ignores the IPv4
> > > > source, one that ignores the IPv4 destination, one that ignores
> > > > the
> > > > TCP source port, and one that ignores the TCP destination port.
> > >
> > > We have the limitation that you can use one input set at a time so
> > > any
> > > of these rules could be created but they couldn't exist
> > > concurrently.
> >
> > No, I get that. The question I have is what happens if you try to
> > input a second input set. With ixgbe we triggered an error for trying
> > to change input sets. I'm wondering if you trigger an error on adding
> > a different input set or if you just invalidate the existing rules.
> >
> > > > With
> > > > the current code all 4 of those rules would be considered to be
> > > > non-ACL rules because the mask is 0 and not partial.
> > >
> > > Correct. I did this to test Flow Director:
> > >
> > > 'ethtool -N ens801f0 flow-type tcp4 src-ip 192.168.0.10 dst-ip
> > > 192.168.0.20 src-port 8500 action 10' and sent traffic matching
> > > this.
> > > Traffic correctly went to queue 10.
> >
> > So a better question here is what happens if you do a rule with
> > src-port 8500, and a second rule with dst-port 8500? Does the second
> > rule fail or does it invalidate the first. If it invalidates the
> > first
> > then that would be a bug.
>
> The second rule fails and a message is output to dmesg.
>
> ethtool -N ens801f0 flow-type tcp4 src-ip 192.168.0.10 dst-ip
> 192.168.0.20 dst-port 8500 action 10
> rmgr: Cannot insert RX class rule: Operation not supported

Ugh. I really don't like the choice to use EOPNOTSUPP as the return
value for a mask case. It really should have been something like an
EBUSY or EINVAL since you are trying to overwrite an already written
mask so you can change the field configuration.

> dmesg:
> ice 0000:81:00.0: Failed to add filter.  Flow director filters on each
> port must have the same input set.

Okay, so this is the behavior you see with Flow Director. If you don't
apply a partial mask it fails to add the second rule.

> > > > If I do the same
> > > > thing and ignore all but one bit then they are all ACL rules.
> > >
> > > Also correct. I did as follows:
> > >
> > > 'ethtool -N ens801f0 flow-type tcp4 src-ip 192.168.0.10 dst-ip
> > > 192.168.0.20 src-port 9000 m 0x1 action 15'
> > >
> > > Sending traffic to port 9000 and 90001, traffic went to queue 15
> > > Sending traffic to port 8000 and 90002, traffic went to other
> > > queues
> >
> > The test here is to set-up two rules and verify each of them and one
> > case that fails both. Same thing for the test above. Basically we
> > should be able to program multiple ACL rules with different masks and
> > that shouldn't be an issue up to some limit I would imagine. Same
> > thing for flow director rules. After the first you should not be able
> > to provide a flow director rule with a different input mask.
>
> I did this:
>
> ethtool -N ens801f0 flow-type tcp4 src-ip 192.168.0.10 dst-ip
> 192.168.0.20 src-port 9000 m 0x1 action 15
> ethtool -N ens801f0 flow-type tcp4 src-ip 192.168.0.10 dst-ip
> 192.168.0.20 src-port 8000 m 0x2 action 20
>
> Sending traffic to port 9000 and 9001 goes to queue 15
> Sending traffic to port 8000 and 8002 goes to queue 20
> Sending traffic to port 8001 and 8500 goes to neither of the queues

Doing the same thing with a mask works. I could add src-port with a
mask in one rule, and I could add dst-port with a mask in another. Can
you see the inconsistency here?

I would argue that you need to have some sort of logic that basically
checks to see if you are going to hit the input set issue and falls
back and applies the ACL rules. Otherwise you are significantly
hampering the usefulness of this filter type. It doesn't make sense
that dropping a field will cause a rule to fail to be added, but
masking a single bit in some field will make it valid. It would make
it a nightmare to use from the user point of view as the rules come
across as arbitrary.
