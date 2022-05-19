Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F29052DE21
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 22:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238814AbiESUNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 16:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiESUNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 16:13:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A0FC8BFA
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 13:13:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E440E61CC1
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 20:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2120AC385AA;
        Thu, 19 May 2022 20:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652991222;
        bh=biRwAq4eZBF1N4T7Jz7PMLCu7XfaIzpmrzVf+GU3EGY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kfBtkMugCQ8+S3O/KKj+pFCySdH+q2MrROx2/PMCEMhvk9ShMJuGeO6DyAvbOmTj6
         cUj2Eb7V0+k6tyUNfhZC8oOpAEHh+n/v7q1KsMOaHMcPZ7Q+swFELlwZdsRfgOIrlr
         ElMlnWumDGWVemgrledF8RrEKKhuko7mFxl7ukd9n34WAb7j934C8UxqbqZqqtdsbM
         gVkF9DKJYbhxYhBonE2zeqjKdQnQyVFopchoNxFYwxI7vLySAHyMLUoM2KzqFiN7Oz
         JeKTXyG38Zg7rA3A8IQg9ooIOO08aYfjN6F5lRSEoncTAa3/onm5l42gpgZGr/OvCm
         g+zMnx09NsdlA==
Date:   Thu, 19 May 2022 13:13:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Oliver Smith <osmith@sysmocom.de>,
        netdev@vger.kernel.org, Harald Welte <laforge@gnumonks.org>
Subject: Re: regression: 'ctnetlink_dump_one_entry' defined but not used
Message-ID: <20220519131341.36c8b24e@kernel.org>
In-Reply-To: <20220519102100.GJ4316@breakpoint.cc>
References: <97b1ea34-250b-48ba-bc04-321b6c0482c1@sysmocom.de>
        <20220519102100.GJ4316@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 12:21:00 +0200 Florian Westphal wrote:
> Oliver Smith <osmith@sysmocom.de> wrote:
> > Hi Florian,
> > 
> > since May 17 we see some automatic builds against net-next.git fail with:
> >   
> > > net/netfilter/nf_conntrack_netlink.c:1717:12: error: 'ctnetlink_dump_one_entry' defined but not used [-Werror=unused-function]
> > >  1717 | static int ctnetlink_dump_one_entry(struct sk_buff *skb,
> > >       |            ^~~~~~~~~~~~~~~~~~~~~~~~  
> > 
> > Looks like this is a regression from your patch 8a75a2c17, I guess
> > ctnetlink_dump_one_entry needs #ifdef CONFIG_NF_CONNTRACK_EVENTS?  
> 
> Its fixed in nf-next.

Let's get it out to net-next, please, I'm carrying this patch locally
as well :(
