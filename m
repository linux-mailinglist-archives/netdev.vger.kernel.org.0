Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA236CECA4
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 21:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfJGTVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 15:21:31 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:37806 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728187AbfJGTVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 15:21:31 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 78371140069;
        Mon,  7 Oct 2019 19:21:29 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 7 Oct
 2019 12:21:23 -0700
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
 <1871cacb-4a43-f906-9a9b-ba6a2ca866dd@solarflare.com>
 <CACAyw98mYK3Psv61+BDcyk56PbnJf2JhdfDLsB0eD4vLJJnGYQ@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <4124d5a6-06b7-ad03-f5fe-4b61e55fff27@solarflare.com>
Date:   Mon, 7 Oct 2019 20:21:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CACAyw98mYK3Psv61+BDcyk56PbnJf2JhdfDLsB0eD4vLJJnGYQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24960.005
X-TM-AS-Result: No-5.598300-4.000000-10
X-TMASE-MatchedRID: 1GZI+iG+MtfmLzc6AOD8DfHkpkyUphL9Ap+UH372RZUjRiu1AuxJTE+m
        MtGpzwaWovHdz/hFHkqVli3dUdHmduRL/dfzA4JW3PhB6Dd4M5fmKRpN3ALyIHGIg4EQe/dBPmW
        b5UMEjgS0B2i5o+ShBBT8Ws5yXMRK0KaUpJQo+cI5UYVNPDbxh6m9/6ObPjnDCnaX2vSsl/+nno
        CPGfH37GwkI7F60L1z3xAKL6qdqRlgX3W8U0UCB+KggdmU+sgMI5rZlsanIIVRD5heJnxuK+mWp
        qKXmZL5QzArtCOFCW5shc3hHvMHV54v+LC4Hz72AI0UpQvEYJkX2zxRNhh61egLopbDhV65ngIg
        pj8eDcByZ8zcONpAscRB0bsfrpPIHm9ggFVoCcDFTZbxzjF3V4JH59Px3o8Q2u0dOlpRB726pvW
        kHT1voL+02BO6uEW7ftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.598300-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24960.005
X-MDID: 1570476090-giMe7Opc1XgA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/10/2019 18:12, Lorenz Bauer wrote:
> Sure, but this is the simplest, not necessarily realistic use case. There
> is a reason that libbpf has the API it has. For example, we patch our
> eBPF before loading it. I'm sure there are other complications, which is
> why I prefer to keep loading my own programs.
Any reason why you can't have the client patch the eBPF (possibly with
 libbpf) before supplying the patched object file to the loaderiser?

>> No, I'm talking about doing a linker step (using the 'full-blown calls'
>>  _within_ an eBPF program that Alexei added a few months back) before the
>>  program is submitted to the kernel.  So the BPF_CALL|BPF_PSEUDO_CALL insn
>>  gets JITed to a direct call.
> Ah, I see. I'm not sure whether this restriction has been lifted, but those
> calls are incompatible with tail calls. So we wouldn't be able to use this.
Indeed, tail calls don't fit into my scheme, because being a tail-call from
 the subprogram doesn't make you a tail-call from the dispatcher program.
But AIUI tail calls are only in use today in various work-arounds for the
 lack of proper linking (including dynamic linking).  If we supported that,
 would you still need them?

>> OK, but in that case xdpd isn't evidence that the "loader" approach doesn't
>>  work, so I still think it should be tried before we go to the lengths of
>>  pushing something into the kernel (that we then have to maintain forever).
> Maybe this came across the wrong way, I never said it is.
No, you didn't (sorry).  Toke somewhat implied it, which is what I was
 responding to there.

-Ed
