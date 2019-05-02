Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E29119DA
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 15:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfEBNNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 09:13:09 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56028 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEBNNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 09:13:09 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hMBWI-0002Bu-CD; Thu, 02 May 2019 15:13:02 +0200
Message-ID: <ab9b48a0e21d0a9e5069045c23db36f43e4356e3.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 1/3] genetlink: do not validate dump requests
 if there is no policy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 02 May 2019 15:13:00 +0200
In-Reply-To: <20190502131023.GD21672@unicorn.suse.cz>
References: <cover.1556798793.git.mkubecek@suse.cz>
         <0a54a4db49c20e76a998ea3e4548b22637fbad34.1556798793.git.mkubecek@suse.cz>
         <031933f3fc4b26e284912771b480c87483574bea.camel@sipsolutions.net>
         <20190502131023.GD21672@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-05-02 at 15:10 +0200, Michal Kubecek wrote:
> On Thu, May 02, 2019 at 02:51:33PM +0200, Johannes Berg wrote:
> > On Thu, 2019-05-02 at 12:48 +0000, Michal Kubecek wrote:
> > > Unlike do requests, dump genetlink requests now perform strict validation
> > > by default even if the genetlink family does not set policy and maxtype
> > > because it does validation and parsing on its own (e.g. because it wants to
> > > allow different message format for different commands). While the null
> > > policy will be ignored, maxtype (which would be zero) is still checked so
> > > that any attribute will fail validation.
> > > 
> > > The solution is to only call __nla_validate() from genl_family_rcv_msg()
> > > if family->maxtype is set.
> > 
> > D'oh. Which family was it that you found this on? I checked only ones
> > with policy I guess.
> 
> It was with my ethtool netlink series (still work in progress).

Then you should probably *have* a policy to get all the other goodies
like automatic policy export (once I repost those patches)

johannes

