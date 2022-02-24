Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327F64C314A
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiBXQaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiBXQaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:30:11 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD8F1D0355
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:29:38 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id u20so4852012lff.2
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Xa6MAq+rNUf44zva/0KAJya5lpKaHjn2wMQpnlHghgw=;
        b=Yj4+pap66cqOlKxhRjNnfnD8zWcxf9YREa3tXAn3vzk/YeFZpnz7dviOGt7ZAKeb9o
         oMIIIq+A++0UOeejViTbqKHEu26hfJE00VLuqcb4yIu2XjJ0YMycsrtJxk/wsWNyTAqy
         o83gkRGSJlHfehzmD255N8UOuhOAkuvbUK5rvnN1IUCJX+3o1QnZODnLOySkS66Kym7t
         6osWwVorc5sMDjR23T+WRe1wIpWQVe9zInGohVsDMs9An2dkT7JJOiRveHrRFAuLfkXP
         n1+rN8N0bWWRuzL63I3mUuLqXiSIZ9snq4/CaqkDfrRJKyKePWFiHdYr2SDonnJEZO08
         yeYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Xa6MAq+rNUf44zva/0KAJya5lpKaHjn2wMQpnlHghgw=;
        b=iL1ys3cfVpxh6/FggpfVlHexqIPJmJbLEeMvQgnwkERDsX6x5yS30GhQhLp9cDqt4A
         tKFb7KYUESjPRM7v5JPI4UyRpzNe6L/9TG1eZOw61/yvYPpFbPQ9RWgxM/6FyfVTIBam
         C8dSHC4xEkxHCr5xIkM6rCAh1iR5jTiIqpTaOQsOI2xt7AFR3F4v8mNtmMstmHXohB80
         a17q0Phyd90UaLkU37m8KDOHWbHNdDQ8OLZiV9Jq8fKdA3XpAIskFKaFzL+y29/Wftuo
         LS+t+29kl+CUh4GsnC62Nsy7Kf9DAfs3pThuRKGmFmZ2dyUiROjrnGpKzFBIJ29mWBfS
         e7VQ==
X-Gm-Message-State: AOAM532LuwrV4I5UMOIEtHBjv2kbVzd6tAp3LP/TStxwtirWbZxJ93q2
        yl0UYqIMJEPe1wjH8U9UG5c=
X-Google-Smtp-Source: ABdhPJx/XkiYdteZIOnPrgPRLU8La/W/ow6dq1xZtLGnXTkkTHpsswA0KTDy+fmvBAxOJjb9utMCTw==
X-Received: by 2002:ac2:592d:0:b0:443:3c8b:590c with SMTP id v13-20020ac2592d000000b004433c8b590cmr2196604lfi.147.1645720176616;
        Thu, 24 Feb 2022 08:29:36 -0800 (PST)
Received: from wbg (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id m7sm245126lfr.82.2022.02.24.08.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 08:29:35 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1 net-next] net: bridge: add support for host l2 mdb entries
In-Reply-To: <20220224080611.4e32bac3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220223172407.175865-1-troglobit@gmail.com> <66dc205f-9f57-61c1-35d9-8712e8d9fe3a@blackwall.org> <20220224080611.4e32bac3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Thu, 24 Feb 2022 17:29:35 +0100
Message-ID: <875yp4qlcg.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 08:06, Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 24 Feb 2022 13:26:22 +0200 Nikolay Aleksandrov wrote:
>> On 23/02/2022 19:24, Joachim Wiberg wrote:
>> > This patch expands on the earlier work on layer-2 mdb entries by adding
>> > support for host entries.
>> It would be nice to add a selftest for L2 entries. You can send it as a follow-up.
> Let's wait for that, also checkpatch says you need to balance brackets
> to hold kernel coding style.

Jakub, by "wait for that" do you mean you'd prefer I add the selftests
to this?  Otherwise I'll send a v2 with the style fixes.

Best regards
 /Joachim
 
