Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB16333700
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhCJIKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbhCJIJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 03:09:36 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80566C06174A;
        Wed, 10 Mar 2021 00:09:36 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id e7so32021976lft.2;
        Wed, 10 Mar 2021 00:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lPoLy6iry9bp7nyGZjIyjIuU2UCPeHladdDawX+/oBM=;
        b=jWZN+ZpeZawy3hzTZNzE8wHigDOngslxR0g3MWsO7og6gH65vfoxx0UvPO5ZJ5cyIv
         sIO2UuqSKHHS1wwL67t9CROro34RvkAfhYZLina47Qqgdlv4I2WVRWPq/nE0UVupYa5n
         PZBmktrQHp6aH0x/GOzV+EkG/GH0BMz4x7F+0b6VELByRirgYpisSYAj7ipbQoFlhw/y
         9IWhO/udIhqoatQiNmFZjCTWXHtFq+mRC1Y1vL4Q0uBAYeC04SlpB/grsbhAXKtvE95U
         Kj23LfVmwwN09Uj5W1WIzNe64WY8GtFwL/XD4pcmN8sA8+hKxa0UUqhnCJufqCa1n0U8
         Msaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lPoLy6iry9bp7nyGZjIyjIuU2UCPeHladdDawX+/oBM=;
        b=HLXqELlDhVwZ6ubIWtkdSjxHJDdyao68Wp6QQhWZXeHfbD5IPNGC0thtcCHWDBUGET
         tU+DH/Ec0uiX5Y6KmYuZpM3qI+SHbb83ukexesz3YCJ0+pX3rB6Qkns/ut/MxNW1YbCX
         tTlE+k/Op2YNxtDi7frD9cBmOq/lgO0mXle115p5PWpuDE0ga0FdkfVJzeunpDnpFr9R
         b6eYDLQcnsVcRR2C8EEZxWQ0zTQe/9atZQq4P1TWX/ItGcrwP/xw4PwZ/YBNjcrouVAm
         NT04O1ILI/wOIDhNPVyDCw/DvWHJ2xm2WZlVNiblrY8HOQXxIXeEM4ljjX9fV0U/b5yx
         nT1A==
X-Gm-Message-State: AOAM533cUKi2TKXwlNwpqCN7+YNxcztAA0qsEvi4C+DvCaCNDtUdbgoV
        njsYzeiAlp/iTWWGBUQLFCcADSqiBLxNHA==
X-Google-Smtp-Source: ABdhPJzu/SRNStd9lF6UFbr9McR9tHrmSq+zXl47gRWCY7i/GqB0TBxN+7iYzeXSRzrJSUbC1yPV6w==
X-Received: by 2002:a19:ef02:: with SMTP id n2mr1286253lfh.141.1615363774987;
        Wed, 10 Mar 2021 00:09:34 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id x1sm2812130ljh.62.2021.03.10.00.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 00:09:34 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, andrii@kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, maximmi@nvidia.com,
        ciara.loftus@intel.com
Subject: [PATCH bpf-next 0/2] libbpf/xsk cleanups
Date:   Wed, 10 Mar 2021 09:09:27 +0100
Message-Id: <20210310080929.641212-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series removes a header dependency from xsk.h, and moves
libbpf_util.h into xsk.h.

More details in each commit!


Thank you,
Björn

Björn Töpel (2):
  libbpf: xsk: remove linux/compiler.h header
  libbpf: xsk: move barriers from libbpf_util.h to xsk.h

 tools/lib/bpf/Makefile      |  1 -
 tools/lib/bpf/libbpf_util.h | 75 -------------------------------------
 tools/lib/bpf/xsk.h         | 68 ++++++++++++++++++++++++++++++++-
 3 files changed, 67 insertions(+), 77 deletions(-)
 delete mode 100644 tools/lib/bpf/libbpf_util.h


base-commit: 32f91529e2bdbe0d92edb3ced41dfba4beffa84a
-- 
2.27.0

