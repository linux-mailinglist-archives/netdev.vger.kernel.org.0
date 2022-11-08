Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F1E620AF8
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbiKHIMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbiKHIL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:11:59 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BC2DF92
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:11:58 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 1919B3200959;
        Tue,  8 Nov 2022 03:11:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 08 Nov 2022 03:11:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667895114; x=1667981514; bh=5g7aOBBkRDYIqqQKjTt7/0kKVfpZ
        iTJWM2vFQRDwljc=; b=Ky777+zaeyZq4OfqtwqMYPUD/5GLSRoLYQa6MfmOGEdx
        GJf4zhbG9yZxFef7ciZVC2/o1xStzTVyhhAFA4hAL2ThsjsimX8H4f1UZ1CmJQnW
        /EPBG6ON8LcpFCL9GCuXV+JX71U/ZdYDVvGXickfCOzVgBajhbsX7Q8Idmp4sIuI
        IukHI7qtv9s+RmGO9lGo79ivLDdSGZzi6njRYF5J1s1j8SEkefRP43Y5PPzKl//M
        rUaO5pS8AXs1DM94HsgwyuAzvikpbwbDVxHspvNFEh87mpvV9vX20tzsJYnd/mKl
        2ImYO2kAuqJTGJoVfDiogk9IMF/ZYlB4v2z7bvGvNg==
X-ME-Sender: <xms:SQ9qY-T08V3BWIAuz34vvoQmWHWOsSCNMPm-DzcM65xArIhlmBKf8g>
    <xme:SQ9qYzw5MCQ3wSwOJlXuQSQBRhz-608t03X0LvBKMlfBr0B2HOlX97mGxcpcALABy
    kV-xmxyAkCx_P4>
X-ME-Received: <xmr:SQ9qY72epH6002LWLL_uQC0mN_0EjeZpe_9q2m0fxDv8s58RpgWor2w_8gmorE779AZUCIQ8-Zia_qH371fAJm1Vvyo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdelgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:SQ9qY6DQ1FOigcv0PQX0Lzzfx5YStJEWREpI4Nr7hiOoLdiAQiIeDA>
    <xmx:SQ9qY3hY0DSQCorH8bsAe8JjfO8nY1-xrqFP9jmCZVoPJw9hp9gLJA>
    <xmx:SQ9qY2oXuMtpI0ebVnKCSgUkvxnr9gWxh18MpQ6tmUNGkKbtqc7dQg>
    <xmx:Sg9qY3iKSvKrt3sR5xxkY88uBhN-giq_JXnxuTX8LqHtsG7eTCW1kw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Nov 2022 03:11:53 -0500 (EST)
Date:   Tue, 8 Nov 2022 10:11:49 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: Re: [patch net-next 2/2] net: devlink: move netdev notifier block to
 dest namespace during reload
Message-ID: <Y2oPRR+P2ecMLPMl@shredder>
References: <20221107145213.913178-1-jiri@resnulli.us>
 <20221107145213.913178-3-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107145213.913178-3-jiri@resnulli.us>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 03:52:13PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The notifier block tracking netdev changes in devlink is registered
> during devlink_alloc() per-net, it is then unregistered
> in devlink_free(). When devlink moves from net namespace to another one,
> the notifier block needs to move along.
> 
> Fix this by adding forgotten call to move the block.
> 
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Fixes: 02a68a47eade ("net: devlink: track netdev with devlink_port assigned")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

Thanks!
