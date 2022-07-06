Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDB0568440
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 11:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbiGFJwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 05:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbiGFJwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 05:52:31 -0400
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA0A24BE6
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 02:52:13 -0700 (PDT)
Received: from equinox by eidolon.nox.tf with local (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1o91hZ-001fsb-9P; Wed, 06 Jul 2022 11:52:09 +0200
Date:   Wed, 6 Jul 2022 11:52:09 +0200
From:   David Lamparter <equinox@diac24.net>
To:     Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: ip6mr: add RTM_GETROUTE netlink op
Message-ID: <YsVbSYGYtrAv+FY3@eidolon.nox.tf>
References: <e41a3aba-ae19-9713-0d41-bd7287fdfc43@blackwall.org>
 <20220704105223.395359-1-equinox@diac24.net>
 <20220704195011.0af1dbab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704195011.0af1dbab@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 07:50:11PM -0700, Jakub Kicinski wrote:
> On Mon,  4 Jul 2022 12:52:23 +0200 David Lamparter wrote:
> > +const struct nla_policy rtm_ipv6_mr_policy[RTA_MAX + 1] = {
> > +	[RTA_SRC]		= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
> > +	[RTA_DST]		= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
> > +	[RTA_TABLE]		= { .type = NLA_U32 },
> > +};
> 
> net/ipv6/ip6mr.c:2515:25: warning: symbol 'rtm_ipv6_mr_policy' was not declared. Should it be static?

As the great poet of our time, Homer Simpson, would say:  "d'oh"

After thinking about it for a bit more, I agree with Nikolay that the
policy shouldn't be reused, so apart from adding the "static" here I'll
also rename it to clarify it's the RTM_GETROUTE policy.


-equi/David
