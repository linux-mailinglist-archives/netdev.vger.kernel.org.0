Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB14666F88
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 11:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239644AbjALK0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 05:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbjALK0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 05:26:03 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A787BE80;
        Thu, 12 Jan 2023 02:22:01 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 14C9A5C01BC;
        Thu, 12 Jan 2023 05:22:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 12 Jan 2023 05:22:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1673518921; x=
        1673605321; bh=yluViCVK9LEZ64fIpen7A1Nsh9HPYnGVZn2CRVaZAK4=; b=K
        E2sgd2x2541tKIYaCy+Yvjg/3RO7Ao8SzdsrBoIlONL5B1cW6Jz6jJAcDO6Ir4u6
        rv8YASockywOz1zQqPVWIHVEK3Zp+4MHBf1hda3uhTwnfTBrU4LBq5lp0/jbrkqS
        iGlfW9kpE8BuPP1c/4Hq7ls4DZ5E4QX0sfUscDXAzjspzchwXRiUlEybGbhHtxsy
        MtFOrMhiTMNnuzQLMTnNYWeH22JaIZxqswDjFL+yyLQWaRtmNnNOMj1UG8pJcltS
        wkje4MRY2c65sMbS0FoyAditOpSmUlf/Tg1E2TF8K7w5+TMo41f8i3EWFOK0fqSS
        1TCcJNJBdsnCRuRBNb1uQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1673518921; x=
        1673605321; bh=yluViCVK9LEZ64fIpen7A1Nsh9HPYnGVZn2CRVaZAK4=; b=F
        1c3tgRKVd3eKWe4Ky9bjion/80gruQhv6G6PKpSG0DNoq6044OwcrnirRJ/lVMmb
        AOnmG4GTjk4+awWObpOlI8gUoL6NuVSAURX3ZP9SElruExUvK7pO8SQgL/vKIgHL
        v3zfAtpuDrYvcZ0xP96HECL8f2RwTm3fSLgTzoFqkDB9SinWLLkC52olGFODf7d+
        MYPStrGk7to7x/lkzguXIqZoqrLq1vOoZT9F4nmG77LggTAPp2zAAvrg/y9HJ7tq
        S4iKecniHwkk+2QWTqzDJy/AyajGzBmvMCqzx7UQKpAaJzfWSySIxBrTy3txECZa
        eq2sGSX14UpTsGyQrgN1g==
X-ME-Sender: <xms:SN-_Y5b_LmDUITf8nj0cRl02p6sn70KPZNjItdotG4xZOvffwQzkrQ>
    <xme:SN-_Ywaz4SeO6rtkQk9DOQEnhNwsdHFWOFW0ryT7Rin6nhUh058TESetCS3QOZZpv
    ykx7knjahw0sw>
X-ME-Received: <xmr:SN-_Y7_12PaG4gn1-xEqOHWQkyaVI7XqYWiLXJWdZ8f4p2MdUtLbMZm9krVDxMoyqAi6FQVH1Yxjj49qAFImY-NhT7Qx5yPbAEuy_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleeigddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeevve
    etgfevjeffffevleeuhfejfeegueevfeetudejudefudetjedttdehueffnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:SN-_Y3qoIXqAXUll3HYE-4O_fNRLZtBcVwL4MjJbX82BzcU-7ncZvw>
    <xmx:SN-_Y0ocbpazTtR2Uv0YoM88AytC2WjKH85QBgpAW1-xLUyUa_WMMA>
    <xmx:SN-_Y9Qja7s0rRehEsVcmgw9UsrvPFE06bSGdgwuPh_GJUzvmbIMLA>
    <xmx:Sd-_YyYQOLN8MwXKHySIDk6I5bKCsTvVKKd0uYHWtz5VBNN_R2KhJQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Jan 2023 05:22:00 -0500 (EST)
Date:   Thu, 12 Jan 2023 11:21:58 +0100
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8152; preserve device list format
Message-ID: <Y7/fRlDqFRUOle7a@kroah.com>
References: <87k01s6tkr.fsf@miraculix.mork.no>
 <20230112100100.180708-1-bjorn@mork.no>
 <Y7/dBXrI2QkiBFlW@kroah.com>
 <87cz7k6ooc.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87cz7k6ooc.fsf@miraculix.mork.no>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 11:18:59AM +0100, Bjørn Mork wrote:
> Greg KH <greg@kroah.com> writes:
> > On Thu, Jan 12, 2023 at 11:01:00AM +0100, Bjørn Mork wrote:
> >> This is a partial revert of commit ec51fbd1b8a2 ("r8152:
> >> add USB device driver for config selection")
> >> 
> >> Keep a simplified version of the REALTEK_USB_DEVICE macro
> >> to avoid unnecessary reformatting of the device list. This
> >> makes new device ID additions apply cleanly across driver
> >> versions.
> >> 
> >> Fixes: ec51fbd1b8a2 ("r8152: add USB device driver for config selection")
> >> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> >> ---
> >> The patch in
> >> https://lore.kernel.org/lkml/20230111133228.190801-1-andre.przywara@arm.com/
> >> will apply cleanly on top of this.
> >> 
> >> This fix will also prevent a lot of stable backporting hassle.
> >
> > No need for this, just backport the original change to older kernels and
> > all will be fine.
> >
> > Don't live with stuff you don't want to because of stable kernels,
> > that's not how this whole process works at all :)
> 
> OK, thanks.  Will prepare a patch for stable instead then.
> 
> But I guess the original patch is unacceptable for stable as-is? It
> changes how Linux react to these devces, and includes a completely new
> USB device driver (i.e not interface driver).

That's up to you all.  We don't add new support for new hardware to
older kernels _UNLESS_ it's just a new device id.  Otherwise it's just
better to tell people to upgrade to the newer kernel.

If you split things up and added a whole new driver, then just leave it
alone, no need to backport anything, sorry, I didn't realize that.

greg k-h
