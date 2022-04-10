Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C834FAF22
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 19:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbiDJRDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 13:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiDJRDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 13:03:41 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349E548383
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 10:01:30 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 581AE3201DD2;
        Sun, 10 Apr 2022 13:01:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 10 Apr 2022 13:01:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FaCAmOomb3TpRnPv6
        cIb8raTfVCz0LJepNMkg3hXWPY=; b=RPuQ+sCAIcIo4j87+rNCqjWJE7XrwCiCw
        yVi/Gv4VOrl0l01a9tetElJPwx8mFGJjMzcJXMWafjKHNyHnv2Fsv15hTQPdPKLY
        iK2yMU1wGeDpk6Yji5rBcSKkqiOFVPXa+2oLBfbrPJNxV3wzf16mLFPP2/rs4Em1
        33iZ18PdnArl7GVc16OvCzRPiELImiggkN4WZb4ljARxeCT/oh2OptUqm8iY47ML
        a5wnYL5EEtcPVIvAbK0l8f89AdNxC6mF/UcO7DS1hVme9IpJBYyBeuWOkriJ1WXd
        TSimEoSi+eV1qrKYdmXHGF7oPQOOxxyE2C02IsUGNtpZwYFleHsdQ==
X-ME-Sender: <xms:Zg1TYnmlje0yKztHP5pYCMPCqFI0B7LA0n-cNyVYrtJ88qVPINe2og>
    <xme:Zg1TYq1GfCmqYAci9MkrUQMmt1vVVOqEu0a2FZ8BoC8OrhXHFTtwlx7k-3LzFX28k
    QpyVTKPsyvGCMQ>
X-ME-Received: <xmr:Zg1TYtrdRXZw12GG8Rn8GUr823s9pfb8N35YFLIgxmjskFKxTqFtScryx_HK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekgedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Zg1TYvm97PaTWX-vqSvxyOsh7YdzPfcMays62mB05RSzhQDYE1N-wg>
    <xmx:Zg1TYl1dSiFhhnYMCRoEiimf5AQUz4jH_F-AeNjVnW05PjAuM9PrYg>
    <xmx:Zg1TYuvqLTUfAoTI7H6dj0vF4JvfIE4a7yfLm8_85IwS1nECn8wkzA>
    <xmx:Zg1TYinW6Fl52h6T5Q690Wke5D3ZKS2zAExsj9G98RF-1OtXmJqE3A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Apr 2022 13:01:25 -0400 (EDT)
Date:   Sun, 10 Apr 2022 20:01:23 +0300
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
Subject: Re: [PATCH net-next 1/5] ipv4: Use dscp_t in struct fib_rt_info
Message-ID: <YlMNY+kRG5x2FZUu@shredder>
References: <cover.1649445279.git.gnault@redhat.com>
 <027027eb31686b0ea43aaf6e533a5912ca400f21.1649445279.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <027027eb31686b0ea43aaf6e533a5912ca400f21.1649445279.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 10:08:37PM +0200, Guillaume Nault wrote:
> Use the new dscp_t type to replace the tos field of struct fib_rt_info.
> This ensures ECN bits are ignored and makes it compatible with the
> fa_dscp field of struct fib_alias.
> 
> This also allows sparse to flag potential incorrect uses of DSCP and
> ECN bits.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
