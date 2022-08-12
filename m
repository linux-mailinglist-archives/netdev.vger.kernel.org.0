Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC32591127
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 15:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbiHLNFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 09:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238911AbiHLNFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 09:05:01 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A8B25286;
        Fri, 12 Aug 2022 06:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1660309494;
        bh=06l3Wte8wdiSSGj0aHo67hrlpwYHCPc676SVq7b2IrY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=dMS/7m44xvqdOCQXeH0xV2GlkEj3lK/uJxPWJ5qHdLzsgJVu43a3D7mV4RAbCdZVf
         sSobltOLkcEl3e0HFU9A3I7Gx2TpPlzGMyKDO+lJFMjhlofscqQ2PvynoBCA+HknVh
         uixn45kaOpYJ6WIgw4aWicwmQtfLGljk0qnpbuuw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from rechner-desktop.digi.box ([155.133.221.219]) by mail.gmx.net
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1M8ygY-1oGRvc0uc2-0064WZ; Fri, 12 Aug 2022 15:04:54 +0200
From:   Stefan Mahr <dac922@gmx.de>
To:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Stefan Mahr <dac922@gmx.de>
Subject: [PATCH] net: sfp: reset fault retry counter on successful reinitialisation
Date:   Fri, 12 Aug 2022 15:04:38 +0200
Message-Id: <20220812130438.140434-1-dac922@gmx.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:GYNukLpfifw2ESKUJ/NQQnqdpgNA3p4JJWk8ULJJzBtfIKmv4JM
 gTFX0xnVYG7GXwdInCammt8smr4z6yL5BOGubEAFtmJifLCDyzP5hIWnbyFDePP7yIbIrpq
 p4nGlsUAMu/DJ82Fvs1huMTw/CwBH4Yk55bM9hvV1WRIWLj3DAw0kVZPnCUnlHp1xLPHSgv
 OwPGtce8q10yfZBnFSrZg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:MgvpOeo0Cc4=:urU2W4Vn84GiGVRf7IbFeY
 T4Gnmk6I7mNIuXkw8u/XQ3hHb0rvNMJoGP/MGpMUkQGB29U8UlKfyiu5vxTXHWn/YKeegZ4Xk
 5ZBieWsBwgikqfiL//k301igGSvQ7tfG64sDvLTm33jC+4UzlCScg6Xyn7LOIuxO6N1G1Ljev
 CxPaWB6kqmMBilpDB4RkDgaHnSjuxfOdyUwhMsoGXiT1K3CD9CpZhYd/WFHogdMX/oDaUQQ5M
 2Y5XXoi9jhUWDbVSvRuLiSqe5GkVfRqarQfNVbMb5cXHCej8t5pYFiBnvChU23LoTDBwvXqM3
 4Yl14Hz3t+8YGIfazD4u9pZQ552OZnT9tmm2CQNxsm6sEJStDnw9FaQL96ilWWFJH7+kgPwIS
 184UVhNyHEujaqKfoF8N+VbhKo2SQ0CrmGRrWiQr8K8AryLc4iz+5l0V8sEw0RB/Lwp3pRDXk
 wi127fA8F3mcameuI+TfjLKjwNJ+96gwhWhfO3Ed8o3ICkgG3PQR7QXl/1mR45+YOPVUJNYF1
 fqj+0b1mtKTavgZFRxblk1q4s3bQUTdFWxa03qAgJhLRclV2MhxxDkenQVQ3O6PSxNAXv8V0w
 7lm3pKkwTD6izJkYJ0O6pbKFzxzhCF0qsHnbQKwl304uwOW605SS5S8E55pyj5/pZVmdSTmuG
 uEZgV8RQ0nyEcOlUC9Jxn6t0U+/2bqzy+SPUSFvvwMOyJklpZ24W2u3FlHqSa7YlosWv74t0p
 /FgeJHBGCYM32o+tlGYXjULLOfdI7yhGPuRE4I1u+LWNP1Ik2p93rWN6wg/Itv7C1dM0g3is4
 RMmRZ1Sm7dppbI08APTY/Jy4RPlkDr2RyB5QnXgEbCyMKYPMPX6QuLEGHsIv5n3BOFajjBsi7
 adrIIkq/Cv7wT3KLPxH16sG1YjmRdOZyKg6Jr5tlMmfrduKGEPyDmIfLR+1GMoxUtBe7gpB7T
 i8sOosgiPHJtjSXN1hUV3cPlx0o/AbmPNkp7LCXoZg9ZozK/mrlg4PrbMfueA4wVRkG0Y7F2k
 P/wLUFOvOsqpBmt+3LxIhyvhv1AD8oYB4ue5m3rVSkiqs+/bz9iz/7Gph1u58ikKHGhFXAByQ
 M4ZVhU/DagXh2jrqBr5SDZ35o7kyaGk7+4sapFuw+BUGqnymrlIbmOI5w==
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch resets the fault retry counter to the default value, if the
module reinitialisation was successful. Otherwise without resetting
the counter, five (N_FAULT/N_FAULT_INIT) single TX_FAULT events will
deactivate the module persistently.

In case the reinitialisation was not successful after five retries,
the module is still being deactivated.

Signed-off-by: Stefan Mahr <dac922@gmx.de>
=2D--
 drivers/net/phy/sfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 63f90fe9a4d2..a8d7a713222a 100644
=2D-- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2263,6 +2263,9 @@ static void sfp_sm_main(struct sfp *sfp, unsigned in=
t event)
 		} else if (event =3D=3D SFP_E_TIMEOUT || event =3D=3D SFP_E_TX_CLEAR) {
 			dev_info(sfp->dev, "module transmit fault recovered\n");
 			sfp_sm_link_check_los(sfp);
+
+			/* Reset the fault retry count */
+			sfp->sm_fault_retries =3D N_FAULT;
 		}
 		break;

=2D-
2.25.1

