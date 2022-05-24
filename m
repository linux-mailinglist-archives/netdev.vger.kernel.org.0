Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38B15326C8
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 11:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbiEXJrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 05:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiEXJrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 05:47:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F92B6D1AA
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 02:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653385666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kJizB8cilvx7WM1xbQjrHpiaKzIJr9by3JAA2+yq6ms=;
        b=YpJz0Qz6+EGo0+hsIwUJNJw2lqtimPAI+QOrCbhBonfhUuzk9AalDanDNP2duvuMmDouBb
        bF7Z8GKSXlThUchFOprRWYDGIu7m+jRxTpFSDNvhvxPiuOgt+P9I5QwfuxiGqUuV1UMQ18
        R+GF/xvMHmmT5IMK7ZNsUeAuFoj0gaE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-WEPGnh_7OKyPvdyLkuI3Ww-1; Tue, 24 May 2022 05:47:45 -0400
X-MC-Unique: WEPGnh_7OKyPvdyLkuI3Ww-1
Received: by mail-qv1-f69.google.com with SMTP id ck16-20020a05621404d000b00461bcafbbe9so12884093qvb.23
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 02:47:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=kJizB8cilvx7WM1xbQjrHpiaKzIJr9by3JAA2+yq6ms=;
        b=nMIlEBbXRpvu8TNF3E4dkDA7ey1hWPRTKmXWHO3WfNTo3wODRsdfpra4DYq5z+R/Xj
         gjPelBQScc2RKYs9ZcZcZwblhywrFLlXEouqLxlfekEbHVEyFMzr2RTejt8vdgt0Hyfl
         2U/Iso1Lc0wVY+swh1W0OetGwCqxww9OZlr3VJU6KyYF2UcyOtKgu85LzZq7sSXFln1m
         E9Qcw+S1EuMVAwS2l9dcNioGwR1jZ3CUv7fcj/aeavOgk21JaEz7iYX8RFFdWyflqQCF
         mqlohVI0O8HFPB0JC7ivvgMTSVR7VGbN6eS3rdw8xH9JMNMDfY+cTekPJ/kO07Kfdfbl
         ucuA==
X-Gm-Message-State: AOAM531pdUlyymNhlnQp5JVN+Xm2fXed+dDlxE4p9859YnVHmtDZVHwB
        huc8VbunQvHiNYuX2+b9uh2MZpnRUorve3jjB+/3YRExbPg9XKwfI5ee3kK5HgAzsHCu68SwFHb
        lQq+ctI0qHuRLGbGJ
X-Received: by 2002:a05:620a:2a11:b0:6a0:4ae4:fee6 with SMTP id o17-20020a05620a2a1100b006a04ae4fee6mr16921308qkp.30.1653385662471;
        Tue, 24 May 2022 02:47:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytLcgsxRyWXWH81uLhpAyCSzF7sa+wf8chx/CfSbmKiy2lXfUV8W54LeOhvuzxrNdA9/jszQ==
X-Received: by 2002:a05:620a:2a11:b0:6a0:4ae4:fee6 with SMTP id o17-20020a05620a2a1100b006a04ae4fee6mr16921297qkp.30.1653385662198;
        Tue, 24 May 2022 02:47:42 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id q10-20020ac8450a000000b002f3ca56e6edsm5812190qtn.8.2022.05.24.02.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 02:47:41 -0700 (PDT)
Message-ID: <ffef5b7a784abd8c9f46930f7479149f348aec73.camel@redhat.com>
Subject: Re: [net-next PATCH] octeontx2-vf: Add support for adaptive
 interrupt coalescing
From:   Paolo Abeni <pabeni@redhat.com>
To:     Suman Ghosh <sumang@marvell.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, sgoutham@marvell.com,
        sbhatta@marvell.com, gakula@marvell.com, Sunil.Goutham@cavium.com,
        hkelam@marvell.com, colin.king@intel.com, netdev@vger.kernel.org
Date:   Tue, 24 May 2022 11:47:38 +0200
In-Reply-To: <20220523115410.1307944-1-sumang@marvell.com>
References: <20220523115410.1307944-1-sumang@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2022-05-23 at 17:24 +0530, Suman Ghosh wrote:
> Add ethtool supported_feature flag to support adaptive interrupt
> coalescing for vf(s).
> 
> Signed-off-by: Suman Ghosh <sumang@marvell.com>

I'm sorry, but net-next is now closed. You have to wait untill it
reopens and the re-post.

Thanks,

Paolo

