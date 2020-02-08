Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F313515648E
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 14:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgBHNcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Feb 2020 08:32:19 -0500
Received: from mail-ed1-f53.google.com ([209.85.208.53]:33619 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgBHNcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 08:32:18 -0500
Received: by mail-ed1-f53.google.com with SMTP id r21so2775783edq.0
        for <netdev@vger.kernel.org>; Sat, 08 Feb 2020 05:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=il1wiNsfS1hqVrcNCXQcWinRWFLQNVHN4PlcH6R5Q8E=;
        b=KiogB4hyD90NrZ/7NQl2lajcD1xLiT3DLBX52BOlXaPIaEaSwHSctTknMDylcxOo1m
         GCnZgESOfVSQQfgyMz5DVfsAZJq3wHUbebWDm6a9GpqO6qJTdWnJilrN39IAdt1dhgYT
         mriAg2Bh2eCj2XB4e5K7jVMCEeuoifoiKgyQfcRFbGea0f0ZCg755IgSOsfg8jTThjqv
         TE8BBi96npQDo2OR76kSgqAJXJF0vrQpIjfoIfAQeVudHyrsm1iqxqMEYHgRLyK76RIn
         7z5ZSHFNifUCZ4uKYAFWammb2WnvGR9GF3u1uThF1daXIg+nI6yqAjw23+CI92vTNMkW
         Un8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=il1wiNsfS1hqVrcNCXQcWinRWFLQNVHN4PlcH6R5Q8E=;
        b=af5V+buWeIuoL9PLSdRdn3GvheTzbC0OOREDXf4+is8lXvmPV0AqEFoeHnbYIGEbAl
         FYridlDBS9OW70LV0pPhbTeh4FkZ4CJ/hur9KP/5HAiahe+3o7riKA2vrzQh2Dg9d+FH
         r6VYjRhPIOmp9VI1b2JAbaZfmDcY3ssEzVX8t0akyQOwE6Dp60b4vfE1u8FL/b49d1y9
         4m6yUSPJDVOr92+7FOyQX2y2my251/BA0stblOPdXw+6ZQMqUAvZsSHyK6jQaUf3+GYm
         9HKfQdWB3fMKcE6NA/QZlinggKqtIDGJbHawZDomBn72ciOFs6tZ6sFA1xnGlDa4+G3X
         6NsA==
X-Gm-Message-State: APjAAAWk4WW5Di0jZgxJZ7CYNDpqCpnu/uNwLjm8FYZK+tay4v6xZcSe
        +HLR3sf5QgKrhKQ8411Tqi5EcjGgpk3R/KeQtGluFA==
X-Google-Smtp-Source: APXvYqxlCtwpjKd0Ijb1KwnZViDTukrbdq8D1NkE5DEU9lF6r9XbIvuOH+NbKZS0rfuAbe+KlYZmv/hpz46MZauU3TE=
X-Received: by 2002:a17:906:1e48:: with SMTP id i8mr3802665ejj.189.1581168736695;
 Sat, 08 Feb 2020 05:32:16 -0800 (PST)
MIME-Version: 1.0
References: <CA+h21hr4KsDCzEeLD5CtcdXMtY5pOoHGi7-Oig0-gmRKThG30A@mail.gmail.com>
 <CA+h21hpWknrGjyK0eRVFmx7a1WWRyCZJtFRgGzr3YyeL3y2gYw@mail.gmail.com> <20200207174350.GA129227@splinter>
In-Reply-To: <20200207174350.GA129227@splinter>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 8 Feb 2020 15:32:06 +0200
Message-ID: <CA+h21ho=r5i1ifFMPF1iTn3upCBkc-SMMFS7whqJ+utvXpHCQQ@mail.gmail.com>
Subject: Re: VLAN retagging for packets switched between 2 certain ports
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Fri, 7 Feb 2020 at 19:43, Ido Schimmel <idosch@idosch.org> wrote:
>
> Hi Vladimir,
>
> On Thu, Feb 06, 2020 at 11:32:52AM +0200, Vladimir Oltean wrote:
> > On Thu, 6 Feb 2020 at 11:02, Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > Hi netdev,
> > >
> > > I am interested in modeling the following classifier/action with tc filters:
> > > - Match packets with VID N received on port A and going towards port B
> > > - Replace VID with M
> > >
> > > Some hardware (DSA switch) I am working on supports this, so it would
> > > be good if I could model this with tc in a way that can be offloaded.
> > > In man tc-flower I found the following matches:
> > >        indev ifname
> > >               Match on incoming interface name. Obviously this makes
> > > sense only for forwarded flows.  ifname is the name of an interface
> > > which must exist at the time of tc invocation.
> > >        vlan_id VID
> > >               Match on vlan tag id.  VID is an unsigned 12bit value in
> > > decimal format.
> > >
> > > And there is a generic "vlan" action (man tc-vlan) that supports the
> > > "modify" command.
> > >
> > > Judging from this syntax, I would need to add a tc-flower rule on the
> > > egress qdisc of swpB, with indev swpA and vlan_id N.
> > > But what should I do if I need to do VLAN retagging towards the CPU
> > > (where DSA does not give me a hook for attaching tc filters)?
> > >
> > > Thanks,
> > > -Vladimir
> >
> > While I don't want to influence the advice that I get, I tried to see
> > this from the perspective of "what would a non-DSA device do?".
> > So what I think would work for me is:
> > - For VLAN retagging of autonomously forwarded flows (between 2
> > front-panel ports) I can do the egress filter with indev that I
> > mentioned above.
> > - For VLAN retagging towards the CPU, I can just attach the filter to
> > the ingress qdisc and not specify an indev at all. The idea being that
> > this filter will match on locally terminated packets and not on all
> > packets received on this port.
> > Would this be confusing?
>
> Yes. The correct way to handle this would be to add a netdev to
> represent the CPU port (switch side) and add the filter on its egress
> qdisc. In addition to your use case, this also allows us to solve other
> use cases:
>
> 1. Control Plane Policing (COPP): Policing of traffic going to the CPU.
> By installing relevant filters with police/drop actions.
> 2. Scheduling traffic towards the CPU: By appropriately configuring the
> egress qdisc, just like for external ports.
>
> I hope to introduce a netdev for the CPU port in mlxsw to solve the
> first use case in the upcoming months.

I understand your point of view, but I personally don't think that
adding a netdev for the CPU port is coherent with the interface that
DSA is trying to expose. Sure, at times this design has perhaps
limited what has been done with DSA, but that doesn't mean that
exposing that net device would be the right solution.
- Why is configuring an egress qdisc on the CPU port less confusing?
As far as I'm aware, an egress qdisc offload should do the same thing
as the non-offloaded version, but in the case of the CPU port, there
isn't any "egress" from software perspective to speak of. As for
ingress: what would tcpdump show? Nothing, probably.
- If we add that CPU port net device, should traffic be allowed to
pass between the front-panel ports and the CPU port by default? (of
course the answer is yes, but: ) Should that CPU port be part of the
bridge or not? It should be, but it won't be. So not having the net
device avoids that problem and a bunch of others.

Thanks,
-Vladimir
