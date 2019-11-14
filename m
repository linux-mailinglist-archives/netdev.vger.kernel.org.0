Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8050DFC3DE
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKNKTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:19:10 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:50762 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726505AbfKNKTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:19:10 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6644B4C0066;
        Thu, 14 Nov 2019 10:19:07 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 14 Nov
 2019 10:18:59 +0000
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
CC:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <20191113204737.31623-1-bjorn.topel@gmail.com>
 <20191113204737.31623-3-bjorn.topel@gmail.com>
 <fa188bb2-6223-5aef-98e4-b5f7976ed485@solarflare.com>
 <CAJ+HfNiDa912Uwt41_KMv+Z-sGr8fU7s4ncBPiUSx4PPAMQQqQ@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <96811723-ab08-b987-78c7-2c9f2a0a972c@solarflare.com>
Date:   Thu, 14 Nov 2019 10:18:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNiDa912Uwt41_KMv+Z-sGr8fU7s4ncBPiUSx4PPAMQQqQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25042.003
X-TM-AS-Result: No-6.773600-8.000000-10
X-TMASE-MatchedRID: oHOSwQSJZWjmLzc6AOD8DfHkpkyUphL9WDtrCb/B2hCL76yI7MxYJd3o
        UtLnebnZ8PxmVvwArq1eKE5I5ZUPHP+j7mX1lKC+PE3khmVvHO4jmtmWxqcghfkuQv9PIVnNY9g
        fdlvEXXSL9VH/M1mj8I8a4JkbB3qj8mSY8pCopWVFd2K6RlAKAalHaQwZyzDtgOlK2zN496l6xL
        6D9mrQLn661BcNrPuogiJroqebj3V41hKqyBRVQUM/y5EMs/JmUb4EdIZGxuBJfyfUaPjAATwc8
        MUw3x8i4HEFwUDiSZ4DTO7t0MJ81QgD4C8clR7Vggra2NOo2i1kAa0IkTbdiE+86maMM3aSd/X/
        X8atqku5dS8rfLvDVLvTPBmQOKTatjezNnTwro6JUlmL3Uj0mDsY2/UEG7fkt17WNImWY5DDi9z
        /5KX8tlcEwZrkbL18l+IrlvQnhmKvMyWwzFWyi51U1lojafr/fS0Ip2eEHnxlgn288nW9IAuTLp
        o5HEc1joczmuoPCq2Y/rC/ht97wGv385DMLr8xy1ZMtZ0r+5Dc+hNhe9IxQOFfg3KapaFv
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.773600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25042.003
X-MDID: 1573726749-PPAhnXFB58cq
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/11/2019 06:29, Björn Töpel wrote:
> On Wed, 13 Nov 2019 at 22:41, Edward Cree <ecree@solarflare.com> wrote:
>> On 13/11/2019 20:47, Björn Töpel wrote:
>> The first-come-first-served model for dispatcher slots might mean that
>>  a low-traffic user ends up getting priority while a higher-traffic
>>  user is stuck with the retpoline fallback.  Have you considered using
>>  a learning mechanism, like in my dynamic call RFC [1] earlier this
>>  year?  (Though I'm sure a better learning mechanism than the one I
>>  used there could be devised.)
> My rationale was that this mechanism would almost exclusively be used
> by physical HW NICs using XDP. My hunch was that the number of netdevs
> would be ~4, and typically less using XDP, so a more sophisticated
> mechanism didn't really make sense IMO.
That seems reasonable in most cases, although I can imagine systems with
 a couple of four-port boards being a thing.  I suppose the netdevs are
 likely to all have the same XDP prog, though, and if I'm reading your
 code right it seems they'd share a slot in that case.

> However, your approach is more
> generic and doesn't require any arch specific work. What was the push
> back for your work?
Mainly that I couldn't demonstrate a performance benefit from the few
 call sites I annotated, and others working in the area felt that
 manual annotation wouldn't scale — Nadav Amit had a different approach
 [2] that used a GCC plugin to apply a dispatcher on an opt-out basis
 to all the indirect calls in the kernel; the discussion on that got
 bogged down in interactions between text patching and perf tracing
 which all went *waaaay* over my head.  AFAICT the static_call series I
 was depending on never got merged, and I'm not sure if anyone's still
 working on it.

-Ed

[2] https://lkml.org/lkml/2018/12/31/19
