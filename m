Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF3F5714DA
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 10:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbiGLIkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 04:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbiGLIkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 04:40:13 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80FD3A5E4D;
        Tue, 12 Jul 2022 01:40:08 -0700 (PDT)
Date:   Tue, 12 Jul 2022 10:40:04 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] netfilter: xt_TPROXY: fix clang -Wformat warnings:
Message-ID: <Ys0zZACWwGilTwHx@salvia>
References: <20220707191745.840590-1-justinstitt@google.com>
 <YsvniilEnfUOd+yk@salvia>
 <CAFhGd8qDwoWLTJEGtap3s2_+AOLdnSg57DO8VgoMrqDtcFY7qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFhGd8qDwoWLTJEGtap3s2_+AOLdnSg57DO8VgoMrqDtcFY7qQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 12:44:05PM -0700, Justin Stitt wrote:
> On Mon, Jul 11, 2022 at 2:04 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Thu, Jul 07, 2022 at 12:17:45PM -0700, Justin Stitt wrote:
> > > diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
> > > index 459d0696c91a..5d74abffc94f 100644
> > > --- a/net/netfilter/xt_TPROXY.c
> > > +++ b/net/netfilter/xt_TPROXY.c
> > > @@ -169,7 +169,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
> > >                  targets on the same rule yet */
> > >               skb->mark = (skb->mark & ~tgi->mark_mask) ^ tgi->mark_value;
> > >
> > > -             pr_debug("redirecting: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
> > > +             pr_debug("redirecting: proto %d %pI6:%hu -> %pI6:%hu, mark: %x\n",
> > >                        tproto, &iph->saddr, ntohs(hp->source),
> > >                        laddr, ntohs(lport), skb->mark);
> > >
> > > @@ -177,7 +177,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
> > >               return NF_ACCEPT;
> > >       }
> > >
> > > -     pr_debug("no socket, dropping: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
> > > +     pr_debug("no socket, dropping: proto %d %pI6:%hu -> %pI6:%hu, mark: %x\n",
> > >                tproto, &iph->saddr, ntohs(hp->source),
> > >                &iph->daddr, ntohs(hp->dest), skb->mark);
> >
> > Could you instead send a patch to remove these pr_debug calls?
>
> Do you mean all Instances of pr_debug in `xt_TPROXY.c` (of which there
> are six) or just these two specific cases @ +169 and +177.

Yes, remove all pr_debug instances, thanks.
