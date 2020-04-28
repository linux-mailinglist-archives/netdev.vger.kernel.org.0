Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23791BB9D1
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgD1J1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:27:39 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22181 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726477AbgD1J1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:27:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588066057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bfXymC3HGPNSUfX/bj/qZ8iDhTWaKlEMnkZzAyhw06M=;
        b=Iom+RxNQUxxG4x/VGnx0W2UqhvII6RyPI0zYXsziiZ+VPVVfuDudSCNscs80rhz99lXdVV
        fXOLO4Lzt0LxE7MIlm4/LTekk4vaXIdM6zVxY2SVc5FTLgi6ta+GNjEc+cm5ylku7T9Ixz
        KF0MihHJ9qCrf475v72HE3+ikec0/04=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-scXwL7yHPHqWZVOVPmMgRQ-1; Tue, 28 Apr 2020 05:27:35 -0400
X-MC-Unique: scXwL7yHPHqWZVOVPmMgRQ-1
Received: by mail-lf1-f71.google.com with SMTP id l5so8712490lfg.3
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 02:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=bfXymC3HGPNSUfX/bj/qZ8iDhTWaKlEMnkZzAyhw06M=;
        b=S2j5sqgSaWmCvuIdm6xibN/bgd8tlWhPwXj5+NFeeW0LN6hpYIP5NsQorhy0y3JJVi
         j43UiOHtFvXiYbVMIH6kCDKXWs/uqFRsxmHFwgZLCrz/DkGf1kGKqRrD8mNxnmBvtHJI
         39hdLc/z2gSDDq5T5fmfsSknyVwljF4mUBQPGKVrPPAahKZZ3Akqj7sgsUenElNsXock
         q8EE7xN79qcvX4Yj7Yn6+ifxnXNOUYeHYcPLfZe0JsBKbugRrJsk2Hg/EfNg8YJVbFea
         RqcyJYONv/5oOANIIILQtX/mkeNJEzx3FbeZouhqQ1b78l8MgunE+uB5uxjb3N6dbLuE
         wtaQ==
X-Gm-Message-State: AGi0PubSZtTzddgCTAVmGdpR4HB6plaaT/1bgldJGPsRZFpjSbZVbH0/
        QSSDg8FRGNhjE4Sotdy+GI16w0eIcaUhahMIRbFMt8ZsMyu9kVnV6aTFSthJFT8eSB57jhbi+fx
        EyC5IzYzBdCAGVhyi
X-Received: by 2002:a2e:9948:: with SMTP id r8mr16658059ljj.1.1588066053955;
        Tue, 28 Apr 2020 02:27:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypKg6xAIsjU40aGuRhCio3mV119xePhahLQuiRpax/ce7Ms4WxTW5SyN4ijPi0TlWwBsbe2+KQ==
X-Received: by 2002:a2e:9948:: with SMTP id r8mr16658042ljj.1.1588066053690;
        Tue, 28 Apr 2020 02:27:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w11sm6259113ljo.39.2020.04.28.02.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 02:27:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0E2901814FF; Tue, 28 Apr 2020 11:27:32 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic skb handler
In-Reply-To: <20200427143145.19008d7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com> <20200427204208.2501-1-Jason@zx2c4.com> <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20200427140039.16df08f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <877dy0y6le.fsf@toke.dk> <20200427143145.19008d7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 28 Apr 2020 11:27:31 +0200
Message-ID: <87tv14vu2k.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 27 Apr 2020 23:14:05 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>> > On Mon, 27 Apr 2020 13:52:54 -0700 Jakub Kicinski wrote:=20=20
>> >> On Mon, 27 Apr 2020 14:42:08 -0600 Jason A. Donenfeld wrote:=20=20
>> >> > A user reported that packets from wireguard were possibly ignored b=
y XDP
>> >> > [1]. Apparently, the generic skb xdp handler path seems to assume t=
hat
>> >> > packets will always have an ethernet header, which really isn't alw=
ays
>> >> > the case for layer 3 packets, which are produced by multiple driver=
s.
>> >> > This patch fixes the oversight. If the mac_len is 0, then we assume
>> >> > that it's a layer 3 packet, and in that case prepend a pseudo ethhd=
r to
>> >> > the packet whose h_proto is copied from skb->protocol, which will h=
ave
>> >> > the appropriate v4 or v6 ethertype. This allows us to keep XDP prog=
rams'
>> >> > assumption correct about packets always having that ethernet header=
, so
>> >> > that existing code doesn't break, while still allowing layer 3 devi=
ces
>> >> > to use the generic XDP handler.=20=20
>> >>=20
>> >> Is this going to work correctly with XDP_TX? presumably wireguard
>> >> doesn't want the ethernet L2 on egress, either? And what about
>> >> redirects?
>> >>=20
>> >> I'm not sure we can paper over the L2 differences between interfaces.
>> >> Isn't user supposed to know what interface the program is attached to?
>> >> I believe that's the case for cls_bpf ingress, right?=20=20
>> >
>> > In general we should also ask ourselves if supporting XDPgeneric on
>> > software interfaces isn't just pointless code bloat, and it wouldn't
>> > be better to let XDP remain clearly tied to the in-driver native use
>> > case.=20=20
>>=20
>> I was mostly ignoring generic XDP for a long time for this reason. But
>> it seems to me that people find generic XDP quite useful, so I'm no
>> longer so sure this is the right thing to do...
>
> I wonder, maybe our documentation is not clear. IOW we were saying that
> XDP is a faster cls_bpf, which leaves out the part that XDP only makes
> sense for HW/virt devices.

I'm not sure it's just because people think it's faster. There's also a
semantic difference; if you just want to do ingress filtering, simply
sticking an XDP program on the interface is a natural fit. Whereas
figuring out the tc semantics for ingress is non-trivial. And also
reusability of XDP programs from the native hook is an important
consideration, I believe. Which is also why I think the pseudo-MAC
header approach is the right fix for L3 devices :)

> Kinda same story as XDP egress, folks may be asking for it but that
> doesn't mean it makes sense.

Well I do also happen to think that XDP egress is a good idea ;)

> Perhaps the original reporter realized this and that's why they
> disappeared?
>
> My understanding is that XDP generic is aimed at testing and stop gap
> for drivers which don't implement native. Defining behavior based on
> XDP generic's needs seems a little backwards, and risky.

That I can agree with - generic XDP should follow the semantics of
native XDP, not the other way around. But that's what we're doing here
(with the pseudo-MAC header approach), isn't it? Whereas if we were
saying "just write your XDP programs to assume only L3 packets" we would
be creating a new semantic for generic XDP...

-Toke

