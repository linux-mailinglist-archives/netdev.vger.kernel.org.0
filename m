Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192DB5FDF13
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 19:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiJMRez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 13:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJMRex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 13:34:53 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941AC14D3D;
        Thu, 13 Oct 2022 10:34:49 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C73EA3200926;
        Thu, 13 Oct 2022 13:34:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 13 Oct 2022 13:34:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1665682487; x=1665768887; bh=DsLRBe3Kqg
        11qxqyD8iEafKn/j01pfzBRrrJqScyfLo=; b=f7SZBH7WjhSQGZCuMHebwkT2sd
        +viFn0CR3SIjXI2JL5ZQkUqV72KbP8lssa0nGl9NnHFp3u8dM930zmbj+k1EKXGT
        dmyWSUG4ThZuPjlJzsmMhWssQ/vk336zYPL3SGF8Bp7sntMNHw3Ra/VplQWA/ya8
        OKnug9TsNQ7E2PIb6gsn+kN/4HXcnz4b51MJcU3dkshI5SZPtiJEGDmZZlcVi/t6
        eAf0w6otCS9bbAl3cs6kSBJqxwMVNMW8utR3tWMkT8cyla2zeMjuYBTHhA9LEvmy
        lsUzNHN3yTXwi7wocJ7n5OeJgSLf2fkm5/wu49LM3w6BF5QZ49mFbE7EtW/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1665682487; x=1665768887; bh=DsLRBe3Kqg11qxqyD8iEafKn/j01
        pfzBRrrJqScyfLo=; b=L76Ve5FJL9Iz4Zy1s4a7laS8w+dlLAmgusGwE5w5DYvV
        2XGZQabRX9k2/MsXSvu/J2Jp0UZcTvJcVcD2pFibsv8AfptxG+CzLmYPouydKWtm
        Sw3rXl/TJAIAnTgEE9Hz7UYJ7MdKnIGC0/sHeWMyu/Ut8L8RPE4TMd91QnIxQn4l
        cJ6G9095f3wEOWX1U9xYDB+HAOnSmMUCX72fd73OEVbAYXqCDKy51IphGcyvOjpa
        JqOEdx9+lGEs1RZZHxO8+DlvnHjDLh6b0KXwNh9TT0DaaHvnTn3MQaoFNMtSJswY
        sPsAUN5uEoEWtsM4hs3TjaXDtiOTwcqIdU6d+AkBFA==
X-ME-Sender: <xms:NkxIYz1JAXnchSoQ40X737hlRnuXoNfxof9Q4CtPc8BjK0pf1PcEpQ>
    <xme:NkxIYyEZi1_PbHefB_3ZLGDU7N94iA7oP-3F2ygeHHcnIVL12Qf-i0-DEBbRo6iJK
    mjvq__qyxPMeAgMwA>
X-ME-Received: <xmr:NkxIYz6xmWbheEiUBU1cQbfkZD6HSj4KAtfwr5vnikiWEeWBGRoLmN9Nesunp2js4s9fOEMkMyDXjIa5>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeektddguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculdefhedmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredt
    tddtvdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqe
    enucggtffrrghtthgvrhhnpeffffdvfefhudfhfeejjedvieduiefgvdfghfejkeehueeu
    hfdvieeftdeugfffhfenucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdr
    giihii
X-ME-Proxy: <xmx:NkxIY42XuTKWSZPHKVCQDb6xQaYhp_x6WhDTrjBTHll6i_UoFT-qAw>
    <xmx:NkxIY2H5bY_aJ91LAFSvfx0au0buKEIf3AXPLGAD312EnB2WbBUZ1g>
    <xmx:NkxIY5_wMmQnIQh6eLuK0z_ECfmqVZjhi8bgaHlQfRSVdjbs4UhXog>
    <xmx:N0xIY5C1R_0VE1OGECV3gCtROmkpxajr9K8vkdh2Fn_H255jVCFhSw>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 13 Oct 2022 13:34:46 -0400 (EDT)
Date:   Thu, 13 Oct 2022 11:34:48 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        bpf@vger.kernel.org, memxor@gmail.com
Subject: Re: [PATCH bpf-next v4 2/3] selftests/bpf: Add connmark read test
Message-ID: <20221013173448.aprptjs5qq777342@k2>
References: <cover.1660254747.git.dxu@dxuuu.xyz>
 <d3bc620a491e4c626c20d80631063922cbe13e2b.1660254747.git.dxu@dxuuu.xyz>
 <43bf4a5f-dac9-4fe9-1eba-9ab9beb650aa@linux.dev>
 <20221012220953.i2xevhu36kxyxscl@k2>
 <16bcda3b-989e-eadf-b6c3-803470b0afd6@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16bcda3b-989e-eadf-b6c3-803470b0afd6@linux.dev>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_PDS_OTHER_BAD_TLD autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 03:20:01PM -0700, Martin KaFai Lau wrote:
> On 10/12/22 3:09 PM, Daniel Xu wrote:
> > Hi Martin,
> > 
> > On Tue, Oct 11, 2022 at 10:49:32PM -0700, Martin KaFai Lau wrote:
> > > On 8/11/22 2:55 PM, Daniel Xu wrote:
> > > > Test that the prog can read from the connection mark. This test is nice
> > > > because it ensures progs can interact with netfilter subsystem
> > > > correctly.
> > > > 
> > > > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> > > > Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > > ---
> > > >    tools/testing/selftests/bpf/prog_tests/bpf_nf.c | 3 ++-
> > > >    tools/testing/selftests/bpf/progs/test_bpf_nf.c | 3 +++
> > > >    2 files changed, 5 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> > > > index 88a2c0bdefec..544bf90ac2a7 100644
> > > > --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> > > > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> > > > @@ -44,7 +44,7 @@ static int connect_to_server(int srv_fd)
> > > >    static void test_bpf_nf_ct(int mode)
> > > >    {
> > > > -	const char *iptables = "iptables -t raw %s PREROUTING -j CT";
> > > > +	const char *iptables = "iptables -t raw %s PREROUTING -j CONNMARK --set-mark 42/0";
> > > Hi Daniel Xu, this test starts failing recently in CI [0]:
> > > 
> > > Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
> > >    iptables v1.8.8 (nf_tables): Could not fetch rule set generation id:
> > > Invalid argument
> > > 
> > >    Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
> > >    iptables v1.8.8 (nf_tables): Could not fetch rule set generation id:
> > > Invalid argument
> > > 
> > >    Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
> > >    iptables v1.8.8 (nf_tables): Could not fetch rule set generation id:
> > > Invalid argument
> > > 
> > >    Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
> > >    iptables v1.8.8 (nf_tables): Could not fetch rule set generation id:
> > > Invalid argument
> > > 
> > >    test_bpf_nf_ct:PASS:test_bpf_nf__open_and_load 0 nsec
> > >    test_bpf_nf_ct:FAIL:iptables unexpected error: 1024 (errno 0)
> > > 
> > > Could you help to take a look? Thanks.
> > > 
> > > [0]: https://github.com/kernel-patches/bpf/actions/runs/3231598391/jobs/5291529292
> > 
> > [...]
> > 
> > Thanks for letting me know. I took a quick look and it seems that
> > synproxy selftest is also failing:
> > 
> >      2022-10-12T03:14:20.2007627Z test_synproxy:FAIL:iptables -t raw -I PREROUTING      -i tmp1 -p tcp -m tcp --syn --dport 8080 -j CT --notrack unexpected error: 1024 (errno 2)
> > 
> > Googling the "Could not fetch rule set generation id" yields a lot of
> > hits. Most of the links are from downstream projects recommending user
> > downgrade iptables (nftables) to iptables-legacy.
> 
> Thanks for looking into it!  We have been debugging a bit today also.  I
> also think iptables-legacy is the one to use.  I posted a patch [0].  Let
> see how the CI goes.
> 
> The rules that the selftest used is not a lot.  I wonder what it takes to
> remove the iptables command usage from the selftest?

At least the conntrack mark stuff, it would've been easier to write the
selftests _without_ iptables. But I thought it was both good and
necessary to test interop between BPF and netfilter. B/c that is
what the user is doing (at least for me).

However if it's causing maintenance trouble, I'll leave that call to
you.

Thanks,
Daniel
