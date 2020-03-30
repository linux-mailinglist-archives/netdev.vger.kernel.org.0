Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7661197FF5
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 17:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgC3PmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 11:42:00 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:43980 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726497AbgC3PmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 11:42:00 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9213B600FA;
        Mon, 30 Mar 2020 15:41:59 +0000 (UTC)
Received: from us4-mdac16-19.ut7.mdlocal (unknown [10.7.65.243])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 939578009B;
        Mon, 30 Mar 2020 15:41:59 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.41])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0AA40280087;
        Mon, 30 Mar 2020 15:41:59 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 93F034C0075;
        Mon, 30 Mar 2020 15:41:58 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 30 Mar
 2020 16:41:49 +0100
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "Lorenz Bauer" <lmb@cloudflare.com>, Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk> <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
 <87imiqm27d.fsf@toke.dk> <20200327230047.ois5esl35s63qorj@ast-mbp>
 <87lfnll0eh.fsf@toke.dk> <20200328022609.zfupojim7see5cqx@ast-mbp>
 <87eetcl1e3.fsf@toke.dk>
 <CAEf4Bzb+GSf8cE_rutiaeZOtAuUick1+RnkCBU=Z+oY_36ArSA@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <53515939-00bb-174c-bc55-f90eaceac2a3@solarflare.com>
Date:   Mon, 30 Mar 2020 16:41:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzb+GSf8cE_rutiaeZOtAuUick1+RnkCBU=Z+oY_36ArSA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25322.003
X-TM-AS-Result: No-3.733700-8.000000-10
X-TMASE-MatchedRID: HXSqh3WYKfvmLzc6AOD8DfHkpkyUphL9+wkHrk36xsyZt08TfNy6OFNR
        SSIx92WyV1r5SEB2wabbOOxEG5SsnVDqf+tE0BQquV7H+spKHhMhXHiVbGfuY9uykrHhg4Pd3JM
        PHOsk+biKKj+nrOfba0vtw1XMFj02gKLoPFWEUId6UYddkosvawILzOoe9wbaJUPjXufzyHhAwV
        xIwdMCgesjiVPWXmP9jivevhMWxb1woTxwetcEI2XaK3KHx/xpfS0Ip2eEHnxlgn288nW9IN5/H
        gWYxplM5MIx11wv+COujVRFkkVsm7NoN/F4vivC3zjmrUHS6t4B1HxZbOGOS38CVb8Uaa23Uvw/
        mqei0gb8GIlFYrQaxsflKSVZe5Hv8SccHBx0EzLKiBNgIisOLIVyAlz5A0zC7xsmi8libwVi6nH
        ReNJA8sM4VWYqoYnhs+fe0WifpQo=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.733700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25322.003
X-MDID: 1585582919-FiRBV_k2cuOB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/03/2020 21:23, Andrii Nakryiko wrote:
> But you can't say the same about other XDP applications that do not
> use libxdp. So will your library come with a huge warning
What about a system-wide policy switch to decide whether replacing/
 removing an XDP program without EXPECTED_FD is allowed?  That way
 the sysadmin gets to choose whether it's the firewall or the packet
 analyser that breaks, rather than baking a policy into the design.
Then libxdp just needs to say in the README "you might want to turn
 on this switch".  Or maybe it defaults to on, and the other program
 has to talk you into turning it off if it wants to be 'ill-behaved'.
Either way, affected users will be driven to the kernel's
 documentation for the policy switch, where we can tell them whatever
 we think they need to know.

-ed
