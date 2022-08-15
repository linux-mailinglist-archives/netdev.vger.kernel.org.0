Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24042594EA2
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbiHPCZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiHPCZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:25:21 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2469726924E;
        Mon, 15 Aug 2022 15:40:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oNikl-00032W-FD; Tue, 16 Aug 2022 00:40:11 +0200
Date:   Tue, 16 Aug 2022 00:40:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>
Cc:     Daniel Xu <dxu@dxuuu.xyz>, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com,
        pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/3] bpf: Add support for writing to nf_conn:mark
Message-ID: <20220815224011.GA9821@breakpoint.cc>
References: <cover.1660592020.git.dxu@dxuuu.xyz>
 <f850bb7e20950736d9175c61d7e0691098e06182.1660592020.git.dxu@dxuuu.xyz>
 <871qth87r1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <871qth87r1.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke Høiland-Jørgensen <toke@kernel.org> wrote:
> > Support direct writes to nf_conn:mark from TC and XDP prog types. This
> > is useful when applications want to store per-connection metadata. This
> > is also particularly useful for applications that run both bpf and
> > iptables/nftables because the latter can trivially access this metadata.
> >
> > One example use case would be if a bpf prog is responsible for advanced
> > packet classification and iptables/nftables is later used for routing
> > due to pre-existing/legacy code.
> >
> > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> 
> Didn't we agree the last time around that all field access should be
> using helper kfuncs instead of allowing direct writes to struct nf_conn?

I don't see why ct->mark needs special handling.

It might be possible we need to change accesses on nf/tc side to use
READ/WRITE_ONCE though.
