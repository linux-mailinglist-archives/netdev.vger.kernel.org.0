Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C4823BDA2
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 17:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgHDP5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 11:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgHDP5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 11:57:01 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F82C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 08:57:01 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id r4so12568376pls.2
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 08:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vDfbRl0tlmqC2FJkqx65WivkgLK9V/eRwTdvczlRfWo=;
        b=YqJ6pcUKI5ZlqElosRa5dpzujH1M6Et4AuxlFy9e9K6As0tjeNvG3ioi2mj5d/eoYF
         SfJ9I/n7hEEMJsjyJPk8KVwg0E/cbgFXaswdJ4hAXlw0NbCY5GGfeocVvwqJmrTDeA7i
         4zYhdLZz0sxe6MdWG8OP9KnUYbasIfqL2KdwF21xdDBSOnK5txrhqrSfujpwA+752aYK
         sGCOpJpVpG4C4b0D/T9jH6U5b1y9Iwh8kaAiF0o3zY+4Tbe4SvJ5C+5jtc8Ci0CcuRvz
         Ehaw8vJ5VT2LN9ANhHKGejr/wktdOb/Y0oBpScJAi4Qw9xWy64nLCp9Jq5b8+LchG+aV
         yRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vDfbRl0tlmqC2FJkqx65WivkgLK9V/eRwTdvczlRfWo=;
        b=Kwzo0lH4Ktq2odmuj21QMPLRM1grN0uM1RHJjcPbj+4Sw2dqXagG+PUb7RVmdYZVfi
         jvOv2Ns+aX8P+8pDUIYTjgnz8l6jkV0m4ELgOfyL+XiZ2MzxRXgTKBzisyGs1cxE9+gm
         Q3nQm4VXqBxwXe/f3xmljWXZs1rhfXEN7T+uDQpXwJrDOJBDEeS4kOmztyDSCkBh10+y
         VCmPdcs9N3aNY2jRK9RW0daN8kpf6+UCGOVojGx7F2tsHks1ycN3NPWKG+mku3Evz8Cy
         V7w2dBpM+ghdt6JjVngDw1OwOKc5uKcH24zj6ADUu2dGrCA5TsFVx595j3zqt9q7c9Jr
         FVpQ==
X-Gm-Message-State: AOAM530pBAxxly+qQdF0dJ21al4umF6RDeNbWJfhWbJ0CRCqfiriGdgL
        WgpdwnZx/Iv2XHjF6i21v4s3lGzLQw8=
X-Google-Smtp-Source: ABdhPJxGsZPRW2E6PLnY3fvsUJLCFO6JDd3UgHctKzcHZvJ6DTaZJhRXTq5JIx0erSOYqAyeNjkK6g==
X-Received: by 2002:a17:902:d30b:: with SMTP id b11mr19843735plc.107.1596556620536;
        Tue, 04 Aug 2020 08:57:00 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id mp1sm2912025pjb.27.2020.08.04.08.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 08:56:59 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [PATCH net-next] flow_dissector: Add IPv6 flow label to symmetric keys
Date:   Tue,  4 Aug 2020 08:56:42 -0700
Message-Id: <20200804155642.52766-1-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The definition for symmetric keys does not include the flow label so
that when symmetric keys is used a non-zero IPv6 flow label is not
extracted. Symmetric keys are used in functions to compute the flow
hash for packets, and these functions also set "stop at flow label".
The upshot is that for IPv6 packets with a non-zero flow label, hashes
are only based on the address two tuple and there is no input entropy
from transport layer information. This patch fixes this bug.
---
 net/core/flow_dissector.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 29806eb765cf..d72e13d125fb 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1765,6 +1765,10 @@ static const struct flow_dissector_key flow_keys_dissector_symmetric_keys[] = {
 		.key_id = FLOW_DISSECTOR_KEY_PORTS,
 		.offset = offsetof(struct flow_keys, ports),
 	},
+	{
+		.key_id = FLOW_DISSECTOR_KEY_FLOW_LABEL,
+		.offset = offsetof(struct flow_keys, tags),
+	},
 };
 
 static const struct flow_dissector_key flow_keys_basic_dissector_keys[] = {
-- 
2.25.1

