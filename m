Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAF235FEC1
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhDOAMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:12:49 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46177 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229889AbhDOAMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 20:12:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E78665C012F;
        Wed, 14 Apr 2021 20:12:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 14 Apr 2021 20:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        vCNx4A6yZ2nFYr+/iSAE2unNH1yQCaYi3B5zUjWAn9U=; b=4KA2UGiPc6cFPCoU
        GhdPHHBVyiZmbS5GDYAHp4Kcxo2oW+ktokviE2ia4Gr4PvD0Kdx97Af1yKRotS03
        aGDK7fWu7Pz5BlpRDNNlgHGv7vXcLReTtijfZ4bvIwsVbKM2+5jnhfPIQpyXkO+n
        IJgYrYX1/IKaftwqpYbGLnTkbSPR6FsEAnidqsIK+ukiahiTTWrHFcy0hf+QZcaT
        6iTgz83NTLMUaJBA7iLZnUgGUbpv/Fxfei2+tlA/qWSzWnjhgt6xwnwPswa+Lpyu
        7HVvm06qy1I91e3Lo3TIEqgmVatffdVetg4wgGzhDrUjcG5BWHTKPXv2beUV73JE
        VFZWdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=vCNx4A6yZ2nFYr+/iSAE2unNH1yQCaYi3B5zUjWAn
        9U=; b=iGu15CEStb1bTemlDVmIETXSx0Pvb7gQQiVxs+Ei5wha/aRGTCTTw5Ruh
        bpB+bXo71/M0NQpEbba56/iyFHLGV0rkSGuFwizR37HYNkqnjxPKe/cfwhE8oqvm
        yCZRtlIR3FbLzKHs3IdiJTp9DRK05KwENf7tNGwlc9TYVfjlzwI/uttFLuVDcjEG
        0wgZK8fYxystsgiwGNOLzg+WUm2l4+1qoFQS9KJtMKLiTARxjbag+Pa9wlSxsi84
        jT2hUB5/rjxgiGwLhc+DczbjJrop8EonXQMGNPlApchWOnIRS5IKQTk4jMtxvK3Y
        wgCyUMNPndyJx+1e4mOwsnSMm01fg==
X-ME-Sender: <xms:6IR3YFnVWQxkR_9_JJJfJqWLuNExti3JgUulKe18gve-IwR8hQHQFQ>
    <xme:6IR3YA3p7xusOy4plpnYvRh9Y9VX3pa56Q0uHzcS0uzfFsfpQZC717K3lU-RiLJjq
    Y2ZnYrgVGT1-9d8fA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthekredttderjeenucfhrhhomhepvehhrhhi
    shcuvfgrlhgsohhtuceotghhrhhishesthgrlhgsohhthhhomhgvrdgtohhmqeenucggtf
    frrghtthgvrhhnpeffhffhvdfgheejffegveeilefffeegheefhedtvefgfeeuteeuffdv
    jeekudegteenucfkphepjedvrdelhedrvdegfedrudehieenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegthhhrihhssehtrghlsghothhhohhm
    vgdrtghomh
X-ME-Proxy: <xmx:6IR3YLpA5IXC9Gtaqlyw78eLtYGlfRqBqGuLYG3u20qF1bajaCmNyg>
    <xmx:6IR3YFkXslB7rkD_m2HrJC3-K9F74YDa4PKkgTKUhgrF3IrUb8I3Gg>
    <xmx:6IR3YD2rHU1NVzdm5Jn1TvJTrDj8DYwUQLWw44dOBp8aNS-FrfE61Q>
    <xmx:6YR3YD85HrLwLELIjCf5be-ZmqPxzIn0MhgecDaNVhv7Uilo3voQQg>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 51743108005C;
        Wed, 14 Apr 2021 20:12:23 -0400 (EDT)
Message-ID: <0acefd2501e228328147911c7ba878b2fcd0cf3b.camel@talbothome.com>
Subject: Re: Bug#985893: Forking on MMSD
From:   Chris Talbot <chris@talbothome.com>
To:     Wookey <wookey@wookware.org>,
        Marius Gripsgard <marius@ubports.com>, 985893@bugs.debian.org
Cc:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm, 982250@bugs.debian.org
Date:   Wed, 14 Apr 2021 20:12:21 -0400
In-Reply-To: <20210414220948.GL11215@mail.wookware.org>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
         <634e0debea558b90af2cebfc99518071f1d630e9.camel@talbothome.com>
         <d01f59bbfdc3c8d5d33fa7fca12ec5e8fe74b837.camel@talbothome.com>
         <9acefe05-29ab-4cb9-8fef-982eb9deb79a@ubports.com>
         <20210414220948.GL11215@mail.wookware.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On Wed, 2021-04-14 at 23:09 +0100, Wookey wrote:
> On 2021-04-14 18:39 +0000, Marius Gripsgard wrote:
> 
> > I would really like to avoid a fork, it's not worth doing dual
> > work. Did you ping ofono devs at irc?  Also have you sent upstream
> > patches? If a fork is the way you want to go, you will need to
> > rename it as the existing packages need to follow upstream, we
> > can't
> > just rip an existing packages away from upstream.
> 
> Debian can package mmsd with whatever set of patches it sees fit. If
> the end result is ChrisT's version, with Modem Manager support, then
> I
> think that's reasonable. mmsd is not currently packaged in debian so
> I
> don't think a rename is required. Ultimately it's up to maintainers
> to
> choose which upstream is most appropriate. There used to be only one,
> but increasingly one gets a choice of varying degrees of active
> maintenance. (This can be a huge pain making life quite awkward for
> maintainers, and I find Debian is the only org trying to unify a
> diverse set of versions where a load of people have scratched their
> own itch and then just left it like that.)
> 

At this point, fork of mmsd should still work with ofono. I have not
disturbed anything ofono related, and have made several improvements to
the core that should benefit ofono too.

I would in addition welcome someone from ofono to work with me! I would
rather mmsd work with both stacks (as we all benefit from that). The
Mobian and PostmarketOS developers have welcomed me, and I am happy to
work with you all too. I joined the UBports matrix channel and
introduced myself (in addition to asking how you all contact the ofono
folks), you are free to reach out to me.

> Ultimately we want the best functionality for our users, and if the
> old upstream has been inactive for years then using this new,
> maintained version of mmsd may well be the best course. Efforts
> should
> continue to either give Chris access to the original repo or
> officially declare it 'under new management' so that there is a
> canonical place for the codebase, but in the meantime it's OK for
> debian to have a big patch.
> 

I admittedly do not know who to contact for repo access? I asked on the
Kernelnewbies IRC/Mailing list (as I am a bit of a kernel newbie), but
I did not hear anything back.

I am not trying to start a fork because I want to, and if you look at
Ofono's ML history, you can see that I have tried a lot to work with
upstream. I am starting a fork because I feel this is the only way I
can really move forward in getting MMS working. Without MMS,
unfortunately the Pinephone I have is little more than a toy with me,
and I put a lot of work into getting MMS working on the Modem Manager
stack.

> Versioning could be tricky in some situations, but SFACT the ofono
> mmsd is just 0.0 so the debian version can be 0.0.something and
> remain
> compatible with a shift back to that repo at some point.
> 
> Wookey

Thank you!

Respectfully,
Chris Talbot

