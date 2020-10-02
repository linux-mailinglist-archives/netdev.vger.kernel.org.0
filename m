Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676AD281C81
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbgJBUCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgJBUCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:02:05 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925FAC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 13:02:05 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kORFj-00FR9L-TE; Fri, 02 Oct 2020 22:02:04 +0200
Message-ID: <1b1089b3ff392b46bc3d4b975b07cd4e34081719.camel@sipsolutions.net>
Subject: Re: [PATCH 1/5] netlink: simplify netlink_policy_dump_start()
 prototype
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Fri, 02 Oct 2020 22:02:03 +0200
In-Reply-To: <20201002083144.39af89e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
         <20201002110205.35dfe0fb3299.If2afc69c480c29c3dfc7c373c9a8b45678939746@changeid>
         <20201002083144.39af89e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-02 at 08:31 -0700, Jakub Kicinski wrote:
> On Fri,  2 Oct 2020 11:09:40 +0200 Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Since moving the call to this to a dump start() handler we no
> > longer need this to deal with being called after having been
> > called already. Since that is the preferred way of doing things
> > anyway, remove the code necessary for that and simply return
> > the pointer (or an ERR_PTR()).
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> 
> > -	return netlink_policy_dump_start(op.policy, op.maxattr, &ctx->state);
> > +	ctx->state = netlink_policy_dump_start(op.policy, op.maxattr);
> > +	if (IS_ERR(ctx->state))
> > +		return PTR_ERR(ctx->state);
> > +	return 0;
> 
> PTR_ERR_OR_ZERO()?

Hah! I didn't even know about that, thanks.

johannes

