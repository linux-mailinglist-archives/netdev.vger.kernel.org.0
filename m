Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54223281566
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388081AbgJBOkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgJBOkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:40:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8BA2206B2;
        Fri,  2 Oct 2020 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601649603;
        bh=Bfr0I14QJrbWCxAlqSxE8ncmUCFZj25RV4q3P8qFynA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m9c2mk98hZNF4SMy1j/Lyk4biORLEt+sx63oX96WYz6z+ghBSlVwlDe2ioZtGge3G
         cUJXdFhGsjO1TGIWiwl3An/0fQX6KjzRtVd+Nm30BfhTwahSBhVdppPVMdOgGi6Buj
         y9SeWeAREiarWeOrLjKPeG0mIDQ5ZWAq3+8ryHz0=
Date:   Fri, 2 Oct 2020 07:40:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
Message-ID: <20201002074001.3484568a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d26ccd875ebac452321343cc9f6a9e8ef990efbf.camel@sipsolutions.net>
References: <20201001225933.1373426-1-kuba@kernel.org>
        <20201001173644.74ed67da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d26ccd875ebac452321343cc9f6a9e8ef990efbf.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 02 Oct 2020 08:29:27 +0200 Johannes Berg wrote:
> On Thu, 2020-10-01 at 17:36 -0700, Jakub Kicinski wrote:
> > Do we need support for separate .doit and .dumpit policies?
> > Or is that an overkill?  
> 
> I suppose you could make an argument that only some attrs might be
> accepted in doit and somewhat others in dumpit, or perhaps none in
> dumpit because filtering wasn't implemented?

Right? Feels like it goes against our strict validation policy to
ignore input on dumpit.

> But still ... often we treat filtering as "advisory" anyway (except
> perhaps where there's no doit at all, like the dump_policy thing here),
> so it wouldn't matter if some attribute is ending up ignored?

It may be useful for feature discovery to know if an attribute is
supported.

I don't think it matters for any user right now, but maybe we should
require user space to specify if they are interested in normal req
policy or dump policy? That'd give us the ability to report different
ones in the future when the need arises.
