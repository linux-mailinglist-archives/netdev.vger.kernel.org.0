Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FF03ABE65
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 23:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhFQV4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 17:56:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38576 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229915AbhFQV4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 17:56:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623966866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oq9kffVK8f1Sa0DR5BkzICWYZziNXpt3UUdoQe11Qgo=;
        b=eoXdI0Doe1X3nj+DfVRMLC4KKt4UtQ7EBGyZInytzstwosE4NnjK4yq6hKuOZaBIMTNhS2
        DbK6/zY5L6vZ1tS2dzcmgA4uXIGevfGk7fNNpI+5k57fK7jktb7GuKm5Joj1JPjq8NXDP0
        anbazkRqrcAO4zMJ4v+jJVpixoCZiec=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-mbxebExuOHOVMDp8VhDjHA-1; Thu, 17 Jun 2021 17:54:25 -0400
X-MC-Unique: mbxebExuOHOVMDp8VhDjHA-1
Received: by mail-oo1-f71.google.com with SMTP id q14-20020a4adc4e0000b0290249480f62d9so4716119oov.0
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 14:54:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oq9kffVK8f1Sa0DR5BkzICWYZziNXpt3UUdoQe11Qgo=;
        b=Ve0sjno6yTe8Dg2LobSpVHwFfNYaJnepwqwUZwwXMdjXH7lmxVr6c2Xxl/A+lNodaq
         CjqYAHOAF8xUX3KjEp4Fezvvd8NC1CuspugGasY33ZbODvMvgvL50/OS4nzYyi6McC6M
         GJTGum2jv41/JkalUpisEtFMfMFx4zHBLaZudACNK71XuDmnn3m/A2kVUhlpcBy6WLXI
         awe0QV7/kA2ExveM5Mfni754MPe3HFKpKx9GM8UBlYPgoGtbTgX6Vn3ZVTscV9gCnWQp
         xk6bK2fIJw1aAWcPH9KhenRSsPoOLbabH5q8J5oiMWNW7IaGR8yDi4QngOFbZY8Y9pmn
         CTwg==
X-Gm-Message-State: AOAM530mRlWzhU2RmT9aMGxGWpNzIRXBLSdYjOUpKmeMhT4OvWAMXopb
        9FXonHecNk0oBNNfVlHzujwDQ7Womt/DM7RXUrxaiGak5sV5fDeR1DLI3BvI2444zLiBXUkDHsm
        Zz8yrKOwpkQotwOsH
X-Received: by 2002:aca:ab4c:: with SMTP id u73mr4958312oie.26.1623966864511;
        Thu, 17 Jun 2021 14:54:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyo7BwMtFjeIYDSFNCTepqIb+7Z7yOe/HtmPkjlgbgsZe5nw6U0ZtyUF9gTPIhaoCEL7PLD9w==
X-Received: by 2002:aca:ab4c:: with SMTP id u73mr4958310oie.26.1623966864411;
        Thu, 17 Jun 2021 14:54:24 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id q11sm1414494ooc.27.2021.06.17.14.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:54:24 -0700 (PDT)
From:   trix@redhat.com
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] ice: change return type of ice_ptp_request_ts() to s8
Date:   Thu, 17 Jun 2021 14:54:19 -0700
Message-Id: <20210617215419.3502075-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A gcc 10.3.1 compile error
ice_ptp.h:149:1: error: return type defaults to
  'int' [-Werror=return-type]
  149 | ice_ptp_request_ts(struct ice_ptp_tx *tx, ...
      | ^~~~~~~~~~~~~~~~~~

This stub's return needs to match the decl for
CONFIG_PTP_I588_CLOCK, which matches its use in
ice_txrt.c

Change the implicit int return to s8.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 41e14f98f0e66..d01507eba0364 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -145,7 +145,7 @@ static inline int ice_get_ptp_clock_index(struct ice_pf *pf)
 	return -1;
 }
 
-static inline
+static inline s8
 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
 {
 	return -1;
-- 
2.26.3

