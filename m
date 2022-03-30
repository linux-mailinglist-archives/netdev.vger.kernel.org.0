Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6049B4EB820
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 04:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240656AbiC3CD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 22:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235508AbiC3CD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 22:03:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E70DB820C;
        Tue, 29 Mar 2022 19:02:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEE3BB81AD3;
        Wed, 30 Mar 2022 02:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E7BC340ED;
        Wed, 30 Mar 2022 02:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648605730;
        bh=rGnBzT+BwzzUK/UCih6GBAbUNSYzQWhQaxlcJYy4cMo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iB69ic/x+0aCRhI/bCnd5qh97PifIo5VQe+T/ARb0od8skzLLHbrXa2nPOzmjO+ly
         ql/umh/bqJrbxJhax17K3HGCFx15MNQFWoKTODkvefTlQcBBpPByx6uAAOtt/i1i4E
         7Vn0/q0VasX2dJ63xwDt6TUmJvob2cjIWa7ys8joWsbbZayxcPYNsgVC2WCAL0yjCJ
         itqaJskIx8dfNFYuyK1tiWWS4+d202ka0RVlZBaRbb8DptHZzaZcz1RdRmq9QviVHe
         TxLS/k5oDCK/hl/nX7GHR4/JJFollBBkMRSRLTe1hCbU9ITwyIRYDNXQcb0J7i7HK9
         yZvj507y7j2SA==
Date:   Tue, 29 Mar 2022 19:02:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: pull-request: bpf 2022-03-29
Message-ID: <20220329190208.3ef9a045@kernel.org>
In-Reply-To: <CAADnVQJNS_U97aqaNxtAhuvZCK6oiDA-tDoAEyDMYnCBbfaZkg@mail.gmail.com>
References: <20220329234924.39053-1-alexei.starovoitov@gmail.com>
        <20220329184123.59cfad63@kernel.org>
        <CAADnVQJNS_U97aqaNxtAhuvZCK6oiDA-tDoAEyDMYnCBbfaZkg@mail.gmail.com>
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

On Tue, 29 Mar 2022 18:51:22 -0700 Alexei Starovoitov wrote:
> On Tue, Mar 29, 2022 at 6:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 29 Mar 2022 16:49:24 -0700 Alexei Starovoitov wrote:  
> > > Hi David, hi Jakub,
> > >
> > > The following pull-request contains BPF updates for your *net* tree.
> > >
> > > We've added 16 non-merge commits during the last 1 day(s) which contain
> > > a total of 24 files changed, 354 insertions(+), 187 deletions(-).
> > >
> > > The main changes are:
> > >
> > > 1) x86 specific bits of fprobe/rethook, from Masami and Peter.
> > >
> > > 2) ice/xsk fixes, from Maciej and Magnus.
> > >
> > > 3) Various small fixes, from Andrii, Yonghong, Geliang and others.  
> >
> > There are some new sparse warnings here that look semi-legit.
> > As in harmless but not erroneous.  
> 
> Both are new warnings and not due to these patches, right?

Erm, you're right. No idea how the build bot can generate a warning
that's present on both source and target branch :S I'll look into 
that while the my local build runs...
