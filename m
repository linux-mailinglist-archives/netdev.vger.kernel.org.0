Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A79197F8B
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 17:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgC3PZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 11:25:22 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:50622 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728124AbgC3PZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 11:25:22 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 120D360109;
        Mon, 30 Mar 2020 15:25:22 +0000 (UTC)
Received: from us4-mdac16-47.ut7.mdlocal (unknown [10.7.66.14])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 12DF8800A4;
        Mon, 30 Mar 2020 15:25:22 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.41])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 50F178006C;
        Mon, 30 Mar 2020 15:25:21 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9C9A84C0064;
        Mon, 30 Mar 2020 15:25:20 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 30 Mar
 2020 16:25:09 +0100
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@gmail.com>
CC:     Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk>
 <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com>
 <CACAyw98yYE+eOx5OayyN2tNQeNqFXnHdRGSv6DYX7ehfMHt1+g@mail.gmail.com>
 <9f0ab343-939b-92e3-c1b8-38a158da10c9@gmail.com>
 <20200327230253.txq54keztlwsok2s@ast-mbp>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <eba2b6df-e2e8-e756-dead-3f1044a061cd@solarflare.com>
Date:   Mon, 30 Mar 2020 16:25:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200327230253.txq54keztlwsok2s@ast-mbp>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25322.003
X-TM-AS-Result: No-3.433400-8.000000-10
X-TMASE-MatchedRID: HXSqh3WYKfvmLzc6AOD8DfHkpkyUphL9BufmGocTlvWOGxiV2ubMaRcT
        3zLrF0OWIhFEhnQLWa/xNyZ+3wKjYG94Ipa1otxoNDrSVZCgbStYyqUhAqJUSZdtxl+wLu3UXJd
        qpY2vVhK0xgJ2yHF4fnQH5Vble25igxRTSLSLS/zc+EHoN3gzlxfbPFE2GHrVwCTIeJgMBBuf89
        1sDZrL6TsKdozCX9PcSVCfHwfEC852yPj1XXqlKdMj64h53798FS5zy5+4YH19stn3xL6PO6PFj
        JEFr+olSXhbxZVQ5H+OhzOa6g8KrSa9b7oykCOWhctkuhYntxN60F/eInHJFPubAAkHYwk4e5QD
        SBGzKJrQdgR5kZeHvC0QKO1FCLmGogUAR7tjSZu1f1VMn08DxeL59MzH0po2K2yzo9Rrj9wPoYC
        35RuihKPUI7hfQSp5eCBcUCG1aJiUTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.433400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25322.003
X-MDID: 1585581921-unFOLmgqAoOC
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/03/2020 23:02, Alexei Starovoitov wrote:
> On Fri, Mar 27, 2020 at 10:12:05AM -0600, David Ahern wrote:
>> I had a thought yesterday along similar lines: bpf_link is about
>> ownership and preventing "accidental" deletes.
> The mechanism for "human override" is tbd.
Then that's a question you really need to solve, especially if you're
 going to push bpf_link quite so... forcefully.
Everything that a human operator can do, so can any program with the
 same capabilities/wheel bits.  Especially as the API that the
 operator-tool uses *will* be open and documented.  The Unix Way does
 not allow unscriptable interfaces, and heavily frowns at any kind of
 distinction between 'humans' and 'programs'.
So what will the override look like?  A bpf() syscall with a special
 BPF_F_IM_A_HUMAN_AND_I_KNOW_WHAT_IM_DOING flag?  ptracing the link
 owner, so that you can close() its fd?  Something in between?

In any case, the question is orthogonal to the bpf_link vs. netlink
 issue: the netlink XDP attach could be done with a flag that means
 "don't allow replacement/removal without EXPECTED_FD".  No?

-ed
