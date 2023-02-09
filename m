Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957AA690D64
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjBIPoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjBIPnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:43:46 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE51656AE
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 07:43:16 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id l14so2461735eds.4
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 07:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ds/sgCBp/UDtkbnDAZWU5ROAJxaoHCgpjc9mZbz3+is=;
        b=S7QfwLcLWTgPI4UcfvqJ+DYDEP2GH34r4yvSHie5cZNcKbits+9fGQmYvgdWsiX9cW
         CotR637oBWCe1KHzu252EhajL7Ss514K0y9Qj91pQQYS/xC9DArBCGvJUzqmIlZ5FTc8
         foP/PVY8vwgqq+CpQXdrZo1kni9pedry4Jx8WSvt2ar0qFERhdem6NuWWvi8WqvjB3az
         vFVUNPmlD0sPJzDeQkL1hb2rBRwZ+pGDId55IDgNxWL/MIeGcXiqrCwH2ZFkFxpvyzlx
         ZgmH4Zfu4uwFi0Q6hs84XcQ41mjKhHEzzEJKNhPmAqk3iCUulxbhMgkH1foWqL/bXstu
         EOMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ds/sgCBp/UDtkbnDAZWU5ROAJxaoHCgpjc9mZbz3+is=;
        b=GbsVW/fdMbgqt1cae9W2qkBPSxlgQwA0HUrfjKy/jiBdgKpSFLFbWQJ8T5KgGguCwD
         Zh3hw9NDirvtPYfuLV/PObmy93/J7eS8dT/ONVyqiQaNBw/3hmel243yKEvdEEjYVwEs
         uA4fmTU4XXIAIldpx3F8b0C3v31iHEzajoGgA+HztTAg6MdkOUlZ1t0th6+6FF5AnmGp
         AkFI/Py21NPXWQnesRhuRM5hlhvcZ8Wg7kALbMnPNAVu1VKDIHgd5ytQo4GHeNh2jn3N
         xYEPgFGjuZiyh0MkPfeKmrgi105qoo+BGPJTOZOeaY1CcunR5lhflrRh/i/wdogT1b3x
         JzpQ==
X-Gm-Message-State: AO0yUKXE5BLAuR+sT8UHrAqnTcMojaVOlafrpxJyGpGZMH65PKsfxaAd
        atyHUyeE9cAod+33B0amQdSsbIxay1RV+uz9jZg=
X-Google-Smtp-Source: AK7set/fbkm/PlPuwGTutMF+GFa/Tl2inK9bduhuElVsggm0OfcUe4cS1u4xQMWFXTlFYOJFdwEeVg==
X-Received: by 2002:a50:8a8f:0:b0:4aa:da7c:4c5c with SMTP id j15-20020a508a8f000000b004aada7c4c5cmr10063006edj.34.1675957390849;
        Thu, 09 Feb 2023 07:43:10 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v1-20020a50a441000000b004aab66d34c7sm933864edb.7.2023.02.09.07.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 07:43:10 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com
Subject: [patch net-next 0/7] devlink: params cleanups and devl_param_driverinit_value_get() fix
Date:   Thu,  9 Feb 2023 16:43:01 +0100
Message-Id: <20230209154308.2984602-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The primary motivation of this patchset is the patch #6, which fixes an
issue introduced by 075935f0ae0f ("devlink: protect devlink param list
by instance lock") and reported by Kim Phillips <kim.phillips@amd.com>
(https://lore.kernel.org/netdev/719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com/)
and my colleagues doing mlx5 driver regression testing.

The basis idea is that devl_param_driverinit_value_get() could be
possible to the called without holding devlink intance lock in
most of the cases (all existing ones in the current codebase),
which would fix some mlx5 flows where the lock is not held.

To achieve that, make sure that the param value does not change between
reloads with patch #2.

Also, convert the param list to xarray which removes the worry about
list_head consistency when doing lockless lookup.

The rest of the patches are doing some small related cleanup of things
that poke me in the eye during the work.

Jiri Pirko (7):
  devlink: don't use strcpy() to copy param value
  devlink: make sure driver does not read updated driverinit param
    before reload
  devlink: fix the name of value arg of
    devl_param_driverinit_value_get()
  devlink: use xa_for_each_start() helper in
    devlink_nl_cmd_port_get_dump_one()
  devlink: convert param list to xarray
  devlink: allow to call devl_param_driverinit_value_get() without
    holding instance lock
  devlink: add forgotten devlink instance lock assertion to
    devl_param_driverinit_value_set()

 include/net/devlink.h       |   6 +-
 net/devlink/core.c          |   4 +-
 net/devlink/dev.c           |   2 +
 net/devlink/devl_internal.h |   5 +-
 net/devlink/leftover.c      | 139 ++++++++++++++++++++----------------
 5 files changed, 90 insertions(+), 66 deletions(-)

-- 
2.39.0

