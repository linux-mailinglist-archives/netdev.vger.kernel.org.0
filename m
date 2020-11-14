Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286A92B2AA8
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 02:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgKNBvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 20:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgKNBvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 20:51:06 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388ABC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 17:51:06 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id y9so10197108ilb.0
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 17:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kNDynN8EYXV2jvx4iZ47g+JLt+azNx8SNJ7QZZJdcG0=;
        b=YVvT75wR5cQHSUnXKiKV94oOR98+1UcB2vUGHnP42QYuO59snPPVZPBqFyw84sHhqQ
         Zn2TwYrZZkgUI2dC6aPRkB21zJdRYQPmLdRNxm5LED7SE0t+kZZVEdbdV7/0uqR5wPoR
         z40cww4hCJFGgKZrG/70y24vhazVlrIR9bNP1WmYvlQjMgBYZ5emdgxppRggUviEUoVu
         ep4+ubM1DUv2RBaAJinVpy9+VtMiIVN92Beop2+E9i9n3+xfJh2iCCMPQjO1cSCC4uXw
         JRWjZU+0vbOCz2M6wSLBAhx2PzSd/R+E3YS6k3ZYwUjvdxP3HUEKAnd5xx1a3levHduR
         j8bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kNDynN8EYXV2jvx4iZ47g+JLt+azNx8SNJ7QZZJdcG0=;
        b=iMipYHA4S8O3rfp9OegvE6fbNsUKsaS+kCjzTOfWaXGhTQRfP14UABY7oTqNpa6rxv
         +ZIciyhMGj/Nz09s+Qa0J5SXiHeozHH2gWZz+ZIC440yI2/J4JWEBJZKaPVSQsgypWVZ
         PZsjrmIY3+SSK3O4r4zu9oaQH6dOVjV6/3nKrOYDD38RjAdxhuEm65uH3zTwkM4Y5FcJ
         3U7WEUbefwzmXCxmSAKl9llaP+o7NmkPLEUUFAGJ68m/kx+WKZMs+NUpB7wntti11Kmh
         ux9bpI6yaR0OQnhpzOBQcg2drZvUQ6hiRrYf5tYTSR5QuqU5Ya+4FW8HxS47SQ4wILTE
         VFDw==
X-Gm-Message-State: AOAM533Eq/3pJprF5j9mdWj2k9w5fGEnsatFsfGYC2OkiqfA6wI719fU
        NYS6CSEqpKKwpZvOB07pWKCaS69NgEIAzjLrbJo=
X-Google-Smtp-Source: ABdhPJyZiXzTewOpimMCGU/yDuoETNycSt4d3aHnGzMU+srykTusy2cmc0yNIuo3lucJ5fQuhf50vUAu7xNMwDFi948=
X-Received: by 2002:a92:ca86:: with SMTP id t6mr1887792ilo.95.1605318664726;
 Fri, 13 Nov 2020 17:51:04 -0800 (PST)
MIME-Version: 1.0
References: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
 <20201113213407.2131340-4-anthony.l.nguyen@intel.com> <CAKgT0UcEd4BmyMxBmy2D2vVCWKu3Q=0iYKZ2UTdAPg0gitSiCQ@mail.gmail.com>
 <2c35ef3950756f0ea04fb61246b2c9b22859d3d4.camel@intel.com>
In-Reply-To: <2c35ef3950756f0ea04fb61246b2c9b22859d3d4.camel@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 13 Nov 2020 17:50:53 -0800
Message-ID: <CAKgT0UdiZGGjSaF=8gx4ZcApYzWDe_FpQwSZmtUjC2ZBsOeXDg@mail.gmail.com>
Subject: Re: [net-next v2 03/15] ice: initialize ACL table
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Cao, Chinh T" <chinh.t.cao@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Valiquette, Real" <real.valiquette@intel.com>,
        "davem@davemloft.neti" <davem@davemloft.neti>,
        "Bokkena, HarikumarX" <harikumarx.bokkena@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 4:16 PM Nguyen, Anthony L
<anthony.l.nguyen@intel.com> wrote:
>
> On Fri, 2020-11-13 at 14:59 -0800, Alexander Duyck wrote:
> > On Fri, Nov 13, 2020 at 1:36 PM Tony Nguyen <
> > anthony.l.nguyen@intel.com> wrote:
> > >
> > > From: Real Valiquette <real.valiquette@intel.com>
> > >
> > > ACL filtering can be utilized to expand support of ntuple rules by
> > > allowing
> > > mask values to be specified for redirect to queue or drop.
> > >
> > > Implement support for specifying the 'm' value of ethtool ntuple
> > > command
> > > for currently supported fields (src-ip, dst-ip, src-port, and dst-
> > > port).
> > >
> > > For example:
> > >
> > > ethtool -N eth0 flow-type tcp4 dst-port 8880 m 0x00ff action 10
> > > or
> > > ethtool -N eth0 flow-type tcp4 src-ip 192.168.0.55 m 0.0.0.255
> > > action -1
> > >
> > > At this time the following flow-types support mask values: tcp4,
> > > udp4,
> > > sctp4, and ip4.
> >
> > So you spend all of the patch description describing how this might
> > be
> > used in the future. However there is nothing specific to the ethtool
> > interface as far as I can tell anywhere in this patch. With this
> > patch
> > the actual command called out above cannot be performed, correct?
> >
> > > Begin implementation of ACL filters by setting up structures,
> > > AdminQ
> > > commands, and allocation of the ACL table in the hardware.
> >
> > This seems to be what this patch is actually doing. You may want to
> > rewrite this patch description to focus on this and explain that you
> > are enabling future support for ethtool ntuple masks. However save
> > this feature description for the patch that actually enables the
> > functionality.
>
> Thanks for the feedback Alex. I believe you're still reviewing the
> patches, I'l look through and make changes accordingly or get responses
> as neeeded.
>
> Thanks,
> Tony

I've pretty much finished up now. My main concern with the set is the
mask handling for the ACL functionality. I think it may be doing the
wrong thing since last I knew Flow Director required the full 4 tuple
to function for TCP/UDP, so there are probably cases that are being
sent to Flow Director when it should be handled by ACL, specifically
when one of the ports is masked out of the filtering entirely.

- Alex
