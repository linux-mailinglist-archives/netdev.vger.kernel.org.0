Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B36554BFC
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbiFVOAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiFVOAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:00:41 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6582B36177
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 07:00:41 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id w19-20020a17090a8a1300b001ec79064d8dso13500165pjn.2
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 07:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=wQqwlkEs4Tje0xSx5I5zNIghpeRUIsZ8KnUcEokGHHA=;
        b=eR/xaJNPp7O1H1tPAbirMc6t3i50KEfCWe8uVZCJddlBpmDO3iKc1/FJz4qFfGo6sv
         S5wMSY7bknB+chevWezwVniX2ITvWGqSwdoTeyI74Gj/VQ9C7oTPIZdUef+3EOLv1hur
         nLZYmv85HPBQTW4Vfplc23TtihMd/8LDEuY87b4xcXQKa2tRvAk/yIRAWk85o/407Z4i
         dZrsqnuNKn9FmcZX//sE7STXTzfHZx35SNgE4sKyp8altzwsnNMNx1ZaZq0oxYGFpv03
         64xOKFR1BRytxChhjVpXHT/garCxiaYGPDCsVTNSTohhymQ5fRzXgP1QDJpzDY0FeTab
         CvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=wQqwlkEs4Tje0xSx5I5zNIghpeRUIsZ8KnUcEokGHHA=;
        b=g8w8M/s8w2orl3FL9UCXg+ItXOBPktueFhTMfjCIcgN/VSb6IaVMpFTMzkQihK66fl
         od30rjuMssJ2jt/IgEHM+vpHCCCeQW6pUwEHxm2+rYnEGXyN3pbuwm0KXMrHq2Ae0+22
         BRdiLHCBFLXLjWS1LEvDpZQFhLxV0UEFoXehE1GdUx+srZcIeLpWbXrHODEsiylpTcLC
         HQyzzPwoULRnkU9+gIKmlvlbzxjYu2SZXl9mduRM10NF6UdiHLoxIgwJc/zMnHmQkhR1
         Q5/2qM8A96xD2Ityc73Q57avyVNIUKKa2VlgMrVefE9imFyVSNrR0sNX9DORf56rGJlx
         pmSA==
X-Gm-Message-State: AJIora9GHlsKDkuDSsHNJOjSktzisdU0P3KRtRFj/6jOtFyT45IfOxlP
        XzZ36SHPE3TE0rXwfdc3XIY=
X-Google-Smtp-Source: AGRyM1uQZm7M6vEkMrOO0bE9Zh3Lla0TOrHKZ7LvAUTo3soz+be+lc5UFLL2P1Mj3YCSULxFjuGX6A==
X-Received: by 2002:a17:903:2308:b0:167:7030:6847 with SMTP id d8-20020a170903230800b0016770306847mr33740368plh.122.1655906440409;
        Wed, 22 Jun 2022 07:00:40 -0700 (PDT)
Received: from localhost ([98.97.116.244])
        by smtp.gmail.com with ESMTPSA id z21-20020a17090a8b9500b001e8520b211bsm12207150pjn.53.2022.06.22.07.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 07:00:40 -0700 (PDT)
Date:   Wed, 22 Jun 2022 07:00:38 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, borisp@nvidia.com,
        john.fastabend@gmail.com, william.xuanziyang@huawei.com
Message-ID: <62b32086c68bb_3937b20874@john.notmuch>
In-Reply-To: <20220620191353.1184629-1-kuba@kernel.org>
References: <20220620191353.1184629-1-kuba@kernel.org>
Subject: RE: [PATCH net 1/2] Revert "net/tls: fix tls_sk_proto_close executed
 repeatedly"
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> This reverts commit 69135c572d1f84261a6de2a1268513a7e71753e2.
> 
> This commit was just papering over the issue, ULP should not
> get ->update() called with its own sk_prot. Each ULP would
> need to add this check.
> 
> Fixes: 69135c572d1f ("net/tls: fix tls_sk_proto_close executed repeatedly")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: borisp@nvidia.com
> CC: john.fastabend@gmail.com
> CC: william.xuanziyang@huawei.com
> ---
>  net/tls/tls_main.c | 3 ---
>  1 file changed, 3 deletions(-)

Reviewed-by: John Fastabend <john.fastabend@gmail.com>
