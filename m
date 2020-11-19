Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB202B9832
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgKSQhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgKSQhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 11:37:53 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1CAC0613CF;
        Thu, 19 Nov 2020 08:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=gHMOgW7vGvHwFQ/LwXMNNh7tP/+xntm6sL8PHrnVw+s=; b=Hr69kj/hMZnD83PR8CeMBzd0d5
        Q8bySE/9SwmQvCwJOXL8pl9Hgl2vtLcNA20vhTmVSJKFxPZeH+G7S12/jDBAAMupPDB16XX/CDjq/
        9US0PctSeW5F8fnuYYxhPgPaoWj4RbW52vTS6prtUfN0vaEzRir/lKk3BeYKhxj5e3w5947/fwEmx
        vxhaDol9Ondo8Adw0KHyeD676fYb0KaVy4b3OVewTImc9vsyATu3AgD/ChZyGduwFS4+1/EGqlMuD
        Sax/dPtVMMQDRJBU7UIfHFsy4sNtxkCE7OaXvZc6nk4qrBrViJmToKpQcdcPo/f0lHEGBgNR0XNcn
        csNV6l4Q==;
Received: from [2601:1c0:6280:3f0::bcc4]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kfmwP-0007TV-7F; Thu, 19 Nov 2020 16:37:49 +0000
Subject: Re: [PATCH net v2] ipv6: Remove dependency of
 ipv6_frag_thdr_truncated on ipv6 module
To:     Georg Kohmann <geokohma@cisco.com>, netdev@vger.kernel.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
References: <20201119095833.8409-1-geokohma@cisco.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e0057da4-4522-f380-b12d-3d7bed8221d3@infradead.org>
Date:   Thu, 19 Nov 2020 08:37:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201119095833.8409-1-geokohma@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/20 1:58 AM, Georg Kohmann wrote:
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
> Remove this dependency by moving ipv6_frag_thdr_truncated out of ipv6. This
> is the same solution as used with a similar issues: Referring to
> commit 70b095c843266 ("ipv6: remove dependency of nf_defrag_ipv6 on ipv6
> module")
> 
> Fixes: 9d9e937b1c8b ("ipv6/netfilter: Discard first fragment not including all headers")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Georg Kohmann <geokohma@cisco.com>
> ---
> 
> Notes:
>     v2: Add Fixes tag and fix spelling in comment.

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> 
>  include/net/ipv6.h                      |  2 --
>  include/net/ipv6_frag.h                 | 30 ++++++++++++++++++++++++++++++
>  net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
>  net/ipv6/reassembly.c                   | 31 +------------------------------
>  4 files changed, 32 insertions(+), 33 deletions(-)
> 

-- 
~Randy

