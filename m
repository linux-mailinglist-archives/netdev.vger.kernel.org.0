Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE8F608D80
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 15:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJVNxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 09:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiJVNxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 09:53:34 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226AE27CFD8
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 06:53:34 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 7AB8D32006F2;
        Sat, 22 Oct 2022 09:53:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 22 Oct 2022 09:53:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666446810; x=1666533210; bh=KcKyZit+XwaY6TxbOToGCYKAxbe8
        8cDjRSehsyijV6U=; b=J3Ymo3HawONpngRpCEPMP2XmhrdBtcLx0sUU+XfBbd9g
        FsFdOtE1+6NLsYCfld4vjUKSnnpQ1tux8ih4gR1B9/54TAdNPMu6AUYFR7fsKaJv
        I6lc6fhg9aiStOmm3mSgj7t7iXfWY2DhPvmd+/9wnlg/zUF4zBo2MMYE3Fxskcaf
        327wi1hMYrhCK6amvWgZ8RlsgGvWpB4BUPXBSW47djL50uRcuKl1kYQ65piE40Pa
        dFjSngs1tFy4U3bZoiNKwhqxIC7al4aRMKD4F4XKeileMt1+37CkCYy+X1NeK0qu
        njp/DjzlmqLwK1dexXtf8AZVchFlYtlkxoH4zmkMBA==
X-ME-Sender: <xms:2fVTY6Yl29CbW3WYwAyHt--u9XCelTr0EmC6MDf08D5jt9ZHl8h7qw>
    <xme:2fVTY9ZHIMLtOQfBUr6ZBnL0Pl5dm3EMV7swCMwpeQvergvbNpXPXgsaxYqVtAwYq
    Kji9qZlU-OTi-g>
X-ME-Received: <xmr:2fVTY08y8WxYLPUZYh2UeaiyMBi_J8_YwPeSQd9zuX48zFkXSAS434VWN4lzfm5BxC5jokldHZTChUKL3VrAuWPrpgqn4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgedttddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdejvdeiffefudduvdffgeetieeigeeugfduffdvffdtfeehieejtdfh
    jeeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2fVTY8rRnD3gXxAv33a46SkqP5_OmZg_3yMVPaHvRWQFq3wkUNzFNg>
    <xmx:2fVTY1qTvO7KUiLEP58eGpziEnVIAhQQ-_20xRG_e9NRxfXnApgE7g>
    <xmx:2fVTY6Q1jHbJZkuoEpspV37ydSnYmzduSn0rwJrQ-eKtrBwudYou2A>
    <xmx:2vVTY-C4P0ML0BiZ8NB-vaXjL-_aMHGlsG4dVzl0xr9KzCP6unDlYw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 22 Oct 2022 09:53:29 -0400 (EDT)
Date:   Sat, 22 Oct 2022 16:53:25 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, gospo@broadcom.com,
        vikas.gupta@broadcom.com
Subject: Re: [PATCH net-next v3 2/3] bnxt_en: add
 .get_module_eeprom_by_page() support
Message-ID: <Y1P11byyH1oEuZqi@shredder>
References: <1666334243-23866-1-git-send-email-michael.chan@broadcom.com>
 <1666334243-23866-3-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1666334243-23866-3-git-send-email-michael.chan@broadcom.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 02:37:22AM -0400, Michael Chan wrote:
> From: Vikas Gupta <vikas.gupta@broadcom.com>
> 
> Add support for .get_module_eeprom_by_page() callback which
> implements generic solution for module`s eeprom access.
> 
> v3: Add bnxt_get_module_status() to get a more specific extack error
>     string.
>     Return -EINVAL from bnxt_get_module_eeprom_by_page() when we
>     don't want to fallback to old method.
> v2: Simplification suggested by Ido Schimmel
> 
> Link: https://lore.kernel.org/netdev/YzVJ%2FvKJugoz15yV@shredder/
> Cc: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
