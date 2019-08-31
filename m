Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53549A4368
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 10:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfHaInU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 04:43:20 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60066 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbfHaInU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 04:43:20 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i3yyZ-0000iW-BO; Sat, 31 Aug 2019 10:43:15 +0200
Date:   Sat, 31 Aug 2019 10:43:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 2/2] net: br_netfiler_hooks: Drops IPv6 packets if
 IPv6 module is not loaded
Message-ID: <20190831084315.GU20113@breakpoint.cc>
References: <20190830181354.26279-1-leonardo@linux.ibm.com>
 <20190830181354.26279-3-leonardo@linux.ibm.com>
 <20190830205541.GR20113@breakpoint.cc>
 <2ba876f9ad6597e640df68f09659dce3c4b5ce03.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ba876f9ad6597e640df68f09659dce3c4b5ce03.camel@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leonardo Bras <leonardo@linux.ibm.com> wrote:
> > There are two solutions:
> > 1. The above patch, but use NF_ACCEPT instead
> > 2. keep the DROP, but move it below the call_ip6tables test,
> >    so that users can tweak call-ip6tables to accept packets.
> 
> Q: Does 2 mean that it will only be dropped if bridge intents to use
> host's ip6tables? Else, it will be accepted by previous if?

Yes, thats the idea: Let users decide if ipv6.disable or call-ip6tables
is more important to them.
