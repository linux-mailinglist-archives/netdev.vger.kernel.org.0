Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0C7539BDA
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 05:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349534AbiFAD7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 23:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240934AbiFAD7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 23:59:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA238AE7A;
        Tue, 31 May 2022 20:59:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CB116114D;
        Wed,  1 Jun 2022 03:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E1FC385B8;
        Wed,  1 Jun 2022 03:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654055951;
        bh=EPTeokL1mGBSVKYzyMo2uVuxRSeWeb/M2HCRNJuM3bk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xn1vnoJbeuGnaRRcwFvcKnDxAa98WuwdnKdVdQGFRTfcV2+sRixiyoDkU+GUHdHBE
         0ApRs66QNZGlmEHubpXLJcxAj+bvasWlEDhdHKWuk4a8Bcca2N5QsdJ5Y31+sQfBvD
         RLJgdIiyVdpwVkiF/3HSMldOCoFQLSrTjK+WhHCTMo5cVdfGbYLkCjhwX1jhYhyGjC
         /F4in2gqZMLPlMriJ7izhaN17HcZrtY09sY7kQ3jTuVb6lWhGswdnxKU6m4qjHghnE
         tAmiFbXjbPJbESGj/Da9D14HvPhibjM/r6YYK0jS0F2K+SJ1bR5nNV89NMyd0Jj2U4
         oPgZ4pbsyH1dg==
Date:   Tue, 31 May 2022 20:59:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net 3/5] netfilter: nf_tables: double hook
 unregistration in netns path
Message-ID: <20220531205910.2f69589d@kernel.org>
In-Reply-To: <20220531215839.84765-4-pablo@netfilter.org>
References: <20220531215839.84765-1-pablo@netfilter.org>
        <20220531215839.84765-4-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 May 2022 23:58:37 +0200 Pablo Neira Ayuso wrote:
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index f77414e13de1..746be13438ef 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -222,12 +222,18 @@ static int nft_netdev_register_hooks(struct net *net,
>  }
>  
>  static void nft_netdev_unregister_hooks(struct net *net,
> -					struct list_head *hook_list)
> +					struct list_head *hook_list,
> +					bool release_netdev)

FWIW

ERROR: code indent should use tabs where possible
#115: FILE: net/netfilter/nf_tables_api.c:7327:
+^I^I^I^I^I         bool release_netdev)$

