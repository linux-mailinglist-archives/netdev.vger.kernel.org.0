Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882EF666FED
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 11:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238482AbjALKmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 05:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbjALKmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 05:42:19 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20E7559C2;
        Thu, 12 Jan 2023 02:36:34 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 667195C0256;
        Thu, 12 Jan 2023 05:36:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 12 Jan 2023 05:36:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1673519794; x=
        1673606194; bh=IW9Zp0/sF/1Ckn+yDeOYUE9+fXzzehSr0zbVXxTpuhI=; b=k
        oMNLx8fIWkOqklFBAPfcX6QBzMCWaLQAk6C65gfs5KpP/w3nmNYo7tuDp4hHd+nE
        Qzg42r7kHyDzwwqS4HFvc79+z5Fwg8BjA0NmSAZDKt6GAouh5jNP5swLNXeYuDeG
        3FCFnivtnwzwI/JGkXQpNnu6lEPn8vdekf3imjGMEDbO8eBTBzKKbI1iaP/B1QP2
        uQ3H+IuLt8cfzhNasII1w9OGAv8BY0HYWhYTscMf8f3j0eV4x0ZpaUlDwh9pOrhu
        SzZ9S4IlAjQwHi6WUS4V9oY/E6AI7AalxRvE6MA0UQlljh2+HSG/fktWRgZKFOSz
        kKiyIKXBuQO69lIBPp0fQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1673519794; x=
        1673606194; bh=IW9Zp0/sF/1Ckn+yDeOYUE9+fXzzehSr0zbVXxTpuhI=; b=C
        aPGQb5EAQKz1I5Lj4/NK2Ac5TXAdXWrIa18CMCB1Lc+Erme2Cq6N9B295N6U7Rgk
        akGFxlV6C4Od0LHY56XNXXt805VdHYRci6zvFUcvE5rmd4L/ajwX2vkc/NPMCSqa
        gBjyB05Ya2BkCoRqlqcuDn6Xx1YWFGeSCxEukFTwF4tDe4YneWSA42cU6Duh02Za
        gvEQvmpnnVuweDOAi0qMlDpSwBlABHKMZxldGM2pQ1UPzM5nI2/BBE1e3cSgfznk
        BMfaiQntykffDrIYjLTM0XnoURzaGwdNT4Op6iAZ047cbieBMNeNEX2PeNGLrUS+
        XpO2iAm68u+vbALCvsRWg==
X-ME-Sender: <xms:suK_Y6kIA8cKHDt2kksd3RRahVa0BzuIB1bBJ6lM_opGh0S2qsX6wA>
    <xme:suK_Yx2i1Ee8TimwuFdGWmf3fnFyMyelPdRyN5XBbxYulPo0WIi98G-IDoRVixmgY
    u-0z2AHTGZVPQ>
X-ME-Received: <xmr:suK_Y4psSy_OFHUQDu6CXH0LYJasImyJZ9gfYyY2RWvb2g8utVyLbwqucxsc3gW2VV3amXOe2o1Hs3cnYhUX5bNFv3deHffZxEU7Cw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleeigddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeevve
    etgfevjeffffevleeuhfejfeegueevfeetudejudefudetjedttdehueffnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:suK_Y-mevOZrrzVXmuCQ0YWxmpH2Hzez0RdSD2SwnycQnnxlADsxhg>
    <xmx:suK_Y43DJH4KjbGOwvVdtQL_88pCLYu2VuL1wt8DItisB8HYFWRLrw>
    <xmx:suK_Y1uNOso6JVebYxw9a843LMUTN1zR6HGrVIVYzWAHzbAMbMoBAA>
    <xmx:suK_YxEWeMILbnTu7iginJUJsNO1j3rchj1Qkcu6p0EtCpSz4hBtaA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Jan 2023 05:36:33 -0500 (EST)
Date:   Thu, 12 Jan 2023 11:36:31 +0100
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8152; preserve device list format
Message-ID: <Y7/ir/zcJQUVec72@kroah.com>
References: <87k01s6tkr.fsf@miraculix.mork.no>
 <20230112100100.180708-1-bjorn@mork.no>
 <Y7/dBXrI2QkiBFlW@kroah.com>
 <87cz7k6ooc.fsf@miraculix.mork.no>
 <878ri86o6j.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <878ri86o6j.fsf@miraculix.mork.no>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 11:29:40AM +0100, Bjørn Mork wrote:
> Bjørn Mork <bjorn@mork.no> writes:
> > Greg KH <greg@kroah.com> writes:
> >
> >> No need for this, just backport the original change to older kernels and
> >> all will be fine.
> >>
> >> Don't live with stuff you don't want to because of stable kernels,
> >> that's not how this whole process works at all :)
> >
> > OK, thanks.  Will prepare a patch for stable instead then.
> >
> > But I guess the original patch is unacceptable for stable as-is? It
> > changes how Linux react to these devces, and includes a completely new
> > USB device driver (i.e not interface driver).
> 
> Doh!  I gotta start thinking before I send email.  Will start right
> after sending this one ;-)
> 
> We cannot backport the device-id table change to stable without taking
> the rest of the patch. The strategy used by the old driver needs two
> entries per device ID, which is why the macro was there.
> 
> So the question is: Can commit ec51fbd1b8a2 ("r8152: add USB device
> driver for config selection") be accepted in stable?
> 
> ( Direct link for convenience since it's not yet in mainline:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/drivers/net/usb/r8152.c?id=ec51fbd1b8a2bca2948dede99c14ec63dc57ff6b
> )
> 
> This is not within the rules as I read them, but it's your call...

Ah, yeah, that's simple enough, I'd take it if you send it to me :)

greg k-h
