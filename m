Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8126029DF
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 13:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJRLKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 07:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJRLK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 07:10:28 -0400
Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17534D14C;
        Tue, 18 Oct 2022 04:10:26 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 1A3E52B06811;
        Tue, 18 Oct 2022 07:10:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Oct 2022 07:10:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1666091422; x=1666098622; bh=U8wpPQWEh5
        8ZbN0yR3/VZpUrmJoyEuxzqpuZ/EhtzXw=; b=FPpwZhiUWWOv/PCuTy9vUJC9m2
        y4kcMr1P+uImmYjI46Xv92ahLFs8sL+43+uu+mQQDAlnwN++4Z+jlgv2JE+Tdnth
        57MgL3yzSKmTpdrCOe3jGSD3n64UuzXsEFVEKpcDvrG00w4TAwUgVcJ7bz11U99n
        zlqng7wZxojKWmfeXk5m4x+xN/F9eTr1Rsj4L1vDLAdTtYWIdCNhN6Yj8GvLQzWa
        Js/GfNKvRDpYwXt60W+bRsT4F6giIhIjBl/qd1mVKd2fVB9B1Q0GDdPfV+L+U50c
        42QWmLlXK4yZqL6D4C63EQySC/MN1RO+yRLB153bwyNjfT+coTICwFV913Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666091422; x=1666098622; bh=U8wpPQWEh58ZbN0yR3/VZpUrmJoy
        EuxzqpuZ/EhtzXw=; b=VZd/2vakzilt25m9+TVR49pb6cHZGnpEUDgXmg/uKH1S
        ezkNAa1xc4jfe0EASTLeFN8LavMgRgOrFcp4ivE4UY1AxI8uXwE+YmQYJM5FdQJA
        0zn5bXRIdgELqCXxEu20ZfhNbYNWZ4M88Zl4sep9w1bkK+nsJ5tMDLwlqhlHr+y+
        mZ7tkc8KlOh6K2Kj0yhRwrj5NDBi5mDBBGCs4cVz4SgLA9hTqO2Rp/gusFDrlhPA
        /I+TV1yfX1XB9e3jLg22edufBn+N1oYVBaNYW21KAz736Ggv/lsn3D1WPHst3aKc
        zLFAne1x3g83NLEU3ul7qdnZglOLV397AqYkLKQLTw==
X-ME-Sender: <xms:nolOY0F7JerDoGIsAmBfxKtLGb2lMYPC8nuTgwVtSpgIyIdWVp59gw>
    <xme:nolOY9X8k6RJyT4e6Clli2fd7AsGSmz6s25Uu96PNyJGwXUds0Uq8-kR6oYYFNb2X
    VQvr-s0ZgUGTA>
X-ME-Received: <xmr:nolOY-Jc5skPz9_8BOH24AnoMMaj-sQw6trDVGMo_8X6m7GJSj16ygWNJvrRtEf-GMdO4WzJONzJ9cbzhomnNNOhiUYL7odu>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeelvddgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:nolOY2EExM93ZvaD_0AIHeIYbHSXWgXx7dG8BzN2Vndw_Su6Wr6ktw>
    <xmx:nolOY6XHFPaCYLD01gF-rJ6vByk2WR_7xZfjErZEyEWN1zyRCldPww>
    <xmx:nolOY5PbORWxwcMFXp5ILYkgl8d0QxAiVBRNsZl_L75-yHIfg-29wg>
    <xmx:nolOY9rhQTer_LEwQrjfdRJwEsx99Y8oYxhepeYW1Ft3NYnZOY-DWHbBtAM>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 18 Oct 2022 07:10:22 -0400 (EDT)
Date:   Tue, 18 Oct 2022 13:10:18 +0200
From:   Greg KH <greg@kroah.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Wen Gong <quic_wgong@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 16/25] wifi: ath10k: reset pointer after
 memory free to avoid potential use-after-free
Message-ID: <Y06JmkTYlD1qSkvz@kroah.com>
References: <20221009222436.1219411-1-sashal@kernel.org>
 <20221009222436.1219411-16-sashal@kernel.org>
 <20221018095356.GH1264@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018095356.GH1264@duo.ucw.cz>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 11:53:56AM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Wen Gong <quic_wgong@quicinc.com>
> > 
> > [ Upstream commit 1e1cb8e0b73e6f39a9d4a7a15d940b1265387eb5 ]
> > 
> > When running suspend test, kernel crash happened in ath10k, and it is
> > fixed by commit b72a4aff947b ("ath10k: skip ath10k_halt during suspend
> > for driver state RESTARTING").
> > 
> > Currently the crash is fixed, but as a common code style, it is better
> > to set the pointer to NULL after memory is free.
> > 
> > This is to address the code style and it will avoid potential bug of
> > use-after-free.
> 
> We don't have this patch in 4.19:
> 
> b72a4aff947b ("ath10k: skip ath10k_halt during suspend for driver state RESTARTING").
> 
> We probably should take that one, as this may depend on it. On the
> other hand, we don't need this one as it is just a cleanup...

I've dropped this from all queues now, thanks.

greg k-h
