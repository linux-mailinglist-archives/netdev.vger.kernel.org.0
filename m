Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD7963E1B0
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 21:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiK3URY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 15:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiK3UQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 15:16:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E43689301;
        Wed, 30 Nov 2022 12:13:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04AD661DBE;
        Wed, 30 Nov 2022 20:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5979AC433D6;
        Wed, 30 Nov 2022 20:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669839180;
        bh=pyfET1ToAw3P7uNG+TwmmC/YKEAYeHY3LwFAqLPkGuY=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=s3ziu1MLDHz/XzIZoldakOWlQ63NfX8SLBbOxIRGytLtTq19KSXwavlc/JUtJoLCF
         /9mMILqTat0Cznb6OCtI0JPoYlSE2xOi0ha3Hp0eVrDjrlsgT4Es1sDAVoTr0Yp+7r
         ecBJvOoUfEGfJF3F3NfdKy/dBLC7lwgbE6hLFFgskzZx8A8X/CcFjHuZvekJSwuB0x
         oSnmGZdHOjx+O4I4PKCC21Thf0R54jtoHJmI8vBMJzERqlQ0sLk3ahBeCXX7fhcFAF
         Sda+3ql1w83Vp+hFMLBdSE1F4UBtp3fbvSAC479BtrKi7PO6HOjEPR+JF4/ZJGRNma
         FeRrBe0m7yvYw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id EEEED5C051C; Wed, 30 Nov 2022 12:12:59 -0800 (PST)
Date:   Wed, 30 Nov 2022 12:12:59 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH rcu 14/16] rxrpc: Use call_rcu_hurry() instead of
 call_rcu()
Message-ID: <20221130201259.GR4001@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <CAEXW_YS1nfsV_ohXDaB1i2em=+0KP1DofktS24oGFa4wPAbiiw@mail.gmail.com>
 <20221130181316.GA1012431@paulmck-ThinkPad-P17-Gen-1>
 <20221130181325.1012760-14-paulmck@kernel.org>
 <639433.1669835344@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <639433.1669835344@warthog.procyon.org.uk>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 07:09:04PM +0000, David Howells wrote:
> Note that this conflicts with my patch:
> 
> 	rxrpc: Don't hold a ref for connection workqueue
> 	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/commit/?h=rxrpc-next&id=450b00011290660127c2d76f5c5ed264126eb229
> 
> which should render it unnecessary.  It's a little ahead of yours in the
> net-next queue, if that means anything.

OK, I will drop this patch in favor of yours, thank you!

							Thanx, Paul
