Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 457F63563F
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 07:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfFEFgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 01:36:46 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38764 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfFEFgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 01:36:46 -0400
Received: by mail-pl1-f195.google.com with SMTP id f97so9287904plb.5;
        Tue, 04 Jun 2019 22:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EoVTGCkzRKlsrQM0KP0hkT+qqBXrIHjwEhfwy+BVosY=;
        b=HANnN8mL02ee0t04/AXj+ZpDz+rirxf0b9ulIbVPx0zrI0pfYVXyx5hzDxMlEBNhsn
         u2LcB0QvXqhmu3AW7vzl2AE5D0OXreU95kK+mqFhY/Y3x0TJtVHsowLpT6vjmAt2FANW
         4MHWfcshLW/LyEfD68ZELxF2HL/PMxRQTx6s7FbtlVQPHpEuwB8eCYTlST+A4bdU4PD1
         GP/ed/NTnsS6+Dth5Kn+e0YQpbBOGAhv2TaTnKbo/BgU5hjOwelFb3L8jt8zGirXq0Ks
         xnyfSSsfuQIutDSxco8Mhb3Ta1T1rMM0z6QOYUrMXC1EJ3XrwYVI8ErxOcdI7wWd1GtV
         HKIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EoVTGCkzRKlsrQM0KP0hkT+qqBXrIHjwEhfwy+BVosY=;
        b=AxRpIa6NP+X3SiKA+e9N+lIII5kcWw+3W7tpB+n3k/6ZnZoPV9YGoOAVOH1hC+kVE3
         4qqlrsENMMDw0RPXHtLvfMPEwzTsnjf2xec1emcedjVGZsSXMxKez+nbYepripSR5SmN
         FzrXg9CsUdtPb+zilMTD0uG8Um2wwVeDQnIOAfF7NTC1LCHqKh5uP49aYvbMr8tPFG6J
         NnARPsi0zjl+tiWXpGR1jKaGenFNWQNrZ/3ls0AJ0wlrPwPMBVR8fu8OfNeUqq+fM9h2
         BB8xQi0h8eaS6+dYXTma0BZJ8seAMG9Sl5CFo7ffa7d8dtWQMRxPEhQIU6fa9KKfEr/e
         CZaA==
X-Gm-Message-State: APjAAAXlb5+r/B3TSN6mmVprLeB6QsaEO0OXBNGrZZ+doV+maWAk2tcW
        ZaWht81ye4NOmhbV2v1ECH0=
X-Google-Smtp-Source: APXvYqyjPyOdXCO+W0BhMOOPaqG9bwVS7teGzVKWTPQozsN2REw/INAOd5UFa5RWlRpR2zFcm3t08w==
X-Received: by 2002:a17:902:28ab:: with SMTP id f40mr40795510plb.295.1559713005624;
        Tue, 04 Jun 2019 22:36:45 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id j15sm22745816pfn.187.2019.06.04.22.36.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 22:36:45 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH v2 bpf-next 0/2] veth: Bulk XDP_TX
Date:   Wed,  5 Jun 2019 14:36:11 +0900
Message-Id: <20190605053613.22888-1-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces bulk XDP_TX in veth.
Improves XDP_TX performance by approximately 9%. The detailed
explanation and performance numbers are shown in patch 2.

v2:
- Use stack for bulk queue instead of a global variable.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

Toshiaki Makita (2):
  xdp: Add tracepoint for bulk XDP_TX
  veth: Support bulk XDP_TX

 drivers/net/veth.c         | 60 ++++++++++++++++++++++++++++++++++++----------
 include/trace/events/xdp.h | 25 +++++++++++++++++++
 kernel/bpf/core.c          |  1 +
 3 files changed, 74 insertions(+), 12 deletions(-)

-- 
1.8.3.1

