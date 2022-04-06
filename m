Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A94F4F6CEF
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbiDFVjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238771AbiDFVjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:39:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB15913F4E
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 14:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Fe2w5yAndJYrhGy8BtB9U0rNAlMKrCaaTl3Fo1uVOlw=; b=RYcBc0hJbGY4+sSFjtSRjfzHGY
        gy3kuukQwJfxhCr8SkvnAEfUCEXmR2hE9emZuoolIZlUzwdl9LAIUDojhdd99N4cwdrBDRj8Nlc2h
        MFQCH4EM/Oikje8LA7n7jTZKat4z79WKDlarHDQm3FN3ipxlNJ3KcsOtkS5zsnZktMYWNR6n0hg1+
        9q/+QT12kZtL5z8EFAC+bRqOQKUO9SMvWUv/YNwOwyzVHrTNtoSpHhkxbfqjLvhFxANLREs4z6w4/
        AHZDLspPh/EWhLN8ewWCx78XK8xjBZGosOgjw1RiH38jzNfFF2MdmVhPokVeUBLwfMVxqhyASHTK1
        cMZgZhpw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ncD27-007z8m-C3; Wed, 06 Apr 2022 21:17:43 +0000
Date:   Wed, 6 Apr 2022 14:17:43 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
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
Message-ID: <Yk4Dd14KCgpqWgtg@bombadil.infradead.org>
References: <20220406124208.3485-1-xiangxia.m.yue@gmail.com>
 <Yk29yO53lSigIbml@bombadil.infradead.org>
 <20220406121611.1791499d@kernel.org>
 <Yk38ClhCaN5FnuDw@bombadil.infradead.org>
 <20220406140629.7cad841b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406140629.7cad841b@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 02:06:29PM -0700, Jakub Kicinski wrote:
> On Wed, 6 Apr 2022 13:46:02 -0700 Luis Chamberlain wrote:
> > > sysctl-next makes a lot of sense, but I'm worried about conflicts.  
> > 
> > I can try to deal with them as I can send the pull request to Linus towards
> > the end of the merge window.
> 
> Do you mean that your -next branch is unstable and can be rebased?

Yes as I had no need / many users other than to get testing done before I
send a pull requst to Linus. The other users are developers sending
random updates with the latest efforts to clean up kernel/sysctl.c and
these sorts of changes. But it would seem that should stop and I should
make it stable.

> Often people keep their -next branches stable, and then only Linus 
> can deal with the conflict (with linux-next's help).

I missed the v5.18 merge window and I hadn't rebased after Linus
released v5.18-rc1 and so I had to rebase now either way too.

> > > Would you be able to spin up a stable branch based on -rc1 so we
> > > can pull it into net-next as well?  
> > 
> > Yes, absolutely. Just pushed, but I should note that linux-next already
> > takes in sysctl-next. And there are non-networking changes that are
> > in sysctl-next. 
> 
> What I mean by a stable branch is a separate branch on top of -rc1 with
> just this patch/series, which we can pull into net-next and you can
> pull into sysctl-next. That way this change will appear with the same
> commit id in both trees and git will deal with it smoothly.

Ah yes, I hadn't needed to make sysctl-next stable but indeed it would
make sense given what you are indicating.
> 
> > Does net-next go to Linus or is it just to help with
> > developers so they get something more close to linux-next but not as
> > insane?
> 
> net-next goes to Linus and it's "stable" by which I mean no rebasing 
> or hard pushing.

I can commit to making sysctl-next to make this coordination easier. It
make sense.

  Luis
