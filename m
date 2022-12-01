Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B22163F99F
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 22:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiLAVOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 16:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiLAVOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 16:14:35 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84E6BF66F;
        Thu,  1 Dec 2022 13:14:34 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id ja4-20020a05600c556400b003cf6e77f89cso3831097wmb.0;
        Thu, 01 Dec 2022 13:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=arGJugZXKuegCy+b2Wy748udH7dyCPYLgoQysJN9/+E=;
        b=G8I3r0UFOmARwoPh8BwqG3XgTzilTOCk8MXuobDoiBD7EaZA2kag7KurO9gpBh9/xP
         uSR1EztpspRtCkwrbNRGBRNBSR47ze8b1l0+lgwr8w2HbULTK6yueiUhMAzkwI4xBTBe
         s4XA8ReFVa+PNNG3MK4uA2X2RrY+TIafn36iZFZ2D7Kw1UjZxXz39/ejXAXm9Eewk6gl
         cht1EbbMZH484vH70ma10+T0qeW4taPBiFUr5h8IAk5KW6uh6ck9DhkBegEDvl3HRVq4
         qFyESQ1nq11PvnjcSGtxNyM25auaOIqTirxYfV+qAzcut3QIaciMaooW8bRjKirPDzZh
         78Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=arGJugZXKuegCy+b2Wy748udH7dyCPYLgoQysJN9/+E=;
        b=lXRlXNXbthGXFnwqrP3CJPcA1L7nmQ5uZJhqgzedycNzaySjX5JvVYjdoNthZZtPxX
         e/LFtV6hTMrj/c84AL/jE5TYWVqKQKrnAV6VtFkL6+gE3wYDlajrZyyjJQWkmcW3I7+H
         NzRH9K36ojMZm5LqBq8aDGjjDfbsqohymeMRbmJwMdX1VTWt1XcVvKWFpAXH/eG35f9A
         3MktCIPBBsWfFYoQtNTF3P70WZJKxduMv9OEtZCsrplKBTg2sH4JRXtJxsaHe5fJ/Q3x
         vgZtSE5CjPHkp+9/IGLbyZor0AMY9LATFQ89VteFdCBPV5K7irj2C0yhoa1m2AFmz/oc
         H2ew==
X-Gm-Message-State: ANoB5pk647nZrZ9D4qKJzxx2xRrmvKVOY7DyjLRVCb1YbWtKXFjlvaBN
        ScD1nMxsOmd9IFXsdq3NmRE=
X-Google-Smtp-Source: AA0mqf7xIdmNr/IVA6wau15GjaiOh2J7K5KuHpMOHdbdrU0DZ6nCVr3UT/wYVLP1hqD2ohBVk4dp6Q==
X-Received: by 2002:a05:600c:1e89:b0:3cf:774b:ce6f with SMTP id be9-20020a05600c1e8900b003cf774bce6fmr6367406wmb.133.1669929272979;
        Thu, 01 Dec 2022 13:14:32 -0800 (PST)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id m35-20020a05600c3b2300b003b50428cf66sm7508708wms.33.2022.12.01.13.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 13:14:32 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        liuhangbin@gmail.com, lixiaoyan@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf-next,v3 0/4] xfrm: interface: Add unstable helpers for XFRM metadata
Date:   Thu,  1 Dec 2022 23:14:21 +0200
Message-Id: <20221201211425.1528197-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
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

This patch series adds xfrm metadata helpers using the unstable kfunc
call interface for the TC-BPF hooks.

This allows steering traffic towards different IPsec connections based
on logic implemented in bpf programs.

The helpers are integrated into the xfrm_interface module. For this
purpose the main functionality of this module is moved to
xfrm_interface_core.c.

---

Series changes in v3:
  - tag bpf-next tree instead of ipsec-next
  - add IFLA_XFRM_COLLECT_METADATA sync patch

Eyal Birger (4):
  xfrm: interface: rename xfrm_interface.c to xfrm_interface_core.c
  xfrm: interface: Add unstable helpers for setting/getting XFRM
    metadata from TC-BPF
  tools: add IFLA_XFRM_COLLECT_METADATA to uapi/linux/if_link.h
  selftests/bpf: add xfrm_info tests

 include/net/dst_metadata.h                    |   1 +
 include/net/xfrm.h                            |  20 +
 net/core/dst.c                                |   8 +-
 net/xfrm/Makefile                             |   8 +
 net/xfrm/xfrm_interface_bpf.c                 |  99 +++++
 ...xfrm_interface.c => xfrm_interface_core.c} |  15 +
 tools/include/uapi/linux/if_link.h            |   1 +
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/xfrm_info.c      | 365 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/xfrm_info.c |  40 ++
 10 files changed, 557 insertions(+), 2 deletions(-)
 create mode 100644 net/xfrm/xfrm_interface_bpf.c
 rename net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} (98%)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xfrm_info.c
 create mode 100644 tools/testing/selftests/bpf/progs/xfrm_info.c

-- 
2.34.1

