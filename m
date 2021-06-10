Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8A53A3357
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhFJSlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFJSk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:40:58 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B0AC061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:39:02 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id if15so4401993qvb.2
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9G474QRmmAjLiQADd887poTIVnN5MD75j0r48SsuWC0=;
        b=m8hZue/ecKuK8bsbsz/Rj0vZ+L06X82yT7SDNAjZBNzC0zFgyeZyadGQY9fzoHAOrk
         rO4lQLNdK4z9RDAErp5LOrWLlT/zs8aqfxP5caKTHj/enDE+pRDuP7WoFcVvY1HncHpO
         ciivHbM3Xn5vvOBP1rSNBuyBySMNLg+wA69vcD8qP30eEvY4bHtWjm1wONu7JrZtUXXU
         eYIEeZ7YQ2wwWQx87C9pmSgrYmk8xZMPC3ok+PgHzp5FGrGIKMhNP6l1vuhJU9a4FO2U
         5WA5Q5WI3YakQaYMHAZEpaIxYszp4Dncc6MIFodpB9g+pgmso11oCEk99V9WTSeWF+yN
         VWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9G474QRmmAjLiQADd887poTIVnN5MD75j0r48SsuWC0=;
        b=s1hkWIdPRahbU7s3Br0LSNNWTRTPADOAiuDXrqm/Q0A7cu/vDV1QojgofTVboe20Mm
         x4WaVU59Q2tReTQ/Lpu6yys29P3fvMUo7Nbm+a+SCcjeDzwQR5uRsx9LToROGeHVXsCn
         grIa1WKjvOmEoqMhx9cKKigRIJWEJftJRgJOuJdf8ij7kKgRMOx1EguCtWf/59HfH/F7
         UTuJF3/T/N3fR2+bAvPRhWnGkN01sZNsLLXmOXnY72Nm4evr2Vzk3MErJAk6P8PkJrUh
         l7b58cjtT/cye2wC4gxp9KCRA0QyIfslEWDK2P6D+OenOSa0mpBpMDuELJLKvkOZ4Mf0
         4Myg==
X-Gm-Message-State: AOAM533hJ0J3gtx0VF0ZnT7N8b+fOxxOsxsbKgMp/kZOq7TZ56nhFUeF
        ruyMcjNYzJ+Of+dZ7AaISmKJhYjX4p0=
X-Google-Smtp-Source: ABdhPJyV2Ul/mQERi3LZiwn/BTcx7akifXINQXaddl0KcjZmBBZk39gFCNlVQi1G9kLeTp3kCP/+hw==
X-Received: by 2002:a05:6214:11b4:: with SMTP id u20mr1091586qvv.4.1623350341445;
        Thu, 10 Jun 2021 11:39:01 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:840f:b35f:63b2:482e])
        by smtp.gmail.com with ESMTPSA id a134sm2760350qkg.114.2021.06.10.11.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:39:01 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next v5 0/3] virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
Date:   Thu, 10 Jun 2021 14:38:50 -0400
Message-Id: <20210610183853.3530712-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

First patch extends the flow dissector BPF program type to accept
pointer to virtio-net header. 

Second patch uses this feature to add optional flow dissection in
virtio_net_hdr_to_skb(). This allows admins to define permitted
packets more strictly, for example dropping deprecated UDP_UFO
packets.

Third patch extends kselftest to cover this feature.

Tanner Love (3):
  net: flow_dissector: extend bpf flow dissector support with vnet hdr
  virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
  selftests/net: amend bpf flow dissector prog to do vnet hdr validation

 drivers/net/bonding/bond_main.c               |   2 +-
 include/linux/skbuff.h                        |  35 ++-
 include/linux/virtio_net.h                    |  25 ++-
 include/uapi/linux/bpf.h                      |   2 +
 kernel/bpf/verifier.c                         |  50 ++++-
 net/bpf/test_run.c                            |   2 +-
 net/core/filter.c                             |  26 +++
 net/core/flow_dissector.c                     |  21 +-
 net/core/sysctl_net_core.c                    |   9 +
 tools/include/uapi/linux/bpf.h                |   2 +
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 208 ++++++++++++++----
 .../selftests/bpf/test_flow_dissector.c       | 181 +++++++++++++--
 .../selftests/bpf/test_flow_dissector.sh      |  19 ++
 13 files changed, 495 insertions(+), 87 deletions(-)

-- 
2.32.0.272.g935e593368-goog

