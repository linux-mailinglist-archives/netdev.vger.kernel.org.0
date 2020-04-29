Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABAB1BE705
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgD2TNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:13:02 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34722 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726456AbgD2TNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:13:02 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jTs8e-0000MC-7O; Wed, 29 Apr 2020 21:12:56 +0200
Date:   Wed, 29 Apr 2020 21:12:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_osf: avoid passing pointer to local var
Message-ID: <20200429191256.GL32392@breakpoint.cc>
References: <20200429190051.27993-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429190051.27993-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:
> gcc-10 points out that a code path exists where a pointer to a stack
> variable may be passed back to the caller:
> 
> net/netfilter/nfnetlink_osf.c: In function 'nf_osf_hdr_ctx_init':
> cc1: warning: function may return address of local variable [-Wreturn-local-addr]
> net/netfilter/nfnetlink_osf.c:171:16: note: declared here
>   171 |  struct tcphdr _tcph;
>       |                ^~~~~
> 
> I am not sure whether this can happen in practice, but moving the
> variable declaration into the callers avoids the problem.

LGTM, thanks Arnd.

Reviewed-by: Florian Westphal <fw@strlen.de>
