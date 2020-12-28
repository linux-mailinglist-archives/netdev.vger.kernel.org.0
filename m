Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFD32E6752
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 17:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633331AbgL1QXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 11:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441014AbgL1QXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 11:23:18 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1438DC0613D6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 08:22:38 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id d11so5133453qvo.11
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 08:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ds2qIQ3CIy8ER5iAyqIpSFRnqjHxdJqLZeRLwlowhag=;
        b=rrjmLQUrtYMBmmD8EwaGJ1Bt7NxhzC0ChFF8hq5Eo02cgtktccgntzN0kN9cfOYq+D
         DtET9XvP92NgaCrHpPbTWwo8Gff4C0F2tSnvmGUtuIIPzG7GDxT2duaC4rku8PD5Y8BS
         P0bsrUrYczea0/DpxXB0EzViP6ZvUPQk+oS9byvMfsAJ5xcqnN2NCg3mFueqkMeTVmuG
         +ep0RtU7D5wWWpx8R5rQTkWRN4HrxqSeAEmzOm0XAF65XJbvt5jPIx3wmclExke1cUVJ
         h5VDz6DLQiGvxxpLHMDAiHlWU7NjoRhv2tznVLb+bGrNZYLcVcMf60pKtf2F36wHd941
         GB/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ds2qIQ3CIy8ER5iAyqIpSFRnqjHxdJqLZeRLwlowhag=;
        b=mWTRQzkBJFcqsoW2Ax1XIP2QYuiPRYK1FEFn44kiuYK8jf2gcfzFTOdjHdsWLJBKrc
         OYNB0R5905ECtsRMpvygChatnqkGwg4uQy5Juw0AZzY7ztYDLUCwNNq/UdcCdQy9DLEJ
         iLcXi/hYy3mBpcUAQUfVi1ZUQIkqUU6Nf0zY6wrDjO6WLyNYmQKre1FQg96FpQ4C8o6+
         p8wl4ECaP/UdkzppBKBkDqma4h4VpAaxmcuI9bXT9mTUSg3Dz+5UutFpenvAziX9R2AJ
         qm2vTH0oeMs2uhggTnhQDmmEgGHjo+FjijyuaQ4mKluOwl2hFHfEr9/27hZO1tS5g1K+
         7SdQ==
X-Gm-Message-State: AOAM533H7JlVZ0s9M7vuQKxwV4N0g4SU1azPpbfKz174AbdRvcb1Uqk2
        RASmrtw8zv1DMfqB1HBNhxstWlJd2w4=
X-Google-Smtp-Source: ABdhPJwLYDd8/DF/QrvENX4G+Kh3drp769zSKvqLtT6HngYBfsrfFqkEzn9wH23hrz2IvJgFlKoMwg==
X-Received: by 2002:a0c:df94:: with SMTP id w20mr47587823qvl.33.1609172557307;
        Mon, 28 Dec 2020 08:22:37 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id u65sm24005556qkb.58.2020.12.28.08.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 08:22:36 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH rfc 0/3] virtio-net: add tx-hash, rx-tstamp and tx-tstamp
Date:   Mon, 28 Dec 2020 11:22:30 -0500
Message-Id: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

RFC for three new features to the virtio network device:

1. pass tx flow hash and state to host, for routing + telemetry
2. pass rx tstamp to guest, for better RTT estimation
3. pass tx tstamp to host, for accurate pacing

All three would introduce an extension to the virtio spec.
I assume this would require opening three ballots against v1.2 at
https://www.oasis-open.org/committees/ballots.php?wg_abbrev=virtio

This RFC is to informally discuss the proposals first.

The patchset is against v5.10. Evaluation additionally requires
changes to qemu and at least one back-end. I implemented preliminary
support in Linux vhost-net. Both patches available through github at

https://github.com/wdebruij/linux/tree/virtio-net-txhash-1
https://github.com/wdebruij/qemu/tree/virtio-net-txhash-1

Willem de Bruijn (3):
  virtio-net: support transmit hash report
  virtio-net: support receive timestamp
  virtio-net: support transmit timestamp

 drivers/net/virtio_net.c        | 52 +++++++++++++++++++++++++++++++--
 include/uapi/linux/virtio_net.h | 23 ++++++++++++++-
 2 files changed, 71 insertions(+), 4 deletions(-)

-- 
2.29.2.729.g45daf8777d-goog

