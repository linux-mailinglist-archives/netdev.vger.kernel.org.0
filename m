Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572FD56CE1F
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 10:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiGJI4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 04:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGJI43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 04:56:29 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B571F13E33
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 01:56:28 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AF6A05C00C5;
        Sun, 10 Jul 2022 04:56:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 10 Jul 2022 04:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1657443384; x=1657529784; bh=oQP+k3Twuy1araA2hjhfw2d6BsCp
        9f7f8xystTD3Z7A=; b=iSn4zksFKKbGDnWwBNRcKqzHgDd0JglasI09qLXVsrrp
        s8wsfybEGJSCwkqus2oJT4juEAmVnRNu+Z5xkfDwZAdzaJBpEvkIwPVAok8qmkCr
        Sauqa2KsDp+XrPdptY3u1xc05YQusDKDBMBBzhf9D78hMjb531lfO9MolOPyfK40
        s6lHTqQ6ILXOSh/VibOiyksIW4GcxjPbl7BvfRDWobSKQOhMVHWnqHtnb8hnlSEg
        2zo9pgulQgd1jGW53fopHkmvbStS+1Wo/VTpJlyNgWjzhG9YiwFoid+LhFHQavm1
        CoLWRU15dBOHUtuOLKfbJMlu7Ak4OqD+i0loInNjkQ==
X-ME-Sender: <xms:OJTKYhelb55U7uqZ1xS7BTMtFWTKpzpbetKzdibqhMvrHFvw1eDtqw>
    <xme:OJTKYvMQBi9rAdPkz8LYZyfj7H1o6WusbgSMPat7hOhYRV-DaM6bTzrb12ILQrBgI
    rIyXI4ES3etW4M>
X-ME-Received: <xmr:OJTKYqjhM8paKdMU83R1TpDHHjJ-Oo0LPP1-vp_Dm7FE5nNm2JoUcDhUU3nD>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudejuddgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdejvdeiffefudduvdffgeetieeigeeugfduffdvffdtfeehieejtdfh
    jeeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:OJTKYq9wl7BaE3GMCCH7D0KKlBbXp45V-iXZSASB9pNrxNnHX5iiQg>
    <xmx:OJTKYtv4Tx_UT9HcdS9PBZVpvfuVREU11TPe1W92V9bCIyxv53tieQ>
    <xmx:OJTKYpFTbAMhzGS1wspqsddJXD6G-iuVU1l0UiBWDjkkV6W7oEO1Pw>
    <xmx:OJTKYhh-fDO6J-D7jLPcfGe8QKcRPLZthgnwhulN9nPk3_ECH_bg7Q>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Jul 2022 04:56:23 -0400 (EDT)
Date:   Sun, 10 Jul 2022 11:56:21 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, dsahern@kernel.org, stephen@networkplumber.org,
        kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH iproute2-next v2 0/3] devlink: add support to run
 selftests
Message-ID: <YsqUNaVhhT9rL1rM@shredder>
References: <20220628164447.45202-1-vikas.gupta@broadcom.com>
 <20220707183116.29422-1-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707183116.29422-1-vikas.gupta@broadcom.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 12:01:13AM +0530, Vikas Gupta wrote:
>  devlink/devlink.c            | 193 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/devlink.h |  26 +++++
>  man/man8/devlink-dev.8       |  46 +++++++++
>  3 files changed, 265 insertions(+)

What about bash completion [1]?

[1] https://lore.kernel.org/netdev/Yrw5d9jqe8%2FJCIbj@shredder/
