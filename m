Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D54E57D541
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 22:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbiGUU4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 16:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGUU4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 16:56:12 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CE68FD74
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 13:56:11 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id z18so1982059qki.2
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 13:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yri+NdM2tEeuB8jYT/moyjQf+8pMf3Es1U7Cbr47hBY=;
        b=fbXAooqtN7BAzu55vnj2PY1f9CiFHmno6gRPQwbpDd7TV3UAOzOmAZFMDXaaLzOmpd
         4ufDmFy5TaH9vEdfEecPDaLS+B7N4mIY+LnBJFSzpE2ReSJm+Gz1mONz5pGLWuRGYTHw
         CSSLbPYSvu79xl32t1LffMTw8BP9/FDOlGVIPRNAYhX7ElD0OvYosDJ3cXWGzAmrRGL2
         BuPXqJ6uOgyBg7fcB7HcOMoSUd6P/C/iYokzTGStO4itKQs0DFxR9ABYaDH9mmD/LjpB
         O1HyDMamx7o38dmxGhYMmmUkIEHWA6RqVuwBhjNwNB9LltBiS3Y6uV9KPMa0AyMsruKA
         EKHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yri+NdM2tEeuB8jYT/moyjQf+8pMf3Es1U7Cbr47hBY=;
        b=TYQ/PVCx0sQaKX6HLfW0zXzB/XZxaRhk24EoIpMVT7Jtc9SXXl/naVKDpUb5bFEbvK
         yn7ppPaEDKIrQ2FjivzoLFgmnlp08ZytwkQgGSiN6OI1hfVQs7aJIj3sCCeQI7g0zgE9
         H6pgri1cUOFUwI6j+V1DFIAbJz3wg4ZE65AYll56eiw4PV+KJxBE4PDnyodmyEJfjQ7Q
         kpFOcnlOJKOFqYs08nqRN/0bvyC6z8js0xEX3psSPEbT2Y5N8wo3gZJKQiPvZFgvkwsw
         rpAvseNbq47DHPpZPcU0tWjHLnr8mMNToiXhE5+ko4jQhYYIA1mZclKM86GiXWNqRxNn
         xa0g==
X-Gm-Message-State: AJIora9/yYUN27XAVMtcrV/R+zEeTRVl358BeEtEgUz6JGClOrmYWbwr
        gQQAAN3+Kie84C6f7W9DEQXEXj++a7kWZoNHTrOT9LN1Verfkw==
X-Google-Smtp-Source: AGRyM1tZKvM/sEZIKkjihxEJFclSDhyx5MI9S61ynlatHo3yv2fqk6mt/8fxSNVP4W28bnCzcQRb5rWOf+QL1igyeXY=
X-Received: by 2002:a05:620a:410c:b0:6b2:82d8:dcae with SMTP id
 j12-20020a05620a410c00b006b282d8dcaemr234781qko.259.1658436970947; Thu, 21
 Jul 2022 13:56:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220721204404.388396-1-weiwan@google.com>
In-Reply-To: <20220721204404.388396-1-weiwan@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 21 Jul 2022 16:55:54 -0400
Message-ID: <CADVnQy=5VzKqUSyQG48rfYPsS1cyHAW3_bZpvJfCs6AAxjPVQA@mail.gmail.com>
Subject: Re: [PATCH net v2] Revert "tcp: change pingpong threshold to 3"
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>, LemmyHuang <hlm3280@163.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 4:44 PM Wei Wang <weiwan@google.com> wrote:
>
> This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
>
> This to-be-reverted commit was meant to apply a stricter rule for the
> stack to enter pingpong mode. However, the condition used to check for
> interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
> jiffy based and might be too coarse, which delays the stack entering
> pingpong mode.
> We revert this patch so that we no longer use the above condition to
> determine interactive session, and also reduce pingpong threshold to 1.
>
> Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
> Reported-by: LemmyHuang <hlm3280@163.com>
> Suggested-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
>
> ---
> v2: added Fixes tag

Acked-by: Neal Cardwell <ncardwell@google.com>

Looks great to me. Thanks, Wei!

neal
