Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8007314FA7B
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 21:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgBAUFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 15:05:38 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23639 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726469AbgBAUFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 15:05:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580587536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y5gaueKPocTAAjleff8daLyKUEdZQvYdv28FIwuztHk=;
        b=M3D9CWFHYMvhVAyRhUNThzfiPQ965TPn5HtASY1arMABAoCUP54JR4EgZCfgzbUP3uLg8p
        v09+yXY/eiZDikJMEImYYHRsGMwpU7GW0lXrtsrijcyAGdUG92F/G95aWTG8GlpApwlPWG
        wjYx0oB1nCqOpU8okeHvCBFJyeYf92I=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-Zu19J5ANOSeS0CW-0K0TqA-1; Sat, 01 Feb 2020 15:05:34 -0500
X-MC-Unique: Zu19J5ANOSeS0CW-0K0TqA-1
Received: by mail-lj1-f199.google.com with SMTP id f11so2649732ljn.6
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 12:05:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Y5gaueKPocTAAjleff8daLyKUEdZQvYdv28FIwuztHk=;
        b=tmOixvhbUZ4a3qP7lEMlrK9ICzwAovcrLvZMDky4f8x4h+Dvpj8CSxt3fL+a8xW+xh
         jON4Eu28nRRquVtP9msYX4+u21yzPgKdLcXCic6Y1YdpCNVbLqvVXuVoHRypKKjqYDPE
         qBdQnwLSrjkgMBpGwakxvGqT/zIs4tM/B0y9Ms5Vl2ZMGZPU1r2wnesjwBC5lU4TYBEd
         dnxtqaibqdBO3dUNuTUnAFMRle6rNs+C/zVdjV/NM00B1pyWwwnoEzERbGk6FVccyRXP
         DhVvaE+XiL1G7oJJPbjAfCIDGQJ5Hrv+Hm/psdiq3bKoKXZNXZDNqj835HJ+mCma+oyo
         uFBw==
X-Gm-Message-State: APjAAAU/jzxMpVAhvBIDvy9hxBj3f9rrkvw2Vgx/9RmOCCXkDDJ2oRRC
        t+6eDywOfqzbzbaddyB5hLPn3OLI76L1a2G6EjqeoIpA/X0CP0d2n+I7GMcVSlW/Uu/x4rNkNs3
        utvWrsO9S+IzWT4s1
X-Received: by 2002:a2e:9d3:: with SMTP id 202mr9728744ljj.60.1580587532914;
        Sat, 01 Feb 2020 12:05:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqygtbqIx2uAOYTaHTWGi8p8JPIBW2AYgmiN6hIKGrcizSpFa4r2eIzEKCKWhRuPyKxVuRtxYA==
X-Received: by 2002:a2e:9d3:: with SMTP id 202mr9728723ljj.60.1580587532672;
        Sat, 01 Feb 2020 12:05:32 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a8sm5065021ljb.38.2020.02.01.12.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 12:05:31 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1CD321800A2; Sat,  1 Feb 2020 21:05:28 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, davem@davemloft.net, jbrouer@redhat.com,
        mst@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
In-Reply-To: <20200201090800.47b38d2b@cakuba.hsd1.ca.comcast.net>
References: <20200123014210.38412-1-dsahern@kernel.org> <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk> <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com> <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk> <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com> <20200126141141.0b773aba@cakuba> <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com> <20200127061623.1cf42cd0@cakuba> <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com> <20200128055752.617aebc7@cakuba> <87ftfue0mw.fsf@toke.dk> <20200201090800.47b38d2b@cakuba.hsd1.ca.comcast.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 01 Feb 2020 21:05:28 +0100
Message-ID: <87sgjucbuf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Sat, 01 Feb 2020 17:24:39 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrot=
e:
>> > I'm weary of partially implemented XDP features, EGRESS prog does us
>> > no good when most drivers didn't yet catch up with the REDIRECTs.=20=20
>>=20
>> I kinda agree with this; but on the other hand, if we have to wait for
>> all drivers to catch up, that would mean we couldn't add *anything*
>> new that requires driver changes, which is not ideal either :/
>
> If EGRESS is only for XDP frames we could try to hide the handling in
> the core (with slight changes to XDP_TX handling in the drivers),
> making drivers smaller and XDP feature velocity higher.

But if it's only for XDP frames that are REDIRECTed, then one might as
well perform whatever action the TX hook was doing before REDIRECTing
(as you yourself argued)... :)

> I think loading the drivers with complexity is hurting us in so many
> ways..

Yeah, but having the low-level details available to the XDP program
(such as HW queue occupancy for the egress hook) is one of the benefits
of XDP, isn't it?

Ultimately, I think Jesper's idea of having drivers operate exclusively
on XDP frames and have the skb handling entirely in the core is an
intriguing way to resolve this problem. Though this is obviously a
long-term thing, and one might reasonably doubt we'll ever get there for
existing drivers...

>> > And we're adding this before we considered the queuing problem.
>> >
>> > But if I'm alone in thinking this, and I'm not convincing anyone we
>> > can move on :)=20=20
>>=20
>> I do share your concern that this will end up being incompatible with
>> whatever solution we end up with for queueing. However, I don't
>> necessarily think it will: I view the XDP egress hook as something
>> that in any case will run *after* packets are dequeued from whichever
>> intermediate queueing it has been through (if any). I think such a
>> hook is missing in any case; for instance, it's currently impossible
>> to implement something like CoDel (which needs to know how long a
>> packet spent in the queue) in eBPF.
>
> Possibly =F0=9F=A4=94 I don't have a good mental image of how the XDP que=
uing
> would work.
>
> Maybe once the queuing primitives are defined they can easily be
> hooked into the Qdisc layer. With Martin's recent work all we need is=20
> a fifo that can store skb pointers, really...
>
> It'd be good if the BPF queuing could replace TC Qdiscs, rather than=20
> layer underneath.

Hmm, hooking into the existing qdisc layer is an interesting idea.
Ultimately, I fear it won't be feasible for performance reasons; but
it's certainly something to consider. Maybe at least as an option?

-Toke

