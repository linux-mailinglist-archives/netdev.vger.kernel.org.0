Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1FC85A8155
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiHaPfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbiHaPfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:35:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6786F45063;
        Wed, 31 Aug 2022 08:35:10 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oTPkC-0004IO-K5; Wed, 31 Aug 2022 17:35:08 +0200
Date:   Wed, 31 Aug 2022 17:35:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
Message-ID: <20220831153508.GB15107@breakpoint.cc>
References: <20220831101617.22329-1-fw@strlen.de>
 <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc>
 <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc>
 <87ilm84goh.fsf@toke.dk>
 <Yw95m0mcPeE68fRJ@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw95m0mcPeE68fRJ@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > asking the kernel to store an additional label with the program rule?
> 
> @Florian, could you probably use the object infrastructure to refer to
> the program?

Yes, I would like to extend objref infra later once this is accepted.

> This might also allow you to refer to this new object type from
> nf_tables maps.

Yes, but first nft needs to be able to construct some meaningful output
again.  If we don't attach a specific label (such as filename), we need
to be able to reconstruct info based on what we can query via id/tag and
bpf syscall.

objref infra doesn't help here unless we'll force something like
'nft-defined-objref-name-must-match-elf-binary-name', and I find that
terrible.

> It would be good to avoid linear rule-based matching to select what
> program to run.

Hmmm, I did not consider it a huge deal, its an ebpf program so
users can dispatch to another program.

Objref is nice if the program to run should be selected from a criterion that isn't
readily available to a sk_filter program though.
