Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC2B55FEC2
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 13:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbiF2Lhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 07:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbiF2Lhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 07:37:36 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E29EF5AB
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 04:37:35 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E06385C02C5;
        Wed, 29 Jun 2022 07:37:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 29 Jun 2022 07:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1656502651; x=1656589051; bh=P0IHYhnU3P2n89YYS5NACqA87Uib
        /LVb15nmw/s9QkI=; b=aBnQ2UZPYDdc+2pLCaA6YZyIeI80gIAIT6OuSkPRZPwl
        AAED+TRcdcMuogtdPucnaq35JGmxraMJWgPiN7Sq2kldb5iUs7By8A0KaIoILA1U
        CEWd3UD0s5QfdaO7r/W+FtyyMMTjwzqvVhB40uniJfrecDYjFLWRJp/t7ZLJO/Ij
        58PJbcUTIg5BT1clCU/FCkdFKy3svfrnyprjOWW9cbDh5/4pFdOME/FJhbAwx1OK
        Ws+72017Z/siNkcfGrGrlknbgjvvpEj9jdi4wrn1CgB42xYF71D/mUSWgaHjjb2q
        lQ622R4xZdctCdh1u5uvuooIQSf6vZS6C1UTmu7PXA==
X-ME-Sender: <xms:ezm8YsGXDX-t1QefAsLKWuUJyWrpJLU67vGKY1EV1OwNYmBx2Hx-FA>
    <xme:ezm8YlUfA9tlZNt6oyRfJUw0zhq-OWHnUmrqTc4mdY0SLY-c9kP2WPdcE6o6JUBqp
    uhwxluA5HTJFPM>
X-ME-Received: <xmr:ezm8YmINN55Ju4j31kOJdT407XDNfszZpC5IGOsk42UkyU9wfsPlQDrNSBEwqd1NBkAFM-qitkeNa3goPQreW9pqBepllg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudegledggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ezm8YuEqsmoOHiWf204ufjVLTpO35jsbZon4O1HOTxGBtEFOrb7rQQ>
    <xmx:ezm8YiUsEmIezBzEZDdHotolh32GWWw2XL9Hue1KY3QPCOTiVntsKw>
    <xmx:ezm8YhOmaF4jTPoN_Ula136zmFMblkjnrFbJMDMcfymtFXqUx9QnsA>
    <xmx:ezm8YkJvhCxfwfxnnthxYXZ4lqmirWBwIU4aDI0-mYZEjU95_He8UQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Jun 2022 07:37:30 -0400 (EDT)
Date:   Wed, 29 Jun 2022 14:37:27 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, dsahern@kernel.org, stephen@networkplumber.org,
        kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH iproute2-next v1 0/2] devlink: add support to run
 selftests
Message-ID: <Yrw5d9jqe8/JCIbj@shredder>
References: <20220628164447.45202-1-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628164447.45202-1-vikas.gupta@broadcom.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 10:14:45PM +0530, Vikas Gupta wrote:
>  devlink/devlink.c            | 157 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/devlink.h |  24 ++++++
>  2 files changed, 181 insertions(+)

Please update the man pages and bash completion
(bash-completion/devlink) in the next version
