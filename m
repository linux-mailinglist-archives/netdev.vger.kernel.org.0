Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B7D54B77A
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344272AbiFNRRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343765AbiFNRRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 13:17:41 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781042A243
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 10:17:39 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id e9so9018685pju.5
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 10:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CiN2y1a1ZzGB3PRUT5jwZTBsw/X9lHeIPNW5+2bWny4=;
        b=JxD8KBqjJd+Jla1osrMduUqzGQDrizOA+MBGJilc+Ho+bk/z1vx7sRB6YdUvrokwXi
         TPbbgY8h/yVUQLqwImaOc2d4Q8MjiHlj48viF7MdgGYF1+nBmdCCDovkQwAqsu0xCMJp
         S5wRH+bs6YeNW8jZs3xut4RzQauqIny+Swyv6gLSglY18GHJ913h11OiuGxbEJhvE9Is
         SITBBFahH+HBLcMLo9c0BHOXL5+XJdK5pKBpfiSyGsJb2fhbKfoiY37x2F3SOY1fmoPk
         GfqWvPpisf8uLZ1pFfl3QvqfYY/rCE4Ueta97lXXHtgKXJNzmQ41TnJBezzoihk5oOSt
         FOAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CiN2y1a1ZzGB3PRUT5jwZTBsw/X9lHeIPNW5+2bWny4=;
        b=s0SGlcNTHFxVwiLVXbQ2tszI0mjj7Ertzf4SJAOBuiiAkxxQ/aqhZduDwG345eRNqA
         RF8BBLUZkurl4KIiAZUu8hEKCo2mtZvGOhvfXT6Jt7vwEjd3yjC5zbRzciYI+cVcHi4W
         qjvfNx8VRNW2fv1Ja7JEBMISbmWsxiG5xxs+CyOfS3AFNfCIl8+WgbXhLF4poR4FY4G/
         rSmg0LBLuOEneQn37Y2lHKDpn5l1UUrmqAiEB0TmsIOBunYmQ9fMV7bbNRqi3KLR84xh
         T9HF6s0BqbLxe/u4RE7S8QTfDk9gaC8Q/LK0drPmnliQ+hgumxerSoDR4CkMFB4IaJAC
         X3Ww==
X-Gm-Message-State: AJIora9ZgxFoLjGihWlyZvSudGwpQIYpoov49ohkIXH2rNT8wXSlrn+U
        6BIF/p+p8xsQBJQNrsDWgHk=
X-Google-Smtp-Source: AGRyM1vwG+zkJf4BZN/Av7oUwCI1NzbnwcLgI+sYYC5IoxpzEeaN742KIZWnV6vej4mtXgpOKvSCQw==
X-Received: by 2002:a17:902:7442:b0:167:8dd5:6a50 with SMTP id e2-20020a170902744200b001678dd56a50mr5617764plt.68.1655227058931;
        Tue, 14 Jun 2022 10:17:38 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2dbb:8c54:2434:5ada])
        by smtp.gmail.com with ESMTPSA id d20-20020a170902e15400b00168c523032fsm7435883pla.269.2022.06.14.10.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 10:17:38 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 0/2] tcp: final (?) round of mem pressure fixes
Date:   Tue, 14 Jun 2022 10:17:32 -0700
Message-Id: <20220614171734.1103875-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While working on prior patch series (e10b02ee5b6c "Merge branch
'net-reduce-tcp_memory_allocated-inflation'"), I found that we
could still have frozen TCP flows under memory pressure.

I thought we had solved this in 2015, but the fix was not complete.

v2: deal with zerocopy tx paths.

Eric Dumazet (2):
  tcp: fix over estimation in sk_forced_mem_schedule()
  tcp: fix possible freeze in tx path under memory pressure

 net/ipv4/tcp.c        | 33 +++++++++++++++++++++++++++++----
 net/ipv4/tcp_output.c |  7 ++++---
 2 files changed, 33 insertions(+), 7 deletions(-)

-- 
2.36.1.476.g0c4daa206d-goog

