Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09012632E05
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiKUUf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiKUUfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:35:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FE6D9B80;
        Mon, 21 Nov 2022 12:35:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D66B761465;
        Mon, 21 Nov 2022 20:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF146C433D6;
        Mon, 21 Nov 2022 20:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669062954;
        bh=uBI/+z4D892XWJGEL8Mg8igdUbmaBy3ZhQQHzB+U+wM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V4XnPYEyKLy8VWkqcBWKryJpFYf9qd6i+70Mc+f/pbEAJGgLoBi1eHYlPeoH36LbV
         5lvYcJKHvy83VrB8g53ySbOy7tXlPLjC8bsjv4e7zJphptMpVn2jaBgRhzFVGLNcJY
         q8Xj0+aJ2CORRaNzfgHPzibuOiyBenTlAN7oIi4tGqvdnzqTLwxnqe07dfupODDASn
         U//nvOlxxqy2Mpx79G92Rfc2Bk3h3YT1auzWDBX7spGaoAfF6kI0Q/Rypb9AKbZ7z+
         MCYNFEXJO2pLAgruXgs+wlQX9nalsw09SZS35ONJpPYJ9eO0ki1gSe+MiLDRIXdbuk
         JmKC0569JAG7w==
Date:   Mon, 21 Nov 2022 12:35:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Eric Dumazet <edumazet@google.com>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_flow_table: add missing locking
Message-ID: <20221121123552.16c00373@kernel.org>
In-Reply-To: <441bcda3-403f-0bf6-2d6f-d8c9d2ce44d6@nbd.name>
References: <20221121182615.90843-1-nbd@nbd.name>
        <3a9c2e94-3c45-5f83-c703-75e1cde13be1@nbd.name>
        <CANn89iKps9pM=DPn1aWF1SDMqrr=HHkHL8VofVHThUmtqzn=tQ@mail.gmail.com>
        <441bcda3-403f-0bf6-2d6f-d8c9d2ce44d6@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Nov 2022 21:08:12 +0100 Felix Fietkau wrote:
> > Could you also add a Fixes: tag ?  
> 
> I don't know which commit to use for that tag.

The oldest upstream commit where the problem you're solving 
can trigger?
