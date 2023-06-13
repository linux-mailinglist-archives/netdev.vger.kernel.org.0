Return-Path: <netdev+bounces-10383-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F069B72E3B0
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:03:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB35E281015
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D87DE15AFB;
	Tue, 13 Jun 2023 13:03:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E1A12B77
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 13:03:12 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793531BCD;
	Tue, 13 Jun 2023 06:02:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1q93fX-0000Gp-MM; Tue, 13 Jun 2023 15:02:43 +0200
Date: Tue, 13 Jun 2023 15:02:43 +0200
From: Florian Westphal <fw@strlen.de>
To: Paul Blakey <paulb@nvidia.com>
Cc: Vlad Buslov <vladbu@nvidia.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
	Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net 1/1] net/sched: act_ct: Fix promotion of offloaded
 unreplied tuple
Message-ID: <ZIho89roQv3NsQ47@strlen.de>
References: <1686313379-117663-1-git-send-email-paulb@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1686313379-117663-1-git-send-email-paulb@nvidia.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Paul Blakey <paulb@nvidia.com> wrote:
> Currently UNREPLIED and UNASSURED connections are added to the nf flow
> table. This causes the following connection packets to be processed
> by the flow table which then skips conntrack_in(), and thus such the
> connections will remain UNREPLIED and UNASSURED even if reply traffic
> is then seen. Even still, the unoffloaded reply packets are the ones
> triggering hardware update from new to established state, and if
> there aren't any to triger an update and/or previous update was
> missed, hardware can get out of sync with sw and still mark
> packets as new.

Reviewed-by: Florian Westphal <fw@strlen.de>

