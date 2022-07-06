Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32BD568EB5
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbiGFQLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbiGFQLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:11:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FFC26AF3;
        Wed,  6 Jul 2022 09:11:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEA79612C5;
        Wed,  6 Jul 2022 16:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B206CC3411C;
        Wed,  6 Jul 2022 16:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657123895;
        bh=oVr93BpxNpu1BAKASsj86szhtwhDGgfUv5IjX/G4dqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qfGJ+ojOMjfnyXRjzRBVHODbpUa24TQvwCjS8k1I3482njdi242j7o0OaM2awwPqq
         fiqef44vCU21sVlCDF2AbEBM0vGx9LgKofSzS42OO5vGfsDcNgyKYG+QNFJ6yMWBl6
         j3ZPXQXJ1FAnV//XGv1ZEb1Xb9v78TrnoMDVS4mvB8MNTSJ7ZYtRhLUsaBHMKr1GrR
         f8T4sj8x/Sf5/135eSKteIaD1qmX1/VGpO4VHQ72TxlCfVOyc2Cfw2BS6GPD9oT4IG
         UMisyC1I2ChSOZD16jYOE/04P++2rlDupjMeW8OyqtWuuzZ5y3TlcNmRgOC6ce5AcX
         PwEypWf+G1omg==
Date:   Wed, 6 Jul 2022 17:11:25 +0100
From:   Will Deacon <will@kernel.org>
To:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Xu Kuohai <xukuohai@huawei.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <James.Morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>
Subject: Re: [PATCH bpf-next v6 0/4] bpf trampoline for arm64
Message-ID: <20220706161125.GB3204@willie-the-truck>
References: <20220625161255.547944-1-xukuohai@huawei.com>
 <d3c1f1ed-353a-6af2-140d-c7051125d023@iogearbox.net>
 <20220705160045.GA1240@willie-the-truck>
 <YsWzfPUmgtRZi/ny@myrica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsWzfPUmgtRZi/ny@myrica>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 05:08:49PM +0100, Jean-Philippe Brucker wrote:
> On Tue, Jul 05, 2022 at 05:00:46PM +0100, Will Deacon wrote:
> > > Given you've been taking a look and had objections in v5, would be great if
> > you
> > > can find some cycles for this v6.
> > 
> > Mark's out at the moment, so I wouldn't hold this series up pending his ack.
> > However, I agree that it would be good if _somebody_ from the Arm side can
> > give it the once over, so I've added Jean-Philippe to cc in case he has time
> > for a quick review.
> 
> I'll take a look. Sorry for not catching this earlier, all versions of the
> series somehow ended up in my spams :/

Yeah, same here. It was only Daniel's mail that hit my inbox!

Will
