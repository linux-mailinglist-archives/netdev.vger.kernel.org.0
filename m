Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE3A588F90
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238128AbiHCPmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237368AbiHCPmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:42:06 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157E8638D
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 08:42:05 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id b133so16803565pfb.6
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 08:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1X8iIxmRWAvlqWrXHFS410p03/OzfP/+iRwjFFKXw30=;
        b=IWftbW3+tqW97FEHybyJHufo830Yv1o7rS2J6bHvY9JGN02ViO+au41pbuoPhpI+kt
         pIlRcqa3fWR93PHQ+M1rDFQh64MLMBySAoJBaTEYO0787n9Q/nkuLgnyMzYXTvGANfoX
         8zn3bbh2ccye6cK/z2DWuxim5b/guuR2GxMvusoCYrOEshZxv53RP43qz5ih/KQiPMIr
         1+o1/tVwFwSMZ8oYQs8ZBT4VbAJWX/uaci2i5xbJhCPrYPbBhrikg0zRG6CwCMzjfJFD
         Hk47Wj+IA43z5oOQ5AJRt4eT8DxFhkISwAV1AA6vlhN4uflgzqx7WP513lVZJ3F1+Ylh
         mxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1X8iIxmRWAvlqWrXHFS410p03/OzfP/+iRwjFFKXw30=;
        b=mIM2Vfch330mMRzYtZ91pMmEJAZMZmuXXyyDU0nXpzZwOovovZxofotN8XO4yqSFKd
         epXwcTokLt0Mi9qhtn6E0r0z+hpp8Skxl+gK+j3RAqys1KRQN5RJ5Kw8EdnDeEjPP3Ae
         TOiJm0MfesX64+T9gGtF9mkRjRzJOSXvBi88IRXjqOx36QljgrYjB8phSmeFLuD4YA1p
         OdbTieaQUemHQElujGssfUoW7JdHQJUbmARBr/7QruKZg37JfdPnT13oVPhV8Ly4J0UY
         SHnXwvjBm3+ZVZgAVNWIMsAiFWmVJgZ+Ye0cbTUxYNF6jQrOGu2ZFED+HoiBmSYTSrCi
         HKCQ==
X-Gm-Message-State: ACgBeo24YGZCSAoZw4D1aTjpauF3n/kOn1DcGIbs6G046qh7CfrGEWnt
        27yYBc+W27YNccCUG1I38t686BRgEu0UoLsz
X-Google-Smtp-Source: AA6agR4WsCRzuXEDoWPLWJFb/79WPlwW2sBPFFlB4dv+rWf+Aj+JYBgv7mg3i4CIzGFKZe1uV40rnQ==
X-Received: by 2002:a05:6a00:4306:b0:52e:3bdc:2635 with SMTP id cb6-20020a056a00430600b0052e3bdc2635mr2351247pfb.79.1659541324477;
        Wed, 03 Aug 2022 08:42:04 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id t1-20020a635341000000b0041c30def5e8sm5093221pgl.33.2022.08.03.08.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 08:42:04 -0700 (PDT)
Date:   Wed, 3 Aug 2022 08:42:02 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Antonio Quartulli <antonio@openvpn.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload
 (ovpn-dco)
Message-ID: <20220803084202.4e249bdb@hermes.local>
In-Reply-To: <52b9d7c9-9f7c-788e-2327-33af63b9c748@openvpn.net>
References: <20220719014704.21346-1-antonio@openvpn.net>
        <20220719014704.21346-2-antonio@openvpn.net>
        <YtbNBUZ0Kz7pgmWK@lunn.ch>
        <c490b87c-085b-baca-b7e4-c67a3ee2c25e@openvpn.net>
        <YuKKJxSFOgOL836y@lunn.ch>
        <52b9d7c9-9f7c-788e-2327-33af63b9c748@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 15:16:10 +0200
Antonio Quartulli <antonio@openvpn.net> wrote:

> Hi Andrew,
> 
> On 28/07/2022 15:07, Andrew Lunn wrote:
> > Also, using a mainline driver out of tree is not easy. The code will
> > make use of the latest APIs, and internal APIs are not stable, making
> > it hard to use in older kernels. So you end up with out of tree
> > wrapper code for whatever version of out of tree Linux you decide to
> > support. Take a look at
> > 
> > https://github.com/open-mesh-mirror/batman-adv  
> 
> Yeah, this is exactly what we are already doing.
> We're just trying to keep is as simple as possible for now:
> 
> https://github.com/OpenVPN/ovpn-dco/blob/master/linux-compat.h
> 
> Thanks for the pointer anyway (I am already deeply inspired by 
> batman-adv, as you may imagine ;-)),
> 

Kernel submissions for upstream must be standalone, and any infrastructure
that is only used by an out of tree kernel driver will not be accepted.

The version you propose upstream must have no linux-compat wrappers.
Sorry kernel developers don't care or want to be concerned about some
out of tree project.
