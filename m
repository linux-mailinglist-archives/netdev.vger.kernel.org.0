Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7426D68BB88
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjBFLdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjBFLdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:33:11 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241E710271;
        Mon,  6 Feb 2023 03:33:08 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pOydw-007zjD-3q; Mon, 06 Feb 2023 18:22:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Feb 2023 18:22:36 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 06 Feb 2023 18:22:36 +0800
Subject: [PATCH 12/17] net: macsec: Remove completion function scaffolding
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tyler Hicks <code@tyhicks.com>, ecryptfs@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Message-Id: <E1pOydw-007zjD-3q@formenos.hmeau.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes the temporary scaffolding now that the comletion
function signature has been converted.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/net/macsec.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index b7d9d487ccd2..becb04123d3e 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -528,9 +528,9 @@ static void count_tx(struct net_device *dev, int ret, int len)
 	}
 }
 
-static void macsec_encrypt_done(crypto_completion_data_t *data, int err)
+static void macsec_encrypt_done(void *data, int err)
 {
-	struct sk_buff *skb = crypto_get_completion_data(data);
+	struct sk_buff *skb = data;
 	struct net_device *dev = skb->dev;
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct macsec_tx_sa *sa = macsec_skb_cb(skb)->tx_sa;
@@ -835,9 +835,9 @@ static void count_rx(struct net_device *dev, int len)
 	u64_stats_update_end(&stats->syncp);
 }
 
-static void macsec_decrypt_done(crypto_completion_data_t *data, int err)
+static void macsec_decrypt_done(void *data, int err)
 {
-	struct sk_buff *skb = crypto_get_completion_data(data);
+	struct sk_buff *skb = data;
 	struct net_device *dev = skb->dev;
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct macsec_rx_sa *rx_sa = macsec_skb_cb(skb)->rx_sa;
