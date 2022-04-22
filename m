Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7AD50C109
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 23:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiDVVYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 17:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiDVVYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 17:24:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1780A19B679;
        Fri, 22 Apr 2022 13:19:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7AF3B82D82;
        Fri, 22 Apr 2022 19:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5742DC385A4;
        Fri, 22 Apr 2022 19:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650656622;
        bh=WwVgQvu+crgB9HWT96pNSkuqAaHtEF5wwt64I5ZCnQI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ClQa3D6Vnh9fu4wV/O1TPl+OpU5hlF9x7zszhiMicEwfT9TYmVwGYPussos77rXVg
         yXo9MCJELP12lmr9cAQE91TCh6P1XaaQTbIRB1PMQRD/kQgckHuYC64vNy4Hu1P1vn
         uPhMBbnEve+cF6on3HVzLwjrclVsFnQttPvl6u/7Hb55TgrAqnNJgxmpqQCOykOalC
         ydvclZKDWmPSDV39imxynV7FUa+OhF6JRZwL10LSjRfmQsFO8JNSVrdvI63+x4yZ0z
         AGGDvdsh58K5AszSf9xYbbh9e37Ao7I38r4RqoGN1PO5Wi0+2kjcPO8a5+gP5/QPMl
         9VC1Re8bc41hQ==
Date:   Fri, 22 Apr 2022 12:43:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
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
Message-ID: <20220422124340.2382da79@kernel.org>
In-Reply-To: <YmK/PM2x5PTG2b+c@bombadil.infradead.org>
References: <20220422070141.39397-1-xiangxia.m.yue@gmail.com>
        <YmK/PM2x5PTG2b+c@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Apr 2022 07:44:12 -0700 Luis Chamberlain wrote:
> On Fri, Apr 22, 2022 at 03:01:38PM +0800, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > 
> > This patchset introduce sysctl macro or replace var
> > with macro.
> > 
> > Tonghao Zhang (3):
> >   net: sysctl: use shared sysctl macro
> >   net: sysctl: introduce sysctl SYSCTL_THREE
> >   selftests/sysctl: add sysctl macro test  
> 
> I see these are based on net-next, to avoid conflicts with
> sysctl development this may be best based on sysctl-next
> though. Jakub?

I guess the base should be whatever we are going to use as
a base for a branch, the branch we can both pull in?

How many patches like that do you see flying around, tho?
I feel like I've seen at least 3 - netfilter, net core and bpf.
It's starting to feel like we should have one patch that adds all 
the constants and self test, put that in a branch anyone can pull in,
and then do the conversions in separate patches..

Option number two - rename the statics in the subsystems to SYSCTL_x,
and we can do a much smaller cleanup in the next cycle which would
replace those with a centralized instances? That should have minimal
chance of conflicts so no need to do special branches.

Option number three defer all this until the merge window.
