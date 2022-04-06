Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1D74F6CEB
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236483AbiDFVjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbiDFViw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:38:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92122DE7
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 14:06:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE8ADB824E1
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 21:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4597C385A1;
        Wed,  6 Apr 2022 21:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649279191;
        bh=XHOhwkDIIzp0VA+nTmVzZn0qZHv0E9t9rp51E4K6LA0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I5bOZb/ZZ52DG8xu6AClu+5+h9RQDDOgFN1RdnhPUC1dD3alMgKLTbrP2Y9lVxuPN
         Wh9DdsWmF3DrkHAZrSRDUEvk4icvcjNMZicJo54L+lRaNASqXtHOQzZUdJH+FaC+qZ
         sYNX5ENbNRrhywcL2ZprL8Jq6ERVClPsHAf47Z5RJm9QVaZpk0pjLK9XzuturlyjqL
         wLxK1UW9e3/TysAEeUpHjGKuRrLbdPvWdqRrz3BF6OfwEdMzbuwPVRtA+U8jbacian
         66pLuBbjjHkaMxSeEoSj1o/qtZtO/x5PWFQwkgI9Skso30d0GMRV75ft3sAKBUZjct
         tWXLSStXqoISQ==
Date:   Wed, 6 Apr 2022 14:06:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: Re: [net-next RESEND v2] net: core: use shared sysctl macro
Message-ID: <20220406140629.7cad841b@kernel.org>
In-Reply-To: <Yk38ClhCaN5FnuDw@bombadil.infradead.org>
References: <20220406124208.3485-1-xiangxia.m.yue@gmail.com>
        <Yk29yO53lSigIbml@bombadil.infradead.org>
        <20220406121611.1791499d@kernel.org>
        <Yk38ClhCaN5FnuDw@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Apr 2022 13:46:02 -0700 Luis Chamberlain wrote:
> > sysctl-next makes a lot of sense, but I'm worried about conflicts.  
> 
> I can try to deal with them as I can send the pull request to Linus towards
> the end of the merge window.

Do you mean that your -next branch is unstable and can be rebased?
Often people keep their -next branches stable, and then only Linus 
can deal with the conflict (with linux-next's help).

> > Would you be able to spin up a stable branch based on -rc1 so we
> > can pull it into net-next as well?  
> 
> Yes, absolutely. Just pushed, but I should note that linux-next already
> takes in sysctl-next. And there are non-networking changes that are
> in sysctl-next. 

What I mean by a stable branch is a separate branch on top of -rc1 with
just this patch/series, which we can pull into net-next and you can
pull into sysctl-next. That way this change will appear with the same
commit id in both trees and git will deal with it smoothly.

> Does net-next go to Linus or is it just to help with
> developers so they get something more close to linux-next but not as
> insane?

net-next goes to Linus and it's "stable" by which I mean no rebasing 
or hard pushing.
