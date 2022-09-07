Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4D35AF9F1
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 04:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiIGCgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 22:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiIGCgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 22:36:07 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE357F112;
        Tue,  6 Sep 2022 19:36:06 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 9FE815C0098;
        Tue,  6 Sep 2022 22:36:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 06 Sep 2022 22:36:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1662518163; x=1662604563; bh=UvF1iyuJKX
        q7GvuceIIhqaYE9S82z6ibv1ru64WCKdc=; b=bybK68XNIMVzk+3c/RNymCE2UC
        g2D6xW8Z45awBvx6tOITVI0L7dMStE8kEEJ6QGwB5OjImAJT32HpYD2CHWTMRN97
        8/BEFv4XahFjMhvb8KUxNEJIqaloK/Qh+Mgd97eZsMtxVkjv6IdDMi4eU7EZwtwK
        Y/EP5MfBlXpXMJ6+jHccSW1FXOjyvJfdV8xWDD/tWL0Soc2Hp/kO4Hz7IbAq+0Nq
        IcPH/Pnlf9qS3wKqVCx0nrE4TFfoAFQjQk9KKeHBOaKd5VXJ5OI5GCQf+lgNThR4
        AzbEx2Vl/nIzfO+BDAkHW9xq7xADqsUgdH1iyRLtKHCyP0R4mI8SUgPhSJyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1662518163; x=1662604563; bh=UvF1iyuJKXq7GvuceIIhqaYE9S82
        z6ibv1ru64WCKdc=; b=g/Ms29JUaxSVe+jMIChvRDNZfKFivNkazOSYXrZh5ok6
        6dWw7gBXGSQDXf1LIzWoCobS8lYawRN5kyDycB2Hninoqu0IxHixZBT2BAyNVOy8
        NrJUQClcIrxzr9mHMRb36ASirhr3OQqA9nhnsMC4ru5kmxH33eTfYU1Qsn7qhvnY
        zwfyIvWW9zvStejmSPjSd7RYUTiJnpNo3GGjSsmzh+IFydHaK/gHIdWnieVmKlyH
        iJ/sf7BcVujYK7TrXEh0yAA1ysfDo2IhguPWA/oygP72byIqwUOJwR+MDpoCi8Cb
        eQUP+gPYSWc2VeCFDO2X09nxXw4yrVhvdY/YKPZumg==
X-ME-Sender: <xms:kQMYY34JVm0p7oDx7hhJ6lvoaufVmGYLL5bLsMXpGLa_Gw9hWF0jZg>
    <xme:kQMYY85aRyY8Z-QupbI3XEKBARn5yAL8R53XVY8m1nmHSXjLRBEn9394oQd4UnQBV
    _n8nJdM3WgGmRUKRw>
X-ME-Received: <xmr:kQMYY-cVP7mJbsbvcQhvEAky98IOSVslrlcgxWmI_i7gYavPQhmue0QWnVBmkKcmyaW8NEuN9kHBIxR0AuWLNhVuhxRBhS8HuB05-Mo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdelledgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfeehmdenucfjughrpeffhf
    fvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepheeltedvgffhgfduud
    elleeguddtueefgfefvdeukeffvdeguddtvdeuteehteevnecuffhomhgrihhnpehkvghr
    nhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:kQMYY4JJYVWpNWNKelD6ugCM7kqpE2U88j6teYM8OVUVpGfBY2BFIQ>
    <xmx:kQMYY7Lckn6zshgDilaoCg72EFbgFppXr5657UpOYbMyJ5Q1va962Q>
    <xmx:kQMYYxyAzifvgDd8EbcQOfP6BasZzhsNeuTJu6J816IyIX1qK9g5uw>
    <xmx:kwMYY4D_EZpkBmZDijU0yOGmXVDBkJSrXdhQ2d_4p29AaPzjwtWuyA>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Sep 2022 22:36:00 -0400 (EDT)
Date:   Tue, 6 Sep 2022 20:35:59 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 4/5] bpf: Add support for writing to
 nf_conn:mark
Message-ID: <20220907023559.22juhtyl3qh2gsym@kashmir.localdomain>
References: <cover.1661192455.git.dxu@dxuuu.xyz>
 <073173502d762faf87bde0ca23e609c84848dd7e.1661192455.git.dxu@dxuuu.xyz>
 <CAP01T74XK_6wMi+tzReTkBqmZkKbUqCmV6pVwcbCMrHrv0X0SA@mail.gmail.com>
 <20220823021923.vmhp5r76dvgwvh2j@kashmir.localdomain>
 <CAP01T77mwS=_sW803CaBgpFtuwMEd4fS81uTvVKYLdGyg5hv1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP01T77mwS=_sW803CaBgpFtuwMEd4fS81uTvVKYLdGyg5hv1A@mail.gmail.com>
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kumar,

On Tue, Aug 23, 2022 at 04:29:17AM +0200, Kumar Kartikeya Dwivedi wrote:
> On Tue, 23 Aug 2022 at 04:19, Daniel Xu <dxu@dxuuu.xyz> wrote:

[...]

> > There's also some other issues I'm uncovering with duplicate BTF IDs for
> > nf_conn. Might have to do a lookup by name instead of the BTF_ID_LIST().
> >
> 
> I think I also hit this problem back when I was working on these
> patches, is it similar to this?
> https://lore.kernel.org/bpf/20211028014428.rsuq6rkfvqzq23tg@apollo.localdomain

Yes, identical I think.

> 
> I think this might be a bug in the BTF generation, since there should
> only be one BTF ID for a type, either in vmlinux or the module BTF.
> Maybe Andrii would be able to confirm.

Had to put out some fires last week.

I chased this down a bit today and best I can tell was the `nf_conn`
definitions in BTF were all slightly different.

For example, here were the 3 definitions in nf_conntrack.ko alone:

    [88439] STRUCT 'nf_conn' size=296 vlen=11
            'ct_general' type_id=67058 bits_offset=0
            'lock' type_id=373 bits_offset=64
            'timeout' type_id=160 bits_offset=576
            'tuplehash' type_id=67235 bits_offset=640
            'status' type_id=1 bits_offset=1536
            'ct_net' type_id=4298 bits_offset=1600
            '__nfct_init_offset' type_id=4213 bits_offset=1664
            'master' type_id=88438 bits_offset=1664
            'mark' type_id=67192 bits_offset=1728
            'ext' type_id=67236 bits_offset=1792
            'proto' type_id=67234 bits_offset=1856
            
    [90882] STRUCT 'nf_conn' size=296 vlen=11
            'ct_general' type_id=67058 bits_offset=0
            'lock' type_id=373 bits_offset=64
            'timeout' type_id=160 bits_offset=576
            'tuplehash' type_id=67235 bits_offset=640
            'status' type_id=1 bits_offset=1536
            'ct_net' type_id=90574 bits_offset=1600
            '__nfct_init_offset' type_id=4213 bits_offset=1664
            'master' type_id=90881 bits_offset=1664
            'mark' type_id=67192 bits_offset=1728
            'ext' type_id=67236 bits_offset=1792
            'proto' type_id=67234 bits_offset=1856
            
    [92469] STRUCT 'nf_conn' size=296 vlen=11
            'ct_general' type_id=67058 bits_offset=0
            'lock' type_id=373 bits_offset=64
            'timeout' type_id=160 bits_offset=576
            'tuplehash' type_id=67235 bits_offset=640
            'status' type_id=1 bits_offset=1536
            'ct_net' type_id=92160 bits_offset=1600
            '__nfct_init_offset' type_id=4213 bits_offset=1664
            'master' type_id=92468 bits_offset=1664
            'mark' type_id=67192 bits_offset=1728
            'ext' type_id=67236 bits_offset=1792
            'proto' type_id=67234 bits_offset=1856

Note how `master` and `ct_net` all have different BTF IDs. Best I can
tell is that there's some kind of subtle difference in BTF types and
it's confusing the dedup algorithm.

I went and upgraded to latest pahole (built from today's source tree) to
chase the issue down further but the problem went away.

Figured I'd write this up in case someone stumbles onto this in the
future.

[...]

Thanks,
Daniel
