Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B13BEE89F3
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 14:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388970AbfJ2NvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 09:51:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20035 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388923AbfJ2NvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 09:51:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572357064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+Ptrz2Yswaus+WKDG/vA8NkrbE6i0FJ85P0xohydacQ=;
        b=bIwIy3WfalptrpmuhKEZawE1vJtp29PhYBB11AAHS1GoRejlawbrKM737MAe1OlQDUDfXz
        DMnkJz89lW7aJeozM5JYqgKS0/u7BPrMxJiuBbTsgvJyw34nCZ2lmGe+XsfKECgSIPZkdX
        LADtV05ZiuC6nhFr/4s0bZJ6ahNXuyQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-NgBMvHL5OviHZhUmixtWtQ-1; Tue, 29 Oct 2019 09:51:00 -0400
Received: by mail-wr1-f71.google.com with SMTP id 7so8490902wrl.2
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 06:51:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UlvxO01Z2Ul860RxIp3leF/YeqCFOTpWgj3ZwcjunwQ=;
        b=atdT1T/rw04pI89vDGGuL2CeKiW+MISM5/W/u9Yx/LW0lIBpbVPfSzV1oHYvEXTI6O
         cA6VMIR3rXGjjNwQik1YPuXDGkyAG9DafWmYsYcnwyL/ZM/zgRopP8wnsLPg7rrlz5be
         5BZptG5tCgmjeAoh4Kg+ODdN7jBjN23p0YPkN5gdeZNBMCQmI2U1h9d3cykovOykofrD
         WsaTjBy5am0icQXE83R4Z9CKkvEmf2cwVuEQlxoGHwkCmmiIIZ2IWYmsVpz+Fj8xeQTR
         CzKn7RVF6hiPlsoD1necb6cDuuW2qBpc/yzc1ZKklXD7ZSHi3ywoyYBFS9zOCBKcexXT
         4H0A==
X-Gm-Message-State: APjAAAVkfbs0cSsK3niOnvd2KSRNsdqmV/OrJPoF2vbncXOVqV0/MOhN
        Oc/Ildbw+J0DpuMezG8+QjIvIUiiZzAtR3jVoT63BNDhMto6XcvFxOsBBEniJfE1mzw8PloS1k8
        vN3N1ljyYcVI9z8Tw
X-Received: by 2002:a5d:4606:: with SMTP id t6mr19071448wrq.173.1572357059285;
        Tue, 29 Oct 2019 06:50:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxiNpbtiXQVaQtMbJhepi411mWyeAD9dyQuax48oQX25AnmundSwJpn6ZhYZJEjeyZL5wFNuA==
X-Received: by 2002:a5d:4606:: with SMTP id t6mr19071429wrq.173.1572357059102;
        Tue, 29 Oct 2019 06:50:59 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 189sm2556920wmc.7.2019.10.29.06.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 06:50:58 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller " <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/4] ICMP flow improvements
Date:   Tue, 29 Oct 2019 14:50:49 +0100
Message-Id: <20191029135053.10055-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-MC-Unique: NgBMvHL5OviHZhUmixtWtQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series improves the flow inspector handling of ICMP packets:
The first two patches just add some comments in the code which would have s=
aved
me a few minutes of time, and refactor a piece of code.
The third one adds to the flow inspector the capability to extract the
Identifier field, if present, so echo requests and replies are classified
as part of the same flow.
The fourth patch uses the function introduced earlier to the bonding driver=
,
so echo replies can be balanced across bonding slaves.

v1 -> v2:
 - remove unused struct members
 - add an helper to check for the Id field
 - use a local flow_dissector_key in the bonding to avoid
   changing behaviour of the flow dissector

Matteo Croce (4):
  flow_dissector: add meaningful comments
  flow_dissector: skip the ICMP dissector for non ICMP packets
  flow_dissector: extract more ICMP information
  bonding: balance ICMP echoes in layer3+4 mode

 drivers/net/bonding/bond_main.c |  77 ++++++++++++++++++++---
 include/net/flow_dissector.h    |  20 +++---
 net/core/flow_dissector.c       | 108 +++++++++++++++++++++++---------
 3 files changed, 160 insertions(+), 45 deletions(-)

--=20
2.21.0

