Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8A55604ED
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbiF2Ps6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbiF2Psz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:48:55 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105E323BC2;
        Wed, 29 Jun 2022 08:48:55 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id d129so15688086pgc.9;
        Wed, 29 Jun 2022 08:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5pao2Fy17gjmaJ1U9t4AR0UHzShwljixF3EypJO16GQ=;
        b=ZalUfop4hha79srSDNMKtttrYo4DVDL2LTEmskngJ6s5U+9scBvG0x7TeDBDOUgemV
         26We5wvjZcSn9VUdXDqCo06zlfNlHhUSB3Zj+rN3L2xh1OMDfzVh2ILA20UnKhzPJwpX
         FotCwX9g5p912RjwEqL4pQSlj0QzwI/SCcN7DLDPaDShi4Ki8llzYIIJTNNyiWhgezAo
         te6nd+CYhg5hGXKeuFNe3E3hLl71qGTma1OmKBVdkeZby+QoAUvEoREQ82kf1VyR2aLP
         9F/SXsqf35qapWqE/98+K1hPCIMBqjXIbHdEwDQaxR73m9TGuCwiZrj/pUHiMQ4S2V3T
         5/CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5pao2Fy17gjmaJ1U9t4AR0UHzShwljixF3EypJO16GQ=;
        b=5rFYqkkyK9Jl5ftxO5ZjetfSKNsKQ5X1fR0NMtE7N1gzNX4FGJezvUk6/7eK8xd2+A
         HUG51DBoNGqoJlwzB3ypL8OEAFJHJRHYbI15S+/fNjo0o6FVsnR+7jrKHqqyUiY6ZPpY
         mGU0ACp0Y8L61T5dCOT7uFVfZ/ojhJq7llpfkw8EBFzNyp6XMH095m5xksR4MwYN9I9Z
         u62OHx+4NCIJnlnpBFR25RAn1BKtcP4lr+L4S+zgyd3Fk68+GNnuDDU9+Inx2EdYqHmh
         VYzuAuPYKwnGofg0DsNEwGNIUrJMjaUlJc+pNucNrnKKhizRjqt2xuQFgAjf0QaqVbV0
         JLmQ==
X-Gm-Message-State: AJIora9Ums8IjKRvykCpjtAvenVYXO8SWYndLS9FOP0WLH0uwijL+u+g
        h/lMycJg7TzwbRyd/gT1/4k=
X-Google-Smtp-Source: AGRyM1s+NbeLO4RMjoQuu6SJl0kzVSYyiicVBZp50pja3pPxpLphe9MSiuR21evdSLCFxib6GBpWQw==
X-Received: by 2002:a63:b444:0:b0:40c:f936:a21a with SMTP id n4-20020a63b444000000b0040cf936a21amr3598179pgu.37.1656517734523;
        Wed, 29 Jun 2022 08:48:54 -0700 (PDT)
Received: from vultr.guest ([45.32.72.20])
        by smtp.gmail.com with ESMTPSA id 1-20020a620501000000b00527d84dfa42sm2661329pff.167.2022.06.29.08.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 08:48:53 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, quentin@isovalent.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 0/4] bpf: Minor fixes 
Date:   Wed, 29 Jun 2022 15:48:28 +0000
Message-Id: <20220629154832.56986-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
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

When I was implementing bpf recharge[1], I found some other issues.
These issues are independent, so I send them separately.

[1]. https://lore.kernel.org/bpf/20220619155032.32515-1-laoar.shao@gmail.com/

Yafang Shao (4):
  bpf: Make non-preallocated allocation low priority
  bpf: Warn on non-preallocated case for missed trace types
  bpf: Don't do preempt check when migrate is disabled
  bpftool: Show also the name of type BPF_OBJ_LINK

 kernel/bpf/bpf_task_storage.c |  8 ++++----
 kernel/bpf/hashtab.c          | 14 ++++++++------
 kernel/bpf/trampoline.c       |  4 ++--
 kernel/bpf/verifier.c         |  2 ++
 tools/bpf/bpftool/common.c    |  1 +
 5 files changed, 17 insertions(+), 12 deletions(-)

-- 
2.17.1

