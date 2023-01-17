Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF30466D6C7
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 08:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbjAQHTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 02:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbjAQHTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 02:19:35 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770882279A
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 23:19:34 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id h192so21289946pgc.7
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 23:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nd5hrW7yCGGI7UG/SOmtBZCUk5tyqgpbkntx81y9hSg=;
        b=K4SNCpHGfhoez11jTfuEJK09YGY0GizT4XWw1i2Y7sLq53iqNLcZQcZPJe3p7CNON7
         ihr68juP+WLn1ksXk1ar+Gal0yBu5K2HCAjgURvj/M2xWKa3oWQVGDCu4JFoocgvAJAU
         90HkhJjOXIYcpUsjLRLaqVSBqqhHvOgNjMcTeZW2KUbwN3HNZ+Tm/Bs3XM0EXrbINCko
         tQGzYq1Z7BawPhIxOslNmDmEMqW4wGxYWGLx9HdmztZcreBCZ0KXB2lISR2J+rwjMKCp
         X5+poGMdumIQhy8eALmzSs1uOQ5MLZoZ8HjLg/kos8fc9PMF/yB0yKvMcNFiW4NUQoWb
         X3oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nd5hrW7yCGGI7UG/SOmtBZCUk5tyqgpbkntx81y9hSg=;
        b=1ZmkC7YCKKsFmNHJb8MpWK6ZeTk50DFlXeA8aTk2LxsGcPFtpR/7bhhRMlOlXYHqgp
         hxwBYnaVtxSR+gwrG3m4F87nwvSIjX70JnvYLDAryp1uksJyW8vjJroktQuHXBXZbUOS
         H9fkXOVdX3YXDkukN2+I075FymSjPpWjdPhgQaXu4IncsGTDuDkt6LPTDREJ18ovMPzr
         PXVm4apGzoUq155w+80WxbXu5tcT1moeb9Q5mH1khCaEvwqQ7Nhv2/7WfJgGbCC7/8Su
         8cay5Hpyko0RuFaimXVD83yu/o5NzSz7yQolwy+oZstKlmn/rBg+sXrOGnPtcI/COoXh
         LVIw==
X-Gm-Message-State: AFqh2kqSW30r0v4s5vvrXNwXWO/Rt1LUaMrBlasOAxBi5MI13Zgx5OMR
        Ssscjn6dzWzLloosQKNqqjnXrwR2//xfngAT
X-Google-Smtp-Source: AMrXdXtTHCfQQRd8tCUbOX9jkfwyq+kKyH+eaXoyBR2Q6Zo4qnodU5jo2dB/cinD2kqn/HArjm67Xw==
X-Received: by 2002:a62:1507:0:b0:581:6069:5c00 with SMTP id 7-20020a621507000000b0058160695c00mr2674298pfv.28.1673939973416;
        Mon, 16 Jan 2023 23:19:33 -0800 (PST)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f12-20020aa7968c000000b005871b73e27dsm5972552pfk.33.2023.01.16.23.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 23:19:32 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 iproute2-next 0/2] tc: add new attr TCA_EXT_WARN_MSG
Date:   Tue, 17 Jan 2023 15:19:23 +0800
Message-Id: <20230117071925.3707106-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230113034353.2766735-1-liuhangbin@gmail.com>
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
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

This patch set revert commit 0cc5533b ("tc/tc_monitor: print netlink extack
message") as we never used it. Then add new attr TCA_EXT_WARN_MSG to print
the extack message as we proposed in the net-next patch.

I would reply to the kernel patch directly as it's not updated.

v2: Add a helper to print the warn message. I still print the msg in
json ojbect given the disscuss in
https://lore.kernel.org/all/20230114090311.1adf0176@hermes.local/

Hangbin Liu (2):
  Revert "tc/tc_monitor: print netlink extack message"
  tc: add new attr TCA_EXT_WARN_MSG

 include/uapi/linux/rtnetlink.h | 1 +
 tc/m_action.c                  | 1 +
 tc/tc_filter.c                 | 1 +
 tc/tc_monitor.c                | 3 ---
 tc/tc_qdisc.c                  | 2 ++
 tc/tc_util.c                   | 9 +++++++++
 tc/tc_util.h                   | 2 ++
 7 files changed, 16 insertions(+), 3 deletions(-)

-- 
2.38.1

