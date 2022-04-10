Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614B64FAF26
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 19:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240713AbiDJRFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 13:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiDJRFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 13:05:14 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101FF4DF5A
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 10:03:04 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 026EF3200E42;
        Sun, 10 Apr 2022 13:03:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 10 Apr 2022 13:03:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rBySSrHHSGhToG9ed
        EZ+GEC7x3nJzGv6GVqQOIXJtWQ=; b=eR+pvyowHRbP3/r22fU/ZEosN/gVNWYY3
        7uiIW0d2p3QdYFLquRyGgzNVDUgddDeNpBI6KsYM2G9s1dGW3FYDyHYePrbx156v
        RjpvrwyGG+0EGsRzBlzn2Y3ZA+AtQH7f7UfuK0S0shOfNwnZd4KXxsNpP6Hv0wK/
        wh8arvhbdVREdOtDvk58RFOa7NRSLXLcyI6l+VKDKTJw0MGwVQ+DupuCw/fcRzkA
        hh6CUIVauSXxK4umqCe05Fj9tUzm9AtBrU57vcVuT9YHFeJaE667PwgBI3vXTBSn
        moyd5ALNkMAbSIk+cQpLmW0b2gvAOyOhndMjDKoKsadUaia+sNhhw==
X-ME-Sender: <xms:xg1TYmx9V8hZOSCvm4UoYH2hUoUxoft5gNihRBs7WeLAlQpRi6Rv1w>
    <xme:xg1TYiSLdXdhoRgR9sMJrM56hKDXc5vxLMx0SQJ8CjNNyd9TiZJfplSHxkYnl9o5P
    _ZvnogL32s4lhs>
X-ME-Received: <xmr:xg1TYoXunuyhoN8qcCh4rFWTlVmpGNozd1vDYstkLd1gQD4_OrqXXqj0gf0U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekgedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:xg1TYsh4dgfWANW61obfVE5y0Hiy1CHykjCfplvN4GhTQ8svG-kUyw>
    <xmx:xg1TYoDhmKIgGxFjD9ENZZfnJQnG74bj4DWWGjQoYxEcCVZy7StPhw>
    <xmx:xg1TYtKfl_gGySWKXmcy9wWkWrmUZXAwqhSVYDaQIqertFA87BnRoA>
    <xmx:xg1TYmAmqL7tQA2zvxbEsPfcXjw6j4B9PXijZ7uYQ5M8nL3OIDrasQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Apr 2022 13:03:01 -0400 (EDT)
Date:   Sun, 10 Apr 2022 20:02:58 +0300
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
Subject: Re: [PATCH net-next 4/5] mlxsw: Use dscp_t in struct
 mlxsw_sp_fib4_entry
Message-ID: <YlMNwt5mFcqSZM8B@shredder>
References: <cover.1649445279.git.gnault@redhat.com>
 <f7a376abaebd90e07853498c084ea2282ff1744f.1649445279.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7a376abaebd90e07853498c084ea2282ff1744f.1649445279.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 10:08:46PM +0200, Guillaume Nault wrote:
> Use the new dscp_t type to replace the tos field of struct
> mlxsw_sp_fib4_entry. This ensures ECN bits are ignored and makes it
> compatible with the dscp fields of fib_entry_notifier_info and
> fib_rt_info.
> 
> This also allows sparse to flag potential incorrect uses of DSCP and
> ECN bits.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
