Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8C46A70D3
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 17:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjCAQYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 11:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCAQYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 11:24:51 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF0A3B0CC;
        Wed,  1 Mar 2023 08:24:49 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 9FEDB3200406;
        Wed,  1 Mar 2023 11:24:48 -0500 (EST)
Received: from imap42 ([10.202.2.92])
  by compute1.internal (MEProxy); Wed, 01 Mar 2023 11:24:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1677687887; x=
        1677774287; bh=226yzvA64Kc8Q6zDrmuOtbs/tNXb1G/+qqLqVU0wHB4=; b=Q
        gm5jFnpNqKyvfla6eRJrva3qhtbnUJ1RIrAD3Fl4JiCtqYtj9exaFLwkLlw/J9IW
        CH4QA6HIR/xoP4kmwHX+Quq45QY2+BG57owtJDssVVSg9J6ywZsMsvyQgoFKrEgS
        SdeJPePl7J5JnSy6cxPWai/Z5x97djayaPmn3chDhTlCSQP2dyGPXJ8Fr9uiXmPc
        AeQEmvbKrXHwO0c3uf+qX19ctRMvJjK3HTZaJilwAgX3FuZkX/+feVMIWvvSTsCS
        ZlDBn1IV98QliXyCLHUzr4OTb0u51LCeEVSOCSUnHnZRxiTGY1H4ajAWqpOO0SRb
        FekUkcuHmCfk7w2AkxyPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1677687887; x=
        1677774287; bh=226yzvA64Kc8Q6zDrmuOtbs/tNXb1G/+qqLqVU0wHB4=; b=g
        KUVlxshVdl0QmWZQ7o9s16OU/obw9EVg7TJH6NIcFJIOGon+kHQO3np8mwQh8L+C
        oNtQSx9D1k7N4rzCkibBLQPez5jvubUR/795i1+KUFAz0GR5csS1rqXeem+1GBmc
        UHjtCrjaX1o+1fr11Wmn64MbuyzMQY6NJ2XHsqDUOddD6OoFrgi80RKmUUMJHFPi
        beYMpP0+JarS8tMdn2GvbBSCowbJMZnh2l7itK3kdcaEm1eQzWp4x6vS7kdH6Z58
        YnJzaUto0FwpXgfpWFlOXEtYozK71YSNQIq9mb/6pDyX7MuzmmJ97FgADtJiXEtW
        Pm79a7A+OrS8PPo+sCO/g==
X-ME-Sender: <xms:T3z_Y0EdtiTqMRRrm0nISQVg-go1QHXe5OyKBmVt0Tqp9YuBwvXyVA>
    <xme:T3z_Y9X2tN0pkEE8IfJC0y_rQn-ap8ClQ85giFB3DCMSNfn9cn2x0D8IakdH7yk0p
    FuYDa-rqNwfMVAbiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudelhedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfeehmdenucfjughrpefofg
    ggkfgjfhffhffvvefutgfgsehtqhertderreejnecuhfhrohhmpedfffgrnhhivghlucgi
    uhdfuceougiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepueefheduve
    eiheeitdeufeekudfhuddukefghfeiieegveeufffhteejgeejgefgnecuffhomhgrihhn
    pehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:T3z_Y-LOjDX5NAcX_e2_yOXzIl5-T-mMwH2h64PFb_kryXbrngQzVw>
    <xmx:T3z_Y2GODkhDhWBRMvngm3F6bX4QqDp0lhWsYMVkZeTYP0ZaoefO5g>
    <xmx:T3z_Y6WJzV186uOyIEsll2Qr3HcGPEUqb6SJLTPCjs7MNdkaE_fS5Q>
    <xmx:T3z_Y5TaLAWcccpos6M2HlQWZG-ij7LEon31LhKw1CHcHERCe46vAw>
Feedback-ID: i6a694271:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id C1FC7BC0078; Wed,  1 Mar 2023 11:24:47 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-183-gbf7d00f500-fm-20230220.001-gbf7d00f5
Mime-Version: 1.0
Message-Id: <e882b638-ab7e-4dde-b95b-c01c8e78e02a@app.fastmail.com>
In-Reply-To: <cc4712f7-c723-89fc-dc9c-c8db3ff8c760@gmail.com>
References: <cover.1677526810.git.dxu@dxuuu.xyz>
 <cf49a091-9b14-05b8-6a79-00e56f3019e1@gmail.com>
 <20230227220406.4x45jcigpnjjpdfy@kashmir.localdomain>
 <cc4712f7-c723-89fc-dc9c-c8db3ff8c760@gmail.com>
Date:   Wed, 01 Mar 2023 09:24:25 -0700
From:   "Daniel Xu" <dxu@dxuuu.xyz>
To:     "Edward Cree" <ecree.xilinx@gmail.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 0/8] Support defragmenting IPv(4|6) packets in BPF
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ed,

Had some trouble with email yesterday (forgot to renew domain
registration) and this reply might not have made it out. Apologies
if it's a repost.

On Mon, Feb 27, 2023 at 10:58:47PM +0000, Edward Cree wrote:
> On 27/02/2023 22:04, Daniel Xu wrote:
> > I don't believe full L4 headers are required in the first fragment.
> > Sufficiently sneaky attackers can, I think, send a byte at a time to
> > subvert your proposed algorithm. Storing skb data seems inevitable h=
ere.
> > Someone can correct me if I'm wrong here.
>=20
> My thinking was that legitimate traffic would never do this and thus if
>  your first fragment doesn't have enough data to make a determination
>  then you just DROP the packet.

Right, that would be practical. I had some discussion with coworkers and
the other option on the table is to drop all fragments. At least for us
in the cloud, fragments are heavily frowned upon (where are they not..)
anyways.

> > What I find valuable about this patch series is that we can
> > leverage the well understood and battle hardened kernel facilities. =
So
> > avoid all the correctness and security issues that the kernel has sp=
ent
> > 20+ years fixing.
>=20
> I can certainly see the argument here.  I guess it's a question of are
>  you more worried about the DoS from tricking the validator into think=
ing
>  good fragments are bad (the reverse is irrelevant because if you can
>  trick a validator into thinking your bad fragment belongs to a previo=
usly
>  seen good packet, then you can equally trick a reassembler into stitc=
hing
>  your bad fragment into that packet), or are you more worried about the
>  DoS from tying lots of memory down in the reassembly cache.

Equal balance of concerns on my side. Ideally there are no dropping of
valid packets and DoS is very hard to achieve.

> Even with reordering handling, a data structure to record which ranges=
 of
>  a packet have been seen takes much less memory than storing the compl=
ete
>  fragment bodies.  (Just a simple bitmap of 8-byte blocks =E2=80=94 th=
e resolution
>  of iph->frag_off =E2=80=94 reduces size by a factor of 64, not counti=
ng all the
>  overhead of a struct sk_buff for each fragment in the queue.  Or you
>  could re-use the rbtree-based code from the reassembler, just with a
>  freshly allocated node containing only offset & length, instead of the
>  whole SKB.)

Yeah, now that you say that, it doesn't sound too bad on space side. But
I do wonder -- how much code and complexity is that going to be? For
example I think ipv6 frags have a 60s reassembly timeout which adds more
stuff to consider. And probably even more I've already forgotten.

B/c at least on the kernel side, this series is 80% code for tests. And
the kfunc wrappers are not very invasive at all.  Plus it's wrapping
infra that hasn't changed much for decades.


> And having a BPF helper effectively consume the skb is awkward, as you
>  noted; someone is likely to decide that skb_copy() is too slow, try to
>  add ctx invalidation, and thereby create a whole new swathe of potent=
ial
>  correctness and security issues.

Yep. I did try that. While the verifier bits weren't too tricky, there
are a lot of infra concerns to solve:

* https://github.com/danobi/linux/commit/35a66af8d54cca647b0adfc7c1da710=
5d2603dde
* https://github.com/danobi/linux/commit/e8c86ea75e2ca8f0631632d54ef7633=
81308711e
* https://github.com/danobi/linux/commit/972bcf769f41fbfa7f84ce00faf06b5=
b57bc6f7a

But FWIW, fragmented packets are kinda a corner case anyways. I don't
think it would be resonable to expect high perf when packets are in
play.

> Plus, imagine trying to support this in a hardware-offload XDP device.
>  They'd have to reimplement the entire frag cache, which is a much big=
ger
>  attack surface than just a frag validator, and they couldn't leverage
>  the battle-hardened kernel implementation.

Hmm, well this helper is restricted to TC progs for now. I don't quite
see a path to enabling for XDP as there would have to be at a minimum
quite a few allocations to handle frags. So not sure XDP is a factor at
the moment.

>=20
> > And make it trivial for the next person that comes
> > along to do the right thing.
>=20
> Fwiw the validator approach could *also* be a helper, it doesn't have =
to
>  be something the BPF developer writes for themselves.
>=20
> But if after thinking about the possibility you still prefer your way,=
 I
>  won't try to stop you =E2=80=94 I just wanted to ensure it had been c=
onsidered.

Thank you for the discussion. The thought had come to mind originally,
but I shied away after seeing some of the reassembly details. Would be
interested in hearing more from other folks.


Thanks,
Daniel
