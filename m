Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAC4666F4B
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 11:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjALKP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 05:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236952AbjALKNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 05:13:42 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFCD33D69;
        Thu, 12 Jan 2023 02:12:27 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 66E7F5C00FF;
        Thu, 12 Jan 2023 05:12:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 12 Jan 2023 05:12:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1673518344; x=
        1673604744; bh=vEhta7zMZrchbjHApsTWQNVEwRZyW+Qr5Tm1UgjUS68=; b=S
        /cdkq7wd6o/lMcnkf0KzrxSckHt8rkcmgQ/7bjXsCCNu2wzJehxZZiYVCtdHlOux
        b8BGjlNV8lLg/2uyWXuRnZoT1DkepLgH6K71+CKU6lg1tZNSnxD4swoPEHZNN0dW
        AWbTNZfm0EQCBiQ3sMxRPxkx+bYZRbsh8Muf032sbyYjDFkGNMlF4aodoQOzOdGC
        XM81nJSYZMXdYnbhI1s6J7sL1YITcmS/g3SE9aDJyaBFmDM4uWObODbvfYsmPnLk
        Re3E8mJX6Z10tOILlkCVEj+IyuLnq7kp07LFmQkpg0VPboyCaDBHtdLgXdT3837g
        W6Hwk/Ltc0TDiq6N4MoCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1673518344; x=
        1673604744; bh=vEhta7zMZrchbjHApsTWQNVEwRZyW+Qr5Tm1UgjUS68=; b=I
        lC3zCD38qxnJMOfi/LxaGEZbv8L542ffFDUM/e/hNEwyFNW0lISQeSc9qwRCBT1X
        xaiUIaWwaOcnRAPHg3xxKOtz8Olsm2MOfE06FjM23BrSMMgR+6X23pRs9rKVBIzS
        hn8st4/DL+u3p5ZnXMLhxhtGWQi0vCmWrO5ryuHBs5VrwQQ+CmacoJeGkEedVZ1Z
        IF2+xL9r6XSy6tAwdYMjhUuLCyJ65Oi/gd8xVoaxEjrRxDP6H89abA+bsk2InuIZ
        oy/a9FgoySYSlT//wN4csVDM1kmFv6DogVuyNNHshafDzc8aISVUIUvKduDnBN6w
        16S3Buj9r7iWu1tn4RuSA==
X-ME-Sender: <xms:CN2_Y1Zf9ugX6PoAuPFmSkaJlDxDIRQ040dMQOPEOkxkbnZvy4HKXA>
    <xme:CN2_Y8b3y0ms7Jaid71Nj8QidSSn-sHFLEajFBuxI4zxC0ABB64450gFBxC_8wwRF
    9NP0qsgljWveA>
X-ME-Received: <xmr:CN2_Y3-7XMJ9YFJ3z5Ha_hy9cCskGa-EWJjEbMBcTwwvg3ZRPLVExpWm2oI2YdwM2kkQJKlIbS9LzJHx7F6ONmvSaSNZFCjSRYL3Kg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleeigdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeevve
    etgfevjeffffevleeuhfejfeegueevfeetudejudefudetjedttdehueffnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:CN2_Yzpb51HchpD8N9XvcI61SLVuaZ8Qa7m33SHXytDqGr3Bo-U13g>
    <xmx:CN2_Ywq4M10qlLZrTtvWpJMNSgKS9iz0QjQ6D09m7Br1VC4YMaNGyA>
    <xmx:CN2_Y5T0fPyfAy881qb2nX5PcWdBgRkJbM7OeGM41VQQYgqyqqfLew>
    <xmx:CN2_Y-a98dfR5giMhqiLZaWDNahtmJAbtNAAyKA7L_C4J7cycKbH5Q>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Jan 2023 05:12:23 -0500 (EST)
Date:   Thu, 12 Jan 2023 11:12:21 +0100
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8152; preserve device list format
Message-ID: <Y7/dBXrI2QkiBFlW@kroah.com>
References: <87k01s6tkr.fsf@miraculix.mork.no>
 <20230112100100.180708-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230112100100.180708-1-bjorn@mork.no>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 11:01:00AM +0100, Bjørn Mork wrote:
> This is a partial revert of commit ec51fbd1b8a2 ("r8152:
> add USB device driver for config selection")
> 
> Keep a simplified version of the REALTEK_USB_DEVICE macro
> to avoid unnecessary reformatting of the device list. This
> makes new device ID additions apply cleanly across driver
> versions.
> 
> Fixes: ec51fbd1b8a2 ("r8152: add USB device driver for config selection")
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> ---
> The patch in
> https://lore.kernel.org/lkml/20230111133228.190801-1-andre.przywara@arm.com/
> will apply cleanly on top of this.
> 
> This fix will also prevent a lot of stable backporting hassle.

No need for this, just backport the original change to older kernels and
all will be fine.

Don't live with stuff you don't want to because of stable kernels,
that's not how this whole process works at all :)

thanks,

greg k-h
