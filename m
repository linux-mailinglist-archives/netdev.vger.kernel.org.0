Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5D76A8133
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 12:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjCBLgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 06:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjCBLfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 06:35:40 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D69936FCC;
        Thu,  2 Mar 2023 03:35:33 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pXhDX-0000l2-92; Thu, 02 Mar 2023 12:35:23 +0100
Date:   Thu, 2 Mar 2023 12:35:23 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Madhu Koriginja <madhu.koriginja@nxp.com>
Cc:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, edumazet@google.com, dccp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vani.namala@nxp.com
Subject: Re: [PATCH] [net:netfilter]: Keep conntrack reference until IPsecv6
 policy checks are done
Message-ID: <20230302113523.GD23204@breakpoint.cc>
References: <20230302112324.906365-1-madhu.koriginja@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302112324.906365-1-madhu.koriginja@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Madhu Koriginja <madhu.koriginja@nxp.com> wrote:
> Keep the conntrack reference until policy checks have been performed for
> IPsec V6 NAT support. The reference needs to be dropped before a packet is
> queued to avoid having the conntrack module unloadable.

Subject Line should be:

[PATCH net] net: netfilter: Keep conntrack reference until IPsecv6 policy checks are done
or
[PATCH net-next] net: netfilter: Keep ..

see below why net-next makes more sense to me.

> Signed-off-by: Madhu Koriginja <madhu.koriginja@nxp.com>
> 	V1-V2: added missing () in ip6_input.c in below condition
> 	if (!(ipprot->flags & INET6_PROTO_NOPOLICY))

This should appear before your signed-off-by, or 
> ---
>  net/dccp/ipv6.c      |  1 +

... here.

I think its fine to place it here because in this case
the mini-changelog doesn't provide any additional context
worth keeping in git.

Paolo, Jakub, David: This is a bug, but its not a regression
either.  I would suggest that Madhu resubmits this AFTER
net-next re-opens.

Madhu, if thats the agreed-upon procedure, you may include

Reviewed-by: Florian Westphal <fw@strlen.de>

when you resend this patch as-is.
