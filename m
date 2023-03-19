Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C7A6BFF16
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 03:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCSC05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 22:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjCSC0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 22:26:55 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42022231EB
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 19:26:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso12937899pjb.0
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 19:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1679192813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GYwkap8ATUCXuqgTA1z6qNYIEawZRaJMjfKaB+5LxK4=;
        b=4fic8rphezRyyU0yV0NV6KAszD7vMBUu59LkO/i6fbUsezMf9ubD+LgBZXLMgaSSZ5
         s/33af6tCU7q8RVjHdNdIuVgTiswsl+K1twEU2exhSytWw4ZCw2c5+8H4gzJ3tG2XEnr
         nCqwpPpDXoBLfCqiwZotf2/44HD6Md5iEQxdFJpquZCT+pQAnAApB8CeJ+EfeE/gZBGE
         4nlYg0KDcZ5svHNt48MqXK5F06O1/Rzw1/xGrC51McjSdgmy+0uK3d7K5OzWl4jumWMu
         0JKBDyuREAI+sTAHMixzaBSkxuis8AE2/EsSlGPwq3jrL9Kowztv05+Pmi+gvXDMSpvw
         /H7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679192813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GYwkap8ATUCXuqgTA1z6qNYIEawZRaJMjfKaB+5LxK4=;
        b=3jdxHgCPIFcK6ZuoN4FGfUS+fSfpmcCl6KOVlPGpdyAC1ogUCEZiozzkVZQP8J0Zi4
         h9gNJAGq5en2mMs7Dg5oJsOQlYcmQ6jOw9tktBd7rS2Jjhynbues+crjhQ8Mhf/vNOBf
         zsfLPL+mJBdGBsUhQ5ZwbK+Nw77PQ+R91lWu8RgEdTH5/opPaB2sDSmsmvb+KjU8F+ob
         DK7HGc881AzffitgalJIBaWdDmLGgE4CNZtyRUXYp0C3YJ96KrikZ+0fHzEjP7cpzKRq
         xO9O6D7JECQK/gYa9r/YZ4xeTILGh9RvCCmAVFyaXijX7F+48L44oiDulFKz3Yy2+wQa
         7XnA==
X-Gm-Message-State: AO0yUKXAftDlsdfA4lTB1+LgoanbrS5wdr4aDztQP+AfSfFQGrISiEow
        yNy4NJc4fr4jJqcL0xgm3bpta4JQhWg4hMlgdyijNg==
X-Google-Smtp-Source: AK7set9QIMOQakuwn1joHdC35AMAMixkGIKte9IuQloYPuHyK08Fm6mN4NTeoKfe6GRRpYwMiNJj5Q==
X-Received: by 2002:a17:90b:4a8e:b0:237:c565:7bc6 with SMTP id lp14-20020a17090b4a8e00b00237c5657bc6mr14775498pjb.10.1679192813599;
        Sat, 18 Mar 2023 19:26:53 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id nm4-20020a17090b19c400b002349fcf17f8sm7215075pjb.15.2023.03.18.19.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 19:26:53 -0700 (PDT)
Date:   Sat, 18 Mar 2023 19:26:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>,
        Andrea Claudi <aclaudi@redhat.com>
Subject: Re: [PATCHv2 iproute2 2/2] tc: m_action: fix parsing of
 TCA_EXT_WARN_MSG by using different enum
Message-ID: <20230318192651.254ecb9f@hermes.local>
In-Reply-To: <20230316035242.2321915-3-liuhangbin@gmail.com>
References: <20230316035242.2321915-1-liuhangbin@gmail.com>
        <20230316035242.2321915-3-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Mar 2023 11:52:42 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> We can't use TCA_EXT_WARN_MSG directly in tc action as it's using different
> enum with filter. Let's use a new TCA_ROOT_EXT_WARN_MSG for tc action
> specifically.
> 
> Fixes: 6035995665b7 ("tc: add new attr TCA_EXT_WARN_MSG")
> Reviewed-by: Andrea Claudi <aclaudi@redhat.com>
> Reported-and-tested-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

Applied but all headers files get done separately by a script
that uses sanitized kernel headers.
