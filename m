Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCBB2B892E
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgKSAzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgKSAzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 19:55:04 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFE2C0613D4;
        Wed, 18 Nov 2020 16:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=B5418EKgBrhzsgtRcZdLETpCCjKmhOs4s0siZt8MTTU=; b=vi2Wmlal0k57aT/TmquQqZ58yJ
        zcaoIECafJV5N2QZOGXUW9nKihm96Y+dG+4hazib5altKAC935LwOMmGz9hyAtJ84xpl/RmEahjN8
        itrl5exAbtj9g+c1OwEMK3e0bSdunJ2euk2aSu1XimXGbJjyGS26i0HkETsGZZNGTPpHGRgZhe4O2
        GJ2ZvvUNWJm5YCzmhlx5tTLQ5BRBKL9YHGMlDefDTSjH+SEEkR42DFVxiD4TWbcVlLkWEqPptMQyN
        2mMSd3XEcEVuhsnmRD7zHnwlMQ0HxOzsWEzdWWRRTGCSvVYOH5/Ydrv6bFug7MixXCOvKKCbePRiC
        sYspbxeA==;
Received: from [2601:1c0:6280:3f0::bcc4]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kfYDt-0008C6-2s; Thu, 19 Nov 2020 00:54:56 +0000
Subject: Re: [PATCH net] ipv6: Remove dependency of ipv6_frag_thdr_truncated
 on ipv6 module
To:     Georg Kohmann <geokohma@cisco.com>, netdev@vger.kernel.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
References: <20201118234445.4911-1-geokohma@cisco.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <fb9d3762-560d-444c-adcd-496fcbb7e0cb@infradead.org>
Date:   Wed, 18 Nov 2020 16:54:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201118234445.4911-1-geokohma@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/20 3:44 PM, Georg Kohmann wrote:
> IPV6=m
> NF_DEFRAG_IPV6=y
> 
> ld: net/ipv6/netfilter/nf_conntrack_reasm.o: in function
> `nf_ct_frag6_gather':
> net/ipv6/netfilter/nf_conntrack_reasm.c:462: undefined reference to
> `ipv6_frag_thdr_truncated'
> 
> Netfilter is depending on ipv6 symbol ipv6_frag_thdr_truncated. This
> dependency is forcing IPV6=y.
> 
> Remove this depencency by moving ipv6_frag_thdr_truncated out of ipv6. This

              dependency

> is the same solution as used with a similar issues: Referring to
> commit 70b095c843266 ("ipv6: remove dependency of nf_defrag_ipv6 on ipv6
> module")
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Georg Kohmann <geokohma@cisco.com>
> ---
>  include/net/ipv6.h                      |  2 --
>  include/net/ipv6_frag.h                 | 30 ++++++++++++++++++++++++++++++
>  net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
>  net/ipv6/reassembly.c                   | 31 +------------------------------
>  4 files changed, 32 insertions(+), 33 deletions(-)

OK, works for me.  Thanks.
 
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

-- 
~Randy

