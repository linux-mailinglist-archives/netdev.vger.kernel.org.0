Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272786D1763
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjCaG12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjCaG1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:27:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1090D191E6;
        Thu, 30 Mar 2023 23:27:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8842D62390;
        Fri, 31 Mar 2023 06:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B1AC433EF;
        Fri, 31 Mar 2023 06:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680244038;
        bh=1sBaK8RSiGcspl393mzRvxzx2GvhtJ91ZCiHzkqJ7oI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RWEWg0JWex/JsHC6mZ4yxVTF8v6obKBM5VH2AmqarAqbw32WRt8AHvBgVwv8mymfP
         m93Vxxk+80Q13ciWB5Qde8LTqZqgNxhu74K0eRz/0GyPYBknL4lJX4LRN3jZ66h5Am
         qU6cYk4j3rv1ru8/oC5+uMeP6Mlhyxlf+Rj/NdgtzSdVen2dSnl3b5AQNUenAtlEfW
         ML/tmc93JctSkoeMX9Mwfvhb2CucrlJltGMCOC8DrohdnEtQ4asm1gCbVvXptkuvVt
         ECAc7nJgmlgzv6obOkWqq01quCkYEoXR8lf0RE41annLZRP0NTuCqIQH6bHpA2OyFV
         4RCgcylkMRemQ==
Date:   Thu, 30 Mar 2023 23:27:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>,
        Liu Haijun <haijun.liu@mediatek.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: wwan: t7xx: do not compile with -Werror by default
Message-ID: <20230330232717.1f8bf5ea@kernel.org>
In-Reply-To: <20230329102640.8830-1-jirislaby@kernel.org>
References: <20230329102640.8830-1-jirislaby@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 12:26:39 +0200 Jiri Slaby (SUSE) wrote:
> There is no reason for any code in the kernel to be built with -Werror
> by default. Note that we have generic CONFIG_WERROR. OTOH, some drivers
> may want to do this only on per-driver basis. Some do
> CONFIG_DRM_I915_WERROR or alike. But I reused the scsi's:
>   ifdef WARNINGS_BECOME_ERRORS
> approach.
> 
> Now, if one wants to build t7xx with -Werror, they may say:
>   make WARNINGS_BECOME_ERRORS=1

As you said we have CONFIG_WERROR now, so I'd vote to delete 
that line completely.
