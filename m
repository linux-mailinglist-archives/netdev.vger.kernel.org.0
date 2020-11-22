Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E812BFD10
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 00:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgKVXkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 18:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgKVXki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 18:40:38 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D201C0613CF;
        Sun, 22 Nov 2020 15:40:38 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id r18so1308296ljc.2;
        Sun, 22 Nov 2020 15:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LM91gP2nIid4DUflEoBR5rOvvtGclV/kTeDrsZg/vUA=;
        b=BQawZD/8wmbS8d3v9C3cInKhR9jRFF63UaGGLGQuz8y+gCwiwGfHBNwJL6giWLgSsz
         zbWMvBzMGxzzYkFSQaD908eVXo1uB+tTnYO+Ur4khoBRDoEeu3YJAMHGdQ8RDlHVgJM+
         ml4TVI9QxbA0Ntiy13ptslFw3SzPKRonqHTaqi7S2HkJzy7OwRO1WXUjH58itgc/FXrG
         CyyTkNXRPatqDtbmKhzZlzyDZSGmXJm4ShB94gJF+PulnA9M4SfiQMuCYy2Df26dtYNA
         e15239GjQ6mCN71rD2M6YVx5WQ+ps3zzInX5WrF3zhpvDGWqUYqmhU6fI+1KS99aqkip
         01sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LM91gP2nIid4DUflEoBR5rOvvtGclV/kTeDrsZg/vUA=;
        b=UKZ2m8WHZcXZuigkFuLVHMNBO6fqmDFcaGJL3Hn3lzWdRp+xMrGhNqygA1Ct1UHZpY
         MyU+5+hGpQ5xFsUod9BJPF2tn9sxWBjfx8DBisTd4DRFzKjap6onLzf8y9qOEikYR/e7
         AsMoQRR9FazKGiieG3glHb90QjzPkVqOrke4NZ+broIosf3L1q5ebuP98q0vgz+KDJzE
         R0ryjyYZtirqHeJpkCy1ZjEQ5AdpBjK6+746hlVHetTu9FjsifTfd3MReY+q7OowaQbr
         vtfmwPF8EPR/o2WcJqlhFuOONcLB6CR5O+ucl1vCJ/wM34RcZorXZswruUx1271gXc0a
         Hrfw==
X-Gm-Message-State: AOAM53159PuzI8TRH3QhhQrnqOKcY3fCcMqQAioXxvxbFciOztZUQsI/
        2L76q6Ouz4YP80k9bbKPkvE=
X-Google-Smtp-Source: ABdhPJxBuZE6wVQydaHsAVsrQ/Q8hA1TfcwCG2pmtjd/Dbr+z7/0FUYmJnxMD8Rxtyzj7NouCJZduQ==
X-Received: by 2002:a2e:88c6:: with SMTP id a6mr9691453ljk.390.1606088436979;
        Sun, 22 Nov 2020 15:40:36 -0800 (PST)
Received: from localhost.localdomain (h-158-174-22-6.NA.cust.bahnhof.se. [158.174.22.6])
        by smtp.gmail.com with ESMTPSA id q13sm1178173lfk.147.2020.11.22.15.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 15:40:36 -0800 (PST)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alex Elder <elder@kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH net-next 1/2] soc: qcom: ipa: Constify static qmi structs
Date:   Mon, 23 Nov 2020 00:40:30 +0100
Message-Id: <20201122234031.33432-2-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201122234031.33432-1-rikard.falkeborn@gmail.com>
References: <20201122234031.33432-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are only used as input arguments to qmi_handle_init() which
accepts const pointers to both qmi_ops and qmi_msg_handler. Make them
const to allow the compiler to put them in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/net/ipa/ipa_qmi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index 5090f0f923ad..d2c3f273c233 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -168,7 +168,7 @@ static void ipa_server_bye(struct qmi_handle *qmi, unsigned int node)
 	ipa_qmi->indication_sent = false;
 }
 
-static struct qmi_ops ipa_server_ops = {
+static const struct qmi_ops ipa_server_ops = {
 	.bye		= ipa_server_bye,
 };
 
@@ -234,7 +234,7 @@ static void ipa_server_driver_init_complete(struct qmi_handle *qmi,
 }
 
 /* The server handles two request message types sent by the modem. */
-static struct qmi_msg_handler ipa_server_msg_handlers[] = {
+static const struct qmi_msg_handler ipa_server_msg_handlers[] = {
 	{
 		.type		= QMI_REQUEST,
 		.msg_id		= IPA_QMI_INDICATION_REGISTER,
@@ -261,7 +261,7 @@ static void ipa_client_init_driver(struct qmi_handle *qmi,
 }
 
 /* The client handles one response message type sent by the modem. */
-static struct qmi_msg_handler ipa_client_msg_handlers[] = {
+static const struct qmi_msg_handler ipa_client_msg_handlers[] = {
 	{
 		.type		= QMI_RESPONSE,
 		.msg_id		= IPA_QMI_INIT_DRIVER,
@@ -463,7 +463,7 @@ ipa_client_new_server(struct qmi_handle *qmi, struct qmi_service *svc)
 	return 0;
 }
 
-static struct qmi_ops ipa_client_ops = {
+static const struct qmi_ops ipa_client_ops = {
 	.new_server	= ipa_client_new_server,
 };
 
-- 
2.29.2

