Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793FD6D5773
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 06:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjDDESU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 00:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjDDEST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 00:18:19 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FCEE66
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 21:18:17 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-5463fa0c2bfso261025827b3.1
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 21:18:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680581897;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:resent-to:resent-message-id:resent-date
         :resent-from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wRW/bojKTcyb/ju3BlDNQg3+FjLfYty/BQ3QUXeAolk=;
        b=Z7GY9qnV+KfUwvK1Ui0WM8M5KaqMSl/y93hyEMIKsEWHKTtMhzWtQMnSD88LuMwYBX
         L9voz0kFcBXXEd22KKv6DCVgxI6c3FrBzAdra9T0Hr3URuzyGDDurYBatAoVw3c4LGNR
         X5mXQvhIIKhcdcUYNeXx2gqwwhlJtOoyARSvOydKfOpQ+EQXqpPMfawZ1akmB4so4TXc
         1VzhtWLocDbCqP+h5faLXz9oNBdZisoH3tOElWzA4KvAr0OyUXEuhk5W7AsBR7FIKt5K
         udjLMrHfC9kmciPTQKnuj3juWGYrju7Id3vy3LpAW+96qIk+M39V00iUQLF3rVQEqess
         vHkQ==
X-Gm-Message-State: AAQBX9cQF3I5ZmovFkNashSA4lAOOXYMQK1M9x9ZneJ+MAgEWd5zqGjd
        UYvkjKoqKx0ZRIi3SpM0cLW47MkxjL0=
X-Google-Smtp-Source: AKy350Yfj9tbKqTS+gZw+GgZ922GicYXgWO+cA+mBrG6XrsjCYHXReASrelTw6CFQSHmB92nOWT0bA==
X-Received: by 2002:a81:52ca:0:b0:541:6978:5d92 with SMTP id g193-20020a8152ca000000b0054169785d92mr1209586ywb.26.1680581896551;
        Mon, 03 Apr 2023 21:18:16 -0700 (PDT)
Received: from vps.qemfd.net (vps.qemfd.net. [173.230.130.29])
        by smtp.gmail.com with ESMTPSA id p76-20020a81984f000000b00545a0818489sm2971925ywg.25.2023.04.03.21.18.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 21:18:16 -0700 (PDT)
Received: from schwarzgerat.orthanc (schwarzgerat.danknet [192.168.128.2])
        by vps.qemfd.net (Postfix) with ESMTP id 9FBCD2BA75
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 00:18:15 -0400 (EDT)
Received: by schwarzgerat.orthanc (Postfix, from userid 1000)
        id 89710600154; Tue,  4 Apr 2023 00:18:15 -0400 (EDT)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=1.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Original-To: dank@localhost
Received: from schwarzgerat.orthanc (localhost [IPv6:::1])
        by schwarzgerat.orthanc (Postfix) with ESMTP id 5B064600234
        for <dank@localhost>; Sun,  2 Apr 2023 04:41:41 -0400 (EDT)
X-Original-To: dank@qemfd.net
Received: from 192.168.128.1 [192.168.128.1]
        by schwarzgerat.orthanc with IMAP (fetchmail-6.4.37)
        for <dank@localhost> (single-drop); Sun, 02 Apr 2023 04:41:41 -0400 (EDT)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        by vps.qemfd.net (Postfix) with ESMTPS id C8FE72BABC
        for <dank@qemfd.net>; Sun,  2 Apr 2023 04:41:40 -0400 (EDT)
Received: by mail-qt1-f170.google.com with SMTP id x17so3611540qtv.7
        for <dank@qemfd.net>; Sun, 02 Apr 2023 01:41:40 -0700 (PDT)
X-Received: by 2002:a05:622a:1046:b0:3e3:9502:8e0e with SMTP id f6-20020a05622a104600b003e395028e0emr12521913qte.3.1680424900146;
        Sun, 02 Apr 2023 01:41:40 -0700 (PDT)
X-Forwarded-To: dank@qemfd.net
X-Forwarded-For: dankamongmen@gmail.com dank@qemfd.net
Received: by 2002:ac8:5487:0:0:0:0:0 with SMTP id h7csp1477920qtq;
        Sun, 2 Apr 2023 01:41:39 -0700 (PDT)
X-Received: by 2002:a0d:e283:0:b0:52e:e691:3b43 with SMTP id l125-20020a0de283000000b0052ee6913b43mr28460564ywe.41.1680424899134;
        Sun, 02 Apr 2023 01:41:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680424899; cv=none;
        d=google.com; s=arc-20160816;
        b=dulJvVvcePtolWbFfiSPirDtiCiO0FyLKG339vxhfz1MZdFUi5vDWJdgXaSKUH7rsQ
         3fAZ8su/UiXGQZxqpaRHmQIgoklff+XbfNN80hzFgeSmyMkY/oSBYa+wZVPJ//Ad2TIF
         Vk+VLe1j5wXHHazeAKsnu7NrG/U9qxJ017TXANXZzQzXSTaBAgvoTVIR+IU2BlIWP+xa
         hiVUXN9ZfaAoF2mUSDCThGcataGBRRloYyubaSKzdfxvCufE0JD9VAR/Xltqvl6zGTQm
         CRofbI4zdiAl2OEdwLiR+Uf4ffEK4hGNcMMFsBgfFTtoGJKvBrry6pHlnubXYQsZG3lq
         3Wuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature;
        bh=wRW/bojKTcyb/ju3BlDNQg3+FjLfYty/BQ3QUXeAolk=;
        b=0DwOuOTiJ1lzNY34+2Od6FclgprRVi8UGuw51iH01B7V/kA+acFkZ3OefE3L0pPF9t
         VxsQPK7SL+JHNhDqvc7jHnoe47UcWnq5m4W2cxZrU+lRDfdezKSIu6yKE/ZZD2ZR4U8x
         soS8hRycIXt3Dz/kl9B6vFmGrgCSxtKpLm004u+sM0NprjplwEUOjUjpyOw9fXZ0x/2Z
         kvn7puWfcFyqc8U2PlN7CkoFd8LD4WW9aDldU3ZAkncbD8gP8KZL3EiP99+MZnBArm7z
         j6JG6bwFS8C8b7VDN3oDqS+KAsa3nQ/nTTaGXDuDnQ73hbOQEFhZEBgOD5lD+5E3lYbJ
         4rng==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@gmail.com header.s=20210112 header.b=KRXHXUOk;
       spf=pass (google.com: domain of dankamongmen@gmail.com designates 209.85.220.41 as permitted sender) smtp.mailfrom=dankamongmen@gmail.com;
       dmarc=pass (p=NONE sp=QUARANTINE dis=NONE) header.from=gmail.com
Received: from mail-sor-f41.google.com (mail-sor-f41.google.com. [209.85.220.41])
        by mx.google.com with SMTPS id p20-20020a81ca14000000b004db85af5723sor3404623ywi.3.2023.04.02.01.41.39
        for <dankamongmen@gmail.com>
        (Google Transport Security);
        Sun, 02 Apr 2023 01:41:39 -0700 (PDT)
Received-SPF: pass (google.com: domain of dankamongmen@gmail.com designates 209.85.220.41 as permitted sender) client-ip=209.85.220.41;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680424898;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wRW/bojKTcyb/ju3BlDNQg3+FjLfYty/BQ3QUXeAolk=;
        b=KRXHXUOkMRh8Kt5Vaf2CjRWIzfWsSX+rC+cd6+FTN9KOsXT1sgI8uQqL4ebL31keWC
         /mfDBEt+xDV4fMhz/omSRt+penwb6os3W4AsXPLKfdPpLbIjrKWe7IBSgWlqnVKPANkU
         dZBIMh0XiJzTssPmYrRkSDPtTsJJ4FZAu/jdQVfywGsIeMp7dxEKuMnfXPffRN4y7mpB
         CO148MXri3LPfswcV14Q+SzGR4Yu1riHPLuDXW7OFVn3YDsIu2t/2FC/y5l5pjeoPFAQ
         YuZhJsj0m1aqP8Wqza673TfsCBpaDfWz0LJca9Q/sYPF+5FEqbIBGqPBbor8P1W5nE0L
         uEBQ==
X-Received: by 2002:a81:4ed0:0:b0:535:aff2:d264 with SMTP id c199-20020a814ed0000000b00535aff2d264mr31299515ywb.1.1680424898536;
        Sun, 02 Apr 2023 01:41:38 -0700 (PDT)
Received: from vps.qemfd.net (vps.qemfd.net. [173.230.130.29])
        by smtp.gmail.com with ESMTPSA id l133-20020a81258b000000b00545a08184e5sm1758510ywl.117.2023.04.02.01.41.38
        for <dankamongmen@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 01:41:38 -0700 (PDT)
Received: from schwarzgerat.orthanc (schwarzgerat.danknet [192.168.128.2])
        by vps.qemfd.net (Postfix) with ESMTP id 0048A2B83F;
        Sun,  2 Apr 2023 04:41:37 -0400 (EDT)
Received: by schwarzgerat.orthanc (Postfix, from userid 1000)
        id E24C2601D1B; Sun,  2 Apr 2023 04:41:37 -0400 (EDT)
From:   nick black <dankamongmen@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        nick black <dankamongmen@gmail.com>
Subject: [PATCH] [net] update xdp_statistics in docs
Date:   Sun,  2 Apr 2023 04:41:21 -0400
Message-Id: <20230402084120.3041477-1-dankamongmen@gmail.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: *
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the three fields from xdp_statistics that were
missing in the AF_XDP documentation.

Signed-off-by: nick black <dankamongmen@gmail.com>
---
 Documentation/networking/af_xdp.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git Documentation/networking/af_xdp.rst Documentation/networking/af_xdp.rst
index 247c6c4127e9..a968de7e902c 100644
--- Documentation/networking/af_xdp.rst
+++ Documentation/networking/af_xdp.rst
@@ -445,6 +445,9 @@ purposes. The supported statistics are shown below:
        __u64 rx_dropped; /* Dropped for reasons other than invalid desc */
        __u64 rx_invalid_descs; /* Dropped due to invalid descriptor */
        __u64 tx_invalid_descs; /* Dropped due to invalid descriptor */
+       __u64 rx_ring_full; /* Dropped due to rx ring being full */
+       __u64 rx_fill_ring_empty_descs; /* Failed to retrieve item from fill ring */
+       __u64 tx_ring_empty_descs; /* Failed to retrieve item from tx ring */
    };
 
 XDP_OPTIONS getsockopt
-- 
2.40.0
