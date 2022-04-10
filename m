Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5452C4FAF23
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 19:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239160AbiDJREP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 13:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiDJREO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 13:04:14 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A3A48383
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 10:02:03 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 27C573200AF3;
        Sun, 10 Apr 2022 13:02:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 10 Apr 2022 13:02:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Hvcm6ZlYf4cJLHB2A
        dE+SzvlX1dZu8vmiEjIbI4HZ+g=; b=kjw0l6c5MZ9MYl6CAXFmcYP817NbjFh3B
        sy784hrBZT/Lr3IHpy55ouNrCuEvgmp5ByFBHdIdu/Cr3OPlg3JYv40lv4InI6nh
        soE5nX99iRoy2f9VWJTJ7/OdH2L5UING0mO+Dvcggr0rDwLo4xNiF+8TxrJLY7FF
        G1z/BYX2ZnNtp5034HsU6UY7UNwdzV84HD9jGAmtOn09P5bEfDoczBSb7cNFW9fC
        2hg9uzX8BoWA4aWZg72g2NUIFPVRsMOVXUsGBoMOLyvq/Rh5coKneOHdPqniWjM3
        Yk5xcpHJZNxhrSz2dREtbQiO+kAUrSiRCWSNJkPn1Dl8ctWnz6avA==
X-ME-Sender: <xms:iQ1TYhbGvLzbBhCCdzvazzUr7lQYhZviEVeGIsraIzAlY_WiXEwEmA>
    <xme:iQ1TYoY3lu7-CU7jxIueYgn-5kIFsaFrnJBr4R9DlLnVmoOYKhCImT88-qkC_fhC-
    P6kI8GFvTxmS0g>
X-ME-Received: <xmr:iQ1TYj9gwOaUTrdsFjZH8q0-jcNoyw6n6yQNuGGHT3JvW8LIL0WO4oT476RQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekgedguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepgfejvefhvdegiedukeetudevgeeujeefffeffeetkeekueeuheejudeltdej
    uedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:iQ1TYvoAWbfWH1f4zMQiTRj3F6xZ3S1vll2tFoBiGG3AgR641DiODg>
    <xmx:iQ1TYsrKgfZffHOrtEyhVYwZAdGugWgl0FKDKWuAEWROCzuqOUPA1w>
    <xmx:iQ1TYlRwkzDYXRhAYACTZj4rFwrXmvGM-pRVy6y5xSDb2STQnpDshQ>
    <xmx:iQ1TYkKvtBuyPsNjgKv7mt1hmN5tIiTrL5Oz9sP7FiAEgAVWprojYA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Apr 2022 13:02:00 -0400 (EDT)
Date:   Sun, 10 Apr 2022 20:01:58 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH net-next 2/5] ipv4: Use dscp_t in struct
 fib_entry_notifier_info
Message-ID: <YlMNhjfpTgmmjPAy@shredder>
References: <cover.1649445279.git.gnault@redhat.com>
 <f69f4e262e502ff97ace5e13842cf7e53cbd7952.1649445279.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f69f4e262e502ff97ace5e13842cf7e53cbd7952.1649445279.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 10:08:40PM +0200, Guillaume Nault wrote:
> Use the new dscp_t type to replace the tos field of struct
> fib_entry_notifier_info. This ensures ECN bits are ignored and makes it
> compatible with the dscp field of struct fib_rt_info.
> 
> This also allows sparse to flag potential incorrect uses of DSCP and
> ECN bits.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
