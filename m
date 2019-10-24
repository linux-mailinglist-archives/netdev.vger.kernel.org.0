Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48DD0E279D
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 03:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390097AbfJXBMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 21:12:23 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60006 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388218AbfJXBMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 21:12:23 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iNRfm-0007Dj-Uy; Thu, 24 Oct 2019 03:12:18 +0200
Date:   Thu, 24 Oct 2019 03:12:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     praveen chaudhary <praveen5582@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kadlec@netfilter.org, pablo@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>
Subject: Re: [PATCH] [netfilter]: Fix skb->csum calculation when netfilter
 manipulation for NF_NAT_MANIP_SRC\DST is done on IPV6 packet.
Message-ID: <20191024011218.GT25052@breakpoint.cc>
References: <1571857342-8407-1-git-send-email-pchaudhary@linkedin.com>
 <1571857342-8407-2-git-send-email-pchaudhary@linkedin.com>
 <20191023193337.GP25052@breakpoint.cc>
 <CAJ_cd4qHM3kqz24Uywpyyz0mPz7axiNZk0Q385ROd4O8XZ11fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ_cd4qHM3kqz24Uywpyyz0mPz7axiNZk0Q385ROd4O8XZ11fA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

praveen chaudhary <praveen5582@gmail.com> wrote:
> inet_proto_csum_replace16 is called from many places, whereas this fix is
> applicable only for nf_nat_ipv6_csum_update. where we need to update
> skb->csum for ipv6 src/dst address change.

Under which circumstances does inet_proto_csum_replace16 upate
skb->csum correctly?

> So, I added a new function. Basically, I used a safe approach to fix it,
> without impacting other cases. Let me know other options,  I am open to
> suggestions.

You seem to imply inet_proto_csum_replace16 is fine and only broken for ipv6
nat.
