Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83622A6F6F
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 22:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbgKDVQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 16:16:13 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:53602 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726152AbgKDVQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 16:16:12 -0500
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0AAB56007D;
        Wed,  4 Nov 2020 21:16:12 +0000 (UTC)
Received: from us4-mdac16-43.ut7.mdlocal (unknown [10.7.64.26])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 07C0D800B0;
        Wed,  4 Nov 2020 21:16:12 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.90])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 77D1280082;
        Wed,  4 Nov 2020 21:16:11 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D942E9C005F;
        Wed,  4 Nov 2020 21:16:10 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Nov 2020
 21:16:00 +0000
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>
CC:     David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
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
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com>
Date:   Wed, 4 Nov 2020 21:15:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25766.003
X-TM-AS-Result: No-2.907200-8.000000-10
X-TMASE-MatchedRID: fgYTp5XatxbmLzc6AOD8DfHkpkyUphL9ffXpER5TkJGfU46p0ASzaB2x
        y09wV0IjxkZvHPhWAryQNn3qLQygcwBeuT9ROxL1naJwCyoIjbzydGTzcdHw7psoi2XrUn/JIq9
        5DjCZh0zLOq+UXtqwWAtuKBGekqUpbGVEmIfjf3sHljKReaQYdJAA96KDAFX2Yp9BDB3Z5hHYvt
        AzrYyDHT0aAd9xlsgbUdNvZjjOj9C63BPMcrcQuXeYWV2RaAfD+kkf6HhPsBc=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.907200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25766.003
X-MDID: 1604524572-1ahBbnotrzbL
X-PPE-DISP: 1604524572;1ahBbnotrzbL
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/11/2020 03:11, Alexei Starovoitov wrote:
> The user will do 'tc -V'. Does version mean anything from bpf loading pov?
> It's not. The user will do "ldd `which tc`" and then what?
Is it beyond the wit of man for 'tc -V' to output somethingabout
 libbpf version?
Other libraries seem to solve these problems all the time, I
 haven't seen anyone explain what makes libbpf so special that it
 has to be different.

-ed
