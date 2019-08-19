Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7509194BD8
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfHSRiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:38:12 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57846 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726959AbfHSRiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:38:12 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1hzlbe-0006dN-0z; Mon, 19 Aug 2019 19:38:10 +0200
Date:   Mon, 19 Aug 2019 19:38:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Vakul Garg <vakul.garg@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Help needed - Kernel lockup while running ipsec
Message-ID: <20190819173810.GK2588@breakpoint.cc>
References: <DB7PR04MB4620CD9AFFAFF8678F803DCE8BA80@DB7PR04MB4620.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB7PR04MB4620CD9AFFAFF8678F803DCE8BA80@DB7PR04MB4620.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vakul Garg <vakul.garg@nxp.com> wrote:
> Hi
> 
> With kernel 4.14.122, I am getting a kernel softlockup while running single static ipsec tunnel.
> The problem reproduces mostly after running 8-10 hours of ipsec encap test (on my dual core arm board).
> 
> I found that in function xfrm_policy_lookup_bytype(), the policy in variable 'ret' shows refcnt=0 under problem situation.
> This creates an infinite loop in  xfrm_policy_lookup_bytype() and hence the lockup.
> 
> Can some body please provide me pointers about 'refcnt'?
> Is it legitimate for 'refcnt' to become '0'? Under what condition can it become '0'?

Yes, when policy is destroyed and the last user calls
xfrm_pol_put() which will invoke call_rcu to free the structure.
