Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE31C50EADD
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 22:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245157AbiDYU4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 16:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbiDYU4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 16:56:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F2E10F436;
        Mon, 25 Apr 2022 13:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dUPQYq2+oE4ZhEPnYgOuVlmUQz4e1ee8Qn7Tuawi6W4=; b=W+wp6p1JyYONZD4FeG/rz9dfZ1
        cGR8sUfgbGQzrNrTFig2Smuou15BjGavsmO82E00H4sQpQ1NrrOa5V9TFAMdYuzjDBJfyoPKKwrwY
        fYtBeQ+DejYaCbDnZg/+ER5YaVwi/bvxxhny3iBVUPXTo6fpqq3nYTkxhBHwsAKGXVKAK/0X5j0f3
        ocuaFOsUBEA3+d6zP8NT3+ASEZkwSMOFwun+dLFb1kFRgGfA808pQCtETmyu9adKitsJm9C6yj3gG
        qQ0G9VMVuq+Y78rGxr/XA5WjCu/Noyo4UGfDNa99WPVHr+d/p1apOQLgB4pctb/sjTacxoqSPeqI9
        8kC51tTQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nj5iH-00BP9x-Rp; Mon, 25 Apr 2022 20:53:41 +0000
Date:   Mon, 25 Apr 2022 13:53:41 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: Re: [net-next v4 0/3] use standard sysctl macro
Message-ID: <YmcKVYMLKHBQjLAK@bombadil.infradead.org>
References: <20220422070141.39397-1-xiangxia.m.yue@gmail.com>
 <YmK/PM2x5PTG2b+c@bombadil.infradead.org>
 <20220422124340.2382da79@kernel.org>
 <Ymb6ukQNDh6VBT59@bombadil.infradead.org>
 <20220425125644.52e3aad4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425125644.52e3aad4@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 12:56:44PM -0700, Jakub Kicinski wrote:
> On Mon, 25 Apr 2022 12:47:06 -0700 Luis Chamberlain wrote:
> > I have a better option. I checked to see the diff stat between
> > the proposed patch to see what the chances of a conflict are
> > and so far I don't see any conflict so I think this patchset
> > should just go through your tree.
> > 
> > So feel free to take it in! Let me know if that's OK!
> 
> Ok, assuming the netfilter and bpf patches I saw were the only other
> conversions we can resolve the conflicts before code reaches Linus...

Sure thing.

  Luis
