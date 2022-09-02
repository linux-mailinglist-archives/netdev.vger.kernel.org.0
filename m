Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC555AB5BA
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 17:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237428AbiIBPwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 11:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237430AbiIBPwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 11:52:24 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7B0D3E6C
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 08:44:32 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id F0BE3240108
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 17:44:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1662133471; bh=smFYOenZzqawXSK94gpzdplWB4M1WgA4Yl+z23nc79E=;
        h=Date:From:To:Cc:Subject:From;
        b=GTYY0grDsPF04pgNJyGL+9R+6v9+CxNjj+M60rU4hAW3WTG2JEEZCKMIjJLzRwK72
         pyck59j5Upgxolb9Cik4fTVJmw78XBK90wsScHgbw5nBZx8+//DWribRhtHA2Q/5Xv
         E2U0d5dtq8jj6FHduIJAHJ7D0rVeCopFqa0fRZpdAsGn234fP5qnIk+X9lQhm6CdMk
         MY5PM2pTz6TXLVGhB6Yv+0lNZaMrGqRjjQxl53BEnnlFqBSAqZlxjqJX9oVmjBlA3c
         NyEGCgi0i5HPy2//5s4iyb+zuhdmW5Dey7FpgS4eceMBjkXcXhJGexNlIhzaxd7oK0
         Qy/V4nFkCZuHg==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4MK2K42hXXz6tmJ;
        Fri,  2 Sep 2022 17:44:24 +0200 (CEST)
Date:   Fri,  2 Sep 2022 15:44:20 +0000
From:   Daniel =?utf-8?Q?M=C3=BCller?= <deso@posteo.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, brouer@redhat.com,
        toke@redhat.com, memxor@gmail.com
Subject: Re: [PATCH bpf-next 0/4] Introduce bpf_ct_set_nat_info kfunc helper
Message-ID: <20220902154420.wpox77fwlamul444@nuc>
References: <cover.1662050126.git.lorenzo@kernel.org>
 <aec3e8d1-6b80-c344-febe-809bbb0308eb@iogearbox.net>
 <YxIUvxY8S256TTUf@lore-desk>
 <df144f34-b44c-cc96-69eb-32eaaf1ac1fb@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df144f34-b44c-cc96-69eb-32eaaf1ac1fb@iogearbox.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 02, 2022 at 04:41:28PM +0200, Daniel Borkmann wrote:
> On 9/2/22 4:35 PM, Lorenzo Bianconi wrote:
> > On Sep 02, Daniel Borkmann wrote:
> > > On 9/1/22 6:43 PM, Lorenzo Bianconi wrote:
> > > > Introduce bpf_ct_set_nat_info kfunc helper in order to set source and
> > > > destination nat addresses/ports in a new allocated ct entry not inserted
> > > > in the connection tracking table yet.
> > > > Introduce support for per-parameter trusted args.
> > > > 
> > > > Kumar Kartikeya Dwivedi (2):
> > > >     bpf: Add support for per-parameter trusted args
> > > >     selftests/bpf: Extend KF_TRUSTED_ARGS test for __ref annotation
> > > > 
> > > > Lorenzo Bianconi (2):
> > > >     net: netfilter: add bpf_ct_set_nat_info kfunc helper
> > > >     selftests/bpf: add tests for bpf_ct_set_nat_info kfunc
> > > > 
> > > >    Documentation/bpf/kfuncs.rst                  | 18 +++++++
> > > >    kernel/bpf/btf.c                              | 39 ++++++++++-----
> > > >    net/bpf/test_run.c                            |  9 +++-
> > > >    net/netfilter/nf_conntrack_bpf.c              | 49 ++++++++++++++++++-
> > > >    .../testing/selftests/bpf/prog_tests/bpf_nf.c |  2 +
> > > >    .../testing/selftests/bpf/progs/test_bpf_nf.c | 26 +++++++++-
> > > >    tools/testing/selftests/bpf/verifier/calls.c  | 38 +++++++++++---
> > > >    7 files changed, 156 insertions(+), 25 deletions(-)
> > > > 
> > > 
> > > Looks like this fails BPF CI, ptal:
> > > 
> > > https://github.com/kernel-patches/bpf/runs/8147936670?check_suite_focus=true
> > 
> > Hi Daniel,
> > 
> > it seems CONFIG_NF_NAT is not set in the kernel config file.
> > Am I supposed to enable it in bpf-next/tools/testing/selftests/bpf/config?
> 
> This would have to be set there and added to the patches, yes. @Andrii/DanielM, is
> this enough or are other steps needed on top of that?

Yes, I think it should be set at said location. Nothing else should be
needed in addition that I can think of.

Thanks,
Daniel

[...]
