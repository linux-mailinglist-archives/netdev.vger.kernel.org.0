Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621756CC086
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 15:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbjC1NVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 09:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbjC1NVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 09:21:19 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C98A5C6;
        Tue, 28 Mar 2023 06:21:18 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0B4355C0217;
        Tue, 28 Mar 2023 09:21:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 28 Mar 2023 09:21:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1680009678; x=1680096078; bh=JS
        r0mrDFOHDXgzkPvPPgOx/WHcneMZ3MuklnDTjY+Wg=; b=Tf9WxvqQLV0U61wfw9
        C6+IJhMfyBypZeTVOqdrqRRGWff7da677vQIYG/QGjdacDL7iSqRqKbYyE/5NM75
        d/cGNYjBooy/VOSQ2z3g/Dc/kT/UhLRrdU0hYJ2jwLEBR4qxuiQ2zkZkSphiclv5
        TTahJRJ/LVHB377RrAPxcf7aGo4nv2BkS7VumKdQaVkds+huhCK5wQLaSOLQX8wP
        yoQHfrGV07/YmFt0fEtK/BxZhGiJLNBsxY1ZOLTG3O7AYZt7wO9ucds7fkLHwvzZ
        L+Iibzb8sOMg6Q7A6MGMS/1AbC0jMhDGJ2Udq4hg9h//tT1OYi7B8/5TMK61x2sX
        xyGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680009678; x=1680096078; bh=JSr0mrDFOHDXg
        zkPvPPgOx/WHcneMZ3MuklnDTjY+Wg=; b=fRNGwLbCfBeTf5h3FxwslnS55w5cE
        FW+DY9wiP1pJRRNOnArtdjokogu1/wmgXvxp4xHDkto5C4dfTDRu1JQ0Hbw+GqmB
        4mNiowJKn6TBalpwc/EpaNwDBv66XnHBw03Nlln43Pp291akKQlpfGrO+FtDCOGX
        fZtroeg2Cz0K4WWRQ/fD0pZO/WebxN7X1S0MXbzsXwzW6rdrcox1OIgFbgryrDYm
        j55iZSucnV0MVmtlsp7eUiV9X7Kau5UVTcnmqvahXFIJLOGvtQw6Do2lvbErbbUT
        Ag5BXiT/35IDTCw3bz++MsxsHV72+N7W4W26fMAlQsyPUbhq/r0gOwnow==
X-ME-Sender: <xms:zekiZAuROTEWqsI9E6Iu7QB3440PCiR2D74n3j1nG1mrlJ1Q4JNbSA>
    <xme:zekiZNe_7DXZAIokYJ9BV7XPTAWtzeOYgbLiL65tXvfA0yMsda-NVn1Ab7DYQWgHf
    uNrazRga0TOuA>
X-ME-Received: <xmr:zekiZLwwve2pqz16v2IjPZ1ax2mWmsNroRivMqHZwAjsmS0a8WaWnmP_acW7PwcJAbWllbe2pw8gl75gCoMmoX8R4RmWvMlPkOh4cw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdehgedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:zekiZDMUim3X7vXkJWx7xueTWaNLrR818fjcKiSZndscplRgftxFyg>
    <xmx:zekiZA8wOMdSftbSmQrIm5c3XgEA_40Z3QB2MyZ1BSXGp6UxRhCXEA>
    <xmx:zekiZLWM1B5ggDxesW5T4r816CGQ-0hUd9Wy9nx_mKmZvO5keiJcXg>
    <xmx:zukiZANvZmMW3U6X3tUqIwE4rPYL2Ar_Pdl5M5wcnaCz_VygNKcrwg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Mar 2023 09:21:17 -0400 (EDT)
Date:   Tue, 28 Mar 2023 15:21:14 +0200
From:   Greg KH <greg@kroah.com>
To:     Dragos-Marian Panait <dragos.panait@windriver.com>
Cc:     stable@vger.kernel.org, George Kennedy <george.kennedy@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.4 0/1] tun: avoid double free in tun_free_netdev
Message-ID: <ZCLpysWGJo_4-iEK@kroah.com>
References: <20230328124628.1645138-1-dragos.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328124628.1645138-1-dragos.panait@windriver.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 03:46:27PM +0300, Dragos-Marian Panait wrote:
> The following commit is needed to fix CVE-2022-4744:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=158b515f703e75e7d68289bf4d98c664e1d632df
> 
> George Kennedy (1):
>   tun: avoid double free in tun_free_netdev
> 
>  drivers/net/tun.c | 109 +++++++++++++++++++++++++---------------------
>  1 file changed, 59 insertions(+), 50 deletions(-)
> 
> 
> base-commit: 6849d8c4a61a93bb3abf2f65c84ec1ebfa9a9fb6
> -- 
> 2.39.1
> 
Thanks, now queued up.

greg k-h
