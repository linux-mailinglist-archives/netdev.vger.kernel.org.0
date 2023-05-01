Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CA86F3834
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 21:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbjEAThx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 15:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbjEAThf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 15:37:35 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099BE103;
        Mon,  1 May 2023 12:35:18 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id BABE25C00EE;
        Mon,  1 May 2023 15:35:15 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 01 May 2023 15:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1682969715; x=1683056115; bh=hW
        WjXXWv7d7L0ntgkDmp3fxBvyf0bmFCInT1dQfkmF0=; b=MDUOivwLEXRu44B/Z6
        E4mBTYSKDYIrzD1t1/aCk4dzf6+FeRoExoxUlGEyhRr5lMgvySVzaCqvNvG76iGQ
        2oi/AbjfXo7iYpDDxog6IsdMCBHTvpc9FPt/5RusRdwXbY8InRdV2I4244gj0QpJ
        C3RbKekvn1yuwVU53tQJXRtOwcuRXwb7mw5ObN9k8fGROJFUQmXtCN7/5Q6vk6HT
        pcvL6zd3uqZmdiu/E3nRFzFptZxjKs0rGiO4jdZJuw+WbYv8/P94Fd1jzhZ8YTd6
        7H7RaGxoUFY3/n2SpTPBlLvDH9ABZQT1y7v5xYu+tgjQ10PqtDFZONjJIfaEqKAy
        YDYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682969715; x=1683056115; bh=hWWjXXWv7d7L0
        ntgkDmp3fxBvyf0bmFCInT1dQfkmF0=; b=EOIHQnDTP0495Zyd/kpI1RJG9XH79
        +mLjqyuFFml14KxqtvNHszNG9lKdRL0ktrI/agRRDu2H0IFSBMaJ+Uik5MhtmMCC
        fAE4BP0LzXTVvnM3uOlVVd6rhWu2acYTMw3tl+oQ9BH2gylkXeDgaVuHk8QJi3XM
        Z2lGTYSD1AJEa5Ee+NMy5eIr1iLfJoJ21Qj8sD1R2dPrEGoOofblTPNbGuEe+i35
        56b4cMpWaAbPA+GdcS6nnjJ4c8JKu3Q+2CyaemtYX0ELM2yyM+oWbtzlsbHMub7y
        KGFPWXVb4tz4OJQeCGwqAVEsE44/NzlI0VbCBkYXMZGyQ53HKRXn+2aeg==
X-ME-Sender: <xms:chRQZKSuevyRtYghWZP9Dcl987j3RJSCY9YnCtpDRRHv9NhNMCoo3w>
    <xme:chRQZPzPSTjc94IaB1lCGUJqcu4nH0QtJnQX_FXJOIPD-jE-i4E4WeRmJGZZmdqEP
    tWWMUSJA7WyPRPofzY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedvgedgudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:chRQZH1O-oPvl34hGSnQHm1Y4KWLpz8yL51ReZ0SAyBcH7SpTYlVdg>
    <xmx:chRQZGAlNxqHQo2QeCWqL_JXZvf4THO9TqNSvO4EIXbErye-2YWE_w>
    <xmx:chRQZDju0qWdOmaaxuShsfO1cGMUL8TyezvA642izCibXgrVQrEcuw>
    <xmx:cxRQZCNe4CIAsYveG_7_BevEmtPdrmp173UAOevDKKarVcZIagQYvQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id BE5C8B60086; Mon,  1 May 2023 15:35:14 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-374-g72c94f7a42-fm-20230417.001-g72c94f7a
Mime-Version: 1.0
Message-Id: <db973b45-a292-4924-a351-40bec063434e@app.fastmail.com>
In-Reply-To: <ZE/duNH3lBLreNkJ@corigine.com>
References: <20230501150624.3552344-1-arnd@kernel.org>
 <ZE/duNH3lBLreNkJ@corigine.com>
Date:   Mon, 01 May 2023 21:34:54 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Simon Horman" <simon.horman@corigine.com>,
        "Arnd Bergmann" <arnd@kernel.org>
Cc:     "Shannon Nelson" <shannon.nelson@amd.com>,
        "Brett Creeley" <brett.creeley@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, Netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "Conor Dooley" <conor.dooley@microchip.com>,
        "Philipp Zabel" <p.zabel@pengutronix.de>
Subject: Re: [PATCH] pds_core: fix linking without CONFIG_DEBUG_FS
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 1, 2023, at 17:41, Simon Horman wrote:
> On Mon, May 01, 2023 at 05:06:14PM +0200, Arnd Bergmann wrote:
>
> While exercising this I noticed that building pds_core fails
> if either CONFIG_AUXILIARY_BUS or NET_DEVLINK are not enabled.
>
> I think the solution is for PFS_CORE to select both CONFIG_AUXILIARY_BUS
> and NET_DEVLINK.

Makes sense. I just double-checked the other uses of these symbols
to see if they should be 'select' or 'depends on', and you are
right that selecting them is the correct solution.

There are two instances of 'depends on CONFIG_AUXILIARY_BUS'
in drivers/reset that both should be 'select' as well, since
this is not a user-visible symbol.

       Arnd
