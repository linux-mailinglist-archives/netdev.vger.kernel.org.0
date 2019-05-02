Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0188711A38
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 15:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfEBNcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 09:32:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:42500 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726267AbfEBNcd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 09:32:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CEB8CADEA;
        Thu,  2 May 2019 13:32:31 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 48508E0117; Thu,  2 May 2019 15:32:31 +0200 (CEST)
Date:   Thu, 2 May 2019 15:32:31 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] genetlink: do not validate dump requests if
 there is no policy
Message-ID: <20190502133231.GF21672@unicorn.suse.cz>
References: <cover.1556798793.git.mkubecek@suse.cz>
 <0a54a4db49c20e76a998ea3e4548b22637fbad34.1556798793.git.mkubecek@suse.cz>
 <031933f3fc4b26e284912771b480c87483574bea.camel@sipsolutions.net>
 <20190502131023.GD21672@unicorn.suse.cz>
 <ab9b48a0e21d0a9e5069045c23db36f43e4356e3.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab9b48a0e21d0a9e5069045c23db36f43e4356e3.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 02, 2019 at 03:13:00PM +0200, Johannes Berg wrote:
> On Thu, 2019-05-02 at 15:10 +0200, Michal Kubecek wrote:
> > On Thu, May 02, 2019 at 02:51:33PM +0200, Johannes Berg wrote:
> > > On Thu, 2019-05-02 at 12:48 +0000, Michal Kubecek wrote:
> > > > Unlike do requests, dump genetlink requests now perform strict validation
> > > > by default even if the genetlink family does not set policy and maxtype
> > > > because it does validation and parsing on its own (e.g. because it wants to
> > > > allow different message format for different commands). While the null
> > > > policy will be ignored, maxtype (which would be zero) is still checked so
> > > > that any attribute will fail validation.
> > > > 
> > > > The solution is to only call __nla_validate() from genl_family_rcv_msg()
> > > > if family->maxtype is set.
> > > 
> > > D'oh. Which family was it that you found this on? I checked only ones
> > > with policy I guess.
> > 
> > It was with my ethtool netlink series (still work in progress).
> 
> Then you should probably *have* a policy to get all the other goodies
> like automatic policy export (once I repost those patches)

Wouldn't it mean effecitvely ending up with only one command (in
genetlink sense) and having to distinguish actual commands with
atributes? Even if I wanted to have just "get" and "set" command, common
policy wouldn't allow me to say which attributes are allowed for each of
them.

Michal
