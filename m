Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEF5E3A1D
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 19:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503824AbfJXRb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 13:31:56 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30271 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729458AbfJXRbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 13:31:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571938313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rCcikZum0+fRxHlX5MBh+qgzuS0QtH3FgkA7ZDqGjZY=;
        b=g3IRn4pu1gMnyttp/8hUOMYp0HHgwRADlOUP2KmafVpwpWeyzTcCuiv6IxL/MKhPu4D8zu
        VUAho2GpmsCBQXxUQsGo8C2eyapTsWMB2YxrxejRirs7A1kbq39eekeNFh1v1oPDKvtcph
        8iHSIcGOcJ3wadrFlyoeO1ikKtU8RSU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-XDeJWQNvOAWWgwuW4GwK1A-1; Thu, 24 Oct 2019 13:31:49 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78A431800E00;
        Thu, 24 Oct 2019 17:31:48 +0000 (UTC)
Received: from localhost.localdomain (ovpn-120-128.rdu2.redhat.com [10.10.120.128])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F0413100EA05;
        Thu, 24 Oct 2019 17:31:47 +0000 (UTC)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id F2D48C0AD9; Thu, 24 Oct 2019 14:31:45 -0300 (-03)
Date:   Thu, 24 Oct 2019 14:31:45 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Message-ID: <20191024173145.GO4321@localhost.localdomain>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <20191022151524.GZ4321@localhost.localdomain>
 <vbflftcwzes.fsf@mellanox.com>
 <20191022170947.GA4321@localhost.localdomain>
 <CAJieiUiDC7U7cGDadSr1L8gUxS6QiW=x9+pkp=8thxbMsMYVCQ@mail.gmail.com>
 <vbfy2xauq8s.fsf@mellanox.com>
MIME-Version: 1.0
In-Reply-To: <vbfy2xauq8s.fsf@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: XDeJWQNvOAWWgwuW4GwK1A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 03:18:00PM +0000, Vlad Buslov wrote:
>=20
> On Thu 24 Oct 2019 at 18:12, Roopa Prabhu <roopa@cumulusnetworks.com> wro=
te:
> > On Tue, Oct 22, 2019 at 10:10 AM Marcelo Ricardo Leitner
> > <mleitner@redhat.com> wrote:
> >>
> >> On Tue, Oct 22, 2019 at 03:52:31PM +0000, Vlad Buslov wrote:
> >> >
> >> > On Tue 22 Oct 2019 at 18:15, Marcelo Ricardo Leitner <mleitner@redha=
t.com> wrote:
> >> > > On Tue, Oct 22, 2019 at 05:17:51PM +0300, Vlad Buslov wrote:
> >> > >> - Extend actions that are used for hardware offloads with optiona=
l
> >> > >>   netlink 32bit flags field. Add TCA_ACT_FLAGS_FAST_INIT action f=
lag and
> >> > >>   update affected actions to not allocate percpu counters when th=
e flag
> >> > >>   is set.
> >> > >
> >> > > I just went over all the patches and they mostly make sense to me.=
 So
> >> > > far the only point I'm uncertain of is the naming of the flag,
> >> > > "fast_init".  That is not clear on what it does and can be overloa=
ded
> >> > > with other stuff later and we probably don't want that.
> >> >
> >> > I intentionally named it like that because I do want to overload it =
with
> >> > other stuff in future, instead of adding new flag value for every si=
ngle
> >> > small optimization we might come up with :)
> >>
> >> Hah :-)
> >>
> >> >
> >> > Also, I didn't want to hardcode implementation details into UAPI tha=
t we
> >> > will have to maintain for long time after percpu allocator in kernel=
 is
> >> > potentially replaced with something new and better (like idr is bein=
g
> >> > replaced with xarray now, for example)
> >>
> >> I see. OTOH, this also means that the UAPI here would be unstable
> >> (different meanings over time for the same call), and hopefully new
> >> behaviors would always be backwards compatible.
> >
> > +1, I also think optimization flags should be specific to what they opt=
imize.
> > TCA_ACT_FLAGS_NO_PERCPU_STATS seems like a better choice. It allows
> > user to explicitly request for it.
>=20
> Why would user care about details of optimizations that doesn't produce
> visible side effects for user land? Again, counters continue to work the
> same with or without the flag.

It's just just details of optimizations, on whether to use likely() or
not, and it does produce user visible effects. Not in terms of API but
of system behavior. Otherwise we wouldn't need the flag, right?
_FAST_INIT, or the fact that it inits faster, is just one of the
aspects of it, but one could also want it for being lighther in
footprint as currently it is really easy to eat Gigs of RAM away on
these percpu counters. So how should it be called, _FAST_INIT or
_SLIM_RULES?

It may be implementation detail, yes, but we shouldn't be building
usage profiles and instead let the user pick what they want. Likewise,
we don't have net.ipv4.fast_tcp, but net.ipv4.tcp_sack, tcp_timestamps
& cia.

If we can find another name then, without using 'percpu' on it but
without stablishing profiles, that would be nice.
Like TCA_ACT_FLAGS_SIMPLE_STATS, or so.

Even though I still prefer the PERCPU, as it's as explicit as it can be. No=
te
that bpf does it like that already:
uapi]$ grep BPF.*HASH -- linux/bpf.h
        BPF_MAP_TYPE_HASH,
        BPF_MAP_TYPE_PERCPU_HASH,
        BPF_MAP_TYPE_LRU_HASH,
        BPF_MAP_TYPE_LRU_PERCPU_HASH,
...

