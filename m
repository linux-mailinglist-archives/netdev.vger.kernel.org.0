Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74776594E4B
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 03:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243333AbiHPBzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 21:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbiHPByj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 21:54:39 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95868210870;
        Mon, 15 Aug 2022 14:46:09 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 330E732007D7;
        Mon, 15 Aug 2022 17:46:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 15 Aug 2022 17:46:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660599966; x=1660686366; bh=5/0EPvXdhP
        ro0zKMiqEkonkJvXb/I1AzuGUyP3JQyBI=; b=wJ/HZdYgs0p31ThNXOV8mrGlLT
        Vk46kz9Qn76RQBJzxbUmYaB3E3ZuFVum/Aqm5qZUlDxu34pekRNIs9XqDYRYsXl5
        FWnt+zCgIAOJIGM8yhRqajjLNRIZs68RJDKBBmavTEHypZ3LrHm/6hynZ9xTMP6L
        TNOl8VuBLUW7QfBjmxLY1bUeD4sj+Otzjiy2j2UtN0gWx7yCaXWRj1Q9ea/suKRr
        i45PrJFOYLwtEO70Hxp0PkBU+n110TSBesNUmW6Q+GcZD0+NGBfPM1Lkwv1lUcrF
        UJTcw4dNWgNDgitrR6KZeHIqLOYqT9dLGK/PFOlm4d5r2luvcVzy/O4gTqmw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660599966; x=1660686366; bh=5/0EPvXdhPro0zKMiqEkonkJvXb/
        I1AzuGUyP3JQyBI=; b=2ZXCvA9cimntn1UjjHMB0r0MlvpOfOOtHRF5pcIaI81T
        mdTJA6vLOYPQM6eL69Kq7ZrFUhQmM8qPZ2ldvDMpyOwzUP+2vCOikQDugdVuRb/K
        pPBPc5U2su3eZoqmIEjJoM2btRPfAeIy864LeQ1D9rhxgWem0JvESurBZN/D3eD+
        IlT1IvcztrdJDrhSkHY8OlPVXV02IwYwk2AiBKpMXflEiwhQ22s1SxW2gB++os7B
        Icohgq8CUp3Ypigl5Omf0Se3QD24c5B4DZ0MvLzvm5zRZbCuY1bRKYZt/kIuNEH/
        sSkIoFePwmLMd0HOnlArTvKFJlHCfNbvyGXSNY2rdA==
X-ME-Sender: <xms:nb76Yv0Ej_z_uM_wN3B_P_R3ltOfeO2C8sGBtIuh29Zc_4lFpEvSDw>
    <xme:nb76YuGJkk7QBkz5kLgrEN5S4OJ8ssQK3Ly2IV2RLuJyqfrclNP7vLJyHnLQmnuSN
    sFj2Dtf4BWj03uncA>
X-ME-Received: <xmr:nb76Yv4yEU20_iu9UQ3pOzsS8VZdfTPLdbpzNJK1NfMSFmLq2SchkjeCfKMsQ0R5QFLwBsENaGicY9hIZPI77-KYqmmsE03A2ds4LP_mNbh27kyAwhUSYlokYwB0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehfedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrf
    grthhtvghrnhepvdfffeevhfetveffgeeiteefhfdtvdffjeevhfeuteegleduheetvedu
    ieettddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:nb76Yk1WLs_gY1IYxKa9HCfxP1WZQGDwJuW8-uJfX6mcviCw_oXBTQ>
    <xmx:nb76YiGxg2k9yNZr3I-NuiFVrR-7qWSkqLVqj3TFJwEPTe17kdgAnA>
    <xmx:nb76Yl-tiKe5RZYevmY2_0IdTNT3c5Rx2X5TGOj8Tou6sOHIO93XsQ>
    <xmx:nr76YgHpauIZlhEd-lIjWIXnPExykmUPz133PNZHrrtpg7Di_j3q_g>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 17:46:05 -0400 (EDT)
Date:   Mon, 15 Aug 2022 14:46:04 -0700
From:   Andres Freund <andres@anarazel.de>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, c@redhat.com
Subject: Re: [PATCH] virtio_net: Revert "virtio_net: set the default max ring
 size by find_vqs()"
Message-ID: <20220815214604.x7g342h3oadruxx2@awork3.anarazel.de>
References: <20220815090521.127607-1-mst@redhat.com>
 <20220815203426.GA509309@roeck-us.net>
 <20220815164013-mutt-send-email-mst@kernel.org>
 <20220815205053.GD509309@roeck-us.net>
 <20220815165608-mutt-send-email-mst@kernel.org>
 <20220815212839.aop6wwx4fkngihbf@awork3.anarazel.de>
 <20220815173256-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815173256-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022-08-15 17:39:08 -0400, Michael S. Tsirkin wrote:
> On Mon, Aug 15, 2022 at 02:28:39PM -0700, Andres Freund wrote:
> > On 2022-08-15 17:04:10 -0400, Michael S. Tsirkin wrote:
> > > So virtio has a queue_size register. When read, it will give you
> > > originally the maximum queue size. Normally we just read it and
> > > use it as queue size.
> > > 
> > > However, when queue memory allocation fails, and unconditionally with a
> > > network device with the problematic patch, driver is asking the
> > > hypervisor to make the ring smaller by writing a smaller value into this
> > > register.
> > > 
> > > I suspect that what happens is hypervisor still uses the original value
> > > somewhere.
> > 
> > It looks more like the host is never told about the changed size for legacy
> > devices...
> > 
> > Indeed, adding a vp_legacy_set_queue_size() & call to it to setup_vq(), makes
> > 5.19 + restricting queue sizes to 1024 boot again.
> 
> Interesting, the register is RO in the legacy interface.
> And to be frank I can't find where is vp_legacy_set_queue_size
> even implemented. It's midnight here too ...

Yea, I meant that added both vp_legacy_set_queue_size() and a call to it. I
was just quickly experimenting around.


> Yes I figured this out too. And I was able to reproduce on qemu now.

Cool.


> I'm posting a new patchset reverting all the handing of resize
> restrictions, I think we should rethink it for the next release.

Makes sense.

Greetings,

Andres Freund
