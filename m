Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B46C39F474
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 22:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbfH0UrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 16:47:19 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45040 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727887AbfH0UrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 16:47:19 -0400
Received: by mail-lj1-f193.google.com with SMTP id e24so504388ljg.11
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 13:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=676eBGOMnEbCXdYc2k42Pn3qEQ+iqzW4O3w2nRFpLyY=;
        b=wjz2OlUL8SBaRIjQe2a3q3lg/KbUwYCbasUcIyh0tUnuwP/DR2Nx/EIcHFqRFsMuov
         BMbbpB7exp43OZSkAwaHJfxuZd0k8xIREjlTyNSPAz8yw656ub/Sb2ZsX7warBLAVVmy
         PnEeBerc/wgN7MYukl+57MTdVvVs84Mh3E/EsmTW5eASJGVG8WI+cNcLbUl9ASoS0gJK
         nEiqqzY4o6eWY45oYImbaodwiaPLHfhMEjXFBbMNBYCd3IcXU9MO/G2qaD6HMM4iDgbN
         YKNdXvzEusmflmeX0/d2oyJ1RzO3XdoSXxzq8qAz6tc/k1nh5P2QWpLAS9yQ32DvnFIo
         zg9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=676eBGOMnEbCXdYc2k42Pn3qEQ+iqzW4O3w2nRFpLyY=;
        b=JS04U5C/Sy6iNj6tGpk/y4fbX0JtSYMGzJ+iTISO4CmVQUyVN9XOkLpxqf6NsGh/4o
         ix/BMmNx7+FFp6AdoxS4MALtkdzm7q8uEu5u/yGaMLZyB2qyAroJcp/qc4KjeMVH8CRT
         Y3WYb0MLZeuOI99eMsAf4liwiZEJ656G6Ws0yHCRtv8F/0iLXLEcD51A75UDE12Il/O1
         zS7sELeWpLzIjgMl0XshTLWCLpTCanIPahrgvCbyS+QijpaknEh89/waWEghJIrlAavP
         7C+81Vm4wDq/2fwdn2ekzinpns1+kuCNNW3/BECCibR5vzFZ0F/S1iPW0A5nMrt53+Ct
         dcnA==
X-Gm-Message-State: APjAAAVjZQs4nqkHTPc/+QUiuIthL7OGnDh17LW/Z6ACl2sndouKecQq
        imeWZ5YbfmsfhSAT09uDUoHGo+pFNgoriMkWJ9Ak
X-Google-Smtp-Source: APXvYqz18ASa+PuVHWeWsueo2BGnqQKKMgfHbJJ8aC+DXkQeY09FG1NoMCLdKpFnC0jdgk4t+vpziyBLozSTThLqkds=
X-Received: by 2002:a2e:6393:: with SMTP id s19mr135317lje.46.1566938836251;
 Tue, 27 Aug 2019 13:47:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190821134547.96929-1-jeffv@google.com> <20190822.161913.326746900077543343.davem@davemloft.net>
 <CABXk95BF=RfqFSHU_---DRHDoKyFON5kS_vYJbc4ns2OS=_t0w@mail.gmail.com>
In-Reply-To: <CABXk95BF=RfqFSHU_---DRHDoKyFON5kS_vYJbc4ns2OS=_t0w@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 27 Aug 2019 16:47:04 -0400
Message-ID: <CAHC9VhRmmEp_nFtOFy_YRa9NwZA4qPnjw7D3JQvqED-tO4Ha1g@mail.gmail.com>
Subject: Re: [PATCH 1/2] rtnetlink: gate MAC address with an LSM hook
To:     Jeffrey Vander Stoep <jeffv@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 7:41 AM Jeffrey Vander Stoep <jeffv@google.com> wro=
te:
> On Fri, Aug 23, 2019 at 1:19 AM David Miller <davem@davemloft.net> wrote:
> > From: Jeff Vander Stoep <jeffv@google.com>
> > Date: Wed, 21 Aug 2019 15:45:47 +0200
> >
> > > MAC addresses are often considered sensitive because they are
> > > usually unique and can be used to identify/track a device or
> > > user [1].
> > >
> > > The MAC address is accessible via the RTM_NEWLINK message type of a
> > > netlink route socket[2]. Ideally we could grant/deny access to the
> > > MAC address on a case-by-case basis without blocking the entire
> > > RTM_NEWLINK message type which contains a lot of other useful
> > > information. This can be achieved using a new LSM hook on the netlink
> > > message receive path. Using this new hook, individual LSMs can select
> > > which processes are allowed access to the real MAC, otherwise a
> > > default value of zeros is returned. Offloading access control
> > > decisions like this to an LSM is convenient because it preserves the
> > > status quo for most Linux users while giving the various LSMs
> > > flexibility to make finer grained decisions on access to sensitive
> > > data based on policy.
> > >
> > > [1] https://adamdrake.com/mac-addresses-udids-and-privacy.html
> > > [2] Other access vectors like ioctl(SIOCGIFHWADDR) are already covere=
d
> > > by existing LSM hooks.
> > >
> > > Signed-off-by: Jeff Vander Stoep <jeffv@google.com>
> >
> > I'm sure the MAC address will escape into userspace via other means,
> > dumping pieces of networking config in other contexts, etc.  I mean,
> > if I can get a link dump, I can dump the neighbor table as well.
>
> These are already gated by existing LSM hooks and capability checks.
> They are not allowed on mandatory access control systems unless explicitl=
y
> granted.
>
> > I kinda think this is all very silly whack-a-mole kind of stuff, to
> > be quite honest.
>
> We evaluated mechanisms for the MAC to reach unprivileged apps.
> A number of researchers have published on this as well such as:
> https://www.usenix.org/conference/usenixsecurity19/presentation/reardon
>
> Three "leaks" were identified, two have already been fixed.
> -ioctl(SIOCGIFHWADDR). Fixed using finer grained LSM checks
> on socket ioctls (similar to this change).
> -IPv6 IP addresses. Fixed by no longer including the MAC as part
> of the IP address.
> -RTM_NEWLINK netlink route messages. The last mole to be whacked.
>
> > And like others have said, tomorrow you'll be like "oh crap, we should
> > block X too" and we'll get another hook, another config knob, another
> > rulset update, etc.
>
> This seems like an issue inherent with permissions/capabilities. I don=E2=
=80=99t
> think we should abandon the concept of permissions because someone
> can forget to add a check.  Likewise, if someone adds new code to the
> kernel and omits a capable(CAP_NET_*) check, I would expect it to be
> fixed like any other bug without the idea of capability checks being toss=
ed
> out.
>
> We need to do something because this information is being abused. Any
> recommendations? This seemed like the simplest approach, but I can
> definitely appreciate that it has downsides.
>
> I could make this really generic by adding a single hook to the end of
> sock_msgrecv() which would allow an LSM to modify the message to omit
> the MAC address and any other information that we deem as sensitive in th=
e
> future. Basically what Casey was suggesting. Thoughts on that approach?

I apologize for the delay in responding; I'm blaming LSS-NA travel.

I'm also not a big fan of inserting the hook in rtnl_fill_ifinfo(); as
presented it is way too specific for a LSM hook for me to be happy.
However, I do agree that giving the LSMs some control over netlink
messages makes sense.  As others have pointed out, it's all a matter
of where to place the hook.

If we only care about netlink messages which leverage nlattrs I
suppose one option that I haven't seen mentioned would be to place a
hook in nla_put().  While it is a bit of an odd place for a hook, it
would allow the LSM easy access to the skb and attribute type to make
decisions, and all of the callers should already be checking the
return code (although we would need to verify this).  One notable
drawback (not the only one) is that the hook is going to get hit
multiple times for each message.

--
paul moore
www.paul-moore.com
