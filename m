Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7344C50D40C
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 19:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236818AbiDXRmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 13:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiDXRmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 13:42:46 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA7915C3B6
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 10:39:42 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id h5so11536564pgc.7
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 10:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HR5tz53iIuNf13OdJyHnN0TVnfrhlU1o8jqUnHZ4Duk=;
        b=RCVB1q+gqIDU4UjYQwEenJznDYoL+/djn1vY8mqOjt7Gxg4TceGasjRcqtXm96arkH
         7dHvxpIxwfNlq2NROYHU7QTQ+quvDn0nq3aReIxpHrUkuyQVZIJ/tJS1m+MFUD45g9Pr
         t7ZYWpyvYx3fX5LewmzU2Gef1KyNgWx2786q7PlXTA+DMArey3scGNRI1ZRmZJUd3rHf
         lhK/ZQhblY2tLqfLz7/3BdF9lq782KHMidHqnPHAh+B0TPu7wqFAf34qrbOCtpD4suH6
         4JkMVLSdy98dQYhucBk3we3azfkEHY/xBCO7JfEamxBP1PnpINzTZu8UrS/Jyu7IFnVE
         5TeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HR5tz53iIuNf13OdJyHnN0TVnfrhlU1o8jqUnHZ4Duk=;
        b=UtC8iyZ/qlvaYWXx9CEcg6G03H3wAqGe5dpqX8zBeuGcS6ZF8WqJDWaRWQPkKXoIc3
         snpdM9NXyLnzAVTAVpboh0iMA2kFkI4U+pimNWsMixsbOnAJ5Y+YjsnSkm5Ux8RgPSXR
         Mz352xTSy8Asr7bfh8TV355yL3oTF1tUGd12C1IfRPwOI0HUrjz6ZsaVHUEEHywPlpgm
         wcXXIaEHSn1uawl0WapV2MsSroq16akhHRFpbdR1JMai042G0GlbBsIBxxy9FU0iWCw4
         EY5XaYHczESf2MyThqJkX5ilS2jr8xdeccaTDVXFb/OfzgAx85WdAIa/OKDf0DCjg0Uc
         c95Q==
X-Gm-Message-State: AOAM53211oXot0FQZ6KnQzSL2YQ5bF/UD6yWSCFn177m3HbUxzYRBvDv
        CoxHQdgNa88B3Iwf2nfMdiSTSw==
X-Google-Smtp-Source: ABdhPJz5M/aJWVhsZbfj+++2DkYSQyxQNXrpT0sS9/ZpquXOxBVBeR2vdYCghseFlvwOljWOzYV9Eg==
X-Received: by 2002:a63:1014:0:b0:399:3710:f204 with SMTP id f20-20020a631014000000b003993710f204mr12068957pgl.424.1650821982220;
        Sun, 24 Apr 2022 10:39:42 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id h132-20020a62838a000000b0050d3d6ad020sm1285399pfe.205.2022.04.24.10.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 10:39:41 -0700 (PDT)
Date:   Sun, 24 Apr 2022 10:39:39 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
Cc:     netdev@vger.kernel.org, outreachy@lists.linux.dev,
        roopa@nvidia.com, roopa.prabhu@gmail.com, jdenham@redhat.com,
        sbrivio@redhat.com
Subject: Re: [PATCH net-next v2 2/2] net: vxlan: vxlan_core.c: Add extack
 support to vxlan_fdb_delete
Message-ID: <20220424103939.47313976@hermes.local>
In-Reply-To: <22f5fb1d5e592c0deefb246225f66908947a613b.1650754231.git.eng.alaamohamedsoliman.am@gmail.com>
References: <cover.1650754228.git.eng.alaamohamedsoliman.am@gmail.com>
        <22f5fb1d5e592c0deefb246225f66908947a613b.1650754231.git.eng.alaamohamedsoliman.am@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Apr 2022 00:54:08 +0200
Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com> wrote:

> +			NL_SET_ERR_MSG(extack, "DST, VNI, ifindex and port are mutually exclusive with NH_ID");
> +			return -EINVAL;

why not break the line after "NL_SET_ERR_MSG(extack,"  so it is no so long?
