Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8903357A6B8
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 20:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237560AbiGSStL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 14:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238785AbiGSStK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 14:49:10 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7D7558D9;
        Tue, 19 Jul 2022 11:49:09 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-10bec750eedso33112683fac.8;
        Tue, 19 Jul 2022 11:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E4ttxU8+ap0OTMUcEGg/HhKTy2xbEmbewTLmzetmHn8=;
        b=ggi2NZglo9gjhkbv7T+uQTK91MM2KJee6xCbeLQqPNG7qDAFi9IvxG6Lj+Oy7IPA45
         LCK/iOxP9xK7aSccFakylkoiRZRx01PLHMETZN7gBOJkaOlxDO32zAQZ3MfIS878eTID
         jmLcdFujMOoSoNCJCloAyrA4VF6a9zgjiPuWz4xfB8SGZpae3EcKg43t+mxd+4DvR5eD
         /BrMokAYZLbcV7Az0RDydcgilcwMirpZ9f3UNp7hVvQgbrWUeuCtC4XPw8EPUnmdWch3
         eH29hREXGb7SzQFBRnwFSdLttSQJWTSnoNaq79lWBeuuz5Cbb/5WRTiiSTSM95hjSqhU
         Q5ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E4ttxU8+ap0OTMUcEGg/HhKTy2xbEmbewTLmzetmHn8=;
        b=HdLhQt3c6hKOciJMDdAwi31d8uxQSuKOil0bLcBM6UEaBlTSgUNeetUXm21ry8n5uP
         FfMfnj5GhK81NEt8MpBo/wjT9NqBwKbH/ZoSQst+vrkzatcqlj92j3R3MmRnLv/o6D0H
         ZPeXxmXtyAuHdY3YQbBSJ+QmvW8gAW7glLg997iQJ4apOyES80ZFIHR41U/9bToQabmi
         5lm/cOyMuZkppS+MvROpw4WycOrYSkbkKD3Cf2+66Bh8pp1vQZ56CXSry1rc+SSArV+F
         3GLEWa5jivY9oPoWR3GDirjljXaABRwLtuA2DVuNGtlonVqcfJIg7cI05fxsJieD2nq9
         PLTg==
X-Gm-Message-State: AJIora85gTMdOAXK3YpIKd8H3haIJvKZ7acr0mCl34yJkzdqSQ8s/gyG
        Dn3lP9z/hGr9+q6PD3U9G9s=
X-Google-Smtp-Source: AGRyM1toHUuwzZ1J1nDTbjOBul+SZVzVKwx7fUuWX2T06+2BuSEHFJXWXR33wCorf8Jlew7Z3JbFTw==
X-Received: by 2002:a05:6870:73cd:b0:10c:31f9:9f48 with SMTP id a13-20020a05687073cd00b0010c31f99f48mr474773oan.13.1658256549077;
        Tue, 19 Jul 2022 11:49:09 -0700 (PDT)
Received: from t14s.localdomain ([2804:d59:ad0f:1800:4914:cce5:a4fb:5a6d])
        by smtp.gmail.com with ESMTPSA id z29-20020a4a655d000000b004279be23ed4sm6331124oog.41.2022.07.19.11.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 11:49:08 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 7076335AA37; Tue, 19 Jul 2022 15:49:06 -0300 (-03)
Date:   Tue, 19 Jul 2022 15:49:06 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net] Documentation: fix sctp_wmem in ip-sysctl.rst
Message-ID: <Ytb8ouxpPfV4MHru@t14s.localdomain>
References: <0ad4093257791efe9651303b91ece0de244aafa4.1658166896.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ad4093257791efe9651303b91ece0de244aafa4.1658166896.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 01:54:56PM -0400, Xin Long wrote:
> Since commit 1033990ac5b2 ("sctp: implement memory accounting on tx path"),
> SCTP has supported memory accounting on tx path where 'sctp_wmem' is used
> by sk_wmem_schedule(). So we should fix the description for this option in
> ip-sysctl.rst accordingly.
> 
> Fixes: 1033990ac5b2 ("sctp: implement memory accounting on tx path")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 0e58001f8580..b7db2e5e5cc5 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -2870,7 +2870,14 @@ sctp_rmem - vector of 3 INTEGERs: min, default, max
>  	Default: 4K
>  
>  sctp_wmem  - vector of 3 INTEGERs: min, default, max
> -	Currently this tunable has no effect.
> +	Only the first value ("min") is used, "default" and "max" are
> +	ignored.
> +
> +	min: Minimal size of send buffer used by SCTP socket.

I'm not a native English speaker, but this seems better:
"Minimum size of send buffer that can be used by an SCTP socket."

> +	It is guaranteed to each SCTP socket (but not association) even
> +	under moderate memory pressure.
> +
> +	Default: 4K
>  
>  addr_scope_policy - INTEGER
>  	Control IPv4 address scoping - draft-stewart-tsvwg-sctp-ipv4-00
> -- 
> 2.31.1
> 
