Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97759545044
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344297AbiFIPKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344286AbiFIPJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:09:57 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DE43B1E87
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 08:09:53 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id e24so21639278pjt.0
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 08:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W7zthL8JawVTFaVcJT9IyjKl9SMa/+bSjdI5LUHigE0=;
        b=FHyWDICwhlWHZewo2AQ7jEhwKHuNcLEV6UMdmv2BmhcyVw8NCT8bXM2kckO5Fq/utX
         w1k5Ageq0blDJ5p5rjPztZ0SBMNKtCz47Y0EcaThM0/yiOHme0wzyyBiCTW31fM5Xd+g
         KcJvgaf5nmh9SM8w9rdBOWHXPGzSY8YQH/dR4UTgd8Taz6JEnRgq3acAeC6CqjUNiz87
         5rW56D1KjlummgSOhBOujqVU7bHE0L5rUHs1rKRCa2xOng20RuBFLTkip5KNkusGovvS
         homyfNiUOFKDfY2PEvEvmoOKN3IehpbfgBpkAAMarrBxWgvwy0RgxmdXCzHIcXtWhT6Z
         RCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W7zthL8JawVTFaVcJT9IyjKl9SMa/+bSjdI5LUHigE0=;
        b=QQGoi7k2RYgiOL0IdWVNqGfaW7aVsaTdDy3j+w6eRrpBu5+cRbBQ3460V69CLvKB+1
         kwdIOnmiyNgx7Dck4yETKX/Mrb5dw3sEKnugUEUfBZED2MwkN2q9Nl+xBgsfB9szxMT0
         NFNNpR84poY8Qh7Oz/OW66W2A6qZVzXwnrYyQeyap7f8cecKuagnBKzAqnZvTz666RPz
         H54+TEHwxR8XXekipf/s5Daoyj6mFgX6XKdCbcHyQVp7Ubzog6afl5oPflXTZx+7CSpZ
         rhLNbqlR5imTjEodQsGY/fjGRgsYss2KnWZCrGqFgEup8GF2q9HM5a5I9FcyuWqkrgfA
         0Alw==
X-Gm-Message-State: AOAM533NQd7zOVfD+AwaedFFqptaBfeKK0suIEbX+/WMS3TpUaLm2u/l
        9P5S8S81XQkQ4fhFmvm4ZUBwARw/XtR2AZvBNSOM/w==
X-Google-Smtp-Source: ABdhPJybuAhNhAK8Al5jAabTr4Cp6oLJTqTQFqiumH2uG5mrl9i+KSLSImxxMxkl4hoEBh8s73XmpE7GzINQlinxhXI=
X-Received: by 2002:a17:902:f68a:b0:167:52ee:2c00 with SMTP id
 l10-20020a170902f68a00b0016752ee2c00mr30503592plg.106.1654787392637; Thu, 09
 Jun 2022 08:09:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com> <20220609063412.2205738-3-eric.dumazet@gmail.com>
In-Reply-To: <20220609063412.2205738-3-eric.dumazet@gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 9 Jun 2022 08:09:41 -0700
Message-ID: <CALvZod4ovzrDC-ydT5RKqK0DEdJzqba1nAY21epYWN0T1Mj3Ng@mail.gmail.com>
Subject: Re: [PATCH net-next 2/7] net: remove SK_MEM_QUANTUM and SK_MEM_QUANTUM_SHIFT
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 11:34 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Due to memcg interface, SK_MEM_QUANTUM is effectively PAGE_SIZE.
>
> This might change in the future, but it seems better to avoid the
> confusion.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
