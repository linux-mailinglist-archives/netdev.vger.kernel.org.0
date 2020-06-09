Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FF91F4821
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 22:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731284AbgFIUb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 16:31:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28781 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731078AbgFIUb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 16:31:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591734684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qeH8KRWl4cS1dUh8uwrpghLTTvP03Fsgf/QgFRRsHTE=;
        b=BXEHv40BZ8rdsOl05b8rwtebjJe1VB8HpaU4MOLv9vOEKzFBJOXeN6wb39ZuqSE5zYygFr
        KhWQXkbrF5UhHTb0IY9JE/N6ifIFlfqBGDHiFmh74Z6VRVtlMZFdkhnmX3d4CPfapxgkgN
        lqW2cJCqwwmQMWgzYJlvGXhHsK+HtIc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-2HDxlWovN-Gtf-VqVZtoIQ-1; Tue, 09 Jun 2020 16:31:22 -0400
X-MC-Unique: 2HDxlWovN-Gtf-VqVZtoIQ-1
Received: by mail-ej1-f72.google.com with SMTP id z21so39472ejl.6
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 13:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=qeH8KRWl4cS1dUh8uwrpghLTTvP03Fsgf/QgFRRsHTE=;
        b=V69ndj4olhbYzSLBzhn8rzsPOp6eGagPRt0gFxYKonaKT+Z72HfFNqzXqH9+FdJpdo
         kpFFXA6pxlxOtx2AxlfzjOc+NV4xlEnKEWgnjG3+vjIGyAKT/3GD/JtkcWKV03EV9mkX
         lsO9XAUiDMzTVlMnHLTBWr0WARLh5fscu4uhxwsizVWSzc4YKG/4SWNdqHMy7Y2Dy8YG
         8JLM3EJ5+lzMBlFwsCXXT67MylUC0eRKi5OEsJdx/VopbidBec762KIAe3H1zV5oma5X
         h1WzSAULQoDGqegDYShNYQ60+TRX6AH8rUK6A5Kp9C3q3aDdrTCj22OnW9sfB5YX7eqh
         cdHA==
X-Gm-Message-State: AOAM531/oq4FJ6miubhoIUFSYjN8KKqbBD5N5Vw8HJ8HDP/JBnz7QpaP
        mfN5Sj5h/O5AORxmwesbHFMsS0e/wTKkDNnKZN31jt05M6UtIW/0HDpr3qvtwkVZgDiZdPU/JTY
        x0sPdTbLVN1ISTME9
X-Received: by 2002:a17:907:4240:: with SMTP id oi24mr148214ejb.127.1591734681602;
        Tue, 09 Jun 2020 13:31:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNleHeE4GhA0E1Gq8Vcdsi9KWJVVGtL1l7bBGN/4hFIbLaCFU34mMapc+kiVa4/F85/JzZoQ==
X-Received: by 2002:a17:907:4240:: with SMTP id oi24mr148199ejb.127.1591734681392;
        Tue, 09 Jun 2020 13:31:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id nw22sm13956137ejb.48.2020.06.09.13.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 13:31:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BDAD5180654; Tue,  9 Jun 2020 22:31:19 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
In-Reply-To: <20200609030344.GP102436@dhcp-12-153.nay.redhat.com>
References: <20200603024054.GK102436@dhcp-12-153.nay.redhat.com> <87img8l893.fsf@toke.dk> <20200604040940.GL102436@dhcp-12-153.nay.redhat.com> <871rmvkvwn.fsf@toke.dk> <20200604121212.GM102436@dhcp-12-153.nay.redhat.com> <87bllzj9bw.fsf@toke.dk> <20200604144145.GN102436@dhcp-12-153.nay.redhat.com> <87d06ees41.fsf@toke.dk> <20200605062606.GO102436@dhcp-12-153.nay.redhat.com> <878sgxd13t.fsf@toke.dk> <20200609030344.GP102436@dhcp-12-153.nay.redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 09 Jun 2020 22:31:19 +0200
Message-ID: <87lfkw7zhk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> On Mon, Jun 08, 2020 at 05:32:54PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Hangbin Liu <liuhangbin@gmail.com> writes:
>>=20
>> > On Thu, Jun 04, 2020 at 06:02:54PM +0200, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >> Hangbin Liu <liuhangbin@gmail.com> writes:
>> >>=20
>> >> > On Thu, Jun 04, 2020 at 02:37:23PM +0200, Toke H=C3=83=C6=92=C3=82=
=C2=B8iland-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote:
>> >> >> > Now I use the ethtool_stats.pl to count forwarding speed and her=
e is the result:
>> >> >> >
>> >> >> > With kernel 5.7(ingress i40e, egress i40e)
>> >> >> > XDP:
>> >> >> > bridge: 1.8M PPS
>> >> >> > xdp_redirect_map:
>> >> >> >   generic mode: 1.9M PPS
>> >> >> >   driver mode: 10.4M PPS
>> >> >>=20
>> >> >> Ah, now we're getting somewhere! :)
>> >> >>=20
>> >> >> > Kernel 5.7 + my patch(ingress i40e, egress i40e)
>> >> >> > bridge: 1.8M
>> >> >> > xdp_redirect_map:
>> >> >> >   generic mode: 1.86M PPS
>> >> >> >   driver mode: 10.17M PPS
>> >> >>=20
>> >> >> Right, so this corresponds to a ~2ns overhead (10**9/10400000 -
>> >> >> 10**9/10170000). This is not too far from being in the noise, I su=
ppose;
>> >> >> is the difference consistent?
>> >> >
>> >> > Sorry, I didn't get, what different consistent do you mean?
>> >>=20
>> >> I meant, how much do the numbers vary between each test run?
>> >
>> > Oh, when run it at the same period, the number is stable, the range is=
 about
>> > ~0.05M PPS. But after a long time or reboot, the speed may changed a l=
ittle.
>> > Here is the new test result after I reboot the system:
>> >
>> > Kernel 5.7 + my patch(ingress i40e, egress i40e)
>> > xdp_redirect_map:
>> >   generic mode: 1.9M PPS
>> >   driver mode: 10.2M PPS
>> >
>> > xdp_redirect_map_multi:
>> >   generic mode: 1.58M PPS
>> >   driver mode: 7.16M PPS
>> >
>> > Kernel 5.7 + my patch(ingress i40e, egress i40e + veth(No XDP on peer))
>> > xdp_redirect_map:
>> >   generic mode: 2.2M PPS
>> >   driver mode: 14.2M PPS
>>=20
>> This looks wrong - why is performance increasing when adding another
>> target? How are you even adding another target to regular
>> xdp_redirect_map?
>>=20
> Oh, sorry for the typo, the numbers make me crazy, it should be only
> ingress i40e, egress veth. Here is the right description:
>
> Kernel 5.7 + my patch(ingress i40e, egress i40e)
> xdp_redirect_map:
>   generic mode: 1.9M PPS
>   driver mode: 10.2M PPS
>
> xdp_redirect_map_multi:
>   generic mode: 1.58M PPS
>   driver mode: 7.16M PPS
>
> Kernel 5.7 + my patch(ingress i40e, egress veth(No XDP on peer))
> xdp_redirect_map:
>   generic mode: 2.2M PPS
>   driver mode: 14.2M PPS

A few messages up-thread you were getting 4.15M PPS in this case - what
changed? It's inconsistencies like these that make me suspicious of the
whole set of results :/

Are you getting these numbers from ethtool_stats.pl or from the XDP
program? What counter are you looking at, exactly?

-Toke

