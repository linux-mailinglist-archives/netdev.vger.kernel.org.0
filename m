Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BD9279A1E
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 16:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgIZObq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 10:31:46 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53191 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726210AbgIZObq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 10:31:46 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Sep 2020 10:31:45 EDT
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B2A125C00E1;
        Sat, 26 Sep 2020 10:23:26 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute4.internal (MEProxy); Sat, 26 Sep 2020 10:23:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        stressinduktion.org; h=mime-version:message-id:in-reply-to
        :references:date:from:to:cc:subject:content-type; s=fm1; bh=iqo2
        xUNUJAElwyhIrFk5iBw1Rq7pFZwG+r8pzZ1Shbk=; b=cHJYHcFUoZSnHLa/mtr8
        wudK4Td2sG7ek3cjt/OmMJejOGgcSb0eXdrElW5e4KbM7/kz0JSxehhAK5IMpBey
        WhEF4YKUVR45EJ7odWhZKTCt18LtyxYtFfiCWPFjOCykYorQpPgB1MX0wXZCTF7x
        1Qs8giTZAOGooqldxfRGnNolkEEe7Vej2RHwYMEkco3uY42EkIPrSCJ3y9ovTk/U
        FKEIdb6yhJKdgDiM8QImYQC9picLTZy+4epdKLEw3Xnsw5oXrmn+hKVyF3E80CVg
        HNP7IY8qvIUEDsf6jFIVa9w9j0mBQTCVwLnLRCZq13Vg2Afz1TNs0l0oIsokF2NY
        HQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=iqo2xU
        NUJAElwyhIrFk5iBw1Rq7pFZwG+r8pzZ1Shbk=; b=nKB1zHegNFqz6e5wxicSSs
        c+JYxEag7T6ryTd6npdCEqEg+u5x3je4bl4RV85fnTCuv/MtxiNP8XqHLbsycD6t
        Mhcd7RJV0kTYvCLiYCufphDsrYsM9XDBA3iE/EyI7y47TL+Hu3V/KlsAqWOd0zCs
        ZkUTl0iNHUgspXDO6LpZuz8McLWLS4IZNQRjHnLGE6zMlOLBIS5rH4moYdggCU6Y
        s8SjtNoztJThh2rlq0jY6IG+zsmAbrtoeFnvB6KWHnSVQg6YFW7MuDPQXEYf2pnf
        Y/aemKh0g2WbVUNpCbLEhVLW28+Jra+6GTnsB9C3wqGeyXEYME4137NEMahzC/Pw
        ==
X-ME-Sender: <xms:3k5vX_OpXpBY1tBj9Zvv0Qw9Sw02e-3hsmebMYvEuf_SGQyW_WMB0g>
    <xme:3k5vX5_K-DJ446ZyNDR0pTTookv_kDKyOD2wMC7JPW01bYCCGVs1bgAKkaANet_Ka
    m5k7oJwst15R2zKEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddvgdejjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderreejnecuhfhrohhmpedfjfgrnhhn
    vghsucfhrhgvuggvrhhitgcuufhofigrfdcuoehhrghnnhgvshesshhtrhgvshhsihhnug
    hukhhtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepvdffgfeiffdvtdekfffffeeu
    lefhieevvdfhjeegiefggeetgffhieekheehvedunecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhephhgrnhhnvghssehsthhrvghsshhinhguuhhk
    thhiohhnrdhorhhg
X-ME-Proxy: <xmx:3k5vX-R37d0Fir6tCJ5mZXPElsURYcCTI1qe91EpS9usOc8ii73gAA>
    <xmx:3k5vXztQ5lqky2MDnfMZ2X7kIntTGaGGG422GikWn9S1-oMxAjOfsQ>
    <xmx:3k5vX3fvzPxhhBQo5FefEH04UYjguVxAIPuCiVW6AWJmHT7zTL689g>
    <xmx:3k5vX-6hv13OcgO44fFk0x1lbOzw9OfE8YMDO1yamJNo0-N6jM6Alg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 3A1B3E0227; Sat, 26 Sep 2020 10:23:25 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.3.0-355-g3ece53b-fm-20200922.004-g3ece53b9
Mime-Version: 1.0
Message-Id: <021e455b-faaf-4044-94bb-30291e1c9ee1@www.fastmail.com>
In-Reply-To: <CAEA6p_DyU7jyHEeRiWFtNZfMPQjJJEV2jN1MV-+5txumC5nmZg@mail.gmail.com>
References: <20200914172453.1833883-1-weiwan@google.com>
 <20200914172453.1833883-2-weiwan@google.com>
 <2ab7cdc1-b9e1-48c7-89b2-a10cd5e19545@www.fastmail.com>
 <CAEA6p_DyU7jyHEeRiWFtNZfMPQjJJEV2jN1MV-+5txumC5nmZg@mail.gmail.com>
Date:   Sat, 26 Sep 2020 16:22:23 +0200
From:   "Hannes Frederic Sowa" <hannes@stressinduktion.org>
To:     "Wei Wang" <weiwan@google.com>
Cc:     "David Miller" <davem@davemloft.net>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>, "Felix Fietkau" <nbd@nbd.name>
Subject: =?UTF-8?Q?Re:_[RFC_PATCH_net-next_1/6]_net:_implement_threaded-able_napi?=
 =?UTF-8?Q?_poll_loop_support?=
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, Sep 26, 2020, at 01:50, Wei Wang wrote:
> On Fri, Sep 25, 2020 at 12:46 PM Hannes Frederic Sowa
> <hannes@stressinduktion.org> wrote:
> > The format string is only based on variable strings. To ease a quick
> > grep for napi threads with ps I would propose to use "napi-%s-%d" or
> > something alike to distinguish all threads created that way.
> >
> 
> Ack. Will add this in the next version.

I think the convention would be to use "napi/%s-%d".

> > Some other comments and questions:
> >
> > Back then my plan was to get this somewhat integrated with the
> > `threadirqs` kernel boot option because triggering the softirq from
> > threaded context (if this option is set) seemed wrong to me. Maybe in
> > theory the existing interrupt thread could already be used in this case.
> > This would also allow for fine tuning the corresponding threads as in
> > this patch series.
> >
> > Maybe the whole approach of threaded irqs plus the already existing
> > infrastructure could also be used for this series if it wouldn't be an
> > all or nothing opt-in based on the kernel cmd line parameter? napi would
> > then be able to just poll directly inline in the interrupt thread.
> >
> 
> I took a look at the current "threadirqs" implementation. From my
> understanding, the kthread used there is to handle irq from the
> driver, and needs driver-specific thread_fn to be used. It is not as
> generic as in the napi layer where a common napi_poll() related
> function could be used as the thread handler. Or did I misunderstand
> your point?

Based on my memories: We had napi_schedule & co being invoked inside
the threads without touching any driver code when we specified
threadirqs. But this would need a double check. The idea of the napi
threads came out of the observation that the threaded irq would merely
kick softirq net-rx (thread). Maybe Paolo has better memories and what
we tried back then?

Thus the idea is to add a flag NAPI_INLINE, which could run
the napi loop from within the threaded irq handler directly and thus
just build on top of the current irq management framework.

This would require to make the single-shot kernel boot parameter
configurable per device (and probably during run-time). I have
absolutely no idea if that's feasible and how complicated that is and
thus might be a dead end.

> > The difference for those kthreads and the extra threads created here
> > would be that fifo scheduling policy is set by default and they seem to
> > automatically get steered to the appropriate CPUs via the IRQTF_AFFINITY
> > mechanism. Maybe this approach is useful here as well?
> >
> > I hadn't had a look at the code for a while thus my memories might be
> > wrong here.
> 
> Yes. Using a higher priority thread policy and doing pinning could be
> beneficial in certain workloads. But I think this should be left to
> the user/admin to do the tuning accordingly.

I agree in general, but if the common case necessarily requires to set
various scheduling options it might still be worthwhile? Administrators
are free to change them later anyway. It might be the same argument that
added the default scheduling parameters to the thread irqs in the first
place, but I can be wrong here and they got added because of
correctness.

Bye,
Hannes
