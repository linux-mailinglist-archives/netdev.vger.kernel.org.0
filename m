Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA46469126
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 09:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbhLFIIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 03:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238716AbhLFIIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 03:08:50 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3E7C0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 00:05:21 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id n26so9449064pff.3
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 00:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rELK3RQlcwJErSV8jCPrnbDLdp42V70txLz5gylGU5I=;
        b=VZyDhhekl+duHJJ0YlKVmY4dNaS7dQ0Zyqo2dDhuCR318aYG4pBsaCLmpE13c8vL/q
         ZW7WRcS4pbpcThFGFSrl1oDM7ypchSa/QOWj8AaBP95ngoRKujlLhtZVPAAPpYLNxW/h
         sbn0xEM9+o/bqluW1QYlbeCbjjYlv6JlZsY4W4TMCiewwKb5i4KRp3v5E1e04RaIJE3F
         saX3CSlNT/t5RTyWxdKj/UFnxery5WX+ieGQBA1fxm98/MPUn8jSQOKQI/Fer0CuC23V
         93qydal+MJixqdMjOwElIkg+tqm5bSbDwCfEc889zexaVSKRPfBkBxOVsyyNmm+6ITkU
         gg3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rELK3RQlcwJErSV8jCPrnbDLdp42V70txLz5gylGU5I=;
        b=OSLd7mt2VI9dEWNf6dHq5F5H218qMxxjKCbPrhzWpcZoRdHumVdEuZ4mr4Sgx3vl2g
         8S42e46vwqJR1Z1qcMGrdAXdwnEuU8h24F57irLzfamFFHS1LaEm0QmdKY2jWsroaqfw
         BjCfVyVsvBIcqqDBbjtD6JD84lkBHzdHgJuyunHeP7tyQkQE3IVr6ajDTzQxmRGekH/a
         mWmMoaPquiYfUHr081C5GLDXmD0T47A71FjWiugvBWqjDZe/yPETAsD1IgYPeSCq4xX9
         178r50P+2y1tWzloPC2erpy6bfeZqq8VoN4A7l8WXr4jxyftiFb95Q/VCguxDQrnAbzS
         Drmg==
X-Gm-Message-State: AOAM532oTY2ZiLJXZIyAbGF5F3gE/6XUUZrOEgHyI2z/+siT+f+JuXLY
        U2dRfvMlWEaeTjd0gG4p3b/04mSy3BudSQ==
X-Google-Smtp-Source: ABdhPJwIEn014u9m7DvmywGY2NEKeo0+BhWaeHhhanVlUGJw+ZrRZouddU2FnOsJhsR15kLenkDfQg==
X-Received: by 2002:a63:470c:: with SMTP id u12mr17833318pga.133.1638777921073;
        Mon, 06 Dec 2021 00:05:21 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id e15sm11148798pfv.131.2021.12.06.00.05.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Dec 2021 00:05:20 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [net-next v1 0/2] net: sched: allow user to select txqueue
Date:   Mon,  6 Dec 2021 16:05:10 +0800
Message-Id: <20211206080512.36610-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Patch 1 allows user to select txqueue in clsact hook.
Patch 2 supports skb-hash and classid to select rxqueue.

Tonghao Zhang (2):
  net: sched: use queue_mapping to pick tx queue
  net: sched: support hash/classid selecting queue_mapping

 include/linux/skbuff.h                 |  1 +
 include/net/tc_act/tc_skbedit.h        |  1 +
 include/uapi/linux/tc_act/tc_skbedit.h |  5 +++
 net/core/dev.c                         | 12 +++++--
 net/sched/act_skbedit.c                | 50 +++++++++++++++++++++++---
 5 files changed, 62 insertions(+), 7 deletions(-)

-- 
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Talal Ahmad <talalahmad@google.com>
Cc: Kevin Hao <haokexin@gmail.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Wei Wang <weiwan@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
--
2.27.0

