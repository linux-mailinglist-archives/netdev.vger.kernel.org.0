Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771DD504A39
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 02:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbiDRAxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 20:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235050AbiDRAxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 20:53:08 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13F213E3C
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 17:50:30 -0700 (PDT)
Date:   Mon, 18 Apr 2022 00:50:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=protonmail2; t=1650243021;
        bh=75Tpo+HGOA92D2kzNg7s2ac7IWzgwCC10Y5QV0uZWNk=;
        h=Date:To:From:Reply-To:Subject:Message-ID:From:To:Cc:Date:Subject:
         Reply-To:Feedback-ID:Message-ID;
        b=RD4Pb5wjSIWIItRkRE1ouO5bLorQmlM0mTa6SlLwtiAJdD5PnBC88k38eMI0zrqNb
         LHo70XDI0YbO54QCT9tHfu+Nnl8Xblgf7IPhZ1t5Lyr4OTZOwlTHx8q03EWoJl9Oqw
         M9VsrSLqIBEGcMCVzAIdoS6kOptwMF3XeZenvVTNfkOcwB8x8hVMKvnG0RI5l3dAMD
         gRVq//98cRvDFIg+horcB/XmOSWY4PN1p5gEQoYjPXFfO1vwOCySk8m+8CuO6tpJ1T
         lv7dTqV17L+mtYCouRVQa6pDheHyX63UPA9UFgWohAuSWLIRAjOqDwvINFtVvsRnYa
         mkkuIOt13LEWA==
To:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
From:   Solomon Tan <solomonbstoner@protonmail.ch>
Reply-To: Solomon Tan <solomonbstoner@protonmail.ch>
Subject: [PATCH] openvswitch: meter: Remove unnecessary int
Message-ID: <Yly1t/mE6QAGPS0e@ArchDesktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses the checkpatch.pl warning that long long is
preferred over long long int.

Signed-off-by: Solomon Tan <solomonbstoner@protonmail.ch>
---
 net/openvswitch/meter.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 04a060ac7fdf..a790920c11d6 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -592,8 +592,8 @@ static int ovs_meter_cmd_del(struct sk_buff *skb, struc=
t genl_info *info)
 bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
 =09=09       struct sw_flow_key *key, u32 meter_id)
 {
-=09long long int now_ms =3D div_u64(ktime_get_ns(), 1000 * 1000);
-=09long long int long_delta_ms;
+=09long long now_ms =3D div_u64(ktime_get_ns(), 1000 * 1000);
+=09long long long_delta_ms;
 =09struct dp_meter_band *band;
 =09struct dp_meter *meter;
 =09int i, band_exceeded_max =3D -1;
@@ -622,7 +622,7 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_b=
uff *skb,
 =09/* Make sure delta_ms will not be too large, so that bucket will not
 =09 * wrap around below.
 =09 */
-=09delta_ms =3D (long_delta_ms > (long long int)meter->max_delta_t)
+=09delta_ms =3D (long_delta_ms > (long long)meter->max_delta_t)
 =09=09   ? meter->max_delta_t : (u32)long_delta_ms;

 =09/* Update meter statistics.
@@ -645,7 +645,7 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_b=
uff *skb,

 =09/* Update all bands and find the one hit with the highest rate. */
 =09for (i =3D 0; i < meter->n_bands; ++i) {
-=09=09long long int max_bucket_size;
+=09=09long long max_bucket_size;

 =09=09band =3D &meter->bands[i];
 =09=09max_bucket_size =3D band->burst_size * 1000LL;
--
2.35.3


