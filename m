Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D5D4D5C23
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346739AbiCKHUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiCKHUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:20:37 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670AE1B30A6;
        Thu, 10 Mar 2022 23:19:35 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 25CC468AFE; Fri, 11 Mar 2022 08:19:31 +0100 (CET)
Date:   Fri, 11 Mar 2022 08:19:30 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Mingbao Sun <sunmingbao@tom.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH] tcp: export symbol tcp_set_congestion_control
Message-ID: <20220311071930.GA18301@lst.de>
References: <20220310134830.130818-1-sunmingbao@tom.com> <20220310124825.159ce624@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220310124825.159ce624@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 12:48:25PM -0800, Jakub Kicinski wrote:
> On Thu, 10 Mar 2022 21:48:30 +0800 Mingbao Sun wrote:
> > Since the kernel API 'kernel_setsockopt' was removed, and since the
> > function ‘tcp_set_congestion_control’ is just the real underlying guy
> > handling this job, so it makes sense to get it exported.
> 
> Do you happen to have a reference to the commit which removed
> kernel_setsockopt and the justification?  My knee jerk reaction
> would the that's a better path than allowing in-kernel socket users 
> to poke at internal functions even if that works as of today.

This was part of the set_fs() removal. Back then we decided we'd rather
have type-safe APIs for in-kernel users, which in total was a major
removal of code lines.
