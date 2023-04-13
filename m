Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6676E08A4
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjDMIKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjDMIKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:10:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365421BE1;
        Thu, 13 Apr 2023 01:10:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C66B8614D6;
        Thu, 13 Apr 2023 08:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2230C433D2;
        Thu, 13 Apr 2023 08:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681373403;
        bh=lMClDkMrgqgkJYaMUUXc7/mL4pKlD3f/q5HMOfhzsoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NrVGILoJGNuSkcJ8ebmZ3OaXsNtuRgD3ADdYmEXq1EBGMsJ8MgbgrrQT+xre30wWb
         sLxhmaVhLtSwCK34+4lPwOqkS+Q24SHaab5F75XpgDWl+B59vSlwa10JebA+mY3Znm
         61p+mQ0wc9P+xmyBuJKVqPbWOJxxRNHL2mJ3avIG5TQApSy7ldImysGlgb7BJNgApn
         Czikowyvobhpnxr0ep/w8fyH8Mvyg7d6uN51pTRchBawYK/slaTNkAzgYC62bS8vX2
         aG4s6z1K+YkNrZdtVay8HqRzIps2JMGrYCzeTxICQp5KdczeOAWt2r7TdKAFN84DsC
         KoxLFMjhj9M2w==
Date:   Thu, 13 Apr 2023 10:09:56 +0200
From:   Simon Horman <horms@kernel.org>
To:     Abhijeet Rastogi <abhijeet.1989@gmail.com>
Cc:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: change ip_vs_conn_tab_bits range to [8,31]
Message-ID: <ZDe41Nc8BjkXVcrf@kernel.org>
References: <20230412-increase_ipvs_conn_tab_bits-v1-1-60a4f9f4c8f2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412-increase_ipvs_conn_tab_bits-v1-1-60a4f9f4c8f2@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 01:49:08PM -0700, Abhijeet Rastogi via B4 Relay wrote:
> From: Abhijeet Rastogi <abhijeet.1989@gmail.com>
> 
> Current range [8, 20] is set purely due to historical reasons
> because at the time, ~1M (2^20) was considered sufficient.
> 
> Previous change regarding this limit is here.
> 
> Link: https://lore.kernel.org/all/86eabeb9dd62aebf1e2533926fdd13fed48bab1f.1631289960.git.aclaudi@redhat.com/T/#u
> 
> Signed-off-by: Abhijeet Rastogi <abhijeet.1989@gmail.com>
> ---

Hi Abhijeet,

> The conversation for this started at: 
> 
> https://www.spinics.net/lists/netfilter/msg60995.html

  'The 20 bit (1m entries) ceiling exists since the original merge of ipvs
   in 2003, so likely this was just considered "big enough" back then.'

Yes, that matches my recollection.

There were probably also concerns about the viability of making
larger allocations at the time on the kinds of systems where
IPVS would be deployed.

On the allocation theme, I do note that 2^31 does lead to a substantial
vmalloc allocation regardless of actual usage. Probably it would be best
to move IPVS to use rhashtable(). But that is obviously a much more
invasive change.

In any case, I think this patch is an improvement on the current situation.

Acked-by: Simon Horman <horms@kernel.org>

> 
> The upper limit for algo is any bit size less than 32, so this
> change will allow us to set bit size > 20. Today, it is common to have
> RAM available to handle greater than 2^20 connections per-host.
> 
> Distros like RHEL already have higher limits set.

...
