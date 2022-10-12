Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0E25FCE30
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 00:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiJLWL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 18:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiJLWLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 18:11:03 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E78C36851;
        Wed, 12 Oct 2022 15:09:57 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 034235C00A7;
        Wed, 12 Oct 2022 18:09:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 Oct 2022 18:09:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1665612592; x=1665698992; bh=0leQkUAZUI
        5cucdkNBVhjMl36k1QA7DeTpC2Onp0f+w=; b=UnTUc1kk2NAEPqvpO9VxiKjZEG
        87qKksTdiQL01NHDiQKMD9YUibH9qqJFMF1grFOeUW+8A7vUHd6uMKdNgf1Remnp
        zMvsNI5Wa7h0NUwJI7Fzes2c2fYThI8zCWAFxaZib/AhXmOojIloz91PrlywjJea
        tM6PC+soY1czngRifzgrqIL4J9/20GV65L1v0IEe1cVuDwfoxpr8ITR/+imX2yPl
        ouTZJ0MuDqhtGSjOWsu6uWaV6jkl4OK+uLbmWOd9icV05XDnjINv57uG7uJxa6wb
        eV050lNwSc1KVxRy9nDuv10yT/n/QB3U/NrteeP0mbOQPvv4px7Cmh5VjXHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1665612592; x=1665698992; bh=0leQkUAZUI5cucdkNBVhjMl36k1Q
        A7DeTpC2Onp0f+w=; b=ah1xWjviASU9PJqysetmOvV2VFbUt/UTVJCFlS5i9Afc
        CFiSc557m8MxCe4jDKTEZtencrE9aA0gKgTqWKDStiVlz+x893H7Lofx8bM/tYdf
        sIQuZkM0ZL5sQA+yDCpc1jjc11eV95B50/LVK2IVjFfU+EJ9uxT/m+Nyl9TZMikC
        Q46ZKEJnRBai+fge4Xbs+juC84Iz7TWkWlDTznnGlbMwoHTwSfclDy+vR2pvt4i6
        yEPXP3VzV2HMRidHjsvSwgBQdTsMSB6WIsYm29LWzpXvcBr7l5RcNVZ0kRb0wdld
        RT5AQVPbYCJOHpX37jFvE8VvknxItkrWRV6gcrTgeQ==
X-ME-Sender: <xms:MDtHYyZ5qBqV__E8_aIu4Fj7NOyxZ-g_HqY-1m5s0gKYZOmogYu1kQ>
    <xme:MDtHY1bVkaG4YuqMJco2lCnnesGNWvoMzA34bCNi-31vgYBHibsofhWhm6O601XjL
    4-Ezu4CMKp04vmIvg>
X-ME-Received: <xmr:MDtHY89xawe8c5Nqr9I3U9hYGnMbplA3LNSvErk66KS1Q76xrKh70Lj42rYWpdNphRR0cBfO9XALq-ng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeejledgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdlfeehmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdertddt
    tddvnecuhfhrohhmpeffrghnihgvlhcuighuuceougiguhesugiguhhuuhdrgiihiieqne
    cuggftrfgrthhtvghrnhepffffvdefhfduhfefjeejvdeiudeigfdvgffhjeekheeuuefh
    vdeifedtuefgfffhnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdig
    hiii
X-ME-Proxy: <xmx:MDtHY0rbtmKfFq-VewpkLXdqQIp74ZcCyQzSUvds1LIxSqvuul-sYA>
    <xmx:MDtHY9qeW-Hel7F2VQp3QB8bDlVMllIvJ7zXGDbzL53q32Pwa-7SAA>
    <xmx:MDtHYyQbmUIbBvlCIiOS22WU6OflwCKf1XbFVJ7f_nYXY6s3_9Vv2Q>
    <xmx:MDtHY41iwbi_fWwJGEPrfvpF1kM-Ats0D4QtIGMtS7Vy0Pr9WpP3Mw>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Oct 2022 18:09:51 -0400 (EDT)
Date:   Wed, 12 Oct 2022 16:09:53 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        bpf@vger.kernel.org, memxor@gmail.com
Subject: Re: [PATCH bpf-next v4 2/3] selftests/bpf: Add connmark read test
Message-ID: <20221012220953.i2xevhu36kxyxscl@k2>
References: <cover.1660254747.git.dxu@dxuuu.xyz>
 <d3bc620a491e4c626c20d80631063922cbe13e2b.1660254747.git.dxu@dxuuu.xyz>
 <43bf4a5f-dac9-4fe9-1eba-9ab9beb650aa@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43bf4a5f-dac9-4fe9-1eba-9ab9beb650aa@linux.dev>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On Tue, Oct 11, 2022 at 10:49:32PM -0700, Martin KaFai Lau wrote:
> On 8/11/22 2:55 PM, Daniel Xu wrote:
> > Test that the prog can read from the connection mark. This test is nice
> > because it ensures progs can interact with netfilter subsystem
> > correctly.
> > 
> > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> > Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >   tools/testing/selftests/bpf/prog_tests/bpf_nf.c | 3 ++-
> >   tools/testing/selftests/bpf/progs/test_bpf_nf.c | 3 +++
> >   2 files changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> > index 88a2c0bdefec..544bf90ac2a7 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> > @@ -44,7 +44,7 @@ static int connect_to_server(int srv_fd)
> >   static void test_bpf_nf_ct(int mode)
> >   {
> > -	const char *iptables = "iptables -t raw %s PREROUTING -j CT";
> > +	const char *iptables = "iptables -t raw %s PREROUTING -j CONNMARK --set-mark 42/0";
> Hi Daniel Xu, this test starts failing recently in CI [0]:
> 
> Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
>   iptables v1.8.8 (nf_tables): Could not fetch rule set generation id:
> Invalid argument
> 
>   Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
>   iptables v1.8.8 (nf_tables): Could not fetch rule set generation id:
> Invalid argument
> 
>   Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
>   iptables v1.8.8 (nf_tables): Could not fetch rule set generation id:
> Invalid argument
> 
>   Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
>   iptables v1.8.8 (nf_tables): Could not fetch rule set generation id:
> Invalid argument
> 
>   test_bpf_nf_ct:PASS:test_bpf_nf__open_and_load 0 nsec
>   test_bpf_nf_ct:FAIL:iptables unexpected error: 1024 (errno 0)
> 
> Could you help to take a look? Thanks.
> 
> [0]: https://github.com/kernel-patches/bpf/actions/runs/3231598391/jobs/5291529292

[...]

Thanks for letting me know. I took a quick look and it seems that
synproxy selftest is also failing:

    2022-10-12T03:14:20.2007627Z test_synproxy:FAIL:iptables -t raw -I PREROUTING      -i tmp1 -p tcp -m tcp --syn --dport 8080 -j CT --notrack unexpected error: 1024 (errno 2)

Googling the "Could not fetch rule set generation id" yields a lot of
hits. Most of the links are from downstream projects recommending user
downgrade iptables (nftables) to iptables-legacy.

So perhaps iptables/nftables suffered a regression somewhere. I'll take
a closer look tonight / tomorrow morning.

Thanks,
Daniel
