Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADFB6C41BE
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 05:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjCVE6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 00:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCVE6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 00:58:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DD526584;
        Tue, 21 Mar 2023 21:58:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E40A2B819BC;
        Wed, 22 Mar 2023 04:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04591C4339B;
        Wed, 22 Mar 2023 04:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679461098;
        bh=Y81qCp1LHk8B/PcrfomdLSIZfNVP8dHYfNNJSh3UeOA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hKxwGQPOCze6EutMfsj1SPtw7PZAN56KHNR3eXyLH3rYsHmChXStxLQIUQuHxG2va
         /NPtJKSSNS4HlIsXJiW7m3soLWaImMGSjDWXo0oFU1QBEZNQDirleYE9O25VydG+0t
         1uS8NXkJhKSoPttuYxVnM+0PLpEVAiNlBz3qBCOQhWlMd+nOFNhC96tVkwRuhuK/7i
         QmM0DBVUVSMXFafGw5H2muU/SQE8YZTKx+g3n0RI5VBDjzNQe21LLZskUlJfXFDlKb
         nhLufRAea5WBBaig4FEVcWcgpx9cnpCPJ/1o4gsiFbWHQU+svmkoCw+zlpd6nkeJzI
         uZvhfvZZq94vw==
Date:   Tue, 21 Mar 2023 21:58:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Jozsef Kadlecsik" <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <linux-kernel@vger.kernel.org>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next 1/1] netfilter: ctnetlink: Support offloaded
 conntrack entry deletion
Message-ID: <20230321215816.40450b38@kernel.org>
In-Reply-To: <1679406604-133128-1-git-send-email-paulb@nvidia.com>
References: <1679406604-133128-1-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Mar 2023 15:50:04 +0200 Paul Blakey wrote:
> To: Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>, Saeed Mahameed  <saeedm@nvidia.com>, Pablo Neira Ayuso <pablo@netfilter.org>, "Jozsef  Kadlecsik" <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, "David S.  Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, "Jakub  Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,  <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,  <linux-kernel@vger.kernel.org>
> CC: Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>, Vlad Buslov  <vladbu@nvidia.com>

Please put the maintainers you expect to take the patch on To:
And the rest of the people on CC:

> Subject: [PATCH net-next 1/1] netfilter: ctnetlink: Support offloaded conntrack entry deletion

git log --no-merges \
	--format='%<(20)%cn %cs  %<(47,trunc)%s' \
	-- \
	net/netfilter/nf_conntrack_netlink.c

clearly not net-next, we don't take patches to this file.
