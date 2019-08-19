Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5240891E81
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 10:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfHSIAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 04:00:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44775 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfHSIAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 04:00:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id c81so696503pfc.11;
        Mon, 19 Aug 2019 01:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SN1EjsM05rbQs6yQJOUkAPdH7YfxCUqGgbGrEM18uAI=;
        b=mM50C017tupULJMY26m/WHdCJBMnq6eXzC/m6JCfWbWHM2cWU94F0TyvXn4mQ2athS
         15ZyaOdkHWxiM6ok8uWmlTqi+u0bIMHgWlWyM8aMgAS2p9wIX+itqtB6Dov46p5EdZls
         7tx5t7JaWmn930LQ9vCv4oIxxsKfwUg6P+z9tHGmv2NkB3PZ1m8tawC3RFJskpk/lksm
         Wa2swCdov27XbV+ClppDrla1v4/3rQ3kbjKOgvRlYGi1bADEuSOAjJ0MgwStZ9/0SIrB
         pm6fS3VQws6oR9vg0ZWC2O7yrzGgbQ6kTD71/0FSijR9IgVk3dGDMlFNObdeZg3LzQT3
         2jmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SN1EjsM05rbQs6yQJOUkAPdH7YfxCUqGgbGrEM18uAI=;
        b=e8UpJj6OvuvZRJlnTkj41Pekwiv7JhSeW87geKpFHmE16RjxJOy7m7OT2l0idoHZYv
         /CjwZfICdUD3/O2KtqUgU6evmsmVRnzDV777EipC8ETGoMlBGMsNqmE4TpzBed56kuKu
         q05SZk05ndT7DPPxwk+7TickVCGMoDGHMjunt6eqeQLrPZ1pFsG6phIKGEOUP+WJBcoW
         Wa0YS/6aUEtk/FsnnKBAOieZmzA1VpRqtvBtrZVcx/lKlwYjHg1p4XzD8WCAn1XYK5U0
         odDQBPOhc+FxIUtMPPxqs1o52px1ZZ/NPfKXd16mTftcwTc6DLbBV4/WgRL0mMUojnMk
         Xgew==
X-Gm-Message-State: APjAAAWn+XC1CQJPeJ44nNBxS2m/775svQm2zhYRzbWdl97Y7+3x26y+
        8TlUmcJI9bVZzn7jude7sNU=
X-Google-Smtp-Source: APXvYqzoxH6iIbJqrff6Vj2LDnxnKTdek1lg9DPnvO3PuR/jeDYdaEEcI+JwDCcbd6TbD7oRa2yeWw==
X-Received: by 2002:a63:d84e:: with SMTP id k14mr18779881pgj.234.1566201630653;
        Mon, 19 Aug 2019 01:00:30 -0700 (PDT)
Received: from localhost.localdomain ([110.225.16.165])
        by smtp.gmail.com with ESMTPSA id f7sm14238514pfd.43.2019.08.19.01.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 01:00:29 -0700 (PDT)
From:   Nishka Dasgupta <nishkadg.linux@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Cc:     Nishka Dasgupta <nishkadg.linux@gmail.com>
Subject: [PATCH] can: peak_pci: Make structure peak_pciec_i2c_bit_ops constant
Date:   Mon, 19 Aug 2019 13:30:18 +0530
Message-Id: <20190819080018.2155-1-nishkadg.linux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Static structure peak_pciec_i2c_bit_ops, of type i2c_algo_bit_data, is
not used except to be copied into another variable. Hence make it const
to protect it from modification.
Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
---
 drivers/net/can/sja1000/peak_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/sja1000/peak_pci.c b/drivers/net/can/sja1000/peak_pci.c
index 68366d57916c..8c0244f51059 100644
--- a/drivers/net/can/sja1000/peak_pci.c
+++ b/drivers/net/can/sja1000/peak_pci.c
@@ -417,7 +417,7 @@ static void peak_pciec_write_reg(const struct sja1000_priv *priv,
 	peak_pci_write_reg(priv, port, val);
 }
 
-static struct i2c_algo_bit_data peak_pciec_i2c_bit_ops = {
+static const struct i2c_algo_bit_data peak_pciec_i2c_bit_ops = {
 	.setsda	= pita_setsda,
 	.setscl	= pita_setscl,
 	.getsda	= pita_getsda,
-- 
2.19.1

