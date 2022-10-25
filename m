Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F1060C3BA
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 08:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiJYGUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 02:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiJYGUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 02:20:47 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD4826575;
        Mon, 24 Oct 2022 23:20:43 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1F6A15C0195;
        Tue, 25 Oct 2022 02:20:43 -0400 (EDT)
Received: from imap42 ([10.202.2.92])
  by compute2.internal (MEProxy); Tue, 25 Oct 2022 02:20:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1666678843; x=1666765243; bh=7W3UXDHBfkNojsHZuhGRHr85qNsS45ct53e
        sNjSB9hc=; b=iRthNzQHgq4jCwNYZJiQBECSxEopKaQr0iOdgDqWIRAqgoGt340
        JrjJ9pIfLrUyf1CxrHXdTdxuV9ApWrG/lJQDV8KnKXYIEQB5OxzKupG0psRS0uZr
        EZywIZWSNtAjUxOk3TBMF7n4jZazT2r5kXj6s4LeFQ3ANppVZ9+nBh40UIHcr71V
        nTs77XJT5kSW0oCiq/zzTV7rVGP7tuvtQ5cWrJxdezJ8XupHEcHSMeb0jtqB54oz
        V3id8otJG73Y/BDcCbp6TGM9npdowdd5rrF7OmOcPPaWQ4pNmcdya/CvotwPsMXz
        7LrK60TPYwR9O0HgsDoqOZZ5QD2XITvM9iQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:message-id:mime-version
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1666678843; x=
        1666765243; bh=7W3UXDHBfkNojsHZuhGRHr85qNsS45ct53esNjSB9hc=; b=p
        pkyH9JYKEmuUSAapa/HXGo9qwV4s9XRC5IobH32xugrmQ0qyctmm7u+r3b+QXOGj
        0zIUPT8srWlA4gsGDrJWz8zF1jLkyD0BfCr2ICV2X0YoPAW0z3CP2PtN1BB52OjE
        GquVkMyWHSyR/df1VxRL5Cw9Amvhut6G4WLiqCuQlC+HQQJ7jZbf2ojP6VFQfHAe
        O4e5WjhrsPGVUiSaOKAnvicyWc0uMs855hU0Z44gjWykHEhFaw1awk3oCpHfVfMs
        IJNCNmtV8dnYFGcrX+kMz8nVYy5/n+TP6X/YsuDzXG3VwGWVTyqaiv8sVr4jaVLj
        NUVxD9wx3Z/jSwidadFzw==
X-ME-Sender: <xms:OoBXYyU0qxB8gEVxTphuY_TnQ2miRubdQP7FAERM3gmwcnYhDLvR8w>
    <xme:OoBXY-mN0Fk5QpuiWKq36wqLq4x9EYk2w76CJIzPNY1Wuqa7cZ8ZIrl_117kp_Ox6
    _gX6tlFDyFG9tklhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgedthedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculddvfedmnecujfgurhepofgfggfkfffhvfevufgtsehttdertder
    redtnecuhfhrohhmpedfffgrnhhivghlucgiuhdfuceougiguhesugiguhhuuhdrgiihii
    eqnecuggftrfgrthhtvghrnhepkeffhffhfedvueejhfekkeeitdetkedvjeetkeektedt
    gfeuleeiudfgteelheetnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpghhithhhuh
    gsrdgtohhmpdhnvghtfhhilhhtvghrrdhorhhgnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:OoBXY2YaeHVHIBuHbZSN3tdLhXZ1VbMsq5pPxGMBhml3U8W_FIQ4yA>
    <xmx:OoBXY5VNxvp_NDN1SA3m16aXUF1lEk5lNFImu6Dnz67JHj5QXVaHjg>
    <xmx:OoBXY8mqwudL1R-Yj9-lXM-ccqyR08eHFXnYD9f0E_lHDtwZsOOowg>
    <xmx:O4BXY7taLan8SFYRH95dKXG4m2U8FvrMZ47dqP0DaB8jqo9kHlKxWQ>
Feedback-ID: i6a694271:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 4E785BC0078; Tue, 25 Oct 2022 02:20:42 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1047-g9e4af4ada4-fm-20221005.001-g9e4af4ad
Mime-Version: 1.0
Message-Id: <9a91603a-7b8f-4c6d-9012-497335e4373b@app.fastmail.com>
Date:   Tue, 25 Oct 2022 00:19:55 -0600
From:   "Daniel Xu" <dxu@dxuuu.xyz>
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Jozsef Kadlecsik" <kadlec@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ppenkov@aviatrix.com
Subject: ip_set_hash_netiface
Content-Type: text/plain
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

I'm following up with our hallway chat yesterday about how ipset
hash:net,iface can easily OOM.

Here's a quick reproducer (stolen from
https://bugzilla.kernel.org/show_bug.cgi?id=199107):

        $ ipset create ACL.IN.ALL_PERMIT hash:net,iface hashsize 1048576 timeout 0
        $ for i in $(seq 0 100); do /sbin/ipset add ACL.IN.ALL_PERMIT 0.0.0.0/0,kaf_$i timeout 0 -exist; done

This used to cause a NULL ptr deref panic before
https://github.com/torvalds/linux/commit/2b33d6ffa9e38f344418976b06 .

Now it'll either allocate a huge amount of memory or fail a
vmalloc():

        [Tue Oct 25 00:13:08 2022] ipset: vmalloc error: size 1073741848, exceeds total pages
        <...>
        [Tue Oct 25 00:13:08 2022] Call Trace:
        [Tue Oct 25 00:13:08 2022]  <TASK>
        [Tue Oct 25 00:13:08 2022]  dump_stack_lvl+0x48/0x60
        [Tue Oct 25 00:13:08 2022]  warn_alloc+0x155/0x180
        [Tue Oct 25 00:13:08 2022]  __vmalloc_node_range+0x72a/0x760
        [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_add+0x7c0/0xb20
        [Tue Oct 25 00:13:08 2022]  ? __kmalloc_large_node+0x4a/0x90
        [Tue Oct 25 00:13:08 2022]  kvmalloc_node+0xa6/0xd0
        [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_resize+0x99/0x710
        <...>

Note that this behavior is somewhat documented
(https://ipset.netfilter.org/ipset.man.html):

>  The internal restriction of the hash:net,iface set type is that the same
>  network prefix cannot be stored with more than 64 different interfaces
>  in a single set.

I'm not sure how hard it would be to enforce a limit, but I think it would
be a bit better to error than allocate many GBs of memory.

Thanks,
Daniel
