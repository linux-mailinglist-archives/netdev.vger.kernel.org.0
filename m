Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D2A2A70EC
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 00:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgKDXF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 18:05:57 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.48]:53998 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728301AbgKDXF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 18:05:56 -0500
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EA0C2600BD;
        Wed,  4 Nov 2020 23:05:55 +0000 (UTC)
Received: from us4-mdac16-23.ut7.mdlocal (unknown [10.7.65.247])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E66188009E;
        Wed,  4 Nov 2020 23:05:55 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.90])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6628B8006A;
        Wed,  4 Nov 2020 23:05:55 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F03729C005E;
        Wed,  4 Nov 2020 23:05:54 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Nov 2020
 23:05:44 +0000
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Hangbin Liu <haliu@redhat.com>, David Ahern <dsahern@gmail.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
 <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com>
 <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
Date:   Wed, 4 Nov 2020 23:05:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25766.003
X-TM-AS-Result: No-1.515600-8.000000-10
X-TMASE-MatchedRID: Jm7Yxmmj9OnmLzc6AOD8DfHkpkyUphL9WDtrCb/B2hARGC0rW8q1Xa2k
        qu8N8Z6gjbUqhuP4DgE/a3iI4EhF3zy85MOgqDd3GctYiGlVjB/ahA35D/bWBFp3Ei6xxmePXvb
        V/VnUv0qcdgImt2fnOLC8HNjVMLYUFOKk4UrUPgXmXEF3MwNZbn2K69afcnwqVWQnHKxp38ihcU
        SGWPyoCQPfHajKM2sCBaafuX8ZUps1mB4DwaTV1qOknopQLzTu8qeI5MA2SKR727cs+BZZRrcwZ
        LpPFTtAaOBJAM+wLRw4LxgJSVfCdYFLOlyz97WhNDrSVZCgbSumUoJ5iJZBr7EtLGRAe3PGesS+
        g/Zq0C76DxBeqeXlOqqWalXMgUb91zJTsMOHLjrnVHXBUzVvZNBQpvv5cj0gJJjt/ngrkz8k1mQ
        4C5BObp6fbj1zw/ix2CZ7T0FVcRTFVSBMr2cm9MzSKGx9g8xhywXStpqWmJZ7eGs179ltWZ5wam
        ltgCNJm+k82PC+tGTRMuzjTM1Wt8RBLZ5x+SkXngIgpj8eDcByZ8zcONpAscRB0bsfrpPIcSqbx
        BgG0w7KpO6qO1dZZL39VMPFRmMT0r4EyuzY7XFNEE+ml4S71fDzwTlmVMdjuO8r3cBqcThWu9cr
        rsVGVRk8KNSxhtI48LUy05gu3pDUNewp4E2/TgSpmVYGQlZ3sxk1kV1Ja8fhIo573pBCBw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.515600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25766.003
X-MDID: 1604531155-b2pbJnnWe2I2
X-PPE-DISP: 1604531155;b2pbJnnWe2I2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/11/2020 22:10, Alexei Starovoitov wrote:
> On Wed, Nov 4, 2020 at 1:16 PM Edward Cree <ecree@solarflare.com> wrote:
>> On 04/11/2020 03:11, Alexei Starovoitov wrote:
>>> The user will do 'tc -V'. Does version mean anything from bpf loading pov?
>>> It's not. The user will do "ldd `which tc`" and then what?
>> Is it beyond the wit of man for 'tc -V' to output somethingabout
>>  libbpf version?
>> Other libraries seem to solve these problems all the time, I
>>  haven't seen anyone explain what makes libbpf so special that it
>>  has to be different.
> slow vger? Please see Daniel and Andrii detailed explanations.
Nah, I've seen that subthread(vger is fine).  I felt that subthread
 was missing this point about -V which is why I replied where it was
 brought up.
Daniel and Andrii have only explained why users will want to have an
 up-to-date libbpf, they (and you) haven't connected it to any
 argument about why static linking is the way to achieve that.
> libbpf is not your traditional library.
This has only been asserted, not explained.
I'm fully willing to entertain the possibility that libbpf is indeed
 special.  But if you want to win people over, you'll need to
 explain *why* it's special.
"Look at bfd and think why" is not enough, be more explicit.

AIUI the API between iproute2 and libbpf isn't changing, all that's
 happening is that libbpf is gaining new capabilities in things that
 are totally transparent to iproute2 (e.g. BTF fixups).  So the
 reasonable thing for users to expect is "I need new BPF features,
 I'll upgrade my libbpf", and with dynamic linking that works fine
 whether they upgrade iproute2 too or not.
This narrative is, on the face of it, just as plausible as "I'm
 getting an error from iproute2, I'll upgrade that".  And if distros
 decide that that's a common enough mistake to matter, then they can
 make the newer iproute2 package depend on a newer libbpf package,
 and apt or yum or whatever will automagically DTRT.
Whereas if you tightly couple them from the start, distros can't
 then go the other way if it turns out you made the wrong choice.
 (What if someone can't use the latest iproute2 release because it
 has a regression bug that breaks their use-case, but they need the
 latest libbpf for one of your shiny new features?)

Don't get me wrong, I'd love a world in which static linking was the
 norm and we all rebuilt our binaries locally every time we upgraded
 a piece.  But that's not the world we live in, and consistency
 *within* a distro matters too...

-ed
