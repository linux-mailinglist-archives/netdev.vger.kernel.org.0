Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E6428A5B5
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 07:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgJKFJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 01:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgJKFJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 01:09:02 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16F7C0613CE;
        Sat, 10 Oct 2020 22:09:01 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d20so14355839iop.10;
        Sat, 10 Oct 2020 22:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=TTLjJ4M65NXNwBuWUHISV2u6iuMr/6vLuZHwjECtuNA=;
        b=Wg18mjEvZDPXnDah10+dwkSC6HXYb5vCluBUu+yuc/cYZEmzrB7r3C7HxXT3p6EkF8
         vS63X+taifRqL3edCskHOY72tMXLkRAlPG8PoqLk/YcWD0zYoO01LPTGlPoQVUuwu6lR
         kaDdIDe8qqvr5qfKR4YLYVnUAvZdFjdXQuCvj3QztDFG8jwl943CFA9RdsZSugXOhUXX
         J65vIa29ZHFvao7fm2mO2YI6Y4O/FiAvn32lLlMwMrdEUvrpMG12SaD/xiw0cJTcLhC2
         hwCzF2DkQjged14epJ7y2FrezZQ6jdWNloxusOMTVAJfmz1e+53aglOQBGzsWUrOAitQ
         HiqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=TTLjJ4M65NXNwBuWUHISV2u6iuMr/6vLuZHwjECtuNA=;
        b=G3bJhOpxieU+9it/1bVLjWC6gB0kUo16D4r9bhFem5V3/eWvDcQiq7FVD59l1JauLm
         +K9uqRIDpbDjJ1jWLon7QzwOKx7sGm2YpcyrmIWFJgH9zOjMlcV5CpT4se/ozCJBu0n+
         v5tSmchZDSuBDQAQElyabTELT8x71xUaEyvT/Bb8O5d4sonq4DskN0RJ1jc/bqg0uNoa
         tTmIeurrQw7oWhS8La5SAfSb1o7VtBaoPpRZcMlos6IcdBkTsEyuzfcQTLOeCjTvlHSl
         GopQkx44Ah5vChde7QalV8U3JLIIkVIWWfnj99FXXEzT6uz2VchKfLacHK/f/fhM0jiO
         J7kg==
X-Gm-Message-State: AOAM531szhl1yrsJ/NGiBz1fC/mIc23G7QQA6uh9fglwyuTGHHfTqqjQ
        fJUr4RgDPRp08qyyH+gq4tc=
X-Google-Smtp-Source: ABdhPJz51xOp5egqyA05mE7x5e2OIPf3OX6v7gFLWBhZT3Yzt6uhTfTfUUrr6SJ/ZGx4+HkCUMQ8/g==
X-Received: by 2002:a6b:3f88:: with SMTP id m130mr13516197ioa.78.1602392941239;
        Sat, 10 Oct 2020 22:09:01 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b2sm6774730ila.62.2020.10.10.22.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 22:09:00 -0700 (PDT)
Subject: [bpf-next PATCH 0/4] bpf, sockmap: allow verdict only sk_skb progs
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Sat, 10 Oct 2020 22:08:29 -0700
Message-ID: <160239226775.8495.15389345509643354423.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows a sockmap sk_skb verdict programs to run without a parser. For
some use cases, such as verdict program that support streaming data or a
l3/l4 proxy that does not use data in packet, loading the nop parser
'return skb->len' is an extra unnecessary complexity. With this series we
simply call the verdict program directly from data_ready instead of
bouncing through the strparser logic.

Patches 1,2 do the lifting on the sockmap side then patches 3,4 add the
selftests.

This applies on top of the series here,

  sockmap/sk_skb program memory acct fixes 
  https://patchwork.ozlabs.org/project/netdev/list/?series=206975

it will apply without the above series cleanly, but will have an incorrect
memory accounting causing a failure in ./test_sockmap. I could have left
it so the series passed without above series, but it seemed odd to have
it out there and then require yet another patch to fix it up here.

Thanks.

---

John Fastabend (4):
      bpf, sockmap: check skb_verdict and skb_parser programs explicitly
      bpf, sockmap: Allow skipping sk_skb parser program
      bpf, selftests: Add option to test_sockmap to omit adding parser program
      bpf, selftests: Add three new sockmap tests for verdict only programs


 include/linux/skmsg.h                      |    2 +
 net/core/skmsg.c                           |   78 ++++++++++++++++++++++++++++
 net/core/sock_map.c                        |   37 ++++++++-----
 tools/testing/selftests/bpf/test_sockmap.c |   54 ++++++++++++++-----
 4 files changed, 142 insertions(+), 29 deletions(-)

--
Signature
