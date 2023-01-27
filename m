Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A26067E6F9
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjA0No2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbjA0No1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:44:27 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5138341084
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 05:44:24 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5AFB13200C83;
        Fri, 27 Jan 2023 08:44:23 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 27 Jan 2023 08:44:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674827062; x=1674913462; bh=049vtcBDNIsAWQrXNX6+PjYeTlzS
        TbdXTssQ9sitqtI=; b=a0sJ7V/Y76F08rHev2jTfZ/FMhWdpmw+KMlgjgAab4cW
        TCLhe06RY455l5bpMR9EtediDE8jrBNzyCGqqRAEGZ8RarWa94uv/SUAH8h9SphQ
        DQZvC5o+r03Rhbvo45Qeh57Uuq8y6t6gZHZqHN/DfXLkzZtu5452Zw/lu2fY8dZj
        Qgr5kGq4jdombEjZTZX5mQiZngO996CKZ2HCk7t1FExDONraqn2zbjcbaDDcg43F
        q4EzdWa3iAIcmE5r6qjkFTstWmQXhIjkkrj75Qb64QhaNQCOeHyUMzzzVQQun4Cr
        wBVMl0vQB34ixNoarQ3XAZoT684LUK0qFDmsZaL9Tw==
X-ME-Sender: <xms:NtXTYzmBiHG6SAvNQoL0YxmhWAfvXlztnPxMuG28A9_aQIjUugjmNA>
    <xme:NtXTY21XutEJYY_3DN7CQP0WA6abt6DedXtQBCktmDUbwVNcNh2Dt0_ZANZ-01x0u
    XxQaMpQ_I_-TM8>
X-ME-Received: <xmr:NtXTY5p_v8w0grzgnnqRjLjCLs9sxOZ2hbR2jDQDDM1Kr4WYG9lNCgvpRxr8za1K2kWRIcb7NLYb2S-AhSnaQGlfd2s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddviedgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NtXTY7kcCa2oaFQvlY6KflchpTeDiWfwzavOqIOpBO_sVPVbRdpYXQ>
    <xmx:NtXTYx01fwFuPS0M-ZJ8QMlnRhiI7WIjBsEjN9KVEAK9Dts0R-NaOQ>
    <xmx:NtXTY6tHhIqK6Q8Gdw2CcTuPBkrdMS8HoWYLWYu16USywLNmImtjRA>
    <xmx:NtXTY-81f5TwHiWvyHtC7hRl_1H7fqh3aB5L9L-aFzuifYMTju9iKw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Jan 2023 08:44:21 -0500 (EST)
Date:   Fri, 27 Jan 2023 15:44:18 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH net-next] net: netlink: recommend policy range validation
Message-ID: <Y9PVMrxPS8Wx7irE@shredder>
References: <20230127084506.09f280619d64.I5dece85f06efa8ab0f474ca77df9e26d3553d4ab@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127084506.09f280619d64.I5dece85f06efa8ab0f474ca77df9e26d3553d4ab@changeid>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 08:45:06AM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> For large ranges (outside of s16) the documentation currently
> recommends open-coding the validation, but it's better to use
> the NLA_POLICY_FULL_RANGE() or NLA_POLICY_FULL_RANGE_SIGNED()
> policy validation instead; recommend that.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

I followed the current comment in code I'm currently working on to
validate VXLAN VNI ([0, 16M - 1]). Adjusted to use
NLA_POLICY_FULL_RANGE() following your patch, so thanks for that.

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
