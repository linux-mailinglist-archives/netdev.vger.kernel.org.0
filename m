Return-Path: <netdev+bounces-2904-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C7B7047C1
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:27:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 414261C208DE
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B44E20980;
	Tue, 16 May 2023 08:27:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0B21F94F
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:27:14 +0000 (UTC)
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD5C4696
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:27:12 -0700 (PDT)
Received: from mail-auth.avm.de (unknown [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 16 May 2023 10:27:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1684225630; bh=Tyjh52SJUtEZHmo/Wzy9QwV/tPNvfbDEEm6u+11MU2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LDkJ7udFpSJqnmgyawPTu++RK58Dl96gSGRBixHmhsVKfvnHypuCY49oKafaf9wBR
	 0O7JcG68AGzGJRBtNNQJMp9ztVtukmHHInGGSqNszId8LOWAHNevaI+d7ma03tfuYt
	 TDPTnk4Z8vP3CKhzMEhaqzsgJc/1V7twHeObB59k=
Received: from localhost (unknown [172.17.88.63])
	by mail-auth.avm.de (Postfix) with ESMTPSA id 5065F8210B;
	Tue, 16 May 2023 10:27:10 +0200 (CEST)
Date: Tue, 16 May 2023 10:27:10 +0200
From: Johannes Nixdorf <jnixdorf-oss@avm.de>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next 2/2] bridge: Add a sysctl to limit new brides
 FDB entries
Message-ID: <ZGM-Xv8sRmeePiGL@u-jnixdorf.ads.avm.de>
References: <20230515085046.4457-1-jnixdorf-oss@avm.de>
 <20230515085046.4457-2-jnixdorf-oss@avm.de>
 <20230515085627.5897dab1@hermes.local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515085627.5897dab1@hermes.local>
X-purgate-ID: 149429::1684225630-BC4657B1-D066D2A4/0/0
X-purgate-type: clean
X-purgate-size: 1286
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 08:56:27AM -0700, Stephen Hemminger wrote:
> On Mon, 15 May 2023 10:50:46 +0200
> Johannes Nixdorf <jnixdorf-oss@avm.de> wrote:
> 
> > +static struct ctl_table br_sysctl_table[] = {
> > +	{
> > +		.procname     = "bridge-fdb-max-entries-default",
> 
> 
> That name is too long.
> 
> Also, all the rest of bridge code does not use sysctl's.

The code in net/bridge/br_netfilter_hooks.c also uses sysctls, which is
where I took inspiration for the approach for setting them up, and also
the naming scheme.

> Why is this special and why should the property be global and not per bridge?

As explained in the commit message and [1] it is a global default
setting. It makes no sense to make it per bridge, as there is already
a per bridge netlink setting that overrides it. The only alternative
option is to not have it at all, which is what I will be going to do
with a v2.

> NAK

Fair enough. I took it out in my pending-v2-state of the series, but
would welcome some input on whether you see any value in the proposed
alternatives in [1], or are strictly against having a global default !=
0 here at all.

[1]: https://lore.kernel.org/netdev/20230515085046.4457-1-jnixdorf-oss@avm.de/T/#ma4145398516bfd39dfa09976b7892f5fdb76f8c0

