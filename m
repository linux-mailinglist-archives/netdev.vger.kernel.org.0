Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE24327EEC7
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731074AbgI3QSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728744AbgI3QSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:18:05 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A72C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 09:18:04 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNenp-00DrCs-DH; Wed, 30 Sep 2020 18:18:01 +0200
Message-ID: <a772c03bfbc8cf8230df631fe2db6f2dd7b96a2a.camel@sipsolutions.net>
Subject: Re: Genetlink per cmd policies
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Michal Kubecek <mkubecek@suse.cz>, dsahern@kernel.org,
        pablo@netfilter.org
Cc:     netdev@vger.kernel.org
Date:   Wed, 30 Sep 2020 18:17:47 +0200
In-Reply-To: <fce613c2b4c797de4be413afddf872fd6dae9ef8.camel@sipsolutions.net>
References: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <fce613c2b4c797de4be413afddf872fd6dae9ef8.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 18:06 +0200, Johannes Berg wrote:
> 
> That's the historic info I guess - I'll take a look at ethtool later and
> see what it's doing there.

Oh, ok, I see how that works ... you *do* have a sort of common/aliased
attribute inside each per-op family that then carries common sub-
attributes. That can be linked into the policy.

I guess that's not a bad idea. I'd still prefer not to add
maxattr/policy into the ops struct because like I said, that's a large
amount of wasted space?

Perhaps then a "struct nla_policy *get_policy(int cmd, int *maxattr)"
function (method) could work, and fall back to just "->policy" and"-
>maxattr" if unset, and then you'd just have to write a few lines of
code for this case? Seems like overall that'd still be smaller than
putting the pointer/maxattr into each and every op struct.

johannes

