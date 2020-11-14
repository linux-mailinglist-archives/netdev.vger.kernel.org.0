Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60692B2AFB
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 04:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgKNDX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 22:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgKNDX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 22:23:59 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2301C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 19:23:58 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id u2so5474704pls.10
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 19:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jIjEwcVfoyvE99EtJypQeIaMH5FzX3VQ8l9t7SX5eOw=;
        b=R5gmnzVUSze5BS4VA05IxtZ29MZDeteqeZ9KXNiI+hvAC5spmL55MtwvkrcNkPT3KT
         TRCwFMeeDPiV3pXcujkysaWczSzjaMT6lNhPNUSmo9+9k/2A3Epe0fz/QXwhyoeqAROI
         fWByoB41AJfhldpPzV2zPEcVlu5kaoF5N1qLRA/o+etgtm4/4k4yyJircnlw3+Ec4P+a
         jFm2GUhSl4UCe6b94xVQBgjJVV9EOre2fJe3Ee2ZeB1PXWras2M5rQS9qO2HSmqi0RKK
         s06GqAJ67iNHf4HMRs0wCMKQlDCXvgXoLuzaSAEM3nySuIvHjbdk/iyT9yRx2vb2HP4/
         /MqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jIjEwcVfoyvE99EtJypQeIaMH5FzX3VQ8l9t7SX5eOw=;
        b=FtmAHzeZVHDF5P3feSiCFobsc3jywuyPVzQXSuJwDe+Xoil04wGlFZTLCnPoC7v45b
         mMkp9ND061ZUwxoU3N2cJxTrjzWY2Q8FXz9eXdPxKjhUJQZkvjgGVCdHXjeJXdZjVwI9
         a4ClVuq+4EOvIZSjYOp7Ujm6LS+1IfSRDzJPxgfcUSvqg218/heTqJZamVef7ej2AgNc
         j+1FLKhEJZzM6jaWfoq3jBmZnEYxGLAL+pBou9WPHg6Neb+sqfFZIX5nJTWyFpZH4jS1
         S6LJvNOLHO4llE+DZroliDfCHU8vfPG303iyD7xlJ8LCO3992JAnt1xoeCjMJg+lEasy
         rHqA==
X-Gm-Message-State: AOAM531Nbay1r69xNlLt3sxt6dF0V0YPjJLTGabBkdRZzmXU5uCaa8Lc
        gur9/3Jx/pBiq5wuKXnCHBt/3+Z0F232iSFk
X-Google-Smtp-Source: ABdhPJzV57CmBC7rYHWmyuc0g0RXtnzD+nUYY1Cw8RHYeRvd37/TqGkrVxDQAWKhXO8UEL4+Gn0rCQ==
X-Received: by 2002:a17:902:8f82:b029:d6:d7e4:6451 with SMTP id z2-20020a1709028f82b02900d6d7e46451mr4455438plo.55.1605324238390;
        Fri, 13 Nov 2020 19:23:58 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id mv16sm12496183pjb.36.2020.11.13.19.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 19:23:57 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 0/3] Add support for sending RFC8335 PROBE 
Date:   Fri, 13 Nov 2020 19:23:56 -0800
Message-Id: <cover.1605323689.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The popular utility ping has several severe limitations such as the
inability to query specific  interfaces on a node and requiring
bidirectional connectivity between the probing and the probed
interfaces. RFC8335 attempts to solve these limitations by creating the
new utility PROBE which is a specialized ICMP message that makes use of
the ICMP Extension Structure outlined in RFC4884.

This patchset adds definitions for the ICMP Extended Echo Request and
Reply (PROBE) types for both IPv4 and IPv6. It also expands the list of
supported ICMP messages to accommodate PROBEs.

Changes since v1:
 - Switch to correct base tree

Andreas Roeseler (3):
  net: add support for sending probe messages
  icmp: define probe message types
  ICMPv6: define probe message types

 include/linux/icmp.h   | 3 +++
 include/linux/icmpv6.h | 6 ++++++
 net/ipv4/ping.c        | 2 +-
 3 files changed, 10 insertions(+), 1 deletion(-)

-- 
2.29.2

