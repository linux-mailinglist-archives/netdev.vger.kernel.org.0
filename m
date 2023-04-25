Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8D16EE76C
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 20:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbjDYSOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 14:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbjDYSOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 14:14:18 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B472D59
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 11:14:17 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a66b9bd7dfso64988015ad.2
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 11:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1682446456; x=1685038456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S29jD9asq8GIhNQQpmkJfSN08f/B/+N3c1+vpXFLXzU=;
        b=iSOOO/lFlDg/Q0UDXbM97TusZYsL7T9b4g+P3bJXaWVlQ1fXuH8ymssdTd89l210O1
         hQZjt0Fm3QDpw2qa2ygoH3aOhZHmW8rhud8kSC5MXg25IlK8Gxr9lUAzdu7FfLI17fLn
         7jRFmw5c/Ci/tIwjdvPezRh8XdHWuDUXnjP/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682446456; x=1685038456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S29jD9asq8GIhNQQpmkJfSN08f/B/+N3c1+vpXFLXzU=;
        b=lDLdSVPtjzyV6bnRSyUlQVihT29lfcQpqoDSNFJeV9nBYBr12T8x+0W1EEkFRAuzf1
         DmuCn3+gdTluDOd3zxIjun9IjCFQs5i7FaGUHqweqkhV06MbxerqfbDBOp10SBxbf1TQ
         RiSYsDadBLLs4mK1nYq68g1MKTLGL66BO6hIJb+OlA+rKaPmpn9PiOXlRqQfcExvB/VV
         GG9DLQ8uxtCDvwcqZn63UsLALjKA/lWsGyXWMssBuRyxLSZZwnY0xdt4bh6cdGQuxCkN
         JDFNaJvswqWH6HH/Hc2ftW3FDrK5PBYjcZq9RJ5x/D8j6E++Ff4fUSpFQpd12yVWR2tm
         HfGw==
X-Gm-Message-State: AAQBX9fHKLmaw5vvema5Fv8ufvOXKo4cFLtohMZkcfe4toXNBVcaXJBP
        ug0nzXb7aPl2nyzVvWQpp2c8Tg==
X-Google-Smtp-Source: AKy350bBKSRyeKYxPnCoHGmQ52eFx1f3KiJmb5Jz9UAUMPiw7Ej7tb/MymZFjaYRtjvbLyQ+MSgnYA==
X-Received: by 2002:a17:902:d501:b0:1a6:c67f:4ed with SMTP id b1-20020a170902d50100b001a6c67f04edmr22884799plg.9.1682446456654;
        Tue, 25 Apr 2023 11:14:16 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:802a:e8a4:2d43:e3a1])
        by smtp.gmail.com with ESMTPSA id z12-20020a1709028f8c00b001a27e5ee634sm8608147plo.33.2023.04.25.11.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 11:14:15 -0700 (PDT)
Date:   Tue, 25 Apr 2023 11:14:13 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Tejun Heo <tj@kernel.org>
Cc:     jiangshanlai@gmail.com, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 10/22] wifi: mwifiex: Use alloc_ordered_workqueue() to
 create ordered workqueues
Message-ID: <ZEgYdSOYaojJBoPP@google.com>
References: <20230421025046.4008499-1-tj@kernel.org>
 <20230421025046.4008499-11-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421025046.4008499-11-tj@kernel.org>
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FSL_HELO_FAKE,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 04:50:34PM -1000, Tejun Heo wrote:
> The conversions are from
> 
>   alloc_workqueue(WQ_UNBOUND | flags, 1, args..)
> 
> to
> 
>   alloc_ordered_workqueue(flags, args...)
> 
> which don't cause any functional changes. If you know that fully ordered
> execution is not ncessary, please let me know. I'll drop the conversion and
> instead add a comment noting the fact to reduce confusion while conversion
> is in progress.
> 
> If you aren't fully sure, it's completely fine to let the conversion
> through. The behavior will stay exactly the same and we can always
> reconsider later.
> 
> As there are follow-up workqueue core changes, I'd really appreciate if the
> patch can be routed through the workqueue tree w/ your acks. Thanks.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> Cc: Ganapathi Bhat <ganapathi017@gmail.com>
> Cc: Sharvari Harisangam <sharvari.harisangam@nxp.com>
> Cc: Xinming Hu <huxinming820@gmail.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  .../net/wireless/marvell/mwifiex/cfg80211.c   | 13 +++++------
>  drivers/net/wireless/marvell/mwifiex/main.c   | 22 +++++++++----------
>  2 files changed, 16 insertions(+), 19 deletions(-)

These work queues only ever get a single work item on them, so
"ordering" can't really matter. This could go either way -- a comment or
the current patch; so:

Reviewed-by: Brian Norris <briannorris@chromium.org>
