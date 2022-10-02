Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8045F212A
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 05:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJBDYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 23:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJBDYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 23:24:36 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B784357FC
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 20:24:32 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b23so7482463pfp.9
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 20:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=fSR9tr3IwX1tkbkpVY+1zw1bk2cLXOmKwUnSwhQ0SuM=;
        b=AtP7T+amBhMrHBwXqDoBTJFPt4t7OM5OK+yhYgO44yKlueXqMfmhk2Kl8qTVVv1Ud8
         vbTyd52E0Ro1e/26wi0Z7WDgCBBO4LGQRH6VaSGzZtF2mAZDz+hajyKKinndGUbXRaYO
         9ILZd4u2D9hw/vLVCQ5ZN+c/BsJvXdcIuLrno=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=fSR9tr3IwX1tkbkpVY+1zw1bk2cLXOmKwUnSwhQ0SuM=;
        b=zgB68P/i72vNvFp9B0kLIdPBrgURRHxYgMjeoNUrYOvId0vIDhe55h/PN8oTYGjlzu
         2+AJrMEILRPwuMJUvxlP4dC2hO/+I+8uqJOe1Az/G/MS1ptW5s3n/xVRSdQlQN/4yH06
         V0huLptGclyua5bD26tP7Oa34cPE62ZVqMwgV5E5Je+HBYrtJVuvpQcUMFpYvgw4EtPd
         lqbJc2Hwm+AmCYQtMe/DceErhoEZL60fbp9EHeKbSTW47Bclk4XSDwwZBRuW5TZQCSBi
         XN8MRdc2AokUxpAPV5Aim93Kn7lqM3NQrX7DNFcntMZny/YQcIUwB51tYvAL4X6zLc/D
         +/vQ==
X-Gm-Message-State: ACrzQf0YfsmoIsNCwAwBFBMFMMKW6noCf6uPoBbNgp4HzE5sVnBq1/Y2
        43aT78e2EKaWxbostts9rKrE6Q==
X-Google-Smtp-Source: AMsMyM4y8n3hAlwbtzsmaWU4vQ+stg6atlQ1aejG9mePtQ+mzUQ1AAhK6WZspOl3jzNc6qfJQ20u/A==
X-Received: by 2002:a63:2221:0:b0:43b:f4a3:80cc with SMTP id i33-20020a632221000000b0043bf4a380ccmr13647354pgi.367.1664681071729;
        Sat, 01 Oct 2022 20:24:31 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p5-20020a170902e74500b00176ab6a0d5fsm4692975plf.54.2022.10.01.20.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 20:24:31 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Simon Kelley <simon@thekelleys.org.uk>
Cc:     Kees Cook <keescook@chromium.org>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: [PATCH] wifi: atmel: Avoid clashing function prototypes
Date:   Sat,  1 Oct 2022 20:24:28 -0700
Message-Id: <20221002032428.4091540-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=16307; h=from:subject; bh=jI9bh0H+4r82lB7BibHcFC61+KWxOWMNoe73/Orrzfc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjOQRsnL4GRjC2rE98Ed/HWfwp6IFzpSqo6JyzTtxI n9K/uwSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYzkEbAAKCRCJcvTf3G3AJlcVD/ 4j+i8KudB7xs4a2P+w//yEV05pHV7yZGf4/ZSVXy09uwSM7KQxAVkNIDJ+wun/A16TZlpJRaoMyp4L WjwvTdyq99AXUPUgLmPPw5hh49xe16UEeTtgkrahMSTAtt4T442xT+JycSIxDODksDWmGtHRW9NkLb 8G/INMjHU9dFq4Vvhmomd1K6sB2yoPd+d26e8TWep2hiD7C1/kTPW1m37ddkuCu8ZfUoqJiroPJ7u1 ylo5OCAVBHaetkHN4VO5VXi2bsYxMooZjlCq8n7RVadzd459kDbuqSolwcMBuPhxGZYNTgSH2bzd1Y LGpKcE3e1zoIP1bsi4V0oqiFBF3ooTZXRzd0vECS0mhOKc58Tm743GpClroROptn1fBAYRT8AfGqrg 8c6hy00NnhmageP2HjxdNC7XpBB32YJ6fukqPf65mQGz81xOB5Q0tS98HfJL1cnGtTSnFDYoSXY4SO 7v15s6DGNW7aOZoPUaOmogMKJ0gyeAKidh5oPU4AFAwNfq9pG4dR8+k3iF2GaACt53cs/WboyJOIir 8A5KBLRbHrtQGsVO//ztFWyg+fSOQ2nPOH3QMoL6A5X4hcQWVR3anhwkoCFFJ8PNzP7VDVycPCavQc HzKkTop9ydBaL9ni/V7/FomcYU34tYMnnaQ+IK+8H5QbWBO7uKEfvXVnZlyg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When built with Control Flow Integrity, function prototypes between
caller and function declaration must match. These mismatches are visible
at compile time with the new -Wcast-function-type-strict in Clang[1].

Of the 1549 warnings found, 188 come from the atmel driver. For example:

drivers/net/wireless/atmel/atmel.c:2518:2: warning: cast from 'int (*)(struct net_device *, struct iw_request_info *, void *, char *)' to 'iw_handler' (aka 'int (*)(struct net_device *, struct iw_request_info *, union iwreq_data *, char *)') converts to incompatible function type [-Wcast-function-type-strict]
        (iw_handler) atmel_config_commit,       /* SIOCSIWCOMMIT */
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The atmel Wireless Extension handler callbacks (iw_handler) use a union
for the data argument. Actually use the union and perform explicit
member selection in the function body instead of having a function
prototype mismatch. There are no resulting binary differences.

This patch is a cleanup based on Brad Spengler/PaX Team's modifications
to the atmel driver in their last public patch of grsecurity/PaX based
on my understanding of the code. Changes or omissions from the original
code are mine and don't reflect the original grsecurity/PaX code.

[1] https://reviews.llvm.org/D134831

Cc: Simon Kelley <simon@thekelleys.org.uk>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/atmel/atmel.c | 164 ++++++++++++++---------------
 1 file changed, 80 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index 0361c8eb2008..7823220686e6 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -1643,9 +1643,10 @@ EXPORT_SYMBOL(stop_atmel_card);
 
 static int atmel_set_essid(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_point *dwrq,
+			   union iwreq_data *wrqu,
 			   char *extra)
 {
+	struct iw_point *dwrq = &wrqu->essid;
 	struct atmel_private *priv = netdev_priv(dev);
 
 	/* Check if we asked for `any' */
@@ -1671,9 +1672,10 @@ static int atmel_set_essid(struct net_device *dev,
 
 static int atmel_get_essid(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_point *dwrq,
+			   union iwreq_data *wrqu,
 			   char *extra)
 {
+	struct iw_point *dwrq = &wrqu->essid;
 	struct atmel_private *priv = netdev_priv(dev);
 
 	/* Get the current SSID */
@@ -1692,9 +1694,10 @@ static int atmel_get_essid(struct net_device *dev,
 
 static int atmel_get_wap(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct sockaddr *awrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct sockaddr *awrq = &wrqu->ap_addr;
 	struct atmel_private *priv = netdev_priv(dev);
 	memcpy(awrq->sa_data, priv->CurrentBSSID, ETH_ALEN);
 	awrq->sa_family = ARPHRD_ETHER;
@@ -1704,9 +1707,10 @@ static int atmel_get_wap(struct net_device *dev,
 
 static int atmel_set_encode(struct net_device *dev,
 			    struct iw_request_info *info,
-			    struct iw_point *dwrq,
+			    union iwreq_data *wrqu,
 			    char *extra)
 {
+	struct iw_point *dwrq = &wrqu->encoding;
 	struct atmel_private *priv = netdev_priv(dev);
 
 	/* Basic checking: do we have a key to set ?
@@ -1793,9 +1797,10 @@ static int atmel_set_encode(struct net_device *dev,
 
 static int atmel_get_encode(struct net_device *dev,
 			    struct iw_request_info *info,
-			    struct iw_point *dwrq,
+			    union iwreq_data *wrqu,
 			    char *extra)
 {
+	struct iw_point *dwrq = &wrqu->encoding;
 	struct atmel_private *priv = netdev_priv(dev);
 	int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
 
@@ -2003,18 +2008,19 @@ static int atmel_get_auth(struct net_device *dev,
 
 static int atmel_get_name(struct net_device *dev,
 			  struct iw_request_info *info,
-			  char *cwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
-	strcpy(cwrq, "IEEE 802.11-DS");
+	strcpy(wrqu->name, "IEEE 802.11-DS");
 	return 0;
 }
 
 static int atmel_set_rate(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_param *vwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	struct iw_param *vwrq = &wrqu->bitrate;
 	struct atmel_private *priv = netdev_priv(dev);
 
 	if (vwrq->fixed == 0) {
@@ -2053,9 +2059,10 @@ static int atmel_set_rate(struct net_device *dev,
 
 static int atmel_set_mode(struct net_device *dev,
 			  struct iw_request_info *info,
-			  __u32 *uwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	__u32 *uwrq = &wrqu->mode;
 	struct atmel_private *priv = netdev_priv(dev);
 
 	if (*uwrq != IW_MODE_ADHOC && *uwrq != IW_MODE_INFRA)
@@ -2067,9 +2074,10 @@ static int atmel_set_mode(struct net_device *dev,
 
 static int atmel_get_mode(struct net_device *dev,
 			  struct iw_request_info *info,
-			  __u32 *uwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	__u32 *uwrq = &wrqu->mode;
 	struct atmel_private *priv = netdev_priv(dev);
 
 	*uwrq = priv->operating_mode;
@@ -2078,9 +2086,10 @@ static int atmel_get_mode(struct net_device *dev,
 
 static int atmel_get_rate(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_param *vwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct iw_param *vwrq = &wrqu->bitrate;
 	struct atmel_private *priv = netdev_priv(dev);
 
 	if (priv->auto_tx_rate) {
@@ -2108,9 +2117,10 @@ static int atmel_get_rate(struct net_device *dev,
 
 static int atmel_set_power(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_param *vwrq,
+			   union iwreq_data *wrqu,
 			   char *extra)
 {
+	struct iw_param *vwrq = &wrqu->power;
 	struct atmel_private *priv = netdev_priv(dev);
 	priv->power_mode = vwrq->disabled ? 0 : 1;
 	return -EINPROGRESS;
@@ -2118,9 +2128,10 @@ static int atmel_set_power(struct net_device *dev,
 
 static int atmel_get_power(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_param *vwrq,
+			   union iwreq_data *wrqu,
 			   char *extra)
 {
+	struct iw_param *vwrq = &wrqu->power;
 	struct atmel_private *priv = netdev_priv(dev);
 	vwrq->disabled = priv->power_mode ? 0 : 1;
 	vwrq->flags = IW_POWER_ON;
@@ -2129,9 +2140,10 @@ static int atmel_get_power(struct net_device *dev,
 
 static int atmel_set_retry(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_param *vwrq,
+			   union iwreq_data *wrqu,
 			   char *extra)
 {
+	struct iw_param *vwrq = &wrqu->retry;
 	struct atmel_private *priv = netdev_priv(dev);
 
 	if (!vwrq->disabled && (vwrq->flags & IW_RETRY_LIMIT)) {
@@ -2152,9 +2164,10 @@ static int atmel_set_retry(struct net_device *dev,
 
 static int atmel_get_retry(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_param *vwrq,
+			   union iwreq_data *wrqu,
 			   char *extra)
 {
+	struct iw_param *vwrq = &wrqu->retry;
 	struct atmel_private *priv = netdev_priv(dev);
 
 	vwrq->disabled = 0;      /* Can't be disabled */
@@ -2175,9 +2188,10 @@ static int atmel_get_retry(struct net_device *dev,
 
 static int atmel_set_rts(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_param *vwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct iw_param *vwrq = &wrqu->rts;
 	struct atmel_private *priv = netdev_priv(dev);
 	int rthr = vwrq->value;
 
@@ -2193,9 +2207,10 @@ static int atmel_set_rts(struct net_device *dev,
 
 static int atmel_get_rts(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_param *vwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct iw_param *vwrq = &wrqu->rts;
 	struct atmel_private *priv = netdev_priv(dev);
 
 	vwrq->value = priv->rts_threshold;
@@ -2207,9 +2222,10 @@ static int atmel_get_rts(struct net_device *dev,
 
 static int atmel_set_frag(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_param *vwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	struct iw_param *vwrq = &wrqu->frag;
 	struct atmel_private *priv = netdev_priv(dev);
 	int fthr = vwrq->value;
 
@@ -2226,9 +2242,10 @@ static int atmel_set_frag(struct net_device *dev,
 
 static int atmel_get_frag(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_param *vwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	struct iw_param *vwrq = &wrqu->frag;
 	struct atmel_private *priv = netdev_priv(dev);
 
 	vwrq->value = priv->frag_threshold;
@@ -2240,9 +2257,10 @@ static int atmel_get_frag(struct net_device *dev,
 
 static int atmel_set_freq(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_freq *fwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	struct iw_freq *fwrq = &wrqu->freq;
 	struct atmel_private *priv = netdev_priv(dev);
 	int rc = -EINPROGRESS;		/* Call commit handler */
 
@@ -2270,9 +2288,10 @@ static int atmel_set_freq(struct net_device *dev,
 
 static int atmel_get_freq(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_freq *fwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	struct iw_freq *fwrq = &wrqu->freq;
 	struct atmel_private *priv = netdev_priv(dev);
 
 	fwrq->m = priv->channel;
@@ -2282,7 +2301,7 @@ static int atmel_get_freq(struct net_device *dev,
 
 static int atmel_set_scan(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_point *dwrq,
+			  union iwreq_data *dwrq,
 			  char *extra)
 {
 	struct atmel_private *priv = netdev_priv(dev);
@@ -2320,9 +2339,10 @@ static int atmel_set_scan(struct net_device *dev,
 
 static int atmel_get_scan(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_point *dwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	struct iw_point *dwrq = &wrqu->data;
 	struct atmel_private *priv = netdev_priv(dev);
 	int i;
 	char *current_ev = extra;
@@ -2391,9 +2411,10 @@ static int atmel_get_scan(struct net_device *dev,
 
 static int atmel_get_range(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_point *dwrq,
+			   union iwreq_data *wrqu,
 			   char *extra)
 {
+	struct iw_point *dwrq = &wrqu->data;
 	struct atmel_private *priv = netdev_priv(dev);
 	struct iw_range *range = (struct iw_range *) extra;
 	int k, i, j;
@@ -2465,9 +2486,10 @@ static int atmel_get_range(struct net_device *dev,
 
 static int atmel_set_wap(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct sockaddr *awrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct sockaddr *awrq = &wrqu->ap_addr;
 	struct atmel_private *priv = netdev_priv(dev);
 	int i;
 	static const u8 any[] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
@@ -2507,7 +2529,7 @@ static int atmel_set_wap(struct net_device *dev,
 
 static int atmel_config_commit(struct net_device *dev,
 			       struct iw_request_info *info,	/* NULL */
-			       void *zwrq,			/* NULL */
+			       union iwreq_data *zwrq,		/* NULL */
 			       char *extra)			/* NULL */
 {
 	return atmel_open(dev);
@@ -2515,66 +2537,40 @@ static int atmel_config_commit(struct net_device *dev,
 
 static const iw_handler atmel_handler[] =
 {
-	(iw_handler) atmel_config_commit,	/* SIOCSIWCOMMIT */
-	(iw_handler) atmel_get_name,		/* SIOCGIWNAME */
-	(iw_handler) NULL,			/* SIOCSIWNWID */
-	(iw_handler) NULL,			/* SIOCGIWNWID */
-	(iw_handler) atmel_set_freq,		/* SIOCSIWFREQ */
-	(iw_handler) atmel_get_freq,		/* SIOCGIWFREQ */
-	(iw_handler) atmel_set_mode,		/* SIOCSIWMODE */
-	(iw_handler) atmel_get_mode,		/* SIOCGIWMODE */
-	(iw_handler) NULL,			/* SIOCSIWSENS */
-	(iw_handler) NULL,			/* SIOCGIWSENS */
-	(iw_handler) NULL,			/* SIOCSIWRANGE */
-	(iw_handler) atmel_get_range,           /* SIOCGIWRANGE */
-	(iw_handler) NULL,			/* SIOCSIWPRIV */
-	(iw_handler) NULL,			/* SIOCGIWPRIV */
-	(iw_handler) NULL,			/* SIOCSIWSTATS */
-	(iw_handler) NULL,			/* SIOCGIWSTATS */
-	(iw_handler) NULL,			/* SIOCSIWSPY */
-	(iw_handler) NULL,			/* SIOCGIWSPY */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) atmel_set_wap,		/* SIOCSIWAP */
-	(iw_handler) atmel_get_wap,		/* SIOCGIWAP */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) NULL,			/* SIOCGIWAPLIST */
-	(iw_handler) atmel_set_scan,		/* SIOCSIWSCAN */
-	(iw_handler) atmel_get_scan,		/* SIOCGIWSCAN */
-	(iw_handler) atmel_set_essid,		/* SIOCSIWESSID */
-	(iw_handler) atmel_get_essid,		/* SIOCGIWESSID */
-	(iw_handler) NULL,			/* SIOCSIWNICKN */
-	(iw_handler) NULL,			/* SIOCGIWNICKN */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) atmel_set_rate,		/* SIOCSIWRATE */
-	(iw_handler) atmel_get_rate,		/* SIOCGIWRATE */
-	(iw_handler) atmel_set_rts,		/* SIOCSIWRTS */
-	(iw_handler) atmel_get_rts,		/* SIOCGIWRTS */
-	(iw_handler) atmel_set_frag,		/* SIOCSIWFRAG */
-	(iw_handler) atmel_get_frag,		/* SIOCGIWFRAG */
-	(iw_handler) NULL,			/* SIOCSIWTXPOW */
-	(iw_handler) NULL,			/* SIOCGIWTXPOW */
-	(iw_handler) atmel_set_retry,		/* SIOCSIWRETRY */
-	(iw_handler) atmel_get_retry,		/* SIOCGIWRETRY */
-	(iw_handler) atmel_set_encode,		/* SIOCSIWENCODE */
-	(iw_handler) atmel_get_encode,		/* SIOCGIWENCODE */
-	(iw_handler) atmel_set_power,		/* SIOCSIWPOWER */
-	(iw_handler) atmel_get_power,		/* SIOCGIWPOWER */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) NULL,			/* SIOCSIWGENIE */
-	(iw_handler) NULL,			/* SIOCGIWGENIE */
-	(iw_handler) atmel_set_auth,		/* SIOCSIWAUTH */
-	(iw_handler) atmel_get_auth,		/* SIOCGIWAUTH */
-	(iw_handler) atmel_set_encodeext,	/* SIOCSIWENCODEEXT */
-	(iw_handler) atmel_get_encodeext,	/* SIOCGIWENCODEEXT */
-	(iw_handler) NULL,			/* SIOCSIWPMKSA */
+	IW_HANDLER(SIOCSIWCOMMIT,	atmel_config_commit),
+	IW_HANDLER(SIOCGIWNAME,		atmel_get_name),
+	IW_HANDLER(SIOCSIWFREQ,		atmel_set_freq),
+	IW_HANDLER(SIOCGIWFREQ,		atmel_get_freq),
+	IW_HANDLER(SIOCSIWMODE,		atmel_set_mode),
+	IW_HANDLER(SIOCGIWMODE,		atmel_get_mode),
+	IW_HANDLER(SIOCGIWRANGE,	atmel_get_range),
+	IW_HANDLER(SIOCSIWAP,		atmel_set_wap),
+	IW_HANDLER(SIOCGIWAP,		atmel_get_wap),
+	IW_HANDLER(SIOCSIWSCAN,		atmel_set_scan),
+	IW_HANDLER(SIOCGIWSCAN,		atmel_get_scan),
+	IW_HANDLER(SIOCSIWESSID,	atmel_set_essid),
+	IW_HANDLER(SIOCGIWESSID,	atmel_get_essid),
+	IW_HANDLER(SIOCSIWRATE,		atmel_set_rate),
+	IW_HANDLER(SIOCGIWRATE,		atmel_get_rate),
+	IW_HANDLER(SIOCSIWRTS,		atmel_set_rts),
+	IW_HANDLER(SIOCGIWRTS,		atmel_get_rts),
+	IW_HANDLER(SIOCSIWFRAG,		atmel_set_frag),
+	IW_HANDLER(SIOCGIWFRAG,		atmel_get_frag),
+	IW_HANDLER(SIOCSIWRETRY,	atmel_set_retry),
+	IW_HANDLER(SIOCGIWRETRY,	atmel_get_retry),
+	IW_HANDLER(SIOCSIWENCODE,	atmel_set_encode),
+	IW_HANDLER(SIOCGIWENCODE,	atmel_get_encode),
+	IW_HANDLER(SIOCSIWPOWER,	atmel_set_power),
+	IW_HANDLER(SIOCGIWPOWER,	atmel_get_power),
+	IW_HANDLER(SIOCSIWAUTH,		atmel_set_auth),
+	IW_HANDLER(SIOCGIWAUTH,		atmel_get_auth),
+	IW_HANDLER(SIOCSIWENCODEEXT,	atmel_set_encodeext),
+	IW_HANDLER(SIOCGIWENCODEEXT,	atmel_get_encodeext),
 };
 
 static const iw_handler atmel_private_handler[] =
 {
-	NULL,				/* SIOCIWFIRSTPRIV */
+	IW_HANDLER(SIOCIWFIRSTPRIV,	NULL),
 };
 
 struct atmel_priv_ioctl {
@@ -2614,8 +2610,8 @@ static const struct iw_handler_def atmel_handler_def = {
 	.num_standard	= ARRAY_SIZE(atmel_handler),
 	.num_private	= ARRAY_SIZE(atmel_private_handler),
 	.num_private_args = ARRAY_SIZE(atmel_private_args),
-	.standard	= (iw_handler *) atmel_handler,
-	.private	= (iw_handler *) atmel_private_handler,
+	.standard	= atmel_handler,
+	.private	= atmel_private_handler,
 	.private_args	= (struct iw_priv_args *) atmel_private_args,
 	.get_wireless_stats = atmel_get_wireless_stats
 };
-- 
2.34.1

