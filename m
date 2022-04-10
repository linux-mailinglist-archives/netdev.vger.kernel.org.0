Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F874FAF24
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 19:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbiDJREp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 13:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiDJREn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 13:04:43 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373DD4DF5A
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 10:02:32 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 274073201F32;
        Sun, 10 Apr 2022 13:02:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 10 Apr 2022 13:02:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=v5Hrjiv0Yk5B0jF+0
        QN7pX0yYPsJFcyC4sVsIi+VRg4=; b=b5SCZdcZcFp+D6uRVGSlwPao8HeyjLrI8
        pxfdxSunV+jYpDq7x4OM2djZ4z2kk3PMf+Da6tSHRkuxbdbaNtZ0vR0Nqnl/uQdb
        XEtvzGmxizYIDL8YWo+v/C+AvSpTyGQ0vm4yGYFVl0WpAfrCWWscvKfctTgVjo8s
        q3A2ZH+pcCIrcxGBZJbks+CRRmZAi7xgd3ghVLG6lRqZGvtY+U99QN1770LaUpgO
        Y5fompKW1L42JnAi2EN1RFLR6SPkqBPPsqcDGEcvYVjlEURIEkNPzsZoQ+kcEvfK
        +Az59crrFT1fVOhuHC/7ITzYHObo7fpoeBZNaFuWZ/v2r+yX8AXvg==
X-ME-Sender: <xms:pg1TYjd0ej_dnjwPzRyL7rXY3ymBYwARGsZ1DNOW7c3F0tXBYpg8rw>
    <xme:pg1TYpMBNyh6DnLkkvki6je95SHG4FEibTQhjoX2CzOcmq6YerfsuHU1nu9eazjxF
    EpeVWsjrfq7qrI>
X-ME-Received: <xmr:pg1TYsgVum-yofGOLjO_FAaT13tw9QETnmfU4IiaGG4xriUOVx6VIKZAaSix>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekgedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:pg1TYk9iEIsl1ou4pI-LQRFRx3tJJY6Pga8hO9dlBjisHa6wK21ejQ>
    <xmx:pg1TYvuZZE093PT5ismCtXwNTxpFX_bTN4J84KO1HyA4rKuiGE1eag>
    <xmx:pg1TYjGud3QTT1sUN9U7BkKQ-j_w7tHaNkMnXbhhDdWi4e_DMrL50A>
    <xmx:pg1TYo8WAG2z_T0iLV2doZ4V9vdCSRHs5RB3H4-tIrIdaJMRIzC8Xw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Apr 2022 13:02:29 -0400 (EDT)
Date:   Sun, 10 Apr 2022 20:02:27 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH net-next 3/5] netdevsim: Use dscp_t in struct nsim_fib4_rt
Message-ID: <YlMNo/4w7X2ls4Or@shredder>
References: <cover.1649445279.git.gnault@redhat.com>
 <1f643c547fc22298afe21953492112de9b9df872.1649445279.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f643c547fc22298afe21953492112de9b9df872.1649445279.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 10:08:43PM +0200, Guillaume Nault wrote:
> Use the new dscp_t type to replace the tos field of struct
> nsim_fib4_rt. This ensures ECN bits are ignored and makes it compatible
> with the dscp fields of struct fib_entry_notifier_info and struct
> fib_rt_info.
> 
> This also allows sparse to flag potential incorrect uses of DSCP and
> ECN bits.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
