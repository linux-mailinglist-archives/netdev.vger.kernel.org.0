Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDCF07B83E
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 05:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfGaDcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 23:32:55 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:37927 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfGaDcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 23:32:55 -0400
Received: by mail-oi1-f194.google.com with SMTP id v186so49633273oie.5
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 20:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=cvFCPVmzmMV6AwVsWFrxEaW+OTUo2ZA/3qrTMLI6lCk=;
        b=gdDCScrqwmz/2dLR4WwDxaRvptrsi6JLx0HXqTmRGpni7IQxi9Staa5kxUTuPDJtyG
         44YFwbJA3V2cFVk6xMZv0JcvH0sTVMaK+gvTk07/46zXAWYvjG8Rn8b5AEx7W2Oc2bJm
         2peVOK6m1zRSF7Np+4Ll9JvBil4KlVEg49t9k64SeKoo1WPIzf+0sXWJdCQvN6+TggF4
         CWsgaA9UxMSfVJJOkK+lgMkLw9ur7DkiuTRAShlWzZpBBsWrwAoKDg5DsC9/cnlQG0Fk
         3a2JFUzkyq+GlvSZ7Cji12pFFAJ+VE/1PsD6VfBTRjc9gw2yK2om7xgxqsEC2THMED5R
         iaCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=cvFCPVmzmMV6AwVsWFrxEaW+OTUo2ZA/3qrTMLI6lCk=;
        b=EYYHFw7i4s3ztsbgSiD0gQ/0nxMnLV1ow2j6Z3xF1fYYO/cVdTv+1o71a38OsFemVE
         Hq4IXjjwvTwnygo0iQ7naxEwOaIoFoDHUshNIBiA0wnGTgt/BJ7A413xrTabVuLWnjyQ
         t+4fKnIo3kYAIpMakCT00l45a12q5oSLuCff26Rv9OgvqkuwZGjq+cwwuSvI5HMFkERU
         W30HZCsFRCNs2botRaU0qJLKWpfrFzmv7fqgBOIIh66cG6KPyaJ2voMLlCVN0o1IjXRL
         LK5Zq7KY7YxvyLT1XirJHuysTcuG83bXd6uZ3ddJmxGHycVen9ziYeWAOJ0IrFIaHrBM
         LATg==
X-Gm-Message-State: APjAAAWC5G5z+II5jOLBO9tdRSUclKV0EI139nEJvLYPxVZCvb0Hie0g
        /+SyNUM2nvrX7OA/hsKzi6f3ssuOcy0HKrZsZ/s=
X-Google-Smtp-Source: APXvYqyI41EyRinmLPn7dzzPA4KedF2blbOGxyjb6qKRUh8AGS2/dkoMDrf4I4A9Jx2SBUXs/Yzry3hlaOsz1i8hfHQ=
X-Received: by 2002:aca:b554:: with SMTP id e81mr34656561oif.7.1564543973848;
 Tue, 30 Jul 2019 20:32:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAO42Z2yN=FfueKAjb0KjY8-CdiKuvkJDr2iJdJR4XdKM90HJRg@mail.gmail.com>
 <93c401b9-bf8b-4d49-9c3b-72d09073444e@cn.fujitsu.com> <CAO42Z2x163LCaYrB2ZEm9i-A=Pw1xcudbGSua5TxxEHdc4=O2g@mail.gmail.com>
 <8e63c39f-3117-7446-e204-df076f43a454@gmail.com> <CAO42Z2we930YTmMUkaWXZOqFQVFxH=bd=y+JFXG8V0Y736kzug@mail.gmail.com>
In-Reply-To: <CAO42Z2we930YTmMUkaWXZOqFQVFxH=bd=y+JFXG8V0Y736kzug@mail.gmail.com>
From:   Mark Smith <markzzzsmith@gmail.com>
Date:   Wed, 31 Jul 2019 13:32:27 +1000
Message-ID: <CAO42Z2yKHJgCEToC=Sj_cGPwbc7Zs8wM+wUuN4ZWRhYgxkv2eQ@mail.gmail.com>
Subject: Fwd: net: ipv6: Fix a bug in ndisc_send_ns when netdev only has a
 global address
To:     David Ahern <dsahern@gmail.com>,
        Su Yanjun <suyj.fnst@cn.fujitsu.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re-sending in text format due to Gmail preserving the HTML email I
received and vger (quite reasonably) rejecting my response.


---------- Forwarded message ---------
From: Mark Smith <markzzzsmith@gmail.com>
Date: Wed, 31 Jul 2019 at 12:23
Subject: Re: net: ipv6: Fix a bug in ndisc_send_ns when netdev only
has a global address
To: David Ahern <dsahern@gmail.com>
Cc: Su Yanjun <suyj.fnst@cn.fujitsu.com>, <netdev@vger.kernel.org>


Hi David,


On Wed., 31 Jul. 2019, 00:11 David Ahern, <dsahern@gmail.com> wrote:
>
> On 7/30/19 4:28 AM, Mark Smith wrote:
> > Hi Su,
> >


>
> <snip>


>
> >>> This patch is not the correct solution to this issue.
> >>>
> >
> > <snip>
> >
> >> In linux implementation, one interface may have no link local address if
> >> kernel config
> >>
> >> *addr_gen_mode* is set to IN6_ADDR_GEN_MODE_NONE. My patch is to fix
> >> this problem.
> >>
> >
> > So this "IN6_ADDR_GEN_MODE_NONE" behaviour doesn't comply with RFC 4291.
> >
> > As RFC 4291 says,
> >
> > "All interfaces are *required* to have *at least one* Link-Local
> > unicast address."
> >
> > That's not an ambiguous requirement.
>
> Interesting. Going back to the original commit:
>
> commit bc91b0f07ada5535427373a4e2050877bcc12218
> Author: Jiri Pirko <jiri@resnulli.us>
> Date:   Fri Jul 11 21:10:18 2014 +0200
>
>     ipv6: addrconf: implement address generation modes
>
>     This patch introduces a possibility for userspace to set various (so far
>     two) modes of generating addresses. This is useful for example for
>     NetworkManager because it can set the mode to NONE and take care of link
>     local addresses itself. That allow it to have the interface up,
>     monitoring carrier but still don't have any addresses on it.
>
> So the intention of IN6_ADDR_GEN_MODE_NONE was for userspace to control
> it. If an LLA is required (4291 says yes, 4861 suggests no) then the
> current behavior is correct and if IN6_ADDR_GEN_MODE_NONE is used by an
> admin some userspace agent is required to add it for IPv6 to work on
> that link.
>

Ok. That seems to be saying that IN6_ADDR_GEN_MODE_NONE means that the
kernel is not going perform any address configuration on the interface
for any prefixes.

That would then place the RFC 4291 burden to generate at least one LL
address for the interface onto the user space application that has
taken over performing IPv6 address configuration on an interface.


> <snip>
> >
> > It is an IPv6 enabled interface, so it requires a link-local address,
> > per RFC 4291. RFC 4291 doesn't exclude any interfaces types from the
> > LL address requirement.
>
> There is no 'link' for loopback, so really no point in generating an LLA
> for it.
>

If your 'link' mean something physical, then I agree, the loopback
virtual interface doesn't have a link.

From IPv6's perspective, there is a link attached, because the
interface is operationally UP and IPv6 can send and receive packets
over it. They just happen to be returned to the sender by the
link-layer below the IPv6 layer. This behaviour is functionally no
different to when a physical loopback cable/plug is plugged into a
physical interface.

IPv6 tries to be fairly generic with definitions such as 'link' and
'interface' to be future proof. Here's the RFC 8200 definitons:

"link         a communication facility or medium over which nodes can
                communicate at the link layer, i.e., the layer
                immediately below IPv6.  Examples are Ethernets [...];
                and internet-layer or higher-layer "tunnels",
                such as tunnels over IPv4 or IPv6 itself.

interface    a node's attachment to a link."

The loopback virtual interface is providing both "a communication
facility [...] over which nodes can communicate at the link layer,
i.e., the layer immediately below IPv6" and an "attachment to a link".

So the loopback virtual interface is by definition a interface per the
IPv6 specification, and therefore requires a link-local address to be
compliant.


Regards,
Mark.
