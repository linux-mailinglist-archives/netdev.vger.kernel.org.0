Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAA0211671
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 01:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGAXCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 19:02:49 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:36619 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726213AbgGAXCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 19:02:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id EBDC17F2;
        Wed,  1 Jul 2020 19:02:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 01 Jul 2020 19:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kdrag0n.dev; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=1YAscWT5Mz6u+VNH7WtgDonrRp
        slfYO5bYDazpLN3U8=; b=BOfrmMmC/i27YrdqadTyWQ29h3hFFoPqQxIPzoaOZT
        t/z9TYlLOKq5dAkCsYA/mApCKR4iSmhgcWjvs4BXrc9tzlH2n7L0leJ5GhGmc7di
        PtQYWhvDlbgtj0v+wnY4nz0xD598DzSOcgoSw3uoVJTvggsYKKqm9xS1khq1kr8s
        H1NYdZpYcUZTdaQRMDlf3el9nhkH5QqLo+ITbdZXBt4l8sGxCZ+XP3AhgQzdqTLi
        g1CdgSv5WxnPk3d7fLFybRf5x2ocZYZ0fzUFZSoYE7LMEpbWgHsbgLtJ4WNQT3nO
        xylzQWNsrY0xR7YLMt7x2kktca7zJRfV6AY1d7/DfZCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1YAscWT5Mz6u+VNH7
        WtgDonrRpslfYO5bYDazpLN3U8=; b=kXcmCArL1NphLT0/LvDuxgrtSv/gcpg3q
        mKrEdfSjf/1ytbnxXxYQEg0bQZ9vLFVpap48pVxSdeTrfoMd2AVmPSfzSNnsjBkZ
        mKz6LTLujS76kDsYY7XuPz2W6LcrzzL+RE9iy8rVhODiI13JkNtzT9sQK1OuSk8J
        p1qYC7x9WohwzQQ7MafshTLomlcz4DFHHZ14K8673fkFGMYssoMLPYY3CB2ml4Ci
        nuTCtTfZ5cGY4cd9ulRvSPJfp1xXtBJTPzfTepCC5o6jm469szt5nhWjGk4PNt3z
        oeuul1G+Xxxlp8EK8AlYEInp31a9oIlDbCnPZGQSeDdgYGpv63+eQ==
X-ME-Sender: <xms:Fxb9Xu07M2EUCikYS8vqjlzn8ECw7wmwjTFPqu6008x4hc4ElTMiwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtdefgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepffgrnhhnhicunfhi
    nhcuoegurghnnhihsehkughrrghgtdhnrdguvghvqeenucggtffrrghtthgvrhhnpefhie
    fhgfelgfdufedvudelvdefvdefgfeiueeufeegteffudekgefhvedtieefteenucfkphep
    udegledrvdegkedrfeekrdduudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegurghnnhihsehkughrrghgtdhnrdguvghv
X-ME-Proxy: <xmx:Fxb9XhGOGXdJ4w96guThX0cdsViLA9offS20zh_0AMQal-0vo_JC3g>
    <xmx:Fxb9Xm4bkVjxs2R8zH2Agf20eZPz5YEYan1XZycJUbOB0Mm0OiPTGA>
    <xmx:Fxb9Xv3tuAYFy2yuMg1OwmD3UwCuKVVHIsT95KdH2HwglkFm8Mi4Kw>
    <xmx:Fxb9XlgPIsIsHBlJNY2SmoS7QxSnv81fEmKh2iTugxqZAYoxqBs5ZA>
Received: from pinwheel.localdomain (vsrv_sea01.kdrag0n.dev [149.248.38.11])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2DF7A328005A;
        Wed,  1 Jul 2020 19:02:46 -0400 (EDT)
From:   Danny Lin <danny@kdrag0n.dev>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Danny Lin <danny@kdrag0n.dev>
Subject: [PATCH] net: sched: Allow changing default qdisc to FQ-PIE
Date:   Wed,  1 Jul 2020 16:01:52 -0700
Message-Id: <20200701230152.445957-1-danny@kdrag0n.dev>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to fq_codel and the other qdiscs that can set as default,
fq_pie is also suitable for general use without explicit configuration,
which makes it a valid choice for this.

This is useful in situations where a painless out-of-the-box solution
for reducing bufferbloat is desired but fq_codel is not necessarily the
best choice. For example, fq_pie can be better for DASH streaming, but
there could be more cases where it's the better choice of the two simple
AQMs available in the kernel.

Signed-off-by: Danny Lin <danny@kdrag0n.dev>
---
 net/sched/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 84badf00647e..a3b37d88800e 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -468,6 +468,9 @@ choice
 	config DEFAULT_FQ_CODEL
 		bool "Fair Queue Controlled Delay" if NET_SCH_FQ_CODEL
 
+	config DEFAULT_FQ_PIE
+		bool "Flow Queue Proportional Integral controller Enhanced" if NET_SCH_FQ_PIE
+
 	config DEFAULT_SFQ
 		bool "Stochastic Fair Queue" if NET_SCH_SFQ
 
@@ -480,6 +483,7 @@ config DEFAULT_NET_SCH
 	default "pfifo_fast" if DEFAULT_PFIFO_FAST
 	default "fq" if DEFAULT_FQ
 	default "fq_codel" if DEFAULT_FQ_CODEL
+	default "fq_pie" if DEFAULT_FQ_PIE
 	default "sfq" if DEFAULT_SFQ
 	default "pfifo_fast"
 endif
-- 
2.27.0

