Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280B7432800
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 21:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhJRT4E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 18 Oct 2021 15:56:04 -0400
Received: from pegasus.erg.abdn.ac.uk ([137.50.19.135]:57912 "EHLO
        pegasus.erg.abdn.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbhJRT4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 15:56:03 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Oct 2021 15:56:03 EDT
Received: from [192.168.1.70] (fgrpf.plus.com [212.159.18.54])
        by pegasus.erg.abdn.ac.uk (Postfix) with ESMTPSA id 639B41B0010F;
        Mon, 18 Oct 2021 20:43:42 +0100 (BST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From:   Gorry Fairhurst <gorry@erg.abdn.ac.uk>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH net-next 2/2] fq_codel: implement L4S style ce_threshold_ect1 marking
Date:   Mon, 18 Oct 2021 20:43:41 +0100
Message-Id: <853050D3-3EA0-4D8F-97EF-3D21385F1647@erg.abdn.ac.uk>
References: <A2749FBB-6963-4043-9A1D-E950AF4ACE62@gmail.com>
Cc:     Bob Briscoe <ietf@bobbriscoe.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Eric Dumazet <edumazet@google.com>,
        Tom Henderson <tomh@tomh.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        "David S . Miller" <davem@davemloft.net>
In-Reply-To: <A2749FBB-6963-4043-9A1D-E950AF4ACE62@gmail.com>
To:     Jonathan Morton <chromatix99@gmail.com>
X-Mailer: iPad Mail (17E262)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Your  summary seems way off the mark to me, and I suggest you ask Wes Eddy for an actual summary of the current status ... 

Gorry


> On 18 Oct 2021, at 16:43, Jonathan Morton <chromatix99@gmail.com> wrote:
> 
> ﻿
>> 
>>> On 17 Oct, 2021, at 2:22 pm, Bob Briscoe <ietf@bobbriscoe.net> wrote:
>>> 
>>> I'll be blunter:
>>> 
>>> In its original (and currently stable) form, fq_codel is RFC-compliant.  It conforms, in particular, to RFC-3168 (ECN).  There's a relatively low threshold for adding RFC-compliant network algorithms to Linux, and it is certainly not required to have a published RFC specifically describing each qdisc's operating principles before it can be upstreamed.  It just so happens that fq_codel (and some other notable algorithms such as CUBIC) proved sufficiently useful in practice to warrant post-hoc documentation in RFC form.
>>> 
>>> However, this patch adds an option which, when enabled, makes fq_codel *non-compliant* with RFC-3168, specifically the requirement to treat ECT(0) and ECT(1) identically, unless conforming to another published RFC which permits different behaviour.
>>> 
>>> There is a path via RFC-8311 to experiment with alternative ECN semantics in this way, but the way ECT(1) is used by L4S is specifically mentioned as requiring a published RFC for public deployments.  The L4S Internet Drafts have *just failed* an IETF WGLC, which means they are *not* advancing to publication as RFCs in their current form.
>> 
>> [BB] Clarification of IETF process: A first Working Group Last Call (WGLC) is nearly always the beginning of the end of the IETF's RFC publication process. Usually the majority of detailed comments arrive during a WGLC. Then the draft has to be fixed, and then it goes either directly through to the next stage (in this case, an IETF-wide last call), or to another WGLC.
> 
> Further clarification: this is already the second WGLC for L4S.  The one two years previously (at Montreal) yielded a number of major technical objections, which remained unresolved as of this latest WGLC.
> 
>>> The primary reason for this failure is L4S' fundamental incompatibility with existing Internet traffic, despite its stated goal of general Internet deployment.
>> 
>> [BB] s/The primary reason /JM's primary objection /
>> There is no ranking of the reasons for more work being needed.  The WG had already developed a way to mitigate this objection. Otherwise, a WGLC would not have been started in the first place. Further work on this issue is now more likely to be wordsmithing.
> 
> Given that the objections cited by the TSVWG Chairs were technical in nature, and related specifically to the incompatibility between L4S and existing conventional traffic, it is clear to me that wordsmithing will *not* be sufficient to render L4S publishable in RFC form, nor deployable at Internet scale.  
> 
> To quote David Black, one of the aforementioned Chairs and also an author of RFC-8311:
> 
>> Two overall conclusions are that a) the WGLC has been productive, and shows significant continuing support for L4S, and b) the L4S drafts should be revised to address the WGLC concerns raised.   The WG chairs strongly suggest that the revisions include limiting the scope and impact of initial L4S experiments on RFC 3168 functionality (both existing usage and potential deployment) to ensure that the L4S experiments are safe to perform on the Internet, paying particular attention to potential impacts on networks and users that are not participating in the L4S experiments.
> 
> It is my recommendation to netdev to stay out of this ongoing mess, by rejecting this patch.
> 
> - Jonathan Morton

