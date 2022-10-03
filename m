Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343E85F2F38
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 13:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiJCLBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 07:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJCLBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 07:01:21 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA90C2711
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 04:01:18 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E7F763200657;
        Mon,  3 Oct 2022 07:01:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 03 Oct 2022 07:01:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1664794875; x=1664881275; bh=rYw5zXDkK5M3GUCH4J8DxE+PGcYN
        v63b5SdhOf1d6oo=; b=B2uSXQ0TBptbTAB2C26Ue47Gtjffu/2KjGSFHaUELDRx
        tyEE7c7SysL1kU8U2zDeL2lz/z3lFn6wW2CRYgPCWa+hM9v6SYtfaGtSITVcz6Ta
        W1fESBpnczGo69yS5H/D5dj9D5cqYciwXA+TC5Y2LN4YNGaMS7fhcgu/HqlDrYyC
        VDIc8/1wO1I8EC0jDODx/kb/J/Zd7QcXoLx5GwQDVUiY4YVqsltorOUr7bq1B9bg
        aguSP2jE5T3NKXJwr8gZlI9UNTblIM34Jpmqpv2v2zCO3TRQBnrvQXtTpBSKSFFl
        7MksmGVSjyZ9ZmVaovEGmaNSmF57esT5K4qFIRRWIA==
X-ME-Sender: <xms:-sA6Y1CdOnR2b0t_cCUdTcLbME57lPiG_ZALHXwPNyUltpRic7abNQ>
    <xme:-sA6Yzj3ANQTFH53aB5r_KD1M2Eos0thj-RgfCDyTnIX0UD5fEzeDE8x4ewUNmu99
    1aFjC8nhzLnvHE>
X-ME-Received: <xmr:-sA6YwnrhZGgkSMbFFp4iTch7_P2W7BzX4XFGRRnGLEabLI8-gIIbFt4evb6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeehledgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-sA6Y_yUXgaN3yQJpL-SW5OGPAI1comZKBBpdnILSKnaSmKEAb55iQ>
    <xmx:-sA6Y6Sbs8wkTql9No11SchuQt5_gUU77ViTwgxamc6cb4_BYWyrag>
    <xmx:-sA6YyY5Zbro2kRDeQ7zXr6CBgTPv7aP0PO61agIHFZZjFeYjNUi1Q>
    <xmx:-8A6Y3K13sH1wbS0WKlqUVa2POvReeEZw5VkajNFuyLLCevGJUXWKA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Oct 2022 07:01:14 -0400 (EDT)
Date:   Mon, 3 Oct 2022 14:01:11 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com
Subject: Re: [PATCH net-next v2 2/3] bnxt_en: add
 .get_module_eeprom_by_page() support
Message-ID: <YzrA99pX12XGbDd6@shredder>
References: <1664648831-7965-1-git-send-email-michael.chan@broadcom.com>
 <1664648831-7965-3-git-send-email-michael.chan@broadcom.com>
 <YzmvdxQpWviawxuj@shredder>
 <CAHLZf_sEB=dR2skpVuTD-r=SW4ZF9aOUKuNxibrjAKFe=v5+=Q@mail.gmail.com>
 <YzqNEc6biKKrfugK@shredder>
 <CAHLZf_tE-fUz2wmaA8=GeqfZMev3Br1M6A316ZJL=CB_KdZxew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHLZf_tE-fUz2wmaA8=GeqfZMev3Br1M6A316ZJL=CB_KdZxew@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 02:55:13PM +0530, Vikas Gupta wrote:
> I believe your new operation means that "drivers need to implement
> get_module_eeprom_by_page" if they want to access banked pages. Am I
> right?

Yes
