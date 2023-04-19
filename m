Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C3F6E8094
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbjDSRoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbjDSRog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:44:36 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2386EAF
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:44:32 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f167d0c91bso406965e9.2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681926270; x=1684518270;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cekCW+SqV/BFx5znWNnA1xPGxJLXH0PS1n/sZ8CHAHc=;
        b=M4vPROgbnjX5wvsvoBVlCGhAl97U6yDSb8O3HKWgF2vJ8IeRxgM0J0N8PATq0bTdHr
         b7s18BOLvfXBi49sesz1T8vrHZXv1E+L7iba7AMvvqkx8sxG7RQ8twu6snNgInwvbapp
         Fuy7AF2b+9U9jEKO5ZmQgWMRnwqPIF3+hxzoRH+SR6LlXQbDc0MXjIqnF3itk41+hyA3
         SFYpv5kPTfINHhvZeKDb6rW0HPFrSXyYr8PE2hm0Qun97QoiyeqgTppWPN/VRjLFBFiE
         E6rLGadxRsuPxNqAaaGMS0cuGOsnAZVbmKuuTzG4J/gLSWRJ58vDNPgm5cjW+RoeqJJs
         LBhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681926270; x=1684518270;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cekCW+SqV/BFx5znWNnA1xPGxJLXH0PS1n/sZ8CHAHc=;
        b=TfaKTH3Hg2WiKl7APq9hOTdXMHM+8/nZfojV2dEsElImQM5BQD96j3+EVaUWHmxz1q
         hG/7XgRCumBqdt8BY5TzT60g9O5hmktOtT8VHSp4pqlA6tyFniFVZaBT1MOl4y2d9Yqy
         2ICT8eitnz4Vv6Qr8IqJF04LvhZWN2BT6m49R54Ntv8NM+CShQH2YdcFLOmXjyDeaZiD
         yfE9eEuxd6t/EG3YY5FBZwbhs5nmdA9UdRBjhg7Mpr3mNJBxgCHMTdNVh1g/4Ok/3Zy2
         DWJDml+sIy4SxUoqUNQztKvWVNdXp3lXJkBaPZztScf93A9NKL7E9nLKio9agxa6G5wV
         8O+w==
X-Gm-Message-State: AAQBX9cIGCjSYWYSAD2wsC0nDRbvfUbU2b4w1zEY0oGm23aqcOfZh1Ol
        gByxIbYuKzXK5lEALpiBKOkNHw==
X-Google-Smtp-Source: AKy350ZoEi+fS+LUYvy1NEQODgr6EfXOnXZZDsYvWL+IrBTTzRuno/1y5jP6qVHtFe7LEio6+0WB0A==
X-Received: by 2002:a05:6000:11cb:b0:2f0:bab2:dc3c with SMTP id i11-20020a05600011cb00b002f0bab2dc3cmr5534481wrx.27.1681926270546;
        Wed, 19 Apr 2023 10:44:30 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id o18-20020a5d4092000000b002fe87e0706bsm3027879wrp.97.2023.04.19.10.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 10:44:30 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH LSM 0/2] security: SELinux/LSM label with MPTCP and accept
Date:   Wed, 19 Apr 2023 19:44:03 +0200
Message-Id: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v1-0-9d4064cb0075@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGQoQGQC/z3OywrCMBCF4Vcps3agrRfUZ7Arl+JiEic20KQhk
 2ih9N1NBV3+HPg4MwhHywLnaobILyt29CWaTQW6J/9ktI/S0Nbttt41J8xBUmRyOIhDz1PC/+R
 C0gElq2F8C+Yio04TMvNhfzRktCIoriJhVJG87lf556xTiGzs9L1zg8u1g/uyfAB5Ce4+owAAA
 A==
To:     Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3225;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=Rl5GtGwq+L7wyDWK7TEacZMevn8jICzh9/ucI2yapPY=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkQCh9PbGJu9bdgZRzN41wd9bdr7geV1tmVBs6h
 MEEW5+fktaJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZEAofQAKCRD2t4JPQmmg
 cxTMD/0UsSFEDeb9i0olgkNDk55w5NjuaDc8AfJoA6yuknO6m5Jdg74k+wA9ZlsdHNyle3AtBHv
 CcOhw7aGerioF14LEJ+E9rUjmZFqMrdaV2Ut317M7Vfk5LTq3dceQZc16RE1slC8MngZfWsJeRJ
 FfdBhvnhxYRXXDOLVGrCpm7wn8ZQcva4hOJ5qF5aK/WM6gyFw6V20MhMogTN+Be84S3raNH6ywi
 G5n+o7FLiGGQ+e0M0kgd7aBR8TFPyvAlKlrj7h4mqdvQkkWjL7h64W17/tzp1wU6+6B8U38blK5
 cr7wOrMBWfmknZiJfrFwsDDB2FyityI/8Gu7UimzRIy/a8OPq8bL3kURS2WSd8NVfn/ecWTee/v
 FPqMkxf9fcFZI6tBSu1uNedS9v6qios+adtBdVC120Swt5eUEuuNqMI+A8InmN1dt7v5Zz7h++7
 37rsJqh1e8GJ0aU5km/6QLLDUb3mo0anp3KFNE6N6+oyIpVd23ws7pFT6VCFglBka5JAPrazrOM
 s3R+bV/y8PGIPTWEGfdY3TQDBjULKnlNodOud8kXmkgzcvgE9VtQL/WhXoYt4FTmsejmB08IwMa
 lzETZGYL1ZwxQ8AN3bw83zjySShptQnaqndReUGDD5cbMtY6FUVBnwtPquDBkPVjJgmZmd+xWok
 lHoTOyvdY0UHDuQ==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In [1], Ondrej Mosnacek explained they discovered the (userspace-facing)
sockets returned by accept(2) when using MPTCP always end up with the
label representing the kernel (typically system_u:system_r:kernel_t:s0),
while it would make more sense to inherit the context from the parent
socket (the one that is passed to accept(2)). Thanks to the
participation of Paul Moore in the discussions, modifications on MPTCP
side have started and the result is available here.

Paolo Abeni worked hard to refactor the initialisation of the first
subflow of a listen socket. The first subflow allocation is no longer
done at the initialisation of the socket but later, when the connection
request is received or when requested by the userspace. This was a
prerequisite to proper support of SELinux/LSM labels with MPTCP and
accept. The last batch containing the commit ddb1a072f858 ("mptcp: move
first subflow allocation at mpc access time") [2] has been recently
accepted and applied in netdev/net-next repo [3].

This series of 2 patches is based on top of the lsm/next branch. Despite
the fact they depend on commits that are in netdev/net-next repo to
support the new feature, they can be applied in lsm/next without
creating conflicts with net-next or causing build issues. These two
patches on top of lsm/next still passes all the MPTCP-specific tests.
The only thing is that the new feature only works properly with the
patches that are on netdev/net-next. The tests with the new labels have
been done on top of them.

It then looks OK to us to send these patches for review on your side. We
hope that's OK for you as well. If the patches look good to you and if
you prefer, it is fine to apply these patches before or after having
synced the lsm/next branch with Linus' tree when it will include the
modifications from the netdev/net-next repo.

Regarding the two patches, the first one introduces a new LSM hook
called from MPTCP side when creating a new subflow socket. This hook
allows the security module to relabel the subflow according to the owing
process. The second one implements this new hook on the SELinux side.

Link: https://lore.kernel.org/netdev/CAFqZXNs2LF-OoQBUiiSEyranJUXkPLcCfBkMkwFeM6qEwMKCTw@mail.gmail.com/ [1]
Link: https://git.kernel.org/netdev/net-next/c/ddb1a072f858 [2]
Link: https://lore.kernel.org/netdev/20230414-upstream-net-next-20230414-mptcp-refactor-first-subflow-init-v1-0-04d177057eb9@tessares.net/ [3]
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
Paolo Abeni (2):
      security, lsm: Introduce security_mptcp_add_subflow()
      selinux: Implement mptcp_add_subflow hook

 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  6 ++++++
 net/mptcp/subflow.c           |  6 ++++++
 security/security.c           | 15 +++++++++++++++
 security/selinux/hooks.c      | 16 ++++++++++++++++
 security/selinux/netlabel.c   |  8 ++++++--
 6 files changed, 50 insertions(+), 2 deletions(-)
---
base-commit: d82dcd9e21b77d338dc4875f3d4111f0db314a7c
change-id: 20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-eee658fafcba

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>

