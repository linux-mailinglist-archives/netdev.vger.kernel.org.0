Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C6A56CE22
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 11:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiGJJAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 05:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGJJAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 05:00:17 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BEA11A18;
        Sun, 10 Jul 2022 02:00:17 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A72D55C00D5;
        Sun, 10 Jul 2022 05:00:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 10 Jul 2022 05:00:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1657443616; x=1657530016; bh=FuH+7xDCBPPGGPgblHUmZHZZT8Lo
        ZV54xq/hlaP9zuk=; b=ZwFdihFDwFWT52Z+xMrCwILk2r9H5a1IF+CrInbmw4uv
        otrpDIsjKctIa1zFFfPJOAgbf+2a3Fq/GDePfAryXvPsezoS5mpkf6Yea8b+NBYQ
        4XoZ1bUor/6r/6DZa/SK+JW3O386fSdfqiE8XLtCdts8m1yQbhgAHdZqTUwJHYSt
        rGhkNk6of8466FXBrYUl/r1A8ITDrLcG2mlm5Em6LzWGq5H9dcTHXmlcQn9iWm5f
        A8LoVgQAJyFTuzv/JPcOwe4puFlGtVplQ1kEiGoviKp1WRxO5liGIHrMReqpN+rK
        k2Xhq3DSPJgKRUZr8oiIp2mDaRIZ9JAGSzDT8Rt7lQ==
X-ME-Sender: <xms:IJXKYkr03nXPzgjWA50z4pescZ3eQGf9iPP7enI1ZGlZMqYOAF0ZvA>
    <xme:IJXKYqqbliegcjRfDjzNaQUSwx-xnMSwM_VA4EUyw43Qmwi6583saYrDdzmhm-Nq6
    yD3HlmAgghJCSU>
X-ME-Received: <xmr:IJXKYpNbEw9w4NpVITrw8aa9Wix1IsQsh-2MSjOMyXPYGYpBonMDKLuvjbwM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudejuddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedvudefveekheeugeeftddvveefgf
    duieefudeifefgleekheegleegjeejgeeghfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:IJXKYr576_kv1WzU1ih1AAhkmWVcYvVyZXNDqeVEnWxn44hdEKNAFA>
    <xmx:IJXKYj4o3A0uOxIWxpQM6jFpW06codvyAILFEsj3Av09CkCOE95ZVQ>
    <xmx:IJXKYrhy8xA2IBZUoeqcH2jTabPj6K3gD4xKnMSNoSnBxOiaquAMaw>
    <xmx:IJXKYqKc2dOhvO2s6mOKnCK4tycYj9diymruj91pTHfGMS0GU0nraw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Jul 2022 05:00:15 -0400 (EDT)
Date:   Sun, 10 Jul 2022 12:00:13 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>, vikas.gupta@broadcom.com
Cc:     jiri@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v2 1/3] devlink: introduce framework for
 selftests
Message-ID: <YsqVHWhNLOP5qKlk@shredder>
References: <20220628164241.44360-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-2-vikas.gupta@broadcom.com>
 <20220707182022.78d750a7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707182022.78d750a7@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 06:20:22PM -0700, Jakub Kicinski wrote:
> On Thu,  7 Jul 2022 23:59:48 +0530 Vikas Gupta wrote:
> >  static const struct genl_small_ops devlink_nl_ops[] = {
> > @@ -9361,6 +9493,18 @@ static const struct genl_small_ops devlink_nl_ops[] = {
> >  		.doit = devlink_nl_cmd_trap_policer_set_doit,
> >  		.flags = GENL_ADMIN_PERM,
> >  	},
> > +	{
> > +		.cmd = DEVLINK_CMD_SELFTESTS_SHOW,
> > +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> 
> I think we can validate strict for new commands, so no validation flags
> needed.
> 
> > +		.doit = devlink_nl_cmd_selftests_show,
> 
> What about dump? Listing all tests on all devices?
> 
> > +		.flags = GENL_ADMIN_PERM,

Related to Jakub's question, is there a reason that the show command
requires 'GENL_ADMIN_PERM' ?

> > +	},
> > +	{
> > +		.cmd = DEVLINK_CMD_SELFTESTS_RUN,
> > +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> > +		.doit = devlink_nl_cmd_selftests_run,
> > +		.flags = GENL_ADMIN_PERM,
> > +	},
> >  };
> >  
> >  static struct genl_family devlink_nl_family __ro_after_init = {
> 
