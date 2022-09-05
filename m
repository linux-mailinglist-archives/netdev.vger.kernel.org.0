Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742295AD179
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 13:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbiIELSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 07:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238219AbiIELSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 07:18:44 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBA15AC5F;
        Mon,  5 Sep 2022 04:18:37 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 64EE05C00F5;
        Mon,  5 Sep 2022 07:18:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 05 Sep 2022 07:18:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1662376716; x=
        1662463116; bh=op1yRLnR46V+ZLMlfknvMWSBqZoTtN/TWGfyjTb8Utc=; b=l
        ODUPrGKWnoO/osLX47ab+/OHTSXXWAyXr8GDMLV5svuAY72F2G2rSGebrJFRYCoo
        wP+4WbeUyWjCk5/7bxW5iAIYhQKjFP1awGajj/W5qEZ50zJgZhTYmqGyNIwPR9hn
        rsstGwV9coWmlSC17nwO/ETqxp1hpzdzvQRWGVIT2jf6zCWID5LeRXEVfLptAqQW
        peVg6rVLZQaZJh5AWejupaObb3T86aOSe4LqChtVzZFDw2p87pLh9fHmf1lUrVbh
        kifcKar8W91vc3NTo0CLkiJWIAoVozx/kr/SAdgk1zy78Ge/9s6L878okorIKloi
        Ia1QLcxFc4/ArFde8k6Iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1662376716; x=
        1662463116; bh=op1yRLnR46V+ZLMlfknvMWSBqZoTtN/TWGfyjTb8Utc=; b=g
        MQcgkbJvhd4TP6ESCNHedc31cRMW5OTi/2skiY5KdhJ/n9ZmbwyWtJiI6TdgQ9y3
        3xQgEKQLn4hPSpcAa4ct2rxD/yDMjMv5A8InpqAc9vXDXn6UOqbBIQMazOASvvZY
        ZFoQjGn5ug+yGIuHsaOw8ZE2+BABqAgqqKJD+KbxIa7487F88TgWVuXcYj7rIPF5
        g9nSI+DXj21v3ECPNMFCTOR9Zy4r+5q/xxBMZCZdwwEizoUiC2OlLmXGzvuKKZXR
        aT/o1TuacFQrQPrmeWUcweKju8pRPlepH56MskqcGaaAEA0SRcjhMVCAFMlmzOdg
        hWRzUdVtung2x2Y7v8bug==
X-ME-Sender: <xms:C9sVYy8A0HoMBdIKskxo24CMoLst3HEwPxLhSmewPfd4mQmMw2ZmUg>
    <xme:C9sVYytqBGARjiU245tnMJ4PWUEW2YM-14Y6Xq6VNOqEXry8_bE6tnRAmaR41Inx-
    4qwqzdIbaIkyWTvV04>
X-ME-Received: <xmr:C9sVY4AuSPpL6gAglv4AYwr0jcmgLncMPTaUtgrvNi_031ZnLbN-GCUQpS8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeliedgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtqhertddttddvnecuhfhrohhmpeforgig
    ihhmvgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrf
    grthhtvghrnheptefgleeggfegkeekgffgleduieduffejffegveevkeejudektdduueet
    feetfefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:C9sVY6c4Zo2idvNMCObPudxwX7PWjqYde-scA5avM83toAIYf8FhQw>
    <xmx:C9sVY3Pto1O6ndPXsTsUF4Rk-n7YLSl_TMhyvBoTarDGQmYccv3buw>
    <xmx:C9sVY0kIDAW3D3AcsT7OZ6iHGOHdoUnKvuWc2GMtMzKptfJJv6oVqg>
    <xmx:DNsVY6PLGPfRFIo4BAPoZZatfHFNjxZJ1DqqifVkh2hk8xXks83qZw>
Feedback-ID: i8771445c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Sep 2022 07:18:34 -0400 (EDT)
Date:   Mon, 5 Sep 2022 13:18:32 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Martin Roukala <martin.roukala@mupuf.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: RaspberryPi4 Panic in net_ns_init()
Message-ID: <20220905111832.73nqtlzpiuwpj7lx@houat>
References: <20220831144205.iirdun6bf3j5v6q4@houat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220831144205.iirdun6bf3j5v6q4@houat>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 04:42:05PM +0200, Maxime Ripard wrote:
> Sorry for the fairly broad list of recipients, I'm not entirely sure
> where the issue lies exactly, and it seems like multiple areas are
> involved.
>=20
> Martin reported me an issue discovered with the VC4 DRM driver that
> would prevent the RaspberryPi4 from booting entirely. At boot, and
> apparently before the console initialization, the board would just die.
>=20
> It first appeared when both DYNAMIC_DEBUG and DRM_VC4 were built-in. We
> started to look into what configuration would trigger it.
>=20
> It looks like a good reproducer is:
>=20
> ARCH=3Darm64 CROSS_COMPILE=3Daarch64-linux-gnu- make -j18 defconfig mod2y=
esconfig
> ./scripts/config -e CONFIG_DYNAMIC_DEBUG
> ARCH=3Darm64 CROSS_COMPILE=3Daarch64-linux-gnu- make -j18 olddefconfig

Interestingly, this was making the kernel Image cross the 64MB boundary.
I've compiled the same configuration but with -Os, and then tried to
boot the failing configuration with U-Boot instead of the RaspberryPi
firmware, and both of them worked. I guess that leaves us with a
bootloader bug, and nothing related to Linux after all.

Sorry for the noise,
Maxime
