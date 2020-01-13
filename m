Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51390139123
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 13:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgAMMdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 07:33:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31884 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725832AbgAMMdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 07:33:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578918801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PsD96KWouF98bRvqci6rNvyMS0MqJNVwEI6mdSQH4/4=;
        b=I2y1Wa25D+nk9i1pr41efxCPFVkFr0M9litzfo5fKltpg0ZSZ7nkkOXdjskNcZ7FooCYDS
        CnTHmiUAA8gb5hxWYwAfzHtNEC5iFccv5zexNNXJRTVpyxG10g3ZjiXpBHR09UdYE7cOKY
        h2o47HDazTMNJDavTp6f/kCok7XP82g=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-o3mIJ51KNtm_inQtmLmysQ-1; Mon, 13 Jan 2020 07:33:18 -0500
X-MC-Unique: o3mIJ51KNtm_inQtmLmysQ-1
Received: by mail-lj1-f197.google.com with SMTP id k21so1925802ljg.3
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 04:33:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=PsD96KWouF98bRvqci6rNvyMS0MqJNVwEI6mdSQH4/4=;
        b=KqWDG4gY/TQ4l4ZiIpc80cGysjpOdR7UM2ahZzVBNtASxGIy0qWaYrfnOF77pq968X
         EfW5H7hcdfyvYPTDnFQO6iZe9wfY+OdiOSVa7rpC+xvcxJ23xfL+YzIjYPlhEjwYAjh1
         2ScH0MsqGwJcygYCZrqLh4Phvh/382LeYl2X8brZDsJ96ILuh3S4ozFh4x1Qjr9EYzry
         ef1rUX1R3vYO9c8dbIRb8NAFYBPn8W66747SzQpVEc/i6NhAMEtf+/7NJ8P7k7n2RsNH
         cQymF7t8UolPjQrVqZDfIxHYuoUpM0MQuYp4BmDnmZyY8t8KVAU6VGH1RaE31gIsei7M
         C0eA==
X-Gm-Message-State: APjAAAUS+653eWClqJ16ArZ5koOJeYWsi+LB6X+NxjWXL/nOSgdmtmqm
        nd8sOp2vUocWuUzNpH5ISEnkYnvXGPgIXtY1jFHVr5Kz6zKUoJXxiu6Vhi0qgahNWiXjPhOP6Zo
        9fMu7qnoMmif9uPB5
X-Received: by 2002:a2e:8797:: with SMTP id n23mr9551853lji.176.1578918796949;
        Mon, 13 Jan 2020 04:33:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqwfJF/jueleXSbyFyMSk3G1etyLO4VdWPeU2aakFn4/i9LODk3EEmPV8ezkYCI7H6KWH2MOdw==
X-Received: by 2002:a2e:8797:: with SMTP id n23mr9551828lji.176.1578918796765;
        Mon, 13 Jan 2020 04:33:16 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q186sm5903724ljq.14.2020.01.13.04.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 04:33:15 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C939C1804D6; Mon, 13 Jan 2020 13:33:13 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     gautamramk@gmail.com, netdev@vger.kernel.org,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net: sched: add Flow Queue PIE packet scheduler
In-Reply-To: <20200113041922.25282650@cakuba>
References: <20200110062657.7217-1-gautamramk@gmail.com> <20200110062657.7217-3-gautamramk@gmail.com> <20200112173624.5f7b754b@cakuba> <87eew3wpg9.fsf@toke.dk> <20200113041922.25282650@cakuba>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 13 Jan 2020 13:33:13 +0100
Message-ID: <87blr7wn7a.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 13 Jan 2020 12:44:38 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrot=
e:
>> Jakub Kicinski <kuba@kernel.org> writes:
>> > On Fri, 10 Jan 2020 11:56:57 +0530, gautamramk@gmail.com wrote:=20=20
>> >> From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
>> >>=20
>> >> Principles:
>> >>   - Packets are classified on flows.
>> >>   - This is a Stochastic model (as we use a hash, several flows might
>> >>                                 be hashed on the same slot)
>> >>   - Each flow has a PIE managed queue.
>> >>   - Flows are linked onto two (Round Robin) lists,
>> >>     so that new flows have priority on old ones.
>> >>   - For a given flow, packets are not reordered.
>> >>   - Drops during enqueue only.
>> >>   - ECN capability is off by default.
>> >>   - ECN threshold is at 10% by default.
>> >>   - Uses timestamps to calculate queue delay by default.
>> >>=20
>> >> Usage:
>> >> tc qdisc ... fq_pie [ limit PACKETS ] [ flows NUMBER ]
>> >>                     [ alpha NUMBER ] [ beta NUMBER ]
>> >>                     [ target TIME us ] [ tupdate TIME us ]
>> >>                     [ memory_limit BYTES ] [ quantum BYTES ]
>> >>                     [ ecnprob PERCENTAGE ] [ [no]ecn ]
>> >>                     [ [no]bytemode ] [ [no_]dq_rate_estimator ]
>> >>=20
>> >> defaults:
>> >>   limit: 10240 packets, flows: 1024
>> >>   alpha: 1/8, beta : 5/4
>> >>   target: 15 ms, tupdate: 15 ms (in jiffies)
>> >>   memory_limit: 32 Mb, quantum: device MTU
>> >>   ecnprob: 10%, ecn: off
>> >>   bytemode: off, dq_rate_estimator: off=20=20
>> >
>> > Some reviews below, but hopefully someone who knows more about qdiscs
>> > will still review :)=20=20
>>=20
>> I looked it over, and didn't find anything you hadn't already pointed
>> out below. It's pretty obvious that this started out as a copy of
>> sch_fq_codel. Which is good, because that's pretty solid. And bad,
>> because that means it introduces another almost-identical qdisc without
>> sharing any of the code...
>>=20
>> I think it would be worthwhile to try to consolidate things at some
>> point. Either by just merging code from fq_{codel,pie}, but another
>> option would be to express fq_codel and fq_pie using the fq{,_impl}.h
>> includes. Maybe even sch_cake as well, but that may take a bit more
>> work. Not sure if we should require this before merging fq_pie, or just
>> leave it as a possible enhancement for later? WDYT?
>
> Tricky :/ No strong opinion on my side. I'm already a little weary of
> added function calls in the fast path (e.g. pie_drop_early()), but using
> some static inlines wouldn't hurt... Then again since fq_codel doesn't
> use fq{,_impl}.h it indeed seems like a bigger project to clean things
> up.

Yeah, definitely a bigger project; and I do worry about regressions.
Especially since fq{,_impl}.h relies heavily on indirect calls...

> IMHO if this qdisc works and is useful it could probably be merged as
> is. Hopefully we can get an opinion on this from Stephen or others.

OK, fine with me :)

-Toke

