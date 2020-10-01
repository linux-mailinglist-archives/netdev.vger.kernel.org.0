Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7FD28093A
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733026AbgJAVKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbgJAVKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 17:10:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE43C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 14:10:13 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kO5q7-00EpB8-OV; Thu, 01 Oct 2020 23:10:11 +0200
Message-ID: <131f3d344499ec58fa653a8d7c15e646ff8f98d0.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 8/9] genetlink: use per-op policy for
 CTRL_CMD_GETPOLICY
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Date:   Thu, 01 Oct 2020 23:10:10 +0200
In-Reply-To: <20201001140911.795b7662@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201001183016.1259870-1-kuba@kernel.org>
         <20201001183016.1259870-9-kuba@kernel.org>
         <b9be586bd097f76c554d3e404e0344ae817a12f1.camel@sipsolutions.net>
         <20201001140911.795b7662@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 14:09 -0700, Jakub Kicinski wrote:
> On Thu, 01 Oct 2020 22:55:09 +0200 Johannes Berg wrote:
> > On Thu, 2020-10-01 at 11:30 -0700, Jakub Kicinski wrote:
> > > Wire up per-op policy for CTRL_CMD_GETPOLICY.
> > > This saves us a call to genlmsg_parse() and will soon allow
> > > dumping this policy.  
> > 
> > Hmm. Probably should've asked this before - I think the code makes
> > perfect sense, but I'm not sure how "this" follows?
> > 
> > I mean, we could've saved the genlmsg_parse() call before, with much the
> > same patch, having the per-op policy doesn't really have any bearing for
> > that? It was just using a different policy - the family one - instead of
> > the per-op one, but ...
> > 
> > Am I missing something?
> 
> Hm, not as far as I can tell, I was probably typing out the message
> fast cause the commit is kinda obivious.
> 
> Looking at the code again now I can't tell why it was calling
> genlmsg_parse() in the first place. LMK if you remember if there 
> was a reason.

Quite possibly it was just old code? I _think_, but didn't check now,
that the parsing for dumpit was added later. Hence the "don't parse"
validate flag, because it wasn't always done and thus would've accepted
any kind of junk as input ...

johannes

