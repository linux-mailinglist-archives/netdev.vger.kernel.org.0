Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503F367AB2C
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 08:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbjAYHtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 02:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbjAYHtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 02:49:13 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDC440BD0;
        Tue, 24 Jan 2023 23:49:12 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id e19-20020a05600c439300b003db1cac0c1fso613275wmn.5;
        Tue, 24 Jan 2023 23:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6LJgasmO9PH76fUp0i98E0QbqnthyjGIC8nu/COY+Q4=;
        b=l8uvUp60OU19mnA6ikHIaIs5IkEIFl2IufEyujTfiXw+xkL4qRkZ4SrTogfS0WeXTF
         qlGaUP2vIALi/6cRNj5YCLY8LFYTXOd7iWCDqggkOXmxitX3HJQu8Z45dCTAxb3/WOzg
         Jj3cLUDivgLw3XZv9SMh7GpivQJDcsX3CzZoWOFS8kt2ZX/K2KJQgQz/qyWQCWCwlxM2
         OqT2bTaUWV1/0CylRbPpA79svMMt35Sgkhh6JmAkY63R+h35vSONhh3Fkvh9scqxvp3n
         siSdVFAw/MGGMzrqifscIgditf0KqJsDL69aokvSSOc0tcRoYpy8iUftmuMygj6U8Vfs
         T+qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6LJgasmO9PH76fUp0i98E0QbqnthyjGIC8nu/COY+Q4=;
        b=Zw1gsLeqSYKy5XR4pju7hsEDXkAUIILc/gGnSP1sOsKRpX09rp9NgaMzhOTY/Vp+LE
         h7bXhuYIYlWb5kXHmSo9heNGV2klD/c24VbzpFxdl7gnhfQ/6pMJzUrzNHh2qbG2iF/R
         oHwOE1+BxuB1KMomyOf7TLg98I9ZRc6FYfTI2hqXqqsvbWN83xcDCmtlN4XUZGckk23w
         6Z7/AH37EfC+RPI4BgexuR0QV6ZjCqIh0Njh7pcFu3QTB6ooAaLN2DlqhZUY+m76HW76
         p5JlEwnWPaPEpj3mNpPh9xHjcIrNbTKn7d261NbSO6omx6bEsH8+sa2LsCNshnyDpaIs
         WsCQ==
X-Gm-Message-State: AFqh2koSsQlVrF8PiHZjbMc3Y5Ft4yORwq2DBhxuYWNAVTVjE1fJZ17/
        O6ubdxVCKN7m5FVxsOtPWcZjxpF8EEO1jg==
X-Google-Smtp-Source: AMrXdXuF8ltl3cPyitQS/G2ed87ROm49TfTX6jOLt5Mxud376zWxVhMzIzxeNLwJmwc9tOBbcjcpFw==
X-Received: by 2002:a05:600c:3083:b0:3da:e4d:e6ba with SMTP id g3-20020a05600c308300b003da0e4de6bamr29857011wmn.14.1674632951213;
        Tue, 24 Jan 2023 23:49:11 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id n13-20020a05600c500d00b003db2b81660esm1032051wmr.21.2023.01.24.23.49.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Jan 2023 23:49:10 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, toke@redhat.com, pabeni@redhat.com,
        davem@davemloft.net, aelior@marvell.com, manishc@marvell.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        mst@redhat.com, jasowang@redhat.com, ioana.ciornei@nxp.com,
        madalin.bucur@nxp.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net v2 0/5] net: xdp: execute xdp_do_flush() before napi_complete_done()
Date:   Wed, 25 Jan 2023 08:48:56 +0100
Message-Id: <20230125074901.2737-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure that xdp_do_flush() is always executed before
napi_complete_done(). This is important for two reasons. First, a
redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
napi context X on CPU Y will be followed by a xdp_do_flush() from the
same napi context and CPU. This is not guaranteed if the
napi_complete_done() is executed before xdp_do_flush(), as it tells
the napi logic that it is fine to schedule napi context X on another
CPU. Details from a production system triggering this bug using the
veth driver can be found in [1].

The second reason is that the XDP_REDIRECT logic in itself relies on
being inside a single NAPI instance through to the xdp_do_flush() call
for RCU protection of all in-kernel data structures. Details can be
found in [2].

The drivers have only been compile-tested since I do not own any of
the HW below. So if you are a maintainer, it would be great if you
could take a quick look to make sure I did not mess something up.

Note that these were the drivers I found that violated the ordering by
running a simple script and manually checking the ones that came up as
potential offenders. But the script was not perfect in any way. There
might still be offenders out there, since the script can generate
false negatives.

v1 -> v2:
* Added acks [Toke, Steen]
* Corrected two spelling errors [Toke]

[1] https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
[2] https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/

Thanks: Magnus

Magnus Karlsson (5):
  qede: execute xdp_do_flush() before napi_complete_done()
  lan966x: execute xdp_do_flush() before napi_complete_done()
  virtio-net: execute xdp_do_flush() before napi_complete_done()
  dpaa_eth: execute xdp_do_flush() before napi_complete_done()
  dpaa2-eth: execute xdp_do_flush() before napi_complete_done()

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c        | 6 +++---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c      | 9 ++++++---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 6 +++---
 drivers/net/ethernet/qlogic/qede/qede_fp.c            | 7 ++++---
 drivers/net/virtio_net.c                              | 6 +++---
 5 files changed, 19 insertions(+), 15 deletions(-)


base-commit: 2a48216cff7a2e3964fbed16f84d33f68b3e5e42
--
2.34.1
