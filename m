Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E53D141DCB
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 13:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgASMco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 07:32:44 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51710 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgASMco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 07:32:44 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1it9kt-0002tD-F7; Sun, 19 Jan 2020 13:32:39 +0100
Date:   Sun, 19 Jan 2020 13:32:39 +0100
From:   Florian Westphal <fw@strlen.de>
To:     David Miller <davem@davemloft.net>
Cc:     fw@strlen.de, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netlink: make getters tolerate NULL nla arg
Message-ID: <20200119123239.GB795@breakpoint.cc>
References: <20200116145522.28803-1-fw@strlen.de>
 <20200117.040849.2032549448991143345.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117.040849.2032549448991143345.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> From: Florian Westphal <fw@strlen.de>
> Date: Thu, 16 Jan 2020 15:55:22 +0100
> 
> > One recurring bug pattern triggered by syzbot is NULL dereference in
> > netlink code paths due to a missing "tb[NL_ARG_FOO] != NULL" test.
> > 
> > At least some of these missing checks would not have crashed the kernel if
> > the various nla_get_XXX helpers would return 0 in case of missing arg.
> > 
> > Make the helpers return 0 instead of crashing when a null nla is provided.
> > Even with allyesconfig the .text increase is only about 350 bytes.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Sorry, I think it's better to find out when code is trying to access
> attributes without verifying that they are even supplied.

Less than 24 hours after I saw this patch marked rejected syzbot
reported another incarnation of this pattern.

Would you consider a v2 with a WARN_ON_ONCE() added (and the
buildbot warning resolved)?

Thanks.
