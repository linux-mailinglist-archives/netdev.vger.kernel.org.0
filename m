Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776AA47A80D
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 11:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhLTK5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 05:57:48 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:52239 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229810AbhLTK5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 05:57:47 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5BC325801A4;
        Mon, 20 Dec 2021 05:57:46 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 20 Dec 2021 05:57:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=KuhQPJcPGkGOv91Y6afHIx9rUdF
        GI8okUJ7zNSalflU=; b=nWJI7XVI5YIFchKfZ1TekjBbYfdPxHfaE23ESkVPY8F
        ZDO4UUMfJeAeQJnK0cK5mH9coH9gRN2+Pt6BnR1jaJ6FILWZSy57bAL2EaGk3avN
        8AAyUdUuFBKMVwUIukYI6K1H13CQUxe5kqLBG+wcn0xfmV8loTtNlgtMNGMI1ua9
        1Tu5eRG0vPH5nN7Mwl13OohoOWBWDUO++CHkieOpoN6WXvjfpygDoB8f1J2FzL0c
        e5Gm4Kg8tAEAwUCsCalaCW1rouQlrIolqnwYEOm3TYhgd+hVSbuRpG0NKWL08b/0
        RDHBp6lfV6Hves8Jr8YneLCXe2rodbuxTnwg5bBvp0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=KuhQPJ
        cPGkGOv91Y6afHIx9rUdFGI8okUJ7zNSalflU=; b=napt0aVxzC3L5ZZVEZNXGn
        oG8Mk586SLucosFTD6AdtDnWx1LTYBoW2Hf23gDFIy2NUUtsk7Jf9N9GKydXXIpF
        F7fnwi5wJLifVQVv4GHlloQIS1AY9/xBJ3icD/HlHTrutqFSQoarFNE0oE5kOIaQ
        598rrCcmiHb0FeeSG7b/EfFURZySB+siy5AnuUtTgHLqHUeBxQJFULIxCbDTsAY+
        R4M6AOQOod/tomeU8wrGzYi7m8dcAeAEWCurKoIDV738MAjfA3ftO98MqLpOiXW1
        bTAf1EOQX1Dfh06E0LO9ACGE5klr73vwcsQISgYJx+N6dg7v6Eaz83+c89FcxbzA
        ==
X-ME-Sender: <xms:qmHAYVpPq8s52mpuWbreXJDrtb23RF-yaCQrDNOTyVBNknXnviJdhQ>
    <xme:qmHAYXrBKRxtpZbSzyVQGuxjpTYlboUWERJHDe569iMYfDGnJv2g_ibZx7PY1AiHQ
    DIWjdo4zOzN6A>
X-ME-Received: <xmr:qmHAYSNVc6Fif7jSLeGBcm-vBEfCuu1mCJY1iv7wlzgOw8fLBbQmSxKY8QJxL6TSWhoF7ZKE3MW0ven9VB5mWI_S7LgCxd6k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddtvddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:qmHAYQ4ewHehKtA_qm9PnK4f3ZKw-m9fpCGfcbydAgWeMPR_FPJR0Q>
    <xmx:qmHAYU4k-ayhrh6yoFw8dD033gac8474E5IarGgGOkFEQd7zjnaFSw>
    <xmx:qmHAYYglgRnaX4DE_Jrf4epwdUWpd9d1KiHoNlSiyQcb5_VOibE8Rg>
    <xmx:qmHAYehLJ56pWSu8RP6j_9YdLy3zZ9LCtTKKXvWb1QaBXmRSbIZB4Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Dec 2021 05:57:45 -0500 (EST)
Date:   Mon, 20 Dec 2021 11:57:44 +0100
From:   Greg KH <greg@kroah.com>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, clang-built-linux@googlegroups.com,
        ulli.kroll@googlemail.com, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org, amitkarwar@gmail.com,
        nishants@marvell.com, gbhat@marvell.com, huxinming820@gmail.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, dmitry.torokhov@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org,
        linux-input@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH 4.19 5/6] ARM: 8788/1: ftrace: remove old mcount support
Message-ID: <YcBhqJMLdwieZa8X@kroah.com>
References: <20211217144119.2538175-1-anders.roxell@linaro.org>
 <20211217144119.2538175-6-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217144119.2538175-6-anders.roxell@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 03:41:18PM +0100, Anders Roxell wrote:
> From: Stefan Agner <stefan@agner.ch>
> 
> commit d3c61619568c88d48eccd5e74b4f84faa1440652 upstream.
> 
> Commit cafa0010cd51 ("Raise the minimum required gcc version to 4.6")
> raised the minimum GCC version to 4.6. Old mcount is only required for
> GCC versions older than 4.4.0. Hence old mcount support can be dropped
> too.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Why is this needed for clang builds in 4.19? 

