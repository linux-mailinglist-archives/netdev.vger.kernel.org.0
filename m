Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D64F4A471
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbfFROt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:49:56 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36100 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728572AbfFROtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:49:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so6237766wrs.3
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 07:49:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KWGq1BQI+Op5ioc0D5PcvjKjNnADNODlsUVMTriDrQA=;
        b=IsaVAllpwGhn5kZmD7oULJShZkFjeyS72ms9zpmjY89SgJj73+6RCGkGhKfFirY+yh
         Uce77JJSNt/wYxMDLSfweHw2/d4xxyWMI44XPA8XizhEtwoEQxDCZvswn/g33SrD4sFD
         QTsjxlWQ/Q1weqfv1D9/MywvAdbrNIDrYmf/TgxybqxnmoHezQ48LseiGpp0B22UwPrO
         EQSq7XQPlPetYmXp79U/3us05dak05clzTX14vCvc6tJJtJhggyiZUU39aCnB/8i9l1u
         oYBlwNEmpNeuN5qVmK6Peq4dOqQRX0X+NNK3HIlL4qcdkHWqDc4hyDQVHwGR190gkbrR
         y0YA==
X-Gm-Message-State: APjAAAUM8T1jcRHSgJ5LOwfBi8C2C1+T1wlm03jL5Z2EMk+wuDhkzjqV
        5GsXWm+G7jcnTxGuXY/9UkxyJpv/+7w=
X-Google-Smtp-Source: APXvYqzdhMp1dOJBV/KWtfG4c/Us+evByni/6ZQKPg0YlH9G7BjVaYaSdKgMz3cVzA4qNKZmEY4aiw==
X-Received: by 2002:adf:dc0c:: with SMTP id t12mr17762039wri.101.1560869394327;
        Tue, 18 Jun 2019 07:49:54 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y133sm4013788wmg.5.2019.06.18.07.49.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:49:53 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        Andrea Claudi <aclaudi@redhat.com>
Subject: [PATCH iproute2 v2 0/3] refactor the cmd_exec()
Date:   Tue, 18 Jun 2019 16:49:32 +0200
Message-Id: <20190618144935.31405-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the netns and ipvrf code so less steps are needed to exec commands
in a netns or a VRF context.
Also remove some code which became dead. bloat-o-meter shows a tiny saving.

Matteo Croce (3):
  netns: switch netns in the child when executing commands
  ip vrf: use hook to change VRF in the child
  netns: make netns_{save,restore} static

 include/namespace.h |  2 --
 include/utils.h     |  6 ++---
 ip/ip.c             |  1 -
 ip/ipnetns.c        | 61 ++++++++++++++++++++++++++++++++++-----------
 ip/ipvrf.c          | 12 ++++++---
 lib/exec.c          |  7 +++++-
 lib/namespace.c     | 31 -----------------------
 lib/utils.c         | 27 --------------------
 8 files changed, 63 insertions(+), 84 deletions(-)

-- 
2.21.0

