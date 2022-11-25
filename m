Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2D26387A3
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiKYKgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKYKgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:36:47 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC84E31ED8
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 02:36:46 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 161645C00FC;
        Fri, 25 Nov 2022 05:36:46 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 25 Nov 2022 05:36:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669372606; x=1669459006; bh=E995JdiU96IdNLXCGxPGVn+cSyz4
        UlpU2nd7Te9v38Y=; b=IW0oz82dv5/yDVET/dsxA3gLFifKVr4cREnQZa0d99HX
        jFweX9okdyC9WFebWS4r5Z1yKKqAnmWqWElpDo2N+0W4VP/qrO4+RHZoZodOSNUO
        Ue543YwCgA49DWotpcFAk8k/7aEUNtHpySn7DwwaZeHniYEFraczfwmcBC/3xILU
        aThbRS9tFoQj4mqX6UMX8Wg1ocoOgm1TBJPiBWXWDwGOqbZNDl+mz449S/DAv1Fm
        5WSTnlKf/Tw2JkN9aAopmxqT5nvkLa+f+E2GcRjCdPz4hJ5gC0Mg6n50ZPSQ78vt
        kRuPBSOSPbkOSU5l3M6DeqUH22i0d8eIo/Y40iONzg==
X-ME-Sender: <xms:vZqAY3L_iuyo_ae-kHv4nv4m1U6pVvFIgZFEmQeHafMSCeVGuvbfeQ>
    <xme:vZqAY7JLvTlBDPubP2JWR2zq-GT62gRusoTffxvZEEWTKgB-T7qgf7I77RpHS-h6l
    m2ozxJt3Gd-QJE>
X-ME-Received: <xmr:vZqAY_t-E8PgQZuTSN82RZvFOdFtlUuDdnI_PGO6WTDNnB7EYeoORmkrVkBlp-wlrerqzziCTgpzkv2e75r3e-pPtXE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrieehgddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:vZqAYwb_qZENiFCDfr7eemRpzWFE3XNM0j6eUZ6ELI3c4o_EKUpkfg>
    <xmx:vZqAY-a9TEofEkXZRv3NBu2i49BPleXjWbELZTHvhIlBs_KRi-ebPw>
    <xmx:vZqAY0AbOJrL2Dr5BGyHGhxyokTwcQ9Fic5g5cM9GZdNSD8LGsm0pg>
    <xmx:vpqAY-GoEFArs5ULQA7mtoJNa0qyswgFMZIDwzq3GQgfDdXzslZg7A>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Nov 2022 05:36:44 -0500 (EST)
Date:   Fri, 25 Nov 2022 12:36:41 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: Re: [patch net-next] net: devlink: add WARN_ON_ONCE to check return
 value of unregister_netdevice_notifier_net() call
Message-ID: <Y4CauRkw4xK/qy0p@shredder>
References: <20221125100255.1786741-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125100255.1786741-1-jiri@resnulli.us>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 11:02:55AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> As the return value is not 0 only in case there is no such notifier
> block registered, add a WARN_ON_ONCE() to yell about it.
> 
> Suggested-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
