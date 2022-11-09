Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91B5622AEB
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiKILtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiKILtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:49:47 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9982F29813
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 03:49:46 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 221245C01DD;
        Wed,  9 Nov 2022 06:49:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 09 Nov 2022 06:49:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667994584; x=1668080984; bh=jgMfHhXsCpxVJwKtOb5GQuTmsKQp
        ZKkrSGGVAU1vBEQ=; b=AkAdaDrk+AJIC5kZjuGGCQZPI8BSQwuy6O/tmqLKMZRA
        NUzhGSuCVigv0tThI1WNzq+1NT5x0ODApmhuX0awCqRA+S1FIPXItaczJHb/G1eB
        EXiN3aaCsNhh2HovwWXODEo3oLUxjEUd3tjn52y2y2qMk/Fj6D6fmmZCRP7HsO5s
        3GLexNaz0lgnaBk2kz+BAuyubSDariIj2IC116yzHusSRWgqfMKhydzPKHRV302Q
        OPmxD59eQ0E/AkwfEMwowXgs8NG51e2oG3bpqpwcQiG/TSh9qXeKfgeWKw0Y3Iog
        fgLQKqvvrerlZa7cdRzlQQrccqTXCY5yHNDevnZsdA==
X-ME-Sender: <xms:15NrYz8fYHNeGXlJvL37FtVeBmTey7E3ZSwtkueTxYQbjqOWWvcQSA>
    <xme:15NrY_sDCjSlrzHV95PZz69Dh4nZK05c82BylC_-NsINDRktma89QQUpnAem-6w8s
    lIk4EoWVN7-U8A>
X-ME-Received: <xmr:15NrYxCMm3Sy0ep8j2hZGdW1Uu4oJx0SyA6t_ZzShMKFC64cwMEqt2lHVvPu>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfedvgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:15NrY_dutKkciE5RQD50Se9repBXN6bps8TUJ6qfvQ_7trSh9nnt6Q>
    <xmx:15NrY4PtfBf1SI9HA5UXOfM4zxS1CC7-xItzLSxcxz4ewlhivdUblA>
    <xmx:15NrYxlvP00pUxZ-x6f2l0DPO3PFonmZYlqDx4RBTsJuDAhUyyR9vg>
    <xmx:2JNrY_eCuCqjmJD84Ld0M08Opi8FeXuPZ-jSc5D_lDuq5uiZmlJixg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Nov 2022 06:49:42 -0500 (EST)
Date:   Wed, 9 Nov 2022 13:49:40 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: Re: [patch net-next v2 3/3] net: devlink: add WARN_ON to check
 return value of unregister_netdevice_notifier_net() call
Message-ID: <Y2uT1AZHtL4XJ20E@shredder>
References: <20221108132208.938676-1-jiri@resnulli.us>
 <20221108132208.938676-4-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108132208.938676-4-jiri@resnulli.us>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 02:22:08PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> As the return value is not 0 only in case there is no such notifier
> block registered, add a WARN_ON() to yell about it.
> 
> Suggested-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
