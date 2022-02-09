Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864454AE942
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiBIF2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:28:37 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236453AbiBIF0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:26:10 -0500
X-Greylist: delayed 592 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 21:26:14 PST
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE81C0364AD
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 21:26:14 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id AAA0C32020AB;
        Wed,  9 Feb 2022 00:16:18 -0500 (EST)
Received: from imap50 ([10.202.2.100])
  by compute3.internal (MEProxy); Wed, 09 Feb 2022 00:16:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; bh=l/FEKsTk/RJ/bVdkbuaJ+iJNXUpU8kXt2BasTM
        UnMok=; b=WTT81p4d5J+2TwiLLg5KCuJHsUsWcBsVQz99jJX3jaWLGjmOTvM+8t
        FIu7f42bAaxMqGUH/4HfW1wqnkKb+PvAc63CY+SKzINnI/MkOr0X9iN+j+zzLRtR
        brlNg+HHdzafQpZJV185OjbJJuZ4AATnOuCTfYcbzkCue6ngzP9SHRL4A3sU/1WK
        yurkAL1dqJmTPTCTdocd+RFPvJlSHb93b7GAxqYPqRyDYWT0uOfk1ezGAl79PiV6
        /8ka9iflSunKkb1JdKhekwsR+MlqBg0jyRruadzcqUYg+pLsyA5adF1EabkmqD3K
        S7P6R3vMraesdoVC1Ff1h4UFX6wzsRpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=l/FEKsTk/RJ/bVdkb
        uaJ+iJNXUpU8kXt2BasTMUnMok=; b=VjZd44boL/hyl1Or446GSWGOYEYdaHCom
        dBkoUdEUW6bTwrGEhPiD5H3EjcJSjXEDsRLnpGXZqKzsF1WVJg05YvTKzJ2BUT18
        cB02YoM85YwmNxZ5KwB9C5S2iX6HGRfHC3i4TfTSvOF998vnfdbsJZWkxmY3guwi
        QY6k1t53P0XQ7QyFR4jNgpiFJXADE3Ja1XMxhwkNnfVpA7zjeL17BCviCp+33hFQ
        mmFAHGHWCv6p1EgTz0zRSI6X0fYVZUAymnRD2xnA2mXEZeD6+qmfc6zTybUtpU+h
        8MY2hRYVG14vApaMMRQzDgidtHh3C06RyGqDrc5faSMxe7R0xFxpg==
X-ME-Sender: <xms:Ik4DYrxr8VmhNINkd4T2K56yQoISs_ITlRMjvbWTmqkNXzSiqCBEWw>
    <xme:Ik4DYjTj29Om3uJ-rlR6g-qXc8ICn-nz-DWqYN9dD_nxSJJjaPZFciZauiaTS55LV
    cS9uy-NVqSiPvolmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheekgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedftehnughr
    vgifucflvghffhgvrhihfdcuoegrnhgurhgvfiesrghjrdhiugdrrghuqeenucggtffrrg
    htthgvrhhnpeehhfefkefgkeduveehffehieehudejfeejveejfedugfefuedtuedvhefh
    veeuffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grnhgurhgvfiesrghjrdhiugdrrghu
X-ME-Proxy: <xmx:Ik4DYlXNEEZBlnmEBhRQXjNSoaiOeOksUSI9yWTDWlbUZ9C2aJKKcw>
    <xmx:Ik4DYlg34TLMJtrwjE8hJ4vkYTseuGnEAIFZJ3076Tyj6dsKhW_KkQ>
    <xmx:Ik4DYtBkAZOBydv5szhH9Z0obnkpM-S8rjJxMd-MnNoxj9ETcrSJ3w>
    <xmx:Ik4DYsNIdT9jxZmcOhn6lc6Hm3ds-cTBeMgi_bGPTBAmGohZsI9LlA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id DF9E01920084; Wed,  9 Feb 2022 00:16:17 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4748-g31a5b5f50e-fm-cal2020-20220204.001-g31a5b5f5
Mime-Version: 1.0
Message-Id: <8748d41d-ac5a-451a-b38b-6ec0fc2bcb99@www.fastmail.com>
In-Reply-To: <20220209000359.372978-1-joel@jms.id.au>
References: <20220209000359.372978-1-joel@jms.id.au>
Date:   Wed, 09 Feb 2022 15:45:57 +1030
From:   "Andrew Jeffery" <andrew@aj.id.au>
To:     "Joel Stanley" <joel@jms.id.au>, "Andrew Lunn" <andrew@lunn.ch>,
        "David Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, linux-aspeed@lists.ozlabs.org
Subject: Re: [PATCH net] net: mdio: aspeed: Add missing MODULE_DEVICE_TABLE
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Feb 2022, at 10:33, Joel Stanley wrote:
> Fix loading of the driver when built as a module.
>
> Fixes: f160e99462c6 ("net: phy: Add mdio-aspeed")
> Signed-off-by: Joel Stanley <joel@jms.id.au>

Acked-by: Andrew Jeffery <andrew@aj.id.au>
