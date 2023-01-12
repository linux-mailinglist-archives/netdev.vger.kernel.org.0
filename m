Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95F3667DA4
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240093AbjALSOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240547AbjALSNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:13:52 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2CC6DBA7
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 09:43:17 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id i17-20020a05600c355100b003d99434b1cfso15732284wmq.1
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 09:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1UJtseQcGwMVKi/xxv0N3WAnrUksBlvoIFHzshgB/So=;
        b=GGHisRe9FQZw2Pt87kLichAs0+AZaBGl/bcSl7S1ecHup0b0wTxFzsTeG1mg/vWMHh
         TVNKPuucTLJ1P4hSpz51ghW5gCmtkNwmyMBE+q+1JBMlJOzdjZik9b+E11x3JBYl5VSv
         Ql7qqItwPoR0cu9wGvRJBat8sghiGWVt4633bc/j6zF+kgF1LvCX+qtJ8HzQjBrEHwPM
         diEMirpaTbgks5tF+vZvmcsRRfjs21so6iZHcDf+ErOkwIMIRDp2v/rEmKEYezwdMUQY
         ztY7PT//kFMZvpK4rrH0FRAZg4hcJ8zBL1KT4PC3e6E60jCHgsl6q6XH59kfJfUAOrJU
         UGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1UJtseQcGwMVKi/xxv0N3WAnrUksBlvoIFHzshgB/So=;
        b=RxZGOw0uhti6IieHgtnUB9qwumkmKS/Nf+5swXGMTBDw8PrsC+iaBErbV761T10dvZ
         G9bBSqwF1MaLtXtUs2NPVk6+y72ryjIv3V/Byjv/V1QccLd92RDtA4PQSYn96LxOwVPy
         zYsCJ1JoEzF1hyHu/jf/UOB4xtlytW1+PAAu/szKYI3eEvjh5TlTVxbA4TEH4DxPPZJ1
         RnqQPBqTnPZiJT1rkB6rNWR+0kD2T2/IzhnQ1Xu2RSSQIvl0HT1VYD9RM8HMjg8/veGw
         SJEy/5WWFuyLAeE8+XAzGgfHdj7ub/NKFstqcELzeyadsjCndzKFzLas78QQoA0RTfQF
         OSDg==
X-Gm-Message-State: AFqh2kp1bjkc2hem2L+0VD83T2JRebyLBBRUmAinmxiujB8yIgHZ+Hcm
        X+f2ljDMRTfPnul1pYDbKPiJ0g==
X-Google-Smtp-Source: AMrXdXtvjozpJKYjb5s0L0a0c9u2jlFxSOhfFdL03MZaYX+pL3wP4o55G0gnn2CE119t8WoCSmey2w==
X-Received: by 2002:a05:600c:34d1:b0:3d7:72e3:f437 with SMTP id d17-20020a05600c34d100b003d772e3f437mr56706371wmq.21.1673545395768;
        Thu, 12 Jan 2023 09:43:15 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id hg9-20020a05600c538900b003cfa622a18asm26448769wmb.3.2023.01.12.09.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 09:43:15 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net 0/3] mptcp: userspace pm: create sockets for the right family
Date:   Thu, 12 Jan 2023 18:42:51 +0100
Message-Id: <20230112-upstream-net-20230112-netlink-v4-v6-v1-0-6a8363a221d2@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJtGwGMC/z2NQQ6CQAxFr0K6tsnMIES8inExA1UatZIpTkwId
 7ewcPleft5fQCkzKZyrBTIVVn6LgT9U0I9R7oQ8GENwoXbeB/xMOmeKLxSa8W8NniwPLEcsLaY2
 dc3J1R2RAyulqIQpR+nHrWXjzU6Zbvzdvy+7u67rD9e3iq2QAAAA
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kishen Maloor <kishen.maloor@intel.com>,
        Florian Westphal <fw@strlen.de>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.11.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2305;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=zm0A5mWdQk3xBGQ5u/VEO3txMGrQk2HzQqNZk2n/aw0=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjwEayhLoK9HDeUD022Cd4xPH++QoWrbyoVTXRoFIt
 v30tzeCJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY8BGsgAKCRD2t4JPQmmgc1SpEA
 CgioDccxnNIFQBbXTXuqbhabB/mTV0Wu4qLPrs4ga5lEmvbJB2jSNTXmEtScC9Pf6t3idr0PviTicf
 fSunIYxSTg+KX7vnmifmvmFc9fTJoKG44jxCCrfsXkV1qBn184BXjWiEoC+svh3CkWFVD+4obQbG89
 6HZEQMdNOV45QP8kqYBhRHGnB1YSvktiivQz1/LbrfWxL8f7tiiuIoCg2gV+NuksfHL2bFrmv2dftr
 EGjBo+WfQGHV08EMYZhS1Q15buHmZsp6saUBC82xVg+L/IX7uf0RrkF6xdhjsTSWnBdLAsIv9iErgL
 qQ0fal8pNf0LoUlf4nud5+14msSkFPNAz8ZoYOuUNKZo3tIR4Qkbkhkpt1Ld4/HPIVAgo/R7HHfDij
 yxf2ShdizmRoXgzrRSP8jGoF8QwcDMA1Rx32PtXF7mtHPPNQ9Ya+UXJbhBq16GTwjNX4VZYKWj1TFF
 xDijT3R54uwNFUjSYasicZz+q+0YgiQ/YAi/mS/SEM/hpEh39InAxuZMGBNmOtOn6h8i7CbuznI3wq
 msm8hhQGnwGwagt1Ma66GVTdcNCH/Vkpg8EmAMFnUm+hLrAMSCiLCTSb1tTRcsTg0yhKI34HK99Yx9
 Q1TVX0hd7JzAFCPFaiabfutjU/VQ/2Cb1ep+6bov1v/0lIMNAW+io0Ka5PSA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before these patches, the Userspace Path Manager would allow the
creation of subflows with wrong families: taking the one of the MPTCP
socket instead of the provided ones and resulting in the creation of
subflows with likely not the right source and/or destination IPs. It
would also allow the creation of subflows between different families or
not respecting v4/v6-only socket attributes.

Patch 1 lets the userspace PM select the proper family to avoid creating
subflows with the wrong source and/or destination addresses because the
family is not the expected one.

Patch 2 makes sure the userspace PM doesn't allow the userspace to
create subflows for a family that is not allowed.

Patch 3 validates scenarios with a mix of v4 and v6 subflows for the
same MPTCP connection.

These patches fix issues introduced in v5.19 when the userspace path
manager has been introduced.

To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Kishen Maloor <kishen.maloor@intel.com>
To: Florian Westphal <fw@strlen.de>
To: Shuah Khan <shuah@kernel.org>
Cc: netdev@vger.kernel.org
Cc: mptcp@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

---
Matthieu Baerts (2):
      mptcp: netlink: respect v4/v6-only sockets
      selftests: mptcp: userspace: validate v4-v6 subflows mix

Paolo Abeni (1):
      mptcp: explicitly specify sock family at subflow creation time

 net/mptcp/pm.c                                    | 25 ++++++++++++
 net/mptcp/pm_userspace.c                          |  7 ++++
 net/mptcp/protocol.c                              |  2 +-
 net/mptcp/protocol.h                              |  6 ++-
 net/mptcp/subflow.c                               |  9 +++--
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 47 +++++++++++++++++++++++
 6 files changed, 90 insertions(+), 6 deletions(-)
---
base-commit: be53771c87f4e322a9835d3faa9cd73a4ecdec5b
change-id: 20230112-upstream-net-20230112-netlink-v4-v6-b6b958039ee0

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>
