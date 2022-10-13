Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB0B5FD4CE
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 08:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiJMG3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 02:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiJMG3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 02:29:16 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1DD1EC55;
        Wed, 12 Oct 2022 23:29:13 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 55C7E5C00FC;
        Thu, 13 Oct 2022 02:29:11 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Thu, 13 Oct 2022 02:29:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1665642551; x=1665728951; bh=IK7qyXP/Hq
        Hv2l79+EvbWbN9n2PDThaIIYKN+SdCmLU=; b=InSsjplS9Ys0U2AGlXKt7JrKR9
        P4de4X3Des9x2jpi0NY5SqXFP9lDw2DELcTICNVaFYyQVug4NSAlLn2wnv5RNlKE
        yseSXnYYuoWnY4pjo8NBgTmK4BauaA0Vxpaxn30Rme9wCptdagLbtyc4WqCbQL+Q
        cbpa5YWMf59gAIoWc3xf7hsmriAvf6j0yjBXUSGoOutA/yJEXGrfxtUUh5GtWCLx
        zifPjL/UKNieG6TcgJ/e4rUEQQTkNwwTqlJHxlGJxgo3ljAN8kc2ybhzMWsdCfpj
        IJCSW6YUymHtrKbcSmGL7p68Usa2uTDg003fZ+yniKqlbvDqZ69trc46dPqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1665642551; x=1665728951; bh=IK7qyXP/HqHv2l79+EvbWbN9n2PD
        ThaIIYKN+SdCmLU=; b=Q2CpNE0R0yn5ejpW0T6nFjfHoMnRLXBS32u4Y90NWnC0
        1tIINvXRjhsIWBsk9oo21L9SAU2QG0twhkXlxNprdbOVir6CW2viY7ro8/IkN8ok
        W1MerrZ+NRcgQkEAfAo90dHOYlI/yT2O/u4mZarMEBDibKBp2TtBsMdspWbRg2kQ
        Px0D68KqMraQDAElccP2rC/C/MFaZSBgdlWvMtzRW6oqKkXKDumd9MfS8pJCrir2
        nCjkuqxVVg1yMAURsQv5HJ7jx7PktJYsnkYbIGw3/La60yExsGRF81MZ30FuyXLE
        3X3N1SLQ8ZDLF1NicDFofzohyntVbzNOOhnOW0gCgQ==
X-ME-Sender: <xms:NrBHY7_Ni3TZ3cVbcq129ad5lztFqrAYS710Pvv1ow2bZY2XNGV1gw>
    <xme:NrBHY3tQatCkmrhc2_bIhRoGWRGOqxv5firinyaUfWUaMrKmhSZ-4DcpdrafBG5Xr
    vDrDMrPBmVYdpapWdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeejledguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:NrBHY5AeVxScoHloAQn3dk12_0JBsCSMxhuCYcm0_4fd4jccNPWxqA>
    <xmx:NrBHY3fPMECVqQVWlU7aEwnSnBUtJ3eZzm5kEW7Di4IbMUH406kCmw>
    <xmx:NrBHYwMEJd_OL-fNGSTJEFtKIs8WIBfG6KXbe-VRRsY3OPi7Nu-NYw>
    <xmx:N7BHYyv332Ii0uhigppB6rMr2NLWWMg9MonS7J95YHIiD4hXOpdN6Q>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 28323B60086; Thu, 13 Oct 2022 02:29:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1047-g9e4af4ada4-fm-20221005.001-g9e4af4ad
Mime-Version: 1.0
Message-Id: <a35fd31b-0658-4ac1-8340-99cdf4c75bb7@app.fastmail.com>
In-Reply-To: <20221012180806-mutt-send-email-mst@kernel.org>
References: <20221010132030-mutt-send-email-mst@kernel.org>
 <87r0zdmujf.fsf@mpe.ellerman.id.au>
 <20221012070532-mutt-send-email-mst@kernel.org>
 <87mta1marq.fsf@mpe.ellerman.id.au> <87edvdm7qg.fsf@mpe.ellerman.id.au>
 <20221012115023-mutt-send-email-mst@kernel.org>
 <CAHk-=wg2Pkb9kbfbstbB91AJA2SF6cySbsgHG-iQMq56j3VTcA@mail.gmail.com>
 <38893b2e-c7a1-4ad2-b691-7fbcbbeb310f@app.fastmail.com>
 <20221012180806-mutt-send-email-mst@kernel.org>
Date:   Thu, 13 Oct 2022 08:28:03 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "Linus Torvalds" <torvalds@linux-foundation.org>,
        xiujianfeng@huawei.com, kvm@vger.kernel.org,
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022, at 12:08 AM, Michael S. Tsirkin wrote:
> On Wed, Oct 12, 2022 at 11:06:54PM +0200, Arnd Bergmann wrote:
>> On Wed, Oct 12, 2022, at 7:22 PM, Linus Torvalds wrote:
>> >
>> > The NO_IRQ thing is mainly actually defined by a few drivers that just
>> > never got converted to the proper world order, and even then you can
>> > see the confusion (ie some drivers use "-1", others use "0", and yet
>> > others use "((unsigned int)(-1)".
>> 
>> The last time I looked at removing it for arch/arm/, one problem was
>> that there were a number of platforms using IRQ 0 as a valid number.
>> We have converted most of them in the meantime, leaving now only
>> mach-rpc and mach-footbridge. For the other platforms, we just
>> renumbered all interrupts to add one, but footbridge apparently
>> relies on hardcoded ISA interrupts in device drivers. For rpc,
>> it looks like IRQ 0 (printer) already wouldn't work, and it
>> looks like there was never a driver referencing it either.
>
> Do these two boxes even have pci?

Footbridge/netwinder has PCI and PC-style ISA on-board devices
(floppy, ps2 mouse/keyboard, parport, soundblaster, ...), RiscPC
has neither.

    Arnd
