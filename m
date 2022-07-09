Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EECA56C58D
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 03:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiGIBB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 21:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGIBB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 21:01:28 -0400
Received: from smtp.gentoo.org (woodpecker.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F3A725A1;
        Fri,  8 Jul 2022 18:01:27 -0700 (PDT)
Date:   Sat, 9 Jul 2022 09:01:10 +0800
From:   Yixun Lan <dlan@gentoo.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] RISC-V/bpf: Enable bpf_probe_read{, str}()
Message-ID: <YsjTVvyqdVGy1uYZ@ofant>
References: <20220703130924.57240-1-dlan@gentoo.org>
 <YsKAZUJRo5cjtZ3n@infradead.org>
 <CAEf4BzbCswMd6KU7f9SEU6xHBBPu_rTL5f+KE0OkYj63e-h-bA@mail.gmail.com>
 <712c8fac-6784-2acd-66ca-d1fd393aef23@fb.com>
 <YsUzX2IeNb/u9VmN@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsUzX2IeNb/u9VmN@infradead.org>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph, YongHong

On 00:01 Wed 06 Jul     , Christoph Hellwig wrote:
> On Tue, Jul 05, 2022 at 11:41:30PM -0700, Yonghong Song wrote:
> > 
> > 
> > On 7/5/22 10:00 PM, Andrii Nakryiko wrote:
> > > On Sun, Jul 3, 2022 at 10:53 PM Christoph Hellwig <hch@infradead.org> wrote:
> > > > 
> > > > On Sun, Jul 03, 2022 at 09:09:24PM +0800, Yixun Lan wrote:
> > > > > Enable this option to fix a bcc error in RISC-V platform
> > > > > 
> > > > > And, the error shows as follows:
> > > > 
> > > > These should not be enabled on new platforms.  Use the proper helpers
> > > > to probe kernel vs user pointers instead.
> > > 
> > > riscv existed as of [0], so I'd argue it is a proper bug fix, as
> > > corresponding select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE should
> > > have been added back then.
> > > 
> > > But I also agree that BCC tools should be updated to use proper
> > > bpf_probe_read_{kernel,user}[_str()] helpers, please contribute such
> > > fixes to BCC tools and BCC itself as well. Cc'ed Alan as his ksnoop in
> > > libbpf-tools seems to be using bpf_probe_read() as well and needs to
> > > be fixed.
> > 
> > Yixun, the bcc change looks like below:
> 
> No, this is broken.  bcc needs to stop using bpf_probe_read entirely
> for user addresses and unconditionally use bpf_probe_read_user first
> and only fall back to bpf_probe_read if not supported.
I agree with Christoph, there is something in the bcc tools that
need to adjust in order to use new bpf_probe_read_{kernel,user}

Please check the ongoing discussion [0] in the bcc tools if you're
interested in, advice and comments are welcome

[0] https://github.com/iovisor/bcc/pull/4085#issuecomment-1179446738

-- 
Yixun Lan (dlan)
Gentoo Linux Developer
GPG Key ID AABEFD55
