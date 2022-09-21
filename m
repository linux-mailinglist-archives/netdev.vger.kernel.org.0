Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2C75BF2AE
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 03:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiIUBVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 21:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiIUBVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 21:21:13 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B8D6E8A9;
        Tue, 20 Sep 2022 18:21:11 -0700 (PDT)
Received: from weisslap.fritz.box ([31.19.218.61]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1M8QFi-1ofEGj1psu-004SVW; Wed, 21 Sep 2022 03:20:45 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Paolo Abeni <pabeni@redhat.com>, Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 0/2] net: openvswitch: metering and conntrack in userns
Date:   Wed, 21 Sep 2022 03:19:44 +0200
Message-Id: <20220921011946.250228-1-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:kXdNCYr9qkIkQ/G2rddT+jcryJ80cRV+muK8wUT0VHYdsznKRze
 IQqT2pFTjYm/PIBvm9h9SoBgcZpYDxtIG26rcgSQSfkUoY3di/gkPb1RqMjLr1gSm4yEh2f
 7P8Z5hz+lluu2M9vxXRvcndigCX+tBsWskRxJDW61BGIWb/YWV7b1U8QJ20uHtG7+X88LOe
 FMFK6aQuv9uWFD6JjIRYQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:PsZjKvhrGFo=:Rk8R3BTsFZ7t/by0hJs7pY
 zW9kuRctOlVZxGfLQDQV1h4HZ2ZN9+o0c/xmQoUjJ0t3bQcqaTid6ECTI+YYHVEr8wEQ49qjg
 V5HM/XGuxhiBAZSjDYRZIOOmuVOKlZfUXH5XIbZVvOzQw+iv56SdR4Abiseu4dimr8tiLojZ3
 mCzseY7J08rTLp94ECKeL+Lw5FHZQJ8VqNFHY54Gjq0bCWbHZc62XfPnbpPB/qdwJlVVctDCF
 PNDw5gMD31RGU3HNKGoyMwD556F1rHY64wp0cXQZEQeZUzCmMWg4hHJ+WjZGr6neh66jHb+P3
 f8rTeoiL4hAvpKnNDEEH8YbqNHyCWSQoNLVtrXClDX0AfWP2+AQqM2kdGEIkrRmDQYKHdtIor
 QKJuOdN5OR8jm43CjTIjPxBYpfnwKPt1EYHASSrtUBdZG6IPRgJR/A8hCBcSXFPm07+bH6Fj0
 DTfDcsWCoiFOCYYVj7+x/5F3b1J4Zf3LdHYZJC4CXvqUy9C3fyYyo2y+KQv44nLF8ZzyonKO8
 A4QPxgjD6Ro38XgUWUvcxoh8UNHYQIJyPn+7uCHYgvV9ZhIGXvyYwyCYxScgl9sxvSOImymmm
 n2NRqi2xHThLCi9K5l1orCWVR0e1HAa0FG+tviEI0AWQBDFaqteeE8yg7lpl0Kil5k1utQHD2
 3NgAnZDbJ2J+Sp8C102RqkSEKF0Bg+YxSEMWePbRq47cXvZVUbl+/D+kTO8o6NPnyyRViVyck
 exSnpNWZGkdA6uJTLXQtUwh3KvHosiOBC6J/SBVkB8R+Yp5cJeeYu17cWhkDeo7APY7rjpo8t
 SFCOCnEUzSZFSG51aR0QZstB8WViw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently using openvswitch in a non-initial user namespace, e.g., an
unprivileged container, is possible but without metering and conntrack
support. This is due to the restriction of the corresponding Netlink
interfaces to the global CAP_NET_ADMIN.

This simple patches switch from GENL_ADMIN_PERM to GENL_UNS_ADMIN_PERM
in several cases to allow this also for the unprivileged container
use case.

We tested this for unprivileged containers created by the container
manager of GyroidOS (gyroidos.github.io). However, for other container
managers such as LXC or systemd which provide unprivileged containers
this should be apply equally.

Changes in v2:
- changed GFP_KERNEL to GFP_KERNEL_ACCOUNT in dp_meter_create()
  as suggested by Paolo
- Rebased on net branch of networking tree

Michael Weiß (2):
  net: openvswitch: allow metering in non-initial user namespace
  net: openvswitch: allow conntrack in non-initial user namespace

 net/openvswitch/conntrack.c | 10 ++++++----
 net/openvswitch/meter.c     | 14 +++++++-------
 2 files changed, 13 insertions(+), 11 deletions(-)

-- 
2.30.2

