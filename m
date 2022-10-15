Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1CC5FFBD7
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 22:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiJOUHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 16:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiJOUHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 16:07:34 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B273844557;
        Sat, 15 Oct 2022 13:07:33 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id x13so4548546qkg.11;
        Sat, 15 Oct 2022 13:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :subject:cc:to:from:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/ynhneD3j0dnbSPLYCvJs/d10Int+5lPSKHCEwL7c0s=;
        b=lq7wqZRy8VrRcpRgq4ZuJYbmIdjrAljfPMqaxAFeeUWiey5ujd40mtKW69vj7ncYU2
         x2Qegj3iILVktYvjp2IdmJ3mbO2wWJHrKa26hV7UB93wAt7DxWgPHYLH1o1RUM6gn2p9
         zx+zkGPP7Wrzvgsg5hJ/F4TEpwwh5OrwIdzQPPI1Dw5gqh1/4kaVxQC86wb23OsJYDPX
         q5CNNVN7P3Hqwjb7ggTlgDk3ZOT1FE4IwA4GJiUlJIDdlJDzjeDifkNnL8hv4Mk2o/Zb
         gRETxviroj0YsXP7j5NHnjlnGNQXy6MTbypuBLBxoZ0DkLQzov7++dvcYHfR7Rfl36p8
         DaRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :subject:cc:to:from:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/ynhneD3j0dnbSPLYCvJs/d10Int+5lPSKHCEwL7c0s=;
        b=WWaoF+XBGhWELyTAizerTUjKfaHko/w/s/+OBTt/E79Kco0UHbqyyMTEqeZRpkeW7m
         QL7tgr8wmB376IkunbmyojJvqJdxT+Jl4wscFmeTJbwZpAPaOgiH3OQllQ4+84uetq8l
         D/mS2lkwuFKiLd6isJwaAvpGMsd4UnJsFw9sHs4Pnc8+1Feryn6h1RlnA22ZqxFAlRkC
         0t9jY2+mfRnpQS01b+BP7P1z/37s1r7xlvp4DSDz6i52qSxWqQ9cFbZcbmK0JHAEzo+O
         WklSXseFD9fCH0LcZFBWoz3p3ZMgQPG9lFwQNFVR3WUR8gc9EmPjdh5gKRo4nEuCV0ky
         +yNg==
X-Gm-Message-State: ACrzQf131SvRTx0GvegUSBeLq8hfwpZfAYy8Br5EdV5OzuGUc/XHRw2t
        8GBTY1gQ1s5n1vQrshIc4aU=
X-Google-Smtp-Source: AMsMyM6pavQG7/wOjJa0wtDpmpwdHysUIdOEJhmKDSsrx11f0uvWjRBNoOShlM+vq8VlwFWqCLl2Ww==
X-Received: by 2002:a05:620a:95b:b0:6ec:90d2:5fe7 with SMTP id w27-20020a05620a095b00b006ec90d25fe7mr2780802qkw.425.1665864452850;
        Sat, 15 Oct 2022 13:07:32 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:b8b9:b1cd:e6fc:2d50])
        by smtp.gmail.com with ESMTPSA id 3-20020ac84e83000000b0039c7b9522ecsm4815812qtp.35.2022.10.15.13.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Oct 2022 13:07:32 -0700 (PDT)
Message-ID: <634b1304.c80a0220.cedc6.e007@mx.google.com>
X-Google-Original-Message-ID: <CANn89iKJpWK9hWLPhfCYNcVUPucpgTf7s_aYv4uiQ=xocmE5WA@mail.gmail.com> (raw)
From:   Cong Wang <xiyou.wangcong@gmail.com>
X-Google-Original-From: Cong Wang <cong.wang@bytedance.com>
To:     edumazet@google.com
Cc:     cong.wang@bytedance.com, davem@davemloft.net, dsahern@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, peilin.ye@bytedance.com,
        yepeilin.cs@gmail.com, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next] net/sock: Introduce trace_sk_data_ready()
Date:   Sat, 15 Oct 2022 13:07:29 -0700
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220928221514.27350-1-yepeilin.cs@gmail.com>
References: <CANn89iKJpWK9hWLPhfCYNcVUPucpgTf7s_aYv4uiQ=xocmE5WA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 09:19:34AM -0700, Eric Dumazet wrote:
> Second patch adding the tracing point once in the helper ?
> 
> Alternatively, why not add the tracepoint directly in the called
> functions (we have few of them),
> instead of all call points ?

Why do we want to give implementations of sk_data_ready() freedom
to not to call this trace_sk_data_ready()?

Thanks.
