Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2C95FCCC3
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 23:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiJLVHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 17:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiJLVHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 17:07:38 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409B513DC6;
        Wed, 12 Oct 2022 14:07:33 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 68F2B5C00BC;
        Wed, 12 Oct 2022 17:07:30 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Wed, 12 Oct 2022 17:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1665608850; x=1665695250; bh=1zjTzbu3nE
        vKPjEu+A0VVC9cmYrYpXNTso2KnYCuc7o=; b=vAwa1ydC+9d2I9JWQMsHnQzLD0
        NajTZT00Z6YRtX9eVlpSljSvsU/yFsucT7Aq4Oscd1E2DbgdPAvw7h8MKi+SfPJi
        6olwV0ACpfjzjzNIEvpw0f/+c5g/bj3HsWyEX4gLB+349ezXY0uOnWrZsu6S7TNx
        mfiAfZoqvCDtQdLE6T4GDduKjKA2nipxepU9MAG7ujEEXk99r8DrNRZfGlK15Cfu
        z2WWUcSqqd0bankroEDffJ6XWZiKoziKWQd8PePJNpvICMQhTRfBPaFsQfDtKMUQ
        MpT0yNPx59E+CJiAriCqWotq1txyVUSWV7+ett3PIQE6J6q76SW15b7lC0nw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1665608850; x=1665695250; bh=1zjTzbu3nEvKPjEu+A0VVC9cmYrY
        pXNTso2KnYCuc7o=; b=VFM8vr6JEg7opglf79F9TeVrikpH40HEGO+JtHdDIeGo
        JDNkv7wsHZKKzWWSsZGrud+/BfHI86ACBp7Eh2fzKmPR66F8OFpDhsKVcYTF3km4
        fFrIaAgxygV9e3TVbuCCWSF+3oxXTTbLWobgiAdbqQm0TbXyIObYp94McGRHBuYL
        O1dyvj+JVJzlRkigjzYCMQ0mYi0YxGQ4Ipe4pnbIw6CFmauLOazr6n3faaW+nETo
        5vFahsqFKyaqFPx8QGAQW3Tdw+ANTXwL8y8U/rytPX57DKMWyIGBdHLm4rMbHaVe
        kqcHrt6Y/l1Vx6o3khLwq3Hlu6WofmmXMSVZWsPt2Q==
X-ME-Sender: <xms:kSxHY4uYl8NqQVKE7TlRYofsBddMRUrI96xa6Pk9mWO3s30GLZXhVw>
    <xme:kSxHY1fxsuw10Uc3pbJSjBs6_0Up0QOclLg48G8pVmvua6kas8vOv7Rp8Ih-15c7Q
    aHhfUnNJWhs47BeYJc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeejkedgudehlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:kSxHYzxEmXJhVtY7mzAljiIxJ8g7vbYtpPC0tpJEjUSewlAhg0JIhw>
    <xmx:kSxHY7Nhw7JdZ-kUMWRwEPuRQzBFD8USLwWQFxnptjhFcbC8wS7iMg>
    <xmx:kSxHY48vPy4-hM5zI6LGwuSveJEJXMlJt5fVNQg9kSkEIfc1U4af4w>
    <xmx:kixHYydoUmNqBtkkA6x_gy4dCaEesVEAWfyCYVTtN8EfE59z9KQcCw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 02DC4B60086; Wed, 12 Oct 2022 17:07:29 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1047-g9e4af4ada4-fm-20221005.001-g9e4af4ad
Mime-Version: 1.0
Message-Id: <38893b2e-c7a1-4ad2-b691-7fbcbbeb310f@app.fastmail.com>
In-Reply-To: <CAHk-=wg2Pkb9kbfbstbB91AJA2SF6cySbsgHG-iQMq56j3VTcA@mail.gmail.com>
References: <20221010132030-mutt-send-email-mst@kernel.org>
 <87r0zdmujf.fsf@mpe.ellerman.id.au>
 <20221012070532-mutt-send-email-mst@kernel.org>
 <87mta1marq.fsf@mpe.ellerman.id.au> <87edvdm7qg.fsf@mpe.ellerman.id.au>
 <20221012115023-mutt-send-email-mst@kernel.org>
 <CAHk-=wg2Pkb9kbfbstbB91AJA2SF6cySbsgHG-iQMq56j3VTcA@mail.gmail.com>
Date:   Wed, 12 Oct 2022 23:06:54 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     xiujianfeng@huawei.com, kvm@vger.kernel.org,
        alvaro.karsz@solid-run.com, "Jason Wang" <jasowang@redhat.com>,
        angus.chen@jaguarmicro.com, wangdeming@inspur.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>, lingshan.zhu@intel.com,
        linuxppc-dev@lists.ozlabs.org, gavinl@nvidia.com
Subject: Re: [GIT PULL] virtio: fixes, features
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022, at 7:22 PM, Linus Torvalds wrote:
>
> The NO_IRQ thing is mainly actually defined by a few drivers that just
> never got converted to the proper world order, and even then you can
> see the confusion (ie some drivers use "-1", others use "0", and yet
> others use "((unsigned int)(-1)".

The last time I looked at removing it for arch/arm/, one problem was
that there were a number of platforms using IRQ 0 as a valid number.
We have converted most of them in the meantime, leaving now only
mach-rpc and mach-footbridge. For the other platforms, we just
renumbered all interrupts to add one, but footbridge apparently
relies on hardcoded ISA interrupts in device drivers. For rpc,
it looks like IRQ 0 (printer) already wouldn't work, and it
looks like there was never a driver referencing it either.

I see that openrisc and parisc also still define NO_IRQ to -1, but at
least openrisc already relies on 0 being the invalid IRQ (from
CONFIG_IRQ_DOMAIN), probably parisc as well.

     Arnd
