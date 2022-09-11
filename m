Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B4A5B5054
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 19:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiIKRjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 13:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiIKRjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 13:39:21 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED582A418;
        Sun, 11 Sep 2022 10:39:17 -0700 (PDT)
Received: from weisslap.fritz.box ([31.19.218.61]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MJnnV-1onAOA3yMT-00KAO0; Sun, 11 Sep 2022 19:39:00 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     michael.weiss@aisec.fraunhofer.de
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] net: openvswitch: metering and conntrack in userns
Date:   Sun, 11 Sep 2022 19:38:23 +0200
Message-Id: <20220911173825.167352-1-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:AhfznFilIVXcoGRvyKPUgYAuCNw3Wd2UL7Sj/tF9+KXiCF+KvxC
 xeIjhWi92HO0Wj5CTthFC+9bHUnXdHzp4F1Btc96+jbyab/I4b6skqLxdcpH6LAVwLjWjZ4
 L65SsCGYYgofDtoOoYqXEN30OvnKTEpuO6Os3EZujDOU3e3iPaKqhVl0N/qX0Y0khV8QpzH
 cyteaEsfdXTFwpIrtRC4g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:LyFaqgxewn8=:arNHfqIIk9Oz+5Gse3dhIu
 xKYpukUpOvTPpNm/VAB4MGg5cKmB1bZ98JbQVi/Y8ofA1D2LHDW0TSRRwJC8efxLg5ooP3EEa
 dJYxT3gsEOPiM0Pggx45XGHrJj5xSyf4QR5mZM36EcWzvHyd/T1MYn9oM1PX4RzSLCiGW3HZa
 XBTlQ0HCeYW61D1Ti2KwR9RoPMcsUAky+kRYQtvHF084TzazrkZxIPTXngTSNkTcMbvNFr/wq
 zHWL5ZmyQLvRoqKDHqxkmgejEC1ziHkfGqg83QWOsrsJTdYrdB+kqduJmr3/yMrzugibsAL+1
 YnWlFZUAMhTGL5Yn/r/lZsJmYwbfSWAQrLUctWKfTK0tfLpM9LDOIAzsaEpqTmXz18Ym/sxct
 T+cbduOg+3y8sBAotMaaLNaxqNBc0qTgTOi4vEGPQ1/VNPMnDGSxF2BeiJX6EDJfSyj+yaBWT
 94HaAbradqi9czvxgFdhMsjLLWW+8f7fUOyYSNNiQBQPxpMPE7n7jvlnR3wuwE9m7jPb5ZZd1
 pS9TKXxzR1LyOz8VWPrC93FvUsPy0+AVwthL9pB01iMqzxRfe53rg0abBqDqQN2ymjyrXMH1o
 THbp0WnWeKatj93E6tOEBViEuVT7SLYD/+QcAV1p3cOMie0zrhGl71ugL+HyNYtnPpZ/6a6AV
 au7jDZZNPdCjPo88qdp75jZ2STY9L4FgNHaBkEFiD16rHXAtga3wGaKjFkA2BWIXkK7A/15vG
 cnlPOew30SlTSrLnZmM+rQomZjaIK32f9hBqJzyAM4QMhwWqlYI7FimavTSZuHmn7FXddx/7R
 fwMdqX/FQt9g5VTcQcoWdMB4jShuQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently using openvswitch in a non-inital user namespace, e.g., an
unprivileged container, is possible but without metering and conntrack
support. This is due to the restriction of the corresponding Netlink
interfaces to the global CAP_NET_ADMIN.

This simple patches switch from GENL_ADMIN_PERM to GENL_UNS_ADMIN_PERM
in several cases to allow this also for the unprivilegd container
use case.

We tested this for unprivileged containers created by the container
manager of GyroidOS (gyroidos.github.io). However, for other container
managers such as LXC or systemd which provide unprivileged containers
this should be apply equally.

Applies against v6.0-rc4

Michael Weiß (2):
  net: openvswitch: allow metering in non-initial user namespace
  net: openvswitch: allow conntrack in non-initial user namespace

 net/openvswitch/conntrack.c |  8 ++++----
 net/openvswitch/meter.c     | 12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

-- 
2.30.2

