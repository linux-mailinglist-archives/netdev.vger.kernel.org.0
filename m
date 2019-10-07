Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBDECE98C
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 18:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbfJGQn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 12:43:57 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:51248 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727830AbfJGQn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 12:43:56 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2BD349C0074;
        Mon,  7 Oct 2019 16:43:51 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 7 Oct
 2019 09:43:46 -0700
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
 <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com>
 <A754440E-07BF-4CF4-8F15-C41179DCECEF@fb.com> <87r23vq79z.fsf@toke.dk>
 <20191003105335.3cc65226@carbon>
 <CAADnVQKTbaxJhkukxXM7Ue7=kA9eWsGMpnkXc=Z8O3iWGSaO0A@mail.gmail.com>
 <87pnjdq4pi.fsf@toke.dk>
 <1c9b72f9-1b61-d89a-49a4-e0b8eead853d@solarflare.com>
 <5d964d8ccfd90_55732aec43fe05c47b@john-XPS-13-9370.notmuch>
 <87tv8pnd9c.fsf@toke.dk>
 <68466316-c796-7808-6932-01d9d8c0a40b@solarflare.com>
 <CACAyw99oUfst5LDaPZmbKNfQtM2wF8fP0rz7qMk+Qn7SMaF_vw@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <1871cacb-4a43-f906-9a9b-ba6a2ca866dd@solarflare.com>
Date:   Mon, 7 Oct 2019 17:43:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CACAyw99oUfst5LDaPZmbKNfQtM2wF8fP0rz7qMk+Qn7SMaF_vw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24960.005
X-TM-AS-Result: No-6.867200-4.000000-10
X-TMASE-MatchedRID: PL66URbwWA/mLzc6AOD8DfHkpkyUphL9nrrV5UnUVY2bkEl1SMP4VemW
        pqKXmZL5t8muGnp6Eq/EgE7Tno8tKvFRSoBCNkty8t4fUUGeErT4h+uI7dxXxMPT+AtaXDv3At+
        0ZcdQf5SJbnWiPQEtz7w/krmG+Si6rsR9esMEBdpR5q8plSdLkCv2BWU4g3/qRv/VbO53xSMJ6V
        VB2qvK12JXtXLTI0rsR9K0Q1TPp1QTfiYqpBGJ6YEAfO/kEruh6KK2AH8K6JCRiV0eo0RbuA6bZ
        1WJGXu36yOJU9ZeY/1HFC0S3Nf0DC/BzHgNxUHbKy67dnbJjn4G0bqd61ORpfkuQv9PIVnNVO8u
        Dr35ISiHhCu0DQxictwh+Y3NgapYJ3fsH+8uclq0pXj1GkAfe2QBrQiRNt2IuM5RdaZDc5ZLUlZ
        L63EH/wmhzSkalvLQM00t02f9inbmg2H4HFDk9887s4OnYGuCprzcyrz2L13Ib96UUXRrmzs+wd
        44iD9CfS0Ip2eEHnzWRN8STJpl3PoLR4+zsDTtIAmDJ33Ctzz+BdfvD/lwSPIhqAIy6l6j1TZHx
        3qeDpj3Xzv0mKqiiHm4bkt+ejt4
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.867200-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24960.005
X-MDID: 1570466634-xpr2ov9_0X0o
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/10/2019 16:58, Lorenz Bauer wrote:
> If you want to support
> all use cases (which you kind of have to) then you'll end up writing an
> RPC wrapper for libbpf,
Yes, you more-or-less would need that.  Though I think you can e.g. have
 the clients load & pin their own maps and then pass the map fds over
 SCM_RIGHTS (though I'm not sure if our current permissions system is
 granular enough for that).

> which sounds very painful to me.
I might be being naïve, but it doesn't sound more painful than is normal
 for userland.  I mean, what operations have you got-
* create/destroy map (maybe, see above)
* load prog (pass it an fd from which it can read an ELF, and more fds
  for the maps it uses.  Everything else, e.g. BTFs, can just live in the
  ELF.)
* destroy prog
* bind prog to hook (admittedly there's a long list of hooks, but this is
  only to cover the XDP ones, so basically we just have to specify
  interface and generic/driver/hw)
-that doesn't seem like it presents great difficulties?

>> Incidentally, there's also a performance advantage to an eBPF dispatcher,
>>  because it means the calls to the individual programs can be JITted and
>>  therefore be direct, whereas an in-kernel data-driven dispatcher has to
>>  use indirect calls (*waves at spectre*).
> This is if we somehow got full blown calls between distinct eBPF programs?
No, I'm talking about doing a linker step (using the 'full-blown calls'
 _within_ an eBPF program that Alexei added a few months back) before the
 program is submitted to the kernel.  So the BPF_CALL|BPF_PSEUDO_CALL insn
 gets JITed to a direct call.

(Although I also think full-blown dynamically-linked calls ought not to be
 impossible, *if* we restrict them to taking a ctx and returning a u64, in
 which case the callee can be verified as though it were a normal program,
 and the caller's verifier just treats the program as returning an unknown
 scalar.  The devil is in the details, though, and it seems no-one's quite
 wanted it enough to do the work required to make it happen.)

>> Maybe Lorenz could describe what he sees as the difficulties with the
>>  centralised daemon approach.  In what ways is his current "xdpd"
>>  solution unsatisfactory?
> xdpd contains the logic to load and install all the different XDP programs
> we have. If we want to change one of them we have to redeploy the whole
> thing. Same if we want to add one. It also makes life-cycle management
> harder than it should be. So our xdpd is not at all like the "loader"
> you envision.
OK, but in that case xdpd isn't evidence that the "loader" approach doesn't
 work, so I still think it should be tried before we go to the lengths of
 pushing something into the kernel (that we then have to maintain forever).

No promises but I might find the time to put together a strawman
 implementation of the loader, to show how I envisage it working.

-Ed
