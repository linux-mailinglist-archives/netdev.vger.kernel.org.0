Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB82C4AC7C8
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbiBGRjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243771AbiBGRaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:30:52 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8690C0401DD
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:30:51 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id k17so11718629plk.0
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c3UO1TTRZqzSjjDQY9Mwanici3NZ8tfp3AuhU7oMYuA=;
        b=QPHaqlTiE16WocBPSKB+Lh+Ski0qtk/u+htUzq292AHwqkwfgCqNFPoyzWnzp35sr1
         n78XPElUsjVk+gUGFqDap1fb/7cK7w3cKnLfv/E1GfzCkSjYiGDbS4+eZ00YZIqec36r
         55RYOC2HtBq5z7nfTlvxbqnm0+1d/78bCDNOvtUD+Jznz0Pv/3oQaLKY4fJGfaDokHcs
         m3OPmlwR+CTgXREhrBYj5yishPrXwWxcJrEjBiv+ALyN8E2AYBv2GcZorbFEj/MBHjdb
         i4HFCxGCYrfT39BP2j5Ag0bTWXBwepHMjSv7tZCU5oF3rdb1QaapZIZPlDDy/uKn9Kx/
         hOgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c3UO1TTRZqzSjjDQY9Mwanici3NZ8tfp3AuhU7oMYuA=;
        b=Hd5yHB+Ug+3tyW4xWbbYGlFTvGmp9gMtg5vDP3n431Os/a4AQH64DMxr5CykhcR0PX
         8iyY1sPBPEiMJbd4v+5DCr5b0Yicr1IAgJySMCbjI8SsGS9xokcdwNth+9snh9x/J+JL
         0BXFc0EBVC8Wy65CvwzKtnBsQfnp7QLwHLVuN2p8RY+1vGJqm//M3G6fLytDcpX+ftVj
         3deDUYefDAo8SRySdMcd754VbepADrAdMb5YaSBoDdmpUBqr7Dg1saYFaNx1lSl8pBa/
         XUTF8GL7u9hdRNxvXoTn8ny/9VuhlOiSw32RHdrRHgszn28M9oexa94iTK+Srqv4WlFh
         Nr4A==
X-Gm-Message-State: AOAM532TBQvS4yP/BToXSQrdX8UAP7z5vtxfLirJmkOlr0LxjFpQL9dS
        r63R17fwEYLdNzN2AQSZig24hg==
X-Google-Smtp-Source: ABdhPJybnmCKGPtO8IqhqttCxQi89zitG0at/CJ7JkdPePmN1OOEdHERPm0zX6p8FrnaR53d4x9KXw==
X-Received: by 2002:a17:90a:af97:: with SMTP id w23mr11768861pjq.162.1644255051050;
        Mon, 07 Feb 2022 09:30:51 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id 38sm8878921pgm.37.2022.02.07.09.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:30:50 -0800 (PST)
Date:   Mon, 7 Feb 2022 09:30:48 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 1/4] net: bridge: Add support for bridge port
 in locked mode
Message-ID: <20220207093048.24bb6249@hermes.local>
In-Reply-To: <20220207100742.15087-2-schultz.hans+netdev@gmail.com>
References: <20220207100742.15087-1-schultz.hans+netdev@gmail.com>
        <20220207100742.15087-2-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Feb 2022 11:07:39 +0100
Hans Schultz <schultz.hans@gmail.com> wrote:

> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -532,6 +532,7 @@ enum {
>  	IFLA_BRPORT_GROUP_FWD_MASK,
>  	IFLA_BRPORT_NEIGH_SUPPRESS,
>  	IFLA_BRPORT_ISOLATED,
> +	IFLA_BRPORT_LOCKED,
>  	IFLA_BRPORT_BACKUP_PORT,
>  	IFLA_BRPORT_MRP_RING_OPEN,

Adding new element in middle of enum causes them to be renumbered.
That breaks the kernel ABI. Please add only at end.
