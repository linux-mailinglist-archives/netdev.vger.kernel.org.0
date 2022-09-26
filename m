Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2507E5EB42D
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiIZWJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiIZWJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:09:45 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A51D116E
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:41 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id d14so4260179ilf.2
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Tcofh2eParKVCFfTU5ufAxTg6uY4Kus0F8zdnWHYYIg=;
        b=Aq58PwRCaXZfPNg4YaGxYuvcojdnBOGLBwOcBYyieYctSEQw73G6W8n3+r2hG4fK3p
         suNr5264F1H1TmCYQdDnJCawGbo1OAiSjAAj84ztGBHXzSjgTuX3d4M8glsqQXw0U9tV
         Fnj+57ZZ7SA0/toa/x99xQ5qQXZc5miVK5SbpM/LL27Y7j7Jkjy2RUoW2+wa7FLESvou
         jNDN0eS5qeBgd9uZXq5L8/n0wx8kiQBBgiDs3yZWwcdIQIJKNtQ9WH/mb7nT/zNU2twu
         woMkrBqjBRWbtyJPfPIeSgjVX/oSfRCpVoe6chyy6/0RasHkjJhj5l459+B2zZAI4I++
         A0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Tcofh2eParKVCFfTU5ufAxTg6uY4Kus0F8zdnWHYYIg=;
        b=4hT0Dav/FIGQC4yzFYW0yoqZu8Lcys7/MILJTGODfCXZtW4K0q1P7AGKgP1VKDcCQW
         BvodhS4delVEg2sJa5GoyHxUbP7tejiDlt84EJbThXL2Y54vUBRW3UBLsnBG2RUHzGW2
         zrf4LIBcFIif70wOeAA/nK66GJxp9Fwd4DKbavIOoF/nZGaYm8WxCdxETqz36y28xKey
         cL8BJSKcSjZJ5oLN51sA2nw7+jKPRqx6HJt8/0CGD1MYwylD79vCB3xqLLo2ecGugTWa
         OgSXleUW0wtiz/Zoz6qHer4RA35UoX1jA7ibELhYaZBoBgtMWcwZvTokqzBElynQ7WPU
         SMZA==
X-Gm-Message-State: ACrzQf2SKGEpC4FVO8oCg3K0yJ395aAebRoRfaAJlRLV8ksEo9jDi4lX
        StFfPmywH7ScmiGSKYtn7FibmA==
X-Google-Smtp-Source: AMsMyM4shf+d5xGDO0sWxUlNoCpHt8PoWqtcOLw6wY7RY03lKrA4P6MQG4WLa8qpPekrfJMCMy/h8A==
X-Received: by 2002:a05:6e02:1a6e:b0:2f5:9aad:1e97 with SMTP id w14-20020a056e021a6e00b002f59aad1e97mr11535884ilv.37.1664230181120;
        Mon, 26 Sep 2022 15:09:41 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:09:38 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/15] net: ipa: generalized register definitions
Date:   Mon, 26 Sep 2022 17:09:16 -0500
Message-Id: <20220926220931.3261749-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is quite a bit bigger than what I normally like to send,
and I apologize for that.  I would like it to get incorporated in
its entirety this week if possible, and splitting up the series
carries a small risk that wouldn't happen.

Each IPA register has a defined offset, and in most cases, a set
of masks that define the width and position of fields within the
register.  Most registers currently use the same offset for all
versions of IPA.  Usually fields within registers are also the same
across many versions.  Offsets and fields like this are defined
using preprocessor constants.

When a register has a different offset for different versions of
IPA, an inline function is used to determine its offset.  And in
places where a field differs between versions, an inline function is
used to determine how a value is encoded within the field, depending
on IPA version.

Starting with IPA version 5.0, the number of IPA endpoints supported
is greater than 32.  As a consequence, *many* IPA register offsets
differ considerably from prior versions.  This increase in endpoints
also requires a lot of field sizes and/or positions to change (such
as those that contain an endpoint ID).

Defining these things with constants is no longer simple, and rather
than fill the code with one-off functions to define offsets and
encode field values, this series puts in place a new way of defining
IPA registers and their fields.  Note that this series creates this
new scheme, but does not add IPA v5.0+ support.

An enumerated type will now define a unique ID for each IPA register.
Each defined register will have a structure that contains its offset
and its name (a printable string).  Each version of IPA will have an
array of these register structures, indexed by register ID.

Some "parameterized" registers are duplicated (this is not new).
For example, each endpoint has an INIT_HDR register, and the offset
of a given endpoint's INIT_HDR register is dependent on the endpoint
number (the parameter).  In such cases, the register's "stride" is
defined as the distance between two of these registers.

If a register contains fields, each field will have a unique ID
that's used as an index into an array of field masks defined for the
register.  The register structure also defines the number of entries
in this field array.

When a register is to be used in code, its register structure will
be fetched using function ipa_reg().  Other functions are then used
to determine the register's offset, or to encode a value into one of
the register's fields, and so on.

Each version of IPA defines the set of registers that are available,
including all fields for these registers.  The array of defined
registers is set up at probe time based on the IPA version, and it
is associated with the main IPA structure.

					-Alex

Alex Elder (15):
  net: ipa: introduce IPA register IDs
  net: ipa: use IPA register IDs to determine offsets
  net: ipa: add per-version IPA register definition files
  net: ipa: use ipa_reg[] array for register offsets
  net: ipa: introduce ipa_reg()
  net: ipa: introduce ipa_reg field masks
  net: ipa: define COMP_CFG IPA register fields
  net: ipa: define CLKON_CFG and ROUTE IPA register fields
  net: ipa: define some more IPA register fields
  net: ipa: define more IPA register fields
  net: ipa: define even more IPA register fields
  net: ipa: define resource group/type IPA register fields
  net: ipa: define some IPA endpoint register fields
  net: ipa: define more IPA endpoint register fields
  net: ipa: define remaining IPA register fields

 drivers/net/ipa/Makefile             |    2 +
 drivers/net/ipa/ipa.h                |    2 +
 drivers/net/ipa/ipa_cmd.c            |    7 +-
 drivers/net/ipa/ipa_endpoint.c       |  378 ++++++----
 drivers/net/ipa/ipa_interrupt.c      |   45 +-
 drivers/net/ipa/ipa_main.c           |  164 +++--
 drivers/net/ipa/ipa_mem.c            |   16 +-
 drivers/net/ipa/ipa_reg.c            |   95 +++
 drivers/net/ipa/ipa_reg.h            | 1011 ++++++++++++--------------
 drivers/net/ipa/ipa_resource.c       |   63 +-
 drivers/net/ipa/ipa_table.c          |   27 +-
 drivers/net/ipa/ipa_uc.c             |    9 +-
 drivers/net/ipa/reg/ipa_reg-v3.1.c   |  478 ++++++++++++
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c |  456 ++++++++++++
 drivers/net/ipa/reg/ipa_reg-v4.11.c  |  512 +++++++++++++
 drivers/net/ipa/reg/ipa_reg-v4.2.c   |  456 ++++++++++++
 drivers/net/ipa/reg/ipa_reg-v4.5.c   |  533 ++++++++++++++
 drivers/net/ipa/reg/ipa_reg-v4.9.c   |  509 +++++++++++++
 18 files changed, 3921 insertions(+), 842 deletions(-)
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v3.1.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v3.5.1.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v4.11.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v4.2.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v4.5.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v4.9.c

-- 
2.34.1

